//
//  PaymentRouter.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 26/12/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import Foundation

enum PaymentRouter {
    case fetchPayment(Payment)
}

extension PaymentRouter: ServiceRouter {
    
    var path: String {
        switch self {
        case .fetchPayment(_):
            return "/tests/mobdev/transaction"
        }
    }
    
    var method: NamespaceHTTPMethod {
        return .post
    }
    
    var parameters: [String : Any] {
        switch self {
        case .fetchPayment(let data):
            return [
                "card_number": data.card_number,
                "cvv": data.cvv,
                "value": data.value,
                "expiry_date": data.expiry_date,
                "destination_user_id": data.destination_user_id
            ]
        default:
            return [:]
        }

    }
}
