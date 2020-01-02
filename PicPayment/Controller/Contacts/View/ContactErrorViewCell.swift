//
//  ContactErrorViewCell.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 11/09/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import UIKit

final class ContactErrorViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupCell(error: ServiceError, completion: @escaping () -> Void) {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        ManagerError().handler(error: error, on: self, completion: completion)
    }
}

