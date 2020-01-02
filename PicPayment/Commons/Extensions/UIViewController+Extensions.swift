//
//  UIViewController+Extensions.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 11/09/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import UIKit

public enum NavigationBarStyle {
    case `default`
    case colored(barColor: UIColor)
}

extension UIViewController {
    
    public func setupNavigationBar(with style: NavigationBarStyle,
                                   prefersLargeTitles: Bool = true) {
        
        guard let navigationController = navigationController else {
            return
        }
        
        switch style {
        case .default:
            navigationController.navigationBar.barTintColor = ColorName.backgroundDefault.color
        case .colored(let barColor):
            navigationController.navigationBar.barTintColor = barColor
        }
        
        navigationController.navigationItem.hidesSearchBarWhenScrolling = false
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.barStyle = .black
        navigationController.navigationBar.tintColor = .white
        
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(font: FontFamily.SFUIText.bold,
                                                                                                      size: 16)!,
                                                                  NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(font: FontFamily.SFUIText.bold,
                                                                                                           size: 34)!,
                                                                       NSAttributedString.Key.foregroundColor: UIColor.white]
        
        navigationController.navigationBar.prefersLargeTitles = prefersLargeTitles
        
        navigationController.navigationBar.layoutIfNeeded()
        navigationItem.backBarButtonItem?.title = ""
    }
}
