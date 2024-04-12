//
//  ActuatorProtocol.swift
//  
//
//  Created by Nicolae Popescu on 13/02/2024.
//

import Foundation

protocol ActuatorProtocol<Action> {
  
  associatedtype Action
  
  var actions: Array<Action> { get set }
  
  init()
}

extension ActuatorProtocol {
  
  @inlinable
  init(_ actions: Array<Action>) {
    // preventing error:  'self.init' isn't called on all paths before returning from initializer
    self.init()
    self.actions += actions
  }
  
  @inlinable
  public mutating func connect(_ actions: Array<Action>) {
    self.actions += actions
  }
  
  @inlinable
  public func forEach( _ body: (Action) throws -> Void) rethrows {
    for action in actions {
      try body(action)
    }
  }
}
