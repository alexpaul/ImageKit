# ImageKit

Handles getting an image from the network and caches image to caches directory or documents.

[Version Releases](https://github.com/alexpaul/ImageKit/releases)

## Requirements 

* Xcode 10.2+ 
* Swift 5.0+ 

## Installation 

Currently ImageKit only has support for Swift package manager. To install copy this github url ```https://github.com/alexpaul/ImageKit``` and navigate to Xcode. Once in Xcode select File -> Swift Packages -> Add Package Dependency and paste the copied url into the search field in the presented dialog. In the Choose Package Options select the Version Rules option which should be the presented default choice and click Next then Finish. At this point the package should have been installed successfully. 

## Swift Package Dependencies 

* [NetworkHelperSPM](https://github.com/alexpaul/NetworkHelperSPM) - for making network requests to fecth image
* [DataPersistence](https://github.com/alexpaul/DataPersistence) - to persists image in cache or documents directory

## Usage 

```swift 
imageView.getImage(with: imageURL) { (result) in
  switch result {
  case .failure:
    DispatchQueue.main.async {
      self.imageView.image = UIImage(systemName: "exclamationmark.triangle.fill")
    }
  case .success(let image):
    DispatchQueue.main.async {
      self.imageView.image = image
    }
  }
}

```
