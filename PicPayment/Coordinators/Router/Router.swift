import class UIKit.UIViewController

final class Router<Controller: ControllerProtocol>: RouterProtocol {
    private (set) var rootController: Controller

    init(rootController: Controller) {
        self.rootController = rootController
    }

    func setRoot(_ module: Module, animated: Bool) {
        guard let controller = module.toPresent() as? UIViewController else { return }
        rootController.present(controller, style: .setRoot(animated: animated))
    }

    func present(_ module: Module, animated: Bool) {
        guard let controller = module.toPresent() as? UIViewController else { return }
        rootController.present(controller, style: .present(animated: animated))
    }

    func dismiss(_ module: Module, animated: Bool) {
        rootController.dismiss(animated: animated)
    }
}
