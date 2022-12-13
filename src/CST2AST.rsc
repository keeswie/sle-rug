module CST2AST

import Syntax;
import AST;

import ParseTree;

/*
 * Implement a mapping from concrete syntax trees (CSTs) to abstract syntax trees (ASTs)
 *
 * - Use switch to do case distinction with concrete patterns (like in Hack your JS) 
 * - Map regular CST arguments (e.g., *, +, ?) to lists 
 *   (NB: you can iterate over * / + arguments using `<-` in comprehensions or for-loops).
 * - Map lexical nodes to Rascal primitive types (bool, int, str)
 * - See the ref example on how to obtain and propagate source locations.
 */

AForm cst2ast(start[Form] sf) = cst2ast(sf.top); 

AForm cst2ast(f:(Form) `form <Id name> {<Question* qq>}`)
 = form(cst2ast(name), [cst2ast(q) | Question q <- qq], src= f.src);


AQuestion cst2ast(Question q) {
  switch(q){
    case (Question) `<Str question> <Id id> : <Type t>`:
      return question("<question>", cst2ast(id), cst2ast(t), src=id.src);
    case(Question) `<Str question> <Id id> : <Type t> = <Expr expr>`:
      return question("<question>", cst2ast(id), cst2ast(t), cst2ast(expr), src = id.src);
    case(Question) `<Block block>`:
      return question(cst2ast(block) src=block.src);
    case(Question) `if ( <Expr expr> ) <Block b1> else <Block b2>`:
      return question(cst2ast(expr), cst2ast(b1), cst2ast(b2), src=expr.src);
    case(Question) `if ( <Expr expr> ) <Block b1>`:
      return question(cst2ast(expr), cst2ast(b1), src=expr.src);
    default: throw "Unhandled expression: <q>";
  }
}

ABlock cst2ast(Block b){
  switch(b){
    case (Block) `{ <Question* qq> }`:
      return block([cst2ast(q) | Question q <- qq], src= qq.src);
    default: throw "Unhandled expression: <q>";
  }
}

AExpr cst2ast(Expr e) {
  switch (e) {
    case (Expr)`<Id x>`: return ref(id("<x>", src=x.src), src=x.src);
    case (Expr) `<Expr lhs> + <Expr rhs>`: 
      return add(cst2ast(lhs), cst2ast(rhs), src=lhs.src); 
    case (Expr) `<Expr lhs> - <Expr rhs>`: 
      return subtr(cst2ast(lhs), cst2ast(rhs), src=lhs.src); 
    case (Expr) `<Expr lhs> * <Expr rhs>`: 
      return  mult(cst2ast(lhs), cst2ast(rhs), src=lhs.src); 
    case (Expr) `<Expr lhs> / <Expr rhs>`: 
      return div(cst2ast(lhs), cst2ast(rhs), src=lhs.src); 
    case (Expr) `Int vali`:
      return integer(vali, src=vali.src);
    case (Expr)  `Bool valb`:
      return boolean(valb, src=valb.src);
    case (Expr) `( <Expr expr> )`:
      return brackets(cst2ast(expr), src=expr.src);
    case (Expr) `! <Expr expr>`:
      return not(cst2ast(expr), src=expr.src);
    case (Expr) `<Expr lhs> \<= <Expr rhs>`:
      return leq(cst2ast(lhs), cst2ast(rhs), src=lhs.src);
    case (Expr) `<Expr lhs> =\> <Expr rhs>`:
      return meq(cst2ast(lhs), cst2ast(rhs), src=lhs.src);
    case (Expr) `<Expr lhs> == <Expr rhs>`:
      return equal(cst2ast(lhs), cst2ast(rhs), src=lhs.src);
    case (Expr) `<Expr lhs> \> <Expr rhs>`:
      return more(cst2ast(lhs), cst2ast(rhs), src=lhs.src);
    case (Expr) `<Expr lhs> \< <Expr rhs>`:
      return less(cst2ast(lhs), cst2ast(rhs), src=lhs.src);
    case (Expr) `<Expr lhs> != <Expr rhs>`:
      return notequal(cst2ast(lhs), cst2ast(rhs), src=lhs.src);
    
    default: throw "Unhandled expression: <e>";
  }
}

default AType cst2ast(Type t) {
  switch(t){
    case (Type) `integer`:
      return integer(src=t.src);
    case (Type) `boolean`:
      return boolean(src=t.src);
    case (Type) `string`:
      return (string(src=t.src).
  }
}
