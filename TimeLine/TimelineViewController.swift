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

open class TimelineViewController: UIViewController {
    @IBOutlet var titleTextView: UITextView!
    @IBOutlet var tableView: UITableView!
    public var historyList:[History] = [] {
        didSet {
            historyList.sort(by: { $0.startTime > $1.startTime })
            tableView.reloadData()
        }
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        titleTextView.text = ""
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        let cellNib = UINib(nibName: TimeLineCell.className, bundle: Bundle(for: TimeLineCell.self))
        tableView.register(cellNib, forCellReuseIdentifier: TimeLineCell.className)
    }
    
}

extension TimelineViewController: UITableViewDataSource {
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimeLineCell.className) as! TimeLineCell
        let isLastIndex = (indexPath.row == historyList.count - 1)
        let history = historyList[indexPath.row]
        cell.update(with: history, isLast: isLastIndex)

        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension TimelineViewController: UITableViewDelegate {
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "progressCell")
        return cell
    }
}

