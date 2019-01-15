//
//  TodayViewController.swift
//  Widget
//
//  Created by 류성두 on 15/01/2019.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import NotificationCenter
import PomodoroFoundation
import PomodoroUIKit
import UIKit

class TodayViewController: TimerViewController, NCWidgetProviding {
    override func viewDidLoad() {
        if interval == nil {
            super.viewDidLoad()
        }
    }

    @IBAction func playPauseButtonClicked(_: UIButton) {
        startOrStopTimer()
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        print(NCUpdateResult.failed)

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.newData)
    }
}
