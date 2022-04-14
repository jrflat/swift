// RUN: %target-swift-emit-module-interface(%t.swiftinterface) %s -module-name attrs
// RUN: %target-swift-typecheck-module-from-interface(%t.swiftinterface) -module-name attrs
// RUN: %FileCheck %s < %t.swiftinterface

// CHECK: @_transparent public func glass() -> Swift.Int { return 0 }{{$}}
@_transparent public func glass() -> Int { return 0 }

// CHECK: @_effects(readnone) public func illiterate(){{$}}
@_effects(readnone) public func illiterate() {}

// CHECK: @_effects(notEscaping arg1.**) public func escapeEffects(arg1: Swift.Int){{$}}
@_effects(notEscaping arg1.**) public func escapeEffects(arg1: Int) {}

// CHECK-LABEL: @frozen public struct Point {
@frozen public struct Point {
  // CHECK-NEXT: public var x: Swift.Int
  public var x: Int
  // CHECK-NEXT: public var y: Swift.Int
  public var y: Int
} // CHECK-NEXT: {{^}$}}
