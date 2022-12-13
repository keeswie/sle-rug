module AST

/*
 * Define Abstract Syntax for QL
 *
 * - complete the following data types
 * - make sure there is an almost one-to-one correspondence with the grammar
 */

data AForm(loc src = |tmp:///|)
  = form(str name, list[AQuestion] questions)
  ; 

data AQuestion(loc src = |tmp:///|)
  = question(str question, AId id, AType typ)
  | question(str question, AId id, AType typ, AExpr expr)
  | question(ABlock block)//not sure
  | question(AExpr condition, ABlock thenBlock, ABlock elseBlock)
  | question(AExpr condition, ABlock thenBlock)
  ; 

data ABlock(loc src = |tmp:///|)
  = block(list[AQuestion] questions)
  ;

data AExpr(loc src = |tmp:///|)
  = var(AId id)
  | mult(AExpr lhs, AExpr rhs)
  | div(AExpr lhs, AExpr rhs)
  | add(AExpr lhs, AExpr rhs)
  | subtr(AExpr lhs, AExpr rhs)
  | integer(int vali)
  | boolean(bool valb)
  | brackets(AExpr expr)
  | not(AExpr expr)
  | leq(AExpr lhs, AExpr rhs)
  | meq(AExpr lhs, AExpr rhs)
  | more(AExpr lhs, AExpr rhs)
  | less(AExpr lhs, AExpr rhs)
  | equal(AExpr lhs, AExpr rhs)
  | notequal(AExpr lhs, AExpr rhs)

  ;


data AId(loc src = |tmp:///|)
  = id(str name);

data AType(loc src = |tmp:///|)
  = integer()
  | boolean()
  | string()
  ;