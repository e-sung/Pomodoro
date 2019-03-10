//
//  UIViewController+Extension.swift
//  PomodoroUIKit
//
//  Created by 류성두 on 10/03/2019.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import Foundation

extension UIViewController {
    open func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc open func dismissKeyboard() {
        view.endEditing(true)
    }
}
