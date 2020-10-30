//
//  MISRPJobListingViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 09/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import Foundation

let companyConfidential = "Company Name : Confidential"
public class Company {
	public var companyId : Int?
	public var name : String?
    public var country:String?
    public var city:String?
    public var about:String?
    public var logo:String?
    public var industries:Array<String>?
   // public var email:String?
   // public var employerType:String?
    public var location:Location?
  //  public var phone: String?
  //  public var shortName:String?
    public var keepConfidential:Int?
    public var isCompanyFollow:Bool?=false //add key for top companies in home
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [Company]
    {
        var models:[Company] = []
        for item in array
        {
            models.append(Company(dictionary: item as! NSDictionary)!)
        }
        return models
    }

    required public init?(dictionary: NSDictionary,hideCompanyName:Int=0) {

		companyId = dictionary["companyId"] as? Int
        if hideCompanyName==0{
		name = dictionary["name"] as? String
        }else{
            name=companyConfidential
        }
        country=dictionary["country"] as? String
        city=dictionary["city"] as? String
        about=dictionary["about"] as? String
        self.logo=dictionary["logo"] as? String
        if let indust=dictionary["industries"]as?Array<String>{
            industries=indust
        }
       // email=dictionary["email"] as? String
       // employerType=dictionary["employerType"] as? String
       // phone=dictionary["phone"] as? String
      //  shortName=dictionary["shortName"] as? String
        keepConfidential=dictionary["keepConfidential"] as? Int
        if let locat=dictionary["location"]as?NSDictionary{
            self.location=Location(dictionary: locat)
        }
        isCompanyFollow = dictionary["isFollowedCompany"] as? Bool
        
	}

}
