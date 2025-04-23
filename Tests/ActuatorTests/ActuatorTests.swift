//
//  Actuator.swift
//
//
//  Created by Nicolae Popescu on 13/02/2024.
//

import XCTest

import Actuator

final class ActuatorTests: XCTestCase {
    @MainActor func testPolymorphism() throws {
        //using polymorphism
        print("Using polymorphism:")
        Expectation.value = expectation(description: "test using polymorphism")
        Expectation.value.expectedFulfillmentCount = 3
        let a = A()
        let b = B()
        let c = C()
        test(list: [a, b, c], a: 10)
        waitForExpectations(timeout: 0)
        
        //using Actuator
        print("\nUsing Actuator:")
        Expectation.value = expectation(description: "test using actuator")
        Expectation.value.expectedFulfillmentCount = 3
        var actuator = Actuator1<Void, Int>([Actuator1.Action(action: a.action)])
        actuator.add(actions: [Actuator1.Action(action: b.action)])
        actuator.add(actions: [Actuator1.Action(action: c.action)])
        XCTAssertTrue(actuator.isConnected)
        XCTAssertEqual(actuator.Count, 3)
        actuator(11)
        waitForExpectations(timeout: 0)
    }
    
    @MainActor func testCopy() throws {
        let a = A()
        let b = B()
        let c = C()
        
        Expectation.value = expectation(description: "test copy")
        Expectation.value.expectedFulfillmentCount = 3
        var actuator = Actuator1<Void, Int>()
        actuator.connect([Actuator1.Action(action: a.action), Actuator1.Action(action: b.action), Actuator1.Action(action: c.action)])
        XCTAssertTrue(actuator.isConnected)
        XCTAssertEqual(actuator.Count, 3)
        actuator(10)
        waitForExpectations(timeout: 0)
    }
    
    @MainActor func testAdd() throws {
        let a = A()
        let b = B()
        let c = C()
        
        Expectation.value = expectation(description: "test add")
        Expectation.value.expectedFulfillmentCount = 4
        var actuator = Actuator1<Void, Int>()
        actuator.connect([Actuator1.Action(action: a.action), Actuator1.Action(action: b.action), Actuator1.Action(action: c.action)])
        actuator.add(actions: [Actuator1.Action(action: a.action)])
        XCTAssertTrue(actuator.isConnected)
        XCTAssertEqual(actuator.Count, 4)
        actuator(10)
        waitForExpectations(timeout: 0)
    }
    
    @MainActor func testRemove() throws {
        let a = A()
        let b = B()
        let c = C()
        
        Expectation.value = expectation(description: "test remove")
        Expectation.value.expectedFulfillmentCount = 2
        var actuator = Actuator1<Void, Int>()
        let action1 = Actuator1.Action(action: a.action)
        let action2 = Actuator1.Action(action: b.action)
        let action3 = Actuator1.Action(action: c.action)
        actuator.connect([action1, action2, action3])
        actuator.remove(action: action1)
        XCTAssertTrue(actuator.isConnected)
        XCTAssertEqual(actuator.Count, 2)
        actuator(10)
        waitForExpectations(timeout: 0)
    }
    
    @MainActor func testNilActionObjectHasNoEffect() throws {
        var a : A? = A()
        let b = B()
        let c = C()
        
        Expectation.value = expectation(description: "test non nil action object")
        Expectation.value.expectedFulfillmentCount = 3
        var actuator = Actuator1<Void, Int>()
        let action1 = Actuator1.Action(action: a!.action)
        let action2 = Actuator1.Action(action: b.action)
        let action3 = Actuator1.Action(action: c.action)
        actuator.connect([action1, action2, action3])
        XCTAssertTrue(actuator.isConnected)
        XCTAssertEqual(actuator.Count, 3)
        actuator(10)
        waitForExpectations(timeout: 0)
        
        // Making underlying action as nil has no effect once action was bound to it
        a = nil
        Expectation.value = expectation(description: "test nil action object")
        Expectation.value.expectedFulfillmentCount = 3
        actuator.connect([action1, action2, action3])
        XCTAssertTrue(actuator.isConnected)
        XCTAssertEqual(actuator.Count, 3)
        actuator(11)
        waitForExpectations(timeout: 0)
    }
    
    @MainActor func testExtractResults() throws {
        let a = A()
        let b = B()
        let c = C()
        
        Expectation.value = expectation(description: "test extract result")
        Expectation.value.expectedFulfillmentCount = 3
        var actuator = Actuator1<Int, Int>()
        let action1 = Actuator1.Action(action: a.actionWithResult)
        let action2 = Actuator1.Action(action: b.actionWithResult)
        let action3 = Actuator1.Action(action: c.actionWithResult)
        actuator.connect([action1, action2, action3])
        XCTAssertTrue(actuator.isConnected)
        XCTAssertEqual(actuator.Count, 3)
        actuator(10)
        waitForExpectations(timeout: 0)
        
        for result in actuator.Results {
            // warning `'is' test is always true` is false positive
            XCTAssertTrue(result is Int)
            XCTAssertEqual(10, result)
        }
    }
    
    @MainActor func testVoidReturn() throws {
        let a = A()
        let b = B()
        let c = C()
        
        Expectation.value = expectation(description: "test extract result")
        Expectation.value.expectedFulfillmentCount = 3
        var actuator = Actuator1<Void, Int>()
        let action1 = Actuator1.Action(action: a.action)
        let action2 = Actuator1.Action(action: b.action)
        let action3 = Actuator1.Action(action: c.action)
        actuator.connect([action1, action2, action3])
        XCTAssertTrue(actuator.isConnected)
        XCTAssertEqual(actuator.Count, 3)
        actuator(10)
        waitForExpectations(timeout: 0)
        
        for result in actuator.Results {
            XCTAssertTrue(result is Void)
        }
    }
}

protocol P {
    func action(a: Int)
    func actionWithResult(a: Int) -> Int
}

struct A: P {
    func action(a: Int) {
        print("A.action a: \(a)")
        Expectation.value.fulfill()
    }
    
    func actionWithResult(a: Int) -> Int {
        print("A.actionWithResult a: \(a)")
        Expectation.value.fulfill()
        return a
    }
}

struct B: P {
    func action(a: Int) {
        print("B.action a: \(a)")
        Expectation.value.fulfill()
    }
    
    func actionWithResult(a: Int) -> Int {
        print("B.actionWithResult a: \(a)")
        Expectation.value.fulfill()
        return a
    }
}

struct C: P {
    func action(a: Int) {
        print("C.action a: \(a)")
        Expectation.value.fulfill()
    }
    
    func actionWithResult(a: Int) -> Int {
        print("C.actionWithResult a: \(a)")
        Expectation.value.fulfill()
        return a
    }
}

func test(list: [P], a: Int) {
    for element in list {
        element.action(a: a)
    }
}

class Expectation {
    nonisolated(unsafe) public static var value = XCTestExpectation(description: "none")
}
