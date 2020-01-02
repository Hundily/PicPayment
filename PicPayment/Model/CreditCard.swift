//
//  CreditCard.swift
//  PicPayment
//
//  Created by Hundily Cerqueira Silva on 27/11/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import Foundation

struct CreditCard: Codable {
    let cardNumber: String
    let cardName: String
    let cardExpired: String
    let cardCvv: String
}
