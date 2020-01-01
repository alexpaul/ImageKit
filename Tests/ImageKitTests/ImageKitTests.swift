import XCTest
@testable import ImageKit

final class ImageKitTests: XCTestCase {
  func testFetchImageFromOnline() {
    // arrange
    let exp = XCTestExpectation(description: "fetched image")
    let imageURLString = "https://developer.apple.com/swift/images/swift-og.png"
    let imageView = UIImageView()
    
    // act
    imageView.getImage(with: imageURLString, writeTo: .documentsDirectory) { [weak imageView] result in
      switch result {
      case .failure:
        XCTFail("failed to fetch image at url: \(imageURLString)")
      case .success(let image):
        DispatchQueue.main.async {
          imageView?.image = image
        }
        XCTAssertNotNil(image)
        exp.fulfill()
      }
    }
    
    wait(for: [exp], timeout: 5.0)
  }
}
