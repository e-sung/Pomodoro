//
//  HistoryMO+CoreDataClass.swift
//
//
//  Created by 류성두 on 24/03/2019.
//
//

import CoreData
import Foundation

public class TLPersistantContainer: NSPersistentContainer {}

@objc(HistoryMO)
public class HistoryMO: NSManagedObject {
    public func setUp(with history: History) {
        title = history.title
        content = history.content
        startDate = history.startTime as NSDate
        endDate = history.endTime as NSDate
    }

    public var durationStr: String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        guard let startTime = startDate as Date?, let endTime = endDate as Date? else { return "" }
        let startStr = dateFormatter.string(from: startTime)
        let endStr = dateFormatter.string(from: endTime)
        return "\(startStr) - \(endStr)"
    }
}
