//
//  ActuatorMacros.swift
//
//
//  Created by Nicolae Popescu on 12/04/2024.
//

@freestanding(declaration, names: named(Actuator1),
              named(Actuator2),
              named(Actuator3),
              named(Actuator4),
              named(Actuator5),
              named(Actuator6),
              named(Actuator7))
public macro ActuatorWithParameters(_ : Array<String>) = #externalMacro(module: "ActuatorMacrosImplementation", type: "ActuatorWithParameters")

@freestanding(declaration, names: named(Actuator1),
              named(Actuator2),
              named(Actuator3),
              named(Actuator4),
              named(Actuator5),
              named(Actuator6),
              named(Actuator7))
public macro Actuator(_ : Int) = #externalMacro(module: "ActuatorMacrosImplementation", type: "Actuator")

