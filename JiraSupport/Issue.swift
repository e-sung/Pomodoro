//
//  Issue.swift
//  JiraSupport
//
//  Created by 류성두 on 2019/10/16.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import Foundation

public struct Issue {
    public var key: String
    public var sumamry: String
    public init(key: String, sumamry: String) {
        self.key = key
        self.sumamry = sumamry
    }
}
