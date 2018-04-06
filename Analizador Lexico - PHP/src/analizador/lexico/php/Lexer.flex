/* Codigo del usuario */

package analizador.lexico.php;

//Librerias JAVA

import java.util.ArrayList;

class Yytoken{

    public int numToken;
    public String token;
    public String tipo;
    public int linea;
    public int columna;

    Yytoken(int numToken, String token, String tipo, int linea, int columna){
        this.numToken = numToken;
        this.token = token;
        this.tipo = tipo;
        this.linea = linea;
        this.columna = columna;
    }

    public String toString(){
        return "Token: No."+numToken+": "+token+" Tipo: "+tipo+" ["+linea+","+columna+"]";
    }
}

%%
/* Opciones y declaraciones */
%class LexicalScannerPHP
%public
%function nextToken
%unicode
%ignorecase
%line
%column

//Codigo Java

%init{ 
this.tokens = new ArrayList<String>();
this.errores = new ArrayList<String>();
%init}

%eof{

    for(int i = 0; i < tokens.size(); i++){
        System.out.println(tokens.get(i));
    }

%eof}

%{

public ArrayList<String> tokens; /* our variable for storing token's info that will be the output */
public ArrayList<String> errores;

private String tokenRecordSet(String token){
    String[] parts = token.split("'");
    String tokenCorrecto = parts[0].toLowerCase() + "'" + parts[1].toUpperCase() + "'" + parts[2];
    return tokenCorrecto;
}

private String tokenMayuscula(String token){
    return token.toUpperCase();
}

private String tokenMinuscula(String token){
    return token.toLowerCase();
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
Etiquetas = ("<?php")|("?>")
PalabrasReservadas = ("__halt_compiler")|("abstract")|("array")|("as")|("callable")|("catch")|("class")|("clone")|("const")|("die")|("echo")|("empty")|("enddeclare")|("eval")|("exit")|("extends")|("final")|("finally")|("function")|("global")|("goto")|("implements")|("include_once")|("instanceof")|("insteadof")|("interface")|("isset")|("list")|("namespace")|("new")|("print")|("private")|("protected")|("public")|("require_once")|("static")|("throw")|("trait")|("try")|("unset")|("use")|("var")|("yield")

//TIPOS
/*  Enteros */
Decimal = ([1-9][0-9]*)|(0)
Octal = "0"[0-7]+
Binario = "0b"[01]+
Hexadecimal = "0"[xX][0-9a-fA-F]+
Integer = ([+-]?{Decimal})|([+-]?{Octal})|([+-]?{Binario})|([+-]?{Hexadecimal})

/*  Reales  */
Lnum = [0-9]+
Dnum = ([0-9]*[\.]{Lnum}) |({Lnum}[\.][0-9]*)
Exponente = [+-]?(({Lnum} | {Dnum}) [eE][+-]?{Lnum})
Reales = ({Lnum})|({Dnum})|({Exponente})

/*  Logicos */
Logicos = ("true")|("false")

/*  Cadenas */
CadenasSimple = ['][\x20-\xff\x0A\x0D\x09\x0B\x1B\x0C\\]{0,256}[']
CadenasDobles = [\"][\x20-\xff\x0A\x0D\x09\x0B\x1B\x0C\\]{0,256}[\"]
Cadenas = ({CadenasSimple})|({CadenasDobles})

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

/*  CONSTANTES  */
Identificador = [a-zA-Z_\x7f-\xff][a-zA-Z0-9_\x7f-\xff]*

/*  VARIABLES  */
Variables = ([\$])({Identificador})

/* Variables predefinidas   */
VariablesSuperGlobales = ([\$])(("GLOBALS")|("_SERVER")|("_GET")|("_POST")|("_FILES")|("_REQUEST")|("_SESSION")|("_ENV")|("_COOKIE")|("HTTP_RAW_POST_DATA")) 
VariablesGlobalesMin = ([\$])(("php_errormsg")|("http_response_header")|("argc")|("argv"))

/*  Constantes predefinidas */
ConstantesReservadas = ("__LINE__")|("__FILE__")|("__DIR__")|("__FUNCTION__")|("__CLASS__")|("__TRAIT__")|("__METHOD__")|("__NAMESPACE__")

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
Texto = [\x20-\xff\x09\x0D\x0A\x0B\x1B\x0C]*
Comentarios = (("/*")({Texto})("*/"))|(("//")({Texto})([\x0A]))|(("#")({Texto})([\x0A]))

/*  Campo de acceso a base de datos */
RecordSet = ([\$])("recordset[")({CadenasSimple})("]")

%%

/* Lexical rules */

{Integer}                   {this.tokens.add(yytext());}
{Reales}                    {this.tokens.add(yytext());}
{Logicos}                   {this.tokens.add(this.tokenMayuscula(yytext()));}
{Cadenas}                   {this.tokens.add(yytext());}
{Operadores}                {this.tokens.add(yytext());}
{Identificador}             {this.tokens.add(yytext());}
{Variables}                 {this.tokens.add(yytext());}
{VariablesSuperGlobales}    {this.tokens.add(this.tokenMayuscula(yytext()));}
{VariablesGlobalesMin}      {this.tokens.add(this.tokenMinuscula(yytext()));}
{ConstantesReservadas}      {this.tokens.add(this.tokenMayuscula(yytext()));}
{EstructurasControl}        {this.tokens.add(this.tokenMinuscula(yytext()));}
{Comentarios}               {this.tokens.add(yytext());}
{Espacios}                  {this.tokens.add(yytext());}
{Saltos}                    {this.tokens.add(yytext());}
{Nulo}                      {this.tokens.add(this.tokenMayuscula(yytext()));}
{PalabrasReservadas}        {this.tokens.add(this.tokenMinuscula(yytext()));}
{Etiquetas}                 {this.tokens.add(this.tokenMinuscula(yytext()));}
{Simbolos}                  {this.tokens.add(yytext());}
{RecordSet}                 {this.tokens.add(this.tokenRecordSet(yytext()));}

.                           {this.errores.add("ERROR: [" + yyline + "," + yycolumn + "] Token: " + yytext());}