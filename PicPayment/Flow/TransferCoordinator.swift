//
//  TransferCoordinator.swift
//  PicPayment
//
//  Created by Hundily Cerqueira Silva on 09/01/20.
//  Copyright © 2020 PicPayment. All rights reserved.
//

import UIKit

final class TransferCoordinator: Coordinator {
    private let router: AnyNavigationRouter<UINavigationController>
    var finishflow: (() -> Void)?
    
    required init<Router: NavigationRouterProtocol>(router: Router) where Router.Controller == UINavigationController {
        self.router = AnyNavigationRouter(router)
        super.init()
    }
    
    override func start() {
        var teste = Contact(id: 123, name: "Hundily", img: "", username: "@hundily")
        var card = CreditCard(cardNumber: "123", cardName: "hundily", cardExpired: "123", cardCvv: "123")

        let contacts = HomeTransferViewController(contact: teste, creditCard: card)
        router.push(contacts, animated: true)
    }
}

//private extension ContactsCoordinator {
//    func goToCreditCardScreen(contact: Contact) {
//        let creditCardViewController = RegisterCreditCardHomeViewController(contact: contact)
//        router.push(creditCardViewController, animated: true)
//    }
//}

extension TransferCoordinator: Presentable {
    func toPresent() -> ControllerProtocol {
        return router.rootController
    }
}

