//
//  FetchIssues.swift
//  JiraSupport
//
//  Created by 류성두 on 2019/10/16.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import Alamofire
import Foundation
import PomodoroFoundation

var credentialHeader: HTTPHeader? {
    guard let mainJiraDomain = mainJiraDomain?.absoluteString else { return nil }
    guard let credential = try? retreiveSavedCredentials(for: mainJiraDomain) else { return nil }
    let credentialData = "\(credential.username):\(credential.password)".data(using: .utf8)
    guard let base64Credential = credentialData?.base64EncodedString() else { return nil }
    return HTTPHeader(name: "Authorization", value: "Basic \(base64Credential)")
}

func fetchIssues(then completionHandler: @escaping (Result<[Issue], Error>) -> Void) {
    let jql = mainJQL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    guard let url = URL(string: "/rest/api/2/search?jql=\(jql)", relativeTo: mainJiraDomain) else {
        fatalError("Wrong Path for Issues")
    }

    guard let credentialHeader = credentialHeader else {
        completionHandler(.failure(KeychainError.noPassword))
        return
    }

    AF.request(url,
               method: .get,
               parameters: nil,
               encoding: JSONEncoding.prettyPrinted,
               headers: HTTPHeaders([credentialHeader]),
               interceptor: nil).responseJSON(completionHandler: { res in
        let dict = res.value as? [String: Any]
        let issues = dict?["issues"] as? [[String: Any]]
        let issueSummaries = issues?
            .compactMap { dict -> Issue? in
                guard let field = dict["fields"] as? [String: Any] else { return nil }
                guard let key = dict["key"] as? String else { return nil }
                guard let summary = field["summary"] as? String else { return nil }
                return Issue(key: key, sumamry: summary)
            }
        if let error = res.error {
            completionHandler(.failure(error))
        } else {
            completionHandler(.success(issueSummaries ?? []))
        }
    })
}
