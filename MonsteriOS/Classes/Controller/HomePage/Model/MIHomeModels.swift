//
//  MIHomeModels.swift
//  MonsteriOS
//
//  Created by Piyush on 06/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

enum PendingActionType:String {
    
    case PROFILE_SUMMARY = "PROFILE_SUMMARY"
    case RESUME = "RESUME"
    case EDUCATION = "EDUCATION"
    case PERSONAL = "PERSONAL"
    case VERIFY_EMAIL_ID = "VERIFY_EMAIL_ID"
    case VERIFY_MOBILE_NUMBER = "VERIFY_MOBILE_NUMBER"
    case EMPLOYMENT = "EMPLOYMENT"
    case JOB_PREFERENCES_FUNCTION = "JOB_PREFERENCES_FUNCTION"
    case JOB_PREFERENCES_INDUSTRY = "JOB_PREFERENCES_INDUSTRY"
    case JOB_PREFERENCES_ROLE = "JOB_PREFERENCES_ROLE"
    case JOB_PREFERENCES_PREFERRED_LOCATION="JOB_PREFERENCES_PREFERRED_LOCATION"
    case PROFILE_TITLE="PROFILE_TITLE"
    case PROFILE_PICTURE="PROFILE_PICTURE"
    case KEY_SKILL="KEY_SKILL"
    case IT_SKILL="IT_SKILL"
    case RESUME_UPDATED_IN_LAST_90_DAYS="RESUME_UPDATED_IN_LAST_90_DAYS"
    case NOTICE_PERIOD="NOTICE_PERIOD"
    case COURSE_AND_CERTIFICATION="COURSE_AND_CERTIFICATION"
    case PROJECTS="PROJECTS"
    case WORK_HISTORY="WORK_HISTORY"
    case NATIONALITY="NATIONALITY"
    case NONE = "NONE"
    case ADD_MOBILE_NUMBER = "ADD_MOBILE_NUMBER"
    case PENDING_ACTIONS="PENDING_ACTIONS"
    case RECOMMENDED_JOBS="RECOMMENDED_JOBS"
    case SIMILAR_JOBS="SIMILAR_JOBS"
    case JOB_ALERTS="JOB_ALERTS"
    case OTHER = "OTHER_PENDING_ACTIONS"
    case GLEAC_SKILLS = "GLEAC_REPORT"
    
    var title :String {
        switch self {
        case .PROFILE_SUMMARY:
            return "Complete your Profile Summary."
        case .RESUME:
            return "Upload Your Resume."
        case .EDUCATION:
            return "Complete Your Education."
        case .PERSONAL:
            return "Complete your Personal detail."
        case .VERIFY_EMAIL_ID:
            return "Verify Your E-mail ID."
        case .VERIFY_MOBILE_NUMBER:
            return "Verify Your Mobile Number."
        case .EMPLOYMENT:
            return "Complete Your Employment Details."
    case .JOB_PREFERENCES_ROLE , .JOB_PREFERENCES_FUNCTION,.JOB_PREFERENCES_INDUSTRY,.JOB_PREFERENCES_PREFERRED_LOCATION:
            return "Add your Job Preferences."
        case .RESUME_UPDATED_IN_LAST_90_DAYS:
            return "Update your Resume."
        case .PROFILE_PICTURE:
            return "Upload Your Profile Picture."
        case .KEY_SKILL:
            return "Add your key skills."
        case .IT_SKILL:
            return "Add your IT skills."
        case .NOTICE_PERIOD:
            return "Update Notice Period."
        case .PROFILE_TITLE:
            return "Add a Profile Title."
        case .NATIONALITY:
            return "Add Nationality."
        case .WORK_HISTORY:
            return "Add Work History."
        case .PROJECTS:
            return "Update your project details."
        case .COURSE_AND_CERTIFICATION:
            return "Add Courses/Certifications."
        case .ADD_MOBILE_NUMBER:
            return "Add Your Mobile Number."
        case .GLEAC_SKILLS:
            return "Stand out to Employers"
        default:
            return ""
            
        }
    }
    
    var description :String {
        switch self {
        case .PROFILE_SUMMARY:
            return "Complete your profile to get notice on recuriter list."
        case .RESUME:
            return "Adding your resume helps you apply for a job with just a swipe."
        case .EDUCATION:
            return "Add details of your educational background."
        case .PERSONAL:
            return "Complete your Personal info , so that recuriter can contact you."
        case .VERIFY_EMAIL_ID:
            return "So that you never miss a mail regarding jobs and other important updates."
        case .VERIFY_MOBILE_NUMBER:
            return "So that employers/recruiters can contact you for jobs."
        case .EMPLOYMENT:
            return "Add information about your work experience."
    case .JOB_PREFERENCES_ROLE ,.JOB_PREFERENCES_FUNCTION, .JOB_PREFERENCES_INDUSTRY ,.JOB_PREFERENCES_PREFERRED_LOCATION:
            return "So that you can get relevant job recommendations."
        case .RESUME_UPDATED_IN_LAST_90_DAYS:
            return "Your Resume is more than 3 months old."
        case .PROFILE_PICTURE:
            return "Gives you an identity & helps make a better connect with recruiters."
        case .KEY_SKILL:
            return "Let employers know your area of expertise."
        case .IT_SKILL:
            return "Add your IT skills."
        case .NOTICE_PERIOD:
            return "Helps employers know your availability."
        case .PROFILE_TITLE:
            return "Introduce yourself to employers."
        case .NATIONALITY:
            return "Let employers know which country you belong to."
        case .WORK_HISTORY:
            return "Add you work history."
        case .PROJECTS:
            return "Showcase your work and achievements."
        case .COURSE_AND_CERTIFICATION:
            return "To highlight additional qualifications."
        case .ADD_MOBILE_NUMBER:
            return "So that employers/recruiters can contact you for jobs."
        case .GLEAC_SKILLS:
            return "85% of job success comes from Soft Skills. Show it in your profile in just 1 min and increase your chances of getting hired"

        default:
            return ""
            
        }
    }
    
    var actionBtnTitle:String {
        switch self {
        case .PROFILE_SUMMARY:
            return "UPDATE"
        case .RESUME:
            return "UPLOAD"
        case .EDUCATION:
            return "UPDATE"
        case .PERSONAL:
            return "UPDATE"
        case .VERIFY_EMAIL_ID:
            return "VERIFY"
        case .VERIFY_MOBILE_NUMBER:
            return "VERIFY"
        case .EMPLOYMENT:
            return "UPDATE"
        case .JOB_PREFERENCES_PREFERRED_LOCATION,.JOB_PREFERENCES_INDUSTRY,.JOB_PREFERENCES_FUNCTION,.JOB_PREFERENCES_ROLE:
            return "UPDATE"
        case .RESUME_UPDATED_IN_LAST_90_DAYS:
            return "UPDATE"
        case .PROFILE_PICTURE:
            return "UPLOAD"
        case .KEY_SKILL:
            return "ADD SKILLS"
        case .IT_SKILL:
            return "ADD IT SKILLS"
        case .NOTICE_PERIOD:
            return "UPDATE"
        case .PROFILE_TITLE:
            return "INTRODUCE"
        case .NATIONALITY:
            return "ADD"
        case .WORK_HISTORY:
            return "ADD"
        case .PROJECTS:
            return "SHOWCASE"
        case .COURSE_AND_CERTIFICATION:
            return "UPDATE"
        case .ADD_MOBILE_NUMBER:
            return "ADD"
        case .GLEAC_SKILLS:
            return "LEARN MORE"

        default:
            return ""
            
        }
    }
    var viewControler:UIViewController? {
        
        switch self {
        case .PROFILE_SUMMARY:
            return nil
        case .RESUME:
            return MIUploadResumeViewController()
        case .EDUCATION:
            return MIEducationDetailViewController()
        case .PERSONAL:
            return MIPersonalDetailVC()
        case .VERIFY_EMAIL_ID:
            return nil
        case .VERIFY_MOBILE_NUMBER:
            return MIOTPViewController()
        case .EMPLOYMENT:
            return MIEmploymentDetailViewController.newInstance
        case .PROJECTS:
            return MIProjectDetailVC()
        case .JOB_PREFERENCES_PREFERRED_LOCATION,.JOB_PREFERENCES_INDUSTRY,.JOB_PREFERENCES_FUNCTION,.JOB_PREFERENCES_ROLE:
            return MIJobPreferenceViewController()
        case .RESUME_UPDATED_IN_LAST_90_DAYS:
            return MIUploadResumeViewController()
        case .PROFILE_PICTURE:
            return nil
        case .KEY_SKILL:
            return MISkillAddViewController()
        case .IT_SKILL:
            return MIITSkillsVC()
        case .NOTICE_PERIOD:
            return MIPendingActionViewController()
        case .PROFILE_TITLE:
            return MIPendingActionViewController()
        case .NATIONALITY:
            return MIPendingActionViewController()
        case .WORK_HISTORY:
            return nil
        case .COURSE_AND_CERTIFICATION:
            return MICoursesCertificatinVC()
        case .ADD_MOBILE_NUMBER:
            return MIPendingActionViewController()
        case .GLEAC_SKILLS:
            return MIGleacVC()

        default:
            return nil
            
        }
    }
    
    var applydescription :String {
        switch self {
        case .PROFILE_SUMMARY:
            return "Complete your profile summary to Apply this Job."
        case .RESUME:
            return "Add your resume to Apply this Job"
        case .EDUCATION:
            return " Kindly complete your education details to proceed further with application"
        case .PERSONAL:
            return "Complete your Personal info , so that you can  Apply this Job."
        case .VERIFY_EMAIL_ID:
            return "Verify your email id to Apply this Job"
        case .VERIFY_MOBILE_NUMBER:
            return "Verify your mobile number so that to Apply this Job"
        case .EMPLOYMENT:
            return "Kindly complete your employment details to proceed further with application"
        case .PROJECTS:
            return "Complete your project detail to Apply this Job"
        default:
            return ""
            
        }
    }
    
    var jobSeekerCardName : String {
        switch self {
        case .PROFILE_SUMMARY:
            return "Complete_your_Profile_Summary".uppercased()
        case .RESUME:
            return "Upload_Your_Resume".uppercased()
        case .EDUCATION:
            return "Complete_Your_Education".uppercased()
        case .PERSONAL:
            return "Complete_your_Personal_detail".uppercased()
        case .VERIFY_EMAIL_ID:
            return "Verify_Your_E-mail_ID".uppercased()
        case .VERIFY_MOBILE_NUMBER:
            return "Verify_Your_Mobile_Number".uppercased()
        case .EMPLOYMENT:
            return "Complete_Your_Employment_Details".uppercased()
        case .JOB_PREFERENCES_ROLE , .JOB_PREFERENCES_FUNCTION,.JOB_PREFERENCES_INDUSTRY,.JOB_PREFERENCES_PREFERRED_LOCATION:
            return "Add_your_Job_Preferences".uppercased()
        case .RESUME_UPDATED_IN_LAST_90_DAYS:
            return "Update_your_Resume".uppercased()
        case .PROFILE_PICTURE:
            return "Upload_Your_Profile_Picture".uppercased()
        case .KEY_SKILL:
            return "Add_your_key_skills".uppercased()
        case .IT_SKILL:
            return "Add_your_IT_skills".uppercased()
        case .NOTICE_PERIOD:
            return "Update_Notice_Period".uppercased()
        case .PROFILE_TITLE:
            return "Add_a_Profile_Title".uppercased()
        case .NATIONALITY:
            return "Add_Nationality".uppercased()
        case .WORK_HISTORY:
            return "Add_Work_History".uppercased()
        case .PROJECTS:
            return "Update_your_project_details".uppercased()
        case .COURSE_AND_CERTIFICATION:
            return "Add_Courses/Certifications".uppercased()
        case .ADD_MOBILE_NUMBER:
            return "Add_Your_Mobile_Number".uppercased()
        default:
            return ""
    }
    }
}

class MIHomeModel: NSObject
{
    var position = "0"
    var moduleName = ""
    var placeHolder = ""
    var headerTitle = ""
    var aliasName = ""
    var data = ""
    var dataJson = [[String:Any]]()
    var dicModel = [String:Any]()
    var isDataAvailable = false
    //    init(with pos:String,dtType:String,vwNm:String) {
    //        position = pos
    //        dtType = dtType
    //        viewName = vwNm
    //    }
    
    init(with dic:[String:Any]) {
        position = dic.stringFor(key: "position")
        placeHolder = dic.stringFor(key: "placeholder")
        aliasName = dic.stringFor(key: "alias")
        moduleName = dic.stringFor(key: "name")
        if let moduleEnum = MIHomeModuleEnums(rawValue: aliasName) {
            headerTitle = moduleEnum.headerTitle
        }
        data = dic.stringFor(key: "data")
        isDataAvailable = false
        
        //static data
        if self.aliasName == MIHomeModuleEnums.reports.rawValue {
            dicModel[aliasName] = MIHomeEmploymentIndex.modelsFromDictionaryArray(array: employmentIndexDic)
        }
                
        if !data.isEmpty {
            
            if self.aliasName == MIHomeModuleEnums.jobCategory.rawValue
            {
                if  let jsonArray = data.convertStringToJSon() as? [[String:Any]] {
                    dicModel[aliasName] = MIHomeJobCategory.modelsFromDictionaryArray(array: jsonArray)
                    isDataAvailable = true
                }
            }
            
            if self.aliasName == MIHomeModuleEnums.careerService.rawValue {
                if  let jsonArray = data.convertStringToJSon() as? [[String:Any]] {
                    dicModel[aliasName] = MIHomeCareerService.modelsFromDictionaryArray(array: jsonArray)
                    isDataAvailable = true
                }
            }
            
            
//            if self.aliasName == MIHomeModuleEnums.reports.rawValue {
//                if  let jsonArray = data.convertStringToJSon() as? [[String:Any]] {
//                    dicModel[aliasName] = MIHomeReport.modelsFromDictionaryArray(array: jsonArray )
//                    isDataAvailable = true
//                }
//            }
            
            if self.aliasName == MIHomeModuleEnums.videos.rawValue {
                if  let jsonArray = data.convertStringToJSon() as? [[String:Any]] {
                    dicModel[aliasName] = MIHomeVideos.modelsFromDictionaryArray(array: jsonArray)
                    isDataAvailable = true
                }
            }
            
            if self.aliasName == MIHomeModuleEnums.article.rawValue {
                if  let jsonDic = data.convertStringToJSonArticle() as? [String:Any] {
                    if let jsonArray = jsonDic["data"] as? [[String:Any]] {
                        dicModel[aliasName] = MIHomeArticle.modelsFromDictionaryArray(array: jsonArray)
                        isDataAvailable = true
                    }
                }
            }
            
            if self.aliasName == MIHomeModuleEnums.pendingAction.rawValue {
                if  let jsonDic = data.convertStringToJSonArticle() as? [String:Any] {
                    if let jsonAction = jsonDic["pendingActionSection"] as? [String:Any] {
                        if let jsonArray = jsonAction["pendingActions"] as? [[String:Any]] {
                            if jsonArray.count == 0 {
                                isDataAvailable = false
                                return
                            }
                            let data = MIPendingItemModel.modelsFromDictionaryArray(array: jsonArray)
                            if data.count == 0 {
                                isDataAvailable = false
                                return
                            }

                            dicModel[aliasName] = data
                            isDataAvailable = true
                            var progress = 100 - jsonArray.reduce(0, { $0+$1.intFor(key: "weightage") })
                            progress = progress < 0 ? 0 : progress
                            AppUserDefaults.save(value: progress, forKey: .ProfileProgress)
                        }
                    }
                }
            }
            
            
            if self.aliasName == MIHomeModuleEnums.recomondedJob.rawValue {
                if  let jsonDic = data.convertStringToJSonArticle() as? [String:Any] {
//                    if let jsonArray = jsonDic["data"] as? [[String:Any]] {
//                        if jsonArray.count == 0 {
//                            isDataAvailable = false
//                            return
//                        }
//                    }
                        dicModel[aliasName] = JoblistingBaseModel(dictionary: jsonDic as NSDictionary)
                            //MIPendingHomeAction.modelsFromDictionaryArray(array: jsonArray)
                        isDataAvailable = true
                 //   }
                }
            }
            
            if self.aliasName == MIHomeModuleEnums.monsterEducation.rawValue {
                if  let jsonList = data.convertStringToJSon() as? [[String:Any]] {
                        dicModel[aliasName] = MIMonsterEducation.modelsFromDictionaryArray(array: jsonList)
                        isDataAvailable = true
                    
                }
            }
            
            
            //add Gleac Model
            if self.aliasName == MIHomeModuleEnums.GleacSkill.rawValue {
                if  let jsonDic = data.convertStringToJSonArticle() as? [String:Any] {
                    
                    if jsonDic.count == 0 {
                        isDataAvailable = false
                        return
                    }
                    if let jsonAction = jsonDic["gleacReportSection"] as? [String:Any] {
                        dicModel[aliasName] = MIHomeGleacSkillIndexModel.init(dictionary: jsonAction)                            
                            //dicModel[aliasName] = MIHomeGleacSkillIndexModel.modelsFromDictionaryArray(array: jsonAction)
                            isDataAvailable = true
                    }
                }
            }
            
            //add Job Top Company
            if self.aliasName == MIHomeModuleEnums.topCompanies.rawValue {
                if let jsonArr = data.convertStringToJSon() as? [[String: Any]] {
                    dicModel[aliasName] = MIHomeJobTopCompanyModel.modelsFromDictionaryArray(array: jsonArr)
                     isDataAvailable = true
                }
            }

            
        }
        
    }
        
}

class MIHomeJobCategory: NSObject {
    private enum MIHomeJobCategoryEnum:String {
        case walkin = "walk"
        case fresher = "fresher"
        case contract = "contract"
        case itJob    = "IT job"
        case engineering = "engineering"
        case finance     = "finance"
        case customerService = "customer"
        case sale            = "sale"
        case nearMe         = "near me"
        static var list:[String] {
            let experience = AppDelegate.instance.userInfo.expereienceLevel
            if experience.lowercased() != "experienced" { 
              return [self.walkin.rawValue,self.fresher.rawValue,self.contract.rawValue,self.itJob.rawValue,self.engineering.rawValue,self.finance.rawValue,self.customerService.rawValue,self.sale.rawValue,self.nearMe.rawValue]
            } else {
                    return [self.walkin.rawValue,self.contract.rawValue,self.itJob.rawValue,self.engineering.rawValue,self.finance.rawValue,self.customerService.rawValue,self.sale.rawValue,self.nearMe.rawValue]
                }
        }
        
        var imgName:String {
            let suffix = "_job_icon"
            var imgName = ""
            switch self {
            case .walkin:
                imgName = "walkin"
            case .fresher:
                imgName = "fresher"
            case .contract:
                imgName = "contract"
            case .itJob:
                imgName = "it"
            case .engineering:
                imgName = "engineering"
            case .finance:
                imgName = "finance"
            case .customerService:
                imgName = "customer_service"
            case .sale:
                imgName = "sale"
            case .nearMe: imgName = "nearMe"
            }
            return "\(imgName)\(suffix)"
        }
        
        var type:HomeJobCategoryType {
            switch self {
                case .walkin:
                    return HomeJobCategoryType.walkin
                case .fresher:
                    return HomeJobCategoryType.fresherJobs
                case .contract:
                    return HomeJobCategoryType.contractJobs
                case .itJob:
                    return HomeJobCategoryType.itJobs
                case .engineering:
                    return HomeJobCategoryType.manufature
                case .finance:
                    return HomeJobCategoryType.finance
                case .customerService:
                    return HomeJobCategoryType.bpoCustomer
                case .sale:
                    return HomeJobCategoryType.sales
            case .nearMe :
                return HomeJobCategoryType.nearMe
            }
        }
    }
    
    public var site_id = ""
    public var name  = ""
    public var id = ""
    public var menu_group = ""
    public var link_rewrite = ""
    public var imgName      = ""
    public var jobType      = HomeJobCategoryType.walkin
    public class func modelsFromDictionaryArray(array:[[String:Any]]) -> [MIHomeJobCategory]
    {
        var models:[MIHomeJobCategory] = []
        for item in array
        {
            if let info = MIHomeJobCategory(dictionary:item){
                let name = info.name.lowercased()
                let jobEnum = MIHomeJobCategoryEnum.list.filter({name.contains($0.lowercased())})
                if jobEnum.count > 0, let jobCategoryEnum = MIHomeJobCategoryEnum(rawValue: jobEnum.first ?? "") {
                    info.imgName = jobCategoryEnum.imgName
                    info.jobType = jobCategoryEnum.type
                    models.append(info)
                }
                
            }
        }
        return models
    }
    
    required public init?(dictionary: [String:Any]) {
        site_id =  dictionary.stringFor(key: "site_id")
        name = dictionary.stringFor(key: "name")
        id =   dictionary.stringFor(key: "id")
        menu_group = dictionary.stringFor(key: "menu_group")
        link_rewrite =  dictionary.stringFor(key: "link_rewrite")
    }
}

class MIHomeCareerService: NSObject {
    public var image        = ""
    public var start_label  = ""
    public var price        = ""
    public var name    = ""
    public var site_id = ""
    public var lang_id = ""
    public var ttlDescription = ""
    public var id  = ""
    public var url = ""
    
    public class func modelsFromDictionaryArray(array:[[String:Any]]) -> [MIHomeCareerService]
    {
        var models:[MIHomeCareerService] = []
        for item in array
        {
            if let info = MIHomeCareerService(dictionary:item){
                models.append(info)
            }
        }
        return models
    }
    
    required public init?(dictionary: [String:Any]) {
        image =  kImgBaseUrl + dictionary.stringFor(key: "image")
        start_label = dictionary.stringFor(key: "start_label")
        price = dictionary.stringFor(key: "price")
        name = dictionary.stringFor(key: "name")
        site_id =  dictionary.stringFor(key: "site_id")
        lang_id =  dictionary.stringFor(key: "lang_id")
        ttlDescription = dictionary.stringFor(key: "description")
        id = dictionary.stringFor(key: "id")
        url = dictionary.stringFor(key: "url")
    }
}


class MIHomeReport:NSObject  {
    public var deviceName = ""
    public var brand = ""
    public var technology = ""
    public var gprs = ""
    public var edge = ""
    public var announced = ""
    public var status = ""
    public var dimensions = ""
    public var weight = ""
    public var sim = ""
    public var type = ""
    public var size = ""
    public var resolution = ""
    public var card_slot = ""
    public var alert_types = ""
    public var loudspeaker_ = ""
    public var wlan = ""
    public var bluetooth = ""
    public var gps = ""
    public var radio = ""
    public var usb = ""
    public var messaging = ""
    public var browser = ""
    public var java = ""
    public var features_c = ""
    public var battery_c = ""
    public var stand_by = ""
    public var talk_time = ""
    public var colors = ""
    public var sar_us = ""
    public var sar_eu = ""
    public var sensors = ""
    public var cpu = ""
    public var os = ""
    public var primary_ = ""
    public var video = ""
    public var secondary = ""
    public var music_play = ""
    public var protection = ""
    public var gpu = ""
    public var multitouch = ""
    public var _2g_bands = ""
    public var _3_5mm_jack_ = ""
    
    public class func modelsFromDictionaryArray(array:[[String:Any]]) -> [MIHomeReport]
    {
        var models:[MIHomeReport] = []
        for item in array
        {
            if let info = MIHomeReport(dictionary:item){
                models.append(info)
            }
        }
        return models
    }
    
    required public init?(dictionary: [String:Any]) {
        
        deviceName = dictionary.stringFor(key: "DeviceName")
        brand = dictionary.stringFor(key: "Brand")
        technology = dictionary.stringFor(key: "technology")
        gprs = dictionary.stringFor(key: "gprs")
        edge = dictionary.stringFor(key: "edge")
        announced = dictionary.stringFor(key: "announced")
        status = dictionary.stringFor(key: "status")
        dimensions = dictionary.stringFor(key: "dimensions")
        weight = dictionary.stringFor(key: "weight")
        sim = dictionary.stringFor(key: "sim")
        type = dictionary.stringFor(key: "type")
        size = dictionary.stringFor(key: "size")
        resolution = dictionary.stringFor(key: "resolution")
        card_slot = dictionary.stringFor(key: "card_slot")
        alert_types = dictionary.stringFor(key: "alert_types")
        loudspeaker_ = dictionary.stringFor(key: "loudspeaker_")
        wlan = dictionary.stringFor(key: "wlan")
        bluetooth = dictionary.stringFor(key: "bluetooth")
        gps = dictionary.stringFor(key: "gps")
        radio = dictionary.stringFor(key: "radio")
        usb = dictionary.stringFor(key: "usb")
        messaging = dictionary.stringFor(key: "messaging")
        browser = dictionary.stringFor(key: "browser")
        java = dictionary.stringFor(key: "java")
        features_c = dictionary.stringFor(key: "features_c")
        battery_c = dictionary.stringFor(key: "battery_c")
        stand_by = dictionary.stringFor(key: "stand_by")
        talk_time = dictionary.stringFor(key: "talk_time")
        colors = dictionary.stringFor(key: "colors")
        sar_us = dictionary.stringFor(key: "sar_us")
        sar_eu = dictionary.stringFor(key: "sar_eu")
        sensors = dictionary.stringFor(key: "sensors")
        cpu = dictionary.stringFor(key: "cpu")
        os = dictionary.stringFor(key: "os")
        primary_ = dictionary.stringFor(key: "primary_")
        video = dictionary.stringFor(key: "video")
        secondary = dictionary.stringFor(key: "secondary")
        music_play = dictionary.stringFor(key: "music_play")
        protection = dictionary.stringFor(key: "protection")
        gpu = dictionary.stringFor(key: "gpu")
        multitouch = dictionary.stringFor(key: "multitouch")
        _2g_bands = dictionary.stringFor(key: "_2g_bands")
        _3_5mm_jack_ = dictionary.stringFor(key: "_3_5mm_jack_")
    }
}

class MIHomeVideos:NSObject {
    public var name = ""
    public var image = ""
    public var id = ""
    public var video_url = ""
    
    public class func modelsFromDictionaryArray(array:[[String:Any]]) -> [MIHomeVideos]
    {
        var models:[MIHomeVideos] = []
        for item in array
        {
            if let info = MIHomeVideos(dictionary:item){
                models.append(info)
            }
        }
        return models
    }
    
    required public init?(dictionary: [String:Any]) {
        name = dictionary.stringFor(key:"name")
        image = kImgBaseUrl + dictionary.stringFor(key:"image")
        id = dictionary.stringFor(key:"id")
        video_url = dictionary.stringFor(key:"video_url")
    }
}


class MIHomeArticle:NSObject {
    public var id  = ""
    public var section_id = ""
    public var created_at = ""
    public var updated_at = ""
    public var subchannel_id = ""
    public var image = ""
    public var source = ""
    public var title = ""
    public var summary = ""
    public var posting_date = ""
    public var href = ""
    
    public class func modelsFromDictionaryArray(array:[[String:Any]]) -> [MIHomeArticle]
    {
        var models:[MIHomeArticle] = []
        for item in array
        {
            if let info = MIHomeArticle(dictionary:item){
                models.append(info)
            }
        }
        return models
    }
    
    required public init?(dictionary: [String:Any]) {
        id = dictionary.stringFor(key:"id")
        section_id = dictionary.stringFor(key:"section_id")
        created_at = dictionary.stringFor(key:"created_at")
        updated_at = dictionary.stringFor(key:"updated_at")
        subchannel_id = dictionary.stringFor(key:"subchannel_id")
        image  = kImgBaseUrl + dictionary.stringFor(key:"image")
        source = dictionary.stringFor(key:"source")
        title = dictionary.stringFor(key:"title")
        summary = dictionary.stringFor(key:"summary")
        posting_date = dictionary.stringFor(key:"posting_date")
        href = "https://\(WebURl.domain ?? "my.monsterindia.com")\(dictionary.stringFor(key:"href"))"
    }
}

class MIHomeEmploymentIndex:NSObject {

    var title = ""
    var imgName = ""
    var ttlDescription = ""
    var titleLink  = ""
    var url        = ""
    var controllerTitle = ""
    public class func modelsFromDictionaryArray(array:[[String:Any]]) -> [MIHomeEmploymentIndex]
    {
        var models:[MIHomeEmploymentIndex] = []
        for item in array
        {
            if let info = MIHomeEmploymentIndex(dictionary:item){
                models.append(info)
            }
        }
        return models
    }
    
    required public init?(dictionary: [String:Any]) {
        title          = dictionary.stringFor(key:"title")
        imgName        = dictionary.stringFor(key:"imgName")
        ttlDescription = dictionary.stringFor(key:"description")
        titleLink      = dictionary.stringFor(key:"titleLink")
        url            = dictionary.stringFor(key:"url")
        controllerTitle = dictionary.stringFor(key:"controllerTitle")
    }
    
}

//Gleac Skills data model
class MIHomeGleacSkillIndexModel: NSObject {

    public var gleacReport: Bool? = false
    public var candidateId: String?
    public var createdAt: Int?
    public var updatedAt: Int?
    
    public class func modelsFromDictionaryArray(array: [[String:Any]]) -> [MIHomeGleacSkillIndexModel]
    {
        var models:[MIHomeGleacSkillIndexModel] = []
        for item in array
        {
            if let info = MIHomeGleacSkillIndexModel(dictionary:item){
                models.append(info)
            }
        }
        return models
    }

    required public init?(dictionary: [String:Any]) {
        gleacReport         = dictionary.booleanFor(key: "gleacReport")
        candidateId         = dictionary.stringFor(key:"candidateId")
        createdAt           = dictionary.intFor(key:"createdAt")
        updatedAt           = dictionary.intFor(key:"updatedAt")
    }

}

// Top Companies data model
class MIHomeJobTopCompanyModel: NSObject {
    
    public var name : String?
    public var logo : String?
    public var companyId : Int?
    public var id : String?
    public var link_rewrite : String?

    public class func modelsFromDictionaryArray(array: [[String:Any]]) -> [MIHomeJobTopCompanyModel]
    {
        var models:[MIHomeJobTopCompanyModel] = []

        for item in array
        {
            if let info = MIHomeJobTopCompanyModel(dictionary:item){
                models.append(info)
            }
        }
        return models
    }


    required public init?(dictionary: [String:Any]) {
        id                   = dictionary["id"] as? String
        companyId            = dictionary["companyId"] as? Int
        name                 = dictionary["name"] as? String
        logo                 = dictionary["logo"] as? String
        link_rewrite         = dictionary["link_rewrite"] as? String

    }

}


public class MIPendingItemModel :NSObject {
    
    var pendingItemName = ""
    var itemWeightage = "0"
    var itemTitle = ""
    var itemDescription = ""
    var pendingActionType : PendingActionType = PendingActionType.NONE
    var pendingItemStateVisible = true
    var itemCount = 0
   
    public class func modelsFromDictionaryArray(array:[[String:Any]]) -> [MIPendingItemModel] {
      //  && Int(info.itemWeightage) ?? 0 > 0
        var models:[MIPendingItemModel] = []
        for item in array
        {
            if let info = MIPendingItemModel(dict:item){
                //&& Int(info.itemWeightage) ?? 0 > 0
                if info.pendingActionType != .NONE && Int(info.itemWeightage) ?? 0 > 0   {
                    if info.pendingActionType == PendingActionType.JOB_PREFERENCES_PREFERRED_LOCATION {
                        let jobPreferences = models.filter( { $0.pendingActionType == PendingActionType.JOB_PREFERENCES_PREFERRED_LOCATION })
                        if jobPreferences.count == 0 {
                            models.append(info)
                        }else{
                            if let jobPrefernces = jobPreferences.first {
                                jobPrefernces.itemCount = jobPrefernces.itemCount + 1
                            }
                        }
                    }else{
                        models.append(info)
                    }
                }
                //add pending action for gleac
                else if info.pendingActionType ==  PendingActionType.GLEAC_SKILLS {
                    if MIFirebaseRemoteConfigInfo.showGleacOnPendingAction(resDate: AppDelegate.instance.userInfo.registartionDate) {
                        models.append(info)
                    }
                      //models.append(info) // models.insert(info, at: models.startIndex)
                    
                }
            }
        }
        return models
    }
    
    required public init?(dict:[String:Any]) {
        
        self.pendingItemName = dict.stringFor(key: "name")
        self.itemWeightage = dict.stringFor(key: "weightage")
        
        switch self.pendingItemName {
        case PendingActionType.EDUCATION.rawValue:
            self.pendingActionType = PendingActionType.EDUCATION
        case PendingActionType.EMPLOYMENT.rawValue:
            self.pendingActionType = PendingActionType.EMPLOYMENT
        case PendingActionType.RESUME.rawValue:
            self.pendingActionType = PendingActionType.RESUME
        case PendingActionType.VERIFY_EMAIL_ID.rawValue:
            self.pendingActionType = PendingActionType.VERIFY_EMAIL_ID
        case PendingActionType.VERIFY_MOBILE_NUMBER.rawValue:
            self.pendingActionType = PendingActionType.VERIFY_MOBILE_NUMBER
        case PendingActionType.PROFILE_SUMMARY.rawValue:
            self.pendingActionType = PendingActionType.PROFILE_SUMMARY
        case PendingActionType.PERSONAL.rawValue:
            self.pendingActionType = PendingActionType.PERSONAL
        case PendingActionType.JOB_PREFERENCES_PREFERRED_LOCATION.rawValue,PendingActionType.JOB_PREFERENCES_INDUSTRY.rawValue,PendingActionType.JOB_PREFERENCES_FUNCTION.rawValue,PendingActionType.JOB_PREFERENCES_ROLE.rawValue:
            self.pendingActionType = PendingActionType.JOB_PREFERENCES_PREFERRED_LOCATION
            self.itemCount = self.itemCount + 1
        case PendingActionType.PROFILE_PICTURE.rawValue:
            self.pendingActionType = PendingActionType.PROFILE_PICTURE
        case PendingActionType.PROFILE_TITLE.rawValue:
            self.pendingActionType = PendingActionType.PROFILE_TITLE
        case PendingActionType.COURSE_AND_CERTIFICATION.rawValue:
            self.pendingActionType = PendingActionType.COURSE_AND_CERTIFICATION
        case PendingActionType.KEY_SKILL.rawValue:
            self.pendingActionType = PendingActionType.KEY_SKILL
        case PendingActionType.IT_SKILL.rawValue:
            self.pendingActionType = PendingActionType.IT_SKILL
        case PendingActionType.NOTICE_PERIOD.rawValue:
            self.pendingActionType = PendingActionType.NOTICE_PERIOD
        case PendingActionType.PROJECTS.rawValue:
            self.pendingActionType = PendingActionType.PROJECTS
        case PendingActionType.RESUME_UPDATED_IN_LAST_90_DAYS.rawValue:
            self.pendingActionType = PendingActionType.RESUME_UPDATED_IN_LAST_90_DAYS
//        case PendingActionType.WORK_HISTORY.rawValue:
//            self.pendingActionType = PendingActionType.WORK_HISTORY
        case PendingActionType.NATIONALITY.rawValue:
            self.pendingActionType = PendingActionType.NATIONALITY
        case PendingActionType.ADD_MOBILE_NUMBER.rawValue:
            self.pendingActionType = PendingActionType.ADD_MOBILE_NUMBER
        
        case PendingActionType.GLEAC_SKILLS.rawValue:
            self.pendingActionType = PendingActionType.GLEAC_SKILLS

        default:
            self.pendingActionType = PendingActionType.NONE

        }

    }
    
}

class MIMonsterEducation:NSObject {
    
    var title = ""
    var id = ""
    var link_rewrite = ""
    var meta_keywords  = ""
    var name        = ""
    
    public class func modelsFromDictionaryArray(array:[[String:Any]]) -> [MIMonsterEducation]
    {
        var models:[MIMonsterEducation] = []
        for item in array
        {
            if let info = MIMonsterEducation(dictionary:item){
                models.append(info)
            }
        }
        return models
    }
    
    required public init?(dictionary: [String:Any]) {
        title          = dictionary.stringFor(key:"title")
        name        = dictionary.stringFor(key:"name")
        link_rewrite = dictionary.stringFor(key:"link_rewrite")
        meta_keywords      = dictionary.stringFor(key:"meta_keywords")
        id            = dictionary.stringFor(key:"id")
    }
}
// static data Employment Index
var employmentIndexDic = [["title":"Monster Employment Index","description":"The Monster Employment Index is a broad and comprehensive monthly analysis of online job posting activity conducted by Monster India.","imgName":"employment_index1","titleLink":"Learn More","url":"https://\(WebURl.domain ?? "monsterindia.com")/employment-index/","controllerTitle":"Employment Index"],["title":"Monster Salary Index","description":"Know whether you earn more or less than your peers, without violating privacy with Monster Career Benchmarking.","imgName":"employment_index2","titleLink":"Compare Your Salary","url":"https://my.monsterindia.com/salary-check.html","controllerTitle":"Salary Index"]]

