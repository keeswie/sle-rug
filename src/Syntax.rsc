module Syntax

extend lang::std::Layout;
extend lang::std::Id;

/*
 * Concrete syntax of QL
 */
start syntax Form 
  = "form" Id name "{" Question* questions "}"; 

// TODO: question, computed question, block, if-then-else, if-then
syntax Question
  = Str question Id parameter ":" Type type // Question
  | Str question Id parameter ":" Type type "=" Expr expr; // Computed question


// TODO: +, -, *, /, &&, ||, !, >, <, <=, >=, ==, !=, literals (bool, int, str)
// Think about disambiguation using priorities and associativity
// and use C/Java style precedence rules (look it up on the internet)
syntax Expr 
  = Id \ "true" \ "false" // true/false are reserved keywords.
  ;
  
syntax Type = "boolean" | "integer" | "string";

syntax OR 
  = AND "&&" AND
  | AND;

syntax AND
  = NOT "||" NOT
  | NOT;

lexical Str = "\"" (~["\""])* "\"";

lexical Int 
  = [1-9][0-9]+
  | "0";

lexical boolLiteral = "true" | "false";

lexical Bool 
  = OR
  | "(" Bool ")"; 



