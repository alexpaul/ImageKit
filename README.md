# ImageKit

Handles getting an image from the network and caches image to caches directory or documents.

[Version Releases](https://github.com/alexpaul/ImageKit/releases)

## Requirements 

* Xcode 10.2+ 
* Swift 5.0+ 

## Swift Package Installation 

To install copy this github url
```https://github.com/alexpaul/ImageKit```  
Navigate to Xcode and do the following: 
 - select **File -> Swift Packages -> Add Package Dependency** 
 - paste the copied url above into the search field in the presented dialog
 - In the **Choose Package Options** select the Version Rules option (default option). Version rules will update Swift packages based on their relesase versions e.g 1.0.1
 
 Click Next then Finish. 
 At this point the package should have been installed successfully 🥳 
 

## Swift Package Dependencies 

* [NetworkHelperSPM](https://github.com/alexpaul/NetworkHelperSPM) - for making network requests to fecth image
* [DataPersistence](https://github.com/alexpaul/DataPersistence) - to persists image in cache or documents directory

## Usage 

By default images are cached to avoid making additional network requests. Cache is purged by iOS as needed. If you need to permanently save images you can override the the default directory from default argument .cachesDirectory to .documentsDirectory as follows ```getImage(with: imageURL, writeTo: .documentsDirectory))```

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

## License 

ImageKit is released under the MIT license. See [LICENSE](https://github.com/alexpaul/ImageKit/blob/master/LICENSE) for details.

