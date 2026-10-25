module lang::objectilang::Tests

import ParseTree;
import Exception;
import lang::objectilang::AST;
import lang::objectilang::Implode;

bool parses(str src) {
  try {
    parseObjectilang(src);
    return true;
  } catch ParseError(_): {
    return false;
  }
}

test bool tVal() = parses("val x: Int = 1 + 2 * 3");

test bool tVar() = parses("var y = 2.5");

test bool tNegativoEnDeclaracion() = parses("val x = -2");

test bool tNegativoComoExpresion() =
  parses("method f(): Int = { -2 }");

test bool tObject() =
  parses("object A extends B [+T, -U] (x: Int, y: String) { val z = x }");

test bool tParametroValObjeto() =
  parses("object List [+A](val item : A)");

test bool tObjectSinCuerpo() = parses("object A");

test bool tMetodoSinIgual() =
  parses("method main { val x = 1 }");

test bool tImplodeMetodoSinIgual() =
  program([methodStmt(methodDef(["main"], [], [],
    block([valDecl("x", [], intLit(1))])))]) :=
      loadAST("method main { val x = 1 }");

test bool tMetodos() =
  parses("method f(x: Int): Int = { x + 1 }\noverride g = { 1 }");

test bool tMetodoAsignado() =
  parses("c.inc = method(step: Int): Int { step + 1 }");

test bool tMetodoAsignadoSinTipo() =
  parses("c.inc = method(step: Int) { step + 1 }");

test bool tIf() =
  parses("if a = b then println(\"si\") else println(\"no\")");

test bool tForRango() = parses("for (i = 0, i \< 10, i++) println(i)");

test bool tForEach() = parses("for (x \<- xs) println(x)");

test bool tForTupla() = parses("for ((k, v) in pairs) { println(k) }");

test bool tNew() =
  parses("val o = new A[Int](1, 2) { method m(): Int = { 1 } }");

test bool tInterpolacion() =
  parses("println(\"a ${x} b ${y.z(1)} c\")");

test bool tComentarios() =
  parses("// linea\nval a = 1 /* bloque */ val b = 2");

test bool tRechazaValSinNombre() = !parses("val = 3");

test bool tRechazaReservada() = !parses("val if = 3");

test bool tPrecedencia() =
  program([valDecl("x", [],
    add(intLit(1), multiply(intLit(2), intLit(3))))]) :=
      loadAST("val x = 1 + 2 * 3");

test bool tAsociatividadIzquierda() =
  program([valDecl("x", [],
    subtract(subtract(intLit(1), intLit(2)), intLit(3)))]) :=
      loadAST("val x = (1 - 2 - 3)");
