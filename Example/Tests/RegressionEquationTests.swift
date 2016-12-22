//
//  RegressionEquationTests.swift
//  WTOnlineLinearRegression
//
//  Created by Wagner Truppel on 2016.12.07.
//
//  Copyright (c) 2016 Wagner Truppel. All rights reserved.
//

import UIKit
import XCTest

import WTOnlineLinearRegression

class RegressionEquationTests: XCTestCase
{
    var slope = try! UncertainValue<Double>(value: 3, variance: 5)
    var interceptY = try! UncertainValue<Double>(value: -4, variance: 2)
    var interceptX: Double = 7
    var x: Double = -4
    var y: Double = 3

    var linEq1: RegressionEquation<Double>!
    var linEq2: RegressionEquation<Double>!
    var linEq3: RegressionEquation<Double>!

    override func setUp()
    {
        super.setUp()

        linEq1 = RegressionEquation<Double>.finiteSlope(slope: slope,
                                                        interceptY: interceptY)
        linEq2 = RegressionEquation<Double>.infiniteSlope(interceptX: interceptX)
        linEq3 = RegressionEquation<Double>.degenerate(x: x, y: y)
    }

    // MARK: -

    func testIsDegenerate1()
    {
        XCTAssertFalse(linEq1.isDegenerate)
    }

    func testIsDegenerate2()
    {
        XCTAssertFalse(linEq2.isDegenerate)
    }

    func testIsDegenerate3()
    {
        XCTAssertTrue(linEq3.isDegenerate)
    }

    // MARK: -

    func testHasFiniteSlope1()
    {
        XCTAssertTrue(linEq1.hasFiniteSlope)
    }

    func testHasFiniteSlope2()
    {
        XCTAssertFalse(linEq2.hasFiniteSlope)
    }

    func testHasFiniteSlope3()
    {
        XCTAssertFalse(linEq3.hasFiniteSlope)
    }

    // MARK: -

    func testHasZeroSlope0()
    {
        slope = try! UncertainValue<Double>(value: 0, variance: 5)
        linEq1 = RegressionEquation<Double>.finiteSlope(slope: slope,
                                                        interceptY: interceptY)
        XCTAssertTrue(linEq1.hasZeroSlope)
    }

    func testHasZeroSlope1()
    {
        XCTAssertFalse(linEq1.hasZeroSlope)
    }

    func testHasZeroSlope2()
    {
        XCTAssertFalse(linEq2.hasZeroSlope)
    }

    func testHasZeroSlope3()
    {
        XCTAssertFalse(linEq3.hasZeroSlope)
    }

    // MARK: -

    func testSlope1()
    {
        let expected = slope
        let resulted = linEq1.slope
        XCTAssertEqual(resulted, expected)
    }

    func testSlope2()
    {
        let expected: UncertainValue<Double>? = nil
        let resulted = linEq2.slope
        XCTAssertEqual(resulted, expected)
    }

    func testSlope3()
    {
        let expected: UncertainValue<Double>? = nil
        let resulted = linEq3.slope
        XCTAssertEqual(resulted, expected)
    }

    // MARK: -

    func testInterceptY1()
    {
        let expected = interceptY
        let resulted = linEq1.interceptY
        XCTAssertEqual(resulted, expected)
    }

    func testInterceptY2()
    {
        let expected: UncertainValue<Double>? = nil
        let resulted = linEq2.interceptY
        XCTAssertEqual(resulted, expected)
    }

    func testY3()
    {
        XCTAssertEqual(linEq3.interceptY, nil)
    }

    // MARK: -

    func testInterceptX0()
    {
        slope = try! UncertainValue<Double>(value: 0, variance: 5)
        linEq1 = RegressionEquation<Double>.finiteSlope(slope: slope,
                                                        interceptY: interceptY)
        XCTAssertEqual(linEq1.interceptX, nil)
    }

    func testInterceptX1()
    {
        let expected = -(interceptY.value / slope.value)
        let resulted = linEq1.interceptX
        XCTAssertEqual(resulted, expected)
    }

    func testInterceptX2()
    {
        let expected = interceptX
        let resulted = linEq2.interceptX
        XCTAssertEqual(resulted, expected)
    }

    func testInterceptX3()
    {
        XCTAssertEqual(linEq3.interceptX, nil)
    }

    // MARK: -

    func testConformanceToEquatable11a()
    {
        XCTAssertTrue(linEq1 == linEq1)
    }

    func testConformanceToEquatable11b()
    {
        let s1: Double = 10
        let s2: Double = 1

        let sv1: Double = 2
        let sv2: Double = 2

        let iy1: Double = 3
        let iy2: Double = 3

        let viy1: Double = 4
        let viy2: Double = 4

        let slope1 = try! UncertainValue<Double>(value: s1, variance: sv1)
        let slope2 = try! UncertainValue<Double>(value: s2, variance: sv2)

        let intcptY1 = try! UncertainValue<Double>(value: iy1, variance: viy1)
        let intcptY2 = try! UncertainValue<Double>(value: iy2, variance: viy2)

        let linEq1 = RegressionEquation<Double>.finiteSlope(slope: slope1,
                                                            interceptY: intcptY1)
        let linEq2 = RegressionEquation<Double>.finiteSlope(slope: slope2,
                                                            interceptY: intcptY2)

        XCTAssertTrue(linEq2 != linEq1)
    }

    func testConformanceToEquatable11c()
    {
        let s1: Double = 1
        let s2: Double = 1

        let sv1: Double = 20
        let sv2: Double = 2

        let iy1: Double = 3
        let iy2: Double = 3

        let viy1: Double = 4
        let viy2: Double = 4

        let slope1 = try! UncertainValue<Double>(value: s1, variance: sv1)
        let slope2 = try! UncertainValue<Double>(value: s2, variance: sv2)

        let intcptY1 = try! UncertainValue<Double>(value: iy1, variance: viy1)
        let intcptY2 = try! UncertainValue<Double>(value: iy2, variance: viy2)

        let linEq1 = RegressionEquation<Double>.finiteSlope(slope: slope1,
                                                            interceptY: intcptY1)
        let linEq2 = RegressionEquation<Double>.finiteSlope(slope: slope2,
                                                            interceptY: intcptY2)

        XCTAssertTrue(linEq2 != linEq1)
    }

    func testConformanceToEquatable11d()
    {
        let s1: Double = 1
        let s2: Double = 1

        let sv1: Double = 2
        let sv2: Double = 2

        let iy1: Double = 30
        let iy2: Double = 3

        let viy1: Double = 4
        let viy2: Double = 4

        let slope1 = try! UncertainValue<Double>(value: s1, variance: sv1)
        let slope2 = try! UncertainValue<Double>(value: s2, variance: sv2)

        let intcptY1 = try! UncertainValue<Double>(value: iy1, variance: viy1)
        let intcptY2 = try! UncertainValue<Double>(value: iy2, variance: viy2)

        let linEq1 = RegressionEquation<Double>.finiteSlope(slope: slope1,
                                                            interceptY: intcptY1)
        let linEq2 = RegressionEquation<Double>.finiteSlope(slope: slope2,
                                                            interceptY: intcptY2)

        XCTAssertTrue(linEq2 != linEq1)
    }

    func testConformanceToEquatable11e()
    {
        let s1: Double = 1
        let s2: Double = 1

        let sv1: Double = 2
        let sv2: Double = 2

        let iy1: Double = 3
        let iy2: Double = 3

        let viy1: Double = 40
        let viy2: Double = 4

        let slope1 = try! UncertainValue<Double>(value: s1, variance: sv1)
        let slope2 = try! UncertainValue<Double>(value: s2, variance: sv2)

        let intcptY1 = try! UncertainValue<Double>(value: iy1, variance: viy1)
        let intcptY2 = try! UncertainValue<Double>(value: iy2, variance: viy2)

        let linEq1 = RegressionEquation<Double>.finiteSlope(slope: slope1,
                                                            interceptY: intcptY1)
        let linEq2 = RegressionEquation<Double>.finiteSlope(slope: slope2,
                                                            interceptY: intcptY2)

        XCTAssertTrue(linEq2 != linEq1)
    }

    func testConformanceToEquatable12()
    {
        XCTAssertTrue(linEq1 != linEq2)
    }

    func testConformanceToEquatable13()
    {
        XCTAssertTrue(linEq1 != linEq3)
    }

    func testConformanceToEquatable22a()
    {
        XCTAssertTrue(linEq2 == linEq2)
    }

    func testConformanceToEquatable22b()
    {
        let ix1: Double = 10
        let ix2: Double = 1

        let linEq1 = RegressionEquation<Double>.infiniteSlope(interceptX: ix1)
        let linEq2 = RegressionEquation<Double>.infiniteSlope(interceptX: ix2)

        XCTAssertTrue(linEq2 != linEq1)
    }

    func testConformanceToEquatable23()
    {
        XCTAssertTrue(linEq2 != linEq3)
    }

    func testConformanceToEquatable33a()
    {
        XCTAssertTrue(linEq3 == linEq3)
    }

    func testConformanceToEquatable33b()
    {
        let x1: Double = 10
        let x2: Double = 1

        let y: Double = 2

        let linEq1 = RegressionEquation<Double>.degenerate(x: x1, y: y)
        let linEq2 = RegressionEquation<Double>.degenerate(x: x2, y: y)
        
        XCTAssertTrue(linEq2 != linEq1)
    }
    
    func testConformanceToEquatable33c()
    {
        let x: Double = 1
        
        let y1: Double = 20
        let y2: Double = 2
        
        let linEq1 = RegressionEquation<Double>.degenerate(x: x, y: y1)
        let linEq2 = RegressionEquation<Double>.degenerate(x: x, y: y2)
        
        XCTAssertTrue(linEq2 != linEq1)
    }
}

