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
  = ref(AMath math)
  | ref(ALogical logical)
  ;

data AMath(loc src = |tmp:///|)
  = math(AAdd add)
  ;

data AAdd(loc src = |tmp:///|)
  = add(ASub sub)
  | add(ASub lh, ASub rh)
  ;

data ASub(loc src = |tmp:///|)
  = sub(AMult mult)
  | sub(AMult lh, AMult rh)
  ;

data AMult(loc src = |tmp:///|)
  = mult(ADiv div)
  | mult(ADiv lh, ADiv rh)
  ;

data ADiv(loc src = |tmp:///|)
  = div(ANumber number)
  | div(ANumber lh, ANumber rh)
  ;

data ANumber(loc src = |tmp:///|)
  = number(int number)
  | number(AMath math)
  | number(AId id)
  ;

data AId(loc src = |tmp:///|)
  = id(str name);

data AType(loc src = |tmp:///|)
  ;