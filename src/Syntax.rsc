module Syntax

extend lang::std::Layout;
extend lang::std::Id;

/*
 * Concrete syntax of QL
 */
start syntax Form 
  = "form" Id name "{" Question* questions "}"; 

syntax Question
  = Str question Id parameter ":" Type type // Question
  | Str question Id parameter ":" Type type "=" Expr expr // Computed question
  | Block block // Block
  | "if" "(" Expr condition ")" Block thenBlock "else" Block elseBlock // If-then-else
  | "if" "(" Expr condition ")" Block thenBlock // If-then
  ;

syntax Block = "{" Question* questions "}";

// TODO: +, -, *, /, &&, ||, !, >, <, <=, >=, ==, !=, literals (bool, int, str)
// Think about disambiguation using priorities and associativity
// and use C/Java style precedence rules (look it up on the internet)
syntax Expr 
  = Id \ "true" \ "false" // true/false are reserved keywords.
  ;
  
syntax Type = "boolean" | "integer" | "string";


lexical Str = "\"" (![\"])* "\"";

lexical Int 
  = [1-9][0-9]+
  | "0";


lexical Bool = ;



