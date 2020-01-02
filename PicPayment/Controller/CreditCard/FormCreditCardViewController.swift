//
//  FormCreditCardViewController
//  PicPayment
//
//  Created by Hundily Cerqueira on 11/09/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SnapKit

final class FormCreditCardViewController: UIViewController {
    
    // MARK: UI
    private lazy var viewFormCreditCard: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = ColorName.backgroundDefault.color
        view.accessibilityIdentifier = "viewFormCreditCard"
        return view
    }()
    
    private lazy var titleCreditCardLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.accessibilityIdentifier = "titleCreditCardLabel"
        label.font = UIFont(font: FontFamily.SFUIText.bold, size: 28)
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 0
        label.text = "Cadastrar Cartão"
        return label
    }()
    
    private lazy var inputCardNumber: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField(frame: .zero)
        input.placeholder = "Número do cartão"
        input.lineColor = UIColor.lightGray
        input.selectedLineColor = ColorName.green.color
        input.selectedTitleColor = ColorName.green.color
        input.keyboardType = UIKeyboardType.decimalPad
        input.textColor = UIColor.white
        input.errorColor = UIColor.red
        input.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)
        return input
    }()
    
    private lazy var inputCardOwnerName: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField(frame: .zero)
        input.placeholder = "Nome do titular"
        input.selectedLineColor = ColorName.green.color
        input.selectedTitleColor = ColorName.green.color
        input.lineColor = UIColor.lightGray
        input.textColor = UIColor.white
        input.errorColor = UIColor.red
        return input
    }()
    
    private lazy var inputMaturityDate: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField(frame: .zero)
        input.placeholder = "Vencimento"
        input.selectedLineColor = ColorName.green.color
        input.selectedTitleColor = ColorName.green.color
        input.keyboardType = UIKeyboardType.decimalPad
        input.lineColor = UIColor.lightGray
        input.textColor = UIColor.white
        input.errorColor = UIColor.red
        input.addTarget(self, action: #selector(expirationDateDidChange), for: .editingChanged)
        return input
    }()
    
    private lazy var inputCvv: SkyFloatingLabelTextField = {
        let input = SkyFloatingLabelTextField(frame: .zero)
        input.placeholder = "CVV"
        input.selectedLineColor = ColorName.green.color
        input.selectedTitleColor = ColorName.green.color
        input.keyboardType = UIKeyboardType.decimalPad
        input.lineColor = UIColor.lightGray
        input.textColor = UIColor.white
        input.errorColor = UIColor.red
        return input
    }()
    
    private lazy var buttonRegisterCard: CustomButton = {
        let button = CustomButton()
        button.setTitle(L10n.saveCreditCard, for: .normal)
        button.accessibilityIdentifier = "buttonRegisterCard"
        button.addTarget(self, action: #selector(registerCardCredit), for: .touchUpInside)
        button.layoutButton(.disabled)
        return button
    }()
    
    var didRequestToNextView: (() -> Void)?
    private var contact: Contact?
    private var isEdit: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupDelegates()
        setupEditData()
        view.backgroundColor = .clear
        UITextField.appearance().keyboardAppearance = .dark
        setupNavigationBar(with: .colored(barColor: ColorName.backgroundDefault.color),
                           prefersLargeTitles: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.topItem?.title = " "
        navigationController?.navigationBar.tintColor = ColorName.green.color
    }
    
    init(contact: Contact, isEdit: Bool) {
        self.contact = contact
        self.isEdit = isEdit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func registerCardCredit() {
        let creditCard = CreditCard(cardNumber: inputCardNumber.text ?? "", cardName: inputCardOwnerName.text ?? "", cardExpired: inputMaturityDate.text ?? "", cardCvv: inputCvv.text ?? "")
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(creditCard) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "CREDIT_CARD")
        }
        
        if let contact = self.contact {
            let payment = HomePaymentViewController(contact: contact, creditCard: creditCard)
            navigationController?.pushViewController(payment, animated: true)
        }
        
        
//        let homePaymentViewController = HomePaymentViewController(contact: contact, creditCard: creditCardParse)
//        self?.router.push(homePaymentViewController, animated: true)
        
//        if let teste = UserDefaults.standard.object(forKey: "CREDIT_CARD") as? Data {
//            let decoder = JSONDecoder()
//            if let loadedPerson = try? decoder.decode(CreditCard.self, from: teste) {
//                print("loadedPerson", loadedPerson)
//            }
//        }
        
        
    }
    
    func setupDelegates() {
        inputCardNumber.delegate = self
        inputCvv.delegate = self
        inputMaturityDate.delegate = self
    }
    
    func setupEditData() {
        if isEdit {
            if let cardPase = UserDefaults.standard.object(forKey: "CREDIT_CARD") as? Data {
                let decoder = JSONDecoder()
                if let card = try? decoder.decode(CreditCard.self, from: cardPase) {
                    inputCardNumber.text = card.cardNumber
                    inputCvv.text = card.cardCvv
                    inputMaturityDate.text = card.cardExpired
                    inputCardOwnerName.text = card.cardName
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        checkEnabledButton()
    }
    
    @objc func didChangeText(textField: UITextField) {
        guard let textValue = textField.text else { return }
        textField.text = self.modifyCreditCardString(creditCardString: textValue)
    }
    
    @objc func expirationDateDidChange() {
        var dateText = inputMaturityDate.text?.replacingOccurrences(of: "/", with: "") ?? ""
        dateText = dateText.replacingOccurrences(of: " ", with: "")
        
        var newText = ""
        for (index, character) in dateText.enumerated() {
            if index == 1 {
                newText = "\(newText)\(character)/"
            } else {
                newText.append(character)
            }
        }
        inputMaturityDate.text = newText
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
    
    func checkEnabledButton() {
        buttonRegisterCard.layoutButton(.disabled)
        guard let inputCardNumber = inputCardNumber.text, !inputCardNumber.isEmpty else { return }
        guard let inputCvv = inputCvv.text, !inputCvv.isEmpty else { return }
        guard let inputCardOwnerName = inputCardOwnerName.text, !inputCardOwnerName.isEmpty else { return }
        guard let inputMaturityDate = inputMaturityDate.text, !inputMaturityDate.isEmpty else { return }
        buttonRegisterCard.layoutButton(.enabled)
    }
}

// MARK: ViewCode
extension FormCreditCardViewController: CodeViewProtocol {
    func buildViewHierarchy() {
        view.addSubview(viewFormCreditCard)
        viewFormCreditCard.addSubview(titleCreditCardLabel)
        viewFormCreditCard.addSubview(inputCardNumber)
        viewFormCreditCard.addSubview(inputCardOwnerName)
        viewFormCreditCard.addSubview(inputMaturityDate)
        viewFormCreditCard.addSubview(inputCvv)
        viewFormCreditCard.addSubview(buttonRegisterCard)
    }
    
    func setupConstraints() {
        
        viewFormCreditCard.anchor(top: view.topAnchor,
                                  leading: view.leadingAnchor,
                                  bottom: view.bottomAnchor,
                                  trailing: view.trailingAnchor,
                                  insets: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        titleCreditCardLabel.anchor(top: viewFormCreditCard.topAnchor,
                                    leading: viewFormCreditCard.leadingAnchor,
                                    trailing: viewFormCreditCard.trailingAnchor,
                                    insets: .init(top: 20.0, left: 20.0, bottom: 0, right: 20.0))
        
        inputCardNumber.anchor(top: titleCreditCardLabel.bottomAnchor,
                               leading: viewFormCreditCard.leadingAnchor,
                               trailing: viewFormCreditCard.trailingAnchor,
                               insets: .init(top: 20.0, left: 20.0, bottom: 0, right: 20.0))
        
        inputCardOwnerName.anchor(top: inputCardNumber.bottomAnchor,
                                  leading: inputCardNumber.leadingAnchor,
                                  trailing: inputCardNumber.trailingAnchor,
                                  insets: .init(top: 64, left: 0, bottom: 0, right: 0))
        
        inputMaturityDate.anchor(top: inputCardOwnerName.bottomAnchor,
                                 leading: inputCardOwnerName.leadingAnchor,
                                 insets: .init(top: 64, left: 0, bottom: 0, right: 0))
        inputMaturityDate.anchor(width: 130)
        
        inputCvv.anchor(top: inputCardOwnerName.bottomAnchor,
                        trailing: inputCardOwnerName.trailingAnchor,
                        insets: .init(top: 64, left: 0, bottom: 0, right: 0))
        inputCvv.anchor(width: 130)
        
        buttonRegisterCard.anchor(leading: viewFormCreditCard.leadingAnchor,
                                  bottom: viewFormCreditCard.bottomAnchor,
                                  trailing: viewFormCreditCard.trailingAnchor,
                                  insets: .init(top: 0, left: 12, bottom: 20, right: 12))
        buttonRegisterCard.anchor(height: 48)
    }
}

extension FormCreditCardViewController: UITextFieldDelegate {
    
    @objc func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text ?? "").count + string.count - range.length
        
        if(textField == inputCardNumber) {
            return newLength <= 19
        }
        
        if(textField == inputCvv) {
            return newLength <= 3
        }
        
        if(textField == inputMaturityDate) {
            return newLength <= 5
        }
        
        return true
    }
}
