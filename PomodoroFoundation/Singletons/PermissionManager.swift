//
//  PermissionManager.swift
//  Pomodoro
//
//  Created by 류성두 on 23/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import Foundation

public class PermissionManager: NSObject {
    public static var shared = PermissionManager()
    public var canSendLocalNotification = false
}
