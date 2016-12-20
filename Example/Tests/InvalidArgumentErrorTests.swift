//
//  InvalidArgumentErrorTests.swift
//  WTOnlineLinearRegression
//
//  Created by Wagner Truppel on 2016.12.07.
//
//  Copyright (c) 2016 Wagner Truppel. All rights reserved.
//

import UIKit
import XCTest

import WTOnlineLinearRegression

class InvalidArgumentErrorTests: XCTestCase
{
    func testEquality1()
    {
        let error1 = InvalidArgumentError<Double>.negativeValue(-1)
        let error2 = error1
        XCTAssertTrue(error2 == error1)
    }

    func testEquality2()
    {
        let error1 = InvalidArgumentError<Double>.negativeVariance(-1)
        let error2 = error1
        XCTAssertTrue(error2 == error1)
    }

    func testEquality3()
    {
        let error1 = InvalidArgumentError<Double>.negativeStandardDeviation(-1)
        let error2 = error1
        XCTAssertTrue(error2 == error1)
    }

    // MARK: -

    func testInequality1()
    {
        let error1 = InvalidArgumentError<Double>.negativeValue(-1)
        let error2 = InvalidArgumentError<Double>.negativeValue(-2)
        XCTAssertTrue(error2 != error1)
    }

    func testInequality2()
    {
        let error1 = InvalidArgumentError<Double>.negativeVariance(-1)
        let error2 = InvalidArgumentError<Double>.negativeVariance(-2)
        XCTAssertTrue(error2 != error1)
    }

    func testInequality3()
    {
        let error1 = InvalidArgumentError<Double>.negativeStandardDeviation(-1)
        let error2 = InvalidArgumentError<Double>.negativeStandardDeviation(-2)
        XCTAssertTrue(error2 != error1)
    }

    // MARK: -

    func testInequality12()
    {
        let error1 = InvalidArgumentError<Double>.negativeValue(-1)
        let error2 = InvalidArgumentError<Double>.negativeVariance(-1)
        XCTAssertTrue(error1 != error2)
    }

    func testInequality13()
    {
        let error1 = InvalidArgumentError<Double>.negativeValue(-1)
        let error3 = InvalidArgumentError<Double>.negativeStandardDeviation(-1)
        XCTAssertTrue(error1 != error3)
    }

    func testInequality23()
    {
        let error2 = InvalidArgumentError<Double>.negativeVariance(-1)
        let error3 = InvalidArgumentError<Double>.negativeStandardDeviation(-1)
        XCTAssertTrue(error2 != error3)
    }
}

