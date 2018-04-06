# MiniPHP

## Descripcion

**MiniPHP** Es un escáner léxico para el lenguaje de programación PHP (Hypertext Preprocessor).
Su función basicamente es reconocer tokens segun el orden de lectura del archivo, si el token es 
valido el programa lo escribira de la manera correcta si este lo requiriera, y por lo contrario
si el token no es válido será agregado a la lista de errores. Estas funciones se realizan a traves
de expresiones regulares implementedas en un metacompilador que genera analizadores léxicos en base
a ellas, se hizo uso del metacompilador JFLEX que implementa el analizador en código de JAVA.

## Requerimientos del software

Para el correcto funcionamiento del programa **MiniPHP** es necesario contar con la Virtual Machine de
Java instalada en la PC:

 - Si no se tiene instalado puede descargarlo de la página oficial https://www.java.com/en/download/

## ¿Comó utilizar el software?

El algoritmo que describe el funcionamiento del software es el siguiente:
 1. Ejecutar la aplicación .Jar.
 2. Cargar un archivo con código PHP (.php).
 3. Analizar el código para válidar los tokens.
 4. Si el archivo esta lexicamente correcto se mostrará en pantalla el código escrito 
 correctamente y a la vez se generará un archivo (.out) con las correcciones realizadas.
 5. Si el archivo contiene errore léxicos se mostrarán en pantalla dichos errores y
 se generará un archivo (.out) el cual contiene los errores encontrados.
 
 **Nota** Es importante recalcar que previamente el analizador léxico tuvo que haber sido compilado.
 
### Ejecutar la aplicación

#### Clikeando sobre el icono de la aplicación
	
Una vez tenga la carpeta del proyecto dirigase a la carpeta _Analizador Lexico - PHP_ una vez este dentro
de esta carpeta dirigase a la carpeta _dist_ y dentro de esta carpeta encontrará el archivo llamado
_MiniPHP.jar_, para ejecutarlo pulse doble-click sobre este archivo.

La ruta relativa del archivo ejecutable es:
```
\Analizador Lexico - PHP\dist\MiniPHP.jar
```
	
#### Consola
	
Debe ubicarse donde se encuentre la carpeta del programa, una vez dentro de ella ejecute el siguiente comando:
```
java -jar Analizador Lexico - PHP\dist\MiniPHP.jar
```

Una vez se ejecutado el programa se mostrará la siguiente pantalla:

![MiniPHP](https://image.ibb.co/jTeNBc/MiniPHP.jpg)

### Cargar Archivo PHP

Para cargar un archivo con código PHP:
1. Dirigase al boton **Cargar Archivo PHP**
2. Presione click sobre este boton 

![MiniPHP-Cargar](https://image.ibb.co/iYHLxH/Mini_PHP_Cargar1.jpg)

Se mostrará el manejador de carpetas y archivos, en esta pantalla tendra que buscar y 
seleccionar el archivo **(.php)** deseado.

![MiniPHP-Cargar2](https://image.ibb.co/hQE0xH/Mini_PHP_Cargar2.jpg)

### Analizar El Archivo PHP

Para analizar un archivo PHP:
1. Dirigase al boton **Analizar Archivo**
2. Presione click sobre este boton 

![MiniPHP-Analizar1](https://image.ibb.co/i7g2Bc/Mini_PHP_Analizar1.jpg)

Esto inicializará el analisis del archivo cargado anteriormente y una vez este finalice
le pedira que seleccione una ubicación para almacenar el archivo de salida(.out).

![MiniPHP-Analizar2](https://image.ibb.co/jcYPrc/Mini_PHP_Analizar2.jpg)

Una vez seleccionada la ubicación de destino del archivo presione el boton **Guardar**

![MiniPHP-Analizar3](https://image.ibb.co/d2gYjx/Mini_PHP_Analizar3.jpg)

Despues de guardar su archivo correspondiente, se mostrará el contenido de este archivo (.out)
en el área de texto correspondiente ya sea una salida de Errores o una salida con el código correcto.

![MiniPHP2](https://image.ibb.co/h2knBc/MiniPHP2.jpg)

### *Compilar Analizador Léxico

Cabe recalcar que esta función está unicamente disponible para el desarrollador, puesto que para la 
ejecución correcta del software es necesario el analizador léxico ya compilado. Por lo tanto el 
botón **Compilar Archivo Flex** se encontrará deshabilitado.

![MiniPHP3](https://image.ibb.co/gNGG4x/MiniPHP3.jpg)

## Manejo De Errores

Para el manejo de errores se hizo uso de la expresion '.' de JFLEX, esta expresion regular se caracteriza
por ejecutarse cuando ninguna expresion regular coincidio con el token actual por lo que esta fuera del
lenguaje se podria decir. La acción que se realiza es de agregar el error a una lista, detallando el token,
numero de linea y numero de columna donde ocurrio el error.

```
.	{this.errores.add(new Yytoken(numeroTokens++, yytext(), yyline, yycolumn)); return new Yytoken(numeroTokens++, yytext(), yyline, yycolumn);}
```

## Opinion del Autor

A mi criterio el software **MiniPHP** desarrollado por mi persona, funciona de manera correcta puesto que
se realizaron distintas pruebas para verificar que no generará problemas al momento de ejecutarlo en cualquier
PC, además su correcto funcionamiento tambien abarca la exactitud léxica que posee para analizar los archivos
escritos en PHP, se escribieron expresiones regulares bastante grandes que tratan de abarcar la mayor cantidad
de casos posibles, se hizo una investigación profunda respecto al lenguaje PHP para abarcar los casos muy 
especificos que pudiera presentar.

## Información del Autor
	
**Bryan Macario Coronado**

_Estudiante de ingeniería en informática y sistemas_

_Universidad Rafael Landivar_

