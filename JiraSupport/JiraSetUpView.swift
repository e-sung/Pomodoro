//
//  JiraSetUpView.swift
//  JiraSupport
//
//  Created by 류성두 on 2020/03/01.
//  Copyright © 2020 Sungdoo. All rights reserved.
//

import SwiftUI
import Combine

class JiraSetUpViewModel: ObservableObject {
    @Published var host: String
    @Published public var email: String
    @Published public var apiToken: String
    var cancelable: [Cancellable] = []
    
    init(host:String, email:String, apiToken: String) {
        self.host = host
        self.email = email
        self.apiToken = apiToken

        let valueChange = $host
            .combineLatest($email, $apiToken)
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink(receiveValue: { host, email, apiToken in
                print("Host: \(host)")
                print("Email: \(email)")
                print("apiToken: \(apiToken)")
            })
        cancelable.append(valueChange)
    }
}

public struct JiraSetUpView: View {
    @ObservedObject var viewModel:JiraSetUpViewModel
//    @State public var host: String = ""
//    @State public var email: String = ""
//    @State public var apiToken: String = ""
    public var body: some View {
        Form {
            HStack {
                Image(systemName: "globe")
                    .frame(width: 15, height: 15)
                TextField("Jira Host Address", text: $viewModel.host)
            }
            HStack {
                Image(systemName: "envelope")
                    .frame(width: 15, height: 15)
                TextField("Jira User Email", text: $viewModel.email)
            }
            HStack {
                Image(systemName: "lock")
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 15, height: 15)
                TextField("Jira API Token", text: $viewModel.apiToken, onCommit: {
                    print("passwordChanged")
                })
            }
        }
    }
}

struct JiraSetUpView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = JiraSetUpViewModel(host: "https://asdf.com", email: "asdf", apiToken: "s")
        return JiraSetUpView(viewModel: viewModel)
    }
}
