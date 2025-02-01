//import SwiftSyntax
//import SwiftCompilerPlugin
//import SwiftSyntaxMacros
import ActuatorMacros
import XCTest

@testable import Actuator

func foo(_ a: Int) -> Int {
    print(a)
    return a
}

func foo2(_ a: Int, _ b: Int) -> Int {
    let ret = a + b
    print(ret)
    return ret
}

func foo3(_ a: Int, _ b: Int, _ c: Int) -> Int {
    let ret = a + b + c
    print(ret)
    return ret
}

//@freestanding(declaration, names: named(FooMethod))
//public macro FooMethod(_ : Array<String>) = #externalMacro(module: "ActuatorTests", type: "FooMethodImpl")
//
////@main
////struct MacroTestsPlugin: CompilerPlugin {
////    let providingMacros: [Macro.Type] = [
////      FooMethodImpl.self
////    ]
////}
//
//public struct FooMethodImpl: DeclarationMacro {
//  public static func expansion(
//    of node: some FreestandingMacroExpansionSyntax,
//    in context: some MacroExpansionContext
//  ) throws -> [DeclSyntax] {
//    return ["""
//            """]
//  }
//}

// todo: extend tests to cover all possible arities
final class ActuatorTests: XCTestCase {
    
    //    func testExample() throws {
    //        var actuator1 = Actuator1<Int, Int>([foo])
    //        actuator1.connect([foo])
    //        actuator1.actions += [foo]
    //        actuator1(1)
    //
    //        #FooMethod([""])
    //
    //        var actuator2 = Actuator2<Int, Int, Int>([foo2])
    //        actuator2.connect([foo2])
    //        actuator2.actions += [foo2]
    //        actuator2(2, 2)
    //
    //        var actuator3 = Actuator3<Int, Int, Int, Int>([foo3])
    //        actuator3.connect([foo3])
    //        actuator3.actions += [foo3]
    //        actuator3(3, 3, 3)
    //    }
    
    func testPolymorphism() throws {
        //using polymorphism
        print("Using polymorphism:")
        Expectation.value = expectation(description: "using polymorphism")
        Expectation.value.expectedFulfillmentCount = 3
        let a = A()
        let b = B()
        let c = C()
        test(list: [a, b, c], a: 10)
        waitForExpectations(timeout: 0)
        
        //using Actuator
        print("\nUsing Actuator:")
        Expectation.value = expectation(description: "using Actuator")
        Expectation.value.expectedFulfillmentCount = 3
        var actuator = Actuator1<Void, Int>([a.test])
        actuator.connect([b.test])
        actuator.actions += [c.test]
        actuator(11)
        waitForExpectations(timeout: 0)
    }
}

protocol P {
    func test(a: Int)
}

struct A: P {
    func test(a: Int) {
        print("A.test a: \(a)")
        Expectation.value.fulfill()
    }
}

struct B: P {
    func test(a: Int) {
        print("B.test a: \(a)")
        Expectation.value.fulfill()
    }
}

struct C: P {
    func test(a: Int) {
        print("C.test a: \(a)")
        Expectation.value.fulfill()
    }
}

func test(list: [P], a: Int) {
    for element in list {
        element.test(a: a)
    }
}

class Expectation {
    public static var value = XCTestExpectation(description: "none")
}
