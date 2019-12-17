# Yoke

A lightweight data binding library in Swift for iOS. Great for those times
when you want to observe changes in your view models and bind them to UI
but want to avoid pulling in a heavy FRP library. Yoke provides a simple API
through a property wrapper called `DataBinding`  which can be observed from
your view controllers.

## Usage

#### Observation
In your view model:
```swift
@DataBinding private(set) var contacts: [Contact] = []

func loadData() {
    service.fetchContacts(completion: { contacts in
        self.contacts = contacts
    })
}
```

From your view controller:
```swift
override func viewDidLoad() {
    super.viewDidLoad()

    viewModel.$contacts.observe { contacts in
        /* Do something with contact data */
    }
}
```

#### Binding

### Using in tandem with futures

You can extend your favorite `Future` library to work seemlessly with Yoke.

Given a future type:
```swift
class Future<Value, Error> { /* ... */ }
```

An example implemention might look something like:
```swift
@discardablResult
func assign(to binding: DataBinding<Value>) -> Future<Value, Error> {
    onSuccess { binding.wrappedValue = $0 }

    return self
}
```

Once implemented, you can make requests from your view models like so:
```swift
@DataBinding var contacts: [Contact] = []

func fetchContacts() {
    service.fetchContacts()
        .receive(on: .main)
        .assign(to: $contacts)
}
```
