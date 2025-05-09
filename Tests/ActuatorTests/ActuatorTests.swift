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

func foo3(_ a: Int, _ b: Int,_ c: Int ) -> Int {
  let ret = a + b + c
  print(ret)
  return ret
}

// todo: extend tests to cover all possible arities
final class ActuatorTests: XCTestCase {
  func testExample() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct
    // results.
    //        XCTAssertEqual(Actuator().text, "Hello, World!")
    
    var actuator1 = Actuator1<Int, Int>([foo])
    actuator1.connect([foo])
    actuator1.actions += [foo]
    actuator1(1)
    
    var actuator2 = Actuator2<Int, Int, Int>([foo2])
    actuator2.connect([foo2])
    actuator2.actions += [foo2]
    actuator2(2, 2)
    
    var actuator3 = Actuator3<Int, Int, Int, Int>([foo3])
    actuator3.connect([foo3])
    actuator3.actions += [foo3]
    actuator3(3, 3, 3)
  }
}
