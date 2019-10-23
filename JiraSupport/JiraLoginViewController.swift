//
//  JiraLoginViewController.swift
//  JiraSupport
//
//  Created by 류성두 on 2019/10/16.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import PomodoroFoundation
import PomodoroUIKit
import UIKit

public class JiraLoginViewController: UIViewController {
    @IBOutlet var textFieldUserName: UITextField!
    @IBOutlet var textFieldPassword: UITextField!
    public override func loadView() {
        Bundle(for: type(of: self)).loadNibNamed(className, owner: self, options: nil)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        textFieldUserName.delegate = self
        textFieldPassword.delegate = self
        hideKeyboardWhenTappedAround()
    }

    @IBAction func login() {
        guard let userName = textFieldUserName.text, let password = textFieldPassword.text else { return }
        let credential = Credentials(username: userName, password: password)
        loginJira(with: credential, then: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
    }
}

extension JiraLoginViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === textFieldUserName {
            textFieldPassword.becomeFirstResponder()
        } else {
            login()
        }
        return true
    }
}
