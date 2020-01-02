//
//  ApplicationCoordinator.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 11/09/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//

import UIKit

final class ApplicationCoordinator: Coordinator {
    
    private let router: AnyRouter<UIWindow>
    
    required init<Router: RouterProtocol>(router: Router) where Router.Controller == UIWindow {
        self.router = AnyRouter(router)
        super.init()
    }
    
    override func start() {
        let navigationController = UINavigationController()
        navigationController.view.backgroundColor = .white
        
        let coordinator = ContactsCoordinator(router: NavigationRouter(rootController: navigationController))
        add(child: coordinator)
        coordinator.finishflow = { [weak self] in
            self?.remove(child: coordinator)
        }
        
        coordinator.start()
        router.setRoot(coordinator, animated: true)
    }
}
