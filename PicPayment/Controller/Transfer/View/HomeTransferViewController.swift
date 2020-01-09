//
//  HomePaymentViewController.swift
//  PicPayment
//
//  Created by Hundily Cerqueira Silva on 26/12/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class HomeTransferViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var imageContact: UIImageView!
    @IBOutlet weak var labelNickName: UILabel!
    @IBOutlet weak var labelErrorPayment: UILabel!
    @IBOutlet weak var inputValue: SkyFloatingLabelTextField!
    @IBOutlet weak var creditCardInfos: UILabel!
    @IBOutlet weak var buttonPayment: CustomButton!
    private var creditCard: CreditCard?
    private var contact: Contact?
    private let kHomeTransferViewController = "HomeTransferViewController"
    
    private lazy var presenter: HomeTransferPresenter = {
        let presenter = HomeTransferPresenter(viewProtocol: self, serviceAPI: TransferService())
        return presenter
    }()
    
    init(contact: Contact, creditCard: CreditCard) {
        presenter.contact = contact
        self.contact = contact
        self.creditCard = creditCard
        super.init(nibName: kHomeTransferViewController, bundle: Bundle.main)
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
        labelErrorPayment.isHidden = true
        imageContact.layer.cornerRadius = imageContact.frame.size.width / 2
        inputValue.lineHeight = 0
        inputValue.selectedLineHeight = 0
        inputValue.tintColor = .clear
        inputValue.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
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
        let vc = RegisterCreditCardFormViewController(contact: contact, state: .edit)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionPayment(_ sender: Any) {
        let cardFormat = creditCard?.cardNumber.replacingOccurrences(of: " ", with: "", options: .literal, range: nil) ?? ""
        let valueTransaction = inputValue.text?.replacingOccurrences(of: "$", with: "", options: .literal, range: nil) ?? ""
        
        let paymentModel = Transfer(card_number: cardFormat, cvv: Int(creditCard?.cardCvv ?? "") ?? 0, value: Double(valueTransaction) ?? 0.0, expiry_date: creditCard?.cardExpired ?? "", destination_user_id: contact?.id ?? 0)
        
        print("paymentModel", paymentModel)
        
        presenter.fetchPayment(payment: paymentModel)
    }
    
    @objc func myTextFieldDidChange(_ textField: UITextField) {
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
}

extension HomeTransferViewController: HomeTransferProtocol {
    func show() {
//        buttonPayment.layoutButton(.enabled)
        //
    }
    
    func showLoading() {
        buttonPayment.layoutButton(.loading)
    }
    
    func dismissLoading() {
        buttonPayment.layoutButton(.enabled)
    }
    
    func show(error: Error) {
        labelErrorPayment.isHidden = false
        labelErrorPayment.text = error.localizedDescription
    }
}
