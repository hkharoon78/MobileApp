//
//  MIExistingProfileInfo.swift
//  MonsteriOS
//
//  Created by Piyush on 26/02/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

public class MIExistingProfileInfo: NSObject {
    public var id = 0
    public var active = false
    public var countryName    = ""
    public var siteContext    = ""
    public var countryIsoCode = ""
    public var title = ""
    
    public class func modelsFromDictionaryArray(array:[[String:Any]]) -> [MIExistingProfileInfo]
    {
        var models:[MIExistingProfileInfo] = []
        for item in array
        {
            if let data = MIExistingProfileInfo(dictionary: item) {
                models.append(data)
            }
            
        }
        return models
    }
    
    required public init?(dictionary: [String:Any]) {
        id = dictionary.intFor(key: "id")
        active = dictionary.booleanFor(key: "active")
        siteContext = dictionary.stringFor(key: "siteContext")
        countryIsoCode = dictionary.stringFor(key: "country")
        countryName = dictionary.stringFor(key: "countryName")
        title = dictionary.stringFor(key: "title")
        
    }
}
