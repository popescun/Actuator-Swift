//
//  MacrosPlugin.swift
//
//
//  Created by Nicolae Popescu on 12/04/2024.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct MacroExamplePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ActuatorWithParameters.self,
        Actuator.self
//        FooMethodImpl.self,
    ]
}
