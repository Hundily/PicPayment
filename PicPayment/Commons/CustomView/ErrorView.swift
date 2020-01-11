//
//  ErroView.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 11/09/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//
import UIKit

final class ErrorView: UIView {
    
    private var buttonAction: (() -> Void)
    
    private lazy var imageEmptyState: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.accessibilityIdentifier = "imageEmptyState"
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.accessibilityIdentifier = "labelTitleError"
        label.textColor = .white
        label.textAlignment = .center
        label.font = Font(font: FontFamily.SFUIText.bold, size: 16)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.accessibilityIdentifier = "labelDescriptionError"
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = Font(font: FontFamily.SFUIText.regular, size: 12)
        return label
    }()
    
    private lazy var buttonTryAgain: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 25
        button.accessibilityIdentifier = "buttonErrorTryAgain"
        button.setTitle("TENTAR NOVAMENTE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    init(frame: CGRect, error: WebserviceError, buttonAction: @escaping () -> Void) {
        self.buttonAction = buttonAction
        super.init(frame: frame)
        buttonTryAgain.addTarget(self, action: #selector(actionButton), for: .touchUpInside)
        setupViews()
        setupView(error: error)
    }
    
    @objc private func actionButton() {
        buttonAction()
        self.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(error: WebserviceError) {
        switch error {
        case .notConnectedToInternet:
            imageEmptyState.image = Asset.icWireless.image
            titleLabel.text = L10n.errorInternetTitle
            descriptionLabel.text = L10n.errorInternetDescription
            accessibilityIdentifier = "notConnectedToInternetErrorView"
        case let .empty(emptyState):
            titleLabel.text = emptyState.title
            descriptionLabel.text = emptyState.description
            imageEmptyState.image = emptyState.imageName
            imageEmptyState.tintColor = .gray
            buttonTryAgain.isHidden = true
            accessibilityIdentifier = "emptyErrorView"
        default:
            titleLabel.text = L10n.errorUnexpectedTitle
            descriptionLabel.text = L10n.errorUnexpectedDescription
            imageEmptyState.image = Asset.icErrorUnexpected.image
            accessibilityIdentifier = "unexpectedErrorView"
        }
    }
}

extension ErrorView: CodeViewProtocol {
    func buildViewHierarchy() {
        self.addSubview(imageEmptyState)
        self.addSubview(titleLabel)
        self.addSubview(descriptionLabel)
        self.addSubview(buttonTryAgain)
    }
    
    func setupConstraints() {
        imageEmptyState.anchor(top: topAnchor, insets: .init(top: 20.5, left: 0, bottom: 0, right: 0))
        imageEmptyState.anchorCenterXToSuperview()
        
        titleLabel.anchor(top: imageEmptyState.bottomAnchor,
                          leading: leadingAnchor,
                          trailing: trailingAnchor,
                          insets: .init(top: 20, left: 20, bottom: 0, right: 20))
        
        descriptionLabel.anchor(top: titleLabel.bottomAnchor,
                                leading: leadingAnchor,
                                trailing: trailingAnchor,
                                insets: .init(top: 15, left: 22, bottom: 0, right: 22))
        
        buttonTryAgain.anchor(top: descriptionLabel.bottomAnchor,
                              leading: leadingAnchor,
                              trailing: trailingAnchor,
                              insets: .init(top: 24, left: 80, bottom: 0, right: 80))
        let bottomConstraint = buttonTryAgain.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -15)
        bottomConstraint.isActive = true
        buttonTryAgain.anchor(height: 56)
    }
    
}

