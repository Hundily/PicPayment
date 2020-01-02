//
//  Presentable+UIKit.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 11/09/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import class UIKit.UIViewController
import class UIKit.UIWindow

extension UIViewController: Presentable {
    func toPresent() -> ControllerProtocol {
        return self
    }
}

extension UIWindow: Presentable {
    func toPresent() -> ControllerProtocol {
        return rootViewController!
    }
}
