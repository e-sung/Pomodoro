//
//  Credentials.swift
//  PomodoroFoundation
//
//  Created by 류성두 on 2019/10/16.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import Foundation

public struct Credentials: Encodable {
    public var username: String
    public var password: String
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
