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
    @IBOutlet weak var inputValue: SkyFloatingLabelTextField!
    @IBOutlet weak var creditCardInfos: UILabel!
    @IBOutlet weak var buttonPayment: CustomButton!
    private var creditCard: CreditCard?
    private var contact: Contact?
    private let kPaymentViewController = "PaymentViewController"

    fileprivate lazy var toolBar: ToolBarButtonKeyboard = {
        let cgRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 100.0)
        let tool = ToolBarButtonKeyboard(frame: cgRect, confirm: {
            self.didPressConfirmButton()
        }, cancel: {
//            self.didPressCancelButton()
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
        inputValue.lineHeight = 0
        inputValue.selectedLineHeight = 0
        inputValue.tintColor = .clear
        inputValue.textAlignment = .center
        inputValue.delegate = self
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .center
        let attributedPlaceholder = NSAttributedString(string: "R$ 0,00", attributes: [NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
        inputValue.attributedPlaceholder = attributedPlaceholder
        inputValue.addTarget(self, action: #selector(moneyTextFieldDidChange), for: .editingChanged)
        self.toolBar.configButton(type: .disable)
        buttonPayment.layoutButton(.disabled)
    }
    
    private func setData() {
        imageContact.imageFromURL(urlString: self.contact?.img ?? "")
        labelNickName.text = self.contact?.username
        let last4 = String(self.creditCard?.cardNumber.suffix(4) ?? "")
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
        if let text = inputValue.text {
            self.toolBar.configButton(type: !text.isEmpty ? .enable : .disable)
            buttonPayment.layoutButton(!text.isEmpty ? .enabled : .disabled)
        }
    }
    
    @IBAction func actionEditCreditCard(_ sender: Any) {
        guard let contact = self.contact else { return }
        let vc = RegisterCreditCardFormViewController(contact: contact, state: .edit)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionPayment(_ sender: Any) {
        let cardFormat = creditCard?.cardNumber.replacingOccurrences(of: " ", with: "", options: .literal, range: nil) ?? ""
//        let valueTransaction = inputValue.text?.replacingOccurrences(of: "R$", with: "", options: .literal, range: nil) ?? ""
        
        let paymentModel = Payment(card_number: cardFormat, cvv: Int(creditCard?.cardCvv ?? "") ?? 0, value: 41.2, expiry_date: creditCard?.cardExpired ?? "", destination_user_id: contact?.id ?? 0)
        
        print("paymentModel", paymentModel)
        
        presenter.fetchPayment(payment: paymentModel)
    }
    
    @objc func moneyTextFieldDidChange(_ textField: UITextField) {
        
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
            self.toolBar.configButton(type: !amountString.isEmpty ? .enable : .disable)
        }
    }
}

extension PaymentViewController: PaymentProtocol {
    func goReceiptView() {
        let controller = ReceiptViewController()
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
        guard let text = textField.text else { return false }
        self.setupTextFieldsAccessoryView()
        //self.interactor?.validInputValue(value: text.getNumberWithFormatValidate())
        return true
    }
}
