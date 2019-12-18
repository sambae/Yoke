
protocol Bindable {
    associatedtype BindingValue: Defaultable

    func receiveValue(_ value: BindingValue)

    var binding: DataBinding<BindingValue> { get }
}

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
#endif
