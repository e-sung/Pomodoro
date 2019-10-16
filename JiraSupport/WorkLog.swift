//
//  WorkLog.swift
//  JiraSupport
//
//  Created by 류성두 on 2019/10/16.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import Foundation
import Alamofire

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
                          started: dateFormatter.string(from: startedTime)+".000+0000")
    let url = "https://jira.flit.to:18443/rest/api/2/issue/\(issue)/worklog"
    AF.request(url,
               method: .post,
               parameters: workLog,
               encoder: JSONParameterEncoder.default).response { res in
                print(res)
    }
}
