//
//  MISRPJobListingViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 09/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//
import Foundation

public class Location {
	public var city : String?
	public var country : String?
	public var state : String?
	public var zone : String?


    public class func modelsFromDictionaryArray(array:NSArray) -> [Location]
    {
        var models:[Location] = []
        for item in array
        {
            models.append(Location(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		city = dictionary["city"] as? String
		country = dictionary["country"] as? String
		state = dictionary["state"] as? String
		zone = dictionary["zone"] as? String
	}

		

}
