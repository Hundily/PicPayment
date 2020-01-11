//
//  Webservice.swift
//  BankApp
//
//  Created by Hundily Cerqueira on 17/07/19.
//  Copyright © 2019 Hundily Cerqueira. All rights reserved.
//

import Foundation

enum ParameterEncoding {
    case json
    case url
}

protocol Webservice {
    func request<T: Codable>(urlString: String,
                             method: HTTPMethod,
                             parameters: [String: Any],
                             headers: [String: String],
                             encoding: ParameterEncoding,
                             completion: @escaping (Swift.Result<T, WebserviceError>) -> Void)
}

extension Webservice {
    func request<T: Codable>(urlString: String,
                             method: HTTPMethod = .get,
                             parameters: [String: Any] = [:],
                             headers: [String: String] = [:],
                             encoding: ParameterEncoding = .url,
                             completion: @escaping (Result<T, WebserviceError>) -> Void) {
        
        request(urlString: urlString,
                method: method,
                parameters: parameters,
                headers: headers,
                encoding: encoding,
                completion: completion)
    }
}
