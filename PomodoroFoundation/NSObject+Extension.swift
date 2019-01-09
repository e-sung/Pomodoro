//
//  NSObject+Extension.swift
//  Pomodoro
//
//  Created by 류성두 on 23/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import Foundation

extension NSObject {
    public class var className: String {
        return String(describing: self)
    }

    public var className: String {
        return type(of: self).className
    }
}
