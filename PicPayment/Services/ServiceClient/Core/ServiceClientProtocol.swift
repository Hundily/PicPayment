//
//  Core.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 11/09/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import Foundation

protocol URLSessionProtocol {
  func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
  func resume()
}

extension URLSession: URLSessionProtocol {
  func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
    return (dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
  }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }

protocol ServiceClientProtocol {
  func request<T: Codable>(router: ServiceRouter, completion: @escaping (ServiceResult<T>) -> Void)
  func request(router: ServiceRouter, completion: @escaping (ServiceResult<Void>) -> Void)
}
