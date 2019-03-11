//
//  History.swift
//  TimeLine
//
//  Created by 류성두 on 11/03/2019.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import Foundation

public struct History: Codable {
    public var title: String
    public var content: String
    public var time: Date
    public init(title: String, content: String, time: Date) {
        self.title = title
        self.content = content
        self.time = time
    }
}
