//
//  MyIssuesViewController.swift
//  JiraSupport
//
//  Created by 류성두 on 2019/10/16.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import UIKit

protocol MyIssueViewControllerDelegate: AnyObject {
    func didSelect(issue: String)
}

class MyIssuesViewController: UITableViewController {
    weak var delegate: MyIssueViewControllerDelegate?
    var myIssues: [String] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchIssues(then: { [weak self] result in
            if let issues = try? result.get() {
                self?.myIssues = issues
                self?.tableView.reloadData()
            }
        })
    }

    override func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return myIssues.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = myIssues[indexPath.row]
        return cell
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let issue = myIssues[indexPath.row]
        delegate?.didSelect(issue: issue)
    }
}
