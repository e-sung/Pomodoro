//
//  MockTimeLineViewController.swift
//  TimeLineApp
//
//  Created by 류성두 on 12/03/2019.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import UIKit
import PomodoroFoundation
import PomodoroUIKit
import TimeLine
import LoremIpsum_iOS

class MockTimeLineViewController: TimelineViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchedHistories = try! context.fetch(HistoryMO.fetchRequest())
        tableView.reloadData()
    }
    
    @IBAction func buttonFloatClicked(_ sender: UIButton) {
        let title = LoremIpsum.generateRandomWords(withLength: UInt.random(in: 1...5))!
        let content = LoremIpsum.generateRandomWords(withLength: UInt.random(in: 10...50))!
        let historyItem = History(title: title, content: content, startTime: Date(), endTime: Date())

        let historyMO = HistoryMO(entity: HistoryMO.entity(), insertInto: context)
        historyMO.setUp(with: historyItem)
        appDelegate.saveContext()
        fetchedHistories.append(historyMO)
        tableView.reloadData()
    }

}
