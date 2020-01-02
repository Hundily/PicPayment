protocol RouterProtocol {
    typealias Module = Presentable
    associatedtype Controller: ControllerProtocol

    var rootController: Controller { get }

    func setRoot(_ module: Module, animated: Bool)

    func present(_ module: Module, animated: Bool)
    func dismiss(_ module: Module, animated: Bool)
}

final class AnyRouter<Controller: ControllerProtocol>: RouterProtocol {
    private let box: _AnyRouterBase<Controller>

    init<Concrete: RouterProtocol>(_ concrete: Concrete) where Concrete.Controller == Controller {
        if let anyRouter = concrete as? AnyRouter<Controller> {
            box = anyRouter.box
        } else {
            box = _AnyRouterBox(concrete)
        }
    }

    var rootController: Controller { return box.rootController }

    func setRoot(_ module: Module, animated: Bool) {
        box.setRoot(module, animated: animated)
    }

    func present(_ module: Module, animated: Bool) {
        box.present(module, animated: animated)
    }

    func dismiss(_ module: Module, animated: Bool) {
        box.dismiss(module, animated: animated)
    }
}

// MARK: Type Erasure
private class _AnyRouterBase<Controller: ControllerProtocol>: RouterProtocol {
    init() {
        guard type(of: self) != _AnyRouterBase.self else {
            fatalError("_AnyRouterBase<Controller> instances can not be created; create a subclass instance instead")
        }
    }

    var rootController: Controller { _abstract() }

    func setRoot(_ module: Module, animated: Bool) { _abstract() }

    func present(_ module: Module, animated: Bool) { _abstract() }
    func dismiss(_ module: Module, animated: Bool) { _abstract() }
}

private final class _AnyRouterBox<Concrete: RouterProtocol>: _AnyRouterBase<Concrete.Controller> {
    private let concrete: Concrete

    required init(_ concrete: Concrete) {
        self.concrete = concrete
        super.init()
    }

    override var rootController: Concrete.Controller { return concrete.rootController }

    override func setRoot(_ module: Module, animated: Bool) {
        concrete.setRoot(module, animated: animated)
    }

    override func present(_ module: Module, animated: Bool) {
        concrete.present(module, animated: animated)
    }

    override func dismiss(_ module: Module, animated: Bool) {
        concrete.dismiss(module, animated: animated)
    }
}

// MARK: Abstract warning
private func _abstract(file: StaticString = #file, line: UInt = #line) -> Never {
    fatalError("Method must be overridden", file: file, line: line)
}
