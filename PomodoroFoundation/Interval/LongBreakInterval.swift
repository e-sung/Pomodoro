//
//  LongBreakInterval.swift
//  PomodoroFoundation
//
//  Created by 류성두 on 29/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import Foundation

public class LongBreakInterval: BreakInterval {
    
    override public var targetSeconds: TimeInterval {
//        return 5
                return 60 * targetMinute
    }
    
    override public var targetMinute: TimeInterval {
        return 15
    }
    
}
