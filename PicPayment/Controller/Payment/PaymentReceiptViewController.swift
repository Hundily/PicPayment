//
//  PaymentReceiptViewController.swift
//  PicPayment
//
//  Created by Hundily Cerqueira Silva on 11/09/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import UIKit
import SnapKit

final class PaymentReceiptViewController: UIViewController {
    
    // MARK: UI
    private lazy var viewPaymentReceipt: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = ColorName.backgroundDefault.color
        view.accessibilityIdentifier = "viewPaymentReceipt"
        return view
    }()
    
    private lazy var imageContact: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.contentMode = .scaleAspectFit
        image.accessibilityIdentifier = "imageContact"
        image.image = Asset.imageProfile.image
        return image
    }()
    
    private lazy var pageTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.accessibilityIdentifier = "pageTitle"
        label.font = UIFont(font: FontFamily.SFUIText.bold, size: 17)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.text = L10n.paymentReceipt
        return label
    }()
    
    private lazy var titleNickName: UILabel = {
        let label = UILabel(frame: .zero)
        label.accessibilityIdentifier = "titleNickName"
        label.font = UIFont(font: FontFamily.SFUIText.bold, size: 20)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.text = "@hundily"
        return label
    }()
    
    private lazy var transactionDateAndTime: UILabel = {
        let label = UILabel(frame: .zero)
        label.accessibilityIdentifier = "transactionDateAndTime"
        label.font = UIFont(font: FontFamily.SFUIText.bold, size: 14)
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.text = "15/09/2019 12h20"
        return label
    }()
    
    private lazy var transactionID: UILabel = {
        let label = UILabel(frame: .zero)
        label.accessibilityIdentifier = "transactionID"
        label.font = UIFont(font: FontFamily.SFUIText.regular, size: 12)
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.text = "Transação: 123456"
        return label
    }()
    
    private lazy var viewLineTop: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    private lazy var viewLineBottom: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    private lazy var finalCard: UILabel = {
        let label = UILabel(frame: .zero)
        label.accessibilityIdentifier = "finalCard"
        label.font = UIFont(font: FontFamily.SFUIText.regular, size: 12)
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 0
        label.text = "Cartão Master 1234"
        return label
    }()
    
    private lazy var valueTransaction: UILabel = {
        let label = UILabel(frame: .zero)
        label.accessibilityIdentifier = "valueTransaction"
        label.font = UIFont(font: FontFamily.SFUIText.bold, size: 13)
        label.textAlignment = .right
        label.textColor = .white
        label.numberOfLines = 0
        label.text = "R$ 123.00"
        return label
    }()
    
    private lazy var totalPaid: UILabel = {
        let label = UILabel(frame: .zero)
        label.accessibilityIdentifier = "totalPaid"
        label.font = UIFont(font: FontFamily.SFUIText.bold, size: 17)
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 0
        label.text = L10n.totalPaid
        return label
    }()
    
    private lazy var valuePaid: UILabel = {
        let label = UILabel(frame: .zero)
        label.accessibilityIdentifier = "valuePaid"
        label.font = UIFont(font: FontFamily.SFUIText.bold, size: 17)
        label.textAlignment = .right
        label.textColor = .white
        label.numberOfLines = 0
        label.text = "R$ 123,00"
        return label
    }()
    
    var didRequestToNextView: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        view.backgroundColor = .clear
        setupNavigationBar(with: .colored(barColor: ColorName.backgroundDefault.color),
                           prefersLargeTitles: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(receipt: PaymentReceipt) {
        titleNickName.text = receipt.username
        imageContact.imageFromURL(urlString: receipt.img)
        transactionDateAndTime.text = receipt.transactionDate
        transactionDateAndTime.text = receipt.transactionDate.toDateFormatted(with: "dd/MM/yyyy")
        transactionID.text = "Transação: \(receipt.id)"
        valueTransaction.text = receipt.value
    }
    
    @objc
    private func registerCardCredit() {
        print("registerCardCredit")
        didRequestToNextView?()
    }
}

extension PaymentReceiptViewController: CodeViewProtocol {
    func buildViewHierarchy() {
        view.addSubview(viewPaymentReceipt)
        viewPaymentReceipt.addSubview(pageTitle)
        viewPaymentReceipt.addSubview(imageContact)
        viewPaymentReceipt.addSubview(titleNickName)
        viewPaymentReceipt.addSubview(transactionDateAndTime)
        viewPaymentReceipt.addSubview(transactionID)
        viewPaymentReceipt.addSubview(viewLineTop)
        viewPaymentReceipt.addSubview(finalCard)
        viewPaymentReceipt.addSubview(valueTransaction)
        viewPaymentReceipt.addSubview(viewLineBottom)
        viewPaymentReceipt.addSubview(totalPaid)
        viewPaymentReceipt.addSubview(valuePaid)
    }
    
    func setupConstraints() {
        
        viewPaymentReceipt.anchor(top: view.topAnchor,
                                  leading: view.leadingAnchor,
                                  bottom: view.bottomAnchor,
                                  trailing: view.trailingAnchor,
                                  insets: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        pageTitle.anchor(top: viewPaymentReceipt.topAnchor,
                         leading: viewPaymentReceipt.leadingAnchor,
                         trailing: viewPaymentReceipt.trailingAnchor,
                         insets: .init(top: 20, left: 0, bottom: 0, right: 0))
        
        imageContact.anchor(top: viewPaymentReceipt.topAnchor,
                            leading: viewPaymentReceipt.leadingAnchor,
                            trailing: viewPaymentReceipt.trailingAnchor,
                            insets: .init(top: 128, left: 110, bottom: 0, right: 110))
        imageContact.anchor(height: 100)
        
        titleNickName.anchor(top: imageContact.bottomAnchor,
                             leading: viewPaymentReceipt.leadingAnchor,
                             trailing: viewPaymentReceipt.trailingAnchor,
                             insets: .init(top: 32.0, left: 20.0, bottom: 0, right: 20.0))
        
        transactionDateAndTime.anchor(top: titleNickName.bottomAnchor,
                                      leading: viewPaymentReceipt.leadingAnchor,
                                      trailing: viewPaymentReceipt.trailingAnchor,
                                      insets: .init(top: 8.0, left: 20.0, bottom: 0, right: 20.0))
        
        transactionID.anchor(top: transactionDateAndTime.bottomAnchor,
                             leading: viewPaymentReceipt.leadingAnchor,
                             trailing: viewPaymentReceipt.trailingAnchor,
                             insets: .init(top: 8.0, left: 20.0, bottom: 0, right: 20.0))
        
        viewLineTop.anchor(top: transactionID.bottomAnchor,
                           leading: viewPaymentReceipt.leadingAnchor,
                           trailing: viewPaymentReceipt.trailingAnchor,
                           insets: .init(top: 24.0, left: 20.0, bottom: 6.0, right: 20.0))
        viewLineTop.anchor(height: 0.5)
        
        finalCard.anchor(top: viewLineTop.bottomAnchor,
                         leading: viewPaymentReceipt.leadingAnchor,
                         trailing: viewPaymentReceipt.trailingAnchor,
                         insets: .init(top: 12, left: 20.0, bottom: 6.0, right: 20.0))
        
        valueTransaction.anchor(
            trailing: viewPaymentReceipt.trailingAnchor,
            insets: .init(top: 0, left: 0, bottom: 0, right: 20.0))
        valueTransaction.snp.makeConstraints { (make) in
            make.centerY.equalTo(finalCard)
        }
        
        viewLineBottom.anchor(top: finalCard.bottomAnchor,
                              leading: viewPaymentReceipt.leadingAnchor,
                              trailing: viewPaymentReceipt.trailingAnchor,
                              insets: .init(top: 12.0, left: 20.0, bottom: 6.0, right: 20.0))
        viewLineBottom.anchor(height: 0.5)
        
        totalPaid.anchor(top: viewLineBottom.bottomAnchor,
                         leading: viewPaymentReceipt.leadingAnchor,
                         trailing: viewPaymentReceipt.trailingAnchor,
                         insets: .init(top: 12, left: 20.0, bottom: 6.0, right: 20.0))
        
        valuePaid.anchor(trailing: viewPaymentReceipt.trailingAnchor,
                         insets: .init(top: 0, left: 0, bottom: 0, right: 20.0))
        valuePaid.snp.makeConstraints { (make) in
            make.centerY.equalTo(totalPaid)
        }
    }
}

