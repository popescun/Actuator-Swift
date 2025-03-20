//
//  ActuatorProtocol.swift
//
//
//  Created by Nicolae Popescu on 13/02/2024.
//

import Foundation

protocol ActuatorProtocol {

    associatedtype Action

    var actions: [Action] { get set }

    init()
}

extension ActuatorProtocol {

    @inlinable
    init(_ actions: [Action]) {
        // preventing error:  'self.init' isn't called on all paths before returning from initializer
        self.init()
        self.actions += actions
    }

    @inlinable
    public mutating func connect(_ actions: [Action]) {
        self.actions += actions
    }
    
    @inlinable
    public mutating func remove(_ action: Action) {
        for act in actions {
//            if act == action {
//                
//            }
        }
    }

    @inlinable
    public func forEach(_ body: (Action) throws -> Void) rethrows {
        for action in actions {
            try body(action)
        }
    }
}
