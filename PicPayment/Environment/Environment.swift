//
//  Environment.swift
//  BankApp
//
//  Created by Hundily Cerqueira on 17/07/19.
//  Copyright © 2019 Hundily Cerqueira. All rights reserved.
//

import Foundation

struct Environment {
    let configuration: Configuration
    
    init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    static var current: Environment {
        return Environment(configuration: .current())
    }
}

extension Environment {
    var baseURLString: String {
        switch configuration {
        case .development:
            return "http://careers.picpay.com"
        default:
            return "http://careers.picpay.com"
        }
    }
}
