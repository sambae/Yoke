#if !os(macOS)
import UIKit
import XCTest
@testable import Yoke

final class UIKitBindableTests: XCTestCase {
    var viewModel: MockViewModel!

    override func setUp() {
        super.setUp()

        viewModel = MockViewModel()
    }

    override func tearDown() {
        super.tearDown()

        viewModel = nil
    }

    func testUIViewBinding() {
        let view = UIView()
        viewModel.testBool = false

        viewModel.$testBool
            .bind(to: \.isHidden, on: view)
        XCTAssertEqual(view.isHidden, false)

        viewModel.testBool = true
        XCTAssertEqual(view.isHidden, true)
    }

    func testUILabelBinding() {
        let label = UILabel()
        XCTAssertNil(label.text)

        viewModel.$testString
            .map { Optional($0) }
            .bind(to: \.text, on: label)

        XCTAssertEqual(label.text, "")

        let newString = "new string"
        viewModel.testString = newString
        XCTAssertEqual(label.text, newString)
    }

    func testUISwitchBinding() {
        let toggle = UISwitch()
        XCTAssertFalse(toggle.isOn)

        toggle.bind(with: viewModel.$testBool)
        XCTAssertTrue(toggle.isOn)

        viewModel.testBool = false
        XCTAssertFalse(toggle.isOn)
    }

    func testUIButtonBinding() {
        let button = UIButton()
        viewModel.testBool = false

        viewModel.$testBool
            .bind(to: \.isEnabled, on: button)
        XCTAssertEqual(button.isEnabled, false)

        viewModel.testBool = true
        XCTAssertEqual(button.isEnabled, true)
    }
}
#endif
