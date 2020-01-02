//
//  Codable+Extensions.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 11/09/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import Foundation

extension Encodable {
  func encode(with encoder: JSONEncoder = JSONEncoder()) throws -> Data {
    return try encoder.encode(self)
  }
}

extension Decodable {
  static func decode(with decoder: JSONDecoder = JSONDecoder(), from data: Data) throws -> Self {
    return try decoder.decode(Self.self, from: data)
  }
}
