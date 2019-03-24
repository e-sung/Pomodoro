//
//  HistoryMO+CoreDataProperties.swift
//  
//
//  Created by 류성두 on 24/03/2019.
//
//

import Foundation
import CoreData


extension HistoryMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HistoryMO> {
        return NSFetchRequest<HistoryMO>(entityName: "HistoryMO")
    }

    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var startDate: NSDate?
    @NSManaged public var endDate: NSDate?

}
