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

PathConfig pcfg = getProjectPathConfig(|project://objectilang|);

Language objectilangLang =
  language(pcfg, "Objectilang", "obj", "lang::objectilang::Plugin", "contribs");

set[LanguageService] contribs() = {
  parser(Tree (str input, loc origin) {
    return parse(#start[Program], input, origin);
  })
};

int main() {
  registerLanguage(objectilangLang);
  return 0;
}
