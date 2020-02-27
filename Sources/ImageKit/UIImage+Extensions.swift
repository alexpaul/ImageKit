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
    let directoryURL = directory == .cachesDirectory ? FileManager.getCachesDirectory() : FileManager.getDocumentsDirectory()
    let filepath = directoryURL.appendingPathComponent(path)
    
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
    var activityIndicator: UIActivityIndicatorView!
    DispatchQueue.main.async {
      activityIndicator = UIActivityIndicatorView(style: .large)
      activityIndicator = UIActivityIndicatorView(style: .large)
      activityIndicator.color = UIColor.systemOrange
      activityIndicator.startAnimating() // it's hidden until we explicitly start animating
      
      self.addSubview(activityIndicator) // we add the indicattor as a subview of the image view
      
      activityIndicator.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                                   activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
      ])
    }
    
    guard let url = URL(string: urlString) else {
      completion(.failure(.badURL(urlString)))
      DispatchQueue.main.async {
        activityIndicator.stopAnimating()
      }
      return
    }
    
    // check the cache
    let filename = createComponentString(from: url)
    if let cachedImage = cachedImage(for: filename, directory: directory) {
      completion(.success(cachedImage))
      DispatchQueue.main.async {
        activityIndicator.stopAnimating()
      }
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
          // cache image to disk
          let componentStr = self?.createComponentString(from: url) ?? ""
          self?.write(to: directory, image: image, path: componentStr)
          
          completion(.success(image))
        }
      }
    }
  }
  
  private func createComponentString(from url: URL) -> String {
    var componentStr = ""
    for component in url.pathComponents where component != "/" {
      componentStr += component
    }
    return componentStr
  }
}
