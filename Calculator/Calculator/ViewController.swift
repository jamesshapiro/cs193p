//
//  ViewController.swift
//  Calculator
//
//  Created by James Shapiro on 6/17/17.
//  Copyright © 2017 James Shapiro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var arguments: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    var userHasAlreadyTypedADecimalPoint = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digitOrDecimalPoint = sender.currentTitle!
        let isDecimal = (digitOrDecimalPoint == ".")
        if isDecimal && userHasAlreadyTypedADecimalPoint {
            print("\\a")
            return
        }
        userHasAlreadyTypedADecimalPoint = userHasAlreadyTypedADecimalPoint || isDecimal
        
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digitOrDecimalPoint
        } else {
            if isDecimal {
                display.text = "0" + digitOrDecimalPoint
            } else {
                display.text = digitOrDecimalPoint
            }
            userIsInTheMiddleOfTyping = true
        }
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
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
            userHasAlreadyTypedADecimalPoint = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        argumentsValue = brain.descriptionComputed
        if let result = brain.result {
            displayValue = result
            argumentsValue = brain.descriptionComputed
        }
        if sender.currentTitle! == "C" {
            displayValue = 0
            argumentsValue = "Hail to the Redskins"
            userIsInTheMiddleOfTyping = false
            userHasAlreadyTypedADecimalPoint = false
        }
    }
}

