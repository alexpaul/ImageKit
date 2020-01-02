//
//  UIImage+Extensions.swift
//  NYTBestsellers
//
//  Created by Alex Paul on 12/21/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit
import NetworkHelper // NetworkHelper is a SPM dependency
import DataPersistence

extension UIImageView {
  // saves image data to the caches directory
  private func write(to directory: Directory,
                     image: UIImage,
                     path: String) {
    // get the caches directory and use the last component above to create a file path for saving the image data
    let cachesDirectoryURL = FileManager.getCachesDirectory()
    let filepath = cachesDirectoryURL.appendingPathComponent(path)
    
    // convert image to data (png or jpg)
    let imageData = image.pngData()
    
    // write (save) to the caches directory
    try? imageData?.write(to: filepath)
  }
  
  // retrieves an image from the caches directory
  public func cachedImage(for filename: String, directory: Directory = .cachesDirectory) -> UIImage? {
    let directoryURL = directory == .cachesDirectory ? FileManager.getCachesDirectory() : FileManager.getDocumentsDirectory()
 
    let filepath = directoryURL.appendingPathComponent(filename)
    guard FileManager.default.fileExists(atPath: filepath.path) else {
      return nil
    }
    guard let data = FileManager.default.contents(atPath: filepath.path) else {
      return nil
    }
    let image = UIImage(data: data)
    return image
  }
  
  // instance method on a UIImageView gets and image from the caches directory or the netowrk
  public func getImage(with urlString: String,
                       writeTo directory: Directory = .cachesDirectory,
                       completion: @escaping (Result<UIImage, AppError>) -> ()) {
    
    // The UIActivityIndicatorView is used to indicate to the user that a download is in progress
    let activityIndicator = UIActivityIndicatorView(style: .large)
    activityIndicator.color = UIColor.systemOrange
    activityIndicator.startAnimating() // it's hidden until we explicitly start animating
    
    addSubview(activityIndicator) // we add the indicattor as a subview of the image view
    
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
                                 activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
    
    guard let url = URL(string: urlString) else {
      completion(.failure(.badURL(urlString)))
      return
    }
    
    // check the cache
    if let cachedImage = cachedImage(for: url.lastPathComponent) {
      completion(.success(cachedImage))
      activityIndicator.stopAnimating()
      return
    }
    
    let request = URLRequest(url: url)
    
    NetworkHelper.shared.performDataTask(with: request) { [weak activityIndicator, weak self] (result) in
      DispatchQueue.main.async {
        activityIndicator?.stopAnimating()
      }
      switch result {
      case .failure(let appError):
        completion(.failure(.networkClientError(appError)))
      case .success(let data):
        if let image = UIImage(data: data) {
          // cache image
          // get the last path component of the url, we will use this as the filename e.g someImage.jpg
          let lastComponent = url.lastPathComponent
          self?.write(to: directory, image: image, path: lastComponent)
          
          completion(.success(image))
        }
      }
    }
  }
}
