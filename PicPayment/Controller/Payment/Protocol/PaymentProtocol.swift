//
//  PaymentProtocol.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 11/01/20.
//  Copyright © 2020 PicPayment. All rights reserved.
//

import Foundation

protocol PaymentProtocol: AnyObject {
    func show()
    func showReceiptView(receipt: PaymentReceipt?)
    func showLoading()
    func dismissLoading()
    func show(error: Error)
}
