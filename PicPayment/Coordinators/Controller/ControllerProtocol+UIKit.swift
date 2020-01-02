//
//  ControllerProtocol+UIKit.swift
//  PicPayment
//
//  Created by Hundily Cerqueira on 11/09/19.
//  Copyright © 2019 PicPayment. All rights reserved.
//
import UIKit

extension ControllerProtocol where Self: UIViewController {
    func present<Controller: ControllerProtocol>(_ controller: Controller, style: ControllerPresentStyle) {
        guard let controller = controller as? UIViewController else { return }
        switch style {
        case let .present(animated),
             let .setRoot(animated):
            present(controller, animated: animated, completion: nil)
        default: return
        }
    }
    
    func dismiss(animated: Bool) {
        dismiss(animated: animated, completion: nil)
    }
}

extension ControllerProtocol where Self: UINavigationController {
    func present<Controller: ControllerProtocol>(_ controller: Controller, style: ControllerPresentStyle) {
        guard let controller = controller as? UIViewController else { return }
        switch style {
        case let .present(animated):
            visibleViewController?.present(controller, animated: animated)
        case let .push(animated):
            pushViewController(controller, animated: animated)
        case let .setRoot(animated):
            setViewControllers([controller], animated: animated)
        }
    }
    
    func dismiss(animated: Bool) {
        visibleViewController?.dismiss(animated: animated, completion: nil)
    }
}

extension UIViewController: ControllerProtocol { }

extension ControllerProtocol where Self: UIWindow {
    func present<Controller: ControllerProtocol>(_ controller: Controller, style: ControllerPresentStyle) {
        guard let controller = controller as? UIViewController else { return }
        
        switch style {
        case let .present(animated):
            guard let rootViewController = rootViewController else {
                changeRootViewController(to: controller, animated: animated)
                return
            }
            
            rootViewController.present(controller, animated: animated)
        case let .setRoot(animated),
             let .push(animated):
            
            changeRootViewController(to: controller, animated: animated)
        }
    }
    
    func dismiss(animated: Bool) {
        window?.rootViewController?.dismiss(animated: animated)
    }
}

extension UIWindow: ControllerProtocol { }

private extension UIWindow {
    func changeRootViewController(to viewController: UIViewController, animated: Bool) {
        guard rootViewController != nil, animated else {
            rootViewController = viewController
            return
        }
        
        let snapView = snapshotView(afterScreenUpdates: true)!
        
        viewController.view.addSubview(snapView)
        rootViewController = viewController
        
        UIView.animate(withDuration: 1.0, animations: {
            snapView.alpha = 0.0
        }, completion: { _ in
            snapView.removeFromSuperview()
            self.isUserInteractionEnabled = true
        })
    }
}

