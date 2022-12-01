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

syntax Expr 
  = Math
  | Logical
  ;

syntax Logical
  = Disjunction
  | Comparison
  ;

syntax Comparison 
  = Math "\<" Math
  | Math "\>" Math
  | Math "\<=" Math
  | Math "=\>" Math
  | Math "==" Math
  | Math "!=" Math
  | Disjunction "==" Disjunction
  | Disjunction "!=" Disjunction
  ; 


syntax Math
  = Add
  ;   

syntax Add 
  = Sub
  | Sub "+" Sub
  ;

syntax Sub 
  = Mult
  | Mult "-" Mult
  ;

syntax Mult 
  = Div
  | Div "*" Div
  ;

syntax Div
  = Number
  | Number "/" Number
  ;

syntax Number
  = Int
  | "(" Math ")"
  | Id \ "True" \ "False" // true/false are reserved keywords
  ;

syntax Type = "boolean" | "integer" | "string";


lexical Str = "\"" (![\"])* "\"";

lexical Int 
  = [1-9][0-9]+
  | [0];


lexical Bool 
  = "True"
  | "False"
  | "(" Disjunction ")";

lexical Disjunction = Conjunction
  Conjunction "||" Conjunction;

lexical Conjunction = Literal
  | Literal "&&" Literal;

lexical Literal = "True"
  | "False"
  | Bool
  | "!" Bool;
