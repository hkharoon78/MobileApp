
//
//  Payload.swift
//  MonsteriOS
//
//  Created by ishteyaque on 29/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//
import Foundation

public class Payload {
	public var result : Result?


    public class func modelsFromDictionaryArray(array:NSArray) -> [Payload]
    {
        var models:[Payload] = []
        for item in array
        {
            models.append(Payload(dictionary: item as! NSDictionary)!)
        }
        return models
    }


	required public init?(dictionary: NSDictionary) {

		if (dictionary["result"] != nil) { result = Result(dictionary: dictionary["result"] as! NSDictionary) }
	}

		

	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.result?.dictionaryRepresentation(), forKey: "result")

		return dictionary
	}

}
