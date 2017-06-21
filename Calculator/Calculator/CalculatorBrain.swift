//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by James Shapiro on 6/18/17.
//  Copyright © 2017 James Shapiro. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    
    
    private var accumulater = Accumulater()
    private var accumulator: Double?
    private var resultIsPending = false
    private var description = ""
    
    func print_descrip() {
        if let accumdec = accumulater.descrip {
            if resultIsPending {
                print(description + accumdec +  " ...")
            } else {
                print(description + accumdec +  " =")
            }
        } else {
            if resultIsPending {
                print(description +  " ...")
            } else {
                print(description +  " =")
            }
        }
    }
    
    private class Accumulater {
        var accumulator: Double?
        var descrip: String?
        
    }
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals
    }
    
    private enum DescribeOperation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((String,String) -> String)
        case equals
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "±" : Operation.unaryOperation({ -$0 }),
        "×" : Operation.binaryOperation({ $0 * $1 }),
        "÷" : Operation.binaryOperation({ $0 / $1 }),
        "+" : Operation.binaryOperation({ $0 + $1 }),
        "−" : Operation.binaryOperation({ $0 - $1 }),
        "x²" : Operation.unaryOperation({ $0 * $0 }),
        "lg" : Operation.unaryOperation({ log2($0) }),
        "eˣ" : Operation.unaryOperation({ pow(M_E, $0) }),
        "1/x" : Operation.unaryOperation({ 1.0 / $0 }),
        "=" : Operation.equals
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulater.accumulator = value
                accumulater.descrip = String(value)
            case .unaryOperation(let function):
                if accumulater.accumulator != nil {
                    accumulater.accumulator = function(accumulater.accumulator!)
                    if resultIsPending {
                        accumulater.descrip = symbol + "(\(accumulater.descrip!))"
                    } else {
                        description = symbol + "(" + description + ")"
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
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulater.accumulator != nil {
            description = description + " " + accumulater.descrip! + " "
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
        accumulater.accumulator = operand
        accumulater.descrip = String(operand)
    }
    
    var result: Double? {
        get {
            return accumulater.accumulator
        }
    }
}
