# Objectilang – Proyecto 2 (Grupo 13)

Proyecto Rascal con la sintaxis concreta (con resaltado de sintaxis) y la sintaxis abstracta (AST) de Objectilang.

## Estructura

```
objectilang/
├── pom.xml                         (dependencia de Rascal)
├── META-INF/RASCAL.MF
├── examples/ejemplo1.obj           (programa de prueba)
└── src/main/rascal/lang/objectilang/
    ├── Syntax.rsc                  gramática concreta + categorías de resaltado
    ├── AST.rsc                     sintaxis abstracta
    ├── Implode.rsc                 parseObjectilang(...) y loadAST(...)
    ├── Plugin.rsc                  registro del lenguaje en VS Code (*.obj)
    └── Tests.rsc                   pruebas (parseo y forma del AST)
```

## Cómo usarlo

1. Abrir la carpeta `objectilang` en VS Code con la extensión **Rascal MPL**.
2. En el terminal de Rascal:
   ```
   import lang::objectilang::Plugin;
   main();                          // registra el lenguaje: *.obj con resaltado
   import lang::objectilang::Implode;
   loadAST(|project://objectilang/examples/ejemplo1.obj|);
   import lang::objectilang::Tests;
   :test
   ```
3. Abrir `examples/ejemplo1.obj`: debe verse con colores y sin errores.

## Notas de versión

- Probado con la estructura de proyecto basada en `pom.xml` (`src/main/rascal`). Si su curso usa la estructura antigua (carpeta `src/`), muevan `lang/` a `src/` y ajusten `Source:` en `META-INF/RASCAL.MF`.
- Si cambian de versión de Rascal, en versiones recientes `parser(...)` en `Plugin.rsc` puede llamarse `parsing(...)`.
- Las partes opcionales (`X?`) se representan en el AST como `list[X]` con 0 o 1 elemento.
