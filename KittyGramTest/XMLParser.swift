//
//  XMLParser.swift
//  KittyGramTest
//
//  Created by Gabor on 07/07/2017.
//  Copyright © 2017 Gabor. All rights reserved.
//

import Foundation

class ParserXML: NSObject, XMLParserDelegate {
    
    var objects = [Dictionary<String,String>]()
    var object = Dictionary<String,String>()
    var inItem = false
    var current = String()
    var url: URL!
    var favouritedArray: [String]?
    
    init(url: URL, favArray: [String]? = nil) {
        self.favouritedArray = favArray
        self.url = url
    }
    
    func parse(completion:@escaping (Bool) -> ()) {
        if Reachability.shared.isConnectedToNetwork() { //checking network connection
            let task =  URLSession(configuration: .default).dataTask(with: self.url, completionHandler: {(data, response, error) in
            if error == nil {
                if let data = data {
                    let parser = XMLParser(data: data)
                    parser.delegate = self
                    parser.parse()
                    completion(true)
                }
            } else {
                    completion(false)
                }
            })
            task.resume()
        } else {
            completion(false)
        }
    }
    
    internal func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "image" {
            object.removeAll(keepingCapacity: false)
            inItem = true
        }
        current = elementName
    }
    
    internal func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "image" {
            inItem = false
            if let idToCheck = object["id"] {

                if let array = favouritedArray {
                    if array.contains(idToCheck) {
                        object["liked"] = "liked"
                    }
                }
            }
            objects.append(object)
        }
    }
    
    internal func parser(_ parser: XMLParser, foundCharacters string: String) {
        if !inItem {
            return
        }
        if let temp = object[current] {
            var tempString = temp
            tempString += string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            object[current] = tempString
        }
        else {
            object[current] = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        }
    }
}
