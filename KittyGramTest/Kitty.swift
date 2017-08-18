//
//  Kitty.swift
//  KittyGramTest
//
//  Created by Gabor on 06/07/2017.
//  Copyright © 2017 Gabor. All rights reserved.
//

import Foundation

public class Kitty: NSObject, NSCoding {

    let id: String
    let url: String
    var isLiked: Bool?
    
    init(id: String, url: String, isLiked: Bool? = false) {
        self.id = id
        self.url = url
        self.isLiked = isLiked
    }
    
    required public init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as! String
        self.url = aDecoder.decodeObject(forKey: "url") as! String
        self.isLiked = aDecoder.decodeObject(forKey: "isLiked") as? Bool ?? false
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.url, forKey: "url")
        aCoder.encode(self.isLiked, forKey: "isLiked")
    }

}
