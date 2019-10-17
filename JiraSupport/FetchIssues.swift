//
//  FetchIssues.swift
//  JiraSupport
//
//  Created by 류성두 on 2019/10/16.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import Alamofire
import Foundation

func fetchIssues(then completionHandler: @escaping (Result<[Issue], Error>) -> Void) {
    let url = "https://jira.flit.to:18443/rest/api/2/search?jql=assignee%20=%20currentUser()%20AND%20%20status%20=%20%22In%20Progress%22"
    AF.request(url).responseJSON(completionHandler: { res in
        let dict = res.value as? [String: Any]
        let issues = dict?["issues"] as? [[String: Any]]
        let issueSummaries = issues?
            .compactMap({ dict -> Issue? in
                guard let field = dict["fields"] as? [String: Any] else { return nil }
                guard let key = dict["key"] as? String else { return nil }
                guard let summary = field["summary"] as? String else { return nil }
                return Issue(key: key, sumamry: summary)
            })
        if let error = res.error {
            completionHandler(.failure(error))
        } else {
            completionHandler(.success(issueSummaries ?? []))
        }
    })
}
