@propertyWrapper
class DataBinding<Value> {
    
    typealias Observer = (Value) -> Void

    var wrappedValue: Value {
        didSet { notifyObservers() }
    }

    var projectedValue: DataBinding<Value> { self }

    private var observers: [Observer] = []

    init(wrappedValue initialValue: Value) {
        wrappedValue = initialValue
    }

    private func notifyObservers() {
        observers.forEach { $0(wrappedValue) }
    }

    func observe(_ observer: @escaping Observer) {
        observe(wrappedValue)
        observers.append(observer)
    }

    func clearObservers() {
        observers = []
    }
}
