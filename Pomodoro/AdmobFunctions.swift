//
//  AdmobFunctions.swift
//  Pomodoro
//
//  Created by 류성두 on 14/05/2019.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import Foundation
import GoogleMobileAds
import UIKit

func makeBannerView() -> GADBannerView {
    let bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
    bannerView.adUnitID = infoForKey("AD_UNIT_ID")
    return bannerView
}

extension UIViewController {
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        positionBannerViewFullWidthAtBottomOfSafeArea(bannerView)
    }

    func positionBannerViewFullWidthAtBottomOfSafeArea(_ bannerView: UIView) {
        // Position the banner. Stick it to the bottom of the Safe Area.
        // Make it constrained to the edges of the safe area.
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            guide.leftAnchor.constraint(equalTo: bannerView.leftAnchor),
            guide.rightAnchor.constraint(equalTo: bannerView.rightAnchor),
            guide.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor),
        ])
    }
}
