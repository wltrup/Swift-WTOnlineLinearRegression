//
//  ObservationTests.swift
//  WTOnlineLinearRegression
//
//  Created by Wagner Truppel on 2016.12.07.
//
//  Copyright (c) 2016 Wagner Truppel. All rights reserved.
//

import UIKit
import XCTest

import WTOnlineLinearRegression

class ObservationTests: XCTestCase
{
    let x: Double = 3

    let yValue: Double = 5
    let yVariance: Double = 16
    var yStandardDeviation: Double { return sqrt(yVariance) }

    var y: UncertainValue<Double>!

    var obs1: Observation<Double>!
    var obs2: Observation<Double>!
    var obs3: Observation<Double>!

    override func setUp()
    {
        super.setUp()

        y = try! UncertainValue<Double>(value: yValue, variance: yVariance)

        obs1 = Observation<Double>(x: x, y: y)

        obs2 = try! Observation<Double>(x: x,
                                        y: yValue,
                                        yVariance: yVariance)

        obs3 = try! Observation<Double>(x: x,
                                        y: yValue,
                                        yStandardDeviation: yStandardDeviation)
    }

    // MARK: -

    func testThatInitCreatesTheExpectedObservation1()
    {
        let obs = obs1!

        XCTAssertTrue(obs.x == x)
        XCTAssertTrue(obs.y == y)
        XCTAssertTrue(obs.y.value == yValue)
        XCTAssertTrue(obs.y.variance == yVariance)
        XCTAssertTrue(obs.y.standardDeviation == yStandardDeviation)
    }

    func testThatInitCreatesTheExpectedObservation2()
    {
        let obs = obs2!

        XCTAssertTrue(obs.x == x)
        XCTAssertTrue(obs.y == y)
        XCTAssertTrue(obs.y.value == yValue)
        XCTAssertTrue(obs.y.variance == yVariance)
        XCTAssertTrue(obs.y.standardDeviation == yStandardDeviation)
    }

    func testThatInitCreatesTheExpectedObservation3()
    {
        let obs = obs3!

        XCTAssertTrue(obs.x == x)
        XCTAssertTrue(obs.y == y)
        XCTAssertTrue(obs.y.value == yValue)
        XCTAssertTrue(obs.y.variance == yVariance)
        XCTAssertTrue(obs.y.standardDeviation == yStandardDeviation)
    }

    // MARK: -

    func testThatInitThrowsOnNegativeVariance()
    {
        let variance: Double = -2

        do
        {
            obs1 = try Observation<Double>(x: x,
                                           y: yValue,
                                           yVariance: variance)
            XCTFail()
        }
        catch
        {
            let expected = InvalidArgumentError.negativeVariance(variance)

            XCTAssertTrue(error is InvalidArgumentError<Double>)
            XCTAssertEqual(error as! InvalidArgumentError<Double>, expected)
        }
    }

    func testThatInitThrowsOnNegativeStandardDeviation()
    {
        let stdDev: Double = -2

        do
        {
            obs1 = try Observation<Double>(x: x,
                                           y: yValue,
                                           yStandardDeviation: stdDev)
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

    func testInitIntIntVar1()
    {
        let x: Int = 1
        let yValue: Int = 2
        let yVar: Double = 0
        let yStdDev: Double = 0

        obs1 = try! Observation<Double>(x: x, y: yValue)

        XCTAssertTrue(obs1.x == Double(x))
        XCTAssertTrue(obs1.y.value == Double(yValue))
        XCTAssertTrue(obs1.y.variance == yVar)
        XCTAssertTrue(obs1.y.standardDeviation == yStdDev)
    }

    func testInitIntIntVar2()
    {
        let x: Int = 1
        let yValue: Int = 2
        let yVar: Double = 9
        let yStdDev: Double = sqrt(yVar)

        obs1 = try! Observation<Double>(x: x,
                                        y: yValue,
                                        yVariance: yVar)

        XCTAssertTrue(obs1.x == Double(x))
        XCTAssertTrue(obs1.y.value == Double(yValue))
        XCTAssertTrue(obs1.y.variance == yVar)
        XCTAssertTrue(obs1.y.standardDeviation == yStdDev)
    }

    func testInitIntIntStdDev()
    {
        let x: Int = 1
        let yValue: Int = 2
        let yVar: Double = 9
        let yStdDev: Double = sqrt(yVar)

        obs1 = try! Observation<Double>(x: x,
                                        y: yValue,
                                        yStandardDeviation: yStdDev)

        XCTAssertTrue(obs1.x == Double(x))
        XCTAssertTrue(obs1.y.value == Double(yValue))
        XCTAssertTrue(obs1.y.variance == yVar)
        XCTAssertTrue(obs1.y.standardDeviation == yStdDev)
    }

    // MARK: -

    func testInitIntDoubleVar1()
    {
        let x: Int = 1
        let yValue: Double = 2
        let yVar: Double = 0
        let yStdDev: Double = 0

        obs1 = try! Observation<Double>(x: x, y: yValue)

        XCTAssertTrue(obs1.x == Double(x))
        XCTAssertTrue(obs1.y.value == Double(yValue))
        XCTAssertTrue(obs1.y.variance == yVar)
        XCTAssertTrue(obs1.y.standardDeviation == yStdDev)
    }

    func testInitIntDoubleVar2()
    {
        let x: Int = 1
        let yValue: Double = 2
        let yVar: Double = 9
        let yStdDev: Double = sqrt(yVar)

        obs1 = try! Observation<Double>(x: x,
                                        y: yValue,
                                        yVariance: yVar)

        XCTAssertTrue(obs1.x == Double(x))
        XCTAssertTrue(obs1.y.value == Double(yValue))
        XCTAssertTrue(obs1.y.variance == yVar)
        XCTAssertTrue(obs1.y.standardDeviation == yStdDev)
    }

    func testInitIntDoubleStdDev()
    {
        let x: Int = 1
        let yValue: Double = 2
        let yVar: Double = 9
        let yStdDev: Double = sqrt(yVar)

        obs1 = try! Observation<Double>(x: x,
                                        y: yValue,
                                        yStandardDeviation: yStdDev)

        XCTAssertTrue(obs1.x == Double(x))
        XCTAssertTrue(obs1.y.value == Double(yValue))
        XCTAssertTrue(obs1.y.variance == yVar)
        XCTAssertTrue(obs1.y.standardDeviation == yStdDev)
    }

    // MARK: -

    func testInitDoubleIntVar1()
    {
        let x: Double = 1
        let yValue: Int = 2
        let yVar: Double = 0
        let yStdDev: Double = 0

        obs1 = try! Observation<Double>(x: x, y: yValue)

        XCTAssertTrue(obs1.x == Double(x))
        XCTAssertTrue(obs1.y.value == Double(yValue))
        XCTAssertTrue(obs1.y.variance == yVar)
        XCTAssertTrue(obs1.y.standardDeviation == yStdDev)
    }

    func testInitDoubleIntVar2()
    {
        let x: Double = 1
        let yValue: Int = 2
        let yVar: Double = 9
        let yStdDev: Double = sqrt(yVar)

        obs1 = try! Observation<Double>(x: x,
                                        y: yValue,
                                        yVariance: yVar)

        XCTAssertTrue(obs1.x == Double(x))
        XCTAssertTrue(obs1.y.value == Double(yValue))
        XCTAssertTrue(obs1.y.variance == yVar)
        XCTAssertTrue(obs1.y.standardDeviation == yStdDev)
    }

    func testInitDoubleIntStdDev()
    {
        let x: Double = 1
        let yValue: Int = 2
        let yVar: Double = 9
        let yStdDev: Double = sqrt(yVar)

        obs1 = try! Observation<Double>(x: x,
                                        y: yValue,
                                        yStandardDeviation: yStdDev)

        XCTAssertTrue(obs1.x == Double(x))
        XCTAssertTrue(obs1.y.value == Double(yValue))
        XCTAssertTrue(obs1.y.variance == yVar)
        XCTAssertTrue(obs1.y.standardDeviation == yStdDev)
    }

    // MARK: -

    func testWithYVariance()
    {
        let yVar: Double = 10
        let yStdDev: Double = sqrt(yVar)

        let obs2 = try! obs1.with(yVariance: yVar)

        XCTAssertTrue(obs2.x == obs1.x)
        XCTAssertTrue(obs2.y.standardDeviation == yStdDev)
        XCTAssertTrue(obs2.y.variance == yVar)
        XCTAssertTrue(obs2.yHasVariance)
    }

    func testWithYVarianceThrowsOnNegativeVariance()
    {
        let variance: Double = -2

        do
        {
            let _ = try obs1.with(yVariance: variance)
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

    func testWithYStandardDeviation()
    {
        let yStdDev: Double = 10
        let yVar: Double = yStdDev * yStdDev

        let obs2 = try! obs1.with(yStandardDeviation: yStdDev)

        XCTAssertTrue(obs2.x == obs1.x)
        XCTAssertTrue(obs2.y.standardDeviation == yStdDev)
        XCTAssertTrue(obs2.y.variance == yVar)
        XCTAssertTrue(obs2.yHasVariance)
    }

    func testWithYStandardDeviationThrowsOnNegativeStandardDeviation()
    {
        let stdDev: Double = -2

        do
        {
            let _ = try obs1.with(yStandardDeviation: stdDev)
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

    func testConformanceToEquatable1()
    {
        let obs2 = obs1
        XCTAssertTrue(obs2 == obs1)
    }

    func testConformanceToEquatable2()
    {
        let obs2 = try! Observation<Double>(x: 8,
                                            y: yValue,
                                            yVariance: yVariance)

        XCTAssertTrue(obs2 != obs1)
    }

    func testConformanceToEquatable3()
    {
        let obs2 = try! Observation<Double>(x: x,
                                            y: 2,
                                            yVariance: yVariance)

        XCTAssertTrue(obs2 != obs1)
    }

    func testConformanceToEquatable4()
    {
        let obs2 = try! Observation<Double>(x: x,
                                            y: yValue,
                                            yVariance: 25)
        
        XCTAssertTrue(obs2 != obs1)
    }
}

