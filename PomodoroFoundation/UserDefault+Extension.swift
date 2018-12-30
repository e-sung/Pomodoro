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

public func save(_ amount: Int, for cellType: SettingContent, to userDefault: UserDefaults) {
    userDefault.set(amount, forKey: cellType.rawValue)
}

public func retreiveAmount(for cellType: SettingContent, from userDefault: UserDefaults) -> Int {
    return userDefault.integer(forKey: cellType.rawValue)
}
