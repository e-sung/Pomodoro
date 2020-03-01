//
//  JiraLoginViewController.swift
//  JiraSupport
//
//  Created by 류성두 on 2019/10/16.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import PomodoroFoundation
import PomodoroUIKit
import SwiftUI
import UIKit

public class JiraLoginViewController: UIViewController {
    var viewModel: JiraSetUpViewModel!
    public override func viewDidLoad() {
        super.viewDidLoad()
        if let mainJiraDomain = mainJiraDomain?.absoluteString {
            let credential = try? retreiveSavedCredentials(for: mainJiraDomain)
            viewModel = JiraSetUpViewModel(previousCredential: credential, jql: mainJQL)
        } else {
            viewModel = JiraSetUpViewModel(previousCredential: nil, jql: "")
        }
        let jiraSetUpView = JiraSetUpView(viewModel: viewModel)
        let jiraSetUpViewHostController = UIHostingController(rootView: jiraSetUpView)

        addChild(jiraSetUpViewHostController)
        jiraSetUpViewHostController.loadViewIfNeeded()
        view.addSubview(jiraSetUpViewHostController.view)
        jiraSetUpViewHostController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        jiraSetUpViewHostController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        jiraSetUpViewHostController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        jiraSetUpViewHostController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        jiraSetUpViewHostController.view.translatesAutoresizingMaskIntoConstraints = false

        let saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        navigationItem.setRightBarButton(saveBarButtonItem, animated: false)
    }

    @objc func save() {
        viewModel.saveCredentialsToKeychain()
        navigationController?.popViewController(animated: true)
    }
}
