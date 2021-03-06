// swiftlint:disable identifier_name trailing_comma
#if !canImport(ObjectiveC)
import XCTest

extension DataBindingTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__DataBindingTests = [
        ("testClearObservers", testClearObservers),
        ("testsMultipleObservers", testsMultipleObservers),
        ("testValueIsEmitted", testValueIsEmitted),
        ("testWaitForNextValue", testWaitForNextValue),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DataBindingTests.__allTests__DataBindingTests),
    ]
}
#endif
