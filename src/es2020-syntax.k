/**
    ECMAScript Language Specification, 2020 Edition
    https://tc39.es/ecma262/2020
    
    TODO:
    1. Figure out how to handle Automatic Semicolon Insertion (ASI). 
    The current parser assumes ASI is already ran and will likely fail some test262
    tests. Decide if ASI is part of the design goal (a complete parser) or 
    a complementary tool that runs AFTER a formatter.
 */
module ES2020-SYNTAX
    // 11.6 Names and Keywords
    // TODO: Handle unicode 11.6
    syntax IdentifierName ::= r"[_$A-Za-z][_$A-Za-z0-9]*" [token]

    // 11.8.3 Numeric Literals
    // TODO: Verify and turn these into lexical syntax
    syntax NumericLiteral ::= DecimalLiteral
                           | DecimalBigIntegerLiteral
                           | NonDecimalIntegerLiteral
                           | NonDecimalIntegerLiteralBigIntLiteralSuffix

    syntax DecimalBigIntegerLiteral ::= "0" BigIntLiteralSuffix
                                     | NonZeroDigit DecimalDigitsOpt BigIntLiteralSuffix

    syntax NonDecimalIntegerLiteral ::= BinaryIntegerLiteral
                                     | OctalIntegerLiteral
                                     | HexIntegerLiteral

    syntax NonDecimalIntegerLiteralBigIntLiteralSuffix ::= BinaryIntegerLiteral BigIntLiteralSuffix
                                                        | OctalIntegerLiteral BigIntLiteralSuffix
                                                        | HexIntegerLiteral BigIntLiteralSuffix

    syntax BigIntLiteralSuffix ::= "n"

    syntax DecimalLiteral ::= DecimalIntegerLiteral "." DecimalDigitsOpt ExponentPartOpt
                           | "." DecimalDigits ExponentPartOpt
                           | DecimalIntegerLiteral ExponentPartOpt

    syntax DecimalIntegerLiteral ::= "0"
                                  | NonZeroDigit DecimalDigitsOpt

    syntax DecimalDigitsOpt ::= DecimalDigits
                             | ""

    syntax DecimalDigits ::= DecimalDigit
                          | DecimalDigits DecimalDigit

    syntax DecimalDigit ::= r"[0-9]" [token]

    syntax NonZeroDigit ::= r"[1-9]" [token]

    syntax ExponentPartOpt ::= ExponentPart
                            | ""

    syntax ExponentPart ::= ExponentIndicator SignedInteger

    syntax ExponentIndicator ::= "e" | "E"

    syntax SignedInteger ::= DecimalDigits
                          | "+" DecimalDigits
                          | "-" DecimalDigits

    syntax BinaryIntegerLiteral ::= "0b" BinaryDigits
                                 | "0B" BinaryDigits

    syntax BinaryDigits ::= BinaryDigit
                         | BinaryDigits BinaryDigit

    syntax BinaryDigit ::= "0" | "1"

    syntax OctalIntegerLiteral ::= "0o" OctalDigits
                                | "0O" OctalDigits

    syntax OctalDigits ::= OctalDigit
                        | OctalDigits OctalDigit

    syntax OctalDigit ::= r"[0-7]" [token]

    syntax HexIntegerLiteral ::= "0x" HexDigits
                              | "0X" HexDigits

    syntax HexDigits ::= HexDigit
                      | HexDigits HexDigit

    syntax HexDigit ::= r"[0-9a-fA-F]" [token]

    // 11.8.4 String Literals
    // TODO: Implement the complete spec of StringLiteral
    // syntax lexical SingleQuotedStringLiteral = r"'([^'\\\n\r]|\\([^\r\n1-9xu]|(\r?\n)|x[0-9a-fA-F]{2}|u[0-9a-fA-F]{4}))*'"
    syntax lexical SingleQuotedStringLiteral = r"'.*'"
    syntax lexical DoubleQuotedStringLiteral = r"\\\".*\\\""
    syntax StringLiteral ::= r"{SingleQuotedStringLiteral}" [token]


    // 11.8.6 Template Literal Lexical Components
    // TODO: implement

    // 12 Expressions
    // 12.1 Identifiers
    syntax IdentifierReference ::= Identifier 
                                | "yield"
                                | "await"
    syntax BindingIdentifier ::= Identifier
                                | "yield"
                                | "await"
    syntax LabelIdentifier ::= Identifier
                            | "yield"
                            | "await"
    syntax Identifier ::= IdentifierName // TODO: SS: exclude ReservedWord

    // 12.2.5 Array Initializer
    syntax ArrayLiteral ::= "[" "]"
                          | "[" Elision "]" // optional Elision
                          | "[" ElementList "]"
                          | "[" ElementList "," "]"
                          | "[" ElementList "," Elision "]"

    syntax ElementList ::= AssignmentExpression
                        | SpreadElement
                        | Elision AssignmentExpression // optional Elision
                        | Elision SpreadElement // optional Elision
                        | ElementList "," AssignmentExpression
                        | ElementList "," SpreadElement
                        | ElementList "," Elision AssignmentExpression // optional Elision
                        | ElementList "," Elision SpreadElement // optional Elision

    syntax Elision ::= ","
                    | Elision ","

    syntax SpreadElement ::= "..." AssignmentExpression

    // 12.2.6 Object Initializer
    syntax PrimaryExpression ::= ObjectLiteral
    syntax ObjectLiteral ::= "{" "}"
                           | "{" PropertyDefinitionList "}"
                           | "{" PropertyDefinitionList "," "}"
    syntax PropertyDefinitionList ::= PropertyDefinition
                                   | PropertyDefinitionList "," PropertyDefinition
    syntax PropertyDefinition ::= IdentifierReference
                               | CoverInitializedName
                               | PropertyName ":" AssignmentExpression
                               | MethodDefinition
                               | "..." AssignmentExpression
    syntax PropertyName ::= LiteralPropertyName
                          | ComputedPropertyName
    syntax LiteralPropertyName ::= IdentifierName
                                | StringLiteral
                                | NumericLiteral
    syntax ComputedPropertyName ::= "[" AssignmentExpression "]"
    syntax CoverInitializedName ::= IdentifierReference Initializer
    syntax Initializer ::= "=" AssignmentExpression

    syntax AssignmentExpression ::= ConditionalExpression
                                 | YieldExpression
                                 | ArrowFunction
                                 | AsyncArrowFunction
                                 | LeftHandSideExpression "=" AssignmentExpression
                                 | LeftHandSideExpression AssignmentOperator AssignmentExpression

    syntax AssignmentOperator ::= "*="
                               | "/="
                               | "%="
                               | "+="
                               | "-="
                               | "<<="
                               | ">>="
                               | ">>>="
                               | "&="
                               | "^="
                               | "|="
                               | "**="

    // 12.2.9 Template Literals
    // TODO: handle template literals
    syntax TemplateLiteral ::= "todo::TemplateLiteral"

    // 12.3 Left-Hand-Side Expressions
    syntax MemberExpression ::= PrimaryExpression
                             | MemberExpression "[" Expression "]"
                             | MemberExpression "." IdentifierName
                             | MemberExpression TemplateLiteral
                             | SuperProperty
                             | MetaProperty
                             | "new" MemberExpression Arguments

    syntax SuperProperty ::= "super" "[" Expression "]"
                           | "super" "." IdentifierName

    syntax MetaProperty ::= NewTarget
                         | ImportMeta

    syntax NewTarget ::= "new" "." "target"

    syntax ImportMeta ::= "import" "." "meta"

    syntax NewExpression ::= MemberExpression
                          | "new" NewExpression

    // TODO: handle supplemental syntax for CoverCallExpressionAndAsyncArrowHead
    syntax CallExpression ::= CoverCallExpressionAndAsyncArrowHead
                           | SuperCall
                           | ImportCall
                           | CallExpression Arguments
                           | CallExpression "[" Expression "]"
                           | CallExpression "." IdentifierName
                           | CallExpression TemplateLiteral

    syntax SuperCall ::= "super" Arguments

    syntax ImportCall ::= "import" "(" AssignmentExpression ")"

    syntax Arguments ::= "(" ")"
                      | "(" ArgumentList ")"
                      | "(" ArgumentList "," ")"

    syntax ArgumentList ::= AssignmentExpression
                         | "..." AssignmentExpression
                         | ArgumentList "," AssignmentExpression
                         | ArgumentList "," "..." AssignmentExpression

    syntax OptionalExpression ::= MemberExpression OptionalChain
                               | CallExpression OptionalChain
                               | OptionalExpression OptionalChain

    syntax OptionalChain ::= "?." Arguments
                          | "?." "[" Expression "]"
                          | "?." IdentifierName
                          | "?." TemplateLiteral
                          | OptionalChain Arguments
                          | OptionalChain "[" Expression "]"
                          | OptionalChain "." IdentifierName
                          | OptionalChain TemplateLiteral

    syntax LeftHandSideExpression ::= NewExpression
                                   | CallExpression
                                   | OptionalExpression

    // 12.4 Update Expressions
    syntax UpdateExpression ::= LeftHandSideExpression
                             | LeftHandSideExpression "++" // TODO: no line terminator
                             | LeftHandSideExpression "--" // TODO: no line terminator
                             | "++" UnaryExpression
                             | "--" UnaryExpression

    // 12.5 Unary Operators
    // TODO: Implement AwaitExpression
    syntax UnaryExpression ::= UpdateExpression
                            | "delete" UnaryExpression
                            | "void" UnaryExpression
                            | "typeof" UnaryExpression
                            | "+" UnaryExpression
                            | "-" UnaryExpression
                            | "~" UnaryExpression
                            | "!" UnaryExpression
                            // | AwaitExpression

    // 12.6 Exponentiation Operator
    syntax ExponentiationExpression ::= UnaryExpression
                                     | UpdateExpression "**" ExponentiationExpression

    // 12.7 Multiplicative Operators
    syntax MultiplicativeExpression ::= ExponentiationExpression
                                     | MultiplicativeExpression MultiplicativeOperator ExponentiationExpression

    syntax MultiplicativeOperator ::= "*"
                                   | "/"
                                   | "%"

    // 12.8 Additive Operators
    syntax AdditiveExpression ::= MultiplicativeExpression
                               | AdditiveExpression "+" MultiplicativeExpression
                               | AdditiveExpression "-" MultiplicativeExpression
        
    // 12.9 Bitwise Shift Operators
    syntax ShiftExpression ::= AdditiveExpression
                            | ShiftExpression "<<" AdditiveExpression
                            | ShiftExpression ">>" AdditiveExpression
                            | ShiftExpression ">>>" AdditiveExpression

    // 12.10 Relational Operators
    syntax RelationalExpression ::= ShiftExpression
                                 | RelationalExpression "<" ShiftExpression
                                 | RelationalExpression ">" ShiftExpression
                                 | RelationalExpression "<=" ShiftExpression
                                 | RelationalExpression ">=" ShiftExpression
                                 | RelationalExpression "instanceof" ShiftExpression
                                 | RelationalExpression "in" ShiftExpression

    // 12.11 Equality Operators
    syntax EqualityExpression ::= RelationalExpression
                               | EqualityExpression "==" RelationalExpression
                               | EqualityExpression "!=" RelationalExpression
                               | EqualityExpression "===" RelationalExpression
                               | EqualityExpression "!==" RelationalExpression

    // 12.12 Binary Bitwise Operators
    syntax BitwiseANDExpression ::= EqualityExpression
                                 | BitwiseANDExpression "&" EqualityExpression

    syntax BitwiseXORExpression ::= BitwiseANDExpression
                                 | BitwiseXORExpression "^" BitwiseANDExpression

    syntax BitwiseORExpression  ::= BitwiseXORExpression
                                 | BitwiseORExpression "|" BitwiseXORExpression

    // 12.13 Binary Logical Operators
    syntax LogicalANDExpression ::= BitwiseORExpression
                                 | LogicalANDExpression "&&" BitwiseORExpression

    syntax LogicalORExpression  ::= LogicalANDExpression
                                 | LogicalORExpression "||" LogicalANDExpression

    syntax CoalesceExpression  ::= CoalesceExpressionHead "??" BitwiseORExpression

    syntax CoalesceExpressionHead ::= CoalesceExpression
                                   | BitwiseORExpression

    syntax ShortCircuitExpression ::= LogicalORExpression
                                   | CoalesceExpression

    // 12.14 Conditional Operator
    syntax ConditionalExpression ::= ShortCircuitExpression
                                  | ShortCircuitExpression "?" AssignmentExpression ":" AssignmentExpression

    // 12.16 Comma Operator
    syntax Expression ::= Expression "," AssignmentExpression 
                        | AssignmentExpression

    // 13. Statements
    syntax Statement ::= BlockStatement
    syntax Declaration ::= LexicalDeclaration
                        // | ClassDeclaration
                        // | HoistableDeclaration
    // syntax HoistableDeclaration ::= FunctionDeclaration
                                // | GeneratorDeclaration
                                // | AsyncFunctionDeclaration
                                // | AsyncGeneratorDeclaration
    // syntax BreakableStatement ::= IterationStatement
    //                             | SwitchStatement

    // 13.2 Block
    syntax BlockStatement ::= Block
    syntax Block ::= "{" StatementList "}"
                    | "{" "}"
    syntax StatementList ::= StatementList StatementListItem 
                            | StatementListItem
    syntax StatementListItem ::= Statement
                                | Declaration

    // 13.3 Declarations and the Variable Statement
    // 13.3.1 Let and Const Declarations
    syntax LexicalDeclaration ::= LetOrConst BindingList ";"
    syntax LetOrConst ::= "let" | "const"
    syntax BindingList ::= BindingList "," LexicalBinding
    syntax LexicalBinding ::= BindingIdentifier Initializer
                            // TODO: Check if this is the right syntax for optional
                            | BindingIdentifier
                            | BindingPattern Initializer

    // 13.3.3 Destructuring Binding Patterns
    syntax BindingPattern ::= ObjectBindingPattern
                           | ArrayBindingPattern

    syntax ObjectBindingPattern ::= "{" "}"
                                 | "{" BindingRestProperty "}"
                                 | "{" BindingPropertyList "}"
                                 | "{" BindingPropertyList "," BindingRestProperty "}" // optional BindingRestProperty
                                 | "{" BindingPropertyList "," "}"

    syntax ArrayBindingPattern ::= "[" Elision BindingRestElement "]" // optional Elision,BindingRestElement
                                | "[" "]"
                                | "[" Elision "]"
                                | "[" BindingRestElement "]"
                                | "[" BindingElementList "]"
                                | "[" BindingElementList "," Elision BindingRestElement "]" // optional Elision,BindingRestElement
                                | "[" BindingElementList "," "]"
                                | "[" BindingElementList "," Elision "]"
                                | "[" BindingElementList "," BindingRestElement "]"

    syntax BindingRestProperty ::= "..." BindingIdentifier

    syntax BindingPropertyList ::= BindingProperty
                                | BindingPropertyList "," BindingProperty

    syntax BindingElementList ::= BindingElementList "," BindingElisionElement
                               | BindingElisionElement

    syntax BindingElisionElement ::= Elision BindingElement // optional Elision
                                    | BindingElement

    syntax BindingProperty ::= SingleNameBinding
                            | PropertyName ":" BindingElement

    syntax BindingElement ::= SingleNameBinding
                           | BindingPattern Initializer // optional Initializer
                           | BindingPattern

    syntax SingleNameBinding ::= BindingIdentifier Initializer // optional Initializer
                                | BindingIdentifier

    syntax BindingRestElement ::= "..." BindingIdentifier
                               | "..." BindingPattern

    // 14.1 Function Definitions
    syntax FunctionDeclaration ::= "function" BindingIdentifier "(" FormalParameters ")" "{" FunctionBody "}"
                                 | "function" "(" FormalParameters ")" "{" FunctionBody "}"

    syntax FunctionExpression ::= "function" BindingIdentifier "(" FormalParameters ")" "{" FunctionBody "}"
                                | "function" "(" FormalParameters ")" "{" FunctionBody "}"

    syntax UniqueFormalParameters ::= FormalParameters

    syntax FormalParameters ::= "" // TODO: review if this means empty
                             | FunctionRestParameter
                             | FormalParameterList
                             | FormalParameterList ","
                             | FormalParameterList "," FunctionRestParameter

    syntax FormalParameterList ::= FormalParameter
                                | FormalParameterList "," FormalParameter

    syntax FunctionRestParameter ::= BindingRestElement

    syntax FormalParameter ::= BindingElement

    syntax FunctionBody ::= FunctionStatementList

    syntax FunctionStatementList ::= "" // TODO: verify empty
                                  | StatementList

    // 14.2 Arrow Function Definitions
    syntax ArrowFunction ::= ArrowParameters "=>" ConciseBody // TODO: no line terminator

    syntax ArrowParameters ::= BindingIdentifier
                            | CoverParenthesizedExpressionAndArrowParameterList

    syntax ConciseBody ::= ExpressionBody // TODO: handle lookahead
                        | "{" FunctionBody "}"

    syntax ExpressionBody ::= AssignmentExpression

    syntax CoverParenthesizedExpressionAndArrowParameterList ::= "todo::CoverParenthesizedExpressionAndArrowParameterList" // TODO: Handle supplemental syntax


    // 14.3 Method Definitions
    // TODO: Finish other methods
    syntax MethodDefinition ::= PropertyName "(" UniqueFormalParameters ")" "{" FunctionBody "}"
                            //  | GeneratorMethod
                            //  | AsyncMethod
                            //  | AsyncGeneratorMethod
                             | "get" PropertyName "(" ")" "{" FunctionBody "}"
                             | "set" PropertyName "(" PropertySetParameterList ")" "{" FunctionBody "}"

    syntax PropertySetParameterList ::= FormalParameter

    // 14.4 Generator Function Definitions
    syntax GeneratorMethod ::= "*" PropertyName "(" UniqueFormalParameters ")" "{" GeneratorBody "}"

    syntax GeneratorDeclaration ::= "function" "*" BindingIdentifier "(" FormalParameters ")" "{" GeneratorBody "}"
                                 | "function" "*" "(" FormalParameters ")" "{" GeneratorBody "}"

    syntax GeneratorExpression ::= "function" "*" BindingIdentifier "(" FormalParameters ")" "{" GeneratorBody "}" // optional BindingIdentifier
                                | "function" "*" "(" FormalParameters ")" "{" GeneratorBody "}"

    syntax GeneratorBody ::= FunctionBody

    syntax YieldExpression ::= "yield"
                            | "yield" AssignmentExpression // TODO: no line terminator
                            | "yield" "*" AssignmentExpression //TODO: no line terminator


    // 14.8 Async Arrow Function Definitions
    // TODO: no line terminator
    syntax AsyncArrowFunction ::= "async" AsyncArrowBindingIdentifier "=>" AsyncConciseBody
                               | CoverCallExpressionAndAsyncArrowHead "=>" AsyncConciseBody

    // TODO: handle lookahead
    syntax AsyncConciseBody ::= ExpressionBody
                            // TODO: handle AsyncFunctionBody
                            //   | "{" AsyncFunctionBody "}"

    syntax AsyncArrowBindingIdentifier ::= BindingIdentifier

    syntax CoverCallExpressionAndAsyncArrowHead ::= MemberExpression Arguments
    // TODO: handle supplemental syntax for Async Arrow Function 14.8
                        
endmodule