//
//  ContactProtocol.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 11/09/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

protocol ContactProtocol: AnyObject {
    func show()
    func showLoading()
    func dismissLoading()
    func show(error: Error)
}
