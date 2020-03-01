//
//  Login.swift
//  JiraSupport
//
//  Created by 류성두 on 2019/10/16.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import Alamofire
import Foundation
import PomodoroFoundation

public var mainJiraDomain: URL? {
    get {
        UserDefaults.standard.url(forKey: "JiraHostURL")
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "JiraHostURL")
    }
}

public var mainJQL: String {
    get {
        UserDefaults.standard.string(forKey: "JQL") ?? defaultJQL
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "JQL")
    }
}

//public var defaultJQL:String {
//    return """
//    assignee = currentUser() AND status in ("진행중", "개발 중", "In Progress")
//    """
//}

public var defaultJQL:String {
    return """
    assignee = currentUser()
    """
}

public func logout() {
    HTTPCookieStorage.shared.cookies?.forEach { HTTPCookieStorage.shared.deleteCookie($0) }
    guard let mainJiraDomain = mainJiraDomain?.absoluteString else { return }
    if let credentials = try? retreiveSavedCredentials(for: mainJiraDomain) {
        removeFromKeychain(credentials: credentials, for: mainJiraDomain)
    }
}
