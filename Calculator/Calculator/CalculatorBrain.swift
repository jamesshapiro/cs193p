//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by James Shapiro on 6/18/17.
//  Copyright © 2017 James Shapiro. All rights reserved.
//

import Foundation

extension String {
    var condensedWhitespace: String {
        let components = self.components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
}

struct CalculatorBrain {
    private var accumulater = Accumulater()
    private var accumulator: Double?
    private var resultIsPending = false
    private var description = ""
    
    private class Accumulater {
        var accumulator: Double?
        var descrip: String?
    }
    
    var descriptionComputed: String {
        if let accumdec = accumulater.descrip {
            if resultIsPending {
                let str = description + accumdec +  " ..."
                return str.condensedWhitespace
            } else {
                let str = description + accumdec +  " ="
                return str.condensedWhitespace
            }
        } else {
            if resultIsPending {
                let str = description +  " ..."
                return str.condensedWhitespace
            } else {
                let str = description + " ="
                return str.condensedWhitespace
            }
        }
    }
    
    func print_descrip() {
        print(descriptionComputed)
    }
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "±" : Operation.unaryOperation(-),
        "×" : Operation.binaryOperation(*),
        "÷" : Operation.binaryOperation(/),
        "+" : Operation.binaryOperation(+),
        "−" : Operation.binaryOperation(-),
        "lg" : Operation.unaryOperation(log2),
        "eˣ" : Operation.unaryOperation({ pow(M_E, $0) }),
        "ln" : Operation.unaryOperation(log),
        "=" : Operation.equals
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulater.accumulator = value
                accumulater.descrip = symbol
            case .unaryOperation(let function):
                if accumulater.accumulator != nil {
                    var nsymbol = symbol
                    if symbol == "eˣ" {
                        nsymbol = "e^"
                    }
                    accumulater.accumulator = function(accumulater.accumulator!)
                    if resultIsPending {
                        description = description + " "
                        accumulater.descrip = nsymbol + "(\(accumulater.descrip!))"
                    } else {
                        if pendingBinaryOperation == nil {
                            description = description + accumulater.descrip!
                            accumulater.descrip = ""
                            description = nsymbol + "(\(description))"
                            
                        } else {
                        description = nsymbol + "(" + description + ")"
                        }
                    }
                    print_descrip()
                }
            case .binaryOperation(let function):
                if accumulater.accumulator != nil {
                    description = description + accumulater.descrip! + " " + symbol
                    resultIsPending = true
                    accumulater.descrip = nil
                    print_descrip()
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulater.accumulator!)
                    accumulater.accumulator = nil
                    
                }
                break
            case .equals:
                resultIsPending = false
                performPendingBinaryOperation()
                print_descrip()
            }
        }
        if symbol == "C" {
            accumulater.accumulator = nil
            accumulater.descrip = nil
            pendingBinaryOperation = nil
            resultIsPending = false
            description = ""
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulater.accumulator != nil {
            description = description + " " + accumulater.descrip!
            accumulater.descrip = ""
            print_descrip()
            accumulater.accumulator = pendingBinaryOperation!.perform(with: accumulater.accumulator!)
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
        if accumulater.accumulator != nil {
            description = ""
        }
        accumulater.accumulator = operand
        accumulater.descrip = String(operand)
    }
    
    var result: Double? {
        get {
            return accumulater.accumulator
        }
    }
}
