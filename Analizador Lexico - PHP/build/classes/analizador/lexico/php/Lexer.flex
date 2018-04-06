/* Codigo del usuario */

package analizador.lexico.php;

//Librerias JAVA

import java.util.ArrayList;

class Yytoken{

    public int numToken;
    public String token;
    public int linea;
    public int columna;

    Yytoken(int numToken, String token, int linea, int columna){
        this.numToken = numToken;
        this.token = token;
        this.linea = linea;
        this.columna = columna;
    }

    public String toString(){
        return "Token No."+numToken+": Token: "+ token+ "\t[Linea: "+linea+", Columna: "+columna+"]";
    }
}

%%
/* Opciones y declaraciones */
%class LexicalScannerPHP
%public
%function nextToken
%unicode
%caseless
%ignorecase
%line
%column

//Codigo Java

%init{ 
this.tokens = new ArrayList<String>();
this.errores = new ArrayList<Yytoken>();
this.numeroTokens = 0;
%init}

%{

public ArrayList<String> tokens; /* our variable for storing token's info that will be the output */
public ArrayList<Yytoken> errores;
private int numeroTokens;

private String tokenRecordSet(String token){
    String[] parts = token.split("'");
    String tokenCorrecto = parts[0].toLowerCase() + "'" + parts[1].toUpperCase() + "'" + parts[2];
    return tokenCorrecto;
}

private String tokenMayuscula(String token){
    String result = token.toUpperCase();
    return result; 
}

private String tokenMinuscula(String token){
    String result = token.toLowerCase();
    return result;
}

%}

//Macro Definition

//SIMBOLOS QUE UTILIZA PHP
Simbolos = ("{")|("}")|(":")|(";")|(",")|("(")|(")")|(".")|("@")|("<>")|("[")|("]")|("^")

//ESPACIOS Y SALTOS

Espacios = (" ")|(\t)
Saltos = (\n)|(\r)|(\n\r)

//PALABRAS RESERVADAS

Nulo = "null"
Etiquetas = ("<?php")|("?>")|("<?")|("</")
PalabrasReservadas = ("__halt_compiler")|("abstract")|("array")|("as")|("callable")|("catch")|("class")|("clone")|("const")|("die")|("echo")|("empty")|("enddeclare")|("eval")|("exit")|("extends")|("final")|("finally")|("function")|("global")|("goto")|("implements")|("include_once")|("instanceof")|("insteadof")|("interface")|("isset")|("list")|("namespace")|("new")|("print")|("private")|("protected")|("public")|("require_once")|("static")|("throw")|("trait")|("try")|("unset")|("use")|("var")|("yield")

//TIPOS
/*  Enteros */
Decimal = ([1-9][0-9]*)|(0)
Octal = "0"[0-7]+
Binario = "0b"[01]+
Hexadecimal = "0"[xX][0-9a-fA-F]+
Integer = ([+-]?{Decimal})|([+-]?{Octal})|([+-]?{Binario})|([+-]?{Hexadecimal})
ErrorEnteroMasLetra = ("1a")

/*  Reales  */
Lnum = [0-9]+
Dnum = ([0-9]*[\.]{Lnum}) |({Lnum}[\.][0-9]*)
Exponente = [+-]?(({Lnum} | {Dnum}) [eE][+-]?{Lnum})
Reales = ({Lnum})|({Dnum})|({Exponente})

/*  Logicos */
Logicos = ("true")|("false")

/*  Cadenas */
Cadenas = ('([^'\\]|\\.)*')|(\"([^\"\\]|\\.)*\")
CadenaSimple = ('([^'\\]|\\.)*')

//OPERADORES 
/*  Aritmeticos */
OpAritmeticos = ("*")|("+")|("-")|("/")|("%")|("**")
/*  Logicos */
OpLogicos = ("and")|("or")|("xor")|("!")|("&&")|("||")
/*  Otros   */
Asignacion = "="
OpBitaBit = ("&")|("|")|("^")|("~")|("<<")|(">>")
OpComparacion = ("==")|("===")|("!=")|("!==")|("<")|(">")|("<=")|(">=")|("<=>")|("??")
OpIncremento = ("++")|("--")
Operadores = ({OpAritmeticos}|{OpLogicos}|{Asignacion}|{OpBitaBit}|{OpComparacion}|{OpIncremento})
ErrorOperador = "=!="

/*  CONSTANTES  */
Identificador = [a-zA-Z_\x7f-\xff][a-zA-Z0-9_\x7f-\xff]*

/*  VARIABLES  */
Variables = ([\$])({Identificador})

/* Variables predefinidas   */
VariablesSuperGlobales = ([\$])(("GLOBALS")|("_SERVER")|("_GET")|("_POST")|("_FILES")|("_REQUEST")|("_SESSION")|("_ENV")|("_COOKIE")|("HTTP_RAW_POST_DATA")) 
VariablesGlobalesMin = ([\$])(("php_errormsg")|("http_response_header")|("argc")|("argv"))

/*  Constantes predefinidas */
ConstantesReservadas = ("__LINE__")|("__FILE__")|("__DIR__")|("__FUNCTION__")|("__CLASS__")|("__TRAIT__")|("__METHOD__")|("__NAMESPACE__")|("__COMPILER_HALT_OFFSET__")
ConstantesDefinidas1 = ("PHP_VERSION")|("PHP_MAJOR_VERSION")|("PHP_MINOR_VERSION")|("PHP_RELEASE_VERSION")|("PHP_VERSION_ID")|("PHP_EXTRA_VERSION")|("PHP_ZTS")|("PHP_DEBUG")|("PHP_MAXPATHLEN")|("PHP_OS")|("PHP_OS_FAMILY")|("PHP_SAPI")|("PHP_EOL")|("PHP_INT_MAX")|("PHP_INT_MIN")|("PHP_INT_SIZE")|("PHP_FLOAT_DIG")|("PHP_FLOAT_EPSILON")|("PHP_FLOAT_MIN")|("PHP_FLOAT_MAX")|("DEFAULT_INCLUDE_PATH")|("PEAR_INSTALL_DIR")|("PEAR_EXTENSION_DIR")|("PHP_EXTENSION_DIR")|("PHP_PREFIX")|("PHP_BINDIR")|("PHP_BINARY")|("PHP_MANDIR")|("PHP_LIBDIR")|("PHP_DATADIR")|("PHP_SYSCONFDIR")|("PHP_LOCALSTATEDIR")|("PHP_CONFIG_FILE_SCAN_DIR")|("PHP_CONFIG_FILE_PATH")|("PHP_SHLIB_SUFFIX")|("PHP_FD_SETSIZE")
ConstantesDefinidas2 = ("E_ERROR")|("E_WARNING")|("E_PARSE")|("E_NOTICE")|("E_CORE_ERROR")|("E_CORE_WARNING")|("E_COMPILE_ERROR")|("E_COMPILE_WARNING")|("E_USER_ERROR")|("E_USER_WARNING")|("E_USER_NOTICE")|("E_DEPRECATED")|("E_USER_DEPRECATED")|("E_ALL")|("E_STRICT")
ConstantesDefinidas = {ConstantesDefinidas1}|{ConstantesDefinidas2}|{ConstantesReservadas}
/*  Estructuras de control  */
/* If-else  */
EstructuraIf = ("if")|("endif")|("else") 
/*  Ciclo-While */
CicloWhile = ("while")|("endwhile")
/*  Ciclo-Do-While */
CicloDoWhile = "do"
/*  Ciclo-For   */
CicloFor = ("for")|("endfor")
/*  Foreach */
CicloForeach = ("foreach")|("endforeach")
/* Switch */
EstructuraSwitch = ("switch")|("case")|("default")|("endswitch")
/*  Sentencias de control de las estructuras     */
SentenciasControl = ("break")|("continue")|("return")|("declare")|("include")|("require")

EstructurasControl = ({EstructuraIf}|{CicloWhile}|{CicloDoWhile}|{CicloFor}|{CicloForeach}|{EstructuraSwitch}|{SentenciasControl})

/*	Comentarios	*/
Texto2 = [\x20-\x29\x2B-\x2E\x30-\xff\x09\x0D\x0B\x1B\x0C]*
Comentarios = (("#")({Texto2})([("*/")|(\x0A)]?))|{Comment}

/* comments */
LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace     = {LineTerminator} | [ \t\f]
Comment = {TraditionalComment} | {EndOfLineComment} | {DocumentationComment}
TraditionalComment   = "/*" [^*] ~"*/" | "/*" "*"+ "/"
// Comment can be the last line of the file, without line terminator.
EndOfLineComment     = "//" {InputCharacter}* {LineTerminator}?
DocumentationComment = "/**" {CommentContent} "*"+ "/"
CommentContent       = ( [^*] | \*+ [^/*] )*
ErrorMultiLinea     = ["/*"]~(\n)

/*  Campo de acceso a base de datos */
RecordSet = ({Variables})("[")({CadenaSimple})("]")

%%

/* Lexical rules */

{PalabrasReservadas}        {numeroTokens++; this.tokens.add(this.tokenMinuscula(yytext())); return new Yytoken(numeroTokens, this.tokenMinuscula(yytext()), yyline, yycolumn);}
{VariablesSuperGlobales}    {numeroTokens++; this.tokens.add(this.tokenMayuscula(yytext())); return new Yytoken(numeroTokens, this.tokenMayuscula(yytext()), yyline, yycolumn);}
{VariablesGlobalesMin}      {numeroTokens++; this.tokens.add(this.tokenMinuscula(yytext())); return new Yytoken(numeroTokens, this.tokenMinuscula(yytext()), yyline, yycolumn);}
{ConstantesDefinidas}       {numeroTokens++; this.tokens.add(this.tokenMayuscula(yytext())); return new Yytoken(numeroTokens, this.tokenMayuscula(yytext()), yyline, yycolumn);}
{EstructurasControl}        {numeroTokens++; this.tokens.add(this.tokenMinuscula(yytext())); return new Yytoken(numeroTokens, this.tokenMinuscula(yytext()), yyline, yycolumn);}
{Etiquetas}                 {numeroTokens++; this.tokens.add(this.tokenMinuscula(yytext())); return new Yytoken(numeroTokens, this.tokenMinuscula(yytext()), yyline, yycolumn);}
{Simbolos}                  {numeroTokens++; this.tokens.add(yytext()); return new Yytoken(numeroTokens, yytext(), yyline, yycolumn);}
{Operadores}                {numeroTokens++; this.tokens.add(yytext()); return new Yytoken(numeroTokens, yytext(), yyline, yycolumn);}
{Integer}                   {numeroTokens++; this.tokens.add(yytext()); return new Yytoken(numeroTokens, yytext(), yyline, yycolumn);}
{Reales}                    {numeroTokens++; this.tokens.add(yytext()); return new Yytoken(numeroTokens, yytext(), yyline, yycolumn);}
{Logicos}                   {numeroTokens++; this.tokens.add(this.tokenMayuscula(yytext())); return new Yytoken(numeroTokens, this.tokenMayuscula(yytext()), yyline, yycolumn);}
{Cadenas}                   {numeroTokens++; this.tokens.add(yytext()); return new Yytoken(numeroTokens, yytext(), yyline, yycolumn);}
{Variables}                 {numeroTokens++; this.tokens.add(yytext()); return new Yytoken(numeroTokens, yytext(), yyline, yycolumn);}
{Comentarios}               {numeroTokens++; this.tokens.add(yytext()); return new Yytoken(numeroTokens, yytext(), yyline, yycolumn);}
{Espacios}                  {numeroTokens++; this.tokens.add(yytext()); return new Yytoken(numeroTokens, yytext(), yyline, yycolumn);}
{Saltos}                    {numeroTokens++; this.tokens.add(yytext()); return new Yytoken(numeroTokens, yytext(), yyline, yycolumn);}
{Nulo}                      {numeroTokens++; this.tokens.add(this.tokenMayuscula(yytext())); return new Yytoken(numeroTokens, this.tokenMayuscula(yytext()), yyline, yycolumn);}
{RecordSet}                 {numeroTokens++; this.tokens.add(this.tokenRecordSet(yytext())); return new Yytoken(numeroTokens, this.tokenRecordSet(yytext()), yyline, yycolumn);}
{Identificador}             {numeroTokens++; this.tokens.add(yytext()); return new Yytoken(numeroTokens, yytext(), yyline, yycolumn);}

{ErrorEnteroMasLetra}       {this.errores.add(new Yytoken(numeroTokens++, yytext(), yyline, yycolumn)); return new Yytoken(numeroTokens, yytext(), yyline, yycolumn);}
{ErrorOperador}             {this.errores.add(new Yytoken(numeroTokens++, yytext(), yyline, yycolumn)); return new Yytoken(numeroTokens, yytext(), yyline, yycolumn);}
{ErrorMultiLinea}           {this.errores.add(new Yytoken(numeroTokens++, yytext(), yyline, yycolumn)); return new Yytoken(numeroTokens, yytext(), yyline, yycolumn);}
.                           {this.errores.add(new Yytoken(numeroTokens++, yytext(), yyline, yycolumn)); return new Yytoken(numeroTokens, yytext(), yyline, yycolumn);}