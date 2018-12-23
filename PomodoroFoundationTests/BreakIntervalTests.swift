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
        XCTAssert(sut.themeColor == .green)
        XCTAssert(sut.notiCategoryId.contains("BreakInterval"))
        XCTAssert(sut.notiAction.title == "Start Focus")
        XCTAssert(sut.notiContent.title == "Time to Focus!")
        XCTAssert(sut.notiContent.body == "Cheer Up!!!")
    }
    
    func testTimerControl() {
        let sut = BreakInterval()
        
        sut.startTimer()
        XCTAssert(sut.timer.isValid)
        
        let expect = expectation(description: "timeElapsed")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
            
            XCTAssert(sut.elapsedSeconds > 0)
            
            sut.pauseTimer()
            XCTAssertFalse(sut.timer.isValid)
            XCTAssert(sut.elapsedSeconds > 0)
            
            sut.stopTimer()
            XCTAssert(sut.elapsedSeconds == 0)
            XCTAssertFalse(sut.timer.isValid)
            
            expect.fulfill()
        })
        
        wait(for: [expect], timeout: 3)
    }
    
}
