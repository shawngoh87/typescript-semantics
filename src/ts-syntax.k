module TS-SYNTAX
    imports INT-SYNTAX
    imports BOOL-SYNTAX
    imports FLOAT-SYNTAX

    /**
    TODO:
    - Reserved keywords e.g. let, const, var
    */


    // Using default layout rules for whitespace and comments
    // https://kframework.org/k-distribution/include/kframework/builtin/kast/#layout-information
    
    syntax VariableDeclaration ::= "var" Name
                                | "var" Name ":" Type
                                | "var" Name "=" Expression
                                | "const" Name ":" Type
                                | "const" Name "=" Expression
                                | "let" Name
                                | "let" Name ":" Type
                                | "let" Name "=" Expression

    syntax AssignmentExpression ::= Name "=" Expression

    syntax Name ::= r"[_$A-Za-z][_$A-Za-z0-9]*" [token] // source?
    syntax Type ::= BuiltinTypes | UserDefinedTypes

    syntax BuiltinTypes ::= "number" | "string" | "boolean" | "any" | "unknown" | "never" | "void" | "null" | "undefined" | "symbol" | "object" | "bigint"
    syntax UserDefinedTypes ::= r"[_$A-Za-z][_$A-Za-z0-9]*" [token] // source?

    syntax Expression ::= Name
                        | Literal

    syntax Statement ::= Expression ";"
                        | VariableDeclaration ";"
                        | AssignmentExpression ";"
                        | Statement Statement [left]

    syntax HexIntegerLiteral ::= r"0x[0-9a-fA-F]+" [token]
    syntax OctalIntegerLiteral ::= r"0o[0-7]+" [token]

    syntax Literal ::= Bool
                    | Int
                    | Float
                    | HexIntegerLiteral
                    | OctalIntegerLiteral

    syntax Null ::= "null"

endmodule