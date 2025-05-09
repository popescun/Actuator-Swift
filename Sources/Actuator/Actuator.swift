//
//  Actuator.swift
//  
//
//  Created by Nicolae Popescu on 13/02/2024.
//

import Foundation
import ActuatorMacros

public struct Actuator1<R, P1>: ActuatorProtocol {
  // implement ActuatorProtocol
  public typealias Action = (P1) -> R
  // todo: this is a repetitive line that should be in a base class; not sure how to do
  public var actions: Array<Action> = []
  
  // define invoke method for this arity
  func callAsFunction(_ a: P1) {
    forEach {
      let ret = $0(a)
      print(ret)
    }
  }
}

//public struct Actuator2<R, P1, P2>: ActuatorProtocol {
//  // implement ActuatorProtocol
//  public typealias Action = (P1, P2) -> R
//  public var actions: Array<Action> = []
//  
//  // define invoke method for this arity
//  func callAsFunction(_ a: P1, _ b: P2) {
//    forEach {
//      let ret = $0(a, b)
//      print(ret)
//    }
//  }
//}

#Actuator(2)

#Actuator(3)
