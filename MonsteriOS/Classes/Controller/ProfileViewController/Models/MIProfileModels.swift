//
//  MIProfileModels.swift
//  MonsteriOS
//
//  Created by Piyush on 14/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import Firebase

public enum MIProfileEnums: String {
    enum headerType:Int {
        case add,edit,editDelete,none
    }
    
    case strength         = "profileStrength"
    case manageProfileSection = "manageProfileSection"
    case resumeSection    = "resumeSection"
    case skill            = "skillSection"
    case ITSkill          = "itSkillSection"
    case jobPreference    = "jobPreferenceSection"
    case workExperience   = "employmentDetailSection"
    case eduExperience    = "educationDetailSection"
    case project          = "projectDetailSection"
    case personalDetail   = "personalDetailSection"
    case awards           = "awardSection"
    case courses          = "courseAndCertificationSection"
    case onlinePresence   = "socialPresenceSection"
    case otherDetail      = "otherDetail"
    case language         = "languageSection"
    
    static var list:[String] {
        return [self.strength.rawValue,self.manageProfileSection.rawValue,self.resumeSection.rawValue,self.skill.rawValue,self.ITSkill.rawValue,self.jobPreference.rawValue,self.workExperience.rawValue,self.eduExperience.rawValue, self.project.rawValue,self.courses.rawValue,self.personalDetail.rawValue, self.awards.rawValue,self.onlinePresence.rawValue,self.language.rawValue]
    }
    
    var headerTitle:String {
        switch self {
        case .skill:
            return "Skills"
        case .ITSkill:
            return "IT Skills"
        case .jobPreference:
            return "Job Preferences"
        case .workExperience:
            return "Work Experience"
        case .eduExperience:
            return "Educational Experience"
        case .project:
            return "Projects"
        case .courses:
            return "Courses & Certification"
        case .personalDetail:
            return "Personal Details"
        case .awards:
            return "Awards & Achievements"
        case .onlinePresence:
            return "Online Presence"
        case .otherDetail:
            return "Other Details"
        case .language:
            return "Language Known"
        default:
            return ""
        }
    }
    
    var headerSubTitle:String {
        switch self {
        case .onlinePresence:
            return "Enter url of your FB/TW/LI profiles"
        case .project:
            return "Add projects that you want to showcase"
        case .awards:
            return "Enter details of any awards you may have received"
        case .ITSkill:
            return "Helps recruiter in finding you for relevant jobs"
        case .personalDetail:
            return "List Personal Details like Date of Birth, Gender etc."
        case .workExperience:
            return "Helps recruiters map your candidature against job vacancies they may have."
        case .jobPreference:
            return "Helps us recommend relevant jobs for you"
        case .language:
            return "Add the languages you know"
        case .eduExperience:
            return "Add your school, college and higher education details"
        case .courses:
            return "Enter details of any professional course or certification you may have done"

        default:
            return ""
        }
    }
    
    var profileHeaderType:headerType {
        switch self {
        case .personalDetail:
            return .edit
        case .jobPreference:
            return .editDelete
        default:
            return .add
        }
    }
    
    var shouldShowSeeMore:Bool {
        switch self {
        case .ITSkill:
            return true
        case .awards:
            return true
        case .courses:
            return true
        case .personalDetail:
            return true
        case .onlinePresence:
            return true
        case .eduExperience:
            return true
        case .workExperience:
            return true
        case .project:
            return true
        case .language:
            return true
        default:
            return false
        }
    }
}


class MIProfileModels: NSObject {
    
    var moduleName    = ""
    var moduleType    = ""
    var dicModel      = [String:Any]()
    var shouldShowAll = false
    var model         = [Any]()
    var numberOfRows  = 0
    var moduleList    = [MIProfileEnums.strength.rawValue,MIProfileEnums.manageProfileSection.rawValue,MIProfileEnums.resumeSection.rawValue, MIProfileEnums.skill.rawValue,MIProfileEnums.ITSkill.rawValue, MIProfileEnums.jobPreference.rawValue, MIProfileEnums.workExperience.rawValue, MIProfileEnums.eduExperience.rawValue, MIProfileEnums.project.rawValue, MIProfileEnums.personalDetail.rawValue]
    
    init(with dic:[String:Any], moduleName:String) {
        self.moduleName  = moduleName
        self.moduleType  = dic.stringFor(key: "moduleType")
        if self.moduleName == MIProfileEnums.skill.rawValue {
            self.moduleType  = "Static"
            if let data = dic["skills"] as? [[String:Any]] {
                dicModel[moduleName] = MIUserSkills.modelsFromDictionaryArray(array: data)
            } else {
                dicModel[moduleName] = MIUserSkills.modelsFromDictionaryArray(array: [[:]])
            }
        }
        
        if self.moduleName == MIProfileEnums.personalDetail.rawValue {
            self.moduleType  = "Custom"
            if let data = dic["data"] as? [[String:Any]] {
                dicModel[moduleName] = MIProfileInfo.modelsFromDictionaryArray(array: data)
            }
        }
        

        if self.moduleName == MIProfileEnums.manageProfileSection.rawValue {
            self.moduleType  = "Static"
            if let data = dic["profiles"] as? [[String:Any]] {
                dicModel[moduleName] = MIExistingProfileInfo.modelsFromDictionaryArray(array: data)
            }
        }
        
        if self.moduleName == MIProfileEnums.resumeSection.rawValue {
            self.moduleType  = "Static"
            if let data = dic["resume"] as? [String:Any] {
                dicModel[moduleName] = MIProfileResumeInfo.modelsFromDictionary(dic: data)
            }
        }
        
        if self.moduleName == MIProfileEnums.ITSkill.rawValue {
            self.moduleType  = "Custom"
            if let data = dic["itSkills"] as? [[String:Any]] {
               dicModel[moduleName] = MIProfileITSkills.modelsFromDictionaryArray(array: data)
            }
        }
        
        if self.moduleName == MIProfileEnums.courses.rawValue {
            self.moduleType  = "Custom"
            if let data = dic["courseAndCertifications"] as? [[String:Any]] {
                dicModel[moduleName] = MIProfileCoursesInfo.modelsFromDictionaryArray(array: data)
            }
        }
        
        if self.moduleName == MIProfileEnums.awards.rawValue {
            self.moduleType  = "Custom"
            if let data = dic["awards"] as? [[String:Any]] {
                dicModel[moduleName] = MIProfileAward.modelsFromDictionaryArray(array: data)
            }
        }
        
        if self.moduleName == MIProfileEnums.jobPreference.rawValue {
            self.moduleType  = "Custom"
            if let data = dic["jobPreference"] as? [String:Any] {
                if let info = MIProfilePreferenceInfo.init(dictionary: data) {
                    self.model = [info]
                    dicModel[moduleName] = info.cellArray
                }
            }
        }
        if self.moduleName == MIProfileEnums.workExperience.rawValue {
            self.moduleType  = "Custom"
            if let data = dic["employments"] as? [[String:Any]] {
                dicModel[moduleName] = MIEmploymentDetailInfo.getModelFromDataSource(employmentDataList: data)
            }
        }
        if self.moduleName == MIProfileEnums.eduExperience.rawValue {
            self.moduleType  = "Custom"
            if let data = dic["educations"] as? [[String:Any]] {
                dicModel[moduleName] = MIEducationInfo.getModelFromDataList(educationData: data)
            }
        }
        if self.moduleName == MIProfileEnums.project.rawValue {
            self.moduleType  = "Custom"
            if let data = dic["projects"] as? [[String:Any]] {
                dicModel[moduleName] = MIProfileProjectInfo.modelsFromDictionaryArray(array: data)
            }
        }
        if self.moduleName == MIProfileEnums.onlinePresence.rawValue {
            self.moduleType  = "Custom"
            if let data = dic["presences"] as? [[String:Any]] {
                dicModel[moduleName] = MIProfileOnlinePresence.modelsFromDictionaryArray(array: data)
            }
        }
        if self.moduleName == MIProfileEnums.language.rawValue {
            self.moduleType  = "Custom"
            if let data = dic["languages"] as? [[String:Any]] {
                dicModel[moduleName] = MIProfileLanguageInfo.modelsFromDictionaryArray(array: data)
            }
        }
    }
    
}

class MIProfileInfo: NSObject {
    public var id                = ""
    public var title             = ""
    public var subTitle          = ""
    public var titleStatus       = ""
    public var titleStatusDetail = ""
    
    public class func modelsFromDictionaryArray(array:[[String:Any]]) -> [MIProfileInfo]
    {
        var models:[MIProfileInfo] = []
        for item in array
        {
            if let info = MIProfileInfo(dictionary:item){
                models.append(info)
            }
        }
        return models
    }
    
    required public init?(dictionary: [String:Any]) {
        id = dictionary.stringFor(key: "id")
        title = dictionary.stringFor(key: "title")
        subTitle = dictionary.stringFor(key: "subTitle")
        titleStatus = dictionary.stringFor(key: "titleStatus")
        titleStatusDetail = dictionary.stringFor(key: "titleStatusDetail")
    }
}


class MIProfileSkill:NSObject {
    public var id      = ""
    public var skillId = ""
    public var text    = ""
    
    public class func modelsFromDictionaryArray(array:[[String:Any]]) -> [MIProfileSkill]
    {
        var models:[MIProfileSkill] = []
        for item in array
        {
            if let info = MIProfileSkill(dictionary:item) {
                models.append(info)
            }
        }
        return models
    }
    
    required public init?(dictionary: [String:Any]) {
        id   = dictionary.stringFor(key:"id")
        if let skillDic = dictionary["skill"] as? [String:Any] {
            skillId   = skillDic.stringFor(key:"id")
            text = skillDic.stringFor(key:"text")
        }
        
    }
    
}


class MIProfileAward:NSObject {
    public var id   = ""
    public var title = ""
    public var ttlDescription = ""
    public var date = ""
    
    public class func modelsFromDictionaryArray(array:[[String:Any]]) -> [MIProfileAward]
    {
        var models:[MIProfileAward] = []
        for item in array
        {
            if let info = MIProfileAward(dictionary:item) {
                models.append(info)
            }
        }
        return models
    }
    
    required public init?(dictionary: [String:Any]) {
        id             = dictionary.stringFor(key:"id")
        title          = dictionary.stringFor(key:"title")
        ttlDescription = dictionary.stringFor(key: "description")
        date           = dictionary.stringFor(key: "date")
    }
}


class MIProfileITSkills:NSObject,NSCopying {
    public var id         = ""
    public var skill      = MICategorySelectionInfo(dictionary: [:])
    public var version    = ""
    public var lastUsed   = ""
    public var expYear    = ""
    public var expMonth   = ""
//    public var skill = 
    public var ttlDescription = ""
    
    public class func modelsFromDictionaryArray(array:[[String:Any]]) -> [MIProfileITSkills]
    {
        var models:[MIProfileITSkills] = []
        for item in array
        {
            if let info = MIProfileITSkills(dictionary:item) {
                models.append(info)
            }
        }
        return models
    }
    
    required public init?(dictionary: [String:Any]) {
        id             = dictionary.stringFor(key:"id")
        if let skill   = dictionary["skill"] as? [String:Any] {
            self.skill = MICategorySelectionInfo(dictionary: skill)
        }
        version        = dictionary.stringFor(key:"version")
        lastUsed       = dictionary.stringFor(key:"lastUsed")
        if let exp = dictionary["experience"] as? [String:Any] {
            self.expYear  = exp.stringFor(key: "years")
            self.expMonth = exp.stringFor(key: "months")
        }
    }
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = MIProfileITSkills(id: id, skill: skill ?? MICategorySelectionInfo(), version: version, lastUsed: lastUsed, expYear: expYear, expMonth: expMonth,descrptionData:ttlDescription)
        return copy
    }
    init(id:String,skill:MICategorySelectionInfo,version:String,lastUsed:String,expYear:String,expMonth:String,descrptionData:String) {
        self.id = id
        if let skill = skill.copy() as? MICategorySelectionInfo {
            self.skill = skill
        }
        self.version = version
        self.lastUsed = lastUsed
        self.expYear = expYear
        self.expMonth = expMonth
        self.ttlDescription = descrptionData
    }
}

class MIProfileOnlinePresence:NSObject {
    public var id   = ""
    public var title = ""
    public var url = ""
    public var ttlDescription = ""
    
    public class func modelsFromDictionaryArray(array:[[String:Any]]) -> [MIProfileOnlinePresence]
    {
        var models:[MIProfileOnlinePresence] = []
        for item in array
        {
            if let info = MIProfileOnlinePresence(dictionary:item) {
                models.append(info)
            }
        }
        return models
    }
    
    required public init?(dictionary: [String:Any]) {
        id             = dictionary.stringFor(key:"id")
        title          = dictionary.stringFor(key:"name")
        url            = dictionary.stringFor(key:"url")
        ttlDescription = dictionary.stringFor(key: "description")
    }
}

class MIProfileCoursesInfo:NSObject {
    
    public var id   = ""
    public var name = ""
    public var issuer = ""
    public var expiryDate = ""

    public class func modelsFromDictionaryArray(array:[[String:Any]]) -> [MIProfileCoursesInfo]
    {
        var models:[MIProfileCoursesInfo] = []
        for item in array
        {
            if let info = MIProfileCoursesInfo(dictionary:item) {
                models.append(info)
            }
        }
        return models
    }
    
    required public init?(dictionary: [String:Any]) {
        id            = dictionary.stringFor(key:"id")
        name          = dictionary.stringFor(key:"name")
        issuer        = dictionary.stringFor(key:"issuer")
        expiryDate     = dictionary.stringFor(key:"expiryDate")

    }
}

class MIProfileProjectInfo:NSObject {
    public var id             = ""
    public var title          = ""
    public var client         = ""
    public var url            = ""
    public var startDate      = ""
    public var endDate        = ""
    public var projDesctipion = ""
    public var projLocationID = ""
    public var projLocation   = ""

    public class func modelsFromDictionaryArray(array:[[String:Any]]) -> [MIProfileProjectInfo]
    {
        var models:[MIProfileProjectInfo] = []
        for item in array
        {
            if let info = MIProfileProjectInfo(dictionary:item) {
                models.append(info)
            }
        }
        return models
    }
    
    required public init?(dictionary: [String:Any]) {
        id             = dictionary.stringFor(key:"id")
        title          = dictionary.stringFor(key:"title")
        client         = dictionary.stringFor(key:"client")
        url            = dictionary.stringFor(key:"url")
        startDate      = dictionary.stringFor(key:"startDate")
        endDate        = dictionary.stringFor(key:"endDate")
        projDesctipion = dictionary.stringFor(key:"description")
        projLocationID = dictionary.dictionaryFor(key:"location").stringFor(key:"id")
        projLocation   = dictionary.dictionaryFor(key:"location").stringFor(key:"text")
    }
}


class MIProfilePersonalDetailInfo:NSObject,NSCopying {
    
    
    public var fullName        = ""
    public var avatar          = ""
    public var primaryEmail    = ""
    public var countryCode     = ""
    public var country         = ""
    public var mobileNumber    = ""
    public var mobileNumberVerifedStatus    = false
    public var emailVerifedStatus    = false
    public var location        = MICategorySelectionInfo()
    public var nationality        = MICategorySelectionInfo()
  //  public var visaType        = MICategorySelectionInfo()

    public var homeTown        = ""
    public var profileTitle    = ""
    public var site            = ""
    public var uuid            = ""
    public var visibility      = false
    public var userImg        : UIImage?
    public var additionPersonalInfo = MIAdditionalPersonalInfo(dictionary: [:])
    public var cellArray      = [MIProfilePersonalCellInfo]()
    public var dictionary = JSONDICT()
    public var expereienceLevel = ""
    public var countryCodeName     = ""
    public var socialProviders  = [String]()
    public var updateAt = ""
    public var registartionDate: Double?
    
    init(name:String,profilePic:String,email:String,countryCode:String,country:String,mobile:String,mverifies:Bool,everifed:Bool,location:MICategorySelectionInfo,hometown:String,title:String,site:String,uuid:String,visibility:Bool,userImg:UIImage,otherUserData:MIAdditionalPersonalInfo,rowdata:[MIProfilePersonalCellInfo],dict:JSONDICT,experlevel:String,countryCodeName:String,social:[String],updateAt:String,nationality:MICategorySelectionInfo) {
        
        self.fullName = name
        self.avatar = profilePic
        self.primaryEmail = email
        self.countryCode = countryCode
        self.country = country
        self.mobileNumber = mobile
        self.mobileNumberVerifedStatus = mverifies
        self.emailVerifedStatus  = everifed
        if let loc =  location.copy() as? MICategorySelectionInfo {
            self.location =  loc
        }
        if let nat =  nationality.copy() as? MICategorySelectionInfo {
            self.nationality =  nat
        }
        self.homeTown = hometown
        self.profileTitle = title
        self.site = site
        self.uuid = uuid
        self.visibility = visibility
        self.userImg = userImg
        
        if let addtionalData =  otherUserData.copy() as? MIAdditionalPersonalInfo {
            self.additionPersonalInfo = addtionalData
        }
        
        self.cellArray = rowdata
        self.dictionary = dict
        self.expereienceLevel = experlevel
        self.countryCodeName = countryCodeName
        self.socialProviders = social
        self.updateAt = updateAt
        
        
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        
        let copyobj = MIProfilePersonalDetailInfo(name: fullName, profilePic: avatar, email: primaryEmail, countryCode: countryCode, country: country, mobile: mobileNumber, mverifies: mobileNumberVerifedStatus, everifed: emailVerifedStatus, location: location, hometown: homeTown, title: profileTitle, site: site, uuid: uuid, visibility: visibility, userImg: userImg ?? UIImage(), otherUserData: additionPersonalInfo ?? MIAdditionalPersonalInfo(dictionary: [:])! , rowdata: cellArray, dict: dictionary, experlevel: expereienceLevel, countryCodeName: countryCodeName, social: socialProviders, updateAt: updateAt, nationality: nationality)
        
        return copyobj
    }
    required public init(dictionary: [String:Any]) {
        self.dictionary = dictionary
        
        if let personalDic = dictionary["personalDetails"] as? [String:Any] {
            self.fullName = personalDic.stringFor(key: "fullName")
            if !personalDic.stringFor(key: "avatar").isEmpty {
                self.avatar   = kBaseUrl  + personalDic.stringFor(key: "avatar")
            }
            if let updateAt = personalDic["updatedAt"] as? Double {

                if let date = Date(timeIntervalSince1970: Double(updateAt/1000)) as? Date {
                    self.updateAt = date.getStringWithFormat(format: "dd MMM, yyyy")
                }
            }
            

           
            self.country  = personalDic.stringFor(key: "country")
            self.site  = personalDic.stringFor(key: "site")
            self.uuid  = personalDic.stringFor(key: "uuid")
            self.visibility  = personalDic.booleanFor(key: "visibility")
            self.expereienceLevel = personalDic.stringFor(key: "experienceLevel")
            
            self.socialProviders = personalDic["socialProviders"] as? [String] ?? []
            
            if let homeTown = personalDic["homeTown"] as? [String:Any] {
                self.homeTown = homeTown.stringFor(key: "text")
            }
            if let nationality = personalDic["nationality"] as? [String:Any] {
                self.nationality = MICategorySelectionInfo(dictionary: nationality) ?? MICategorySelectionInfo()
            }
            if let emailList = personalDic["emails"] as? [[String:Any]],emailList.count > 0 {
                var emailDic = emailList.first
                for mail in emailList {
                    if let primaryVal = mail["primary"] as? Int, primaryVal == 1 {
                        emailDic = mail
                        break
                    }
                }
                self.primaryEmail  = emailDic?.stringFor(key: "email") ?? ""
                self.emailVerifedStatus = emailDic?.booleanFor(key: "status") ?? false

            }
            if let mobileList = personalDic["mobileNumbers"] as? [[String:Any]],mobileList.count > 0 {
                let mobileDic = mobileList.first
                self.mobileNumber  = mobileDic?.stringFor(key: "mobileNumber") ?? ""
                self.countryCode   = mobileDic?.stringFor(key: "countryCode") ?? ""
                self.mobileNumberVerifedStatus = mobileDic?.booleanFor(key: "status") ?? false
            }
            if let dic = personalDic["additionalPersonalDetail"] as? [String:Any] {
                self.additionPersonalInfo = MIAdditionalPersonalInfo(dictionary: dic)
                self.profileTitle         = dic.stringFor(key: "profileTitle")
            }
           
            // create cell array
            cellArray.removeAll()
            
            var info = MIProfilePersonalCellInfo(with: "HomeTown", desc: self.homeTown)
            cellArray.append(info)

            info = MIProfilePersonalCellInfo(with: "Permanent Address", desc: self.additionPersonalInfo?.permanentAddress ?? "")
            cellArray.append(info)
            
            info = MIProfilePersonalCellInfo(with: "Gender", desc: self.additionPersonalInfo?.gender ?? "")
            cellArray.append(info)
            

            info = MIProfilePersonalCellInfo(with: "DOB", desc: self.additionPersonalInfo?.dob ?? "")
            cellArray.append(info)
            
            info = MIProfilePersonalCellInfo(with: "Pin Code", desc: self.additionPersonalInfo?.pincode ?? "")
            cellArray.append(info)
            
//            info = MIProfilePersonalCellInfo(with: "Passport Number", desc: self.additionPersonalInfo?.passportNumber ?? "")
//            cellArray.append(info)
//            
            cellArray = cellArray.filter( {$0.cellDesc != "" })
            
             //add registration gleac time
            if let time = personalDic["registartionDate"] as? Double {
                self.registartionDate = time

            }
            
        }
    }
        
    func commit() {
        AppUserDefaults.save(value: self.dictionary, forKey: .UserData, archieve: true)
       // CommonClass.recordProfile()
    }
        
}


class MIFirebaseRemoteConfigInfo: NSObject  {
    var remoteConfigStartTimeForGleac: Double?
    var remoteConfigEndTimeForGleac: Double?
    var srpFilterEnable = false
    static var sharedRemoteConfig = MIFirebaseRemoteConfigInfo()
    
     private override init() {
        super.init()
    }
    

    init(remoteConfig:RemoteConfig){
        let firStartDate = remoteConfig.configValue(forKey: "registration_date").numberValue ?? 0
        let firEndDate = remoteConfig.configValue(forKey: "registration_end_date").numberValue ?? 0
        
        let sDate = firStartDate.doubleValue //firStartDate//
        let eDate = firEndDate.doubleValue //firEndDate//
        self.remoteConfigStartTimeForGleac = sDate
        self.remoteConfigEndTimeForGleac = eDate
        self.srpFilterEnable = remoteConfig.configValue(forKey: "srpFilterEnable").boolValue
    }
    
     class func getFirebaseRemoteConfigData()  {
         let remoteConfig = RemoteConfig.remoteConfig()
         let settings = RemoteConfigSettings()
         settings.minimumFetchInterval = 3600
         remoteConfig.configSettings = settings
         remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
         remoteConfig.fetch() { (status, error) in
                        
            guard error == nil else { return }
                        
            remoteConfig.activate { (error) in
               // guard error == nil else { return }
                if remoteConfig.allKeys(from: .remote).count > 0 {
                    MIFirebaseRemoteConfigInfo.sharedRemoteConfig = MIFirebaseRemoteConfigInfo(remoteConfig: remoteConfig)
                }
            }
        }
    }
    
    class func showGleacOnPendingAction(resDate: Double?) -> Bool {
        let regDate = Double(AppDelegate.instance.userInfo.registartionDate ?? 0)
        let endDate = MIFirebaseRemoteConfigInfo.sharedRemoteConfig.remoteConfigEndTimeForGleac ?? 0
        let startDate = MIFirebaseRemoteConfigInfo.sharedRemoteConfig.remoteConfigStartTimeForGleac ?? 0
        if startDate == 0 {
           return false
        } else if endDate == 0 {
           
            if startDate.isLessThanOrEqualTo(regDate) //startDate?.isEqual(to: regDate) || startDate?.isLess(than: regDate))
            {
                return true
            }
            
            return false
         }
         else {
            
            if startDate.isLessThanOrEqualTo(regDate) && regDate.isLessThanOrEqualTo(endDate) {
                return true
            }

            return false
        }
        
     }
    
    
}


class MIAdditionalPersonalInfo:NSObject,NSCopying {
   
    
    var gender              = ""
    var dob                 = ""
    var maritalStatus       = ""
    var passportNumber      = ""
    var permanentAddress    = ""
    var pincode             = ""
    var differentlyAbled    = ""
    var workExperienceYear  = "0"
    var workExperienceMonth = "0"
//    var salaryCurreny       = ""
//    var salaryThousand      = "0"
//    var salarylakh          = "0"
//    var salaryModeName          = "Annually"
    var cityName    = ""
    var salaryModal = SalaryDetail()
    public var currentlocation        = MICategorySelectionInfo()
    var workVisaType        = MICategorySelectionInfo()

    init(gender:String,dob:String,maritalStatus:String,pasport:String,permantAddress:String,pincode:String,differentAbled:String,workexpyear:String,workexpmonth:String,cityName:String,salaryModal:SalaryDetail,curentloca:MICategorySelectionInfo,visaType:MICategorySelectionInfo) {
        
        self.gender = gender
        self.dob = dob
        self.maritalStatus = maritalStatus
        self.passportNumber = pasport
        self.permanentAddress = permantAddress
        self.pincode = pincode
        self.workExperienceYear = workexpyear
        self.workExperienceMonth = workexpmonth
        self.cityName = cityName
        if let mode = salaryModal.copy() as? SalaryDetail {
            self.salaryModal = mode
        }
        if let loc = curentloca.copy() as? MICategorySelectionInfo {
            self.currentlocation = loc
        }
        self.differentlyAbled = differentAbled
        if let visa = visaType.copy() as? MICategorySelectionInfo {
            self.workVisaType = visa
        }

    }
    func copy(with zone: NSZone? = nil) -> Any {
        let copyObj = MIAdditionalPersonalInfo(gender: self.gender, dob: self.dob, maritalStatus: self.maritalStatus, pasport: self.passportNumber, permantAddress: self.permanentAddress, pincode: self.pincode, differentAbled: self.differentlyAbled, workexpyear: self.workExperienceYear, workexpmonth: self.workExperienceMonth, cityName: self.cityName, salaryModal: self.salaryModal, curentloca: self.currentlocation,visaType: workVisaType)
        return  copyObj
    }
    
    required public init?(dictionary: [String:Any]) {
        if let gender = dictionary["gender"] as? [String:Any] {
            self.gender     = gender.stringFor(key: "text")
        }
        if let dob = dictionary.stringFor(key: "dob").dateWith(PersonalTitleConstant.dateFormatePattern)?.getStringWithFormat(format: "dd MMM yyyy") {
                self.dob = dob
        }
        passportNumber   = dictionary.stringFor(key: "passportNumber")
        permanentAddress = dictionary.stringFor(key: "permanentAddress")
        pincode          = dictionary.stringFor(key: "pincode")
        differentlyAbled = dictionary.stringFor(key: "differentlyAbled")
        if let currentLocation = dictionary["currentLocation"] as?  [String:Any] {
            currentlocation =  MICategorySelectionInfo(dictionary:currentLocation)!
            cityName        =  currentLocation.stringFor(key: "otherText")
        }
        if let workVisa = dictionary["workVisaType"] as?  [String:Any] {
            workVisaType = MICategorySelectionInfo(dictionary: workVisa) ?? MICategorySelectionInfo()
        }
        if let currentSalary = dictionary["currentSalary"] as?  [String:Any] {
            salaryModal = SalaryDetail(salary: currentSalary) ?? SalaryDetail()
//            salaryCurreny =  currentSalary.stringFor(key: "currency")
//            if salaryCurreny == "INR" {
//                let salary =  currentSalary.intFor(key: "absoluteValue")
//                let salaryLkh = salary/100000
//                salarylakh = "\(salaryLkh)"
//                salaryThousand = "\(salary%100000)"
//
//            }else{
//                salarylakh =  String(currentSalary.intFor(key: "absoluteValue"))
//                salaryThousand =  "0"
//            }
//            if let mode = currentSalary["salaryMode"] as? [String:Any]{
//                salaryModeName = mode["text"] as? String ?? "Annually"
//            }
           
        }
        if let experience = dictionary["experience"] as?  [String:Any] {
            workExperienceYear =  String(experience.intFor(key: "years"))
            workExperienceMonth =  String(experience.intFor(key: "months"))
        }
    }
}

class MIProfilePersonalCellInfo:NSObject {
    
    var cellTitle = ""
    var cellDesc  = ""
    
    init(with ttl:String,desc:String) {
        self.cellTitle = ttl
        self.cellDesc  = desc
    }
}

class MIProfilePreferenceInfo:NSObject {
    var locArray      = [MICategorySelectionInfo]()
    var industryArray = [MICategorySelectionInfo]()
    var functionArray = [MICategorySelectionInfo]()
    var rolesArray    = [MICategorySelectionInfo]()
    var jobType         = ""
    var employmentType  = ""
    var prefershiftType = ""
    var expectedSalary  = ""
    var sixDaysWeek     = false
    var userId          = ""
    var profileId       = ""
    var cellArray       = [MIProfileJobPreferenceCellInfo]()
    
    required public init?(dictionary: [String:Any]) {
        if let industryDic = dictionary["industries"] as? [[String:Any]] {
            self.industryArray = MICategorySelectionInfo.modelsFromDictionaryArray(array: industryDic)
        }
        if let funcDic = dictionary["functions"] as? [[String:Any]] {
            self.functionArray = MICategorySelectionInfo.modelsFromDictionaryArray(array: funcDic)
        }
        if let rolesDic = dictionary["roles"] as? [[String:Any]] {
            self.rolesArray = MICategorySelectionInfo.modelsFromDictionaryArray(array: rolesDic)
        }
        if let locDic = dictionary["locations"] as? [[String:Any]] {
            self.locArray = MICategorySelectionInfo.modelsFromDictionaryArray(array: locDic)
        }
        //if let expectedSalary = dictionary["expectedSalary"] as? [String:Any] {
        //}
        
        
        // create cell array
        cellArray.removeAll()
        var names = self.industryArray.filter({$0.name != ""}).map({$0.name}).joined(separator: ", ")
        var info = MIProfileJobPreferenceCellInfo(with: "Industry", desc: names)
        cellArray.append(info)
        
        names = self.functionArray.filter({$0.name != ""}).map({$0.name}).joined(separator: ", ")
        info = MIProfileJobPreferenceCellInfo(with: "Function", desc: names)
        cellArray.append(info)
        
        names = self.rolesArray.filter({$0.name != ""}).map({$0.name}).joined(separator: ", ")
        info = MIProfileJobPreferenceCellInfo(with: "Role", desc: names)
        cellArray.append(info)
        
        names = self.locArray.filter({$0.name != ""}).map({$0.name}).joined(separator: ", ")
        info = MIProfileJobPreferenceCellInfo(with: "Location", desc: names)
        cellArray.append(info)
        
        cellArray = cellArray.filter( {$0.cellDesc != "" })
    }
}

class MIProfileJobPreferenceCellInfo: NSObject {
    var cellTitle = ""
    var cellDesc  = ""
    
    init(with ttl:String,desc:String) {
        self.cellTitle = ttl
        self.cellDesc  = desc
    }
}



class MIProfileResumeInfo:NSObject {
    public var fileName     = ""
    public var filePath     = ""
    public var downloadFileName     = ""

    public class func modelsFromDictionary(dic:[String:Any]) -> MIProfileResumeInfo
    {
        var models = MIProfileResumeInfo(dictionary: [:])
        if let info = MIProfileResumeInfo(dictionary:dic) {
            models = info
        }
        return models!
    }
    
    required public init?(dictionary: [String:Any]) {
        downloadFileName = dictionary.stringFor(key:"downloadFileName")
        fileName = dictionary.stringFor(key:"filename")
        filePath = dictionary.stringFor(key:"filePath")
    }
}

class MIProfileLanguageInfo:NSObject,NSCopying {
    public var languageId  = ""
    public var language    = MICategorySelectionInfo.init(dictionary: [:])
    public var proficiency = MICategorySelectionInfo.init(dictionary: [:])
    public var read        = false
    public var write       = false
    public var speak       = false
    
    public class func modelsFromDictionaryArray(array:[[String:Any]]) -> [MIProfileLanguageInfo]
    {
        var models:[MIProfileLanguageInfo] = []
        for item in array
        {
            if let info = MIProfileLanguageInfo(dictionary:item) {
                models.append(info)
            }
        }
        return models
    }
    
    required public init?(dictionary: [String:Any]) {
        self.languageId   = dictionary.stringFor(key: "id")
        if let languageDic = dictionary["language"] as? [String:Any] {
            self.language = MICategorySelectionInfo.init(dictionary: languageDic)
        }
        
        if let proficiencyDic = dictionary["proficiency"] as? [String:Any] {
            self.proficiency = MICategorySelectionInfo.init(dictionary: proficiencyDic)
        }
        
        read   = dictionary.booleanFor(key:"read")
        write  = dictionary.booleanFor(key:"write")
        speak  = dictionary.booleanFor(key:"speak")
    }
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = MIProfileLanguageInfo.init(id: languageId, language: language ?? MICategorySelectionInfo(), proficiency: proficiency ?? MICategorySelectionInfo(), read: read, write: write, speak: speak)
        return copy
    }
  init(id:String,language:MICategorySelectionInfo,proficiency:MICategorySelectionInfo,read:Bool,write:Bool,speak:Bool) {
        self.languageId = id
        if let prof = proficiency.copy() as? MICategorySelectionInfo {
            self.proficiency = prof
        }
        if let lng = language.copy() as? MICategorySelectionInfo {
            self.language = lng
        }
        self.read = read
        self.write = write
        self.speak = speak
    }
}


