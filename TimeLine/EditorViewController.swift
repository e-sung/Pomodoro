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

open class EditorViewController: UIViewController {

    @IBOutlet var titleTextView: UITextView!
    @IBOutlet var bodyTextView: UITextView!
    @IBOutlet var heightOfTitleView: NSLayoutConstraint!
    @IBOutlet var heightOfBodyTextView: NSLayoutConstraint!
    
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    var disposeBag = DisposeBag()
    
    open override func loadView() {
        Bundle(for: EditorViewController.self).loadNibNamed(EditorViewController.className,
                                                            owner: self,
                                                            options: nil)
    }
    override open func viewDidLoad() {
        super.viewDidLoad()

        titleTextView.delegate = self
        bodyTextView.delegate = self
        bodyTextView.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: bodyTextView.font!)
        adjustHeight(of: titleTextView, with: heightOfTitleView)
        
        RxKeyboard.instance.visibleHeight.asObservable().bind(onNext: { [weak self] height in
            self?.bottomConstraint.constant = height
        })
        .disposed(by: disposeBag)
    }

}

extension EditorViewController: UITextViewDelegate {
    open func textViewDidChange(_ textView: UITextView) {
        if textView === titleTextView {
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
