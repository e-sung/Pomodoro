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

public func logout() {
    HTTPCookieStorage.shared.cookies?.forEach { HTTPCookieStorage.shared.deleteCookie($0) }
    if let credentials = try? retreiveSavedCredentials() {
        removeFromKeychain(credentials: credentials)
    }
}
