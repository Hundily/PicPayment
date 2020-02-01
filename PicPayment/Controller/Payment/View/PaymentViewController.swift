//
//  HomePaymentViewController.swift
//  PicPayment
//
//  Created by Hundily Cerqueira Silva on 26/12/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import FittedSheets

class PaymentViewController: UIViewController {
    
    @IBOutlet weak var imageContact: UIImageView!
    @IBOutlet weak var labelNickName: UILabel!
    @IBOutlet weak var labelErrorPayment: UILabel!
    @IBOutlet weak var inputValue: UITextField!
    @IBOutlet weak var moneySymbol: UILabel!
    @IBOutlet weak var creditCardInfos: UILabel!
    @IBOutlet weak var buttonPayment: CustomButton!
    private var creditCard: CreditCard?
    private var creditCardLastFourNumber: String = ""
    private var contact: Contact?
    private let kPaymentViewController = "PaymentViewController"
    
    fileprivate lazy var toolBar: ToolBarButtonKeyboard = {
        let cgRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 100.0)
        let tool = ToolBarButtonKeyboard(frame: cgRect, confirm: {
            self.didPressConfirmButton()
        }, cancel: {
            //self.didPressCancelButton()
        })
        return tool
    }()
    
    private lazy var presenter: PaymentPresenter = {
        let presenter = PaymentPresenter(viewProtocol: self, serviceAPI: PaymentService())
        return presenter
    }()
    
    init(contact: Contact, creditCard: CreditCard) {
        self.contact = contact
        self.creditCard = creditCard
        super.init(nibName: kPaymentViewController, bundle: Bundle.main)
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
    
    private func setupUI() {
        labelErrorPayment.isHidden = true
        imageContact.layer.cornerRadius = imageContact.frame.size.width / 2
        inputValue.textColor = .gray
        inputValue.tintColor = .clear
        inputValue.delegate = self
        inputValue.addTarget(self, action: #selector(moneyTextFieldDidChange), for: .editingChanged)
        self.toolBar.configButton(type: .disable)
        self.buttonPayment.layoutButton(.disabled)
    }
    
    private func setData() {
        imageContact.imageFromURL(urlString: self.contact?.img ?? "")
        labelNickName.text = self.contact?.username
        let last4 = String(self.creditCard?.cardNumber.suffix(4) ?? "")
        creditCardLastFourNumber = last4
        creditCardInfos.text = "MasterCard \(last4)"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        handleTextIsEmpty()
    }
    
    fileprivate func setupTextFieldsAccessoryView() {
        inputValue.inputAccessoryView = toolBar
    }
    
    fileprivate func didPressConfirmButton() {
        guard let inputText = inputValue.text else {  return }
        
        inputValue.resignFirstResponder()
        if !inputText.isEmpty {
            self.actionPayment(String())
        }
    }
    
    private func handleTextIsEmpty() {
        if let value = inputValue.text {
            let doubleAmount = value.trimmingCharacters(in: .whitespaces).currencyToDouble()
            if doubleAmount == 0 {
                self.toolBar.configButton(type: .disable)
                self.buttonPayment.layoutButton(.disabled)
            } else {
                self.toolBar.configButton(type: .enable)
                self.buttonPayment.layoutButton(.enabled)
            }
        }
    }
    
    @IBAction func actionEditCreditCard(_ sender: Any) {
        guard let contact = self.contact else { return }
        let vc = RegisterCreditCardFormViewController(contact: contact, state: .edit)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionPayment(_ sender: Any) {
        guard let value = inputValue.text else  { return }
        
        if let card = creditCard?.cardNumber, let expiryDate = creditCard?.cardExpired, let cvv = creditCard?.cardCvv, let userId = contact?.id {
            let cardNumberCast = card.trimmingCharacters(in: .whitespaces)
            let doubleAmount = value.trimmingCharacters(in: .whitespaces).currencyToDouble()
            if let cvvCast = Int(cvv) {
                let paymentModel = Payment(card_number: cardNumberCast, cvv: cvvCast, value: doubleAmount, expiry_date: expiryDate, destination_user_id: userId)
                
                presenter.fetchPayment(payment: paymentModel)
            }
        }
    }
    
    @objc func moneyTextFieldDidChange(_ textField: UITextField) {
        if let amountString = inputValue.text?.currencyFormatting() {
            if amountString.isEmpty {
                textField.text = "0,00"
                textField.textColor = .gray
                moneySymbol.textColor = .gray
                self.toolBar.configButton(type: .disable)
            } else {
                textField.text = amountString
                textField.textColor = ColorName.green.color
                moneySymbol.textColor = ColorName.green.color
                self.toolBar.configButton(type: .enable)
            }
        }
    }
}

extension PaymentViewController: PaymentProtocol {
    
    func showReceiptView(receipt: PaymentReceipt?)  {
        guard let receipt = receipt else { return }
        let controller = ReceiptViewController(receipt: receipt)
        let sheetController = SheetViewController(controller: controller, sizes: [.fixed(600), .fullScreen])
        sheetController.topCornersRadius = 15
        self.present(sheetController, animated: false, completion: nil)
    }
    
    func show() {
        //buttonPayment.layoutButton(.enabled)
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

extension PaymentViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard textField.text != nil else { return false }
        self.setupTextFieldsAccessoryView()
        //self.interactor?.validInputValue(value: text.getNumberWithFormatValidate())
        return true
    }
}
