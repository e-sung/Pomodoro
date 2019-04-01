//
//  SettingContentTests.swift
//  PomodoroFoundationTests
//
//  Created by 류성두 on 11/01/2019.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

@testable import PomodoroFoundation
import XCTest

class SettingContentTests: XCTestCase {
    let focusTime = SettingContent(rawValue: "focusIntervalSetting")
    let breakTime = SettingContent(rawValue: "breakIntervalSetting")
    let longBreakTime = SettingContent(rawValue: "longBreakIntervalSetting")
    let cycleForLongBreak = SettingContent(rawValue: "cycleForLongBreakSetting")
    let targetSetting = SettingContent(rawValue: "targetSetting")
    let neverSleepSetting = SettingContent(rawValue: "neverSleepSetting")
    let enhancedFocusModeSetting = SettingContent(rawValue: "enhancedFocusModeSetting")
    let devMode = SettingContent(rawValue: "devModeSetting")

    func testDefaultValues() {
        XCTAssert(focusTime?.defaultValue as? Int == 25)
        XCTAssert(breakTime?.defaultValue as? Int == 5)
        XCTAssert(longBreakTime?.defaultValue as? Int == 15)
        XCTAssert(cycleForLongBreak?.defaultValue as? Int == 3)
        XCTAssert(targetSetting?.defaultValue as? Int == 10)
        XCTAssert(neverSleepSetting?.defaultValue as? Bool == true)
        XCTAssert(enhancedFocusModeSetting?.defaultValue as? Bool == false)
        XCTAssert(devMode?.defaultValue as? Bool == false)
    }

    func testNumberOfCases() {
        XCTAssert(focusTime?.numberOfCases == 12)
        XCTAssert(breakTime?.numberOfCases == 12)
        XCTAssert(longBreakTime?.numberOfCases == 12)
        XCTAssert(cycleForLongBreak?.numberOfCases == 50)
        XCTAssert(targetSetting?.numberOfCases == 50)
        XCTAssert(neverSleepSetting?.numberOfCases == nil)
        XCTAssert(enhancedFocusModeSetting?.numberOfCases == nil)
        XCTAssert(devMode?.numberOfCases == nil)
    }

    func testFormattedString() {
        XCTAssert(focusTime?.formattedString(given: 18) == "18 min")
        XCTAssert(breakTime?.formattedString(given: 17) == "17 min")
        XCTAssert(longBreakTime?.formattedString(given: 16) == "16 min")

        XCTAssert(cycleForLongBreak?.formattedString(given: 100) == "After 100 Cycles")
        XCTAssert(targetSetting?.formattedString(given: 30) == "30 cycles per day")

        XCTAssert(neverSleepSetting?.formattedString(given: 30) == nil)
        XCTAssert(enhancedFocusModeSetting?.formattedString(given: 3) == nil)
        XCTAssert(devMode?.formattedString(given: 2) == nil)
    }

    func testAmountForRow() {
        let row = 3
        XCTAssert(focusTime?.amount(for: row) == 20)
        XCTAssert(breakTime?.amount(for: row) == 20)
        XCTAssert(longBreakTime?.amount(for: row) == 20)

        XCTAssert(targetSetting?.amount(for: row) == 4)
        XCTAssert(cycleForLongBreak?.amount(for: row) == 4)

        XCTAssert(neverSleepSetting?.amount(for: row) == nil)
        XCTAssert(enhancedFocusModeSetting?.amount(for: row) == nil)
        XCTAssert(devMode?.amount(for: row) == nil)
    }

    func testRowForAmount() {
        var amount = 20
        XCTAssert(focusTime?.rowFor(amount) == 3)
        XCTAssert(breakTime?.rowFor(amount) == 3)
        XCTAssert(longBreakTime?.rowFor(amount) == 3)

        amount = 4
        XCTAssert(targetSetting?.rowFor(amount) == 3)
        XCTAssert(cycleForLongBreak?.rowFor(amount) == 3)

        XCTAssert(neverSleepSetting?.rowFor(amount) == nil)
        XCTAssert(enhancedFocusModeSetting?.rowFor(amount) == nil)
        XCTAssert(devMode?.rowFor(amount) == nil)
    }
}
