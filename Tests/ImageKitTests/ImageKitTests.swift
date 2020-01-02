import XCTest
@testable import ImageKit
@testable import DataPersistence

final class ImageKitTests: XCTestCase {
    
  func testFetchImageFromOnline() {
    // arrange
    let exp = XCTestExpectation(description: "fetched image")
    let imageURLString = "https://developer.apple.com/swift/images/swift-og.png"
    let imageView = UIImageView()
    
    // act
    imageView.getImage(with: imageURLString) { [weak imageView] result in
      switch result {
      case .failure:
        XCTFail("failed to fetch image at url: \(imageURLString)")
      case .success(let image):
        DispatchQueue.main.async {
          imageView?.image = image
        }
        // assert
        XCTAssertNotNil(image)
        exp.fulfill()
      }
    }
    
    wait(for: [exp], timeout: 5.0)
  }
}
