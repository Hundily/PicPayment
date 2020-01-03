//
//  EmptyState.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 11/09/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import UIKit

enum EmptyState {
    case contact
    case payment
    
    var title: String {
        switch self {
        case .contact:
            return L10n.errorEmptyStateTitleContact
        case .payment:
            return L10n.errorFetchPayment
        }
    }
    
    var description: String {
        switch self {
        case .contact:
            return L10n.errorEmptyStateDescriptionContact
        case .payment:
            return L10n.errorEmptyStateDescriptionPaymento
        }
    }
    
    var imageName: UIImage {
        switch self {
        case .contact:
            return Asset.emptyStateContact.image
        case .payment:
            return Asset.emptyStateContact.image
        }
    }
}
