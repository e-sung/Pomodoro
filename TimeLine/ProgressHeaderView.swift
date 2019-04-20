//
//  ProgressHeaderView.swift
//  TimeLine
//
//  Created by 류성두 on 20/04/2019.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import UIKit

class ProgressHeaderView: UITableViewHeaderFooterView {
    @IBOutlet private var progressView: UIProgressView!
    var progress: Float {
        get {
            return progressView.progress
        }
        set {
            progressView.progress = newValue
        }
    }
}
