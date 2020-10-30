//
//  Result.swift
//  MonsteriOS
//
//  Created by ishteyaque on 29/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import Foundation

public class Result {
	public var identifier : String?
	public var next : String?
    public var pendingActions:Array<MIPendingItemModel>?
    public var profiles:Array<MIExistingProfileInfo>?
    public var screeningQuestionnaire:ScreeningQuestionnaire?
    public var job:JoblistingData?
    public class func modelsFromDictionaryArray(array:NSArray) -> [Result]
    {
        var models:[Result] = []
        for item in array
        {
            models.append(Result(dictionary: item as! NSDictionary)!)
        }
        return models
    }


	required public init?(dictionary: NSDictionary) {

		identifier = dictionary["identifier"] as? String
		next = dictionary["next"] as? String
        if let penDing=dictionary["pendingActions"]as?[[String:Any]]{
            self.pendingActions=MIPendingItemModel.modelsFromDictionaryArray(array: penDing)
        }
        if let profile=dictionary["profiles"]as?[[String:Any]]{
            self.profiles=MIExistingProfileInfo.modelsFromDictionaryArray(array: profile)
        }
        if let screeningQuestionnaire=dictionary["screeningQuestionnaire"]as?[String:Any]{
            self.screeningQuestionnaire=ScreeningQuestionnaire(dictionary: screeningQuestionnaire as NSDictionary)
        }
        if let jobData=dictionary["job"]as?[String:Any]{
           self.job=JoblistingData(dictionary: jobData as NSDictionary)
        }
	}

	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.identifier, forKey: "identifier")
		dictionary.setValue(self.next, forKey: "next")

		return dictionary
	}

}

public class ScreeningQuestionnaire {
    public var questionnaireId : Int?
    public var questions : Array<Questions>?
    public var acceptedWeight : Int?
    public var title : String?
    public class func modelsFromDictionaryArray(array:NSArray) -> [ScreeningQuestionnaire]
    {
        var models:[ScreeningQuestionnaire] = []
        for item in array
        {
            models.append(ScreeningQuestionnaire(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary) {
        questionnaireId = dictionary["questionnaireId"] as? Int
        if (dictionary["questions"] != nil) { questions = Questions.modelsFromDictionaryArray(array: dictionary["questions"] as! NSArray) }
        acceptedWeight = dictionary["acceptedWeight"] as? Int
        title = dictionary["title"] as? String
    }
    
    
}
public class Questions {
    public var question : String?
    public var weightage : Int?
    public var answer : String?
    public var questionNumber : String?
    public var type : String?
    public var indexpath=0
    public class func modelsFromDictionaryArray(array:NSArray) -> [Questions]
    {
        var models:[Questions] = []
        for item in array
        {
            models.append(Questions(dictionary: item as! NSDictionary)!)
        }
        return models
    }
   
    required public init?(dictionary: NSDictionary) {
        question = dictionary["question"] as? String
        weightage = dictionary["weightage"] as? Int
       // answer = dictionary["answer"] as? String
        questionNumber = dictionary["questionNumber"] as? String
        type = dictionary["type"] as? String
    }
    
}
