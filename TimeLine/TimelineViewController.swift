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
import CoreData

open class TimelineViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! PMAppDelegate
    let context = (UIApplication.shared.delegate as! PMAppDelegate).persistentContainer.viewContext
    public var viewModel = TimelineViewModel()
    public var disposeBag = DisposeBag()
    public var keyboardHeight: CGFloat = 0

    @IBOutlet public var titleTextView: UITextView!
    @IBOutlet public var tableView: UITableView!

    // MARK: - LifeCycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        titleTextView.text = ""
        setUpTableView()
        RxKeyboard.instance.visibleHeight.asObservable()
            .delay(1, scheduler: MainScheduler.instance)
            .bind(onNext:  { [weak self] in
            self?.keyboardHeight = $0
        })
        .disposed(by: disposeBag)
        navigationController?.setNavigationBarHidden(true, animated: false)
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
        viewModel.fetchHistories()
        tableView.reloadData()
        guard viewModel.fetchedHistories.isEmpty == false else { return }
        tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
    }

    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editVC = segue.destination as? EditorViewController, let sender = sender as? TimeLineCell {
            editVC.delegate = sender
            editVC.history = sender.history
        }
    }
}

// MARK: - TableViewDataSource
extension TimelineViewController: UITableViewDataSource {
    open func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.fetchedHistories.count
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimeLineCell.className) as! TimeLineCell
        let isLastIndex = (indexPath.row == viewModel.fetchedHistories.count - 1)
        let history = viewModel.fetchedHistories[indexPath.row]
        cell.update(with: history, isLast: isLastIndex)
        return cell
    }

    public func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= -40 {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        else if scrollView.contentOffset.y > 44 {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
}

// MARK: - TableViewDelegate
extension TimelineViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TimeLineCell else { return }
        guard keyboardHeight == 0 else { return }
        present(editPopUp(for: cell), animated: true, completion: nil)

    }

    open func tableView(_: UITableView, viewForFooterInSection _: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }

    open func tableView(_ tableView: UITableView, viewForHeaderInSection _: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "progressCell")
        return cell
    }
}

// MARK: - Alerts
extension TimelineViewController {
    public var finishPopUp: UIAlertController {
        let alert = UIAlertController(title: "Congratulation!", message: "Add Memo?", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { tf in
            tf.placeholder = "some placeholderw"
        })
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.addNewItem(with: alert)
        })
        
        let noAction = UIAlertAction(title: "No", style: .default, handler: { [weak self] _ in
            self?.addNewItem(with: alert)
        })
        
        alert.addAction(noAction)
        alert.addAction(okAction)
        return alert
    }
    
    public func editPopUp(for cell: TimeLineCell ) -> UIAlertController {
        let actionSheet = UIAlertController(title: "What do yo want to do?", message: nil, preferredStyle: .actionSheet)
        let areYouSureAlert = deletePopUp(for: cell)
        let actions = [
            UIAlertAction(title: "Edit", style: .default, handler: { [weak self] (action) in
                self?.performSegue(withIdentifier: "showEditVC", sender: cell)
            }),
            UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] action in
                self?.present(areYouSureAlert, animated: true, completion: nil)
            }),
            UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                actionSheet.dismiss(animated: true, completion: nil)
            })
        ]
        
        actions.forEach({ actionSheet.addAction($0) })
        return actionSheet
    }
    
    public func deletePopUp(for cell: TimeLineCell) -> UIAlertController {
        let areYouSureAlert = UIAlertController(title: "Are you Sure?", message: nil, preferredStyle: .alert)
        let Delete = UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            guard let history = cell.history else { return }
            self?.delete(history: history)
        })
        let Cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        areYouSureAlert.addAction(Delete)
        areYouSureAlert.addAction(Cancel)
        return areYouSureAlert
    }
}

// MARK: - Helper
extension TimelineViewController {
    
    public func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        let cellNib = UINib(nibName: TimeLineCell.className, bundle: Bundle(for: TimeLineCell.self))
        tableView.register(cellNib, forCellReuseIdentifier: TimeLineCell.className)
    }
    
    public var titleText: String {
        var title = titleTextView.text
        if title == nil || title?.isEmpty == true {
            title = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
        }
        return title!
    }
    
    open func delete(history: HistoryMO) {
        viewModel.delete(history: history)
        tableView.reloadData()
    }
    
    public func addNewItem(with alert: UIAlertController) {
        var memo = alert.textFields?.first?.text
        if memo == nil || memo?.isEmpty == true {
            memo = "-"
        }
        viewModel.addHistory(title: titleText, memo: memo!, startDate: Date(), endDate: Date())
        tableView.reloadData()
        scrollToBottom()
    }
    
    public func scrollToBottom() {
        let itemCount = viewModel.fetchedHistories.count
        guard itemCount > 0 else { return }
        let indexPath = IndexPath(row: itemCount - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}
