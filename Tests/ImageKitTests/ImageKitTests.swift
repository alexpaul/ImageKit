import XCTest
@testable import ImageKit

final class ImageKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(ImageKit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
