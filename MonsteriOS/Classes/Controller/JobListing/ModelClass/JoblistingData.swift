//
//  MISRPJobListingViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 09/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import Foundation


public class JoblistingData {
	public var jobId : Int?
	public var title : String?
    public var kiwiJobId:String?
    public var kiwiCompanyId: String?
    public var kiwiRecruiterId : String?
	public var company : Company?
	public var location : Array<Location>?
	public var minimumExperience : MinimumExperience?
	public var maximumExperience : MaximumExperience?
	public var minimumSalary : MinimumSalary?
	public var maximumSalary : MaximumSalary?
	public var postedAt : Int?
	public var createdAt : Int?
	public var updatedAt : Int?
	public var expires : Int?
	public var jobCode : String?
	public var applicants : Array<Applicants>?
	public var industries : Array<String>?
	public var functions : Array<String>?
	public var roles : Array<String>?
	public var description : String?
	public var summary : String?
	public var walkInStartDate : String?
	public var walkInEndDate : String?
	public var jobTypes : Array<String>?
	public var employmentTypes : Array<String>?
	public var itSkills : Array<ItSkills>?
	public var skills : Array<Skills>?
	public var recruiterId : Int?
    public var companyId:Int?
	public var designation : String?
    public var recruiterName:String?
	public var minimumSalaryFilter : Int?
	public var maximumSalaryFilter : Int?
    public var walkInVenue:WalkInVenue?
    public var isSelected=false
    public var recruiter:Recruiter?
    public var isSaved:Bool?=false
    public var isApplied:Bool?=false
    public var isViewed:Bool?=false
    public var isRecruiterFollow:Bool?=false
    public var isCompanyFollow:Bool?=false
    public var redirectUrl:String?
    public var isSearchLogo:Int?
    public var activeJob:Bool?=false
    public var freshness:Int?
    public var jobAppliedDate:Int?
    public var jobSavedDate:Int?
    public var recruiterContactNumber:String?
    public var showContactDetails:Int?
    public var walkInPro:Bool?
    public var isJdLogo:Int?
    public var isCJT:Int?
    public var isMicrosite:Int?
    public var micrositeUrl:String?
    public var walkInSchedules:Array<WalkInSchedule>?
    public var hideCompanyName:Int? = 0
    public var applyUrl:String?
    public var totalApplicants:Int = 0
    public var resultId = ""

    public class func modelsFromDictionaryArray(array:NSArray,resultId:String="") -> [JoblistingData]
    {
        var models:[JoblistingData] = []
        for item in array
        {
            if let newItem=item as? NSDictionary {
                models.append(JoblistingData(dictionary: newItem, resultId: resultId)!)
            //models.append(JoblistingData(dictionary:newItem)!)
            }
        }
        return models
    }

    init() {
        
    }

    required public init?(dictionary: NSDictionary,resultId:String="") {

		jobId = dictionary["jobId"] as? Int
        kiwiJobId=dictionary["kiwiJobId"] as? String
        self.kiwiCompanyId=dictionary["kiwiCompanyId"]as?String
        self.kiwiRecruiterId=dictionary["kiwiRecruiterId"]as?String
		title = dictionary["title"] as? String
        self.hideCompanyName=dictionary["hideCompanyName"] as? Int
        if (dictionary["company"] != nil) {
            company = Company(dictionary: dictionary["company"] as! NSDictionary,hideCompanyName: self.hideCompanyName ?? 0)
        }
        if (dictionary["locations"] != nil) { location = Location.modelsFromDictionaryArray(array: dictionary["locations"] as! NSArray) }
		if (dictionary["minimumExperience"] != nil) { minimumExperience = MinimumExperience(dictionary: dictionary["minimumExperience"] as! NSDictionary) }
		if (dictionary["maximumExperience"] != nil) { maximumExperience = MaximumExperience(dictionary: dictionary["maximumExperience"] as! NSDictionary) }
		if (dictionary["minimumSalary"] != nil) { minimumSalary = MinimumSalary(dictionary: dictionary["minimumSalary"] as! NSDictionary) }
		if (dictionary["maximumSalary"] != nil) { maximumSalary = MaximumSalary(dictionary: dictionary["maximumSalary"] as! NSDictionary) }
		postedAt = dictionary["postedAt"] as? Int
		createdAt = dictionary["createdAt"] as? Int
		updatedAt = dictionary["updatedAt"] as? Int
		expires = dictionary["expires"] as? Int
        freshness = dictionary["freshness"] as? Int
        companyId = dictionary["companyId"] as? Int
		jobCode = dictionary["jobCode"] as? String
        if (dictionary["applicants"] != nil) {
            applicants = Applicants.modelsFromDictionaryArray(array: dictionary["applicants"] as! NSArray)
        }
        if let industryArray=dictionary["industries"] as? [String] {
            industries=industryArray
        }
        
        if let function=dictionary["functions"] as? [String]{ functions = function}
        if let role=dictionary["roles"] as? [String] { roles = role}
		description = dictionary["description"] as? String
		summary = dictionary["summary"] as? String
		walkInStartDate = dictionary["walkInStartDate"] as? String
		walkInEndDate = dictionary["walkInEndDate"] as? String
        
        if let jobTyp=dictionary["jobTypes"] as? [String] { jobTypes = jobTyp}
        if let empType=dictionary["employmentTypes"] as? [String] { employmentTypes = empType }
        if (dictionary["itSkills"] != nil) { itSkills = ItSkills.modelsFromDictionaryArray(array: dictionary["itSkills"] as! NSArray) }
        if (dictionary["skills"] != nil) { skills = Skills.modelsFromDictionaryArray(array: dictionary["skills"] as! NSArray) }
		recruiterId = dictionary["recruiterId"] as? Int
		designation = dictionary["designation"] as? String
		minimumSalaryFilter = dictionary["minimumSalaryFilter"] as? Int
		maximumSalaryFilter = dictionary["maximumSalaryFilter"] as? Int
        recruiterName = dictionary["recruiterName"] as? String
        
        if let walkingVenue=dictionary["walkInVenue"] as? NSDictionary { walkInVenue = WalkInVenue(dictionary: walkingVenue) }
        
        if let recruit=dictionary["recruiter"] as? NSDictionary { recruiter = Recruiter(dictionary: recruit) }
        if let saved=dictionary["isSaved"] as? String{
            isSaved = saved=="true" ? true : false
        }
        if let saved=dictionary["isApplied"] as? String {
            isApplied = saved=="true" ? true : false
        }
        if let isViewed=dictionary["isViewed"] as? String{
            self.isViewed = isViewed=="true" ? true : false
        }
        if let saved=dictionary["isFollowedRecruiter"] as? String{
            isRecruiterFollow = saved=="true" ? true : false
        }
        if let saved=dictionary["isFollowedCompany"] as? String{
            isCompanyFollow = saved=="true" ? true : false
        }
        self.redirectUrl=dictionary["redirectUrl"] as? String
        self.isSearchLogo=dictionary["isSearchLogo"] as? Int
        self.activeJob=dictionary["activeJob"] as? Bool
        self.jobAppliedDate=dictionary["jobAppliedDate"]as?Int
        self.jobSavedDate=dictionary["jobSavedDate"]as?Int
        self.showContactDetails=dictionary["showContactDetails"]as?Int
        self.recruiterContactNumber=dictionary["recruiterContactNumber"]as?String
        self.walkInPro=dictionary["walkInPro"]as?Bool
        self.isJdLogo=dictionary["isJdLogo"]as?Int
        self.isCJT=dictionary["isCJT"]as?Int
        self.isMicrosite=dictionary["isMicrosite"]as?Int
        self.micrositeUrl=dictionary["micrositeUrl"]as?String
        self.applyUrl=dictionary["applyUrl"]as?String
        if let walkInSch=dictionary["walkInSchedules"] as? [Any]{
            self.walkInSchedules=WalkInSchedule.modelsFromDictionaryArray(array: walkInSch as NSArray)
        }
        
        self.totalApplicants=dictionary["totalApplicants"]as?Int ?? 0
        self.resultId = resultId
       // if let companyLogo=dictionary["isSearchLogo"] as? String{
       //     isSearchLogo = companyLogo=="true" ? true : false
        //}
        //isSaved = dictionary["isSaved"] as? Bool
        //isApplied = dictionary["isApplied"] as? Bool
        //isRecruiterFollow = dictionary["isFollowedRecruiter"] as? Bool
        //isCompanyFollow = dictionary["isFollowedCompany"] as? Bool
	}

}

public class Skills{
    
    public var id : String?
    public var text : String?
    public class func modelsFromDictionaryArray(array:NSArray) -> [Skills]    {
        var models:[Skills] = []
        for item in array
        {
            models.append(Skills(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    
    required public init?(dictionary: NSDictionary) {
        id=dictionary["id"]as?String
        text=(dictionary["text"] as? String ?? "")?.withoutWhiteSpace()
        let aphbet = NSCharacterSet.letters
        let digits = NSCharacterSet.decimalDigits

        let rangedigit = text?.rangeOfCharacter(from: digits)
        let rangeaphbet = text?.rangeOfCharacter(from: aphbet)

        if rangedigit == nil  && rangeaphbet == nil{
            text = ""
        }
        
    }
}
public class WalkInSchedule{

    public var venue : String = ""
    public var venueAddress : String?
    public var fromTime : String?
    public var toTime : String?
    public var scheduleDate : String?
     public var scheduleDateSort : Date?
    public var numberOfCandidates : Int?
    public var apply : Int?
    public var maxApply : Int?
    public var createdAt : Int?
    public var updatedAt : Int?
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [WalkInSchedule]
    {
        var models:[WalkInSchedule] = []
        for item in array
        {
            if item is NSDictionary{
            models.append(WalkInSchedule(dictionary: item as! NSDictionary)!)
            }
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary) {
        
        venue = dictionary["venue"] as? String ?? ""
        venueAddress = dictionary["venueAddress"] as? String
        fromTime = dictionary["fromTime"] as? String
        toTime = dictionary["toTime"] as? String
        scheduleDate = dictionary["scheduleDate"] as? String
        if scheduleDate != nil{
            let datefroma=DateFormatter()
            datefroma.dateFormat = PersonalTitleConstant.dateFormatePattern
            self.scheduleDateSort=datefroma.date(from: scheduleDate!)
        }
        numberOfCandidates = dictionary["numberOfCandidates"] as? Int
        apply = dictionary["apply"] as? Int
        maxApply = dictionary["maxApply"] as? Int
        createdAt = dictionary["createdAt"] as? Int
        updatedAt = dictionary["updatedAt"] as? Int
    }
    
    
  

}
public class WalkInVenue{
    public var addresses:Array<String>?
    public var startDate:String?
    public var endDate:String?
    public var city:String?
    public var startTime:String?
    public var endTime:String?
    
    init(newDict:[String:Any]){
        self.addresses = [String]()

        if let wlkinvenue = newDict["walkInVenue"] as? [String:Any] {
            self.addresses?.append(wlkinvenue["venueAddress"]as?String ?? "")
            self.startDate=wlkinvenue["walkinDate"]as?String
            self.startTime=wlkinvenue["timeSlot"]as?String
         //   self.city = wlkinvenue["venue"]as?String
        }else{
            self.addresses?.append(newDict["venueAddress"]as?String ?? "")
            self.startDate=newDict["walkinDate"]as?String
            self.startTime=newDict["timeSlot"]as?String
            self.city = newDict["venue"]as?String
        }
        
    }
    required public init?(dictionary: NSDictionary) {
        if let address=dictionary["addresses"] as? [String] { addresses = address }
        startDate=dictionary["startDate"]as?String
        endDate=dictionary["endDate"]as?String
        city=dictionary["city"]as?String
        //startTime=dictionary["startTime"]as?Int
        //endTime=dictionary["endTime"]as?Int
        if let startT=dictionary["startTime"]as?Int{
            if String(startT).count > 0{
                if String(startT).count == 3{
                    startTime=String(String(startT).prefix(1)) + ":" + String(String(startT).suffix(2))
                }
                if String(startT).count == 4{
                    startTime=String(String(startT).prefix(2)) + ":" + String(String(startT).suffix(2))
                }
            }
            
        }
        if let startT=dictionary["endTime"]as?Int{
            if String(startT).count > 0{
                if String(startT).count == 3{
                    endTime=String(String(startT).prefix(1)) + ":" + String(String(startT).suffix(2))
                }
                if String(startT).count == 4{
                    endTime=String(String(startT).prefix(2)) + ":" + String(String(startT).suffix(2))
                }
            }
            
        }
        
    }
}
