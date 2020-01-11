//
//  WebserviceError.swift
//  BankApp
//
//  Created by Hundily Cerqueira on 17/07/19.
//  Copyright © 2019 Hundily Cerqueira. All rights reserved.
//

import Foundation

enum WebserviceError: Error {
    case internalServerError
    case notConnectedToInternet
    case timedOut
    case unexpected
    case malformedURL
    case unauthorized
    case forbidden
    case unparseable
    case unknown
    case empty(EmptyState)
}

extension WebserviceError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .internalServerError:
            return "Erro Interno"
        case .notConnectedToInternet:
            return "Aparentemente você está sem conexão."
        case .timedOut:
            return "Request timeout."
        case .unauthorized:
            return "Usuário não autorizado."
        default:
            return "Erro: Tente novamente."
        }
    }
}

extension WebserviceError: Equatable {
    // swiftlint:disable:next cyclomatic_complexity
    static func == (lhs: WebserviceError, rhs: WebserviceError) -> Bool {
        switch (lhs, rhs) {
        case (.internalServerError, .internalServerError):
            return true
        case (.notConnectedToInternet, .notConnectedToInternet):
            return true
        case (.timedOut, .timedOut):
            return true
        case (.unexpected, .unexpected):
            return true
        case (.malformedURL, .malformedURL):
            return true
        case (.unauthorized, .unauthorized):
            return true
        case (.forbidden, .forbidden):
            return true
        case (.unparseable, .unparseable):
            return true
        case (.unknown, .unknown):
            return true
        case let (.empty(lshEmptyState), .empty(rhsEmptyState)):
            return lshEmptyState == rhsEmptyState
        default:
            return false
        }
    }
}
