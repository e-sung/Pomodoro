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

public func loginJira(with credential: Credentials, then completionHandler: @escaping (Swift.Result<Bool, Error>) -> Void) {
    
    guard let mainDomain = mainJiraDomain else {
        fatalError("Jira Domain isn't configured!")
    }
    guard let url = URL(string: "/rest/auth/1/session/", relativeTo: mainDomain) else {
        fatalError("Wrong Path for Jira Auth Session")
    }

    AF.request(url,
               method: .post,
               parameters: credential,
               encoder: JSONParameterEncoder.default).response { res in
        if let error = res.error {
            completionHandler(.failure(error))
        } else {
            saveToKeychain(credentials: credential)
            completionHandler(.success(true))
        }
    }
}

public func logout() {
    HTTPCookieStorage.shared.cookies?.forEach({ HTTPCookieStorage.shared.deleteCookie($0) })
    if let credentials = try? retreiveSavedCredentials() {
        removeFromKeychain(credentials: credentials)
    }
}
