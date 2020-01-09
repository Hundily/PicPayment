//
//  HomePaymentProtocol.swift
//  PicPayment
//
//  Created by Hundily Cerqueira Silva on 03/01/20.
//  Copyright © 2020 PicPayment. All rights reserved.
//

import Foundation

protocol HomeTransferProtocol: AnyObject {
    func show()
    func showLoading()
    func dismissLoading()
    func show(error: Error)
}
