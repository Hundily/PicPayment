//
//  SplashViewController.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 12/01/20.
//  Copyright © 2020 PicPayment. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var labelDeveloped: UILabel!
    @IBOutlet weak var holderView: UIView!
    private let kSplashViewController = "SplashViewController"
    
    init() {
        super.init(nibName: kSplashViewController, bundle: Bundle.main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setupAnimation()
    }
    
    private func setupAnimation() {
        UIView.animate(withDuration: 5, animations: {
            self.labelDeveloped.alpha = 1
            self.view.layoutIfNeeded()
        }) { (na) in
            let nav = UINavigationController(rootViewController: ContactsViewController())
            self.navigationController?.present(nav, style: .present(animated: false))
//            self.navigationController?.present(nav, animated: false, completion: nil)
        }
    }
}
