//
//  ViewController.swift
//  TimeLine
//
//  Created by 류성두 on 11/02/2019.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import UIKit
import PomodoroFoundation
import PomodoroUIKit

class TimelineViewController: UIViewController {
    @IBOutlet var titleTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        titleTextView.text = ""
        
    }


}

