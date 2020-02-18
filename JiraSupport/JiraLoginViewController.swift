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
    @IBOutlet var textFieldJiraHost: UITextField!
    private var jiraHostTextFieldDelegate = JiraHostTextFieldDelegate()
    public override func loadView() {
        Bundle(for: type(of: self)).loadNibNamed(className, owner: self, options: nil)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        textFieldUserName.delegate = self
        textFieldPassword.delegate = self
        textFieldJiraHost.delegate = jiraHostTextFieldDelegate
        textFieldUserName.placeholder = "e-mail"
        textFieldPassword.placeholder = "API-Token"
        hideKeyboardWhenTappedAround()
        textFieldJiraHost.text = mainJiraDomain?.absoluteString
    }
}

extension JiraLoginViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === textFieldUserName {
            textFieldPassword.becomeFirstResponder()
        }
        return true
    }

    public func textFieldDidEndEditing(_: UITextField) {
        guard let userName = textFieldUserName.text, let password = textFieldPassword.text else { return }
        guard userName.isEmpty == false, password.isEmpty == false else { return }
        let credential = Credentials(username: userName, password: password)
        saveToKeychain(credentials: credential)
    }
}

class JiraHostTextFieldDelegate: NSObject, UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        guard let url = URL(string: text) else { return }
        UserDefaults.standard.set(url, forKey: "JiraHostURL")
    }
}
