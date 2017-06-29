//
//  ViewController.swift
//  Calculator
//
//  Created by James Shapiro on 6/17/17.
//  Copyright © 2017 James Shapiro. All rights reserved.
//

import UIKit

private class MyNumberFormatterWrapper: NumberFormatter {
    override init() {
        super.init()
        self.maximumFractionDigits = 6
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: UIViewController {
    private let numberFormatter = MyNumberFormatterWrapper()
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var arguments: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            if digit != "." || !textCurrentlyInDisplay.contains(".") {
                display.text = textCurrentlyInDisplay + digit
            }
        } else {
            display.text = (digit == "." ? "0" : "") + digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = numberFormatter.string(from: NSNumber(value: newValue))
        }
    }
    
    var argumentsValue: String {
        get {
            return arguments.text!
        }
        set {
            arguments.text = newValue
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        argumentsValue = brain.description.map({
            if let doubleValue = Double($0) {
                return numberFormatter.string(from: NSNumber(value: doubleValue))!
            } else {
                return $0
            }
        }).joined(separator: " ")
        if let result = brain.result {
            displayValue = result
        }
        if sender.currentTitle! == "C" {
            displayValue = 0
            argumentsValue = "Hail to the Redskins"
            userIsInTheMiddleOfTyping = false
        }
    }
}

