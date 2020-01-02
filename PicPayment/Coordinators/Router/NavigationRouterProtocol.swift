enum NavigationRouterPopAnimation {
    case none
    case normal
    case fade
}

protocol NavigationRouterProtocol: RouterProtocol {
    func push(_ module: Module, animated: Bool, completion: (() -> Void)?)
    func popToRootModule(animatedWith animation: NavigationRouterPopAnimation, completion: (() -> Void)?)
    func popTo(_ module: Module, animatedWith animation: NavigationRouterPopAnimation, completion: (() -> Void)?)
}

final class AnyNavigationRouter<Controller: ControllerProtocol>: NavigationRouterProtocol {
    private let box: _AnyNavigationRouterBase<Controller>

    init<Concrete: NavigationRouterProtocol>(_ concrete: Concrete) where Concrete.Controller == Controller {
        if let anyNavigationRouter = concrete as? AnyNavigationRouter<Controller> {
            box = anyNavigationRouter.box
        } else {
            box = _AnyNavigationRouterBox(concrete)
        }
    }

    var rootController: Controller { return box.rootController }

    func present(_ module: Module, animated: Bool) {
        box.present(module, animated: animated)
    }

    func dismiss(_ module: Module, animated: Bool) {
        box.dismiss(module, animated: animated)
    }

    func setRoot(_ module: Module, animated: Bool) {
        box.setRoot(module, animated: animated)
    }

    func push(_ module: Module, animated: Bool, completion: (() -> Void)? = nil) {
        box.push(module, animated: animated, completion: completion)
    }

    func popTo(_ module: Module, animatedWith animation: NavigationRouterPopAnimation = .normal, completion: (() -> Void)? = nil) {
        box.popTo(module, animatedWith: animation, completion: completion)
    }

    func popToRootModule(animatedWith animation: NavigationRouterPopAnimation = .normal, completion: (() -> Void)?) {
        box.popToRootModule(animatedWith: animation, completion: completion)
    }
}

// MARK: Type Erasure
private class _AnyNavigationRouterBase<Controller: ControllerProtocol>: NavigationRouterProtocol {
    init() {
        guard type(of: self) != _AnyNavigationRouterBase.self else {
            fatalError("_AnyNavigationRouterBase<Controller> instances can not be created; create a subclass instance instead")
        }
    }

    var rootController: Controller { _abstract() }
    func present(_ module: Module, animated: Bool) { _abstract() }
    func dismiss(_ module: Module, animated: Bool) { _abstract() }

    func setRoot(_ module: Module, animated: Bool) { _abstract() }
    func push(_ module: Module, animated: Bool, completion: (() -> Void)?) { _abstract() }

    func popTo(_ module: Module, animatedWith animation: NavigationRouterPopAnimation, completion: (() -> Void)?) { _abstract() }
    func popToRootModule(animatedWith animation: NavigationRouterPopAnimation, completion: (() -> Void)?) { _abstract() }
}

private final class _AnyNavigationRouterBox<Concrete: NavigationRouterProtocol>: _AnyNavigationRouterBase<Concrete.Controller> {
    private let concrete: Concrete

    required init(_ concrete: Concrete) {
        self.concrete = concrete
        super.init()
    }

    override var rootController: Concrete.Controller { return concrete.rootController }

    override func present(_ module: Module, animated: Bool) {
        concrete.present(module, animated: animated)
    }

    override func dismiss(_ module: Module, animated: Bool) {
        concrete.dismiss(module, animated: animated)
    }

    override func setRoot(_ module: Module, animated: Bool) {
        concrete.setRoot(module, animated: animated)
    }

    override func push(_ module: Module, animated: Bool, completion: (() -> Void)?) {
        concrete.push(module, animated: animated, completion: completion)
    }

    override func popTo(_ module: _AnyNavigationRouterBase<Controller>.Module,
                        animatedWith animation: NavigationRouterPopAnimation,
                        completion: (() -> Void)?) {
        concrete.popTo(module, animatedWith: animation, completion: completion)
    }
    override func popToRootModule(animatedWith animation: NavigationRouterPopAnimation, completion: (() -> Void)?) {
        concrete.popToRootModule(animatedWith: animation, completion: completion)
    }
}

// MARK: Abstract warning
private func _abstract(file: StaticString = #file, line: UInt = #line) -> Never {
    fatalError("Method must be overridden", file: file, line: line)
}
