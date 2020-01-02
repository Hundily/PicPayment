//
//  HomePaymentViewController.swift
//  PicPayment
//
//  Created by Hundily Cerqueira Silva on 26/12/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class HomePaymentViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var imageContact: UIImageView!
    @IBOutlet weak var labelNickName: UILabel!
    @IBOutlet weak var inputValue: SkyFloatingLabelTextField!
    @IBOutlet weak var creditCardInfos: UILabel!
    private var creditCard: CreditCard?
    private var contact: Contact?
    private let kHomePaymentViewController = "HomePaymentViewController"
    
    init(contact: Contact, creditCard: CreditCard) {
        self.contact = contact
        self.creditCard = creditCard
        super.init(nibName: kHomePaymentViewController, bundle: Bundle.main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = " "
        navigationController?.navigationBar.tintColor = ColorName.green.color
    }
    
    func setupUI() {
        imageContact.layer.cornerRadius = imageContact.frame.size.width / 2
        inputValue.lineHeight = 0
        inputValue.selectedLineHeight = 0
        inputValue.tintColor = .clear
    }
    
    func setData() {
        imageContact.imageFromURL(urlString: self.contact?.img ?? "")
        labelNickName.text = self.contact?.username
        let last4 = String(self.creditCard?.cardNumber.suffix(4) ?? "")
        creditCardInfos.text = "MasterCard \(last4) •"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func actionEditCreditCard(_ sender: Any) {
        guard let contact = self.contact else { return }
        let vc = FormCreditCardViewController(contact: contact, isEdit: true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionPayment(_ sender: Any) {
        print("actionPayment")
    }
}
