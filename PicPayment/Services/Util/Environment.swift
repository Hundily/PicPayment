//
//  Environment.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 11/09/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//


import Foundation


struct Environment {

  private static var environments: [String: Any]? {
    guard let dict: [String: Any] = Bundle.main.infoDictionary?["EnvironmentConfig"] as? [String: Any] else { return nil }
    return dict
  }

  static var host: String {
    guard let value = environments?["HOST"] as? String else { return "" }
    return value
  }
}
