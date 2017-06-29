//
//  CalculatorTests3.swift
//  CalculatorTests3
//
//  Created by James Shapiro on 6/21/17.
//  Copyright © 2017 James Shapiro. All rights reserved.
//

import XCTest
@testable import Calculator

class CalculatorTests3: XCTestCase {
    
    var brain: CalculatorBrain!
    var viewController: ViewController!
    override func setUp() {
        super.setUp()
        brain = CalculatorBrain()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOnePlusOneEqualsTwo() {
        brain.setOperand(1)
        brain.performOperation("+")
        brain.setOperand(1)
        brain.performOperation("=")
        XCTAssertEqual(brain.result, 2)
        XCTAssertEqual(brain.description, ["1.0", "+", "1.0", "="])
    }
    
    func testTwoSqrtPlusThreeSqrtEquals() {
        brain.setOperand(2)
        brain.performOperation("√")
        XCTAssertEqual(brain.description, ["√(2.0)", "="])
        brain.performOperation("+")
        brain.setOperand(3)
        brain.performOperation("√")
        XCTAssertEqual(brain.description, ["√(2.0)", "+", "√(3.0)", "..."])
        brain.performOperation("=")
        XCTAssertEqual(brain.description, ["√(2.0)", "+", "√(3.0)", "="])
    }
    
    func testSevenPlusNineEqualsSqrtPlusTwoEquals() {
        brain.setOperand(7)
        brain.performOperation("+")
        XCTAssertEqual(brain.description, ["7.0", "+", "..."])
        brain.setOperand(9)
        brain.performOperation("=")
        XCTAssertEqual(brain.description, ["7.0", "+", "9.0", "="])
        brain.performOperation("√")
        XCTAssertEqual(brain.description, ["√(7.0", "+", "9.0)", "="])
        brain.performOperation("+")
        brain.setOperand(2)
        brain.performOperation("=")
        XCTAssertEqual(brain.result, 6)
        XCTAssertEqual(brain.description, ["√(7.0", "+", "9.0)", "+", "2.0", "="])
    }
    
    func testSevenPlusNineSqrt() {
        brain.setOperand(7)
        brain.performOperation("+")
        brain.setOperand(9)
        brain.performOperation("√")
        XCTAssertEqual(brain.description, ["7.0", "+", "√(9.0)", "..."])
        brain.performOperation("=")
        XCTAssertEqual(brain.result, 10)
        XCTAssertEqual(brain.description, ["7.0", "+", "√(9.0)", "="])
    }
    
    func testSevenPlusNineEqualsPlusSixEqualsPlusThreeEquals() {
        brain.setOperand(7)
        brain.performOperation("+")
        XCTAssertEqual(brain.description, ["7.0", "+", "..."])
        brain.setOperand(9)
        brain.performOperation("=")
        XCTAssertEqual(brain.description, ["7.0", "+", "9.0", "="])
        brain.performOperation("+")
        XCTAssertEqual(brain.description, ["7.0", "+", "9.0", "+", "..."])
        brain.setOperand(6)
        brain.performOperation("=")
        XCTAssertEqual(brain.description, ["7.0", "+", "9.0", "+", "6.0", "="])
        brain.performOperation("+")
        XCTAssertEqual(brain.description, ["7.0", "+", "9.0", "+", "6.0", "+", "..."])
        brain.setOperand(3)
        brain.performOperation("=")
        XCTAssertEqual(brain.result, 25)
        XCTAssertEqual(brain.description, ["7.0", "+", "9.0", "+", "6.0", "+", "3.0", "="])
    }
    
    func testSevenPlusNineEqualsSqrtSixPlusThreeEquals() {
        brain.setOperand(7)
        brain.performOperation("+")
        XCTAssertEqual(brain.description, ["7.0", "+", "..."])
        brain.setOperand(9)
        brain.performOperation("=")
        XCTAssertEqual(brain.description, ["7.0", "+", "9.0", "="])
        brain.performOperation("√")
        XCTAssertEqual(brain.result, 4)
        XCTAssertEqual(brain.description, ["√(7.0", "+", "9.0)", "="])
        brain.setOperand(6)
        brain.performOperation("+")
        XCTAssertEqual(brain.description, ["6.0", "+", "..."])
        brain.setOperand(3)
        brain.performOperation("=")
        XCTAssertEqual(brain.result, 9)
        XCTAssertEqual(brain.description, ["6.0", "+", "3.0", "="])
    }
    
    func testFourTimesPiEquals() {
        brain.setOperand(4)
        brain.performOperation("×")
        XCTAssertEqual(brain.description, ["4.0", "×", "..."])
        brain.performOperation("π")
        brain.performOperation("=")
        XCTAssertEqual(brain.description, ["4.0", "×", "π", "="])
    }
    
    func testPiSinEqualsPi() {
        brain.performOperation("π")
        brain.performOperation("sin")
        brain.performOperation("=")
        brain.performOperation("π")
        brain.performOperation("=")
        XCTAssertEqual(brain.result, Double.pi)
        XCTAssertEqual(brain.description, ["π", "="])
    }
    
    func testOnePlusOnePlusOne() {
        brain.setOperand(1)
        brain.performOperation("+")
        brain.setOperand(1)
        brain.performOperation("+")
        brain.setOperand(1)
        brain.performOperation("=")
        XCTAssertEqual(brain.result, 3)
        XCTAssertEqual(brain.description, ["1.0", "+", "1.0", "+", "1.0", "="])
    }
    
    func testSixTimesFiveTimesFourTimesThreeTimesTwoTimesOne() {
        brain.setOperand(6)
        brain.performOperation("×")
        brain.setOperand(5)
        brain.performOperation("×")
        brain.setOperand(4)
        brain.performOperation("×")
        brain.setOperand(3)
        brain.performOperation("×")
        brain.setOperand(2)
        brain.performOperation("×")
        brain.setOperand(1)
        brain.performOperation("=")
        XCTAssertEqual(brain.result, 720)
        XCTAssertEqual(brain.description, ["6.0", "×", "5.0", "×", "4.0", "×", "3.0", "×", "2.0", "×", "1.0", "="])
    }
    
    func testPiTimesOneEquals() {
        brain.performOperation("π")
        brain.performOperation("×")
        brain.setOperand(1)
        brain.performOperation("=")
        XCTAssertEqual(brain.result, Double.pi)
        XCTAssertEqual(brain.description, ["π", "×", "1.0", "="])
    }
    
    
    
}
