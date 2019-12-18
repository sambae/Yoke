
protocol Defaultable {
    static var defaultValue: Self { get }
}

extension Bool: Defaultable {
    static var defaultValue = false
}
extension String: Defaultable {
    static var defaultValue = ""
}
extension Int: Defaultable {
    static var defaultValue = 0
}
