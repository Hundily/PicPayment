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
        setDelegate()
    }
    
    private func setupLayout() {
        self.navigationController?.navigationBar.backItem?.title = " "
        let card = presenter.getCard()
        
        switch state {
        case .edit:
            labelTitle.text = "Editar Cartão"
            cardNumber.text = card?.cardNumber
            cardCvv.text = card?.cardCvv
            cardName.text = card?.cardName
            cardExpired.text = card?.cardExpired
        default:
            return
        }
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
        guard let textValue = textField.text else { return }
        textField.text = self.modifyCreditCardString(creditCardString: textValue)
    }
    
    func modifyCreditCardString(creditCardString : String) -> String {
        let trimmedString = creditCardString.components(separatedBy: .whitespaces).joined()
        
        let arrOfCharacters = Array(trimmedString)
        var modifiedCreditCardString = ""
        
        if(arrOfCharacters.count > 0) {
            for i in 0...arrOfCharacters.count-1 {
                modifiedCreditCardString.append(arrOfCharacters[i])
                if((i+1) % 4 == 0 && i+1 != arrOfCharacters.count){
                    modifiedCreditCardString.append(" ")
                }
            }
        }
        return modifiedCreditCardString
    }
    
    @objc func expirationDateDidChange() {
        var dateText = cardExpired.text?.replacingOccurrences(of: "/", with: "") ?? ""
        dateText = dateText.replacingOccurrences(of: " ", with: "")
        
        var newText = ""
        for (index, character) in dateText.enumerated() {
            if index == 1 {
                newText = "\(newText)\(character)/"
            } else {
                newText.append(character)
            }
        }
        cardExpired.text = newText
    }
    
    func checkEnabledButton() {
        buttonRegisterCreditCard.layoutButton(.disabled)
        cardCvv.errorMessage = ""
        cardExpired.errorMessage = ""
        cardNumber.errorMessage = ""
        
        guard let inputCardNumber = cardNumber.text, !inputCardNumber.isEmpty else {
            cardNumber.errorMessage = "Número inválido"
            return
        }
        
        guard let inputCvv = cardCvv.text, !inputCvv.isEmpty else {
            cardCvv.errorMessage = "CVV inválido"
            return
        }
        
        guard let inputCardOwnerName = cardName.text, !inputCardOwnerName.isEmpty else { return }
        
        guard let inputMaturityDate = cardExpired.text, !inputMaturityDate.isEmpty else {
            cardExpired.errorMessage = "Validade inválida"
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
        self.navigationController?.popViewController(animated: true)
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
