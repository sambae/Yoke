protocol DefaultValue {
    static var defaultValue: Self { get }
}

extension Bool: DefaultValue {
    static var defaultValue = false
}
extension String: DefaultValue {
    static var defaultValue = ""
}
extension Int: DefaultValue {
    static var defaultValue = 0
}

public enum Tap: DefaultValue {
    case tap

    static var defaultValue: Tap = .tap
}
