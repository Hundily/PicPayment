//
//  ContactRouter.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 11/09/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import Foundation

enum ContactRouter {
    case fetchContact
}

extension ContactRouter: ServiceRouter {
    
    var path: String {
        switch self {
        case .fetchContact:
            return "/tests/mobdev/users"
        }
    }
    
    var method: NamespaceHTTPMethod {
        return .get
    }
    
}
