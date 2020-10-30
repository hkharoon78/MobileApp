//
//  Recuiter.swift
//  MonsteriOS
//
//  Created by ishteyaque on 20/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import Foundation

public class Recruiter {
    
    public var recruiterId : Int?
    public var name : String?
    public var email : String?
    public var companyId : Int?
    public var location : String?
    public var functions : Array<String>?
    public var industries : Array<String>?
    public var levelHiringFor : Array<String>?
    public var skills : Array<String>?
    public var designations:String?
    public var avatarUrl:String?
    public var recruiterUuid:String?
    
    public var id : String?
    public var score : Int?
   
    public var totalWorkExperience : Int?
    public var employments : Array<Employments>?
    public var createdAt : Int?
    public var updatedAt : Int?
   // public var recruiterUuid : String?
    
    public var designation : String?
    public var companyName : String?
    public var phone : String?
    public var followersCount : Int?
    public var clientsHiringFor : Array<String>?
    public var achievements : Array<Achievements>?
    public var lastActiveAt : Int?
    public var imageData : RecImageData?
    public var profileStatus:Bool=false
    public var kiwiSocialId:Int?
    
    required public init?(dictionary: NSDictionary) {
        recruiterId = dictionary["recruiterId"] as? Int
        name = dictionary["name"] as? String
        email = dictionary["email"] as? String
        companyId = dictionary["companyId"] as? Int
         kiwiSocialId = dictionary["kiwiSocialId"] as? Int
        location = dictionary["location"] as? String
        designations = dictionary["designation"] as? String
        if let profileStatus=dictionary["profileStatus"] as? String{
            if profileStatus == "A"{
                self.profileStatus=true
            }
        }
       // avatarUrl = dictionary["avatarUrl"] as? String
        if let imageURl=dictionary["avatarUrl"] as? String{
            DispatchQueue.main.async {
                if let domainName=AppDelegate.instance.site?.domain{
                    self.avatarUrl = "https://media."+domainName.replacingOccurrences(of: "www.", with: "")+imageURl
                }
            }
        }
        recruiterUuid=dictionary["recruiterUuid"]as?String
        if let indust=dictionary["industries"]as?Array<String>{
            industries=indust
        }
        if let funct=dictionary["functions"]as?Array<String>{
            functions=funct
        }
        if let levelHiringF=dictionary["levelHiringFor"]as?Array<String>{
            levelHiringFor=levelHiringF
        }
        
        if let skill=dictionary["skills"]as?Array<String>{
            skills=skill
        }
       
        id = dictionary["id"] as? String
        score = dictionary["score"] as? Int
        totalWorkExperience = dictionary["totalWorkExperience"] as? Int
        if (dictionary["employments"] != nil) { employments = Employments.modelsFromDictionaryArray(array: dictionary["employments"] as! NSArray) }
        createdAt = dictionary["createdAt"] as? Int
        updatedAt = dictionary["updatedAt"] as? Int
        recruiterUuid = dictionary["recruiterUuid"] as? String
        designation = dictionary["designation"] as? String
        companyName = dictionary["companyName"] as? String
        phone = dictionary["phone"] as? String
        followersCount = dictionary["followersCount"] as? Int
        if (dictionary["achievements"] != nil) { achievements = Achievements.modelsFromDictionaryArray(array: dictionary["achievements"] as! NSArray) }
        lastActiveAt = dictionary["lastActiveAt"] as? Int
      //  if (dictionary["imageData"] != nil) { imageData = RecImageData(dictionary: dictionary["imageData"] as! NSDictionary) }
    }
}



public class RecImageData {
    public var imageType : String?
    public var imageData : String?
    public class func modelsFromDictionaryArray(array:NSArray) -> [RecImageData]
    {
        var models:[RecImageData] = []
        for item in array
        {
            models.append(RecImageData(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary) {
        
        imageType = dictionary["imageType"] as? String
        imageData = dictionary["imageData"] as? String
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.imageType, forKey: "imageType")
        dictionary.setValue(self.imageData, forKey: "imageData")
        
        return dictionary
    }
    
}


public class Achievements {
    public var description : String?
    public var achievementDate : String?
    public class func modelsFromDictionaryArray(array:NSArray) -> [Achievements]
    {
        var models:[Achievements] = []
        for item in array
        {
            models.append(Achievements(dictionary: item as! NSDictionary)!)
        }
        return models
    }
   
    required public init?(dictionary: NSDictionary) {
        
        description = dictionary["description"] as? String
        achievementDate = dictionary["achievementDate"] as? String
    }
    
    
}

public class Employments {
    public var company : String?
    public var start : String?
    public var end : String?
    public var designation : String?
    public var currentCompany : Bool?
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [Employments]
    {
        var models:[Employments] = []
        for item in array
        {
            models.append(Employments(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    required public init?(dictionary: NSDictionary) {
        
        company = dictionary["company"] as? String
        start = dictionary["start"] as? String
        end = dictionary["end"] as? String
        designation = dictionary["designation"] as? String
        currentCompany = dictionary["currentCompany"] as? Bool
    }
    
}
