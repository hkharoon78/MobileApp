//
//  MISRPJobListingViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 09/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import Foundation


public class MaximumSalary {
	public var currency : String?
	public var lakhs : Int?
	public var thousands : Int?
    public var absoluteValue:Int?
    public var salaryMode:String?

    public class func modelsFromDictionaryArray(array:NSArray) -> [MaximumSalary]
    {
        var models:[MaximumSalary] = []
        for item in array
        {
            models.append(MaximumSalary(dictionary: item as! NSDictionary)!)
        }
        return models
    }


	required public init?(dictionary: NSDictionary) {

		currency = dictionary["currency"] as? String
		lakhs = dictionary["lakhs"] as? Int
		thousands = dictionary["thousands"] as? Int
        absoluteValue = dictionary["absoluteValue"] as? Int
        salaryMode = dictionary["salaryMode"] as? String
        
        
	}

		

}
