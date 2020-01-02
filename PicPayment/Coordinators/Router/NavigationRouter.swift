import UIKit

final class NavigationRouter: NSObject {
    private (set) var rootController: UINavigationController
    private var completions: [UIViewController: () -> Void]

    private weak var snapshotView: UIView?

    required init(rootController: UINavigationController) {
        self.rootController = rootController
        completions = [:]

        super.init()

        rootController.delegate = self
    }
}

extension NavigationRouter: NavigationRouterProtocol {
    func setRoot(_ module: Module, animated: Bool) {
        completions.forEach { $0.value() }
        completions.removeAll()

        guard let controller = module.toPresent() as? UIViewController else { return }
        rootController.present(controller, style: .setRoot(animated: animated))
    }

    func push(_ module: Module, animated: Bool, completion: (() -> Void)?) {
        guard rootController.viewControllers.isEmpty == false else {
            setRoot(module, animated: animated)
            return
        }

        guard let controller = module.toPresent() as? UIViewController else { return }

        if let completion = completion {
            completions[controller] = completion
        }

        rootController.present(controller, style: .push(animated: animated))
    }

    func popTo(_ module: Module, animatedWith animation: NavigationRouterPopAnimation = .normal, completion: (() -> Void)? = nil) {
        guard rootController.viewControllers.count > 1 else { return }

        guard let controller = module.toPresent() as? UIViewController else { return }
        popToViewController(controller, animatedWith: animation, completion: completion)
    }

    func popToRootModule(animatedWith animation: NavigationRouterPopAnimation, completion: (() -> Void)?) {
        guard rootController.viewControllers.count > 1, let controller: UIViewController = rootController.viewControllers.first else { return }
        popToViewController(controller, animatedWith: animation, completion: completion)
    }

    func present(_ module: Module, animated: Bool) {
        guard let controller = module.toPresent() as? UIViewController else { return }
        rootController.present(controller, style: .present(animated: animated))
    }

    func dismiss(_ module: Module, animated: Bool) {
        rootController.dismiss(animated: animated)
    }
}

protocol NavigationTransitionEffect {
  var navigationBarColor: UIColor { get }
  var prefersLargeTitles: Bool { get }
}

extension NavigationTransitionEffect {
  var navigationBarColor: UIColor { return ColorName.backgroundDefault.color }
  var prefersLargeTitles: Bool { return true }
}

extension NavigationRouter: UINavigationControllerDelegate {
  func navigationController(
    _ navigationController: UINavigationController,
    animationControllerFor operation: UINavigationController.Operation,
    from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

    if let transitionEffect = toVC as? NavigationTransitionEffect {
      toVC.setupNavigationBar(with: .colored(barColor: transitionEffect.navigationBarColor),
                              prefersLargeTitles: transitionEffect.prefersLargeTitles)
    }

    return nil
  }

  func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    if let transitionEffect = viewController as? NavigationTransitionEffect {
      viewController.setupNavigationBar(with: .colored(barColor: transitionEffect.navigationBarColor),
                              prefersLargeTitles: transitionEffect.prefersLargeTitles)
    }
  }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let poppedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            navigationController.viewControllers.contains(poppedViewController) == false else { return }

        runCompletion(for: poppedViewController)
    }
}

private extension NavigationRouter {
    func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completions.removeValue(forKey: controller)
        completion()
    }

    func popToViewController(_ controller: UIViewController, animatedWith animation: NavigationRouterPopAnimation, completion: (() -> Void)?) {
        var customCompletion: (() -> Void) = {
            completion?()
        }

        switch animation {
        case .none:
            completions[rootController.visibleViewController!] = customCompletion
            popToViewController(controller, animated: false)
        case .normal:
            completions[rootController.visibleViewController!] = customCompletion
            popToViewController(controller)
        case .fade:
            customCompletion = { [weak self] in
                self?.completePopTransitionWithFadeAnimation()
                completion?()
            }

            completions[rootController.visibleViewController!] = customCompletion
            fadeToViewController(controller)
        }
    }

    func popToViewController(_ viewController: UIViewController, animated: Bool = true) {
        guard rootController.viewControllers.contains(viewController) else {
            if let parentViewController = viewController.parent {
                popToViewController(parentViewController, animated: animated)
            }
            return
        }

        if let controllers = rootController.popToViewController(viewController, animated: animated) {
            controllers.forEach { runCompletion(for: $0) }
        }
    }

    func fadeToViewController(_ viewController: UIViewController) {
        guard let snapshotView = rootController.visibleViewController?.view.snapshotView(afterScreenUpdates: true) else { return }

        rootController.view.addSubview(snapshotView)
        self.snapshotView = snapshotView

        popToViewController(viewController, animated: false)
    }

    func completePopTransitionWithFadeAnimation() {
        guard let snapshotView = snapshotView else { return }

        UIView.animate(withDuration: 1.0, animations: {
            snapshotView.alpha = 0.0
        }, completion: { _ in
            snapshotView.removeFromSuperview()
        })
    }
}
