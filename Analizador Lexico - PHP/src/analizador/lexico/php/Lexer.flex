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

Verdadero = "true" | "TRUE" | "True"    //[tT][rR][uU][eE]
Falso = "false" | "FALSE"   | "False"   //[fF][aA][lL][sS][eE]

%%

/*  Cadenas */


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

/* Lexical rules */

{Integer} {}
