//
//  HomeCreditCardViewController.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 11/09/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import UIKit

final class HomeCreditCardViewController: UIViewController {
    
    // MARK: UI
    private lazy var viewCreditCard: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = ColorName.backgroundDefault.color
        view.accessibilityIdentifier = "viewCreditCard"
        return view
    }()
    
    private lazy var imageCreditCard: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.contentMode = .scaleAspectFit
        image.accessibilityIdentifier = "imageCreditCard"
        image.image = Asset.creditCard.image
        return image
    }()
    
    private lazy var titleCreditCardLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.accessibilityIdentifier = "titleCreditCardLabel"
        label.font = UIFont(font: FontFamily.SFUIText.bold, size: 28)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.text = L10n.titleCreditCard
        return label
    }()
    
    private lazy var descriptionCreditCardLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.accessibilityIdentifier = "descriptionCreditCardLabel"
        label.font = UIFont(font: FontFamily.SFUIText.regular, size: 14)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.text = L10n.descriptionCreditCard
        return label
    }()
    
    private lazy var buttonRegisterCard: CustomButton = {
       let button = CustomButton()
        button.setTitle(L10n.registerCard, for: .normal)
        button.accessibilityIdentifier = "buttonRegisterCard"
        button.addTarget(self, action: #selector(registerCardCredit), for: .touchUpInside)
        button.layoutButton(.enabled)
        return button
    }()
    
    var didRequestToFormCreditCardView: (() -> Void)?
    private var contact: Contact?
    private var kHomeCreditCardViewController = "HomeCreditCardViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        view.backgroundColor = .clear
        setupNavigationBar(with: .colored(barColor: ColorName.backgroundDefault.color),
                           prefersLargeTitles: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = " "
        navigationController?.navigationBar.tintColor = ColorName.green.color
    }
    
    init(contact: Contact?) {
        if let contact = contact {
            self.contact = contact
        }

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func registerCardCredit() {
        print("home registerCardCredit")
        guard let contact = self.contact else { return }
        
        //fix coordinator
        self.didRequestToFormCreditCardView?()
        let vc = FormCreditCardViewController(contact: contact, isEdit: false)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeCreditCardViewController: CodeViewProtocol {
    func buildViewHierarchy() {
        view.addSubview(viewCreditCard)
        viewCreditCard.addSubview(imageCreditCard)
        viewCreditCard.addSubview(titleCreditCardLabel)
        viewCreditCard.addSubview(descriptionCreditCardLabel)
        viewCreditCard.addSubview(buttonRegisterCard)
    }
    
    func setupConstraints() {
        
        viewCreditCard.anchor(top: view.topAnchor,
                              leading: view.leadingAnchor,
                              bottom: view.bottomAnchor,
                              trailing: view.trailingAnchor,
                              insets: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        imageCreditCard.anchor(top: viewCreditCard.topAnchor,
                               leading: viewCreditCard.leadingAnchor,
                               trailing: viewCreditCard.trailingAnchor,
                               insets: .init(top: 128, left: 110, bottom: 0, right: 110))
        imageCreditCard.anchor(height: 70.0)
        
        titleCreditCardLabel.anchor(top: imageCreditCard.bottomAnchor,
                                    leading: viewCreditCard.leadingAnchor,
                                    trailing: viewCreditCard.trailingAnchor, insets: .init(top: 32.0, left: 20.0, bottom: 0, right: 20.0))
        
        descriptionCreditCardLabel.anchor(top: titleCreditCardLabel.bottomAnchor,
                                          leading: viewCreditCard.leadingAnchor,
                                          trailing: viewCreditCard.trailingAnchor,
                                          insets: .init(top: 16.0, left: 36, bottom: 0, right: 36))
        
        buttonRegisterCard.anchor(leading: viewCreditCard.leadingAnchor,
                                  bottom: viewCreditCard.bottomAnchor,
                                  trailing: viewCreditCard.trailingAnchor,
                                  insets: .init(top: 0, left: 12, bottom: 20, right: 12))
        buttonRegisterCard.anchor(height: 48)
        
        
    }
    
}

extension HomeCreditCardViewController: UITextFieldDelegate {
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        previousTextFieldContent = textField.text
//        previousSelection = textField.selectedTextRange
//        return true
//    }

}

