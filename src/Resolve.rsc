module Resolve

import AST;

/*
 * Name resolution for QL
 */ 


// modeling declaring occurrences of names
alias Def = rel[str name, loc def];

// modeling use occurrences of names
alias Use = rel[loc use, str name];

alias UseDef = rel[loc use, loc def];

// the reference graph
alias RefGraph = tuple[
  Use uses, 
  Def defs, 
  UseDef useDef
]; 

RefGraph resolve(AForm f) = <us, ds, us o ds>
  when Use us := uses(f), Def ds := defs(f);

Use uses(AForm f) {
  return {<e.id.src, e.id.name>|/AExpr e := f, e has id} + {<i.src, i.name> | /AId i := f}; ; 
}

Def defs(AForm f) {
  return {<q.param.name, q.param.src> |/AQuestion q := f, q has param};
}