//
//  ContactListType.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 11/09/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

enum ContactListCellType<T> {
    case loading
    case cell(T)
    case error(WebserviceError)
}
