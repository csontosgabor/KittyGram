//
//  KittyDatasource.swift
//  KittyGramTest
//
//  Created by Gabor on 07/07/2017.
//  Copyright © 2017 Gabor. All rights reserved.
//

import Foundation


open class KittyDatasource: NSObject {
    
    var kitties: [Kitty]?
    //creating kittiesArray from the objects of XMLParser
    required public init(objects: [Dictionary<String,String>]) throws {
        var kitties = [Kitty]()
      
        for kitty in objects {
            guard let id = kitty["id"] , let url = kitty["url"] else { return }
            let newKitty = Kitty(id: id, url: url)
            if let _ = kitty["liked"] {
                newKitty.isLiked = true 
            }
            kitties.append(newKitty)
        }
        self.kitties = kitties
    }
    
    open func kittyAtIndex(_ index: Int) -> Kitty? {
        return kitties?[index] 
    }
    
    open func numberOfSections() -> Int {
        return 1
    }
    
    open func numberOfItems() -> Int {
        return kitties?.count ?? 0
    }
    //using in KittyViewController
    open func likeTouched(_ catId: String, isLiked: Bool){
        if let kitties = kitties {
            kitties.filter({$0.id == catId}).forEach { $0.isLiked = isLiked }
            self.kitties = kitties
        }
    }
    //removing offline data in FavKittyViewController
    open func removeLikedCat(_ catId: String) {
        if let kitties = kitties {
           self.kitties = kitties.filter(){$0.id != catId}
        }
    }
    //storing fetched datas into memory
    open func storeFetchedKitties(isFromFeed: Bool) {
        guard let kittiesToStore = self.kitties else { return }
        let datasource = NSKeyedArchiver.archivedData(withRootObject: kittiesToStore)
        if isFromFeed {
            UserDefaults.standard.removeObject(forKey: "feedKittyArray")
            UserDefaults.standard.set(datasource, forKey: "feedKittyArray")
        } else {
            UserDefaults.standard.removeObject(forKey: "likedKittyArray")
            UserDefaults.standard.set(datasource, forKey: "likedKittyArray")
        }
    }
    //fetching stored data from memory
    open func loadFetchedKitties(isFromFeed: Bool) {
        let storedData: NSData?
        
        if isFromFeed {
            storedData = UserDefaults.standard.object(forKey: "feedKittyArray") as? NSData
        } else {
            storedData = UserDefaults.standard.object(forKey: "likedKittyArray") as? NSData
        }
        if let dataSource = storedData {
            let savedKitties = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(dataSource) as! [Kitty]
            self.kitties = savedKitties
        }
    }
}
