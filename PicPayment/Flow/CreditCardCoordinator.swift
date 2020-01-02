//
//  CreditCardCoordinator.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 11/09/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import UIKit

final class CreditCardCoordinator: Coordinator {
    private let router: AnyNavigationRouter<UINavigationController>
    var finishflow: (() -> Void)?
    
    required init<Router: NavigationRouterProtocol>(router: Router) where Router.Controller == UINavigationController {
        self.router = AnyNavigationRouter(router)
        super.init()
    }
    
    override func start() {
        let creditCardViewController = HomeCreditCardViewController(contact: nil)
        creditCardViewController.didRequestToFormCreditCardView = { [weak self] in
            self?.goToFormCreditCardScreen()
        }
        router.push(creditCardViewController, animated: true)
    }
}

private extension CreditCardCoordinator {
    func goToFormCreditCardScreen() {
        print("goToFormCreditCardScreen")
    }
}

extension CreditCardCoordinator: Presentable {
    func toPresent() -> ControllerProtocol {
        return router.rootController
    }
}
