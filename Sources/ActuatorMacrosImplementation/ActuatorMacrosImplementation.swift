//
//  ActuatorMacrosImplementation.swift
//
//
//  Created by Nicolae Popescu on 10/04/2024.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

/* To be called like #ActuatorWithParameters("R", "P1", "P2", "P3") to expends to:

 public struct Actuator3<R, P1, P2, P3>: ActuatorProtocol {
     // implement ActuatorProtocol
     public typealias Action = (P1, P2, P3) -> R

     public var actions: Array<Action> = []

     // define invoke method for this arity
     func callAsFunction(_ p1: P1, _ p2: P2, _ p3: P3) {
       forEach {
         let ret = $0 (p1, p2, p3)
         // print(ret)
       }
     }
 }
*/
public struct ActuatorWithParameters: DeclarationMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard
            var arrayElements = node.argumentList.first?.expression.as(
                ArrayExprSyntax.self)?.elements
        else {
            throw CocoaError(.featureUnsupported)  // You might want to replace this error with a more descriptive replacement
        }

        let startIndex = arrayElements.startIndex

        guard
            let returnElement = arrayElements[startIndex].as(
                ArrayElementSyntax.self)?.expression.as(
                    StringLiteralExprSyntax.self)?.representedLiteralValue
        else {
            throw CocoaError(.featureUnsupported)  // You might want to replace this error with a more descriptive replacement
        }

        arrayElements.remove(at: startIndex)

        //    print("count:" + String(arrayElements.count))

        var nextIndex = arrayElements.startIndex
        var arguments: [String] = []
        for element in arrayElements {
            guard
                let argument = element.as(ArrayElementSyntax.self)?.expression
                    .as(StringLiteralExprSyntax.self)?.representedLiteralValue
            else {
                throw CocoaError(.featureUnsupported)  // You might want to replace this error with a more descriptive replacement
            }
            arguments.append(argument)
            nextIndex = arrayElements.index(after: nextIndex)
        }

        var arity: String = ""
        for arg in arguments {
            arity += arg + ", "
        }
        arity.removeLast(2)

        //  print("arity:" + arity)

        let signature = returnElement + ", " + arity

        var callSignature: String = ""
        var forEachSignature: String = ""
        for arg in arguments {
            callSignature += "_ " + arg.lowercased() + ": " + arg + ","
            forEachSignature += arg.lowercased() + ", "
        }
        callSignature.removeLast()
        forEachSignature.removeLast(2)

        return MacroReturn.Return(argumentsCount: arguments.count,
                                  signature: signature,
                                  returnElement: returnElement,
                                  callSignature: callSignature,
                                  forEachSignature: forEachSignature,
                                  arity: arity)
    }
}

//
/*
 To be called like `#Actuator(3)` that expends to:

 public struct Actuator3<R, P1, P2, P3>: ActuatorProtocol {
     // implement ActuatorProtocol
     public typealias Action = (P1, P2, P3) -> R

     public var actions: Array<Action> = []

     // define invoke method for this arity
     func callAsFunction(_ p1: P1, _ p2: P2, _ p3: P3) {
       forEach {
         let ret = $0 (p1, p2, p3)
         // print(ret)
       }
     }
 }
 */
public struct Actuator: DeclarationMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard
            let arg = node.argumentList.first?.expression.as(
                IntegerLiteralExprSyntax.self)?.literal.text
        else {
            NSException(
                name: .genericException,
                reason: "Failed to get the macro's argument!"
            ).raise()
            return []
        }

        print("arg:", arg)

        let paramCount = Int(arg) ?? 0

        if paramCount == 0 {
            NSException(name: .genericException, reason: "paramCount is 0!")
                .raise()
        }

        print("paramCount:", paramCount)

        let returnElement = "R"

        var arguments: [String] = []

        for index in 1...paramCount {
            arguments.append("P" + String(index))
        }

        print("arguments:", arguments)

        var arity: String = ""

        for arg in arguments {
            arity += arg + ", "
        }
        arity.removeLast(2)

        // print("arity:" + arity)
        
        let signature = returnElement + ", " + arity

        var callSignature: String = ""
        var forEachSignature: String = ""
        for arg in arguments {
            callSignature += "_ " + arg.lowercased() + ": " + arg + ","
            forEachSignature += arg.lowercased() + ", "
        }
        callSignature.removeLast()
        forEachSignature.removeLast(2)

        return MacroReturn.Return(argumentsCount: arguments.count,
                                  signature: signature,
                                  returnElement: returnElement,
                                  callSignature: callSignature,
                                  forEachSignature: forEachSignature,
                                  arity: arity)
    }
}

struct MacroReturn {
    static func Return(argumentsCount: Int,
                       signature: String,
                       returnElement: String,
                       callSignature: String,
                       forEachSignature: String,
                       arity: String) -> [DeclSyntax] {
        return [
            """
            public struct Actuator\(raw: argumentsCount)<\(raw: signature)>: ActuatorProtocol {
                // implement ActuatorProtocol
                public typealias Action = IdentifiableAction
            
                private var actions: Array<Action> = []
            
                private var results: Array<\(raw: returnElement)> = []
            
                public init() {
                }
            
                public init(_ actions: [Action]) {
                    self.actions += actions
                }
            
                func forEach(_ body: (Action) throws -> Void) rethrows {
                    for action in actions {
                        try body(action)
                    }
                }
            
                // define invoke method for this arity
                public mutating func callAsFunction(\(raw: callSignature)) {
                    results.removeAll()
                    forEach {
                        let ret = $0.action(\(raw: forEachSignature))
                        results += [ret]
                        // print(ret)
                  }
                }
            
                var Actions : [Action] {
                  get {
                      actions
                  }
                }
            
                public mutating func connect(_ actions: [Action]) {
                    self.actions.removeAll()
                    self.actions += actions
                }
            
                public mutating func add(actions: [Action]) {
                    self.actions += actions
                }
            
                public mutating func remove(action: Action) {
                    actions.removeAll(where: { $0.id == action.id })
                }
            
                public var Results : Array<\(raw: returnElement)> {
                  get {
                      results
                  }
                }
            
                public struct IdentifiableAction {
                    public typealias Action = (\(raw: arity)) -> \(raw: returnElement) 
                    var action: (\(raw: arity)) -> \(raw: returnElement)
                    var id = UUID()
            
                    public init(action: @escaping Action) {
                        self.action  = action    
                    }
                }
            }
            """
        ]
    }
}
