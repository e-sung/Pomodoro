//
//  PermissionManager.swift
//  Pomodoro
//
//  Created by 류성두 on 23/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import Foundation

class PermissionManager {
    static var shared = PermissionManager()
    var canSendLocalNotification = false
}
