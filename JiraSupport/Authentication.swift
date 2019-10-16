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

public func loginJira(with credential: Credentials, then completionHandler: @escaping (Swift.Result<Bool, Error>) -> Void) {

    AF.request("https://jira.flit.to:18443/rest/auth/1/session/",
               method: .post,
               parameters: credential,
               encoder: JSONParameterEncoder.default).response { res in
                if let error = res.error {
                    completionHandler(.failure(error))
                }
                else {
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
