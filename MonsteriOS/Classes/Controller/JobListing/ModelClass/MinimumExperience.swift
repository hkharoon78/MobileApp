//
//  MISRPJobListingViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 09/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import Foundation
 


public class MinimumExperience {
	public var years : Int?
	public var months : Int?


    public class func modelsFromDictionaryArray(array:NSArray) -> [MinimumExperience]
    {
        var models:[MinimumExperience] = []
        for item in array
        {
            models.append(MinimumExperience(dictionary: item as! NSDictionary)!)
        }
        return models
    }


	required public init?(dictionary: NSDictionary) {

		years = dictionary["years"] as? Int
		months = dictionary["months"] as? Int
	}



}
