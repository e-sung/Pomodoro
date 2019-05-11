//
//  PomodoroFoundationTests.swift
//  PomodoroFoundationTests
//
//  Created by 류성두 on 23/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

@testable import PomodoroFoundation
import XCTest

class BreakIntervalTests: XCTestCase {
    func testInit() {
        // Given Nothing

        // When
        let sut = BreakInterval()

        // Then
        XCTAssert(sut.targetSeconds == 300)
        XCTAssert(sut.targetMinute == 5)
        if Locale.current.languageCode?.contains("en") == true {
            XCTAssert(sut.notiContent.title == "Time to Focus!!")
            XCTAssert(sut.notiAction.title == "Start Focusing")
        }
        XCTAssert(sut.typeIdentifier == "BreakInterval")
    }
}
