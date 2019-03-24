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
}
