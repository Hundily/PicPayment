//
//  ControllerProtocol.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 11/09/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//
enum ControllerPresentStyle {
    case present(animated: Bool)
    case push(animated: Bool)
    case setRoot(animated: Bool)
}

protocol ControllerProtocol: AnyObject {
    func present<Controller: ControllerProtocol>(_ controller: Controller, style: ControllerPresentStyle)
    func dismiss(animated: Bool)
}
