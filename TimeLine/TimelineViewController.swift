//
//  ViewController.swift
//  TimeLine
//
//  Created by 류성두 on 11/02/2019.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import PomodoroFoundation
import PomodoroUIKit
import RxSwift
import RxKeyboard
import UIKit

open class TimelineViewController: UIViewController {
    @IBOutlet public var titleTextView: UITextView!
    @IBOutlet public var tableView: UITableView!
    public var fetchedHistories: [HistoryMO] = []
    public var keyboardHeight: CGFloat = 0
    public var disposeBag = DisposeBag()
    public var titleText: String {
        var title = titleTextView.text
        if title == nil || title?.isEmpty == true {
            title = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
        }
        return title!
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
        RxKeyboard.instance.visibleHeight.asObservable()
            .delay(1, scheduler: MainScheduler.instance)
            .bind(onNext:  { [weak self] in
            self?.keyboardHeight = $0
        })
        .disposed(by: disposeBag)
        
        titleTextView.rx.text.bind(onNext: { [weak self] _ in
            guard let tableHeaderView = self?.tableView.tableHeaderView else { return }
            let newSize = tableHeaderView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            tableHeaderView.frame = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
            self?.tableView.reloadData()
        })
        .disposed(by: disposeBag)
        
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editVC = segue.destination as? EditorViewController, let sender = sender as? TimeLineCell {
            editVC.delegate = sender
            editVC.history = sender.history
        }
    }
    
    open func delete(history: HistoryMO) {
        
    }
}

extension TimelineViewController: UITableViewDataSource {
    open func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return fetchedHistories.count
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimeLineCell.className) as! TimeLineCell
        let isLastIndex = (indexPath.row == fetchedHistories.count - 1)
        let history = fetchedHistories[indexPath.row]
        cell.update(with: history, isLast: isLastIndex)
        return cell
    }

    public func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension TimelineViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TimeLineCell else { return }
        guard keyboardHeight == 0 else { return }
        showEditItemActionSheet(for: cell)

    }
    
    func showEditItemActionSheet(for cell: TimeLineCell) {
        let actionSheet = UIAlertController(title: "What do yo want to do?", message: nil, preferredStyle: .actionSheet)
        
        let actions = [
            UIAlertAction(title: "Edit", style: .default, handler: { [weak self] (action) in
                self?.performSegue(withIdentifier: "showEditVC", sender: cell)
            }),
            UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] action in
                self?.showAreYouSureToDeleteAlert(for: cell)
            })
        ]
        
        actions.forEach({ actionSheet.addAction($0) })
        present(actionSheet, animated: true, completion: nil)
    }
    
    func showAreYouSureToDeleteAlert(for cell: TimeLineCell) {
        let areYouSureAlert = UIAlertController(title: "Are you Sure?", message: nil, preferredStyle: .alert)
        let Delete = UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            guard let history = cell.history else { return }
            self?.delete(history: history)
            print("Deleted")
        })
        let Cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        areYouSureAlert.addAction(Delete)
        areYouSureAlert.addAction(Cancel)
        present(areYouSureAlert, animated: true, completion: nil)
    }

    open func tableView(_: UITableView, viewForFooterInSection _: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }

    open func tableView(_ tableView: UITableView, viewForHeaderInSection _: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "progressCell")
        return cell
    }
}
