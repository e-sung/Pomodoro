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

        let viewModel = JiraSetUpViewModel(previousCredential: previousCredential)
        let jiraSetupView = JiraSetUpView(viewModel: viewModel)
        let jiraSetUpViewHostController = UIHostingController(rootView: jiraSetupView)
        addChild(jiraSetUpViewHostController)
        jiraSetUpViewHostController.loadViewIfNeeded()
        view.addSubview(jiraSetUpViewHostController.view)
        jiraSetUpViewHostController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        jiraSetUpViewHostController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        jiraSetUpViewHostController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        jiraSetUpViewHostController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        jiraSetUpViewHostController.view.translatesAutoresizingMaskIntoConstraints = false

    }

    func removePreviousCredential() {
        guard let credential = previousCredential else { return }
        guard let jira = mainJiraDomain?.absoluteString else { return }
        removeFromKeychain(credentials: credential, for: jira)
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
        let newCredential = Credentials(username:userName, password: password)
        saveToKeychain(credentials: newCredential,for: host)
    }
}

class JiraHostTextFieldDelegate: NSObject, UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        guard let url = URL(string: text) else { return }
        UserDefaults.standard.set(url, forKey: "JiraHostURL")
    }
}
