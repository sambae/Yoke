@propertyWrapper
class DataBinding<Value> {
    typealias Observer = (Value) -> Void

    internal var observers: [Observer] = []
    internal var bindingObserver: Observer?
    internal var receivedFromBinding = false
    internal var emitOnObserve = true

    var wrappedValue: Value {
        didSet { emitValue() }
    }
    var projectedValue: DataBinding<Value> { self }

    init(wrappedValue initialValue: Value) {
        wrappedValue = initialValue
    }

    internal func emitValue() {
        observers.forEach { $0(wrappedValue) }

        if !receivedFromBinding {
            bindingObserver?(wrappedValue)
        }

        receivedFromBinding = false
    }

    internal func observeBinding(_ observer: @escaping Observer) {
        bindingObserver = observer
    }

    internal func receiveFromBinding(_ value: Value) {
        receivedFromBinding = true
        wrappedValue = value
    }

    func observe(waitForNextValue: Bool = false, _ observer: @escaping Observer) {
        observers.append(observer)

        if !waitForNextValue {
            observer(wrappedValue)
        }
    }

    func clearObservers() {
        observers = []
    }
}
