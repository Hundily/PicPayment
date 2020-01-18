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
        setData()
    }
    
    func setData() {
        imageContact.layer.cornerRadius = imageContact.frame.size.width / 2
        imageContact.imageFromURL(urlString: receipt?.img ?? "")
        labelNickName.text = receipt?.username
        labelPaymentDate.text = receipt?.transactionDate
        labelPaymentId.text = "Transação: \(receipt?.id ?? 0)"
        labelPaymentValue.text = String.currencyInputFormatting("\(receipt?.value ?? 0)")()
        labelTotalPaymentValue.text = String.currencyInputFormatting("\(receipt?.value ?? 0)")()
    }
}
