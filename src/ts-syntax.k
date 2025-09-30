module TS-SYNTAX

/*
var a = true;
var b: Boolean;
var c: Boolean = false;
*/
syntax ID ::= "a" | "b" | "c"
syntax BooleanLiteral ::= "true" | "false"
syntax BooleanDeclarationExpression ::=    "var" ID "=" BooleanLiteral ";"
                            |   "var" ID ":" "Boolean" ";"
                            |   "var" ID ":" "Boolean" "=" BooleanLiteral ";"

syntax Statement ::= BooleanDeclarationExpression
                    | Statement Statement [left]

endmodule