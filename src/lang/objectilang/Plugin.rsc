module lang::objectilang::Plugin

/*
 * Registro del lenguaje en VS Code (extension Rascal).
 * Con esto los archivos *.obj se abren con resaltado de sintaxis y
 * muestran los errores de parseo.
 *
 * En el terminal de Rascal:
 *   import lang::objectilang::Plugin;
 *   main();
 */

import ParseTree;
import util::Reflective;
import util::LanguageServer;
import lang::objectilang::Syntax;

private str LANG_NAME = "Objectilang";
private str LANG_EXT = "obj";

private Tree (str _input, loc _origin) objectilangParser() {
  return ParseTree::parser(#start[Program]);
}

set[LanguageService] objectilangLanguageServer() = {
  parsing(objectilangParser(), usesSpecialCaseHighlighting = false)
};

void main() {
  PathConfig pcfg =
    getProjectPathConfig(|project://objectilang|, mode=interpreter_external());

  registerLanguage(
    language(pcfg, LANG_NAME, {LANG_EXT},
             "lang::objectilang::Plugin", "objectilangLanguageServer")
  );
}
