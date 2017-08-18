//
//  CatchedImageView.swift
//  KittyGramTest
//
//  Created by Gabor on 06/07/2017.
//  Copyright © 2017 Gabor. All rights reserved.
//

import Foundation
import UIKit

open class CatchedImageView: UIImageView {
    
    open static let imageCache = NSCache<NSString, DiscardableImageCacheItem>()
    private var urlStringForChecking: String?
    
    open func loadImageFromURL(_ urlString: String, completion: (() -> ())? = nil){
        self.image = nil
        self.urlStringForChecking = urlString
        let urlKey = urlString as NSString
        
        if let imageFromCache = CatchedImageView.imageCache.object(forKey: urlKey) {
            self.image = imageFromCache.image
            completion?()
            return
        }
        
        if urlString.contains(".gif") { // The app doesn't support GIF files yet.
            self.image = UIImage(named: "no_gif_error")
            completion?()
            return
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            if error != nil {
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    let cacheItem = DiscardableImageCacheItem(image: image)
                    CatchedImageView.imageCache.setObject(cacheItem, forKey: urlKey)
                    
                    if urlString == self?.urlStringForChecking {
                        self?.image = image
                        completion?()
                    }
                }
            }
            
        }).resume()
    }
    
    public init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
        self.backgroundColor = UIColor(white: 0.95, alpha: 1)
        self.contentMode = .scaleAspectFill
    }
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
