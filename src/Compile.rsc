module Compile

import AST;
import Resolve;
import IO;
import lang::html::AST; // see standard library
import lang::html::IO;

/*
 * Implement a compiler for QL to HTML and Javascript
 *
 * - assume the form is type- and name-correct
 * - separate the compiler in two parts form2html and form2js producing 2 files
 * - use string templates to generate Javascript
 * - use the HTMLElement type and the `str writeHTMLString(HTMLElement x)` function to format to string
 * - use any client web framework (e.g. Vue, React, jQuery, whatever) you like for event handling
 * - map booleans to checkboxes, strings to textfields, ints to numeric text fields
 * - be sure to generate uneditable widgets for computed questions!
 * - if needed, use the name analysis to link uses to definitions
 */

void compile(AForm f) {
  writeFile(f.src[extension="js"].top, form2js(f));
  writeFile(f.src[extension="html"].top, writeHTMLString(form2html(f)));
  println("done");
}

HTMLElement form2html(AForm f) {
  return html([]);
}

str form2js(AForm f) {
  int temp = 1;
  return "import { Question, IfQuestion } from \"./Question.js\";
         'import { Form } from \"./Form.js\";
         'import { Expression } from \"./Expression.js\";
         'let form = new Form(\"<f.id.name>\");
         '<for(q<-f.questions){temp+=8;>
         '<QuestoString(q, temp, "form",0,1)>
         '<}>
         ' (form);  
         ";
}

str QuestoString(AQuestion q, int temp, str parent, int flag, int ifCount){
  switch(q) {
    case question(str ques, AId param,AType t): {
      return "let <param.name> = new Question(<ques>,\"<param.name>\",\"<getType(t)>\", <getDefault(t)>)
             '<parent>.addQuestion(<param.name>, <flag>)
             ";
    }
    case compQuestion(str ques, AId param, AType t, AExpr exp): {
      println("compQuestion");
      return "<exprToObject(exp,temp, "")>
             'let <param.name> = new Question(<ques>,\"<param.name>\",\"<getType(t)>\",ex<temp>)
             '<parent>.addQuestion(<param.name>,<flag>)
          ";
    }
    case ifStatement(AExpr exp, list[AQuestion] questions): {
      println("ifQuestion");
      ifCount = ifCount + 1;
      return "<exprToObject(exp,temp, "")>
             'let ifq<ifCount> = new IfQuestion(ex<temp>)
             '<for(ques<-questions){temp+=10;>
             '<QuestoString(ques, temp, "ifq<ifCount>",1, ifCount)>
             '<}>
             '<parent>.addQuestion(ifq<ifCount>,<flag>)
             ";
    }
    case ifElseStatement(AExpr exp, list[AQuestion] ifQuestions, list[AQuestion] elseQuestions): {
      println("ifelseQuestion");
      ifCount = ifCount + 1;
      return "<exprToObject(exp,temp, "")>
             'let ifq<ifCount> = new IfQuestion(ex<temp>)
             '<for(q<-ifQuestions){temp+=13;>
             '<QuestoString(q, temp, "ifq<ifCount>",1, ifCount)>
             '<}>
             '<for(q<-elseQuestions){temp+=15;>
             '<QuestoString(q, temp, "ifq<ifCount>",0, ifCount)>
             '<}>
             '<parent>.addQuestion(ifq<ifCount>,<flag>)
             ";
    }
  }
  return "hoi";
}

str getType(AType t){
  switch(t){
      case integer(): {return "integer";}
      case boolean(): {return "boolean";}
      case string(): {return "string";}
    }
  return "unknown";
}

str getDefault(AType t){
  switch(t){
      case integer(): {return "1";}
      case boolean(): {return "true";}
      case string(): {return "\"\"";}
    }
  return "unknown";
}

str exprToObject(AExpr exp, int i, str done){
  switch (exp) {
    case ref(id(str x)): return "let ex<i> = new Expression(\"\",\"\", \"ref\", \"<x>\");\n";
    case integer(int vali): return "let ex<i> = new Expression(\"\",\"\", \"integer\", <vali>);\n";
    case boolean(bool valb): return "let ex<i> = new Expression(\"\",\"\", \"boolean\", <valb>);\n";
    case brackets(AExpr expr): return exprToObject(expr, i+1, done) + "let ex<i> = new Expression(ex<i+1>,\"\", \"brackets\");\n";
    case not(AExpr expr): return  exprToObject(expr, i+1, done)+ "let ex<i> = new Expression(\"ex<i+1>\",\"\", \"not\")";
    case mult(AExpr left, AExpr right): return exprToObject(left, i*10+2, done) + exprToObject(right, i*20-4, done) + "let ex<i> = new Expression(ex<i*10+2>,ex<i*20-4>,\"mult\");\n";
    case add(AExpr left, AExpr right):return exprToObject(left, i*10+2, done) + exprToObject(right, i*20-4, done) + "let ex<i> = new Expression(ex<i*10+2>,ex<i*20-4>,\"add\");\n";
    case subtract(AExpr left, AExpr right):return exprToObject(left, i*10+2, done) + exprToObject(right, i*20-4, done) + "let ex<i> = new Expression(ex<i*10+2>,ex<i*20-4>,\"subtract\");\n";
    case greater(AExpr left, AExpr right):return exprToObject(left, i*10+2, done) + exprToObject(right, i*20-4, done) + "let ex<i> = new Expression(ex<i*10+2>,ex<i*20-4>,\"greater\");\n";
    case less(AExpr left, AExpr right):return exprToObject(left, i*10+2, done) + exprToObject(right, i*20-4, done) + "let ex<i> = new Expression(ex<i*10+2>,ex<i*20-4>,\"less\");\n";
    case greq(AExpr left, AExpr right):return exprToObject(left, i*10+2, done) + exprToObject(right, i*20-4, done) + "let ex<i> = new Expression(ex<i*10+2>,ex<i*20-4>,\"greq\");\n";
    case leq(AExpr left, AExpr right):return exprToObject(left, i*10+2, done) + exprToObject(right, i*20-4, done) + "let ex<i> = new Expression(ex<i*10+2>,ex<i*20-4>,\"leq\");\n";
    case neq(AExpr left, AExpr right):return exprToObject(left, i*10+2, done) + exprToObject(right, i*20-4, done) + "let ex<i> = new Expression(ex<i*10+2>,ex<i*20-4>,\"neq\");\n";
    case conj(AExpr left, AExpr right):return exprToObject(left, i*10+2, done) + exprToObject(right, i*20-4, done) + "let ex<i> = new Expression(ex<i*10+2>,ex<i*20-4>,\"conj\");\n";
    case disj(AExpr left, AExpr right):return exprToObject(left, i*10+2, done) + exprToObject(right, i*20-4, done) + "let ex<i> = new Expression(ex<i*10+2>,ex<i*20-4>,\"disj\");\n";
    
    default: throw "Unsupported expression";
  };
}