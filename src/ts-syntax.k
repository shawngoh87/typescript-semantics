/**
 * TypeScript Syntax
 *
 * Based on ECMAScript Language Specification, 2020 Edition
 * https://tc39.es/ecma262/2020
 */
module TS-SYNTAX
    imports INT-SYNTAX
    imports BOOL-SYNTAX
    imports FLOAT-SYNTAX

    /**
    TODO:
    - Reserved keywords e.g. let, const, var
    - variable declaration sequence
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

    syntax Name ::= r"[_$A-Za-z][_$A-Za-z0-9]*" [token] // source?
    syntax Type ::= BuiltinTypes | UserDefinedTypes

    syntax BuiltinTypes ::= "number" | "string" | "boolean" | "any" | "unknown" | "never" | "void" | "null" | "undefined" | "symbol" | "object" | "bigint"
    syntax UserDefinedTypes ::= r"[_$A-Za-z][_$A-Za-z0-9]*" [token] // source?

    syntax PrimaryExpression ::= Name
                                | Literal
    syntax LeftExpression ::= PrimaryExpression
    syntax Expression ::= LeftExpression
                        > Expression "++"
                        | Expression "--"
                        > "delete" Expression
                        | "void" Expression
                        | "typeof" Expression
                        | "++" Expression                               [prefer]
                        | "--" Expression                               [prefer]
                        | "+" Expression
                        | "-" Expression
                        | "~" Expression
                        | "!" Expression
                        > left:
                        Expression "*" Expression                            [left]
                        | Expression "/" Expression                            [left]
                        | Expression "%" Expression                            [left]
                        > left:
                        Expression "+" Expression                            [left]
                        | Expression "-" Expression                            [left]
                        > left:
                        Expression "<<" Expression                           [left]
                        | Expression ">>" Expression                           [left]
                        | Expression ">>>" Expression                          [left]
                        > left:
                        Expression "<" Expression                            [left]
                        | Expression ">" Expression                            [left]
                        | Expression "<=" Expression                           [left]
                        | Expression ">=" Expression                           [left]
                        | Expression "instanceof" Expression                   [left,prefer]
                        | Expression "in" Expression                           [left, symbol('_in_::Expression*Expression->Expression)]
                        > left:
                        Expression "==" Expression                           [left]
                        | Expression "!=" Expression                           [left]
                        | Expression "===" Expression                          [left]
                        | Expression "!==" Expression                          [left]
                        > left:
                        Expression "&" Expression                            [left]
                        > left:
                        Expression "^" Expression                            [left]
                        > left:
                        Expression "|" Expression                            [left]
                        > left:
                        Expression "&&" Expression                           [left]
                        > left:
                        Expression "||" Expression                           [left]
                        > Expression "?" Expression ":" Expression
                        > right:
                        LeftExpression "=" Expression                               // [right]
                        | LeftExpression "*=" Expression                            // [right]
                        | LeftExpression "/=" Expression                            // [right]
                        | LeftExpression "%=" Expression                            // [right]
                        | LeftExpression "+=" Expression                            // [right]
                        | LeftExpression "-=" Expression                            // [right]
                        | LeftExpression "<<=" Expression                           // [right]
                        | LeftExpression ">>=" Expression                           // [right]
                        | LeftExpression ">>>=" Expression                          // [right]
                        | LeftExpression "&=" Expression                            // [right]
                        | LeftExpression "^=" Expression                            // [right]
                        | LeftExpression "|=" Expression                            //[right]

    syntax Expressions ::= List{Expression, ","}
    syntax ExpressionSequence ::= Expression
                                | Expression "," ExpressionSequence [symbol('_,_::Expression*ExpressionSequence->ExpressionSequence)]
    
    syntax Statement ::= Block
                        | Statement Statement [left] // ?
                        //    | "var" VariableDeclarationS ";"
                        | VariableDeclaration ";"
                        | ExpressionSequence ";"
                        | "if" "(" ExpressionSequence ")" Statement
                        | "if" "(" ExpressionSequence ")" Statement "else" Statement    [prefer]
                        | "do" Statement "while" "(" ExpressionSequence ")" ";"
                        | "while" "(" ExpressionSequence ")" Statement
                        | "for" "("                Expressions ";" Expressions ";" Expressions ")" Statement
                        //    | "for" "(" "var" VariableDeclarationS ";" Expressions ";" Expressions ")" Statement
                        //    | "for" "("            LeftExpression "in" ExpressionSequence ")" Statement
                        //    | "for" "(" "var" VariableDeclaration "in" ExpressionS ")" Statement
                        | "continue" ";"
                        | "continue" Name ";"
                        | "break" ";"
                        | "break" Name ";"
                        | "return" ";"
                        | "return" ExpressionSequence ";"
                        | "with" "(" ExpressionSequence ")" Statement
                        | Name ":" Statement                     [symbol('_:_::Name*Statement->Statement)] // label
                        // | "switch" "(" ExpressionSequence ")" CaseBlock
                        | "throw" ExpressionSequence ";"
                        //    | "try" Block Catch
                        //    | "try" Block Finally
                        //    | "try" Block Catch Finally
                        //    | "debugger" ";"

    syntax Statements ::= List{Statement, ""}       [symbol('__::Statement*Statements->Statements)]

    // syntax IterationStatement ::= "do" Statement "while" "(" Expression ")" ";"
    //                             | "while" "(" Expression ")" Statement
    //                             | "for" "(" Expression ";" Expression ";" Expression ")" Statement
    //                             | "for" "(" "var" VariableDeclarationList ";" Expression ";" Expression ")" Statement
    //                             | "for" "(" LexicalDeclaration Expression ";" Expression ")" Statement
    //                             | "for" "(" LeftHandSideExpression "in" Expression ")" Statement
    //                             | "for" "(" "var" ForBinding "in" Expression ")" Statement
    //                             | "for" "(" ForDeclaration "in" Expression ")" Statement
    //                             | "for" "(" LeftHandSideExpression "of" AssignmentExpression ")" Statement
    //                             | "for" "(" "var" ForBinding "of" AssignmentExpression ")" Statement
    //                             | "for" "(" ForDeclaration "of" AssignmentExpression ")" Statement
    //                             | "for" "await" "(" LeftHandSideExpression "of" AssignmentExpression ")" Statement
    //                             | "for" "await" "(" "var" ForBinding "of" AssignmentExpression ")" Statement
    //                             | "for" "await" "(" ForDeclaration "of" AssignmentExpression ")" Statement

    syntax Block ::= "{" Statements "}" [symbol('{_}::Statements->Block)]

    syntax HexIntegerLiteral ::= r"0x[0-9a-fA-F]+" [token]
    syntax OctalIntegerLiteral ::= r"0o[0-7]+" [token]

    syntax Literal ::= Bool
                    | Int
                    | Float
                    | HexIntegerLiteral
                    | OctalIntegerLiteral

    syntax Null ::= "null"

endmodule