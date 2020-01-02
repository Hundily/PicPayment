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
    
    var title: String {
        switch self {
        case .contact:
            return L10n.errorEmptyStateTitleContact
        }
    }
    
    var description: String {
        switch self {
        case .contact:
            return L10n.errorEmptyStateDescriptionContact
        }
    }
    
    var imageName: UIImage {
        switch self {
        case .contact:
            return Asset.emptyStateContact.image
        }
    }
}
