//import SwiftSyntax
//import SwiftCompilerPlugin
//import SwiftSyntaxMacros
import ActuatorMacros
import XCTest

@testable import Actuator

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

final class ActuatorTests: XCTestCase {
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
        var actuator = Actuator1<Void, Int>([Actuator1.Action(action: a.action)])
        actuator.connect([Actuator1.Action(action: b.action)])
        actuator.actions += [Actuator1.Action(action: c.action)]
        actuator(11)
        waitForExpectations(timeout: 0)
    }
    
    func testCopy() throws {
        let a = A()
        let b = B()
        let c = C()
    
        Expectation.value = expectation(description: "actuator copy")
        Expectation.value.expectedFulfillmentCount = 3
        var actuator = Actuator1<Void, Int>()
        actuator.connect([Actuator1.Action(action: a.action), Actuator1.Action(action: b.action), Actuator1.Action(action: c.action)])
        actuator(10)
        waitForExpectations(timeout: 0)
    }
    
    func testAdd() throws {
        let a = A()
        let b = B()
        let c = C()
    
        Expectation.value = expectation(description: "actuator add")
        Expectation.value.expectedFulfillmentCount = 4
        var actuator = Actuator1<Void, Int>()
        actuator.connect([Actuator1.Action(action: a.action), Actuator1.Action(action: b.action), Actuator1.Action(action: c.action)])
        actuator.actions += [Actuator1.Action(action: a.action)]
        actuator(10)
        waitForExpectations(timeout: 0)
    }
    
    func testRemove() throws {
        let a = A()
        let b = B()
        let c = C()
    
        Expectation.value = expectation(description: "actuator add")
        Expectation.value.expectedFulfillmentCount = 2
        var actuator = Actuator1<Void, Int>()
        let action1 = Actuator1.Action(action: a.action)
        let action2 = Actuator1.Action(action: b.action)
        let action3 = Actuator1.Action(action: c.action)
        actuator.connect([action1, action2, action3])
        actuator.remove(action: action1)
        actuator(10)
        waitForExpectations(timeout: 0)
    }
}

protocol P {
    func action(a: Int)
}

struct A: P {
    func action(a: Int) {
        print("A.test a: \(a)")
        Expectation.value.fulfill()
    }
}

struct B: P {
    func action(a: Int) {
        print("B.test a: \(a)")
        Expectation.value.fulfill()
    }
}

struct C: P {
    func action(a: Int) {
        print("C.test a: \(a)")
        Expectation.value.fulfill()
    }
}

func test(list: [P], a: Int) {
    for element in list {
        element.action(a: a)
    }
}

class Expectation {
    public static var value = XCTestExpectation(description: "none")
}
