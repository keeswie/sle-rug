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
  = ref(ALogical logical)
  | ref(AMath math)
  ;

data ALogical(loc src = |tmp:///|)
  = logical(ADisjunction Disjunction)
  | logical(AComparison)
  ;

data AComparison(loc src = |tmp:///|)
  = comparison(ABool abool)
  ;

data ADisjunction(loc src = |tmp:///|)
  = disjunction(AConjunction conjunction)
  | disjunction(AConjunction lh, AConjunction rh)
  ;

data AConjunction(loc src = |tmp:///|)
  = conjunction(ALiteral literal)
  | conjunction(ALiteral lh, ALiteral rh)
  ;

data ALiteral(loc src = |tmp:///|)
  = literal(ABool abool)
  ;

data ABool(loc src = |tmp:///|)
  = abool(str abool)
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