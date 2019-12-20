@propertyWrapper
class DataBinding<Value> {
    typealias Observer = (Value) -> Void

    private var observers: [Observer] = []
    private var bindingObserver: Observer?
    private var receivedFromBinding = false
    private var emitOnObserve = true

    var wrappedValue: Value {
        didSet { emitValue() }
    }
    var projectedValue: DataBinding<Value> { self }

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

    func observe(waitForNextValue: Bool = false, _ observer: @escaping Observer) {
        observers.append(observer)

        if !waitForNextValue {
            observer(wrappedValue)
        }
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

    func twoWayBind<BindableType: TwoWayBindable>(with bindable: BindableType)
    where BindableType.BindingValue == Value {

        bindable.addBindingTarget()

        bindable.binding.observeBinding {
            self.receiveFromBinding($0)
        }

        bind(with: bindable)
    }
}
