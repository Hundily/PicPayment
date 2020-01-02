//
//  PaymentRouter.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 26/12/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import Foundation

enum PaymentRouter {
    case fetchPayment
}

extension PaymentRouter: ServiceRouter {
    
    var path: String {
        switch self {
        case .fetchPayment:
            return "/tests/mobdev/transaction"
        }
    }
    
    var method: NamespaceHTTPMethod {
        return .post
    }
    
}
