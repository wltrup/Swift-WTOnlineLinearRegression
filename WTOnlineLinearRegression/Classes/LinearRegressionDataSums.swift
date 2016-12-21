/*
 LinearRegressionDataSums.swift
 WTOnlineLinearRegression

 Created by Wagner Truppel on 2016.12.07

 The MIT License (MIT)

 Copyright (c) 2016 Wagner Truppel.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.

 When crediting me (Wagner Truppel) for this work, please use one
 of the following two suggested formats:

 Uses "WTOnlineLinearRegression" by Wagner Truppel
 https://github.com/wltrup

 or

 WTOnlineLinearRegression by Wagner Truppel
 https://github.com/wltrup
 */

import Foundation


/// This struct encapsulates the sums of various quantities necessary for
/// computing a regression line over a collection of observations.
///
/// `BFPType` is any `BinaryFloatingPoint` type such as `Double` or `CGFloat`.
///
public struct LinearRegressionDataSums<BFPType: BinaryFloatingPoint>: Equatable
{
    /// The sum of the observations' (1 over y-variance) values over the
    /// collection of observations used to perform the linear regression
    /// associated with this instance.
    public let oneOverVarianceY: BFPType

    /// The sum of the observations' (x over y-variance) values over the
    /// collection of observations used to perform the linear regression
    /// associated with this instance.
    public let xOverVarianceY: BFPType

    /// The sum of the observations' (y over y-variance) values over the
    /// collection of observations used to perform the linear regression
    /// associated with this instance.
    public let yOverVarianceY: BFPType

    /// The sum of the observations' (x times y over y-variance) values
    /// over the collection of observations used to perform the linear
    ///regression associated with this instance.
    public let xyOverVarianceY: BFPType

    /// The sum of the observations' (x-squared over y-variance) values
    /// over the collection of observations used to perform the linear
    ///regression associated with this instance.
    public let xSquaredOverVarianceY: BFPType

    /// The sum of the observations' (y-squared over y-variance) values
    /// over the collection of observations used to perform the linear
    ///regression associated with this instance.
    public let ySquaredOverVarianceY: BFPType

    // MARK: - Initializers

    /// One of the designated initializers.
    /// Initialises an instance with all-zero values.
    ///
    /// This initializer is *internal*.
    ///
    init()
    {
        self.oneOverVarianceY = 0
        self.xOverVarianceY = 0
        self.yOverVarianceY = 0
        self.xyOverVarianceY = 0
        self.xSquaredOverVarianceY = 0
        self.ySquaredOverVarianceY = 0
    }

    /// One of the designated initializers.
    ///
    /// This initializer is *internal*.
    ///
    /// - Parameters:
    ///   - oneOverVarianceY: the sume of oneOverVarianceY values.
    ///   - xOverVarianceY: the sume of xOverVarianceY values.
    ///   - yOverVarianceY: the sume of yOverVarianceY values.
    ///   - xyOverVarianceY: the sume of xyOverVarianceY values.
    ///   - xSquaredOverVarianceY: the sume of xSquaredOverVarianceY values.
    ///   - ySquaredOverVarianceY: the sume of ySquaredOverVarianceY values.
    ///   - totalSquaredErrors: the sume of totalSquaredErrors values.
    ///   - residualSquaredErrors: the sume of residualSquaredErrors values.
    ///
    /// - Throws: InvalidArgumentError.negativeValue
    ///           if `oneOverVarianceY` is less than zero or
    ///           if `xSquaredOverVarianceY` is less than zero or
    ///           if `ySquaredOverVarianceY` is less than zero.
    ///
    init(oneOverVarianceY: BFPType,
         xOverVarianceY: BFPType,
         yOverVarianceY: BFPType,
         xyOverVarianceY: BFPType,
         xSquaredOverVarianceY: BFPType,
         ySquaredOverVarianceY: BFPType) throws
    {
        guard oneOverVarianceY >= 0 else {
            throw InvalidArgumentError.negativeValue(oneOverVarianceY)
        }

        guard xSquaredOverVarianceY >= 0 else {
            throw InvalidArgumentError.negativeValue(xSquaredOverVarianceY)
        }

        guard ySquaredOverVarianceY >= 0 else {
            throw InvalidArgumentError.negativeValue(ySquaredOverVarianceY)
        }

        self.oneOverVarianceY = oneOverVarianceY
        self.xOverVarianceY = xOverVarianceY
        self.yOverVarianceY = yOverVarianceY
        self.xyOverVarianceY = xyOverVarianceY
        self.xSquaredOverVarianceY = xSquaredOverVarianceY
        self.ySquaredOverVarianceY = ySquaredOverVarianceY
    }

    // MARK: - Equatable conformance

    /// Implements conformance to the `Equatable` protocol.
    ///
    /// - Parameters:
    ///   - lhs: the first operand.
    ///   - rhs: the second operand.
    ///
    /// - Returns: whether or not the two instances are considered equal.
    ///
    public static func ==(lhs: LinearRegressionDataSums,
                          rhs: LinearRegressionDataSums) -> Bool
    {
        return lhs.oneOverVarianceY == rhs.oneOverVarianceY &&
            lhs.xOverVarianceY == rhs.xOverVarianceY &&
            lhs.yOverVarianceY == rhs.yOverVarianceY &&
            lhs.xyOverVarianceY == rhs.xyOverVarianceY &&
            lhs.xSquaredOverVarianceY == rhs.xSquaredOverVarianceY &&
            lhs.ySquaredOverVarianceY == rhs.ySquaredOverVarianceY
    }
}

