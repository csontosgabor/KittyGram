//
//  Service.swift
//  KittyGramTest
//
//  Created by Gabor on 06/07/2017.
//  Copyright © 2017 Gabor. All rights reserved.
//

import Foundation

struct Service {
    
    var apiKey = ""//get an own key @ http://thecatapi.com/api-key-registration.html
    var getKittiesUrl = "http://thecatapi.com/api/images/get?format=xml&results_per_page=20"
    var getFavouriteUrl = "http://thecatapi.com/api/images/getfavourites?api_key="
    var favouriteUrl = "http://thecatapi.com/api/images/favourite?api_key="
    
    static let sharedInstance = Service()
    let networkError = NSError(domain: "http://thecatapi.com", code: 1, userInfo: [NSLocalizedDescriptionKey:"Ups, it seems your network is down."])
    
    func fetchKitties(userId: String, completionHandler:@escaping (KittyDatasource?, Error?) -> ()) {
        let url = URL(string: getFavouriteUrl + "\(apiKey)&sub_id=\(userId)")!
        let parser = ParserXML(url: url)
        var likedKittyArray = [String]()
        // We need to make two API calls here.
        parser.parse(completion: { success in
            if success {
                //1. Fetch the already liked cat pictures ids and save it in an array
                for object in parser.objects {
                    if let id = object["id"] {
                        likedKittyArray.append(id)
                    }
                }//2. Fetch random cat images and pass to the parser
                let url = URL(string: self.getKittiesUrl)!
                let parser = ParserXML(url: url, favArray: likedKittyArray)
                parser.parse(completion: { success in
                    if success {
                        //passing random cat images, with the liked values!
                        let kitties = try! KittyDatasource(objects: parser.objects)
                        completionHandler(kitties, nil)
                    } else {
                        completionHandler(nil,self.networkError)
                    }
                })
            } else {
                 completionHandler(nil,self.networkError)
            }
        })
    }
    //fething liked kitties
    func fetchLikedKitties(userId: String, completionHandler:@escaping (KittyDatasource?, Error?) -> ()) {
        let url = URL(string: getFavouriteUrl + "\(apiKey)&sub_id=\(userId)")!
        let parser = ParserXML(url: url)
        parser.parse(completion: { success in
            if success {
                //passing random cat images, with the liked values!
                let kitties = try! KittyDatasource(objects: parser.objects)
                completionHandler(kitties, nil)
            }
            completionHandler(nil,self.networkError)
        })
    }
    //like/dislike a kitty
    func likeKitty(_ like: Bool, userId: String, catId: String, completionHandler:@escaping (Bool) ->()) {
        var urlString = favouriteUrl + "\(apiKey)&sub_id=\(userId)&image_id=\(catId)"//likeing
        if !like { //disliking
            urlString = urlString+"&action=remove"
        }
        if Reachability.shared.isConnectedToNetwork() {
        let url = URL(string: urlString)!
        let task =  URLSession(configuration: .default).dataTask(with: url, completionHandler: {(data, response, error) in
            if error == nil {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        });
        task.resume()
        } else {
             completionHandler(false)
        }
    }
}

