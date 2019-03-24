//
//  HistoryMO+CoreDataClass.swift
//  
//
//  Created by 류성두 on 24/03/2019.
//
//

import Foundation
import CoreData

public class TLPersistantContainer: NSPersistentContainer {
    
}

@objc(HistoryMO)
public class HistoryMO: NSManagedObject {
    public func setUp(with history: History) {
        self.title = history.title
        self.content = history.content
        self.startDate = history.startTime as NSDate
        self.endDate = history.endTime as NSDate
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
