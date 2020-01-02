//
//  ServiceResult.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 11/09/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import Foundation

enum ServiceResult<T> {
  case success(T)
  case failure(ServiceError)
}

extension ServiceResult {
  var isSuccess: Bool {
    switch self {
    case .success:
      return true
    case .failure:
      return false
    }
  }

  var isFailure: Bool {
    return !isSuccess
  }

  var value: T? {
    switch self {
    case .success(let value):
      return value
    case .failure:
      return nil
    }
  }

  var error: Swift.Error? {
    switch self {
    case .success:
      return nil
    case .failure(let error):
      return error
    }
  }
}

extension ServiceResult: CustomStringConvertible {
  var description: String {
    switch self {
    case .success:
      return "SUCCESS"
    case .failure:
      return "FAILURE"
    }
  }
}

extension ServiceResult: CustomDebugStringConvertible {
  var debugDescription: String {
    switch self {
    case .success(let value):
      return "SUCCESS: \(value)"
    case .failure(let error):
      return "FAILURE: \(error)"
    }
  }
}

extension ServiceResult where T == Void {
  static var success: ServiceResult {
    return .success(())
  }
}
