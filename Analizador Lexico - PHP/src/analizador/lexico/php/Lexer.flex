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
%type String

//Codigo Java

%init{ 
this.tokensList = new ArrayList();
%init}

%{

private ArrayList tokensList; /* our variable for storing token's info that will be the output */

private void writeOutputFile() throws IOException { /* our method for writing the output file */
	String filename = "file.out";
	BufferedWriter out = new BufferedWriter(new FileWriter(filename));
	for (String s:this.tokensList) {
		System.out.println(s);
		out.write(s + "\n");
	}
	out.close();
}

%}

//Macro Definition

//PALABRAS RESERVADAS

Nulo = [nN][uU][lL][lL]
Etiquetas = "<?"[pP][hH][pP] | "?>"
PalabrasReservadas = [pP][rR][iI][vV][aA][tT][eE] | [pP][uU][bB][lL][iI][cC] |[aA][sS] | [cC][lL][aA][sS][sS] |
					[eE][cC][hH][oO] | [pP][rR][iI][nN][tT] | [gG][oO][tT][oO] | [tT][rR][yY] | [sS][tT][aA][tT][iI][cC] |
					[pP][rR][oO][tT][eE][cC][tT][eE][dD] | [nN][eE][wW] | [vV][aA][rR] | [cC][aA][tT][cC][hH] |
					[aA][bB][sS][tT][rR][aA][cC][tT] | [cC][lL][oO][nN][eE] | [cC][oO][nN][sS][tT] | [eE][nN][dD][fF][oO][rR] |
					[fF][iI][nN][aA][lL] | [gG][lL][oO][bB][aA][lL] | [iI][mM][pP][lL][eE][mM][eE][nN][tT][sS] |
					[iI][nN][cC][lL][uU][dD][eE] | [iI][nN][tT][eE][rR][fF][aA][sS][eE] | [tT][hH][rR][oO][wW] | [uU][sS][eE] |
					

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

/*  Logicos */

Verdadero = [tT][rR][uU][eE]
Falso = [fF][aA][lL][sS][eE]

/*  Cadenas */
Cadenas = [\x20-\xff]{0,256}

//OPERADORES 

/*  Aritmeticos */

OpAritmeticos = "*" | "+" | "-" | "/" | "%" | "**"

/*  Logicos */
OpLogicos = [aA][nN][dD]] | [oO][rR] | [xX][oO][rR] | "!" | "&&" | "||"

/*  Otros   */
Asignacion = "="
Concatenacion = "."
OpBitaBit = "&" | "|" | "^" | "~" | "<<" | ">>"
OpComparacion = "==" | "===" | "!=" | "!==" | "<" | ">" | "<=" | ">=" | "<=>" | "??"
OpControlError = "@"
OpIncremento = "++" | "--"
OpTipo = [iI][nN][sS][tT][aA][nN][cC][eE][oO][fF]
OpArray = "<>"
OpCompuestos = {OpAritmeticos}{Asignacion} | {OpBitaBit}{Asignacion} | {Concatenacion}{Asignacion}

/*  CONSTANTES  */

IdConstantes = [a-zA-Z_\x7f-\xff][a-zA-Z0-9_\x7f-\xff]*

/*  VARIABLES  */

Variables = [$]{IdConstantes}

/* Variables predefinidas   */

VariablesSuperGlobales= ([$])([gG][lL][oO][bB][aA][lL][sS] | [_][sS][eE][rR][vV][eE][rR] | [_][gG][eE][tT] | [_][pP][oO][sS][tT] | [_][fF][iI][lL][eE][sS] | [_][cC][oO][oO][kK][iI][eE] | [_][sS][eE][sS][sS][iI][oO][nN] | [_][rR][eE][qQ][uU][eE][sS][tT] | [_][eE][nN][vV]) 
OtrasVariablesM = ([$])([hH][tT][tT][pP][_][rR][aA][wW][_][pP][oO][sS][tT][_][dD][aA][tT][aA])
OtrasVariablesm = ([$])([pP][hH][pP][_][eE][rR][rR][oO][rR][mM][sS][gG] | [hH][tT][tT][pP][_][rR][eE][sS][pP][oO][nN][sS][eE][_][hH][eE][aA][dD][eE][rR] | [aA][rR][gG][cC] | [aA][rR][gG][vV])

/*  Estructuras de control  */

SimbolosLlaves = "{" | "}" | ":"
SimbolosParentesis = "(" | ")"

/* If-else  */
EstructuraIf = [iI][fF] | [eE][nN][dD][iI][fF]
EstructuraElse = [eE][lL][sS][eE]
EstructuraElseIf = {EstructuraElse}{EstructuraIf} | {EstructuraElse}[" "]{EstructuraIf}

/*  Ciclo-While */
CicloWhile = [wW][hH][iI][lL][eE] | [eE][nN][dD][wW][hH][iI][lL][eE]

/*  Ciclo-Do-While */
CicloDoWhile = [dD][oO]

/*  Ciclo-For   */
CicloFor = [fF][oO][rR]

/*  Foreach */
CicloForeach = {CicloFor}[eE][aA][cC][hH]

/* Switch */
EstructuraSwitch = [sS][wW][iI][tT][cC][hH] | [cC][aA][sS][eE] | [dD][eE][fF][aA][uU][lL][tT] | [eE][nN][dD][sS][wW][iI][tT][cC][hH]

/*  Sentencias de control de las estructuras     */

SentenciasControl = [bB][rR][eE][aA][kK] | [cC][oO][nN][tT][iI][nN][uU][eE] | [rR][eE][tT][uU][rR][nN] | [dD][eE][cC][lL][aA][rR][eE] | [iI][nN][cC][lL][uU][dD][eE]  [rR][eE][qQ][uU][iI][rR][eE]

/*	FUNCIONES	*/

ERFunciones = [fF][uU][nN][cC][tT][iI][oO][nN]

/*	Comentarios	*/

Texto = [\x20-\xff\x09\x0D]*
Comentarios = "/*"{Texto}"*/" | "//"{Texto}[\x0A] | "#"{Texto}[\x0A]

%%

/* Lexical rules */


{Integer} {}
