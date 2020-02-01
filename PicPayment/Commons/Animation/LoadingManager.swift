//
//  LoadingManager.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 11/09/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import UIKit
import Lottie

final class LoadingManager {
    
    // MARK: View
    private let animationView = AnimationView(name: "loading")
    
    func startAnimation(view: UIView) {
        let screen = UIScreen.main.bounds
        animationView.frame = screen
        animationView.accessibilityIdentifier = "loadingView"
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        view.addSubview(animationView)
        animationView.play()
    }
    
    func stopAnimation() {
        animationView.stop()
        animationView.removeFromSuperview()
    }
}
