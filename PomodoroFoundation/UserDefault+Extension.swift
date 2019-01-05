//
//  UserDefault+Extension.swift
//  Pomodoro
//
//  Created by 류성두 on 30/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import Foundation

public func saveCycles(_ cycle: Int, date: Date = Date(), to userDefault: UserDefaults) {
    userDefault.set(cycle, forKey: "cycle")
    userDefault.set(date, forKey: "lastestCycleDate")
}

public func retreiveCycle(from userDefault: UserDefaults) -> Int {
    return userDefault.integer(forKey: "cycle")
}

public func retreiveLatestCycleDate(from userDefault: UserDefaults) -> Date {
    return userDefault.value(forKey: "lastestCycleDate") as? Date ?? Date()
}

public func save(_ amount: Int, for settingContent: SettingContent, to userDefault: UserDefaults) {
    userDefault.set(amount, forKey: settingContent.rawValue)
}

public func retreiveAmount(for settingContent: SettingContent, from userDefault: UserDefaults) -> Int? {
    let valueInUserDefault = userDefault.object(forKey: settingContent.rawValue) as? Int
    if valueInUserDefault == nil {
        return settingContent.defaultValue as? Int
    }
    else {
        return valueInUserDefault
    }
}

public func save(_ bool: Bool, for settingContent: SettingContent, to userDefault: UserDefaults) {
    userDefault.set(bool, forKey: settingContent.rawValue)
}

public func retreiveBool(for settingContent: SettingContent, from userDefault:UserDefaults) -> Bool? {
    return userDefault.object(forKey: settingContent.rawValue) as? Bool
}

public func saveDateBackgroundEntered(_ date: Date, to userDefault: UserDefaults) {
    userDefault.set(date, forKey: "dateBackgroundEnter")
}

public func retreiveDateBackgroundEntered(from userDefault: UserDefaults) -> Date? {
    return userDefault.object(forKey: "dateBackgroundEnter") as? Date
}

public func saveInterval(_ interval: Interval, to userDefault: UserDefaults) {
    userDefault.set(interval, forKey: "Interval")
}

public func retreiveInterval(from userDefault: UserDefaults) -> Interval? {
    return userDefault.object(forKey: "Interval") as? Interval
}
