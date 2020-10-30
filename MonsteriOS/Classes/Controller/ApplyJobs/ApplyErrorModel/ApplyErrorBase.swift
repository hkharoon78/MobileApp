
//
//  ApplyErrorBase.swift
//  MonsteriOS
//
//  Created by ishteyaque on 29/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//
import Foundation
public class ApplyErrorBase {
	public var appName : String?
	public var appVersion : String?
	public var errorCode : String?
	public var errorMessage : String?
	public var payload : Payload?

    public class func modelsFromDictionaryArray(array:NSArray) -> [ApplyErrorBase]
    {
        var models:[ApplyErrorBase] = []
        for item in array
        {
            models.append(ApplyErrorBase(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		appName = dictionary["appName"] as? String
		appVersion = dictionary["appVersion"] as? String
		errorCode = dictionary["errorCode"] as? String
		errorMessage = dictionary["errorMessage"] as? String
		if (dictionary["payload"] != nil) { payload = Payload(dictionary: dictionary["payload"] as! NSDictionary) }
	}

}

public class ApplySuccessModel{
    public var job:JoblistingData?
    public var next:String?
    public var responseType:String?
    
    required public init?(dictionary: NSDictionary) {
        next = dictionary["next"] as? String
        responseType = dictionary["responseType"] as? String
        if (dictionary["job"] != nil) { job = JoblistingData(dictionary: dictionary["job"] as! NSDictionary) }
    }

}
