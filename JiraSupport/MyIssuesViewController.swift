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

    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    weak var delegate: MyIssueViewControllerDelegate?
    var myIssues: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.startAnimating()
        fetchIssues(then: { [weak self] result in
            if let issues = try? result.get() {
                self?.myIssues = issues
                self?.tableView.reloadData()
            }
        })

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myIssues.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = myIssues[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let issue = myIssues[indexPath.row]
        delegate?.didSelect(issue: issue)
    }

}
