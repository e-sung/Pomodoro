//
//  UserDefaults+Extension.swift
//  PomodoroSettings
//
//  Created by 류성두 on 30/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import Foundation

public func save(_ amount: Int, for cellType: SettingContent, to userDefault: UserDefaults) {
    userDefault.set(amount, forKey: cellType.rawValue)
}

public func retreiveAmount(for cellType: SettingContent, from userDefault: UserDefaults) -> Int {
    return userDefault.integer(forKey: cellType.rawValue)
}
