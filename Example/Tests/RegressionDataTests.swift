//
//  RegressionDataTests.swift
//  WTOnlineLinearRegression
//
//  Created by Wagner Truppel on 2016.12.07.
//
//  Copyright (c) 2016 Wagner Truppel. All rights reserved.
//

import UIKit
import XCTest

@testable import WTOnlineLinearRegression

class RegressionDataTests: XCTestCase
{
    let index = 1

    let observations = [
        try! Observation<Double>(x: 2, y: 3, yVariance: 4),
        try! Observation<Double>(x: 5, y: 6, yVariance: 7),
        try! Observation<Double>(x: 8, y: 9, yVariance: 10)
    ]

    let sumOneOverVarianceY: Double = 11
    let sumXoverVarianceY: Double = 12
    let sumYoverVarianceY: Double = 13
    let sumXYoverVarianceY: Double = 14
    let sumXsquaredOverVarianceY: Double = 15
    let sumYsquaredOverVarianceY: Double = 16

    let meanTotalSquaredError: Double = 17
    let meanSquaredResidualError: Double = 18
    let meanSquaredRegressionError: Double = 19
    let rSquared: Double = 20

    let slopeEq = RegressionEquation<Double>
        .finiteSlope(slope:      try! UncertainValue<Double>(value: 21, variance: 22),
                     interceptY: try! UncertainValue<Double>(value: 23, variance: 24))

    let verticalEq = RegressionEquation<Double>.infiniteSlope(interceptX: 25)

    // MARK: -

    func testNoParamInit()
    {
        let sut = RegressionData<Double>()

        XCTAssertEqual(sut.index, 0)
        XCTAssertEqual(sut.observations, [Observation<Double>]())
        XCTAssertEqual(sut.sumOneOverVarianceY, 0)
        XCTAssertEqual(sut.sumXoverVarianceY, 0)
        XCTAssertEqual(sut.sumYoverVarianceY, 0)
        XCTAssertEqual(sut.sumXYoverVarianceY, 0)
        XCTAssertEqual(sut.sumXsquaredOverVarianceY, 0)
        XCTAssertEqual(sut.sumYsquaredOverVarianceY, 0)
        XCTAssertEqual(sut.meanTotalSquaredError, 0)
        XCTAssertEqual(sut.meanSquaredResidualError, nil)
        XCTAssertEqual(sut.meanSquaredRegressionError, nil)
        XCTAssertEqual(sut.rSquared, nil)
        XCTAssertEqual(sut.equation, nil)
    }

    func testParamsInit()
    {
        let sut = try! RegressionData<Double>(
            index: index,
            observations: observations,
            sumOneOverVarianceY: sumOneOverVarianceY,
            sumXoverVarianceY: sumXoverVarianceY,
            sumYoverVarianceY: sumYoverVarianceY,
            sumXYoverVarianceY: sumXYoverVarianceY,
            sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
            sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
            meanTotalSquaredError: meanTotalSquaredError,
            meanSquaredResidualError: meanSquaredResidualError,
            meanSquaredRegressionError: meanSquaredRegressionError,
            rSquared: rSquared,
            equation: slopeEq
        )

        XCTAssertEqual(sut.index, index)
        XCTAssertEqual(sut.numberOfObservations, observations.count)
        XCTAssertEqual(sut.observations, observations)
        XCTAssertEqual(sut.sumOneOverVarianceY, sumOneOverVarianceY)
        XCTAssertEqual(sut.sumXoverVarianceY, sumXoverVarianceY)
        XCTAssertEqual(sut.sumYoverVarianceY, sumYoverVarianceY)
        XCTAssertEqual(sut.sumXYoverVarianceY, sumXYoverVarianceY)
        XCTAssertEqual(sut.sumXsquaredOverVarianceY, sumXsquaredOverVarianceY)
        XCTAssertEqual(sut.sumYsquaredOverVarianceY, sumYsquaredOverVarianceY)
        XCTAssertEqual(sut.meanTotalSquaredError, meanTotalSquaredError)
        XCTAssertEqual(sut.meanSquaredResidualError, meanSquaredResidualError)
        XCTAssertEqual(sut.meanSquaredRegressionError, meanSquaredRegressionError)
        XCTAssertEqual(sut.rSquared, rSquared)
        XCTAssertEqual(sut.equation, slopeEq)
    }

    // MARK: -

    func testParamsInitThrowsOnNegativeSumOneOverVarianceY()
    {
        let sumOneOverVarianceY: Double = -1

        do
        {
            let _ = try RegressionData<Double>(
                index: index,
                observations: observations,
                sumOneOverVarianceY: sumOneOverVarianceY,
                sumXoverVarianceY: sumXoverVarianceY,
                sumYoverVarianceY: sumYoverVarianceY,
                sumXYoverVarianceY: sumXYoverVarianceY,
                sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
                sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
                meanTotalSquaredError: meanTotalSquaredError,
                meanSquaredResidualError: meanSquaredResidualError,
                meanSquaredRegressionError: meanSquaredRegressionError,
                rSquared: rSquared,
                equation: slopeEq
            )

            XCTFail()
        }
        catch
        {
            let expected = InvalidArgumentError.negativeValue(sumOneOverVarianceY)

            XCTAssertTrue(error is InvalidArgumentError<Double>)
            XCTAssertEqual(error as! InvalidArgumentError<Double>, expected)
        }
    }

    func testParamsInitThrowsOnNegativeSumXsquaredOverVarianceY()
    {
        let sumXsquaredOverVarianceY: Double = -1

        do
        {
            let _ = try RegressionData<Double>(
                index: index,
                observations: observations,
                sumOneOverVarianceY: sumOneOverVarianceY,
                sumXoverVarianceY: sumXoverVarianceY,
                sumYoverVarianceY: sumYoverVarianceY,
                sumXYoverVarianceY: sumXYoverVarianceY,
                sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
                sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
                meanTotalSquaredError: meanTotalSquaredError,
                meanSquaredResidualError: meanSquaredResidualError,
                meanSquaredRegressionError: meanSquaredRegressionError,
                rSquared: rSquared,
                equation: slopeEq
            )

            XCTFail()
        }
        catch
        {
            let expected = InvalidArgumentError.negativeValue(sumXsquaredOverVarianceY)

            XCTAssertTrue(error is InvalidArgumentError<Double>)
            XCTAssertEqual(error as! InvalidArgumentError<Double>, expected)
        }
    }

    func testParamsInitThrowsOnNegativeSumYsquaredOverVarianceY()
    {
        let sumYsquaredOverVarianceY: Double = -1

        do
        {
            let _ = try RegressionData<Double>(
                index: index,
                observations: observations,
                sumOneOverVarianceY: sumOneOverVarianceY,
                sumXoverVarianceY: sumXoverVarianceY,
                sumYoverVarianceY: sumYoverVarianceY,
                sumXYoverVarianceY: sumXYoverVarianceY,
                sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
                sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
                meanTotalSquaredError: meanTotalSquaredError,
                meanSquaredResidualError: meanSquaredResidualError,
                meanSquaredRegressionError: meanSquaredRegressionError,
                rSquared: rSquared,
                equation: slopeEq
            )

            XCTFail()
        }
        catch
        {
            let expected = InvalidArgumentError.negativeValue(sumYsquaredOverVarianceY)

            XCTAssertTrue(error is InvalidArgumentError<Double>)
            XCTAssertEqual(error as! InvalidArgumentError<Double>, expected)
        }
    }

    func testParamsInitThrowsOnNegativeTotalSSE()
    {
        let meanTotalSquaredError: Double = -1

        do
        {
            let _ = try RegressionData<Double>(
                index: index,
                observations: observations,
                sumOneOverVarianceY: sumOneOverVarianceY,
                sumXoverVarianceY: sumXoverVarianceY,
                sumYoverVarianceY: sumYoverVarianceY,
                sumXYoverVarianceY: sumXYoverVarianceY,
                sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
                sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
                meanTotalSquaredError: meanTotalSquaredError,
                meanSquaredResidualError: meanSquaredResidualError,
                meanSquaredRegressionError: meanSquaredRegressionError,
                rSquared: rSquared,
                equation: slopeEq
            )

            XCTFail()
        }
        catch
        {
            let expected = InvalidArgumentError.negativeValue(meanTotalSquaredError)

            XCTAssertTrue(error is InvalidArgumentError<Double>)
            XCTAssertEqual(error as! InvalidArgumentError<Double>, expected)
        }
    }

    func testParamsInitThrowsOnNegativeResidualSSE()
    {
        let meanSquaredResidualError: Double = -1

        do
        {
            let _ = try RegressionData<Double>(
                index: index,
                observations: observations,
                sumOneOverVarianceY: sumOneOverVarianceY,
                sumXoverVarianceY: sumXoverVarianceY,
                sumYoverVarianceY: sumYoverVarianceY,
                sumXYoverVarianceY: sumXYoverVarianceY,
                sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
                sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
                meanTotalSquaredError: meanTotalSquaredError,
                meanSquaredResidualError: meanSquaredResidualError,
                meanSquaredRegressionError: meanSquaredRegressionError,
                rSquared: rSquared,
                equation: slopeEq
            )

            XCTFail()
        }
        catch
        {
            let expected = InvalidArgumentError.negativeValue(meanSquaredResidualError)

            XCTAssertTrue(error is InvalidArgumentError<Double>)
            XCTAssertEqual(error as! InvalidArgumentError<Double>, expected)
        }
    }

    func testParamsInitThrowsOnNegativeRegressionSSE()
    {
        let meanSquaredRegressionError: Double = -1

        do
        {
            let _ = try RegressionData<Double>(
                index: index,
                observations: observations,
                sumOneOverVarianceY: sumOneOverVarianceY,
                sumXoverVarianceY: sumXoverVarianceY,
                sumYoverVarianceY: sumYoverVarianceY,
                sumXYoverVarianceY: sumXYoverVarianceY,
                sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
                sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
                meanTotalSquaredError: meanTotalSquaredError,
                meanSquaredResidualError: meanSquaredResidualError,
                meanSquaredRegressionError: meanSquaredRegressionError,
                rSquared: rSquared,
                equation: slopeEq
            )

            XCTFail()
        }
        catch
        {
            let expected = InvalidArgumentError.negativeValue(meanSquaredRegressionError)

            XCTAssertTrue(error is InvalidArgumentError<Double>)
            XCTAssertEqual(error as! InvalidArgumentError<Double>, expected)
        }
    }

    func testParamsInitThrowsOnNegativeRsquared()
    {
        let rSquared: Double = -1

        do
        {
            let _ = try RegressionData<Double>(
                index: index,
                observations: observations,
                sumOneOverVarianceY: sumOneOverVarianceY,
                sumXoverVarianceY: sumXoverVarianceY,
                sumYoverVarianceY: sumYoverVarianceY,
                sumXYoverVarianceY: sumXYoverVarianceY,
                sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
                sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
                meanTotalSquaredError: meanTotalSquaredError,
                meanSquaredResidualError: meanSquaredResidualError,
                meanSquaredRegressionError: meanSquaredRegressionError,
                rSquared: rSquared,
                equation: slopeEq
            )

            XCTFail()
        }
        catch
        {
            let expected = InvalidArgumentError.negativeValue(rSquared)

            XCTAssertTrue(error is InvalidArgumentError<Double>)
            XCTAssertEqual(error as! InvalidArgumentError<Double>, expected)
        }
    }

    // MARK: -

    func testEquality()
    {
        let sut1 = try! RegressionData<Double>(
            index: index,
            observations: observations,
            sumOneOverVarianceY: sumOneOverVarianceY,
            sumXoverVarianceY: sumXoverVarianceY,
            sumYoverVarianceY: sumYoverVarianceY,
            sumXYoverVarianceY: sumXYoverVarianceY,
            sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
            sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
            meanTotalSquaredError: meanTotalSquaredError,
            meanSquaredResidualError: meanSquaredResidualError,
            meanSquaredRegressionError: meanSquaredRegressionError,
            rSquared: rSquared,
            equation: slopeEq
        )

        let sut2 = sut1
        XCTAssertTrue(sut2 == sut1)
    }

    func testInequalityIndex()
    {
        let sut1 = try! RegressionData<Double>(
            index: 1,
            observations: observations,
            sumOneOverVarianceY: sumOneOverVarianceY,
            sumXoverVarianceY: sumXoverVarianceY,
            sumYoverVarianceY: sumYoverVarianceY,
            sumXYoverVarianceY: sumXYoverVarianceY,
            sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
            sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
            meanTotalSquaredError: meanTotalSquaredError,
            meanSquaredResidualError: meanSquaredResidualError,
            meanSquaredRegressionError: meanSquaredRegressionError,
            rSquared: rSquared,
            equation: slopeEq
        )

        let sut2 = try! RegressionData<Double>(
            index: 2,
            observations: observations,
            sumOneOverVarianceY: sumOneOverVarianceY,
            sumXoverVarianceY: sumXoverVarianceY,
            sumYoverVarianceY: sumYoverVarianceY,
            sumXYoverVarianceY: sumXYoverVarianceY,
            sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
            sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
            meanTotalSquaredError: meanTotalSquaredError,
            meanSquaredResidualError: meanSquaredResidualError,
            meanSquaredRegressionError: meanSquaredRegressionError,
            rSquared: rSquared,
            equation: slopeEq
        )

        XCTAssertTrue(sut2 != sut1)
    }

    func testInequalityObservations()
    {
        let observations1 = [
            try! Observation<Double>(x: 2, y: 3, yVariance: 4),
            try! Observation<Double>(x: 8, y: 9, yVariance: 10)
        ]

        let sut1 = try! RegressionData<Double>(
            index: index,
            observations: observations1,
            sumOneOverVarianceY: sumOneOverVarianceY,
            sumXoverVarianceY: sumXoverVarianceY,
            sumYoverVarianceY: sumYoverVarianceY,
            sumXYoverVarianceY: sumXYoverVarianceY,
            sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
            sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
            meanTotalSquaredError: meanTotalSquaredError,
            meanSquaredResidualError: meanSquaredResidualError,
            meanSquaredRegressionError: meanSquaredRegressionError,
            rSquared: rSquared,
            equation: slopeEq
        )

        let observations2 = [
            try! Observation<Double>(x: 8, y: 9, yVariance: 10)
        ]

        let sut2 = try! RegressionData<Double>(
            index: index,
            observations: observations2,
            sumOneOverVarianceY: sumOneOverVarianceY,
            sumXoverVarianceY: sumXoverVarianceY,
            sumYoverVarianceY: sumYoverVarianceY,
            sumXYoverVarianceY: sumXYoverVarianceY,
            sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
            sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
            meanTotalSquaredError: meanTotalSquaredError,
            meanSquaredResidualError: meanSquaredResidualError,
            meanSquaredRegressionError: meanSquaredRegressionError,
            rSquared: rSquared,
            equation: slopeEq
        )

        XCTAssertTrue(sut2 != sut1)
    }

    func testInequalitySumOneOverVarianceY()
    {
        let sut1 = try! RegressionData<Double>(
            index: index,
            observations: observations,
            sumOneOverVarianceY: 1,
            sumXoverVarianceY: sumXoverVarianceY,
            sumYoverVarianceY: sumYoverVarianceY,
            sumXYoverVarianceY: sumXYoverVarianceY,
            sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
            sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
            meanTotalSquaredError: meanTotalSquaredError,
            meanSquaredResidualError: meanSquaredResidualError,
            meanSquaredRegressionError: meanSquaredRegressionError,
            rSquared: rSquared,
            equation: slopeEq
        )

        let sut2 = try! RegressionData<Double>(
            index: index,
            observations: observations,
            sumOneOverVarianceY: 2,
            sumXoverVarianceY: sumXoverVarianceY,
            sumYoverVarianceY: sumYoverVarianceY,
            sumXYoverVarianceY: sumXYoverVarianceY,
            sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
            sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
            meanTotalSquaredError: meanTotalSquaredError,
            meanSquaredResidualError: meanSquaredResidualError,
            meanSquaredRegressionError: meanSquaredRegressionError,
            rSquared: rSquared,
            equation: slopeEq
        )

        XCTAssertTrue(sut2 != sut1)
    }

    func testInequalitySumXoverVarianceY()
    {
        let sut1 = try! RegressionData<Double>(
            index: index,
            observations: observations,
            sumOneOverVarianceY: sumOneOverVarianceY,
            sumXoverVarianceY: 1,
            sumYoverVarianceY: sumYoverVarianceY,
            sumXYoverVarianceY: sumXYoverVarianceY,
            sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
            sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
            meanTotalSquaredError: meanTotalSquaredError,
            meanSquaredResidualError: meanSquaredResidualError,
            meanSquaredRegressionError: meanSquaredRegressionError,
            rSquared: rSquared,
            equation: slopeEq
        )

        let sut2 = try! RegressionData<Double>(
            index: index,
            observations: observations,
            sumOneOverVarianceY: sumOneOverVarianceY,
            sumXoverVarianceY: 2,
            sumYoverVarianceY: sumYoverVarianceY,
            sumXYoverVarianceY: sumXYoverVarianceY,
            sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
            sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
            meanTotalSquaredError: meanTotalSquaredError,
            meanSquaredResidualError: meanSquaredResidualError,
            meanSquaredRegressionError: meanSquaredRegressionError,
            rSquared: rSquared,
            equation: slopeEq
        )

        XCTAssertTrue(sut2 != sut1)
    }

    func testInequalitySumYoverVarianceY()
    {
        let sut1 = try! RegressionData<Double>(
            index: index,
            observations: observations,
            sumOneOverVarianceY: sumOneOverVarianceY,
            sumXoverVarianceY: sumXoverVarianceY,
            sumYoverVarianceY: 1,
            sumXYoverVarianceY: sumXYoverVarianceY,
            sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
            sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
            meanTotalSquaredError: meanTotalSquaredError,
            meanSquaredResidualError: meanSquaredResidualError,
            meanSquaredRegressionError: meanSquaredRegressionError,
            rSquared: rSquared,
            equation: slopeEq
        )

        let sut2 = try! RegressionData<Double>(
            index: index,
            observations: observations,
            sumOneOverVarianceY: sumOneOverVarianceY,
            sumXoverVarianceY: sumXoverVarianceY,
            sumYoverVarianceY: 2,
            sumXYoverVarianceY: sumXYoverVarianceY,
            sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
            sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
            meanTotalSquaredError: meanTotalSquaredError,
            meanSquaredResidualError: meanSquaredResidualError,
            meanSquaredRegressionError: meanSquaredRegressionError,
            rSquared: rSquared,
            equation: slopeEq
        )

        XCTAssertTrue(sut2 != sut1)
    }

    func testInequalitySumXYoverVarianceY()
    {
        let sut1 = try! RegressionData<Double>(
            index: index,
            observations: observations,
            sumOneOverVarianceY: sumOneOverVarianceY,
            sumXoverVarianceY: sumXoverVarianceY,
            sumYoverVarianceY: sumYoverVarianceY,
            sumXYoverVarianceY: 1,
            sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
            sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
            meanTotalSquaredError: meanTotalSquaredError,
            meanSquaredResidualError: meanSquaredResidualError,
            meanSquaredRegressionError: meanSquaredRegressionError,
            rSquared: rSquared,
            equation: slopeEq
        )

        let sut2 = try! RegressionData<Double>(
            index: index,
            observations: observations,
            sumOneOverVarianceY: sumOneOverVarianceY,
            sumXoverVarianceY: sumXoverVarianceY,
            sumYoverVarianceY: sumYoverVarianceY,
            sumXYoverVarianceY: 2,
            sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
            sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
            meanTotalSquaredError: meanTotalSquaredError,
            meanSquaredResidualError: meanSquaredResidualError,
            meanSquaredRegressionError: meanSquaredRegressionError,
            rSquared: rSquared,
            equation: slopeEq
        )

        XCTAssertTrue(sut2 != sut1)
    }

    func testInequalitySumXsquaredOverVarianceY()
    {
        let sut1 = try! RegressionData<Double>(
            index: index,
            observations: observations,
            sumOneOverVarianceY: sumOneOverVarianceY,
            sumXoverVarianceY: sumXoverVarianceY,
            sumYoverVarianceY: sumYoverVarianceY,
            sumXYoverVarianceY: sumXYoverVarianceY,
            sumXsquaredOverVarianceY: 1,
            sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
            meanTotalSquaredError: meanTotalSquaredError,
            meanSquaredResidualError: meanSquaredResidualError,
            meanSquaredRegressionError: meanSquaredRegressionError,
            rSquared: rSquared,
            equation: slopeEq
        )

        let sut2 = try! RegressionData<Double>(
            index: index,
            observations: observations,
            sumOneOverVarianceY: sumOneOverVarianceY,
            sumXoverVarianceY: sumXoverVarianceY,
            sumYoverVarianceY: sumYoverVarianceY,
            sumXYoverVarianceY: sumXYoverVarianceY,
            sumXsquaredOverVarianceY: 2,
            sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
            meanTotalSquaredError: meanTotalSquaredError,
            meanSquaredResidualError: meanSquaredResidualError,
            meanSquaredRegressionError: meanSquaredRegressionError,
            rSquared: rSquared,
            equation: slopeEq
        )

        XCTAssertTrue(sut2 != sut1)
    }

    func testInequalitySumYsquaredOverVarianceY()
    {
        let sut1 = try! RegressionData<Double>(
            index: index,
            observations: observations,
            sumOneOverVarianceY: sumOneOverVarianceY,
            sumXoverVarianceY: sumXoverVarianceY,
            sumYoverVarianceY: sumYoverVarianceY,
            sumXYoverVarianceY: sumXYoverVarianceY,
            sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
            sumYsquaredOverVarianceY: 1,
            meanTotalSquaredError: meanTotalSquaredError,
            meanSquaredResidualError: meanSquaredResidualError,
            meanSquaredRegressionError: meanSquaredRegressionError,
            rSquared: rSquared,
            equation: slopeEq
        )

        let sut2 = try! RegressionData<Double>(
            index: index,
            observations: observations,
            sumOneOverVarianceY: sumOneOverVarianceY,
            sumXoverVarianceY: sumXoverVarianceY,
            sumYoverVarianceY: sumYoverVarianceY,
            sumXYoverVarianceY: sumXYoverVarianceY,
            sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
            sumYsquaredOverVarianceY: 2,
            meanTotalSquaredError: meanTotalSquaredError,
            meanSquaredResidualError: meanSquaredResidualError,
            meanSquaredRegressionError: meanSquaredRegressionError,
            rSquared: rSquared,
            equation: slopeEq
        )

        XCTAssertTrue(sut2 != sut1)
    }

    func testInequalityTotalSSE()
    {
        let sut1 = try! RegressionData<Double>(
            index: index,
            observations: observations,
            sumOneOverVarianceY: sumOneOverVarianceY,
            sumXoverVarianceY: sumXoverVarianceY,
            sumYoverVarianceY: sumYoverVarianceY,
            sumXYoverVarianceY: sumXYoverVarianceY,
            sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
            sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
            meanTotalSquaredError: 1,
            meanSquaredResidualError: meanSquaredResidualError,
            meanSquaredRegressionError: meanSquaredRegressionError,
            rSquared: rSquared,
            equation: slopeEq
        )

        let sut2 = try! RegressionData<Double>(
            index: index,
            observations: observations,
            sumOneOverVarianceY: sumOneOverVarianceY,
            sumXoverVarianceY: sumXoverVarianceY,
            sumYoverVarianceY: sumYoverVarianceY,
            sumXYoverVarianceY: sumXYoverVarianceY,
            sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
            sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
            meanTotalSquaredError: 2,
            meanSquaredResidualError: meanSquaredResidualError,
            meanSquaredRegressionError: meanSquaredRegressionError,
            rSquared: rSquared,
            equation: slopeEq
        )

        XCTAssertTrue(sut2 != sut1)
    }

    func testInequalityResidualSSE()
    {
        let sut1 = try! RegressionData<Double>(
            index: index,
            observations: observations,
            sumOneOverVarianceY: sumOneOverVarianceY,
            sumXoverVarianceY: sumXoverVarianceY,
            sumYoverVarianceY: sumYoverVarianceY,
            sumXYoverVarianceY: sumXYoverVarianceY,
            sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
            sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
            meanTotalSquaredError: meanTotalSquaredError,
            meanSquaredResidualError: 1,
            meanSquaredRegressionError: meanSquaredRegressionError,
            rSquared: rSquared,
            equation: slopeEq
        )

        let sut2 = try! RegressionData<Double>(
            index: index,
            observations: observations,
            sumOneOverVarianceY: sumOneOverVarianceY,
            sumXoverVarianceY: sumXoverVarianceY,
            sumYoverVarianceY: sumYoverVarianceY,
            sumXYoverVarianceY: sumXYoverVarianceY,
            sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
            sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
            meanTotalSquaredError: meanTotalSquaredError,
            meanSquaredResidualError: 2,
            meanSquaredRegressionError: meanSquaredRegressionError,
            rSquared: rSquared,
            equation: slopeEq
        )

        XCTAssertTrue(sut2 != sut1)
    }

    func testInequalityRegressionSSE()
    {
        let sut1 = try! RegressionData<Double>(
            index: index,
            observations: observations,
            sumOneOverVarianceY: sumOneOverVarianceY,
            sumXoverVarianceY: sumXoverVarianceY,
            sumYoverVarianceY: sumYoverVarianceY,
            sumXYoverVarianceY: sumXYoverVarianceY,
            sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
            sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
            meanTotalSquaredError: meanTotalSquaredError,
            meanSquaredResidualError: meanSquaredResidualError,
            meanSquaredRegressionError: 1,
            rSquared: rSquared,
            equation: slopeEq
        )

        let sut2 = try! RegressionData<Double>(
            index: index,
            observations: observations,
            sumOneOverVarianceY: sumOneOverVarianceY,
            sumXoverVarianceY: sumXoverVarianceY,
            sumYoverVarianceY: sumYoverVarianceY,
            sumXYoverVarianceY: sumXYoverVarianceY,
            sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
            sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
            meanTotalSquaredError: meanTotalSquaredError,
            meanSquaredResidualError: meanSquaredResidualError,
            meanSquaredRegressionError: 2,
            rSquared: rSquared,
            equation: slopeEq
        )

        XCTAssertTrue(sut2 != sut1)
    }

    func testInequalityRsquared()
    {
        let sut1 = try! RegressionData<Double>(
            index: index,
            observations: observations,
            sumOneOverVarianceY: sumOneOverVarianceY,
            sumXoverVarianceY: sumXoverVarianceY,
            sumYoverVarianceY: sumYoverVarianceY,
            sumXYoverVarianceY: sumXYoverVarianceY,
            sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
            sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
            meanTotalSquaredError: meanTotalSquaredError,
            meanSquaredResidualError: meanSquaredResidualError,
            meanSquaredRegressionError: meanSquaredRegressionError,
            rSquared: 1,
            equation: slopeEq
        )

        let sut2 = try! RegressionData<Double>(
            index: index,
            observations: observations,
            sumOneOverVarianceY: sumOneOverVarianceY,
            sumXoverVarianceY: sumXoverVarianceY,
            sumYoverVarianceY: sumYoverVarianceY,
            sumXYoverVarianceY: sumXYoverVarianceY,
            sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
            sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
            meanTotalSquaredError: meanTotalSquaredError,
            meanSquaredResidualError: meanSquaredResidualError,
            meanSquaredRegressionError: meanSquaredRegressionError,
            rSquared: 2,
            equation: slopeEq
        )

        XCTAssertTrue(sut2 != sut1)
    }

    func testInequalityRegressionEquation()
    {
        let sut1 = try! RegressionData<Double>(
            index: index,
            observations: observations,
            sumOneOverVarianceY: sumOneOverVarianceY,
            sumXoverVarianceY: sumXoverVarianceY,
            sumYoverVarianceY: sumYoverVarianceY,
            sumXYoverVarianceY: sumXYoverVarianceY,
            sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
            sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
            meanTotalSquaredError: meanTotalSquaredError,
            meanSquaredResidualError: meanSquaredResidualError,
            meanSquaredRegressionError: meanSquaredRegressionError,
            rSquared: rSquared,
            equation: slopeEq
        )

        let sut2 = try! RegressionData<Double>(
            index: index,
            observations: observations,
            sumOneOverVarianceY: sumOneOverVarianceY,
            sumXoverVarianceY: sumXoverVarianceY,
            sumYoverVarianceY: sumYoverVarianceY,
            sumXYoverVarianceY: sumXYoverVarianceY,
            sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
            sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
            meanTotalSquaredError: meanTotalSquaredError,
            meanSquaredResidualError: meanSquaredResidualError,
            meanSquaredRegressionError: meanSquaredRegressionError,
            rSquared: rSquared,
            equation: verticalEq
        )

        XCTAssertTrue(sut2 != sut1)
    }

    // MARK: -

    func testConformanceToComparable1()
    {
        let sut1 = try! RegressionData<Double>(
            index: index,
            observations: observations,
            sumOneOverVarianceY: sumOneOverVarianceY,
            sumXoverVarianceY: sumXoverVarianceY,
            sumYoverVarianceY: sumYoverVarianceY,
            sumXYoverVarianceY: sumXYoverVarianceY,
            sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
            sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
            meanTotalSquaredError: meanTotalSquaredError,
            meanSquaredResidualError: meanSquaredResidualError,
            meanSquaredRegressionError: meanSquaredRegressionError,
            rSquared: rSquared,
            equation: slopeEq
        )

        XCTAssertFalse(sut1 < sut1)
    }

    func testConformanceToComparable2()
    {
        let sut1 = try! RegressionData<Double>(
            index: 1,
            observations: observations,
            sumOneOverVarianceY: sumOneOverVarianceY,
            sumXoverVarianceY: sumXoverVarianceY,
            sumYoverVarianceY: sumYoverVarianceY,
            sumXYoverVarianceY: sumXYoverVarianceY,
            sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
            sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
            meanTotalSquaredError: meanTotalSquaredError,
            meanSquaredResidualError: meanSquaredResidualError,
            meanSquaredRegressionError: meanSquaredRegressionError,
            rSquared: rSquared,
            equation: slopeEq
        )

        let sut2 = try! RegressionData<Double>(
            index: 2,
            observations: observations,
            sumOneOverVarianceY: sumOneOverVarianceY,
            sumXoverVarianceY: sumXoverVarianceY,
            sumYoverVarianceY: sumYoverVarianceY,
            sumXYoverVarianceY: sumXYoverVarianceY,
            sumXsquaredOverVarianceY: sumXsquaredOverVarianceY,
            sumYsquaredOverVarianceY: sumYsquaredOverVarianceY,
            meanTotalSquaredError: meanTotalSquaredError,
            meanSquaredResidualError: meanSquaredResidualError,
            meanSquaredRegressionError: meanSquaredRegressionError,
            rSquared: rSquared,
            equation: slopeEq
        )
        
        XCTAssertTrue(sut1 < sut2)
    }
}

