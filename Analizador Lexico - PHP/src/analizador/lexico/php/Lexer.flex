/* Codigo del usuario */
package analizador.lexico.php;

import static analizador.lexico.php.Token.*;

//Librerias JAVA
import java.io.BufferedWriter.*;
import java.io.FileWriter.*;
import java.io.IOException.*;
import java.util.ArrayList.*;

%%
/* Opciones y declaraciones */
%class LexicalScannerPHP
%unicode
%line
%column
%ignorecase
%type String


//Codigo Java

%init{ 
this.tokens = new ArrayList();
this.errores = new ArrayList();
this.fin = false;
%init}

%{

public ArrayList tokens; /* our variable for storing token's info that will be the output */
public ArrayList errores;
public boolean fin;

private String tokenRecordSet(String token){
    String[] parts = token.split("'");
    String tokenCorrecto = parts[0].toLowerCase() + "'" + parts[1].toUpperCase() + "'" + parts[2];
    return tokenCorrecto;
}

%}

//Macro Definition

//SIMBOLOS QUE UTILIZA PHP
Simbolos = "{" | "}" | ":" | ";" | "," | "(" | ")" | "." | "@" | "<>"

//ESPACIOS Y SALTOS

Espacios = (" ") | (\x09)
Saltos = (\n) | (\r) | (\n\r)

//PALABRAS RESERVADAS

Nulo = "null"
Etiquetas = "<?php" | "?>"
PalabrasReservadas = "__halt_compiler" | "abstract" | "array" | "as" | "callable" | "catch" | "class" |
                     "clone" | "const" | "die" | "echo" | "empty" | "enddeclare" | "eval" | "exit" |
                     "extends" | "final" | "finally" | "function" | "global" | "goto" | "implements" |
                     "include_once" | "instanceof" | "insteadof" | "interface" | "isset" | "list" |
                     "namespace" | "new" | "print" | "private" | "protected" | "public" | " require_once" |
                     "static" | "throw" | "trait" | "try" | "unset" | "use" | "var" | "yield"

//TIPOS

/*  Enteros */
Decimal = [1-9][0-9]* | 0
Octal = "0"[0-7]+
Binario = "0b"[01]+
Hexadecimal = "0"[xX][0-9a-fA-F]+

Integer = [+-]?{Decimal} | [+-]?{Octal} | [+-]?{Binario} | [+-]?{Hexadecimal}

/*  Reales  */
Lnum = [0-9]+
Dnum = ([0-9]*[\.]{Lnum}) |({Lnum}[\.][0-9]*)
Exponente = [+-]?(({Lnum} | {Dnum}) [eE][+-]?{Lnum})

Reales = {Lnum} | {Dnum} | {Exponente}

/*  Logicos */

Logicos = "true" | "false"

/*  Cadenas */
CadenasSimple = [\'][\x20-\xff\x0A\x0D\x09\x0B\x1B\x0C\\]{0,256}[\']
CadenasDobles = [\"][\x20-\xff\x0A\x0D\x09\x0B\x1B\x0C\\]{0,256}[\"]
Cadenas = {CadenasSimple} | {CadenasDobles}

//OPERADORES 

/*  Aritmeticos */
OpAritmeticos = "*" | "+" | "-" | "/" | "%" | "**"
/*  Logicos */
OpLogicos = "and" | "or" | "xor" | "!" | "&&" | "||"
/*  Otros   */
Asignacion = "="
OpBitaBit = "&" | "|" | "^" | "~" | "<<" | ">>"
OpComparacion = "==" | "===" | "!=" | "!==" | "<" | ">" | "<=" | ">=" | "<=>" | "??"
OpIncremento = "++" | "--"
OpCompuestos = {OpAritmeticos}{Asignacion} | {OpBitaBit}{Asignacion} | {Concatenacion}{Asignacion}

Operadores = {OpAritmeticos} | {OpLogicos} | {Asignacion} | {OpBitaBit} | {OpComparacion} | {OpIncremento} | {OpCompuestos}

/*  CONSTANTES  */
Identificador = [a-zA-Z_\x7f-\xff][a-zA-Z0-9_\x7f-\xff]*

/*  VARIABLES  */
Variables = [\$]{Identificador}

/* Variables predefinidas   */
VariablesSuperGlobales = ([\$])("GLOBALS" | "_SERVER" | "_GET" | "_POST" | "_FILES" | "_REQUEST" | "_SESSION" | "_ENV" | "_COOKIE" | "HTTP_RAW_POST_DATA") 
VariablesGlobalesMin = ([\$])("php_errormsg" | "http_response_header" | "argc" | "argv")

/*  Constantes predefinidas */
ConstantesReservadas = "__LINE__" | "__FILE__" | "__DIR__" | "__FUNCTION__" | "__CLASS__" | "__TRAIT__" | "__METHOD__" | "__NAMESPACE__"

/*  Estructuras de control  */

/* If-else  */
EstructuraIf = "if" | "endif" | "else" 
/*  Ciclo-While */
CicloWhile = "while" | "endwhile"
/*  Ciclo-Do-While */
CicloDoWhile = "do"
/*  Ciclo-For   */
CicloFor = "for" | "endfor"
/*  Foreach */
CicloForeach = "foreach" | "endforeach"
/* Switch */
EstructuraSwitch = "switch" | "case" | "default" | "endswitch"
/*  Sentencias de control de las estructuras     */
SentenciasControl = "break" | "continue" | "return" | "declare" | "include" | "require"

EstructurasControl = {EstructuraIf} | {CicloWhile} | {CicloDoWhile} | {CicloFor} | {CicloForeach} | {EstructuraSwitch} | {SentenciasControl}

/*	Comentarios	*/
Texto = [\x20-\xff\x09\x0D\x0A\x0B\x1B\x0C]*
Comentarios = "/*"{Texto}"*/" | "//"{Texto}[\x0A] | "#"{Texto}[\x0A]

/*  Campo de acceso a base de datos */
RecordSet = [\$]("recordset[")({CadenasSimple})("]")

%%

/* Lexical rules */

{Integer}                   {this.tokens.add(yytext());}
{Reales}                    {this.tokens.add(yytext());}
{Logicos}                   {this.tokens.add(yytext().toUpperCase());}
{Cadenas}                   {this.tokens.add(yytext());}
{Operadores}                {this.tokens.add(yytext());}
{Identificador}             {this.tokens.add(yytext());}
{Variables}                 {this.tokens.add(yytext());}
{VariablesSuperGlobales}    {this.tokens.add(yytext().toUpperCase());}
{VariablesGlobalesMin}      {this.tokens.add(yytext().toLowerCase());}
{ConstantesReservadas}      {this.tokens.add(yytext().toUpperCase());}
{EstructurasControl}        {this.tokens.add(yytext().toLowerCase());}
{Comentarios}               {this.tokens.add(yytext());}
{Espacios}                  {this.tokens.add(yytext());}
{Saltos}                    {this.tokens.add(yytext());}
{Nulo}                      {this.tokens.add(yytext().toUpperCase());}
{PalabrasReservadas}        {this.tokens.add(yytext().toLowerCase());}
{Etiquetas}                 {this.tokens.add(yytext().toLowerCase());}
{Simbolos}                  {this.tokens.add(yytext());}
{RecordSet}                 {this.tokens.add(this.tokenRecordSet(yytext()));}

.                           {this.errores.add("ERROR: [" + yyline + "," + yycolumn + "] Token: " + yytext());}

<< EOF >>                   {this.fin = true}