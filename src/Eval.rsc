module Eval

import AST;
import Resolve;
import IO;
/*
 * Implement big-step semantics for QL
 */
 
// NB: Eval may assume the form is type- and name-correct.


// Semantic domain for expressions (values)
data Value
  = vint(int n)
  | vbool(bool b)
  | vstr(str s)
  ;

// The value environment
alias VEnv = map[str name, Value \value];

// Modeling user input
data Input
  = input(str question, Value \value);
  
// produce an environment which for each question has a default value
// (e.g. 0 for int, "" for str etc.)
VEnv initialEnv(AForm f) {
  VEnv env = ();
  for(/question(_, AId param, AType t) := f){
    switch(t){
      case integer(): {env =  env + (param.name: vint(0));}
      case boolean(): {env = env + (param.name: vbool(false));}
      case string(): {env = env + (param.name: vstr(""));}
    }
  };
  for(/compQuestion(_, AId param, AType t, _) := f){
    switch(t){
      case integer(): {env =  env + (param.name: vint(0));}
      case boolean(): {env = env + (param.name: vbool(false));}
      case string(): {env = env + (param.name: vstr(""));}
    }
  };
  return env;
}


// Because of out-of-order use and declaration of questions
// we use the solve primitive in Rascal to find the fixpoint of venv.
VEnv eval(AForm f, Input inp, VEnv venv) {
  return solve (venv) {
    venv = evalOnce(f, inp, venv);
  }
}

VEnv evalOnce(AForm f, Input inp, VEnv venv) {
  for(q <- f.questions){
    venv = eval(q, inp, venv);
    
  }
  return venv; 
}
  // evaluate conditions for branching,
  // evaluate inp and computed questions to return updated VEnv
VEnv eval(AQuestion q, Input inp, VEnv venv) {   
  switch(q) {
    case question(str ques, AId param,_): {
      println("question");
      if("<ques>" == ("\"" + inp.question + "\"")){
        venv[param.name] = inp.\value;
      }
    }
    case compQuestion(str ques, AId param, _, AExpr exp): {
      println("compQuestion");
      if(ques == inp.question){
        venv[param.name] = eval(exp, venv);
      }
    }
    case ifStatement(_, list[AQuestion] questions): {
      println("ifQuestion");
      for(question <- questions){
        venv = eval(question, inp, venv);
      }
    }
    case ifElseStatement(_, list[AQuestion] ifQuestions, list[AQuestion] elseQuestions): {
      println("ifelseQuestion");
      for(question <- ifQuestions){
        venv = eval(question, inp, venv);
      }
      for(question <- elseQuestions){
        venv = eval(question, inp, venv);
      }
    }
    
  }
  
  return venv; 
}

Value eval(AExpr e, VEnv venv) {
  switch (e) {
    case ref(id(str x)): return venv[x];
    case integer(int vali): return vint(vali);
    case boolean(bool valb): return vbool(valb);
    case brackets(AExpr expr): return eval(expr, venv);
    case not(AExpr expr): return vbool(!(eval(expr, venv).b));
    case mult(AExpr left, AExpr right): return vint(eval(left, venv).n * eval(right, venv).n);
    case div(AExpr left, AExpr right):return vint(eval(left, venv).n / eval(right, venv).n);
    case add(AExpr left, AExpr right):return vint(eval(left, venv).n + eval(right, venv).n);
    case subtract(AExpr left, AExpr right):return vint(eval(left, venv).n - eval(right, venv).n);
    case greater(AExpr left, AExpr right):return vbool(eval(left, venv).n > eval(right, venv).n);
    case less(AExpr left, AExpr right):return vbool(eval(left, venv).n < eval(right, venv).n);
    case greq(AExpr left, AExpr right):return vbool(eval(left, venv).n >= eval(right, venv).n);
    case leq(AExpr left, AExpr right):return vbool(eval(left, venv).n <= eval(right, venv).n);
    case neq(AExpr left, AExpr right):return vbool(eval(left, venv).n != eval(right, venv).n);
    case conj(AExpr left, AExpr right):return vbool(eval(left, venv).b && eval(right, venv).b);
    case disj(AExpr left, AExpr right):return vbool(eval(left, venv).b || eval(right, venv).b);
    
    default: throw "Unsupported expression <e>";
  }
}
