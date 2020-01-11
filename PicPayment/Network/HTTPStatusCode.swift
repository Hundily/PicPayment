//
//  HTTPStatusCode.swift
//  BankApp
//
//  Created by Hundily Cerqueira on 17/07/19.
//  Copyright © 2019 Hundily Cerqueira. All rights reserved.
//

import Foundation

enum HTTPStatusCode: Int {
    case unauthorized = 401
    case forbidden = 403
    case internalServerError = 500
}
