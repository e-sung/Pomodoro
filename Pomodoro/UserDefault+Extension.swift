//
//  UserDefault+Extension.swift
//  Pomodoro
//
//  Created by 류성두 on 30/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import Foundation

func save(_ minute: Int, for cellType: BasicSettingTableViewCell.TYPE, to userDefault: UserDefaults) {
    userDefault.set(minute, forKey: cellType.rawValue)
}

func retreiveMinute(for cellType: BasicSettingTableViewCell.TYPE, from userDefault: UserDefaults) -> Int {
    return userDefault.integer(forKey: cellType.rawValue)
}

func saveCycles(_ cycle: Int, date: Date = Date(), to userDefault: UserDefaults) {
    userDefault.set(cycle, forKey: "cycle")
    userDefault.set(date, forKey: "lastestCycleDate")
}

func retreiveCycle(from userDefault: UserDefaults) -> Int {
    return userDefault.integer(forKey: "cycle")
}

func retreiveLatestCycleDate(from userDefault: UserDefaults) -> Date {
    return userDefault.value(forKey: "lastestCycleDate") as? Date ?? Date()
}
