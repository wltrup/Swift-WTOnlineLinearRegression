//
//  UncertainValueTests.swift
//  WTOnlineLinearRegression
//
//  Created by Wagner Truppel on 2016.12.07.
//
//  Copyright (c) 2016 Wagner Truppel. All rights reserved.
//

import UIKit
import XCTest

import WTOnlineLinearRegression

class UncertainValueTests: XCTestCase
{
    func testNoParamInit()
    {
        let sut = UncertainValue<Double>()

        XCTAssertEqual(sut.value, 0)
        XCTAssertEqual(sut.variance, 0)
        XCTAssertEqual(sut.standardDeviation, 0)
    }

    // MARK: -

    func testVarianceInit()
    {
        let value: Double = 5
        let variance: Double = 64
        let stdDev: Double = sqrt(variance)

        let sut = try! UncertainValue<Double>(value: value, variance: variance)

        XCTAssertEqual(sut.value, value)
        XCTAssertEqual(sut.variance, variance)
        XCTAssertEqual(sut.standardDeviation, stdDev)
    }

    func testVarianceInitThrowsOnNegativeVariance()
    {
        let variance: Double = -3

        do
        {
            let _ = try UncertainValue<Double>(value: 5, variance: variance)
            XCTFail()
        }
        catch
        {
            let expected = InvalidArgumentError.negativeVariance(variance)

            XCTAssertTrue(error is InvalidArgumentError<Double>)
            XCTAssertEqual(error as! InvalidArgumentError<Double>, expected)
        }
    }

    // MARK: -

    func testStandardDeviationInit()
    {
        let value: Double = 5
        let stdDev: Double = 8
        let variance: Double = stdDev * stdDev

        let sut = try! UncertainValue<Double>(value: value, standardDeviation: stdDev)

        XCTAssertEqual(sut.value, value)
        XCTAssertEqual(sut.variance, variance)
        XCTAssertEqual(sut.standardDeviation, stdDev)
    }

    func testStandardDeviationInitThrowsOnNegativeStandardDeviation()
    {
        let stdDev: Double = -3

        do
        {
            let _ = try UncertainValue<Double>(value: 5, standardDeviation: stdDev)
            XCTFail()
        }
        catch
        {
            let expected = InvalidArgumentError.negativeStandardDeviation(stdDev)

            XCTAssertTrue(error is InvalidArgumentError<Double>)
            XCTAssertEqual(error as! InvalidArgumentError<Double>, expected)
        }
    }

    // MARK: -

    func testEquality()
    {
        let value: Double = 5
        let variance: Double = 64

        let sut1 = try! UncertainValue<Double>(value: value, variance: variance)
        let sut2 = sut1

        XCTAssertTrue(sut2 == sut1)
    }

    func testInequalityValue()
    {
        let variance: Double = 64

        let sut1 = try! UncertainValue<Double>(value: 3, variance: variance)
        let sut2 = try! UncertainValue<Double>(value: 5, variance: variance)

        XCTAssertTrue(sut2 != sut1)
    }

    func testInequalityVariance()
    {
        let value: Double = 3

        let sut1 = try! UncertainValue<Double>(value: value, variance: 5)
        let sut2 = try! UncertainValue<Double>(value: value, variance: 8)

        XCTAssertTrue(sut2 != sut1)
    }

    func testInequalityStandardDeviation()
    {
        let value: Double = 3

        let sut1 = try! UncertainValue<Double>(value: value, standardDeviation: 5)
        let sut2 = try! UncertainValue<Double>(value: value, standardDeviation: 8)
        
        XCTAssertTrue(sut2 != sut1)
    }
}

