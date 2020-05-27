//
//  FullScreenAd.swift
//  Cities
//
//  Created by Владислав Казмирчук on 26.05.2020.
//  Copyright © 2020 Влад Казмирчук. All rights reserved.
//

import Foundation
import GoogleMobileAds

class FullScreenAd: NSObject, GADInterstitialDelegate {
    
    weak var rootVC: UIViewController?
    let adId = "ca-app-pub-3940256099942544/4411468910"
    var interstitial: GADInterstitial?
    
    var showCallback: (()->Void)? = nil
    var closeCallback: (()->Void)? = nil
    
    init(rootViewController: UIViewController) {
        rootVC = rootViewController
        super.init()
        interstitial = createAndLoadInterstitial()
    }
    
    func show(onShow: (()->Void)?, onClose: (()->Void)?) {
        guard let rootVC = rootVC else { return }
        showCallback = onShow
        closeCallback = onClose
        if interstitial?.isReady == true {
            interstitial?.present(fromRootViewController: rootVC)
        } else {
            print("ERROR showing ad")
        }
    }
    
    private func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: adId)
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    
    // MARK: - GADInterstitialDelegate
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
        closeCallback?()
    }
    
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        showCallback?()
    }
}
