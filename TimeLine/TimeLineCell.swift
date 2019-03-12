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
    @IBOutlet private var labels:[UILabel]!
    @IBOutlet var heightOfArrow: NSLayoutConstraint!
    var heightArrowConstantFromIB: CGFloat!
    
    var isLastItem = false
    
    open func update(with history: History, isLast: Bool) {
        update(isLastItem: isLast)
        update(with: history)
    }
    
    func update(isLastItem: Bool) {
        if isLastItem {
            heightOfArrow.constant = CGFloat.leastNonzeroMagnitude
        }
        else {
            heightOfArrow.constant = heightArrowConstantFromIB
        }
    }
    
    func update(with history: History) {
        isHidden = false
        labelTitle.text = history.title
        labelContent.text = history.content
        labelTime.text = history.durationStr
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        heightArrowConstantFromIB = heightOfArrow.constant
        selectionStyle = .none
        labels.forEach({ $0.text = "" })
        isHidden = true
    }

}
