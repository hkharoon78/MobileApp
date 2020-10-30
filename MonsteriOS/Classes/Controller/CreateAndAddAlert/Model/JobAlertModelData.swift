//
//  JobAlertModelData.swift
//  MonsteriOS
//
//  Created by ishteyaque on 16/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import Foundation
public class Salary {
    public var currency : String?
    public var absoluteValue : Int?
   // public var thousands : Int?
    
    
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
        absoluteValue = dictionary["absoluteValue"] as? Int
       // thousands = dictionary["thousands"] as? Int
    }
}

public class JobAlertModelData {
    public var createdAt : Int?
    public var updatedAt : Int?
    public var id : String?
    public var name : String?
    public var email : String?
    public var minimumSalary : MaximumSalary?
    public var maximumSalary : MaximumSalary?
    public var experience : Experience?
    public var industries : Array<String>?
    public var functions : Array<String>?
    public var roles : Array<String>?
    public var keywords : Array<String>?
    public var frequency : Frequency?
    public var ssoId : String?
    public var seekerId : Int?
    public var profileId : Int?
    public var locations:Array<String>?
    public var salary:Salary?
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [JobAlertModelData]
    {
        var models:[JobAlertModelData] = []
        for item in array
        {
            models.append(JobAlertModelData(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary) {
        
        createdAt = dictionary["createdAt"] as? Int
        updatedAt = dictionary["updatedAt"] as? Int
        id = dictionary["id"] as? String
        name = dictionary["name"] as? String
        email = dictionary["email"] as? String
        if let dictData = dictionary["minimumSalary"] as? NSDictionary { minimumSalary = MaximumSalary(dictionary:dictData)}
        //minimumSalary = dictionary["minimumSalary"] as? String
        if let dictData = dictionary["maximumSalary"] as? NSDictionary { maximumSalary = MaximumSalary(dictionary: dictData) }
        if let dictData = dictionary["experience"] as? NSDictionary { experience = Experience(dictionary: dictData) }
        if let function=dictionary["functions"] as? [String]{ functions = function}
        if let industry=dictionary["industries"] as? [String]{ industries = industry}
        if let role=dictionary["roles"] as? [String]{ roles = role}
        if let keyword=dictionary["keywords"] as? [String]{ keywords = keyword}
        if let location=dictionary["locations"] as? [String]{ locations = location}
        if let salar=dictionary["salary"] as? NSDictionary{ salary = Salary(dictionary: salar)}
        if let dictData = dictionary["frequency"] as? NSDictionary { frequency = Frequency(dictionary: dictData) }
        ssoId = dictionary["ssoId"] as? String
        seekerId = dictionary["seekerId"] as? Int
        profileId = dictionary["profileId"] as? Int
    }

}
public class JobAlertModelDataWithMaster {
    public var createdAt : Int?
    public var updatedAt : Int?
    public var id : String?
    public var name : String?
    public var email : String?
    public var minimumSalary : MaximumSalary?
    public var maximumSalary : MaximumSalary?
    public var experience : Experience?
    public var industries : Array<Frequency>?
    public var functions : Array<Frequency>?
    public var roles : Array<Frequency>?
    public var keywords : Array<String>?
    public var frequency : Frequency?
    public var ssoId : String?
    public var seekerId : Int?
    public var profileId : Int?
    public var locations:Array<Frequency>?
    public var salary:Salary?
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [JobAlertModelDataWithMaster]
    {
        var models:[JobAlertModelDataWithMaster] = []
        for item in array
        {
            models.append(JobAlertModelDataWithMaster(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary) {
        
        createdAt = dictionary["createdAt"] as? Int
        updatedAt = dictionary["updatedAt"] as? Int
        id = dictionary["id"] as? String
        name = dictionary["name"] as? String
        email = dictionary["email"] as? String
        if let dictData = dictionary["minimumSalary"] as? NSDictionary { minimumSalary = MaximumSalary(dictionary:dictData)}
        //minimumSalary = dictionary["minimumSalary"] as? String
        if let dictData = dictionary["maximumSalary"] as? NSDictionary { maximumSalary = MaximumSalary(dictionary: dictData) }
        if let dictData = dictionary["experience"] as? NSDictionary { experience = Experience(dictionary: dictData) }
        if let function=dictionary["functions"] as? NSArray{ functions = Frequency.modelsFromDictionaryArray(array: function)}
        if let industry=dictionary["industries"] as? NSArray{ industries = Frequency.modelsFromDictionaryArray(array: industry)}
        if let role=dictionary["roles"] as? NSArray{ roles = Frequency.modelsFromDictionaryArray(array: role)}
        if let keyword=dictionary["keywords"] as? [String]{ keywords = keyword}
        if let location=dictionary["locations"] as? NSArray{ locations = Frequency.modelsFromDictionaryArray(array: location)}
        if let salar=dictionary["salary"] as? NSDictionary{ salary = Salary(dictionary: salar)}
        if let dictData = dictionary["frequency"] as? NSDictionary { frequency = Frequency(dictionary: dictData) }
        ssoId = dictionary["ssoId"] as? String
        seekerId = dictionary["seekerId"] as? Int
        profileId = dictionary["profileId"] as? Int
    }
    
}


public class Frequency {
    public var id : String?
    public var text : String?
    public class func modelsFromDictionaryArray(array:NSArray) -> [Frequency]
    {
        var models:[Frequency] = []
        for item in array
        {
            models.append(Frequency(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary) {
        
        id = dictionary["id"] as? String
        text = dictionary["text"] as? String
    }
    
    
}


public class ManageJobAlertBaseModel {
    public var data : Array<JobAlertModelData>?
    public var meta : Meta?
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [ManageJobAlertBaseModel]
    {
        var models:[ManageJobAlertBaseModel] = []
        for item in array
        {
            models.append(ManageJobAlertBaseModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }
  
    required public init?(dictionary: NSDictionary) {
        
        if (dictionary["data"] != nil) { data = JobAlertModelData.modelsFromDictionaryArray(array: dictionary["data"] as! NSArray) }
        if (dictionary["meta"] != nil) { meta = Meta(dictionary: dictionary["meta"] as! NSDictionary) }
    }
}
public class ManageJobAlertBaseModelMaster {
    public var data : Array<JobAlertModelDataWithMaster>?
    public var meta : Meta?
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [ManageJobAlertBaseModelMaster]
    {
        var models:[ManageJobAlertBaseModelMaster] = []
        for item in array
        {
            models.append(ManageJobAlertBaseModelMaster(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary) {
        
        if (dictionary["data"] != nil) { data = JobAlertModelDataWithMaster.modelsFromDictionaryArray(array: dictionary["data"] as! NSArray) }
        if (dictionary["meta"] != nil) { meta = Meta(dictionary: dictionary["meta"] as! NSDictionary) }
    }
}

