//
//  Identifier.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 11/09/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import UIKit

extension UIViewController {
    var identifier: String {
        return String(describing: self)
    }
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewHeaderFooterView {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}

