//
//  History.swift
//  TimeLine
//
//  Created by 류성두 on 11/03/2019.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import Foundation

public struct History: Codable {
    public var title: String
    public var content: String
    public var startTime: Date
    public var endTime: Date
    public var durationStr: String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        let startStr = dateFormatter.string(from: startTime)
        let endStr = dateFormatter.string(from: endTime)
        return "\(startStr) - \(endStr)"
    }
    public init(title: String, content: String, startTime: Date, endTime: Date) {
        self.title = title
        self.content = content
        self.startTime = startTime
        self.endTime = endTime
    }
    
    public init(with managedObject: HistoryMO) {
        self.title = managedObject.title ?? ""
        self.content = managedObject.content ?? ""
        self.startTime = managedObject.startDate as Date? ?? Date()
        self.endTime = managedObject.endDate as Date? ?? Date()
    }
}
