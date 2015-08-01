// RUN: %target-swift-frontend(mock-sdk: %clang-importer-sdk) -parse -I %S/Inputs/custom-modules %s -import-underlying-module -verify

// REQUIRES: objc_interop

import CoreCooling

func testSomeClass(sc: SomeClass, osc: SomeClass?) {
  var ao1: AnyObject = sc.methodA(osc)
  if sc.methodA(osc) == nil { } // expected-error{{binary operator '==' cannot be applied to operands of type 'AnyObject' and 'NilLiteralConvertible'}}

  var ao2: AnyObject = sc.methodB(nil)
  if sc.methodA(osc) == nil { } // expected-error{{binary operator '==' cannot be applied to operands of type 'AnyObject' and 'NilLiteralConvertible'}}

  var ao3: AnyObject = sc.property // expected-error{{value of optional type 'AnyObject?' not unwrapped; did you mean to use '!' or '?'?}}
  var ao3_ok: AnyObject? = sc.property // okay

  var ao4: AnyObject = sc.methodD()
  if sc.methodD() == nil { } // expected-error{{binary operator '==' cannot be applied to operands of type 'AnyObject' and 'NilLiteralConvertible'}}

  sc.methodE(sc)
  sc.methodE(osc) // expected-error{{value of optional type 'SomeClass?' not unwrapped; did you mean to use '!' or '?'?}}

  sc.methodF(sc, second: sc)
  sc.methodF(osc, second: sc) // expected-error{{value of optional type 'SomeClass?' not unwrapped; did you mean to use '!' or '?'?}}
  sc.methodF(sc, second: osc) // expected-error{{value of optional type 'SomeClass?' not unwrapped; did you mean to use '!' or '?'?}}

  sc.methodG(sc, second: sc)
  sc.methodG(osc, second: sc) // expected-error{{value of optional type 'SomeClass?' not unwrapped; did you mean to use '!' or '?'?}}
  sc.methodG(sc, second: osc) 

  let ci: CInt = 1
  var sc2 = SomeClass(int: ci)
  var sc2a: SomeClass = sc2
  if sc2 == nil { } // expected-error{{binary operator '==' cannot be applied to operands of type 'SomeClass' and 'NilLiteralConvertible'}}

  var sc3 = SomeClass(double: 1.5)
  if sc3 == nil { } // okay
  var sc3a: SomeClass = sc3 // expected-error{{value of optional type 'SomeClass?' not unwrapped}}

  var sc4 = sc.returnMe()
  var sc4a: SomeClass = sc4
  if sc4 == nil { } // expected-error{{binary operator '==' cannot be applied to operands of type 'SomeClass' and 'NilLiteralConvertible'}}
}

// Nullability with CF types.
func testCF(fridge: CCRefrigerator) {
  CCRefrigeratorOpenDoSomething(fridge) // okay
  CCRefrigeratorOpenDoSomething(nil) // expected-error{{nil cannot be used in context expecting type 'CCRefrigerator'}}

  CCRefrigeratorOpenMaybeDoSomething(fridge) // okay
  CCRefrigeratorOpenMaybeDoSomething(nil) // okay

  CCRefrigeratorOpenMaybeDoSomething(5) // expected-error{{cannot convert value of type 'Int' to expected argument type 'CCRefrigerator?'}}
}
