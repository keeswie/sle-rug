module Transform

import Syntax;
import Resolve;
import AST;
import ParseTree;
import Set;

/* 
 * Transforming QL forms
 */
 
 
/* Normalization:
 *  wrt to the semantics of QL the following
 *     q0: "" int; 
 *     if (a) { 
 *        if (b) { 
 *          q1: "" int; 
 *        } 
 *        q2: "" int; 
 *      }
 *
 *  is equivalent to
 *     if (true) q0: "" int;
 *     if (true && a && b) q1: "" int;
 *     if (true && a) q2: "" int;
 *
 * Write a transformation that performs this flattening transformation.
 *
 */
 
AForm flatten(AForm f) {
  f.questions = flattenQuestions(f.questions, boolean(true));
  return f;
}

list[AQuestion] flattenQuestions(list[AQuestion] lq, AExpr exp) {
  list[AQuestion] questions = [];
  for (AQuestion q <- lq) {
    questions = questions + flatQuestion(q, exp);
  }

  return questions;
}

list[AQuestion] flatQuestion(AQuestion q, AExpr expression) {
  switch(q) {
    case question(str ques, AId param, AType t): {
      return [ifStatement(expression, [q])];
    }
    case compQuestion(str ques, AId param, AType t, AExpr exp): {
      return [ifStatement(expression, [q])];
    }
    case ifStatement(AExpr exp, list[AQuestion] lq): {
      return flattenQuestions(lq, conj(expression, brackets(exp)));
    }
    case ifElseStatement(AExpr exp, list[AQuestion] lq1, list[AQuestion] lq2): {
      // TODO: Not sure about the neg here
      return flattenQuestions(lq1, conj(expression, brackets(exp))) + flattenQuestions(lq2, conj(expression, brackets(not(exp))));
    }
    default: {
      return [];
    }
  }
}

/* Rename refactoring:
 *
 * Write a refactoring transformation that consistently renames all occurrences of the same name.
 * Use the results of name resolution to find the equivalence class of a name.
 *
 */
 
start[Form] rename(start[Form] f, loc useOrDef, str newName, UseDef useDef) {
   if(isEmpty(useDef[useOrDef])) {
    return traverseForm(f, useOrDef, newName, useDef);
   }

   return traverseForm(f, toList(useDef[useOrDef])[0], newName, useDef);
} 

bool idWorks(str id) {
  try {
    parse(#Id, id);
    return true;
  } catch: {
    return false;
  }
}

Form traverseForm(Form f, loc useOrDef, str newName, UseDef useDef) {
  if (!idWorks(newName)) {
    return f; // Id is not valid
  }

  Id newID = [Id]newName;
  return visit (f) {
    case (Expr)`<Id x>` => (Expr)`<Id $newID>`
        when <loc use, definition> <- useDef, use == x@\loc
    case (Question)`<Str question> <Id param> : <Type t>` => (Question)`<Str question>    <Id newID> : <Type t>`
        when <str name, definition> <- useDef, param == [Id]name
    case (Question)`<Str question> <Id param> : <Type t> = <Expr e>` => (Question)`<Str question> <Id newID> : <Type t>`
        when <str name, definition> <- useDef, param == [Id]name

  }

  return f;
}
 
 
 

