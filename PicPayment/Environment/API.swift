//
//  API.swift
//  BankApp
//
//  Created by Hundily Cerqueira on 17/07/19.
//  Copyright © 2019 Hundily Cerqueira. All rights reserved.
//

import Foundation

struct API {
    enum Path {
        case contacts
        case payment
        
        var value: String {
            let baseURL = Environment.current.baseURLString
            
            switch self {
            case .contacts:
                return "\(baseURL)/tests/mobdev/users"
            case .payment:
                return "\(baseURL)/tests/mobdev/transaction"
            }
        }
    }
}
