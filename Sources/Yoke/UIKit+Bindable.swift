
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

extension UILabel: Bindable {
    func receiveValue(_ value: String) {
        text = value
    }
}
#endif
