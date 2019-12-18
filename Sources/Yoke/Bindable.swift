
protocol Bindable {
    associatedtype BindingValue: Defaultable

    func receiveValue(_ value: BindingValue)

    var binding: DataBinding<BindingValue> { get }
}

protocol Emittable {
    var hasTarget: Bool { get set }
    func addBindingTarget()
    func emitValue()
}

typealias TwoWayBindable = Bindable & Emittable

private enum AssociatedKeys {
    static var binding = "associatedkey"
    static var hasTarget = "hasTarget"
}

#if !os(macOS)
import UIKit

extension Bindable where Self: UIView {
    var binding: DataBinding<BindingValue> {
        if let binding = objc_getAssociatedObject(self, &AssociatedKeys.binding) as? DataBinding<BindingValue> {
            return binding
        }

        let binding = DataBinding<BindingValue>(wrappedValue: BindingValue.defaultValue)
        binding.observe { self.receiveValue($0) }

        objc_setAssociatedObject(self, &AssociatedKeys.binding, binding, .OBJC_ASSOCIATION_RETAIN)

        return binding
    }
}

extension UIControl: Emittable {
    func addBindingTarget() {
        addTarget(self, action: #selector(emitValue), for: .valueChanged)
        hasTarget = true
    }

    var hasTarget: Bool {
        get {
            (objc_getAssociatedObject(self, &AssociatedKeys.hasTarget) as? Bool) ?? false
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.hasTarget, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }

    @objc func emitValue() {}
}
#endif
