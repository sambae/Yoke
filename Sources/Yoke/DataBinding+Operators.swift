extension DataBinding {

    func map<NewValue>(_ transform: @escaping (Value) -> NewValue) -> DataBinding<NewValue> {
        return flatMap {
            DataBinding<NewValue>(wrappedValue: transform($0))
        }
    }

    func flatMap<NewValue>(_ transform: @escaping (Value) -> DataBinding<NewValue>) -> DataBinding<NewValue> {
        let newBinding = DataBinding<NewValue>(wrappedValue: transform(wrappedValue).wrappedValue)

        observe {
            newBinding.wrappedValue = transform($0).wrappedValue
        }

        return newBinding
    }

    @discardableResult
    func also(_ sideEffects: @escaping (Value) -> Void) -> DataBinding<Value> {
        return map {
            sideEffects($0)
            return $0
        }
    }

    func bind(with binding: DataBinding<Value>) {
        observeBinding {
            binding.receiveFromBinding($0)
        }

        bindingObserver?(wrappedValue)
    }

    func twoWayBind(with binding: DataBinding<Value>) {
        binding.observeBinding {
            self.receiveFromBinding($0)
        }

        bind(with: binding)
    }

    @discardableResult
    func bind<Object>(to keyPath: ReferenceWritableKeyPath<Object, Value>, on object: Object) -> DataBinding<Value> {
        return also {
            object[keyPath: keyPath] = $0
        }
    }
}
