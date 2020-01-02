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
    imageView.getImage(with: imageURLString, writeTo: .documentsDirectory) { [weak imageView] result in
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
  
  func testFetchImageFromDirectory() {
    // arrange
    let imageURLString = "https://developer.apple.com/swift/images/swift-og.png"
    let imageView = UIImageView()
    
    guard let url = URL(string: imageURLString) else {
      XCTFail("bad image url: \(imageURLString)")
      return
    }
      
    let filename = url.lastPathComponent
        
    // act
    guard let image = imageView.cachedImage(for: filename, directory: .documentsDirectory) else {
      XCTFail("no cached iamge found at path")
      return
    }
    
    // assert
    XCTAssertNotNil(image)
    
  }
}
