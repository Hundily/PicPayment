//
//  WebService.swift
//  PicPaymentTests
//
//  Created by Hundily Cerqueira on 11/01/20.
//  Copyright © 2020 PicPayment. All rights reserved.
//

import Foundation
@testable import PicPayment

enum MockWebserviceType {
    case unexpectedError
    case customerLogin
    case loginError
    case contacts
    case payment
}

final class MockWebservice: Webservice {
    
    let type: MockWebserviceType
    
    init(type: MockWebserviceType) {
        self.type = type
    }
    
    func request<T: Codable>(urlString: String,
                             method: HTTPMethod = .get,
                             parameters: [String : Any] = [:],
                             headers: [String : String] = [:],
                             encoding: ParameterEncoding = .url,
                             completion: @escaping (Result<T, WebserviceError>) -> Void) {
        switch type {
        case .unexpectedError:
            completion(.failure(.unexpected))
        case .loginError:
            completion(.failure(.unauthorized))
        default:
            let jsonDecoder = JSONDecoder()
            let object = try! jsonDecoder.decode(T.self, from: data)
            completion(.success(object))
        }
    }
}

extension MockWebservice {
    var data: Data {
        let path: String
        switch type {
        case .unexpectedError:
            fatalError("Unexpected error should return any data")
        case .customerLogin:
            path = Bundle(for: MockWebservice.self).path(forResource: "loginResponse", ofType: "json")!
        case .loginError:
            fatalError("Unexpected error should return any data")
        case .contacts:
            path = Bundle(for: MockWebservice.self).path(forResource: "ContactsResponse", ofType: "json")!
        case .payment:
            path = Bundle(for: MockWebservice.self).path(forResource: "PaymentResponse", ofType: "json")!
        }
        let fileURL = URL(fileURLWithPath: path)
        return try! Data(contentsOf: fileURL)
    }
}

