#if !os(macOS)
import UIKit

extension UISwitch: Bindable {
    override func emitValue() {
        binding.wrappedValue = isOn
    }

    func receiveValue(_ value: Bool) {
        setOn(value, animated: true)
    }
}

extension UIButton: Bindable {
    override func emitValue() {
        binding.wrappedValue = .tap
    }

    func receiveValue(_ value: Tap) {}
}
#endif
