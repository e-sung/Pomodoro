//
//  JiraSetUpView.swift
//  JiraSupport
//
//  Created by 류성두 on 2020/03/01.
//  Copyright © 2020 Sungdoo. All rights reserved.
//

import SwiftUI
import Combine
import PomodoroFoundation

public class JiraSetUpViewModel: ObservableObject {
    @Published var host: String
    @Published public var email: String
    @Published public var apiToken: String
    @Published public var canSave: Bool = false
    var cancelables: [Cancellable] = []
    let previousCredential:Credentials?
    let previousHost: String?
    
    public init(previousCredential:Credentials?) {
        self.previousCredential = previousCredential
        self.previousHost = mainJiraDomain?.absoluteString
        self.host = mainJiraDomain?.absoluteString ?? ""
        self.email = previousCredential?.username ?? ""
        self.apiToken = previousCredential?.password ?? ""
        
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
        saveToKeychain(credentials: Credentials(username: email, password: apiToken), for: host)
    }
    
    func removePreviousCredential() {
        guard let credential = previousCredential else { return }
        guard let jira = mainJiraDomain?.absoluteString else { return }
        removeFromKeychain(credentials: credential, for: jira)
    }
    

}

public struct JiraSetUpView: View {
    @ObservedObject var viewModel:JiraSetUpViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var hasEdited = false
    public init(viewModel: JiraSetUpViewModel) {
        self.viewModel = viewModel

        
    }

    public var body: some View {
        NavigationView {
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
            }
            .navigationBarTitle("Jira SetUp", displayMode: .inline)
            .navigationBarItems(trailing:
               Button("Save", action: {
                    self.viewModel.saveCredentialsToKeychain()
                    self.presentationMode.wrappedValue.dismiss()
               })
                .disabled(self.viewModel.canSave == false)
            )
        }
    }
}




struct JiraSetUpView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = JiraSetUpViewModel(previousCredential: nil)
        return JiraSetUpView(viewModel: viewModel)
    }
}
