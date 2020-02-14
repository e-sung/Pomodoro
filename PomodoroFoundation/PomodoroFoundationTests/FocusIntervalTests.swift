//
//  PomodoroFoundationTests.swift
//  PomodoroFoundationTests
//
//  Created by 류성두 on 23/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

@testable import PomodoroFoundation
import XCTest

class FocusIntervalTests: XCTestCase {
    func testInit() {
        // Given Nothing

        // When
        let sut = FocusInterval()

        // Then
        XCTAssertFalse(sut.timer.isValid)
        XCTAssert(sut.elapsedSeconds == 0)
        XCTAssert(sut.targetSeconds == 1500)
        XCTAssert(sut.targetMinute == 25, "initial target seconds for focusTime should be 25 minutes")
        if Locale.current.languageCode?.contains("en") == true {
            XCTAssert(sut.notiAction.title == "Start Break")
            XCTAssert(sut.notiContent.title == "Time to Break!!")
        }
        XCTAssert(sut.typeIdentifier == "FocusInterval")
    }

    func testTimerStartAndPause() {
        // Given Nothing

        // When
        let sut = FocusInterval()
        sut.startTimer()

        // Then
        XCTAssert(sut.isActive)

        // When
        sut.pauseTimer()

        // Then
        XCTAssert(sut.isActive == false)
    }

    func testTimerStop() {
        // Given
        let expect = expectation(description: "Time has elapsed")

        // When
        let sut = FocusInterval()
        sut.startTimer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // Then
            XCTAssert(sut.elapsedSeconds >= 3)

            // When
            sut.stopTimer()
            // Then
            XCTAssert(sut.elapsedSeconds == 0)
            expect.fulfill()
        }

        wait(for: [expect], timeout: 5)
    }
}
