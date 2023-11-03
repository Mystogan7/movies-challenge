//
//  ImageCache.swift
//  iOSMoviesApplicationChallenge
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 02/11/2023.
//

import UIKit

class ImageLoader {
    static let shared = ImageLoader()
    private let memoryCache = NSCache<NSURL, UIImage>()
    private var ongoingTasks: [URL: URLSessionDataTask] = [:]
    
    private var diskCacheURL: URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("imageCache")
    }
    
    private init() {
        try? FileManager.default.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = memoryCache.object(forKey: url as NSURL) {
            completion(cachedImage)
            return
        }
        
        let fileURL = diskCacheURL.appendingPathComponent(url.lastPathComponent)
        if let cachedImage = UIImage(contentsOfFile: fileURL.path) {
            memoryCache.setObject(cachedImage, forKey: url as NSURL)
            completion(cachedImage)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            DispatchQueue.global(qos: .background).async {
                try? data.write(to: fileURL, options: .atomic)
                
                self?.memoryCache.setObject(image, forKey: url as NSURL)
                
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
        task.resume()
        ongoingTasks[url] = task
    }
    
    func cancelOngoingTask(for url: URL) {
        ongoingTasks[url]?.cancel()
        ongoingTasks.removeValue(forKey: url)
    }
}

extension UIImageView {
    private struct AssociatedKeys {
        static var imageURL = "imageURL"
    }
    
    var imageURL: URL? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.imageURL) as? URL
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.imageURL, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
