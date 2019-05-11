//
//  LongBreakIntervalTests.swift
//  PomodoroFoundationTests
//
//  Created by 류성두 on 29/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

@testable import PomodoroFoundation
import XCTest

class LongBreakIntervalTests: XCTestCase {
    func testInit() {
        // Given Nothing

        // When
        let sut = LongBreakInterval()

        // Then
        XCTAssert(sut.targetSeconds == 900)
        XCTAssert(sut.targetMinute == 15)
    }
}
