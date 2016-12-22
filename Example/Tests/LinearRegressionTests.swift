//
//  LinearRegressionTests.swift
//  WTOnlineLinearRegression
//
//  Created by Wagner Truppel on 2016.12.07.
//
//  Copyright (c) 2016 Wagner Truppel. All rights reserved.
//

import UIKit
import XCTest
@testable import WTOnlineLinearRegression

class LinearRegressionTests: XCTestCase
{
    func testInitIgnoringVarianceInYFalse()
    {
        let ignoringVar = false
        let reg = try! LinearRegression<Double>(ignoringVarianceInY: ignoringVar)
        XCTAssertEqual(reg.ignoringVarianceInY, ignoringVar)
    }

    func testInitIgnoringVarianceInYTrue()
    {
        let ignoringVar = true
        let reg = try! LinearRegression<Double>(ignoringVarianceInY: ignoringVar)
        XCTAssertEqual(reg.ignoringVarianceInY, ignoringVar)
    }

    // MARK: -

    func testInitKeepingHistoryFalse()
    {
        let keepingHist = false
        let ignoringVar = false

        let reg = try! LinearRegression<Double>(ignoringVarianceInY: ignoringVar,
                                                keepingHistory: keepingHist)

        XCTAssertEqual(reg.keepingHistory, keepingHist)
    }

    func testInitKeepingHistoryTrue()
    {
        let keepingHist = true
        let ignoringVar = false

        let reg = try! LinearRegression<Double>(ignoringVarianceInY: ignoringVar,
                                                keepingHistory: keepingHist)

        XCTAssertEqual(reg.keepingHistory, keepingHist)
    }

    // MARK: -

    func testInitDefaultMinimumVarianceInY()
    {
        let defaultVar: Double = 1e-3
        let ignoringVar = false

        let reg = try! LinearRegression<Double>(ignoringVarianceInY: ignoringVar,
                                                minimumVarianceInY: defaultVar)

        XCTAssertEqual(reg.minimumVarianceInY, defaultVar)
    }

    func testInitDefaultMinimumVarianceInYThrowsOnZero()
    {
        let defaultVar: Double = 0
        let ignoringVar = false

        do
        {
            let _ = try LinearRegression<Double>(ignoringVarianceInY: ignoringVar,
                                                 minimumVarianceInY: defaultVar)
            XCTFail()
        }
        catch
        {
            let expected = RegressionError.invalidMinimumVarianceInY(defaultVar)

            XCTAssertTrue(error is RegressionError<Double>)
            XCTAssertEqual(error as! RegressionError<Double>, expected)
        }
    }

    func testInitDefaultMinimumVarianceInYThrowsOnNegative()
    {
        let defaultVar: Double = -5
        let ignoringVar = false

        do
        {
            let _ = try LinearRegression<Double>(ignoringVarianceInY: ignoringVar,
                                                 minimumVarianceInY: defaultVar)
            XCTFail()
        }
        catch
        {
            let expected = RegressionError.invalidMinimumVarianceInY(defaultVar)

            XCTAssertTrue(error is RegressionError<Double>)
            XCTAssertEqual(error as! RegressionError<Double>, expected)
        }
    }

    // MARK: -

    func testRemoveThrowsWhenNoObservations()
    {
        let obs1 = try! Observation<Double>(x: 1, y: 0)

        do
        {
            let reg = try! LinearRegression<Double>(ignoringVarianceInY: false)
            try reg.remove(obs1)

            XCTFail()
        }
        catch
        {
            let expected = RegressionError
                .cannotRemoveObservationFromEmptyCollection(obs1)

            XCTAssertTrue(error is RegressionError<Double>)
            XCTAssertEqual(error as! RegressionError<Double>, expected)
        }
    }

    func testRemoveThrowsWhenUnknownObservation()
    {
        let obs1 = try! Observation<Double>(x: 1, y: 0)
        let obs2 = try! Observation<Double>(x: 0, y: 2)

        do
        {
            let reg = try! LinearRegression<Double>(ignoringVarianceInY: false)

            reg.add(obs1)
            try reg.remove(obs2)

            XCTFail()
        }
        catch
        {
            let expected = RegressionError
                .cannotRemoveNonExistingObservation(obs2)

            XCTAssertTrue(error is RegressionError<Double>)
            XCTAssertEqual(error as! RegressionError<Double>, expected)
        }
    }

    // MARK: -

    func testNoHistory_0_observations()
    {
        let keepingHist = false
        let ignoringVar = false

        let reg = try! LinearRegression<Double>(ignoringVarianceInY: ignoringVar,
                                                keepingHistory: keepingHist)

        let expHistory: [RegressionData<Double>] = []
        let expCurData = RegressionData<Double>()

        XCTAssertEqual(reg.history.count, 0)
        XCTAssertEqual(reg.history, expHistory)
        XCTAssertEqual(reg.currentData, expCurData)
    }

    // MARK: -

    fileprivate func applyTestNoHistory(ignoringVarianceInY: Bool,
                                        observations: [Observation<Double>],
                                        adding: [Int],
                                        removing: [Int],
                                        tolerance: Double = 1e-10)
    {
        // Given

        let indicesToAddSet = Set<Int>(adding)
        let indicesToRemoveSet = Set<Int>(removing)
        let indices = indicesToAddSet.subtracting(indicesToRemoveSet)

        let reg = try! LinearRegression<Double>(ignoringVarianceInY: ignoringVarianceInY,
                                                keepingHistory: false)

        let obsToUse = indices.map {
            (index: Int) -> Observation<Double> in
            let obs = observations[index]
            let safeObs: Observation<Double>
            if !ignoringVarianceInY && !obs.yHasVariance
            { safeObs = try! obs.with(yVariance: reg.minimumVarianceInY) }
            else if ignoringVarianceInY
            { safeObs = try! obs.with(yVariance: 1) }
            else
            { safeObs = obs }
            return safeObs
        }

        let sone = obsToUse.map { 1.0 / $0.y.variance }.reduce(0, +)
        print("sone: \(sone)")

        let sx = obsToUse.map { $0.x / $0.y.variance }.reduce(0, +)
        print("sx: \(sx)")

        let sy = obsToUse.map { $0.y.value / $0.y.variance }.reduce(0, +)
        print("sy: \(sy)")

        let sxy = obsToUse.map { ($0.x * $0.y.value) / $0.y.variance }.reduce(0, +)
        print("sxy: \(sxy)")

        let sxsq = obsToUse.map { ($0.x * $0.x) / $0.y.variance }.reduce(0, +)
        print("sxsq: \(sxsq)")

        let sysq = obsToUse.map { ($0.y.value * $0.y.value) / $0.y.variance }.reduce(0, +)
        print("sysq: \(sysq)")

        let mx: Double = (sone == 0 ? 0 : sx / sone)
        print("mx: \(mx)")

        let my: Double = (sone == 0 ? 0 : sy / sone)
        print("my: \(my)")

        let mxy: Double = (sone == 0 ? 0 : sxy / sone)
        print("mxy: \(mxy)")

        let mxsq: Double = (sone == 0 ? 0 : sxsq / sone)
        print("mxsq: \(mxsq)")

        let delta = mxsq - mx * mx
        print("delta: \(delta)")

        let deltaTimesSlope = mxy - mx * my
        print("deltaTimesSlope: \(deltaTimesSlope)")

        let deltaTimesIntcptY = mxsq * my - mx * mxy
        print("deltaTimesIntcptY: \(deltaTimesIntcptY)")

        let a: Double? = (delta == 0 ? nil : deltaTimesSlope / delta)
        print("a: \(a == nil ? "nil" : "\(a!)")")

        let b: Double? = (delta == 0 ? nil : deltaTimesIntcptY / delta)
        print("b: \(b == nil ? "nil" : "\(b!)")")

        let mTotSE = obsToUse
            .map { (obs: Observation<Double>) -> Double in
                let u = obs.y.value - my
                let v = (u * u) / obs.y.variance
                return v / sone
            }.reduce(0, +)
        print("mTotSE: \(mTotSE)")

        let mResSE: Double? = (delta == 0 ? nil :
            obsToUse
                .map { (obs: Observation<Double>) -> Double in
                    let u = a! * obs.x + b! - obs.y.value
                    let v = (u * u) / obs.y.variance
                    return v / sone
                }
                .reduce(0, +)
        )
        print("mResSE: \(mResSE == nil ? "nil" : "\(mResSE!)")")

        let mRegSE: Double? = (delta == 0 ? nil :
            obsToUse
                .map { (obs: Observation<Double>) -> Double in
                    let u = a! * obs.x + b! - my
                    let v = (u * u) / obs.y.variance
                    return v / sone
                }
                .reduce(0, +)
        )
        print("mRegSE: \(mRegSE == nil ? "nil" : "\(mRegSE!)")")

        let rSquared: Double?
        if delta == 0
        {
            if mTotSE == 0
            { rSquared = nil } // degenerate line
            else
            { rSquared = 1 } // vertical line
        }
        else
        {
            if mTotSE == 0
            { rSquared = 1 } // horizontal line
            else
            { rSquared = 1 - mResSE! / mTotSE } // typical line
        }
        print("rSquared: \(rSquared == nil ? "nil" : "\(rSquared!)")")

        let ix: Double?
        if mTotSE == 0
        { ix = nil } // degenerate or horizontal line
        else
        {
            if delta == 0
            { ix = mx } // vertical line
            else
            { ix = -b!/a! } // typical line
        }
        print("ix: \(ix == nil ? "nil" : "\(ix!)")")

        // When

        let obsToAdd = adding.map { observations[$0] }
        let obsToRemove = removing.map { observations[$0] }

        obsToAdd.forEach { reg.add($0) }
        obsToRemove.forEach { try! reg.remove($0) }

        // Then

        XCTAssertEqualWithAccuracy(reg.currentData.sumOneOverVarianceY,
                                   sone, accuracy: tolerance)
        XCTAssertEqualWithAccuracy(reg.currentData.sumXoverVarianceY,
                                   sx, accuracy: tolerance)
        XCTAssertEqualWithAccuracy(reg.currentData.sumYoverVarianceY,
                                   sy, accuracy: tolerance)
        XCTAssertEqualWithAccuracy(reg.currentData.sumXYoverVarianceY,
                                   sxy, accuracy: tolerance)
        XCTAssertEqualWithAccuracy(reg.currentData.sumXsquaredOverVarianceY,
                                   sxsq, accuracy: tolerance)
        XCTAssertEqualWithAccuracy(reg.currentData.sumYsquaredOverVarianceY,
                                   sysq, accuracy: tolerance)
        XCTAssertEqualWithAccuracy(reg.currentData.meanTotalSquaredError,
                                   mTotSE, accuracy: tolerance)

        if mResSE == nil
        { XCTAssertNil(reg.currentData.meanSquaredResidualError) }
        else
        {
            let result = reg.currentData.meanSquaredResidualError
            XCTAssertNotNil(result)
            XCTAssertEqualWithAccuracy(result!, mResSE!, accuracy: tolerance)
        }

        if mRegSE == nil
        { XCTAssertNil(reg.currentData.meanSquaredRegressionError) }
        else
        {
            let result = reg.currentData.meanSquaredRegressionError
            XCTAssertNotNil(result)
            XCTAssertEqualWithAccuracy(result!, mRegSE!, accuracy: tolerance)
        }

        if rSquared == nil
        { XCTAssertNil(reg.currentData.rSquared) }
        else
        {
            let result = reg.currentData.rSquared
            XCTAssertNotNil(result)
            XCTAssertEqualWithAccuracy(result!, rSquared!, accuracy: tolerance)
        }

        let eq = reg.currentData.equation

        if a == nil
        { XCTAssertNil(eq?.slope) }
        else
        {
            XCTAssertNotNil(eq?.slope)
            let result = eq?.slope!.value
            XCTAssertEqualWithAccuracy(result!, a!, accuracy: tolerance)
        }

        if b == nil
        { XCTAssertNil(eq?.interceptY) }
        else
        {
            XCTAssertNotNil(eq?.interceptY)
            let result = eq?.interceptY!.value
            XCTAssertEqualWithAccuracy(result!, b!, accuracy: tolerance)
        }

        if ix == nil
        { XCTAssertNil(eq?.interceptX) }
        else
        {
            XCTAssertNotNil(eq?.interceptX)
            let result = eq?.interceptX
            XCTAssertEqualWithAccuracy(result!, ix!, accuracy: tolerance)
        }
    }

    // MARK: -

    func test_not_ignoringVariance_1_observation()
    {
        let ignoringVar = false

        let observations: [Observation<Double>] = [
            try! Observation<Double>(x: 1, y: 0)
        ]

        applyTestNoHistory(ignoringVarianceInY: ignoringVar,
                           observations: observations,
                           adding: [0],
                           removing: [])
    }

    func test_not_ignoringVariance_2_observations()
    {
        let ignoringVar = false

        let observations: [Observation<Double>] = [
            try! Observation<Double>(x: 1, y: 0),
            try! Observation<Double>(x: 0, y: 2)
        ]

        applyTestNoHistory(ignoringVarianceInY: ignoringVar,
                           observations: observations,
                           adding: [0, 1],
                           removing: [])
    }

    func test_not_ignoringVariance_3_observations()
    {
        let ignoringVar = false

        let observations: [Observation<Double>] = [
            try! Observation<Double>(x: 1, y: 0),
            try! Observation<Double>(x: 0, y: 2),
            try! Observation<Double>(x: 0.5, y: 1)
        ]

        applyTestNoHistory(ignoringVarianceInY: ignoringVar,
                           observations: observations,
                           adding: [0, 1, 2],
                           removing: [])
    }


    func test_not_ignoringVariance_3_observations_remove_1()
    {
        let ignoringVar = false

        let observations: [Observation<Double>] = [
            try! Observation<Double>(x: 1, y: 0),
            try! Observation<Double>(x: 0, y: 2),
            try! Observation<Double>(x: 0.5, y: 1)
        ]

        applyTestNoHistory(ignoringVarianceInY: ignoringVar,
                           observations: observations,
                           adding: [0, 1, 2],
                           removing: [0])
    }

    func test_not_ignoringVariance_3_observations_remove_2()
    {
        let ignoringVar = false

        let observations: [Observation<Double>] = [
            try! Observation<Double>(x: 1, y: 0),
            try! Observation<Double>(x: 0, y: 2),
            try! Observation<Double>(x: 0.5, y: 1)
        ]

        applyTestNoHistory(ignoringVarianceInY: ignoringVar,
                           observations: observations,
                           adding: [0, 1, 2],
                           removing: [0, 2])
    }

    func test_not_ignoringVariance_3_observations_remove_3()
    {
        let ignoringVar = false

        let observations: [Observation<Double>] = [
            try! Observation<Double>(x: 1, y: 0),
            try! Observation<Double>(x: 0, y: 2),
            try! Observation<Double>(x: 0.5, y: 1)
        ]

        applyTestNoHistory(ignoringVarianceInY: ignoringVar,
                           observations: observations,
                           adding: [0, 1, 2],
                           removing: [2, 0, 1])
    }

    // MARK: -

    func test_not_ignoringVariance_degenerateLine()
    {
        let ignoringVar = false

        let observations: [Observation<Double>] = [
            try! Observation<Double>(x: 1, y: 0),
            try! Observation<Double>(x: 1, y: 0)
        ]

        applyTestNoHistory(ignoringVarianceInY: ignoringVar,
                           observations: observations,
                           adding: [0, 1],
                           removing: [])
    }

    // MARK: -

    func test_not_ignoringVariance_zeroSlope()
    {
        let ignoringVar = false

        let observations: [Observation<Double>] = [
            try! Observation<Double>(x: 1, y: 2),
            try! Observation<Double>(x: 2, y: 2)
        ]

        applyTestNoHistory(ignoringVarianceInY: ignoringVar,
                           observations: observations,
                           adding: [0, 1],
                           removing: [])
    }

    // MARK: -

    func test_not_ignoringVariance_infiniteSlope()
    {
        let ignoringVar = false

        let observations: [Observation<Double>] = [
            try! Observation<Double>(x: 1, y: 0),
            try! Observation<Double>(x: 1, y: 2)
        ]

        applyTestNoHistory(ignoringVarianceInY: ignoringVar,
                           observations: observations,
                           adding: [0, 1],
                           removing: [])
    }

    // MARK: -

    func test_ignoringVariance_1_observation()
    {
        let ignoringVar = true

        let observations: [Observation<Double>] = [
            try! Observation<Double>(x: 1, y: 0)
        ]

        applyTestNoHistory(ignoringVarianceInY: ignoringVar,
                           observations: observations,
                           adding: [0],
                           removing: [])
    }

    func test_ignoringVariance_2_observations()
    {
        let ignoringVar = true

        let observations: [Observation<Double>] = [
            try! Observation<Double>(x: 1, y: 0),
            try! Observation<Double>(x: 0, y: 2)
        ]

        applyTestNoHistory(ignoringVarianceInY: ignoringVar,
                           observations: observations,
                           adding: [0, 1],
                           removing: [])
    }

    func test_ignoringVariance_3_observations()
    {
        let ignoringVar = true

        let observations: [Observation<Double>] = [
            try! Observation<Double>(x: 1, y: 0),
            try! Observation<Double>(x: 0, y: 2),
            try! Observation<Double>(x: 0.5, y: 1)
        ]

        applyTestNoHistory(ignoringVarianceInY: ignoringVar,
                           observations: observations,
                           adding: [0, 1, 2],
                           removing: [])
    }


    func test_ignoringVariance_3_observations_remove_1()
    {
        let ignoringVar = true

        let observations: [Observation<Double>] = [
            try! Observation<Double>(x: 1, y: 0),
            try! Observation<Double>(x: 0, y: 2),
            try! Observation<Double>(x: 0.5, y: 1)
        ]

        applyTestNoHistory(ignoringVarianceInY: ignoringVar,
                           observations: observations,
                           adding: [0, 1, 2],
                           removing: [0])
    }

    func test_ignoringVariance_3_observations_remove_2()
    {
        let ignoringVar = true

        let observations: [Observation<Double>] = [
            try! Observation<Double>(x: 1, y: 0),
            try! Observation<Double>(x: 0, y: 2),
            try! Observation<Double>(x: 0.5, y: 1)
        ]

        applyTestNoHistory(ignoringVarianceInY: ignoringVar,
                           observations: observations,
                           adding: [0, 1, 2],
                           removing: [0, 2])
    }

    func test_ignoringVariance_3_observations_remove_3()
    {
        let ignoringVar = true

        let observations: [Observation<Double>] = [
            try! Observation<Double>(x: 1, y: 0),
            try! Observation<Double>(x: 0, y: 2),
            try! Observation<Double>(x: 0.5, y: 1)
        ]

        applyTestNoHistory(ignoringVarianceInY: ignoringVar,
                           observations: observations,
                           adding: [0, 1, 2],
                           removing: [2, 0, 1])
    }

    // MARK: -

    func test_ignoringVariance_degenerateLine()
    {
        let ignoringVar = true

        let observations: [Observation<Double>] = [
            try! Observation<Double>(x: 1, y: 0),
            try! Observation<Double>(x: 1, y: 0)
        ]

        applyTestNoHistory(ignoringVarianceInY: ignoringVar,
                           observations: observations,
                           adding: [0, 1],
                           removing: [])
    }

    // MARK: -

    func test_ignoringVariance_zeroSlope()
    {
        let ignoringVar = true

        let observations: [Observation<Double>] = [
            try! Observation<Double>(x: 1, y: 2),
            try! Observation<Double>(x: 2, y: 2)
        ]

        applyTestNoHistory(ignoringVarianceInY: ignoringVar,
                           observations: observations,
                           adding: [0, 1],
                           removing: [])
    }

    // MARK: -

    func test_ignoringVariance_infiniteSlope()
    {
        let ignoringVar = true

        let observations: [Observation<Double>] = [
            try! Observation<Double>(x: 1, y: 0),
            try! Observation<Double>(x: 1, y: 2)
        ]

        applyTestNoHistory(ignoringVarianceInY: ignoringVar,
                           observations: observations,
                           adding: [0, 1],
                           removing: [])
    }

    // MARK: -

    func testWithRealData()
    {
        /*
         Example adapted from
         https://en.m.wikipedia.org/wiki/Simple_linear_regression#Numerical_example
         */

        let ignoringVar = true

        let observations: [Observation<Double>] = [
            try! Observation<Double>(x: 1.47, y: 52.21),
            try! Observation<Double>(x: 1.50, y: 53.12),
            try! Observation<Double>(x: 1.52, y: 54.48),
            try! Observation<Double>(x: 1.55, y: 55.84),
            try! Observation<Double>(x: 1.57, y: 57.20),
            try! Observation<Double>(x: 1.60, y: 58.57),
            try! Observation<Double>(x: 1.63, y: 59.93),
            try! Observation<Double>(x: 1.65, y: 61.29),
            try! Observation<Double>(x: 1.68, y: 63.11),
            try! Observation<Double>(x: 1.70, y: 64.47),
            try! Observation<Double>(x: 1.73, y: 66.28),
            try! Observation<Double>(x: 1.75, y: 68.10),
            try! Observation<Double>(x: 1.78, y: 69.92),
            try! Observation<Double>(x: 1.80, y: 72.19),
            try! Observation<Double>(x: 1.83, y: 74.46)
        ]

        applyTestNoHistory(ignoringVarianceInY: ignoringVar,
                           observations: observations,
                           adding: Array<Int>(0 ..< observations.count),
                           removing: [])
    }

    // MARK: -

    func testHistory()
    {
        let keepingHist = true
        let ignoringVar = true

        let observations: [Observation<Double>] = [
            try! Observation<Double>(x: 1, y: 0),
            try! Observation<Double>(x: 0, y: 2)
        ]
        
        let reg = try! LinearRegression<Double>(ignoringVarianceInY: ignoringVar,
                                                keepingHistory: keepingHist)

        reg.add(observations[0])
        let data1 = reg.currentData

        reg.add(observations[1])
        let data2 = reg.currentData

        let expectedHistory = [data1, data2]

        XCTAssertEqual(reg.history, expectedHistory)
    }
}

