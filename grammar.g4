grammar ModeltestDSL;

testSuite       : (testDefinition)* EOF ;

testDefinition  : 'test' IDENTIFIER '{' statement* '}' ;

statement
    : assertStatement ';'
    | variableDeclaration ';'
    | expression ';'
    ;

variableDeclaration
    : IDENTIFIER IDENTIFIER '=' expression
    ;

assertStatement
    : 'assert' booleanExpr ( '|' STRING_LITERAL )?
    ;

booleanExpr
    : booleanAndExpr ( '||' booleanAndExpr )*
    ;

booleanAndExpr
    : booleanAtomExpr ( '&&' booleanAtomExpr )*
    ;

booleanAtomExpr
    : 'inconsistency'                           # InconsistencyExpr
    | 'exists' expression                       # ExistsExpr
    | expression '==' expression                # EqualsExpr
    | expression '!=' expression                # NotEqualsExpr
    ;

expression
    : IDENTIFIER ('.' expression)*
    | functionCall ('.' expression)*
    | STRING_LITERAL
    | INT_LITERAL
    ;

functionCall
    : IDENTIFIER '(' (variable (',' variable)*)? ')'
    ;

variable
    : expression
    | STRING_LITERAL
    ;

IDENTIFIER       : [A-Z_a-z][A-Z_a-z0-9]* ;
STRING_LITERAL   : '"' (~["\\] | '\\' .)* '"' ;
INT_LITERAL      : [0-9]+ ;

WS               : [ \t\r\n]+ -> skip ;
COMMENT          : '//' ~[\r\n]* -> skip ;