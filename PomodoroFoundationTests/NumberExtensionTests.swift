//
//  NumberExtensionTests.swift
//  PomodoroFoundationTests
//
//  Created by 류성두 on 08/01/2019.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

@testable import PomodoroFoundation
import XCTest

class NumberExtensionTests: XCTestCase {
    func testMinuteString() {
        // Given
        if Locale.current.languageCode?.hasPrefix("en") == true {
            let intFour: Int = 4
            let doubleFour: Double = 4
            // When, Then
            XCTAssert(doubleFour.minuteString == "4 min")
            XCTAssert(intFour.minuteString == "4 min")
        }
    }

    func testSecondString() {
        // Given
        if Locale.current.languageCode?.hasPrefix("en") == true {
            let intFour: Int = 4
            let doubleFour: Double = 4
            // When, Then
            XCTAssert(doubleFour.secondString == "4 sec")
            XCTAssert(intFour.secondString == "4 sec")
        }
    }
}
