#if !os(macOS)
import UIKit
import XCTest
@testable import Yoke

class UIKitExtensionTests: XCTestCase {
    var viewModel: MockViewModel!

    override func setUp() {
        super.setUp()

        viewModel = MockViewModel()
    }

    override func tearDown() {
        super.tearDown()

        viewModel = nil
    }

    func testUILabelBinding() {
        let label = UILabel()
        XCTAssertNil(label.text)

        viewModel.$testString.bind(with: label)
        XCTAssertEqual(label.text, "")

        let newString = "new string"
        viewModel.testString = newString
        XCTAssertEqual(label.text, newString)
    }

    func testUISwitchBinding() {
        let toggle = UISwitch()
        XCTAssertFalse(toggle.isOn)

        viewModel.$testBool.bind(with: toggle)
        XCTAssertTrue(toggle.isOn)

        viewModel.testBool = false
        XCTAssertFalse(toggle.isOn)
    }
}

class MockViewModel {
    @DataBinding var testBool = true
    @DataBinding var testString = ""
}

#endif
