//
//  LongBreakIntervalTests.swift
//  PomodoroFoundationTests
//
//  Created by 류성두 on 29/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import XCTest
@testable import PomodoroFoundation

class LongBreakIntervalTests: XCTestCase {

    func testInit() {
        // Given Nothing
        
        // When
        let sut = LongBreakInterval()
        
        
        // Then
        XCTAssert(sut.targetSeconds == 900)
        XCTAssert(sut.targetMinute == 15 )
        XCTAssert(sut.notiAction.title == "Start Focus")
        XCTAssert(sut.notiContent.title == "Time to Focus!")
        XCTAssert(sut.notiContent.body == "Cheer Up!!!")
    }

}
