//
//  DataSumsTests.swift
//  WTOnlineLinearRegression
//
//  Created by Wagner Truppel on 2016.12.07.
//
//  Copyright (c) 2016 Wagner Truppel. All rights reserved.
//

import UIKit
import XCTest

@testable import WTOnlineLinearRegression

class DataSumsTests: XCTestCase
{
    let oneOverVarianceY: Double = 1
    let xOverVarianceY: Double = 2
    let yOverVarianceY: Double = 3
    let xyOverVarianceY: Double = 4
    let xSquaredOverVarianceY: Double = 5
    let ySquaredOverVarianceY: Double = 6

    func testNoParamInit()
    {
        let sut = DataSums<Double>()

        XCTAssertEqual(sut.oneOverVarianceY, 0)
        XCTAssertEqual(sut.xOverVarianceY, 0)
        XCTAssertEqual(sut.yOverVarianceY, 0)
        XCTAssertEqual(sut.xyOverVarianceY, 0)
        XCTAssertEqual(sut.xSquaredOverVarianceY, 0)
        XCTAssertEqual(sut.ySquaredOverVarianceY, 0)
    }

    func testParamsInit()
    {
        let sut = try! DataSums<Double>(
            oneOverVarianceY: oneOverVarianceY,
            xOverVarianceY: xOverVarianceY,
            yOverVarianceY: yOverVarianceY,
            xyOverVarianceY: xyOverVarianceY,
            xSquaredOverVarianceY: xSquaredOverVarianceY,
            ySquaredOverVarianceY: ySquaredOverVarianceY
        )

        XCTAssertEqual(sut.oneOverVarianceY, oneOverVarianceY)
        XCTAssertEqual(sut.xOverVarianceY, xOverVarianceY)
        XCTAssertEqual(sut.yOverVarianceY, yOverVarianceY)
        XCTAssertEqual(sut.xyOverVarianceY, xyOverVarianceY)
        XCTAssertEqual(sut.xSquaredOverVarianceY, xSquaredOverVarianceY)
        XCTAssertEqual(sut.ySquaredOverVarianceY, ySquaredOverVarianceY)
    }

    // MARK: -

    func testParamsInitThrowsOnNegativeOneOverVarianceY()
    {
        let oneOverVarianceY: Double = -1

        do
        {
            let _ = try DataSums<Double>(
                oneOverVarianceY: oneOverVarianceY,
                xOverVarianceY: xOverVarianceY,
                yOverVarianceY: yOverVarianceY,
                xyOverVarianceY: xyOverVarianceY,
                xSquaredOverVarianceY: xSquaredOverVarianceY,
                ySquaredOverVarianceY: ySquaredOverVarianceY
            )

            XCTFail()
        }
        catch
        {
            let expected = InvalidArgumentError.negativeValue(oneOverVarianceY)

            XCTAssertTrue(error is InvalidArgumentError<Double>)
            XCTAssertEqual(error as! InvalidArgumentError<Double>, expected)
        }
    }

    func testParamsInitThrowsOnNegativeXsquaredOverVarianceY()
    {
        let xSquaredOverVarianceY: Double = -5

        do
        {
            let _ = try DataSums<Double>(
                oneOverVarianceY: oneOverVarianceY,
                xOverVarianceY: xOverVarianceY,
                yOverVarianceY: yOverVarianceY,
                xyOverVarianceY: xyOverVarianceY,
                xSquaredOverVarianceY: xSquaredOverVarianceY,
                ySquaredOverVarianceY: ySquaredOverVarianceY
            )

            XCTFail()
        }
        catch
        {
            let expected = InvalidArgumentError.negativeValue(xSquaredOverVarianceY)

            XCTAssertTrue(error is InvalidArgumentError<Double>)
            XCTAssertEqual(error as! InvalidArgumentError<Double>, expected)
        }
    }

    func testParamsInitThrowsOnNegativeYsquaredOverVarianceY()
    {
        let ySquaredOverVarianceY: Double = -6

        do
        {
            let _ = try DataSums<Double>(
                oneOverVarianceY: oneOverVarianceY,
                xOverVarianceY: xOverVarianceY,
                yOverVarianceY: yOverVarianceY,
                xyOverVarianceY: xyOverVarianceY,
                xSquaredOverVarianceY: xSquaredOverVarianceY,
                ySquaredOverVarianceY: ySquaredOverVarianceY
            )

            XCTFail()
        }
        catch
        {
            let expected = InvalidArgumentError.negativeValue(ySquaredOverVarianceY)

            XCTAssertTrue(error is InvalidArgumentError<Double>)
            XCTAssertEqual(error as! InvalidArgumentError<Double>, expected)
        }
    }

    // MARK: -

    func testEquality()
    {
        let sut1 = try! DataSums<Double>(
            oneOverVarianceY: oneOverVarianceY,
            xOverVarianceY: xOverVarianceY,
            yOverVarianceY: yOverVarianceY,
            xyOverVarianceY: xyOverVarianceY,
            xSquaredOverVarianceY: xSquaredOverVarianceY,
            ySquaredOverVarianceY: ySquaredOverVarianceY
        )

        let sut2 = sut1
        XCTAssertTrue(sut2 == sut1)
    }

    func testInequalityOneOverVarianceY()
    {
        let sut1 = try! DataSums<Double>(
            oneOverVarianceY: 10,
            xOverVarianceY: xOverVarianceY,
            yOverVarianceY: yOverVarianceY,
            xyOverVarianceY: xyOverVarianceY,
            xSquaredOverVarianceY: xSquaredOverVarianceY,
            ySquaredOverVarianceY: ySquaredOverVarianceY
        )


        let sut2 = try! DataSums<Double>(
            oneOverVarianceY: 20,
            xOverVarianceY: xOverVarianceY,
            yOverVarianceY: yOverVarianceY,
            xyOverVarianceY: xyOverVarianceY,
            xSquaredOverVarianceY: xSquaredOverVarianceY,
            ySquaredOverVarianceY: ySquaredOverVarianceY
        )

        XCTAssertTrue(sut2 != sut1)
    }

    func testInequalityXoverVarianceY()
    {
        let sut1 = try! DataSums<Double>(
            oneOverVarianceY: oneOverVarianceY,
            xOverVarianceY: 10,
            yOverVarianceY: yOverVarianceY,
            xyOverVarianceY: xyOverVarianceY,
            xSquaredOverVarianceY: xSquaredOverVarianceY,
            ySquaredOverVarianceY: ySquaredOverVarianceY
        )


        let sut2 = try! DataSums<Double>(
            oneOverVarianceY: oneOverVarianceY,
            xOverVarianceY: 20,
            yOverVarianceY: yOverVarianceY,
            xyOverVarianceY: xyOverVarianceY,
            xSquaredOverVarianceY: xSquaredOverVarianceY,
            ySquaredOverVarianceY: ySquaredOverVarianceY
        )

        XCTAssertTrue(sut2 != sut1)
    }

    func testInequalityYoverVarianceY()
    {
        let sut1 = try! DataSums<Double>(
            oneOverVarianceY: oneOverVarianceY,
            xOverVarianceY: xOverVarianceY,
            yOverVarianceY: 10,
            xyOverVarianceY: xyOverVarianceY,
            xSquaredOverVarianceY: xSquaredOverVarianceY,
            ySquaredOverVarianceY: ySquaredOverVarianceY
        )


        let sut2 = try! DataSums<Double>(
            oneOverVarianceY: oneOverVarianceY,
            xOverVarianceY: xOverVarianceY,
            yOverVarianceY: 20,
            xyOverVarianceY: xyOverVarianceY,
            xSquaredOverVarianceY: xSquaredOverVarianceY,
            ySquaredOverVarianceY: ySquaredOverVarianceY
        )

        XCTAssertTrue(sut2 != sut1)
    }

    func testInequalityXYoverVarianceY()
    {
        let sut1 = try! DataSums<Double>(
            oneOverVarianceY: oneOverVarianceY,
            xOverVarianceY: xOverVarianceY,
            yOverVarianceY: yOverVarianceY,
            xyOverVarianceY: 10,
            xSquaredOverVarianceY: xSquaredOverVarianceY,
            ySquaredOverVarianceY: ySquaredOverVarianceY
        )


        let sut2 = try! DataSums<Double>(
            oneOverVarianceY: oneOverVarianceY,
            xOverVarianceY: xOverVarianceY,
            yOverVarianceY: yOverVarianceY,
            xyOverVarianceY: 20,
            xSquaredOverVarianceY: xSquaredOverVarianceY,
            ySquaredOverVarianceY: ySquaredOverVarianceY
        )

        XCTAssertTrue(sut2 != sut1)
    }

    func testInequalityXsquaredOverVarianceY()
    {
        let sut1 = try! DataSums<Double>(
            oneOverVarianceY: oneOverVarianceY,
            xOverVarianceY: xOverVarianceY,
            yOverVarianceY: yOverVarianceY,
            xyOverVarianceY: xyOverVarianceY,
            xSquaredOverVarianceY: 10,
            ySquaredOverVarianceY: ySquaredOverVarianceY
        )


        let sut2 = try! DataSums<Double>(
            oneOverVarianceY: oneOverVarianceY,
            xOverVarianceY: xOverVarianceY,
            yOverVarianceY: yOverVarianceY,
            xyOverVarianceY: xyOverVarianceY,
            xSquaredOverVarianceY: 20,
            ySquaredOverVarianceY: ySquaredOverVarianceY
        )

        XCTAssertTrue(sut2 != sut1)
    }

    func testInequalityYsquaredOverVarianceY()
    {
        let sut1 = try! DataSums<Double>(
            oneOverVarianceY: oneOverVarianceY,
            xOverVarianceY: xOverVarianceY,
            yOverVarianceY: yOverVarianceY,
            xyOverVarianceY: xyOverVarianceY,
            xSquaredOverVarianceY: xSquaredOverVarianceY,
            ySquaredOverVarianceY: 10
        )


        let sut2 = try! DataSums<Double>(
            oneOverVarianceY: oneOverVarianceY,
            xOverVarianceY: xOverVarianceY,
            yOverVarianceY: yOverVarianceY,
            xyOverVarianceY: xyOverVarianceY,
            xSquaredOverVarianceY: xSquaredOverVarianceY,
            ySquaredOverVarianceY: 20
        )
        
        XCTAssertTrue(sut2 != sut1)
    }
}

