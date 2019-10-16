//
//  Result.swift
//  PomodoroFoundation
//
//  Created by 류성두 on 2019/10/16.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import Foundation

extension Result {
    public var hasSucceeded: Bool {
        switch self {
        case .success:
            return true
        default:
            return false
        }
    }

    public var hasFailed: Bool {
        return !hasSucceeded
    }

}
