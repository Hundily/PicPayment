//
//  ReceiptViewController.swift
//  PicPayment
//
//  Created by Hundily Cerqueira Silva on 08/01/20.
//  Copyright © 2020 hundily. All rights reserved.
//

import UIKit

class ReceiptViewController: UIViewController {
    
    @IBOutlet weak var imageContact: UIImageView!
    @IBOutlet weak var labelNickName: UILabel!
    @IBOutlet weak var labelPaymentDate: UILabel!
    @IBOutlet weak var labelPaymentId: UILabel!
    @IBOutlet weak var labelFinalCreditCard: UILabel!
    @IBOutlet weak var labelPaymentValue: UILabel!
    @IBOutlet weak var labelTotalPaymentValue: UILabel!
    private var receipt: PaymentReceipt?
    private let kReceiptViewController = "ReceiptViewController"
    
    init(receipt: PaymentReceipt) {
        super.init(nibName: kReceiptViewController, bundle: Bundle.main)
        self.receipt = receipt
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        if let img = receipt?.img, let userName = receipt?.username, let transactionDate = receipt?.transactionDate, let id = receipt?.id, let value = receipt?.value {
            let timeTransaction = TimeInterval(transactionDate) ?? 0.0
            let time = Date(timeIntervalSince1970: TimeInterval(timeTransaction))
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy - HH:mm"
            let date = formatter.string(from: time)
            
            imageContact.layer.cornerRadius = imageContact.frame.size.width / 2
            imageContact.imageFromURL(urlString: img)
            labelNickName.text = userName
            labelPaymentDate.text = date
            labelPaymentId.text = NSLocalizedString("Transação ", comment: "") + String(id)
            
            let currency = NumberFormatter()
            currency.numberStyle = .currency
            currency.locale = Locale(identifier: "pt_BR")
            
            if let formattedTipAmount = currency.string(from: NSNumber(value: value)) {
                labelPaymentValue.text = formattedTipAmount
                labelTotalPaymentValue.text = formattedTipAmount
            }
        }
    }
}
