//
//  RegisterCreditCardHomeViewController.swift
//  PicPayment
//
//  Created by Hundily Cerqueira Silva on 07/01/20.
//  Copyright © 2020 hundily. All rights reserved.
//

import UIKit

class RegisterCreditCardHomeViewController: UIViewController {
    
    private var contact: Contact?
    
    init(contact: Contact?) {
        if let contact = contact {
            self.contact = contact
        }

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = " "
        navigationController?.navigationBar.tintColor = ColorName.green.color
    }
    
    @IBAction func actionGoRegisterForm(_ sender: Any) {
        let modalViewController = RegisterCreditCardFormViewController(contact: nil, state: .register)
        navigationController?.pushViewController(modalViewController, animated: true)
    }
}
