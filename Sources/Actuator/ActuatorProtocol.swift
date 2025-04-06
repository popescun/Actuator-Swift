//
//  ActuatorProtocol.swift
//
//
//  Created by Nicolae Popescu on 13/02/2024.
//

import Foundation

protocol ActuatorProtocol {

    associatedtype Action
    
    var Actions : [Action] { get }

    init()
    
    init(_ actions: [Action])
}
