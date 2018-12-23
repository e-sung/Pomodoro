//
//  PomodoroFoundationTests.swift
//  PomodoroFoundationTests
//
//  Created by 류성두 on 23/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import XCTest
@testable import PomodoroFoundation

class FocusIntervalTests: XCTestCase {


    func testInit() {
        // Given Nothing
        
        // When
        let sut = FocusInterval()
        
        
        // Then
        XCTAssertFalse(sut.timer.isValid)
        XCTAssert(sut.elapsedSeconds == 0)
        XCTAssert(sut.targetSeconds == 1500)
        XCTAssert(sut.targetMinute == 25 )
        XCTAssert(sut.themeColor == .red)
        XCTAssert(sut.notiCategoryId.contains("FocusInterval"))
        XCTAssert(sut.notiAction.title == "Start Break")
        XCTAssert(sut.notiContent.title == "Time to Break!")
        XCTAssert(sut.notiContent.body == "Well Done!!!")
        XCTAssert(sut.notiContent.title == "Time to Break!")
    }
    
    func testTimerControl() {
        let sut = FocusInterval()
        
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
