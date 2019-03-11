//
//  TimeLineCell.swift
//  TimeLine
//
//  Created by 류성두 on 11/03/2019.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import UIKit

open class TimeLineCell: UITableViewCell {

    @IBOutlet private var labelTitle: UILabel!
    @IBOutlet private var labelContent: UILabel!
    @IBOutlet private var labelTime: UILabel!
    @IBOutlet var heightOfArrow: NSLayoutConstraint!
    
    var isLastItem = false {
        didSet {
            setNeedsLayout()
        }
    }
    
//    var history: History? {
//        didSet {
//            setNeedsLayout()
//        }
//    }
//    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if isLastItem {
            heightOfArrow.constant = CGFloat.leastNonzeroMagnitude
        }
        else {
            heightOfArrow.constant = 40
        }
//        guard let history = history  else { return }
//        labelTitle.text = history.title
//        labelContent.text = history.content
//        labelTime.text = DateFormatter.localizedString(from: history.time,
//                                                       dateStyle: .none,
//                                                       timeStyle: .short)
    }
//

}
