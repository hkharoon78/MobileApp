//
//  MISRPJobListingViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 09/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import Foundation
public class Meta {
	public var paging : Paging?
	public var resultId : String?
    public var version = "V1"

//    public class func modelsFromDictionaryArray(array:NSArray) -> [Meta]
//    {
//        var models:[Meta] = []
//        for item in array
//        {
//            models.append(Meta(dictionary: item as! NSDictionary)!)
//        }
//        return models
//    }


	required public init?(dictionary: NSDictionary) {

		if (dictionary["paging"] != nil) { paging = Paging(dictionary: dictionary["paging"] as! NSDictionary) }
		resultId = dictionary["resultId"] as? String
        
        if let ver = dictionary.value(forKey: "version") as? String {
            version = ver
        }
//        if let session=dictionary["sessionId"] as? String{
//           sessionId=session
//        }
        
	}

		


}
