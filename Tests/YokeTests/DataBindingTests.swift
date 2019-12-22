import XCTest
@testable import Yoke

final class DataBindingTests: XCTestCase {
    var viewModel: MockViewModel!
    var result: Bool?

    override func setUp() {
        super.setUp()

        viewModel = MockViewModel()
    }

    override func tearDown() {
        super.tearDown()

        viewModel = nil
        result = nil
    }

    func testValueIsEmitted() {
        viewModel.$testBool.observe {
            self.result = $0
        }
        XCTAssertTrue(result ?? false)

        viewModel.testBool = !viewModel.testBool
        XCTAssertEqual(result, viewModel.testBool)
    }

    func testWaitForNextValue() {
        viewModel.$testBool.observe(waitForNextValue: true) {
            self.result = $0
        }
        XCTAssertNil(result)

        viewModel.testBool = !viewModel.testBool
        XCTAssertEqual(result, viewModel.testBool)
    }

    func testClearObservers() {
        viewModel.$testBool.observe {
            self.result = $0
        }
        XCTAssertNotNil(result)

        viewModel.$testBool.clearObservers()
        viewModel.testBool = !viewModel.testBool
        XCTAssertEqual(result, !viewModel.testBool)
    }

    func testMultipleObservers() {
        var result1: Bool?
        var result2: Bool?
        var result3: Bool?

        viewModel.$testBool.observe {
            result1 = $0
        }

        XCTAssertNotNil(result1)
        XCTAssertNil(result2)
        XCTAssertNil(result3)

        viewModel.$testBool.observe {
            result2 = $0
        }
        viewModel.$testBool.observe {
            result3 = $0
        }

        XCTAssertNotNil(result2)
        XCTAssertNotNil(result3)

        viewModel.testBool = !viewModel.testBool

        XCTAssertEqual(result1, viewModel.testBool)
        XCTAssertEqual(result2, viewModel.testBool)
        XCTAssertEqual(result3, viewModel.testBool)
    }

    func testMap() {
        var stringResult = ""
        let expectedResult = "true"

        viewModel.$testBool
            .map { "\($0)" }
            .observe { stringResult = $0 }

        XCTAssertEqual(stringResult, expectedResult)
    }

    func testFlatMap() {
        var stringResult = ""
        let expectedResult = "result"

        viewModel.$testBool
            .flatMap { _ in self.viewModel.$testString }
            .observe { stringResult = $0 }

        viewModel.testString = expectedResult
        XCTAssertEqual(stringResult, "")

        viewModel.testBool = false
        XCTAssertEqual(stringResult, expectedResult)
    }
}
