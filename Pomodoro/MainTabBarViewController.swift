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
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}
