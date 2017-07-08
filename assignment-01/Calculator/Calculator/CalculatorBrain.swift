//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by James Shapiro on 6/18/17.
//  Copyright © 2017 James Shapiro. All rights reserved.
//

import Foundation

/// Extracts the non-empty, non-whitespace components of a `String`
/// into an array of Strings
private extension String {
    var arguments: [String] {
        let components = self.components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }
    }
}

/// Handles all numerical computations for the Calculator app
struct CalculatorBrain {
    /// Stores the numerical result of the computations so far
    /// and a String record of the most recent operations.
    private var accumulator: (double: Double?, string: String?) = (nil, nil)
    /// Signals whether the Calculator Brain is in the middle
    /// of a binary operation.
    private var resultIsPending = false
    /// Stores a history of the operands and operations that
    /// have been entered so far.
    private var argumentsEntered = ""
    
    private func print_descrip() {
        print(description)
    }
    
    /// The different types of mathematical operations that the
    /// Calculator can perform.
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals
    }
    
    /// A map from symbols for the supported operations to
    /// the supported operations themselves.
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "sin" : Operation.unaryOperation(sin),
        "cos" : Operation.unaryOperation(cos),
        "±" : Operation.unaryOperation(-),
        "×" : Operation.binaryOperation(*),
        "÷" : Operation.binaryOperation(/),
        "+" : Operation.binaryOperation(+),
        "−" : Operation.binaryOperation(-),
        "lg" : Operation.unaryOperation(log2),
        "ln" : Operation.unaryOperation(log),
        "=" : Operation.equals
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                if pendingBinaryOperation == nil {
                    argumentsEntered = ""
                }
                accumulator = (value, symbol)
            case .unaryOperation(let function):
                if accumulator.double == nil {
                    return
                }
                accumulator.double = function(accumulator.double!)
                if resultIsPending {
                    argumentsEntered.append(" ")
                    accumulator.string = symbol + "(\(accumulator.string!))"
                } else {
                    if pendingBinaryOperation == nil {
                        argumentsEntered.append(accumulator.string!)
                        accumulator.string = ""
                        argumentsEntered = symbol + "(\(argumentsEntered))"
                    } else {
                        argumentsEntered = symbol + "(" + argumentsEntered + ")"
                    }
                }
                print_descrip()
                
            case .binaryOperation(let function):
                if pendingBinaryOperation != nil && accumulator.double != nil {
                    performPendingBinaryOperation()
                }
                if accumulator.double == nil {
                    return
                }
                argumentsEntered.append("\(accumulator.string!) \(symbol) ")
                resultIsPending = true
                pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator.double!)
                accumulator = (nil, nil)
                print_descrip()
                
            case .equals:
                resultIsPending = false
                performPendingBinaryOperation()
                print_descrip()
            }
        }
        if symbol == "C" {
            accumulator = (nil, nil)
            pendingBinaryOperation = nil
            resultIsPending = false
            argumentsEntered = ""
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator.double != nil {
            argumentsEntered.append(" \(accumulator.string!)")
            accumulator.string = ""
            print_descrip()
            accumulator.double = pendingBinaryOperation!.perform(with: accumulator.double!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double,Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        if accumulator.double != nil {
            argumentsEntered = ""
        }
        accumulator = (operand, String(operand))
    }
    
    var result: Double? {
        get {
            return accumulator.double
        }
    }
    
    var description: [String] {
        var displayResult = argumentsEntered + (accumulator.string ?? "")
        resultIsPending ? displayResult.append(" ...") : displayResult.append(" =")
        return displayResult.arguments
    }
}
