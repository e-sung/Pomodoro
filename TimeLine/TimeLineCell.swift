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
    var heightArrowConstantFromIB: CGFloat!
    
    var isLastItem = false {
        didSet {
            if isLastItem {
                heightOfArrow.constant = CGFloat.leastNonzeroMagnitude
            }
            else {
                heightOfArrow.constant = heightArrowConstantFromIB
            }
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        heightArrowConstantFromIB = heightOfArrow.constant
        selectionStyle = .none
    }

}
