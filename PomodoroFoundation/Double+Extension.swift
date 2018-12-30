//
//  Double+Extension.swift
//  Pomodoro
//
//  Created by 류성두 on 30/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import Foundation
import SwiftDate

extension Double {
    public var minuteString: String {
        return self.toString(options: {
            $0.allowedUnits = [.minute]
            $0.unitsStyle = .short
        })
    }
}

extension Int {
    public var minuteString: String {
        let interval = Double(self * 60)
        return interval.minuteString
    }
}
