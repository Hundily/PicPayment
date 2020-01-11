//
//  Transaction.swift
//  PicPayment
//
//  Created by Hundily Cerqueira Silva on 09/01/20.
//  Copyright © 2020 PicPayment. All rights reserved.
//

import Foundation

struct PaymentResponse: Codable {
    let transaction: Transaction?
}

struct Transaction : Codable {
    let id: Int?
    let timestamp: Int?
    let value: Double?
    let destination_user: Destination_user?
    let success: Bool?
    let status: String?
}

struct Destination_user: Codable {
    let id: Int?
    let name: String?
    let img: String?
    let username: String?
}


