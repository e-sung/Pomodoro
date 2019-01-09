//
//  Double+Extension.swift
//  Pomodoro
//
//  Created by 류성두 on 30/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import Foundation

extension Double {
    public var minuteString: String {
        let integerValue = Int(exactly: self)!
        return integerValue.minuteString
    }

    public var secondString: String {
        let integerValue = Int(exactly: self)!
        return integerValue.secondString
    }
}

extension Int {
    public var minuteString: String {
        let minute = DateComponents(minute: self)
        return minuteFormatter.string(from: minute)!
    }

    public var secondString: String {
        let second = DateComponents(second: self)
        return secondFormatter.string(from: second)!
    }
}

private var minuteFormatter: DateComponentsFormatter {
    let dateComponentFormatter = DateComponentsFormatter()
    dateComponentFormatter.formattingContext = .beginningOfSentence
    dateComponentFormatter.unitsStyle = .short
    dateComponentFormatter.allowedUnits = .minute
    return dateComponentFormatter
}

private var secondFormatter: DateComponentsFormatter {
    let dateComponentFormatter = DateComponentsFormatter()
    dateComponentFormatter.formattingContext = .beginningOfSentence
    dateComponentFormatter.unitsStyle = .short
    dateComponentFormatter.allowedUnits = .second
    return dateComponentFormatter
}
