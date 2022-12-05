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
  = question(str question, str id, AType typ)
  | question(str question, str id, AType typ, AExpr expr)
  | question(ABlock block)//not sure
  | question(AExpr condition, ABlock thenBlock, ABlock elseBlock)
  | question(AExpr condition, ABlock thenBlock)
  ; 

data ABlock(loc src = |tmp:///|)
  = block(list[AQuestion] questions)
  ;

data AExpr(loc src = |tmp:///|)
  = ref(AId id)
  ;


data AId(loc src = |tmp:///|)
  = id(str name);

data AType(loc src = |tmp:///|)
  ;