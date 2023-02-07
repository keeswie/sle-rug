module Check

import AST;
import Resolve;
import Message; // see standard library
import IO;

data Type
  = tint()
  | tbool()
  | tstr()
  | tunknown()
  ;

// the type environment consisting of defined questions in the form 
alias TEnv = rel[loc def, str name, str label, Type \type];

Type getType(AType typ){
  switch(typ) {
      case integer(): return tint();
      case boolean(): return tbool();
      case string():  return tstr();
    }
    return tunknown();
}


// To avoid recursively traversing the form, use the `visit` construct
// or deep match (e.g., `for (/question(...) := f) {...}` ) 
TEnv collect(AForm f) {
  TEnv env = {};
  for (/question(str ques, AId trg, AType typ) := f){
    env += <trg.src, trg.name, ques ,getType(typ)>;
  }
  for (/compQuestion(str ques, AId param, AType typ,_) := f){
    env += <param.src, param.name, ques ,getType(typ)>;
  }
  return env; 
}


set[Message] check(AForm f, TEnv tenv, UseDef useDef) {
  set[Message] msg = {};  
  for(q <- f.questions){
    msg += check(q, tenv, useDef);
  }

  return msg; 
}


set[Message] check(AQuestion q, TEnv tenv, UseDef useDef) {
  set[Message] msg = {};
  for(t1<-tenv && q has ques){
      if(t1.label == q.ques && t1.def != q.param.src){
        msg += {warning("duplicate labels", t1.def);};
      }
      if(t1.name == q.param.name && t1.\type != getType(q.t)){
        msg += {error("declared questions with the same name but different types.", q.param.src);}
      }
  }
  if(q has t && q has exp){ // compQuestion
    if(typeOf(q.exp, tenv, useDef) != getType(q.t)){
      msg += {error("computed questions should match the type of the expression.", q.param.src);}
    }    
  }

  if(q has exp){
    msg += check(q.exp, tenv, useDef);
  }

  if(q has questions){
    for(quest <- q.questions){
      msg += check(quest, tenv, useDef);
    }
  }
  
  if(q has ifQuestions){
    for(quest <- q.ifQuestions){
      msg += check(quest, tenv, useDef);
    }
    for(quest <- q.elseQuestions){
      msg += check(quest, tenv, useDef);
    }
  }

  return msg; 
}

set[Message] check(AExpr e, TEnv tenv, UseDef useDef) {
  set[Message] msgs = {};
  switch (e) {
    case ref(AId x):
      msgs += { error("Undeclared question", x.src) | useDef[x.src] == {} };
    case integer(int vali):
      msgs += { error("Incompatible operand", e.src) | typeOf(e, tenv, useDef) != tint()};
    case boolean(bool valb):
      msgs += { error("Incompatible operand", e.src) | typeOf(e, tenv, useDef) != tbool()};  
    case not(AExpr expr):
      msgs += { error("Incompatible operand", e.src) | typeOf(expr, tenv, useDef) != tbool()};  
    case brackets(AExpr expr):{};
    case conj(AExpr left, AExpr right):
      msgs += { error("Incompatible operand", e.src) | typeOf(left, tenv, useDef) != tbool() && tbool() != typeOf(right, tenv, useDef)};
    case disj(AExpr left, AExpr right):
      msgs += { error("Incompatible operand", e.src) | typeOf(left, tenv, useDef) != tbool() && tbool() != typeOf(right, tenv, useDef)};
    default:{
      
      msgs += { error("Incompatible operand", e.src) | typeOf(e.left, tenv, useDef) != tint() && tint() != typeOf(e.right, tenv, useDef)};
    }
  }
  
  return msgs; 
}

Type typeOf(AExpr e, TEnv tenv, UseDef useDef) {
  switch (e) {
    case ref(id(_, src = loc u)):{ 
      if (<u, loc d> <- useDef, <d, _, _, Type t> <- tenv) {
        return t;
      }
    }
    case integer(_): { return tint();}
    case boolean(_): return tbool();
    case brackets(_): return typeOf(e.expr,tenv, useDef);
    case not(_): return tbool();
    default:{
      if(typeOf(e.left, tenv, useDef) == typeOf(e.right, tenv, useDef)){
        
        return typeOf(e.left, tenv, useDef);
      }else{
        return tunknown();
      }
    }
  }
  
  return tunknown(); 
}


 
 

