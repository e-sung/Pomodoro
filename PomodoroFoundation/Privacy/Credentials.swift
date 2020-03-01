//
//  Credentials.swift
//  PomodoroFoundation
//
//  Created by 류성두 on 2019/10/16.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import Foundation

public struct Credentials: Encodable {
    public var host:String
    public var username: String
    public var password: String
    public init(host:String, username: String, password: String) {
        self.host = host
        self.username = username
        self.password = password
    }
}
