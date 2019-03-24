//
//  EditorViewController.swift
//  TimeLine
//
//  Created by 류성두 on 18/03/2019.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import UIKit
import RxKeyboard
import RxSwift

public protocol EditorViewControllerDelegate: class {
    func itemDidChange(_ title: String, body: String)
}

open class EditorViewController: UIViewController {
    
    public var history:HistoryMO?

    @IBOutlet public var titleTextView: UITextView!
    @IBOutlet public var bodyTextView: UITextView!
    @IBOutlet var heightOfTitleView: NSLayoutConstraint!
    @IBOutlet var heightOfBodyTextView: NSLayoutConstraint!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    var disposeBag = DisposeBag()
    public weak var delegate: EditorViewControllerDelegate?
    
    open override func loadView() {
        Bundle(for: EditorViewController.self).loadNibNamed(EditorViewController.className,
                                                            owner: self,
                                                            options: nil)
    }
    override open func viewDidLoad() {
        super.viewDidLoad()

        titleTextView.delegate = self
        bodyTextView.delegate = self
        titleTextView.text = history?.title
        bodyTextView.text = history?.content
        bodyTextView.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: bodyTextView.font!)
        
        adjustHeight(of: titleTextView, with: heightOfTitleView)
        RxKeyboard.instance.visibleHeight.asObservable().bind(onNext: { [weak self] height in
            self?.bottomConstraint.constant = height
            if height == 0 {
                self?.topConstraint.constant = 0
                UIView.animate(withDuration: 0.5, animations: {
                    self?.view.layoutIfNeeded()
                })
            }
        })
        .disposed(by: disposeBag)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Edit History"
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonClicked(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonClicked(_:)))
        navigationController?.navigationBar.tintColor = UIColor(white: 0.1, alpha: 1)

    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.itemDidChange(titleTextView.text, body: bodyTextView.text)
    }
    
    @objc open func cancelButtonClicked(_ sender: Any?) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc open func doneButtonClicked(_ sender: Any?) {
        navigationController?.popViewController(animated: true)
    }
}

extension EditorViewController: UITextViewDelegate {
    open func textViewDidChange(_ textView: UITextView) {
        if textView === titleTextView {
            if textView.text.has("\n") {
                bodyTextView.becomeFirstResponder()
                textView.text = textView.text.replace(from: "\n", to: "")
            }
            adjustHeight(of: textView, with: heightOfTitleView, duration: 0.5)
        }
    }

    func adjustHeight(of textView: UITextView, with height: NSLayoutConstraint, duration: TimeInterval = 0) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        height.constant = newSize.height
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }
}
