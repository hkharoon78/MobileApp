//
//  MISRPJobListingViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 09/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import Foundation


public class Paging {
	public var cursors : Cursors?
	public var nextUrl : String?
	public var previousUrl : String?
	public var total : Int?
	public var limit : Int?


    public class func modelsFromDictionaryArray(array:NSArray) -> [Paging]
    {
        var models:[Paging] = []
        for item in array
        {
            models.append(Paging(dictionary: item as! NSDictionary)!)
        }
        return models
    }


	required public init?(dictionary: NSDictionary) {

		if let cursoDict=dictionary["cursors"] as? NSDictionary{ cursors = Cursors(dictionary:cursoDict) }
		nextUrl = dictionary["nextUrl"] as? String
		previousUrl = dictionary["previousUrl"] as? String
		total = dictionary["total"] as? Int
		limit = dictionary["limit"] as? Int
	}

}
