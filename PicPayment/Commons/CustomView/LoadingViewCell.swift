//
//  LoadingViewTable.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 11/09/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import UIKit

final class LoadingViewCell: UITableViewCell {
    
    private let loadingManager = LoadingManager()
    
    func setup() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        loadingManager.startAnimation(view: contentView)
    }
}
