//
//  FetchIssues.swift
//  JiraSupport
//
//  Created by 류성두 on 2019/10/16.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import Alamofire
import Foundation

func fetchIssues(then completionHandler: @escaping (Result<[String], Error>) -> Void) {
    let url = "https://jira.flit.to:18443/rest/api/2/search?jql=assignee%20=%20currentUser()%20AND%20%20status%20=%20%22In%20Progress%22"
    AF.request(url).responseJSON(completionHandler: { res in
        let dict = res.value as? [String: Any]
        let issues = dict?["issues"] as? [[String: Any]]
        let issueSummaries = issues?
            .compactMap({ $0["fields"] as? [String: Any] })
            .compactMap({ $0["summary"] as? String })
        if let error = res.error {
            completionHandler(.failure(error))
        } else {
            completionHandler(.success(issueSummaries ?? []))
        }
    })
}
