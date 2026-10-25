# Cambios realizados a la gramática de Objectilang

Este documento registra los ajustes hechos en `src/lang/objectilang/Syntax.rsc`
durante la integración y las pruebas del ejemplo `examples/ejemplo1.obj`.

## Cambios para admitir el ejemplo del proyecto

### Parámetros `val` en objetos

La forma anterior de `Param` solo aceptaba `nombre: Tipo`. Se agregó una
alternativa para permitir parámetros de constructor escritos como `val`, por
ejemplo:

```objectilang
object List [+A](val item: A)
```

La nueva alternativa es `valParam: "val" Id ":" TypeExpr`. También se agregó el
constructor `valParam` a `AParam` en `AST.rsc`, para que la conversión al AST
conserve si el parámetro tenía el modificador `val`.

### Métodos sin `=`

La forma anterior de `methodDef` exigía `=` antes del bloque. Se hizo opcional
para aceptar métodos con la forma usada en el ejemplo:

```objectilang
method main {
  val x = 1
}
```

La producción `overrideDef` y la asignación de métodos mantienen sus propias
reglas; este cambio solo afecta a `methodDef`.

## Ajustes de sintaxis concreta y pruebas

- Los operadores de comparación `<`, `>`, `<=`, `>=` y `<>` se escriben
  escapados en Rascal (`"\<"`, `"\>"`, `"\<="`, `"\>="` y `"\<\>"`) para que se
  interpreten como operadores literales de Objectilang.
- La producción de paréntesis se etiqueta `bracket` para que los paréntesis
  agrupen expresiones sin introducir un constructor adicional en el AST.
- Las pruebas de precedencia comparan la estructura del AST mediante patrones,
  en vez de comparar también las anotaciones de ubicación de origen.
- La prueba de asociatividad usa `val x = (1 - 2 - 3)`. Como Objectilang permite
  sentencias consecutivas sin separador, `val x = 1 - 2` puede ser ambiguo:
  después de la expresión `1`, `-2` también puede interpretarse como otra
  sentencia de expresión. Los paréntesis evitan esa ambigüedad en la prueba;
  **no cambian ni resuelven esa ambigüedad en la gramática base**.

## Elementos que no se cambiaron

- No se añadieron reglas ni no-terminales para resolver la ambigüedad entre
  resta y una sentencia que comienza con negación unaria.
- No se añadieron filtros `prefer`/`avoid` al parser.
- No se modificó la gramática para aceptar asignaciones generales; el proyecto
  indica que Objectilang no tiene reasignación.

## Pruebas relacionadas

`src/lang/objectilang/Tests.rsc` incluye casos para parámetros `val` en
objetos, métodos sin `=`, precedencia, asociatividad y expresiones negativas.
Para validar los cambios desde el REPL de Rascal:

```rascal
import lang::objectilang::Tests;
:test
```
