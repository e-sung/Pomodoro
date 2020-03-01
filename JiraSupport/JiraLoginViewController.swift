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
import SwiftUI

public class JiraLoginViewController: UIViewController {
    @IBOutlet var textFieldUserName: UITextField!
    @IBOutlet var textFieldPassword: UITextField!
    @IBOutlet var textFieldJiraHost: UITextField!
    private var jiraHostTextFieldDelegate = JiraHostTextFieldDelegate()
    public override func loadView() {
        Bundle(for: type(of: self)).loadNibNamed(className, owner: self, options: nil)
    }

    public var previousCredential: Credentials?

    public override func viewDidLoad() {
        super.viewDidLoad()
        textFieldUserName.delegate = self
        textFieldPassword.delegate = self
        textFieldJiraHost.delegate = jiraHostTextFieldDelegate
        textFieldUserName.placeholder = "e-mail"
        textFieldPassword.placeholder = "API-Token"
        hideKeyboardWhenTappedAround()
        textFieldJiraHost.text = mainJiraDomain?.absoluteString
        if let credential = previousCredential {
            textFieldUserName.text = credential.username
            textFieldPassword.text = credential.password
        }
        
        
//        let viewModel = JiraSetUpViewModel(host: "https://asdf.com", email: "asdf", apiToken: "s")
//        var jiraSetUpView = UIHostingController(rootView: JiraSetUpView(viewModel: viewModel))
//        addChild(jiraSetUpView)
//        jiraSetUpView.loadViewIfNeeded()
//        view.addSubview(jiraSetUpView.view)
//        jiraSetUpView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        jiraSetUpView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        jiraSetUpView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        jiraSetUpView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        jiraSetUpView.view.translatesAutoresizingMaskIntoConstraints = false

    }

    func removePreviousCredential() {
        guard let credential = previousCredential else { return }
        removeFromKeychain(credentials: credential)
    }
}

extension JiraLoginViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        removePreviousCredential()
        if textField === textFieldUserName {
            textFieldPassword.becomeFirstResponder()
        }
        return true
    }

    public func textFieldDidEndEditing(_: UITextField) {
        removePreviousCredential()
        guard let host = textFieldJiraHost.text else { return }
        guard let userName = textFieldUserName.text, let password = textFieldPassword.text else { return }
        guard userName.isEmpty == false, password.isEmpty == false else { return }
        let newCredential = Credentials(host:host, username: userName, password: password)
        saveToKeychain(credentials: newCredential)
    }
}

class JiraHostTextFieldDelegate: NSObject, UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        guard let url = URL(string: text) else { return }
        UserDefaults.standard.set(url, forKey: "JiraHostURL")
    }
}
