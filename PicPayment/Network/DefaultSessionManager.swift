//
//  DefaultSessionManager.swift
//  BankApp
//
//  Created by Hundily Cerqueira on 17/07/19.
//  Copyright © 2019 Hundily Cerqueira. All rights reserved.
//

import Alamofire

final class DefaultSessionManager: SessionManager {
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 20
        configuration.timeoutIntervalForResource = 20
        configuration.requestCachePolicy = .useProtocolCachePolicy
        
        super.init(configuration: configuration)
    }
}
