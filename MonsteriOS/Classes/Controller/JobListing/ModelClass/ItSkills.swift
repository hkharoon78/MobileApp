//
//  MISRPJobListingViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 09/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import Foundation


public class ItSkills {
    public var id : String?
    public var text : String?
    public var version : String?
    public var lastUsed : String?
    public var experience : Experience?
    
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [ItSkills]
    {
        var models:[ItSkills] = []
        for item in array
        {
            models.append(ItSkills(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    
    required public init?(dictionary: NSDictionary) {
        
        id = dictionary["id"] as? String
        text = (dictionary["text"] as? String ?? "")?.withoutWhiteSpace()
        let aphbet = NSCharacterSet.letters
        let digits = NSCharacterSet.decimalDigits
        
        let rangedigit = text?.rangeOfCharacter(from: digits)
        let rangeaphbet = text?.rangeOfCharacter(from: aphbet)
        
        if rangedigit == nil  && rangeaphbet == nil{
            text = ""
        }
        version = dictionary["version"] as? String
        lastUsed = dictionary["lastUsed"] as? String
        if (dictionary["experience"] != nil) { experience = Experience(dictionary: dictionary["experience"] as! NSDictionary) }
    }
    
    
    
}
