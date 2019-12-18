
@propertyWrapper
class DataBinding<Value> {
    typealias Observer = (Value) -> Void

    var wrappedValue: Value {
        didSet { emitValue() }
    }

    var projectedValue: DataBinding<Value> { self }
    private var observers: [Observer] = []
    private var bindingObserver: Observer?
    private var receivedFromBinding = false

    init(wrappedValue initialValue: Value) {
        wrappedValue = initialValue
    }

    private func emitValue() {
        observers.forEach { $0(wrappedValue) }

        if !receivedFromBinding {
            bindingObserver?(wrappedValue)
        }

        receivedFromBinding = false
    }

    private func observeBinding(_ observer: @escaping Observer) {
        bindingObserver = observer
    }

    private func receiveFromBinding(_ value: Value) {
        receivedFromBinding = true
        wrappedValue = value
    }

    func observe(_ observer: @escaping Observer) {
        observer(wrappedValue)

        observers.append(observer)
    }

    func clearObservers() {
        observers = []
    }

    func bind<BindableType: Bindable>(with bindable: BindableType) where BindableType.BindingValue == Value {

        observeBinding {
            bindable.binding.receiveFromBinding($0)
        }

        bindingObserver?(wrappedValue)
    }
}
