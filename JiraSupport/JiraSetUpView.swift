//
//  JiraSetUpView.swift
//  JiraSupport
//
//  Created by 류성두 on 2020/03/01.
//  Copyright © 2020 Sungdoo. All rights reserved.
//

import Combine
import PomodoroFoundation
import SwiftUI

public class JiraSetUpViewModel: ObservableObject {
    @Published var host: String
    @Published public var email: String
    @Published public var apiToken: String
    @Published public var jql: String
    @Published public var canSave: Bool = false
    var cancelables: [Cancellable] = []
    let previousCredential: Credentials?
    let previousHost: String?
    let tokenHelperURL = URL(string: "https://confluence.atlassian.com/cloud/api-tokens-938839638.html")!
    let jqlHelperURL = URL(string: "https://www.atlassian.com/blog/jira-software/jql-the-most-flexible-way-to-search-jira-14")!

    public init(previousCredential: Credentials?, jql: String) {
        self.previousCredential = previousCredential
        previousHost = mainJiraDomain?.absoluteString
        host = mainJiraDomain?.absoluteString ?? "https://rainist.atlassian.net"
        email = previousCredential?.username ?? ""
        apiToken = previousCredential?.password ?? ""
        self.jql = jql

        let newInput = $host
            .combineLatest($email, $apiToken)
            .sink(receiveValue: { [weak self] newHost, newEmail, newToken in
                self?.canSave = self?.previousHost != newHost
                    || self?.previousCredential?.username != newEmail
                    || self?.previousCredential?.password != newToken
            })
        cancelables = [newInput]
    }

    func saveCredentialsToKeychain() {
        removePreviousCredential()
        mainJiraDomain = URL(string: host)
        mainJQL = jql
        saveToKeychain(credentials: Credentials(username: email, password: apiToken), for: host)
    }

    func removePreviousCredential() {
        guard let credential = previousCredential else { return }
        guard let jira = mainJiraDomain?.absoluteString else { return }
        removeFromKeychain(credentials: credential, for: jira)
    }
}

public struct JiraSetUpView: View {
    @ObservedObject var viewModel: JiraSetUpViewModel
    @Environment(\.presentationMode) var presentationMode
    public init(viewModel: JiraSetUpViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        Form {
            HStack {
                Image(systemName: "globe")
                    .frame(width: 15, height: 15)
                TextField("Jira Host Address", text: $viewModel.host)
                    .textContentType(.URL)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            HStack {
                Image(systemName: "envelope")
                    .frame(width: 15, height: 15)
                TextField("Jira User Email", text: $viewModel.email)
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            HStack {
                Image(systemName: "lock")
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 15, height: 15)
                SecureField("Jira API Token", text: $viewModel.apiToken)
                    .textContentType(.password)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            HStack {
                Image(systemName: "tray.2")
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 15, height: 15)
                TextField("JQL", text: $viewModel.jql)
                    .textContentType(.password)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            Section(header: HelperFooter()) {
                Text("API Token 발급 받는 법")
                    .onTapGesture {
                        let url = self.viewModel.tokenHelperURL
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                Text("JQL이란?")
                    .onTapGesture {
                        let url = self.viewModel.jqlHelperURL
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
            }
        }
    }
}

struct HelperFooter: View {
    var body: some View {
        HStack {
            Image(systemName: "questionmark.circle")
            Text("도움말")
        }
    }
}

struct JiraSetUpView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = JiraSetUpViewModel(previousCredential: nil, jql: "")
        return JiraSetUpView(viewModel: viewModel)
    }
}
