module lang::objectilang::Implode

/*
 * Parser y conversion del arbol de sintaxis concreta (CST) al AST.
 */
 
import ParseTree;
import lang::objectilang::Syntax;
import lang::objectilang::AST;

public start[Program] parseObjectilang(str text) =
  parse(#start[Program], text);

public start[Program] parseObjectilang(loc file) =
  parse(#start[Program], file);

public AProgram loadAST(start[Program] tree) = implode(#AProgram, tree.top);

public AProgram loadAST(str text) = loadAST(parseObjectilang(text));

public AProgram loadAST(loc file) = loadAST(parseObjectilang(file));
