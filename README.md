# Yoke

![Build Status](https://github.com/sambae/Yoke/workflows/build/badge.svg)

A lightweight data binding library in Swift for iOS. Yoke provides a simple API through a property wrapper called `@DataBinding` which can be observed from your view controllers and bound to UIKit widgets.

#### Currently supports two way bindings for:
| Widget   | Properties | Event            |
|----------|------------| -----------------|
| UIButton |            | `.touchUpInside` |
| UISwitch | `isOn`     | `.valueChanged`  |

## Usage

#### Binding

You can bind to any property on any UI widget (or any object that conforms to `NSObject`) using
`bind(to:on:)` which takes a key path and an object and applies changes using KVC.

You can also create a two way binding with supported widgets using `twoWayBind(with:)`.

In your view model:
```swift
@DataBinding private(set) var title = "title"
@DataBinding private(set) var isEnabled = false

init {
    $isEnabled.observe {
        // Do something when user toggles the bound switch
    }
}
```

From your view controller:
```swift
let titleLabel = UILabel()
let toggle = UISwitch()

func setupViews() {
    viewModel.$title
        .map { Optional($0) }
        .bind(to: \.text, on: titleLabel)

    toggle.bind(with: viewModel.$isEnabled)
}
```

#### Observation
`@DataBinding` can also be used as a regular observable type.

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

## Using in tandem with futures

You can extend your favorite `Future` library to work seemlessly with Yoke.

Given a future type:
```swift
class Future<Value, Error> { /* ... */ }
```

Add a method that assigns the success value to a `DataBinding` object's `wrappedValue` property:
```swift
@discardablResult
func assign(to binding: DataBinding<Value>) -> Future<Value, Error> {
    onSuccess { binding.wrappedValue = $0 }

    return self
}
```

Once implemented, make requests from your view model:
```swift
@DataBinding var contacts: [Contact] = []

func fetchContacts() {
    service.fetchContacts()
        .receive(on: .main)
        .assign(to: $contacts)
}
```
