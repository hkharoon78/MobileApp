//
//  MISRPJobListingViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 09/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import Foundation

public class Experience {
	public var years : String?
	public var months : String?

    public class func modelsFromDictionaryArray(array:NSArray) -> [Experience]
    {
        var models:[Experience] = []
        for item in array
        {
            models.append(Experience(dictionary: item as! NSDictionary)!)
        }
        return models
    }


	required public init?(dictionary: NSDictionary) {

        if let year=dictionary["years"] as? Int{
            years=String(year)
        }else{
		years = dictionary["years"] as? String
        }
        if let month=dictionary["months"] as? Int{
            months=String(month)
        }else{
            months = dictionary["months"] as? String
        }
		
	}

		

}
