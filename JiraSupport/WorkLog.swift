//
//  WorkLog.swift
//  JiraSupport
//
//  Created by 류성두 on 2019/10/16.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import Alamofire
import Foundation

public func logWorkTime(seconds: TimeInterval, for issue: String) {
    struct WorkLog: Codable {
        let timeSpentSeconds: Int
        let started: String
    }
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.autoupdatingCurrent
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }

    let startedTime = Date(timeInterval: seconds, since: Date())
    let workLog = WorkLog(timeSpentSeconds: Int(seconds),
                          started: dateFormatter.string(from: startedTime) + ".000+0000")
    guard let mainDomain = mainJiraDomain else {
        fatalError("Main Jira URL hasn't been configured!")
    }
    guard let url = URL(string: "/rest/api/2/issue/\(issue)/worklog", relativeTo: mainDomain ) else {
        fatalError("Wrong Path for WorkLog")
    }
    guard let credentialHeader = credentialHeader else { return }
    AF.request(url,
               method: .post,
               parameters: workLog,
               encoder: JSONParameterEncoder.default,
               headers: HTTPHeaders([credentialHeader])).response { res in
        print(res)
    }
}
