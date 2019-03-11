//
//  ViewController.swift
//  TimeLine
//
//  Created by 류성두 on 11/02/2019.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import UIKit
import PomodoroFoundation
import PomodoroUIKit

class TimelineViewController: UIViewController {
    @IBOutlet var titleTextView: UITextView!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        titleTextView.text = ""
        tableView.dataSource = self
        tableView.delegate = self

    }
}

extension TimelineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        return cell
    }
}

extension TimelineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "progressCell")
        return cell
    }
}

