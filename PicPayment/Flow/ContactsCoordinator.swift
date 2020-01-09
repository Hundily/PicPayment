//
//  ContactsCoordinator.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 11/09/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import UIKit

final class ContactsCoordinator: Coordinator {
    private let router: AnyNavigationRouter<UINavigationController>
    var finishflow: (() -> Void)?
    
    required init<Router: NavigationRouterProtocol>(router: Router) where Router.Controller == UINavigationController {
        self.router = AnyNavigationRouter(router)
        super.init()
    }
    
    override func start() {
        let contacts = ContactsViewController()
        contacts.didRequestToNextView = { [weak self] contact in
            if let creditCard = UserDefaults.standard.object(forKey: "CREDIT_CARD") as? Data {
                let decoder = JSONDecoder()
                if let creditCardParse = try? decoder.decode(CreditCard.self, from: creditCard) {
                    let homePaymentViewController = HomeTransferViewController(contact: contact, creditCard: creditCardParse)
                    self?.router.push(homePaymentViewController, animated: true)
                }
            } else {
                self?.goToCreditCardScreen(contact: contact)
            }
        }

        router.push(contacts, animated: true)
    }
    
    func registerCreditCardHome(contact: Contact) {
        let creditCardViewController = RegisterCreditCardHomeViewController(contact: contact)
        router.push(creditCardViewController, animated: true)
    }

}

private extension ContactsCoordinator {
    func goToCreditCardScreen(contact: Contact) {
        let creditCardViewController = RegisterCreditCardHomeViewController(contact: contact)
        router.push(creditCardViewController, animated: true)
    }
}

extension ContactsCoordinator: Presentable {
    func toPresent() -> ControllerProtocol {
        return router.rootController
    }
}
