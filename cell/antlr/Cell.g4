grammar Cell;

importTable: importAction tableSource 'as' tableAlias;
importAction: 'import' 'table';
tableSource: STRING;
tableAlias: ID;

app: (formula END+)*
    ;

formula:
    | expr
    | importTable
    | assignValue
    | nomapNoreduce
    ;

assignValue:
    assignTarget '=' assignSource
    ;
assignTarget: ID( '.' ID )*;
assignSource:
    expr # AssignSourceByExpr
    | importAction tableSource # AssignSourceByTable
    | defineFunction # AssignSourceByFun
    | of # AssignSourceByOf
    | codeBlock # AssignSourceByBlock
    ;

// 函数
defineFunction: 'fun' functionSignature codeBlock;
callFunctionItem: functionSignature codeBlock?;
functionSignature: FUN '(' formula? endParam* ')' ;
endParam: ',' formula ;
codeBlock: '{' END* formula? (END+ formula END*)*  '}';

// of codeBlock
of: expr 'of' codeBlock ;

nomapNoreduce: remove | rename | move | move_end | write | filter | not_filter;

// remove
remove: 'remove' assignTarget;

// rename
rename: 'rename'  assignTarget 'to' STRING;

// move move_end move_start
move: 'move' assignTarget 'to' NUMBER;
move_end: 'move_end' assignTarget;

// write
write: 'write'  assignTarget 'to' STRING;

filter: 'filter'  assignTarget 'to' STRING;
not_filter: 'not_filter'  assignTarget 'to' STRING;

// 表达式
expr :
    '(' expr ')'                                                # Brackets
    | expr ('.' callFunctionItem?)+                  # CallFunctionChain
    | callFunctionItem                              # CallFunction
    | expr op=('++' | '--')                                     # IncreaseOrDecrease
    | op=('!' | '-' | '~' | '+') expr                           # SingleOperation
    | expr op=('*' | '/' | '%' | '//' | '\\\\' | '**' ) expr    # MulDiv
    | expr op=('+' | '-') expr                                  # AddSub
    | expr op=('<<' | '>>' | '>>>') expr                        # BitShift
    | expr op=('>=' | '<=' | '>' | '<' ) expr                   # Compare
    | expr op=('==' | '!=' | '===' ) expr                       # Equals
    | expr '&' expr                                             # BitAnd
    | expr '|' expr                                             # BitOr
    | expr '&&' expr                                            # LogicAnd
    | expr '||' expr                                            # LogicOr
    | expr op=( '->' | '<-' | '<->' | '<>') expr                # JoinTable
    | expr 'to' expr                                            # Pair
    | '[' expr (',' expr)* ']'                                  # ArrayByComma
    | assignTarget                                              # AssignTarget0
    | ID                                                        # ExprId
    | NUMBER                                                    # ExprNumber
    | SCIENTIFIC_NOTATION                                       # ScientificNotattion
    | BOOL                                                      # ExprBool
    | STRING                                                    # ExprString
    | DESC                                                      # DESC
    | ASC                                                       # ASC
    ;

// 运算符
NOT             : '!';
WAVE            : '~';  // 波浪wave

INCREASE        : '++';
DECREASE        : '--';
MUL             : '*';
DIV             : '/';
DEL             : '%';
FLOOR           : '//';  // 向下取整
CEIL            : '\\';  // 向上取整
POW             : '**';
ADD             : '+';
SUB             : '-';

LEFT_SHIFT      : '<<';
RIGHT_SHIFT     : '>>';
UNSIGNED_SHIFT  : '>>>';

GE              : '>=';
LE              : '<=';
GT              : '>';
LT              : '<';

EQUAL           : '==';
NOTEQUAL        : '!=';
IDENTICAL       : '===';

BIT_AND         : '&';
BIT_OR          : '|';

AND             : '&&';
OR              : '||';

DESC            : 'DESC';
ASC             : 'ASC';

NUMBER : Digit+ ('.' Digit+)?;
SCIENTIFIC_NOTATION : Digit+('.' Digit+)?('e'|'E')('-'|'+')?Digit+ ;

BOOL : 'true' | 'false';
STRING  : ('"'(ESC_QUOTES|ESC_BACKLASH|.)*?'"') | ('\''(ESC_SINGLE_QUOTES|ESC_BACKLASH|.)*?'\'');

FUN     : [_a-zA-Z][_a-zA-Z0-9]*;
ID      : '`' ( '``' | ~[`] )+ '`' ;

END     : '\r'?'\n' ;

WS      : [ \t]+ -> skip ;              // 丢弃空白字符
UNKNOWN_CHAR : . ;
fragment ESC_QUOTES : '\\"' ;
fragment ESC_BACKLASH : '\\\\' ;
fragment ESC_SINGLE_QUOTES : '\\\'' ;
fragment Digit : [0-9];
