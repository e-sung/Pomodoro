//
//  PomodoroFoundationTests.swift
//  PomodoroFoundationTests
//
//  Created by 류성두 on 23/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import XCTest
@testable import PomodoroFoundation

class NSObjectExtensionTests: XCTestCase {
    
    
    func testInit() {
        let focusInterval = FocusInterval()
        XCTAssert(focusInterval.className == "FocusInterval")
        XCTAssert(FocusInterval.className == "FocusInterval")
    }
    
}
