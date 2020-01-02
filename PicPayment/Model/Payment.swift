//
//  Transaction.swift
//  PicPayment
//
//  Created by Hundily Cerqueira Silva on 26/12/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import Foundation

struct Payment {
    let card_number: String
    let cvv: String
    let value: String
    let expiry_date: String
    let destination_user_id: String
}
