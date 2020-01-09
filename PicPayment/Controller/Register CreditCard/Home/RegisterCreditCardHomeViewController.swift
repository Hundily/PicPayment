//
//  RegisterCreditCardHomeViewController.swift
//  PicPayment
//
//  Created by Hundily Cerqueira Silva on 07/01/20.
//  Copyright © 2020 hundily. All rights reserved.
//

import UIKit

class RegisterCreditCardHomeViewController: UIViewController {
    
    @IBOutlet weak var buttonCloseModal: UIImageView!
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
        self.navigationController?.navigationBar.backItem?.title = " "
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeModal))
        self.buttonCloseModal.addGestureRecognizer(tap)
        buttonCloseModal.isUserInteractionEnabled = true
    }
    
    @objc func closeModal(sender:UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionGoRegisterForm(_ sender: Any) {
        let modalViewController = RegisterCreditCardFormViewController(contact: nil, state: .register)
        navigationController?.pushViewController(modalViewController, animated: true)
    }
}
