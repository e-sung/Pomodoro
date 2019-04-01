//
//  MockEditViewController.swift
//  TimeLineApp
//
//  Created by 류성두 on 24/03/2019.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import PomodoroUIKit
import TimeLine
import UIKit

class MockEditViewController: EditorViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func doneButtonClicked(_ sender: Any?) {
        super.doneButtonClicked(sender)
        guard let history = history else { return }
        history.title = titleTextView.text
        history.content = bodyTextView.text
        appDelegate.saveContext()
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}
