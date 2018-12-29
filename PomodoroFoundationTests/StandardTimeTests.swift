//
//  StandardTimeTests.swift
//  PomodoroFoundationTests
//
//  Created by 류성두 on 29/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import XCTest
@testable import PomodoroFoundation

class StandardTimeTests: XCTestCase {

    func testStandardDates() {
        XCTAssert(Locale.posix == Locale(identifier: "en_US_POSIX"))
        XCTAssert(TimeZone.gmt == TimeZone(identifier: "GMT")!)
        XCTAssert(DateFormatter.standard.timeZone == TimeZone.gmt)
        XCTAssert(DateFormatter.standard.locale == Locale.posix)
        XCTAssert(DateFormatter.standard.calendar == Calendar(identifier: .iso8601))
    }


}
