# ImageKit

Handles getting an image from the network and caches image to caches directory or documents.


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
