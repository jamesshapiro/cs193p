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
    }
    
    func testDescriptionTwoSqrtPlusThreeSqrtEquals() {
        brain.setOperand(2)
        brain.performOperation("√")
        XCTAssertEqual(brain.descriptionComputed, "√(2.0) =")
        brain.performOperation("+")
        brain.setOperand(3)
        brain.performOperation("√")
        XCTAssertEqual(brain.descriptionComputed, "√(2.0) + √(3.0) ...")
        brain.performOperation("=")
        XCTAssertEqual(brain.descriptionComputed, "√(2.0) + √(3.0) =")
        brain.setOperand(9)
    }
    
    func testDescriptionSevenPlusNineEqualsSqrtPlusTwoEquals() {
        brain.setOperand(7)
        brain.performOperation("+")
        XCTAssertEqual(brain.descriptionComputed, "7.0 + ...")
        brain.setOperand(9)
        brain.performOperation("=")
        XCTAssertEqual(brain.descriptionComputed, "7.0 + 9.0 =")
        brain.performOperation("√")
        XCTAssertEqual(brain.descriptionComputed, "√(7.0 + 9.0) =")
        brain.performOperation("+")
        brain.setOperand(2)
        brain.performOperation("=")
        XCTAssertEqual(brain.descriptionComputed, "√(7.0 + 9.0) + 2.0 =")
    }
    
    func testDescriptionSevenPlusNineSqrt() {
        brain.setOperand(7)
        brain.performOperation("+")
        brain.setOperand(9)
        brain.performOperation("√")
        XCTAssertEqual(brain.descriptionComputed, "7.0 + √(9.0) ...")
        brain.performOperation("=")
        XCTAssertEqual(brain.descriptionComputed, "7.0 + √(9.0) =")
    }
    
    func testDescriptionSevenPlusNineEqualsPlusSixEqualsPlusThreeEquals() {
        brain.setOperand(7)
        brain.performOperation("+")
        XCTAssertEqual(brain.descriptionComputed, "7.0 + ...")
        brain.setOperand(9)
        brain.performOperation("=")
        XCTAssertEqual(brain.descriptionComputed, "7.0 + 9.0 =")
        brain.performOperation("+")
        XCTAssertEqual(brain.descriptionComputed, "7.0 + 9.0 + ...")
        brain.setOperand(6)
        brain.performOperation("=")
        XCTAssertEqual(brain.descriptionComputed, "7.0 + 9.0 + 6.0 =")
        brain.performOperation("+")
        XCTAssertEqual(brain.descriptionComputed, "7.0 + 9.0 + 6.0 + ...")
        brain.setOperand(3)
        brain.performOperation("=")
        XCTAssertEqual(brain.descriptionComputed, "7.0 + 9.0 + 6.0 + 3.0 =")
    }
    
    func testDescriptionSevenPlusNineEqualsSqrtSixPlusThreeEquals() {
        brain.setOperand(7)
        brain.performOperation("+")
        XCTAssertEqual(brain.descriptionComputed, "7.0 + ...")
        brain.setOperand(9)
        brain.performOperation("=")
        XCTAssertEqual(brain.descriptionComputed, "7.0 + 9.0 =")
        brain.performOperation("√")
        XCTAssertEqual(brain.descriptionComputed, "√(7.0 + 9.0) =")
        brain.setOperand(6)
        brain.performOperation("+")
        XCTAssertEqual(brain.descriptionComputed, "6.0 + ...")
        brain.setOperand(3)
        brain.performOperation("=")
        XCTAssertEqual(brain.descriptionComputed, "6.0 + 3.0 =")
    }
    
    func testDescriptionFourTimesPiEquals() {
        brain.setOperand(4)
        brain.performOperation("×")
        XCTAssertEqual(brain.descriptionComputed, "4.0 × ...")
        brain.performOperation("π")
        brain.performOperation("=")
        XCTAssertEqual(brain.descriptionComputed, "4.0 × π =")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
