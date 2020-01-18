//
//  RegisterCreditCardFormViewController.swift
//  PicPayment
//
//  Created by Hundily Cerqueira Silva on 07/01/20.
//  Copyright © 2020 hundily. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

enum RegisterCreditCardState {
    case edit
    case register
}

class RegisterCreditCardFormViewController: UIViewController {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var cardNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var cardName: SkyFloatingLabelTextField!
    @IBOutlet weak var cardExpired: SkyFloatingLabelTextField!
    @IBOutlet weak var cardCvv: SkyFloatingLabelTextField!
    @IBOutlet weak var buttonRegisterCreditCard: CustomButton!
    private let kRegisterCreditCardFormViewController = "RegisterCreditCardFormViewController"
    private var state = RegisterCreditCardState.register
    
    private lazy var presenter: RegisterCreditCardFormPresenter = {
        let presenter = RegisterCreditCardFormPresenter(viewProtocol: self)
        return presenter
    }()
    
    init(contact: Contact?, state: RegisterCreditCardState) {
        super.init(nibName: kRegisterCreditCardFormViewController, bundle: Bundle.main)
        self.state = state
        
        if let contact = contact {
            presenter.setContact(contact: contact)
            presenter.creditCardData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupNavigationLayout()
        setDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupLayout() {
        buttonRegisterCreditCard.layoutButton(.disabled)
        let card = presenter.getCard()
        
        switch state {
        case .edit:
            labelTitle.text = L10n.editCard
            cardNumber.text = card?.cardNumber
            cardCvv.text = card?.cardCvv
            cardName.text = card?.cardName
            cardExpired.text = card?.cardExpired
        default:
            return
        }
    }
    
    private func setupNavigationLayout() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.topItem?.title = " "
        navigationController?.navigationBar.tintColor = ColorName.green.color
        navigationController?.navigationBar.barTintColor = ColorName.backgroundDefault.color
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        checkEnabledButton()
    }
    
    private func setDelegate() {
        cardNumber.delegate = self
        cardCvv.delegate = self
        cardExpired.delegate = self
        cardNumber.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
        cardExpired.addTarget(self, action: #selector(expirationDateDidChange), for: .editingChanged)
    }
    
    @objc func didChangeText(textField: UITextField) {
        textField.text = String().formatterCreditCard(str: textField.text ?? "")
    }
    
    @objc func expirationDateDidChange() {
        cardExpired.text = String().formatterExpirationDate(str: cardExpired.text ?? "")
    }
    
    func checkEnabledButton() {
        buttonRegisterCreditCard.layoutButton(.disabled)
        cardCvv.errorMessage = ""
        cardExpired.errorMessage = ""
        cardNumber.errorMessage = ""
        
        guard let inputCardNumber = cardNumber.text, !inputCardNumber.isEmpty else {
            cardNumber.errorMessage = L10n.invalidNumber
            return
        }
        
        guard let inputCvv = cardCvv.text, !inputCvv.isEmpty else {
            cardCvv.errorMessage = L10n.invalidCvv
            return
        }
        
        guard let inputCardOwnerName = cardName.text, !inputCardOwnerName.isEmpty else { return }
        
        guard let inputMaturityDate = cardExpired.text, !inputMaturityDate.isEmpty else {
            cardExpired.errorMessage = L10n.invalidExpired
            return
        }
        
        buttonRegisterCreditCard.layoutButton(.enabled)
    }
    
    @IBAction func actionRegisterCreditCard(_ sender: Any) {
        let creditCard = CreditCard(cardNumber: cardNumber.text ?? "", cardName: cardName.text ?? "", cardExpired: cardExpired.text ?? "", cardCvv: cardCvv.text ?? "")
        presenter.registerCreditCard(creditCard: creditCard)
    }
}

extension RegisterCreditCardFormViewController: RegisterCreditCardFormProtocol {
    func registerCardSuccess() {
        switch state {
        case .register:
            dismiss(animated: true)
        case .edit:
            navigationController?.popViewController(animated: true)
        }
    }
    
    func registerCardError() {
        //
    }
}

extension RegisterCreditCardFormViewController: UITextFieldDelegate {
    
    @objc func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text ?? "").count + string.count - range.length
        
        if(textField == cardNumber) {
            return newLength <= 19
        }
        
        if(textField == cardCvv) {
            return newLength <= 3
        }
        
        if(textField == cardExpired) {
            return newLength <= 5
        }
        
        return true
    }
}
