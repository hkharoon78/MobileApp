//
//  MISRPJobListingViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 09/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import Foundation

public class Cursors {
	public var next : String?
	public var previous : String?

    public class func modelsFromDictionaryArray(array:NSArray) -> [Cursors]
    {
        var models:[Cursors] = []
        for item in array
        {
            models.append(Cursors(dictionary: item as! NSDictionary)!)
        }
        return models
    }


	required public init?(dictionary: NSDictionary) {

		next = dictionary["next"] as? String
		previous = dictionary["previous"] as? String
	}

		
}
