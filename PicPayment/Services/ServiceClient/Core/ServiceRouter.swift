//
//  APIRouter.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 11/09/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import Foundation

enum NamespaceHTTPMethod: Int, RawRepresentable {
  case get
  case post
  case put
  case delete

  public var rawValue: String {
    switch self {
    case .get:
      return "GET"
    case .post:
      return "POST"
    case .put:
      return "PUT"
    case .delete:
      return "DELETE"
    }
  }

  public init?(rawValue: String) {
    switch rawValue {
    case "GET":
      self = .get
    case "POST":
      self = .post
    case "PUT":
      self = .put
    case "DELETE":
      self = .delete
    default:
      self = .get
    }
  }
}

enum NamespaceParameterEncoding: Int, RawRepresentable {
  case url
  case json
  case array

  public var rawValue: String {
    switch self {
    case .url:
      return "URL"
    case .json:
      return "JSON"
    case .array:
      return "ARRAY"
    }
  }

  public init?(rawValue: String) {
    switch rawValue {
    case "URL":
      self = .url
    case "JSON":
      self = .json
    case "ARRAY":
      self = .array
    default:
      self = .url
    }
  }
}

protocol ServiceRouter {
  var baseURL: String { get }
  var path: String { get }
  var fullURL: String { get }
  var method: NamespaceHTTPMethod { get }
  var encoding: NamespaceParameterEncoding { get }
  var parameters: [String: Any] { get }
  var parametersArray: [Any] { get }
  func asURLRequest() -> URLRequest?
}

extension ServiceRouter {

  var baseURL: String {
    return Environment.host
  }

  var fullURL: String {
    return baseURL + path
  }

  var method: NamespaceHTTPMethod {
    return .get
  }

  var encoding: NamespaceParameterEncoding {
    return .url
  }

  var parameters: [String: Any] {
    return [:]
  }

  var parametersArray: [Any] {
    return []
  }
}


extension ServiceRouter {

  func asURLRequest() -> URLRequest? {
    guard let url = URL(string: fullURL) else { return nil }

    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue

    switch encoding {
    case .url:
      urlEncode(&request)
    case .json:
      jsonEncode(&request)
    case .array:
      arrayEncode(&request)
    }

    return request
  }

  private func urlEncode(_ urlRequest: inout URLRequest) {
    if let url = urlRequest.url, [.get, .delete].contains(method) {
      if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
        urlComponents.queryItems = parameters.map{ URLQueryItem(name: $0.key, value: ($0.value as? String)) }
        urlRequest.url = urlComponents.url
      }
    } else {
      if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
        urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
      }
      let httpBody = parameters.map{ "\($0.key)=\($0.value)" }.joined(separator: "&")
      urlRequest.httpBody = httpBody.data(using: .utf8, allowLossyConversion: false)
    }
  }

  private func jsonEncode(_ urlRequest: inout URLRequest) {
    guard let data = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
    if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
      urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    urlRequest.httpBody = data
  }

  private func arrayEncode(_ urlRequest: inout URLRequest) {
    guard let data = try? JSONSerialization.data(withJSONObject: parametersArray, options: .prettyPrinted) else { return }
    if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
      urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    urlRequest.httpBody = data
  }

}
