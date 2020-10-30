
//
//  MISRPJobListingViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 09/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//
import Foundation

public class Applicants {
	public var profileId : Int?
	public var seekerId : Int?
	public var uuid : Int?
	public var appliedAt : Int?
    public class func modelsFromDictionaryArray(array:NSArray) -> [Applicants]
    {
        var models:[Applicants] = []
        for item in array
        {
            if item is NSDictionary{
            models.append(Applicants(dictionary: item as! NSDictionary)!)
            }
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		profileId = dictionary["profileId"] as? Int
		seekerId = dictionary["seekerId"] as? Int
		uuid = dictionary["uuid"] as? Int
		appliedAt = dictionary["appliedAt"] as? Int
	}



}
