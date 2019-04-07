//
//  MockTimeLineViewController.swift
//  TimeLineApp
//
//  Created by 류성두 on 12/03/2019.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import LoremIpsum_iOS
import PomodoroFoundation
import PomodoroUIKit
import TimeLine
import CoreData
import UIKit

class MockTimeLineViewController: TimelineViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    @IBAction func buttonFloatClicked(_: UIButton) {
        let title = LoremIpsum.generateRandomWords(withLength: UInt.random(in: 1 ... 5))!
        let content = LoremIpsum.generateRandomWords(withLength: UInt.random(in: 10 ... 50))!
        viewModel.addHistory(title: title, memo: content, startDate: Date(), endDate: Date())
        tableView.reloadData()
    }
    
    @IBAction func buttonAddNewItemClicked(_ sender: Any) {
        present(finishPopUp, animated: true, completion: nil)
    }
    
}
