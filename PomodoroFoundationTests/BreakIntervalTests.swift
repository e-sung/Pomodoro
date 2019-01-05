//
//  PomodoroFoundationTests.swift
//  PomodoroFoundationTests
//
//  Created by 류성두 on 23/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import XCTest
@testable import PomodoroFoundation

class BreakIntervalTests: XCTestCase {
    
    
    func testInit() {
        // Given Nothing
        
        // When
        let sut = BreakInterval()
        
        
        // Then
        XCTAssert(sut.targetSeconds == 300)
        XCTAssert(sut.targetMinute == 5 )
        XCTAssert(sut.notiAction.title == "Start Focus")
        XCTAssert(sut.notiContent.title == "Time to Focus!")
        XCTAssert(sut.notiContent.body == "Cheer Up!!!")
        XCTAssert(sut.typeIdentifier == "BreakInterval")
    }
    
}
