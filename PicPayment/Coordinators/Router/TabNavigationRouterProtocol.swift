import class UIKit.UIImage

struct TabNavigationItem {
    let title: String
    let image: UIImage
    let selectedImage: UIImage
}

protocol TabNavigationItemPresentable {
    var tabNavigationItem: TabNavigationItem { get }
}

protocol TabNavigationRouterProtocol: RouterProtocol {
    typealias TabModule = RouterProtocol.Module & TabNavigationItemPresentable

    func setTabs(_ modules: [TabModule], animated: Bool)
}

final class AnyTabNavigationRouter<Controller: ControllerProtocol>: TabNavigationRouterProtocol {
    private let box: _AnyTabNavigationRouterBase<Controller>

    init<Concrete: TabNavigationRouterProtocol>(_ concrete: Concrete) where Concrete.Controller == Controller {
        if let router = concrete as? AnyTabNavigationRouter<Controller> {
            box = router.box
        } else {
            box = _AnyTabNavigationRouterBox(concrete)
        }
    }

    var rootController: Controller { return box.rootController }

    func setRoot(_ module: Module, animated: Bool) {
        box.setRoot(module, animated: animated)
    }

    func setTabs(_ modules: [TabModule], animated: Bool) {
        box.setTabs(modules, animated: animated)
    }

    func present(_ module: Module, animated: Bool) {
        box.present(module, animated: animated)
    }

    func dismiss(_ module: Module, animated: Bool) {
        box.dismiss(module, animated: animated)
    }
}

// MARK: Type Erasure
private class _AnyTabNavigationRouterBase<Controller: ControllerProtocol>: TabNavigationRouterProtocol {
    init() {
        guard type(of: self) != _AnyTabNavigationRouterBase.self else {
            fatalError("_AnyTabNavigationRouterBase<Controller> instances can not be created; create a subclass instance instead")
        }
    }

    var rootController: Controller { _abstract() }
    func setRoot(_ module: Module, animated: Bool) { _abstract() }
    func setTabs(_ modules: [TabModule], animated: Bool) { _abstract() }
    func present(_ module: Module, animated: Bool) { _abstract() }
    func dismiss(_ module: Module, animated: Bool) { _abstract() }
}

private final class _AnyTabNavigationRouterBox<Concrete: TabNavigationRouterProtocol>: _AnyTabNavigationRouterBase<Concrete.Controller> {
    private let concrete: Concrete

    required init(_ concrete: Concrete) {
        self.concrete = concrete
        super.init()
    }

    override var rootController: Concrete.Controller { return concrete.rootController }

    override func setRoot(_ module: Module, animated: Bool) {
        concrete.setRoot(module, animated: animated)
    }

    override func setTabs(_ modules: [TabModule], animated: Bool) {
        concrete.setTabs(modules, animated: animated)
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
