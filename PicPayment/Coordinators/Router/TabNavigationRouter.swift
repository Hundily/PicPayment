import class Foundation.NSObject

import class UIKit.UITabBarController
import protocol UIKit.UITabBarControllerDelegate

import class UIKit.UIViewController

final class TabNavigationRouter: NSObject {
    private (set) var rootController: UITabBarController

    required init(rootController: UITabBarController) {
        self.rootController = rootController

        super.init()

        rootController.delegate = self
    }
}

extension TabNavigationRouter: TabNavigationRouterProtocol {
    func setRoot(_ module: Module, animated: Bool) {
        guard let controller = module.toPresent() as? UIViewController else { return }
        rootController.setViewControllers([controller], animated: animated)
    }

    func setTabs(_ modules: [TabModule], animated: Bool) {
        let controllers: [UIViewController] = modules.compactMap {
            guard let controller = $0.toPresent() as? UIViewController else { return nil }
            controller.tabBarItem.title = $0.tabNavigationItem.title
            controller.tabBarItem.image = $0.tabNavigationItem.image
            controller.tabBarItem.selectedImage = $0.tabNavigationItem.selectedImage

            return controller
        }

        rootController.setViewControllers(controllers, animated: animated)
    }

    func present(_ module: Module, animated: Bool) {
        guard let controller = module.toPresent() as? UIViewController else { return }
        rootController.present(controller, style: .present(animated: animated))
    }

    func dismiss(_ module: Module, animated: Bool) {
        rootController.dismiss(animated: animated)
    }
}

extension TabNavigationRouter: UITabBarControllerDelegate { }

private extension TabNavigationRouter { }
