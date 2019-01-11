//
//  NotificationManagerTests.swift
//  PomodoroFoundationTests
//
//  Created by 류성두 on 29/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

@testable import PomodoroFoundation
import UserNotifications
import XCTest

class NotificationManagerTests: XCTestCase {
    var notiExpectation: XCTestExpectation!
    func testInit() {
        let sut = NotificationManager(delegate: self)
        XCTAssertNotNil(sut)
    }

    func testPublishNotification() {
        #if targetEnvironment(simulator)
            // Don't test this on simulator because it cannot be tested
        #else
            let sut = NotificationManager(delegate: self)
            notiExpectation = expectation(description: "Noti Received")

            sut.publishNotiContent(of: FocusInterval(), via: UNUserNotificationCenter.current())
            wait(for: [notiExpectation], timeout: 5)
        #endif
    }
}

// MARK: UserNotificationExtension

extension NotificationManagerTests: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_: UNUserNotificationCenter,
                                       didReceive _: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    public func userNotificationCenter(_: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler
                                       completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        XCTAssert(notification.request.content.title == "Time to Break!")
        notiExpectation.fulfill()
        completionHandler([.alert, .sound, .badge])
    }
}
