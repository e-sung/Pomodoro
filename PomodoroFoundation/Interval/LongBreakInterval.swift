//
//  LongBreakInterval.swift
//  PomodoroFoundation
//
//  Created by 류성두 on 29/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import Foundation

public class LongBreakInterval: BreakInterval {

    override public var targetMinute: TimeInterval {
        let longBreakAmount = retreiveAmount(for: .longBreakTime, from: UserDefaults.standard)!
        return TimeInterval(exactly: longBreakAmount)!
    }
    
}
