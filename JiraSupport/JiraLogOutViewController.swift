//
//  JiraLogOutViewController.swift
//  JiraSupport
//
//  Created by 류성두 on 2019/10/16.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import UIKit
import PomodoroFoundation

public class JiraLogOutViewController: UIViewController {

    @IBOutlet var imageViewStatus: UIImageView!
    @IBOutlet var labelStatus: UILabel!
    @IBOutlet var buttonLogout: UIButton!
    
    public override func loadView() {
        Bundle(for: type(of: self)).loadNibNamed(className, owner: self, options: nil)
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = try? retreiveSavedCredentials() {
            imageViewStatus.image = UIImage(systemName: "checkmark.circle")
            imageViewStatus.tintColor = .systemGreen
            labelStatus.text = "로그인 되어 있습니다"
        }
        else {
            imageViewStatus.image = UIImage(systemName: "xmark.circle")
            imageViewStatus.tintColor = .systemRed
            labelStatus.text = "로그 아웃 되어 있습니다"
            buttonLogout.isHidden = true
        }

    }

    @IBAction func buttonLogoutClicked() {
        logout()
        navigationController?.popViewController(animated: true)
    }

}
