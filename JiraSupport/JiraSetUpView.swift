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
        if jql == defaultJQL {
            self.jql = ""
        } else {
            self.jql = jql
        }

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
            Section(header: HelperHeader(), footer: HelperFooter()) {
                Button(action: {
                    self.openAPITokenHelperPage()
                }) {
                    Text("API Token 생성 방법").foregroundColor(.primary)
                }
                Button(action: {
                    self.openJQLHelperPage()
                }) {
                    Text("JQL 사용방법").foregroundColor(.primary)
                }
            }
        }
    }

    func openAPITokenHelperPage() {
        let url = viewModel.tokenHelperURL
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    func openJQLHelperPage() {
        let url = viewModel.jqlHelperURL
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

struct HelperHeader: View {
    var body: some View {
        HStack {
            Image(systemName: "questionmark.circle")
            Text("도움말")
        }
    }
}

struct HelperFooter: View {
    var body: some View {
        VStack(alignment:.leading) {
            Text("* Jira의 비밀번호 대신 API 토큰을 발급받으셔야 합니다")
            Text("* JQL로 앱과 연동할 티켓들을 세부적으로 고를 수 있습니다.")
            Text("* JQL 기본값: assignee = currentUser()")
        }
        .padding(.top, 4)
    }
}

struct JiraSetUpView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = JiraSetUpViewModel(previousCredential: nil, jql: "")
        return JiraSetUpView(viewModel: viewModel)
    }
}
