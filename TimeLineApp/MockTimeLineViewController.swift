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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonFloatClicked(_ sender: UIButton) {
        let title = LoremIpsum.generateRandomWords(withLength: UInt.random(in: 1...5))!
        let content = LoremIpsum.generateRandomWords(withLength: UInt.random(in: 10...50))!
        let historyItem = History(title: title, content: content, startTime: Date(), endTime: Date())
        historyList.append(historyItem)
    }

}
