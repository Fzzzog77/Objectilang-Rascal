module src::main::rascal::lang::objectilang::Syntax

/*
 * Objectilang - sintaxis concreta (Proyecto 2, Grupo 13)
 *
 * Basada en la gramatica del Proyecto 1, con las correcciones descritas en
 * el documento "Cambios a la gramatica". Las anotaciones @category son las
 * que alimentan el resaltado de sintaxis en VS Code.
 *
 * Nota: las palabras reservadas (literales) se resaltan como keywords por
 * defecto; los tokens lexicos llevan su categoria explicita.
 */

// ---------------------------------------------------------------------------
// Layout (espacios y comentarios)
// ---------------------------------------------------------------------------

layout Layout = WhitespaceAndComment* !>> [\ \t\n\r] !>> "//" !>> "/*";

lexical WhitespaceAndComment
  = [\ \t\n\r]
  | @category="Comment" "//" ![\n]* $
  | @category="Comment" "/*" (![*] | [*] !>> [/])* "*/"
  ;

// ---------------------------------------------------------------------------
// Palabras reservadas
// ---------------------------------------------------------------------------

keyword Reserved
  = "object" | "extends" | "method" | "override" | "val" | "var" | "new"
  | "if" | "then" | "else" | "for" | "in" | "true" | "false"
  | "and" | "or" | "neg" | "print" | "println"
  ;

// ---------------------------------------------------------------------------
// Tokens
// ---------------------------------------------------------------------------

lexical Id
  = @category="Variable" ([a-zA-Z] [a-zA-Z0-9]* !>> [a-zA-Z0-9]) \ Reserved
  ;

lexical TypeName
  = @category="Type" ([a-zA-Z] [a-zA-Z0-9]* !>> [a-zA-Z0-9]) \ Reserved
  ;

lexical IntLit   = @category="Constant" [0-9]+ !>> [0-9];
lexical FloatLit = @category="Constant" [0-9]+ "." [0-9]+ !>> [0-9];

// Operador/palabra de los ciclos: "<-" o "in"
lexical Generator = "\<-" | "in" !>> [a-zA-Z0-9];

// Cadenas. Soportan interpolacion con ${ Expresion }.
// Se parten en trozos lexicos (como hace Rascal con sus propios strings):
//   "texto"                      -> StringPlain
//   "pre ${ e1 } mid ${ e2 } post" -> StringPre e1 StringMid e2 StringPost
lexical StringChar
  = ![\"\\$\n\r]
  | [$] !>> [{]
  | [\\] [\"\\nrt$]
  ;

lexical StringPlain = @category="Constant" "\"" StringChar* "\"";
lexical StringPre   = @category="Constant" "\"" StringChar* "${";
lexical StringMid   = @category="Constant" "}" StringChar* "${";
lexical StringPost  = @category="Constant" "}" StringChar* "\"";

// ---------------------------------------------------------------------------
// Programa y sentencias
// ---------------------------------------------------------------------------

start syntax Program
  = program: Statement*
  ;

syntax Statement
  = objectStmt: ObjectDef
  | methodStmt: MethodDef
  | valDecl: "val" Id TypeAnn? "=" Expression
  | varDecl: "var" Id TypeAnn? "=" Expression
  | ifStmt: "if" Expression "then" Body "else" Body
  | forEach: "for" "(" Id Generator Invocation ")" Body
  | forEachTuple: "for" "(" "(" {Id ","}+ ")" Generator Invocation ")" Body
  | forRange: "for" "(" Id "=" Expression "," Expression "," Id "++" ")" Body
  | printStmt: "print" "(" Expression? ")"
  | printlnStmt: "println" "(" Expression? ")"
  | exprStmt: Expression
  | emptyStmt: ";"
  ;

syntax Block
  = block: "{" Statement* "}"
  ;

// Cuerpo de if/for: un bloque o una unica sentencia
syntax Body
  = blockBody: Block
  | singleBody: Statement
  ;

// ---------------------------------------------------------------------------
// Objetos y metodos
// ---------------------------------------------------------------------------

syntax ObjectDef
  = objectDef: "object" Id Extension? TypeParams? Params? Block?
  ;

syntax Extension
  = extension: "extends" Id
  ;

syntax MethodDef
  = methodAssign: Id "." {Id "."}+ "=" "method" Params TypeAnn Block
  | methodDef: "method" Id? Params? TypeAnn? "=" Block
  | overrideDef: "override" Id? Params? TypeAnn? "=" Block
  ;

// Cuerpo de un objeto anonimo: new A(...) { method ... }
syntax ObjectBody
  = objectBody: "{" MethodDef* "}"
  ;

// ---------------------------------------------------------------------------
// Parametros y tipos
// ---------------------------------------------------------------------------

syntax Params
  = params: "(" {Param ","}* ")"
  ;

syntax Param
  = param: Id ":" TypeExpr
  ;

syntax TypeParams
  = typeParams: "[" {TypeParam ","}+ "]"
  ;

syntax TypeParam
  = invariant: TypeName
  | covariant: "+" TypeName
  | contravariant: "-" TypeName
  ;

syntax TypeArgs
  = typeArgs: "[" {TypeExpr ","}+ "]"
  ;

syntax TypeAnn
  = typeAnn: ":" TypeExpr
  ;

syntax TypeExpr
  = simpleType: TypeName
  | genericType: TypeName TypeArgs
  ;

// ---------------------------------------------------------------------------
// Expresiones
// ---------------------------------------------------------------------------

syntax Invocation
  = invocation: {Id "."}+ TypeArgs? CallArgs?
  ;

syntax CallArgs
  = callArgs: "(" {Expression ","}* ")"
  ;

syntax StringLit
  = plain: StringPlain
  | templateStr: StringPre StringTail
  ;

syntax StringTail
  = tailEnd: Expression StringPost
  | tailMore: Expression StringMid StringTail
  ;

syntax Expression
  = intLit: IntLit
  | floatLit: FloatLit
  | stringLit: StringLit
  | trueLit: "true"
  | falseLit: "false"
  | callExpr: Invocation
  | newObject: "new" Id TypeArgs? CallArgs? ObjectBody?
  | bracket "(" Expression ")"
  > negate: "-" Expression
  | logicalNot: "neg" Expression
  > right power: Expression "**" Expression
  > left ( multiply: Expression "*" Expression
         | divide: Expression "/" Expression
         | modulo: Expression "%" Expression
         )
  > left ( add: Expression "+" Expression
         | subtract: Expression "-" Expression
         )
  > non-assoc ( lessThan: Expression "\<" Expression
              | greaterThan: Expression "\>" Expression
              | lessEq: Expression "\<=" Expression
              | greaterEq: Expression "\>=" Expression
              | notEqual: Expression "\<\>" Expression
              | equals: Expression "=" Expression
              )
  > left andExpr: Expression "and" Expression
  > left orExpr: Expression "or" Expression
  ;
