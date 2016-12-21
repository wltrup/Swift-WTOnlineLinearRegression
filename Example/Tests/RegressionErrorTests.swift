//
//  RegressionErrorTests.swift
//  WTOnlineLinearRegression
//
//  Created by Wagner Truppel on 2016.12.07.
//
//  Copyright (c) 2016 Wagner Truppel. All rights reserved.
//

import UIKit
import XCTest

import WTOnlineLinearRegression

class RegressionErrorTests: XCTestCase
{
    let quantity: Double = -3
    let obs = try! Observation<Double>(x: 1, y: 2, yVariance: 3)

    var error1: RegressionError<Double>!
    var error2: RegressionError<Double>!
    var error3: RegressionError<Double>!

    // MARK: -

    override func setUp()
    {
        super.setUp()

        error1 = RegressionError.invalidMinimumVarianceInY(quantity)
        error2 = RegressionError.cannotRemoveObservationFromEmptyCollection(obs)
        error3 = RegressionError.cannotRemoveNonExistingObservation(obs)
    }

    // MARK: -
    
    func testEquality1()
    {
        let error4 = error1
        XCTAssertTrue(error4 == error1)
    }

    func testEquality2()
    {
        let error4 = error2
        XCTAssertTrue(error4 == error2)
    }

    func testEquality3()
    {
        let error4 = error3
        XCTAssertTrue(error4 == error3)
    }

    // MARK: -

    func testInequality12()
    {
        XCTAssertTrue(error1 != error2)
    }

    func testInequality13()
    {
        XCTAssertTrue(error1 != error3)
    }

    func testInequality23()
    {
        XCTAssertTrue(error2 != error3)
    }
}

