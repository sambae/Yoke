
#if !os(macOS)
import UIKit

extension UISwitch: Bindable {
    func receiveValue(_ value: Bool) {
        setOn(value, animated: true)
    }
}

#endif
