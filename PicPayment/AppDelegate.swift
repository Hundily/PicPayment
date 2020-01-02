//
//  AppDelegate.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 11/09/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import UIKit
import IQKeyboardManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var applicationCoordinator: ApplicationCoordinator?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
   
    IQKeyboardManager.shared().isEnabled = true

    self.window = UIWindow(frame: UIScreen.main.bounds)
    
    let router = Router(rootController: self.window!)
    applicationCoordinator = ApplicationCoordinator(router: router)
    applicationCoordinator?.start()

    self.window?.makeKeyAndVisible()
    
    return true
  }

}

