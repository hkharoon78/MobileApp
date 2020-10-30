//
//  NotificationBaseModel.swift
//  MonsteriOS
//
//  Created by ishteyaque on 09/07/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import Foundation
public class NotificationBaseModel {
    public var notificationUuid : String?
    public var user_id : Int?
    public var profile_id : String?
    public var kiwi_profile_id : String?
    public var kiwi_user_id : String?
    public var docType : String?
    public var subSection : Array<SubSection>?
    public var seen : Bool?
    public var created_at : String?
    public var modified_at : String?
    public var new_count : Int?
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [NotificationBaseModel]
    {
        var models:[NotificationBaseModel] = []
        for item in array
        {
            models.append(NotificationBaseModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary) {
        
        notificationUuid = dictionary["notificationUuid"] as? String
        user_id = dictionary["user_id"] as? Int
        profile_id = dictionary["profile_id"] as? String
        kiwi_profile_id = dictionary["kiwi_profile_id"] as? String
        kiwi_user_id = dictionary["kiwi_user_id"] as? String
        docType = dictionary["docType"] as? String
        if let subSectionnew = dictionary["subSection"] as? NSArray { subSection = SubSection.modelsFromDictionaryArray(array: subSectionnew) }
        seen = dictionary["seen"] as? Bool
        created_at = dictionary["created_at"] as? String
        modified_at = dictionary["modified_at"] as? String
        new_count = dictionary["new_count"] as? Int
    }
    
    
}


public class SubSection {
    public var type : String?
    public var text : String?
    public var notifications : Array<Notifications>?
    public var accessed_at : String?
    public var prevCount : Int?
    public var newCount : Int?
    public var modified_at : String?
    public var key : String?
    public var deliveryStatus : String?
    public var similarJobId : Int?
    public class func modelsFromDictionaryArray(array:NSArray) -> [SubSection]
    {
        var models:[SubSection] = []
        for item in array
        {
            models.append(SubSection(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    

    required public init?(dictionary: NSDictionary) {
        
        type = dictionary["type"] as? String
        text = dictionary["text"] as? String
        if (dictionary["notifications"] != nil) { notifications = Notifications.modelsFromDictionaryArray(array: dictionary["notifications"] as! NSArray) }
        accessed_at = dictionary["accessed_at"] as? String
        prevCount = dictionary["prevCount"] as? Int
        newCount = dictionary["newCount"] as? Int
        modified_at = dictionary["modified_at"] as? String
        if let modifiedDate=dictionary["modified_at"] as? Int{
            modified_at = String(modifiedDate)
        }
        similarJobId = dictionary["similarJobId"] as? Int
        if let simJobId=dictionary["similarJobId"] as? String{
            similarJobId=Int(simJobId)
        }
        key = dictionary["key"] as? String
        deliveryStatus = dictionary["deliveryStatus"] as? String
        
    }
    
}


public class Notifications {
    public var title : String?
    public var body : String?
    public var key : String?
    public var actionTaken : Bool?
    public var action_taken_on : String?
    public var modified_at   : String?
    public var weightagePercent : Int?
    public var deliveryStatus : String?
    public var prevCount:Int?
    public var newCount:Int?
    var pendingActionType:PendingActionType = .NONE
    public var jobSearchRequest:JobSearchRequest?
    public var similarJobId:Int?
    public class func modelsFromDictionaryArray(array:NSArray) -> [Notifications]
    {
        var models:[Notifications] = []
        for item in array
        {
            models.append(Notifications(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary) {
        
        title = dictionary["title"] as? String
        body = dictionary["body"] as? String
        key = dictionary["key"] as? String
        self.pendingActionType = key.map { PendingActionType(rawValue: $0) ?? .NONE } ?? .NONE
        actionTaken = dictionary["actionTaken"] as? Bool
        action_taken_on = dictionary["action_taken_on"] as? String
        modified_at   = dictionary["modified_at"] as? String
        if let modifiedDate=dictionary["modified_at"] as? Int{
            modified_at = String(modifiedDate)
        }
        weightagePercent = dictionary["weightagePercent"] as? Int
        deliveryStatus = dictionary["deliveryStatus"] as? String
       // similarJobId = dictionary["similarJobId"] as? Int
        if let simiJob=dictionary["similarJobId"] as? String{
            similarJobId=Int(simiJob) ?? 0
        }
        if let request=dictionary["jobSearchRequest"] as? NSDictionary{
            self.jobSearchRequest=JobSearchRequest(dictionary: request)
        }
    }
    init(model:SubSection) {
        self.title=model.key
        self.body=model.text
        self.key=model.type
        self.prevCount=model.prevCount
        self.newCount=model.newCount
        self.similarJobId=model.similarJobId
        self.modified_at=model.modified_at
        self.action_taken_on=model.accessed_at
        self.pendingActionType = key.map { PendingActionType(rawValue: $0) ?? .NONE } ?? .NONE
    }
    init(model:PendingAction) {
        self.key=model.name
         self.pendingActionType = model.pendingActionType
        self.title=self.pendingActionType.title
    }
}


public class JobSearchRequest{
    public var query:String?
    public var industries : Array<String>?
    public var functions : Array<String>?
    public var roles : Array<String>?
    public var keywords : Array<String>?
    public var experienceRanges:Array<String>?
    public var salaryRanges:Array<String>?
    public var jobFreshness:Array<String>?
    public var jobTypes:Array<String>?
    public var employerTypes:Array<String>?
    public var companies:Array<String>?
    public var locations:Array<String>?
    required public init?(dictionary: NSDictionary) {
        query = dictionary["query"] as? String
        if let indus=dictionary["industries"] as? [String]{
            self.industries=indus
        }
        if let functio=dictionary["functions"] as? [String]{
            self.functions=functio
        }
        if let role=dictionary["roles"] as? [String]{
            self.roles=role
        }
        if let key=dictionary["keywords"] as? [String]{
            self.keywords=key
        }
        if let exp=dictionary["experienceRanges"] as? [String]{
            self.experienceRanges=exp
        }
        if let sal=dictionary["salaryRanges"] as? [String]{
            self.salaryRanges=sal
        }
        if let jobFres=dictionary["jobFreshness"] as? [String]{
            self.jobFreshness=jobFres
        }
        if let jobTyp=dictionary["jobTypes"] as? [String]{
            self.jobTypes=jobTyp
        }
        if let empType=dictionary["employerTypes"] as? [String]{
            self.employerTypes=empType
        }
        if let comp=dictionary["companies"] as? [String]{
            self.companies=comp
        }
        if let loca=dictionary["locations"] as? [String]{
            self.locations=loca
        }
        if let loca=dictionary["jobCities"] as? [String]{
            self.locations=loca
        }
        //locations
    }
}

struct NotificationViewModel{
    var keyValue:String
    var title:String
    var subTitle:String
    var actionTaken:Bool
    var buttonTitle:String
    var modifiedAt:String
    var pendingActionType:PendingActionType
    var similarJobId:Int
    var jobSearchRequest:JobSearchRequest?
    var count:Int=0
    init(model:Notifications) {
        self.keyValue=model.key ?? ""
        self.title=model.title ?? ""
        self.subTitle=model.body ?? ""
        self.actionTaken = model.actionTaken ?? false
        self.pendingActionType = model.pendingActionType
        if pendingActionType == .RECOMMENDED_JOBS{
            self.title="Recommended Jobs"
        }
        if pendingActionType == .SIMILAR_JOBS{
            self.title="Similar Jobs"
        }
        if pendingActionType == .OTHER{
            self.title="Pending Actions"
        }
        self.buttonTitle = self.pendingActionType.actionBtnTitle
        self.modifiedAt = model.modified_at ?? ""
        if let dateMod=model.modified_at{
            self.modifiedAt = formatPostedDate(dateValue: Int(dateMod) ?? 0, titl: "")
        }
        
        self.similarJobId=model.similarJobId ?? 0
        self.jobSearchRequest=model.jobSearchRequest
        //self.count=model.newCount ?? 0
    }
}
