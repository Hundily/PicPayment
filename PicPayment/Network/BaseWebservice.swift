//
//  BaseWebservice.swift
//  BankApp
//
//  Created by Hundily Cerqueira on 17/07/19.
//  Copyright © 2019 Hundily Cerqueira. All rights reserved.
//

import Foundation
import Alamofire

extension ParameterEncoding {
    var alamofireEncoding: Alamofire.ParameterEncoding {
        switch self {
        case .json:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
}

struct BaseWebservice: Webservice {
    private let manager = DefaultSessionManager()
    
    func request<T: Codable>(urlString: String,
                             method: HTTPMethod,
                             parameters: [String: Any],
                             headers: [String: String],
                             encoding: ParameterEncoding,
                             completion: @escaping (Swift.Result<T, WebserviceError>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            return completion(.failure(.malformedURL))
        }
        
        var alamofireHeaders = headers
        alamofireHeaders["Content-Type"] = "application/json"
        
        let httpMethod = alamofireMethod(with: method)
        
        let request = manager.request(url, method: httpMethod,
                                      parameters: parameters,
                                      encoding: encoding.alamofireEncoding,
                                      headers: alamofireHeaders)
        
        request
            .validate(statusCode: 200..<300)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    let jsonDecoder = JSONDecoder()
                    do {
                        let object = try jsonDecoder.decode(T.self, from: data)
                        completion(.success(object))
                    } catch {
                        print(error)
                        completion(.failure(.unparseable))
                    }
                case .failure(let error):
                    let statusCode = response.response?.statusCode
                    self.handleFailure(error: error, statusCode: statusCode, completion: completion)
                }
        }
    }
    
    private func handleFailure<T>(error: Error, statusCode: Int?,
                                  completion: @escaping (Swift.Result<T, WebserviceError>) -> Void) {
        if let urlError = error as? URLError {
            return completion(.failure(self.handleURLError(error: urlError)))
        }
        
        guard let statusCode = statusCode else {
            return completion(.failure(.unexpected))
        }
        
        completion(.failure(self.handleHTTPError(statusCode: statusCode)))
    }
    
    private func handleURLError(error: URLError) -> WebserviceError {
        switch error.code {
        case .notConnectedToInternet:
            return .notConnectedToInternet
        case .timedOut:
            return .timedOut
        default:
            return .unexpected
        }
    }
    
    private func handleHTTPError(statusCode: Int) -> WebserviceError {
        guard let error = HTTPStatusCode(rawValue: statusCode) else {
            return .unexpected
        }
        
        switch error {
        case .unauthorized:
            return .unauthorized
        case .internalServerError:
            return .internalServerError
        case .forbidden:
            return .forbidden
        }
    }
}

extension BaseWebservice {
    private func alamofireMethod(with httpMethod: HTTPMethod) -> Alamofire.HTTPMethod {
        switch httpMethod {
        case .get:
            return .get
        case .post:
            return .post
        case .put:
            return .put
        }
    }
}
