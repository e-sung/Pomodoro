//
//  MyIssuesViewController.swift
//  JiraSupport
//
//  Created by 류성두 on 2019/10/16.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import UIKit

public protocol MyIssueViewControllerDelegate: AnyObject {
    func didSelect(issue: Issue?)
}

public class MyIssuesViewController: UITableViewController {
    public weak var delegate: MyIssueViewControllerDelegate?
    var myIssues: [Issue] = []

    public static var storyboardInstance: MyIssuesViewController {
        let sb = UIStoryboard(name: "MyIssues", bundle: Bundle(for: MyIssuesViewController.self))
        return sb.instantiateInitialViewController() as! MyIssuesViewController
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchIssues(then: { [weak self] result in
            if let issues = try? result.get() {
                self?.myIssues = issues
                self?.tableView.reloadData()
            }
        })
    }

    public override func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    public override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return myIssues.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = myIssues[indexPath.row].sumamry
        return cell
    }

    public override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let issue = myIssues[indexPath.row]
        delegate?.didSelect(issue: issue)
        dismiss(animated: true, completion: nil)
    }
}
