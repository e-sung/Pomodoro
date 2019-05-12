//
//  MainTabBarViewController.swift
//  Pomodoro
//
//  Created by 류성두 on 11/05/2019.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBar.items?.first?.accessibilityLabel = NSLocalizedString("main_timer", comment: "")
        tabBar.items?.last?.accessibilityLabel = NSLocalizedString("setting", comment: "")
        tabBar.items?.forEach({ $0.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0) })
    }
}
