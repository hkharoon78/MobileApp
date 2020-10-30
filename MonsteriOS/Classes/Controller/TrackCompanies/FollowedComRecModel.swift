//
//  FollowedComRecModel.swift
//  MonsteriOS
//
//  Created by Anushka on 05/03/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import Foundation
public class FollowedComRecModel {
    public var id : Int?
    public var recruiterId : String?
    public var companyId : String?
    public var name:String?
    public var isFollowed:Bool=true
    public var recruiterUuid:String?
    public var email:String?
    public var functions:Array<String>?
    public var recruiterDetails:Recruiter?
    public var companyDetails:Company?
  
    public class func modelsFromDictionaryArray(array:NSArray) -> [FollowedComRecModel]
    {
        var models:[FollowedComRecModel] = []
        for item in array
        {
            models.append(FollowedComRecModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary) {
        if let temId=dictionary["id"] as? String{
        id = Int(temId)
        }
        if let tempRecId=dictionary["recruiterId"] as? Int{
        recruiterId = String(tempRecId)
        }
        if let tempComId=dictionary["companyId"] as? Int{
        companyId = String(tempComId)
        }
        name=dictionary["name"]as?String
        recruiterUuid=dictionary["recruiterUuid"]as?String
        self.recruiterDetails=Recruiter(dictionary: dictionary)
        self.companyDetails=Company(dictionary: dictionary)
    }
    
  
    
}
public class FollowedComRecBaseModel {
    public var data : Array<FollowedComRecModel>?
    public var meta : Meta?
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [FollowedComRecBaseModel]
    {
        var models:[FollowedComRecBaseModel] = []
        for item in array
        {
            models.append(FollowedComRecBaseModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
   
    required public init?(dictionary: NSDictionary) {
        
        if (dictionary["data"] != nil) { data = FollowedComRecModel.modelsFromDictionaryArray(array: dictionary["data"] as! NSArray) }
        if (dictionary["meta"] != nil) { meta = Meta(dictionary: dictionary["meta"] as! NSDictionary) }
    }
    
  
    
}
