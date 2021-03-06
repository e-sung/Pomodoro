//
//  TimelineViewModel.swift
//  TimeLine
//
//  Created by 류성두 on 07/04/2019.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import CoreData
import Foundation
import PomodoroFoundation

open class TimelineViewModel {
    let appDelegate = UIApplication.shared.delegate as! PMAppDelegate
    let context = (UIApplication.shared.delegate as! PMAppDelegate).persistentContainer.viewContext

    public var fetchRequest: NSFetchRequest<HistoryMO> {
        let fetchRequest = NSFetchRequest<HistoryMO>(entityName: HistoryMO.className)
        fetchRequest.predicate = NSPredicate(format: "(startDate >= %@) AND (startDate <= %@)", argumentArray: [Date().midnight, Date.tomorrow.midnight])
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: true)]
        return fetchRequest
    }

    public var fetchedHistories: [HistoryMO] = []

    public func fetchHistories() {
        fetchedHistories = try! context.fetch(fetchRequest)
    }

    open func delete(history: HistoryMO) {
        context.delete(history)
        fetchedHistories.removeAll(where: { $0.startDate == history.startDate })
        try? context.save()
    }

    open func addHistory(title: String, memo: String, startDate _: Date, endDate _: Date) {
        let historyMO = HistoryMO(entity: HistoryMO.entity(), insertInto: context)
        historyMO.setUp(title: title, content: memo, startTime: Date(), endTime: Date())
        appDelegate.saveContext()
        fetchedHistories.append(historyMO)
    }
}
