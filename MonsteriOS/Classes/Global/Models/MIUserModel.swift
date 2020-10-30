//
//  MIUserModel.swift
//  MonsteriOS
//
//  Created by Rakesh on 15/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
enum AccountTypeVia {
    case facebook
    case Google
    case Manual
}
enum UserProfessionalCategory : String{
    case Fresher = "FRESHER"
    case Experienced = "EXPERIENCED"
    case None = "NONE"
    
}
class MIUserResume : NSObject {
    var resumePath  = ""
    var resumeBucket  = ""
    var resumeViaImages  = false
    var resumeName  = ""
    var resumeSizeInMb  = 0
    var resumeExtension  = ""
    
    init(with params:[String:Any]) {
        if let resumeParam = params[APIKeys.resumeAPIKey] as? [String:Any] {
            resumeBucket = resumeParam.stringFor(key: APIKeys.bucketAPIKey)
            resumePath = resumeParam.stringFor(key: APIKeys.pathAPIKey)
        }
    }
}
class MIDisabilityDetail : NSObject {
    
    var type = MICategorySelectionInfo()
    var subtype = MICategorySelectionInfo()
    var detail = MICategorySelectionInfo()
    var disabilityDescription = ""
    var disabilityCertificate  = ""
    var disabilityIssuer  = ""
    
    override init() {
        
    }
    init(disabilityDict:[String:Any]) {
        self.disabilityCertificate = disabilityDict.stringFor(key: APIKeys.disabilitycertificationNoAPIKey)
        self.disabilityDescription = disabilityDict.stringFor(key: APIKeys.disabilitydescriptionAPIKey)
        self.disabilityIssuer = disabilityDict.stringFor(key: APIKeys.disabilityissueByAPIKey)
        if let type = disabilityDict[APIKeys.disabilitytypeAPIKey] as? [String:Any] {
            self.type = MICategorySelectionInfo(dictionary: type) ?? MICategorySelectionInfo()
        }
        if let subtype = disabilityDict[APIKeys.disabilitysubtypeAPIKey] as? [String:Any] {
            self.subtype = MICategorySelectionInfo(dictionary: subtype) ?? MICategorySelectionInfo()
        }
        if let details = disabilityDict[APIKeys.detailAPIKey] as? [String:Any] {
            self.detail = MICategorySelectionInfo(dictionary: details) ?? MICategorySelectionInfo()
        }
    }
    
}
class MIPersonalDetail:NSObject {
    
    var homeTown = MICategorySelectionInfo()
    var permentantAddress = ""
    var gender = MICategorySelectionInfo()
    var dob : Date?
    var pincode = ""
    var maretialStatus = MICategorySelectionInfo()
    var category = MICategorySelectionInfo()
    var passportNumber = ""
    var workPermits = [MICategorySelectionInfo]()
    var workPermitUSA = MICategorySelectionInfo()
    var nationality = MICategorySelectionInfo()
    var speciallAbled = false
    var disabilityObj = MIDisabilityDetail()
    var residentStatus = [MICategorySelectionInfo]()
    
    class func getParamsForRegisterPersonalDetail(personalData:MIPersonalDetail) -> [String:Any] {
        var params = [String:Any]()
        var additionalPersonalDetail = [String:Any]()
        
        additionalPersonalDetail[APIKeys.genderAPIKey] = MIUserModel.getParamForIdText(id:personalData.gender.uuid, value: personalData.gender.name)
        if personalData.dob != nil {
            additionalPersonalDetail[APIKeys.dobAPIKey] = personalData.dob?.getStringWithFormat(format: PersonalTitleConstant.dateFormatePattern)
        }
        
        if  !MIUserModel.userSharedInstance.visaType.name.isEmpty && MIUserModel.userSharedInstance.visaType.name != kDONT_HAVE_WORK_AUTHORIZATION{
            additionalPersonalDetail[APIKeys.workVisaTypeUpdated] = true
            
            additionalPersonalDetail[APIKeys.workVisaType] = MIUserModel.getParamForIdText(id: MIUserModel.userSharedInstance.visaType.uuid , value: MIUserModel.userSharedInstance.visaType.name)
            if MIUserModel.userSharedInstance.cityName.isEmpty {
                additionalPersonalDetail[APIKeys.currentLocationAPIKey] = MIUserModel.getParamForIdText(id: MIUserModel.userSharedInstance.userlocationModal.uuid, value: MIUserModel.userSharedInstance.userlocationModal.name)
                       
            }else{
                var locationParam = MIUserModel.getParamForIdText(id: MIUserModel.userSharedInstance.userlocationModal.uuid, value: MIUserModel.userSharedInstance.userlocationModal.name)
                locationParam[APIKeys.otherTextAPIKey] = MIUserModel.userSharedInstance.cityName
                additionalPersonalDetail[APIKeys.currentLocationAPIKey] = locationParam
            }
        }
       
        additionalPersonalDetail[APIKeys.maritalStatusAPIKey] = MIUserModel.getParamForIdText(id: (personalData.maretialStatus.uuid), value: personalData.maretialStatus.name)
        var workAuthorizedCountries = [[String:Any]]()
        if personalData.workPermits.count > 0 {
            for obj in personalData.workPermits {
                var workAuthorized = [String:Any]()
                workAuthorized = MIUserModel.getParamForIdText(id: (obj.uuid), value: obj.name)
                workAuthorizedCountries.append(workAuthorized)
                
            }
        }
        additionalPersonalDetail[APIKeys.workAuthorizedCountriesAPIKey] = workAuthorizedCountries
        params[APIKeys.additionalPersonalDetailAPIKey] = additionalPersonalDetail
        
        return params
        
    }
    class func getDictFromPersonalDetailList(personalData:MIPersonalDetail) -> [String:Any] {
        
        var params = [String:Any]()
        params[APIKeys.homeTownAPIKey] = MIUserModel.getParamForIdText(id: (personalData.homeTown.uuid), value: personalData.homeTown.name)
        params[APIKeys.nationalityAPIKey] = MIUserModel.getParamForIdText(id: (personalData.nationality.uuid), value: personalData.nationality.name)
        
        var additionalPersonalDetail = [String:Any]()
        additionalPersonalDetail[APIKeys.permanentAddressAPIKey] = personalData.permentantAddress
        additionalPersonalDetail[APIKeys.genderAPIKey] = MIUserModel.getParamForIdText(id:personalData.gender.uuid, value: personalData.gender.name)
        if personalData.dob != nil {
            additionalPersonalDetail[APIKeys.dobAPIKey] = personalData.dob?.getStringWithFormat(format: PersonalTitleConstant.dateFormatePattern)
        }
        additionalPersonalDetail[APIKeys.pincodeAPIKey] = personalData.pincode
        additionalPersonalDetail[APIKeys.maritalStatusAPIKey] = MIUserModel.getParamForIdText(id: (personalData.maretialStatus.uuid), value: personalData.maretialStatus.name)
        additionalPersonalDetail[APIKeys.categoryAPIKey] = MIUserModel.getParamForIdText(id: (personalData.category.uuid), value: personalData.category.name)
        additionalPersonalDetail[APIKeys.passportNumberAPIKey] = personalData.passportNumber
        var workAuthorizedCountries = [[String:Any]]()
        
        if personalData.workPermits.count > 0 {
            for obj in personalData.workPermits {
                workAuthorizedCountries.append(MIUserModel.getParamForIdText(id: (obj.uuid), value: obj.name))
            }
        }
        additionalPersonalDetail[APIKeys.workAuthorizedCountriesAPIKey] = workAuthorizedCountries
        
        workAuthorizedCountries = [[String:Any]]()
        if personalData.residentStatus.count > 0 {
            for obj in personalData.residentStatus {
                workAuthorizedCountries.append( MIUserModel.getParamForIdText(id: (obj.uuid), value: obj.name))
                
            }
        }
        additionalPersonalDetail[APIKeys.residentCountriesAPIKey] = workAuthorizedCountries
        
        additionalPersonalDetail[APIKeys.workStatusUSAAPIKey] = MIUserModel.getParamForIdText(id: (personalData.workPermitUSA.uuid), value: personalData.workPermitUSA.name)
        additionalPersonalDetail[APIKeys.differentlyAbledAPIKey] = personalData.speciallAbled
        
        var disabilityParams = [String:Any]()
        disabilityParams[APIKeys.disabilitytypeAPIKey] = MIUserModel.getParamForIdText(id: (personalData.disabilityObj.type.uuid), value:personalData.disabilityObj.type.name)
        disabilityParams[APIKeys.disabilitysubtypeAPIKey] = MIUserModel.getParamForIdText(id: (personalData.disabilityObj.subtype.uuid), value: personalData.disabilityObj.subtype.name)
        disabilityParams[APIKeys.disabilitydetailsAPIKey] = MIUserModel.getParamForIdText(id: (personalData.disabilityObj.detail.uuid), value: personalData.disabilityObj.detail.name)
        disabilityParams[APIKeys.disabilitydescriptionAPIKey] = personalData.disabilityObj.disabilityDescription
        disabilityParams[APIKeys.disabilitycertificationNoAPIKey] = personalData.disabilityObj.disabilityCertificate
        disabilityParams[APIKeys.disabilityissueByAPIKey] = personalData.disabilityObj.disabilityIssuer
        if personalData.speciallAbled {
            additionalPersonalDetail[APIKeys.disabilityAPIKey] = disabilityParams
        }else{
            additionalPersonalDetail[APIKeys.disabilityAPIKey] = nil
        }
        params[APIKeys.additionalPersonalDetailAPIKey] = additionalPersonalDetail
        
        return params
    }
    
    class func getModelFromDict(params:[String:Any]) -> MIPersonalDetail {
        
        let obj = MIPersonalDetail()
        if let homeTown = params[APIKeys.homeTownAPIKey] as? [String:Any] {
            obj.homeTown = MICategorySelectionInfo(dictionary: homeTown) ??  MICategorySelectionInfo()
        }
        if let nationality = params[APIKeys.nationalityAPIKey] as? [String:Any] {
            obj.nationality = MICategorySelectionInfo(dictionary: nationality) ??  MICategorySelectionInfo()
        }
        if let additionalPersonalDetail = params[APIKeys.additionalPersonalDetailAPIKey] as? [String:Any] {
            if let disability = additionalPersonalDetail[APIKeys.disabilityAPIKey] as? [String:Any] {
                obj.disabilityObj = MIDisabilityDetail(disabilityDict: disability)
            }
            obj.dob = additionalPersonalDetail.stringFor(key: APIKeys.dobAPIKey).dateWith(PersonalTitleConstant.dateFormatePattern)
            if let category = additionalPersonalDetail[APIKeys.categoryAPIKey] as? [String:Any] {
                obj.category = MICategorySelectionInfo(dictionary: category) ??  MICategorySelectionInfo()
            }
            if let maritalStatus = additionalPersonalDetail[APIKeys.maritalStatusAPIKey] as? [String:Any] {
                obj.maretialStatus = MICategorySelectionInfo(dictionary: maritalStatus) ??  MICategorySelectionInfo()
            }
            if let gender = additionalPersonalDetail[APIKeys.genderAPIKey] as? [String:Any] {
                obj.gender = MICategorySelectionInfo(dictionary: gender) ??  MICategorySelectionInfo()
            }
            if let workStatusUSA = additionalPersonalDetail[APIKeys.workStatusUSAAPIKey] as? [String:Any] {
                obj.workPermitUSA = MICategorySelectionInfo(dictionary: workStatusUSA) ??  MICategorySelectionInfo()
            }
            
            if let workAuthorizedCountries = additionalPersonalDetail[APIKeys.workAuthorizedCountriesAPIKey] as? [Any] {
                for paramsCountry in workAuthorizedCountries {
                    if let data = paramsCountry as? [String:Any] {
                        if let objWork = MICategorySelectionInfo(dictionary: data) {
                            obj.workPermits.append(objWork)
                        }
                    }
                }
            }
            if let residentCountries = additionalPersonalDetail[APIKeys.residentCountriesAPIKey] as? [Any] {
                for country in residentCountries {
                    if let data = country as? [String:Any] {
                        if let objWork = MICategorySelectionInfo(dictionary: data) {
                            obj.residentStatus.append(objWork)
                        }
                    }
                }
            }
            obj.passportNumber = additionalPersonalDetail.stringFor(key: APIKeys.passportNumberAPIKey)
            obj.permentantAddress = additionalPersonalDetail.stringFor(key: APIKeys.permanentAddressAPIKey)
            obj.pincode = additionalPersonalDetail.stringFor(key: APIKeys.pincodeAPIKey)
            obj.speciallAbled = additionalPersonalDetail.booleanFor(key: APIKeys.differentlyAbledAPIKey)
        }
        return obj
    }
    
}
class MIUserModel: NSObject {
    
    static var userSharedInstance = MIUserModel.init()
    var userAccountType = AccountTypeVia.Manual
    var userProfessionalType = UserProfessionalCategory.None
    var userSocialAccessToken = ""
    var userId = ""
    var userFullName = ""
    var userlocationModal = MICategorySelectionInfo()
    var userEmail = ""
    var userPassword = ""
    var userMobileNumber = ""
    var userCountryCode = ""
    var userExperienceInYear = "0"
    var userExperienceInMonth = "0"
    var nationalityModal = MICategorySelectionInfo()
    var visaType = MICategorySelectionInfo()
    var userCountryNameCode = ""
    var cityName = ""
    var userResume = MIUserResume(with: [String:Any]())
    
    var userSkills : [MIUserSkills]?
    var educationsByUser : [SectionModel]?
    var userEducationDataList : [MIEducationInfo]?
    var userEmploymentDataList : [MIEmploymentDetailInfo]?
    var userJobPreference : MIJobPreferencesModel?
    
    var isEducationUploaded = false
    var isEmploymentUploaded = false
    var isSkillsUploaded = false
    var allowPromotionOfferMails = false
    
    
    init(userId:String) {
        self.userId = userId
    }
    private override init() {
        self.userEducationDataList = [MIEducationInfo]()
        self.userEmploymentDataList = [MIEmploymentDetailInfo]()
        self.userSkills = [MIUserSkills]()
    }
    
    func saveCurrentUserDataModel(userData: MIUserModel) {
        MIUserModel.userSharedInstance = userData
        MIUserModel.userSharedInstance.userFullName = userData.userFullName
        MIUserModel.userSharedInstance.userMobileNumber = userData.userMobileNumber
        MIUserModel.userSharedInstance.userlocationModal = userData.userlocationModal
        MIUserModel.userSharedInstance.userEmail = userData.userEmail
        MIUserModel.userSharedInstance.userPassword = userData.userPassword
        MIUserModel.userSharedInstance.nationalityModal = userData.nationalityModal
        MIUserModel.userSharedInstance.userCountryCode = userData.userCountryCode
        MIUserModel.userSharedInstance.userProfessionalType = userData.userProfessionalType
        MIUserModel.userSharedInstance.userSkills = userData.userSkills
        //   MIUserModel.userSharedInstance.userJobPreference?.preferredIndustrys = userData.userJobPreference
    }
    
    class func resetUserResumeData() {
        MIUserModel.userSharedInstance.userEducationDataList?.removeAll()
        MIUserModel.userSharedInstance.userEmploymentDataList?.removeAll()
        MIUserModel.userSharedInstance.educationsByUser?.removeAll()
        MIUserModel.userSharedInstance.userSkills?.removeAll()
        MIUserModel.userSharedInstance.userJobPreference = nil
        MIUserModel.userSharedInstance.isEducationUploaded = false
        MIUserModel.userSharedInstance.isEmploymentUploaded = false
        MIUserModel.userSharedInstance.isSkillsUploaded = false
        MIUserModel.userSharedInstance.userExperienceInYear = "0"
        MIUserModel.userSharedInstance.userExperienceInMonth = "0"
        
    }
    //     func resetCurrentUserData(){
    //        MIUserModel.userSharedInstance.userFullName = ""
    //        MIUserModel.userSharedInstance.userMobileNumber = ""
    //        MIUserModel.userSharedInstance.userlocationModal = MICategorySelectionInfo()
    //        MIUserModel.userSharedInstance.userEmail = ""
    //        MIUserModel.userSharedInstance.userSocialAccessToken = ""
    //        MIUserModel.userSharedInstance.userCountryCode = ""
    //        MIUserModel.userSharedInstance.userPassword = ""
    //        MIUserModel.userSharedInstance.nationalityModal = MICategorySelectionInfo()
    //        MIUserModel.userSharedInstance.userProfessionalType = .None
    //        MIUserModel.userSharedInstance.userExperienceInYear = "0"
    //        MIUserModel.userSharedInstance.userExperienceInMonth = "0"
    //        MIUserModel.resetUserResumeData()
    //    }
    
    class func getParmsFromModelForUserRegisteration(userModal: MIUserModel, otpCode:String, otpID: String, visaOption: VisaOptionOpen, registerType: RegisterVia) -> [String:Any] {
        
        var personalParams = [String:Any]()
        
        if CommonClass.covidFlagMobile {
            if userModal.userProfessionalType == .Experienced  {
                personalParams["covidLayoff"] = covid19Flag
            }
        }
        
        personalParams[APIKeys.fullNameAPIKey] = userModal.userFullName
        personalParams[APIKeys.emailAPIKey]    = userModal.userEmail
        personalParams[APIKeys.passwordAPIKey] = userModal.userPassword
        
        if otpCode.isEmpty{
            personalParams[APIKeys.mobileNumberAPIKey] = [APIKeys.mobileNumberAPIKey:userModal.userMobileNumber,APIKeys.countryCodeAPIKey:userModal.userCountryCode.replacingOccurrences(of: "+", with: "")]
            
        }else{
            personalParams[APIKeys.mobileNumberAPIKey] = [APIKeys.mobileNumberAPIKey:userModal.userMobileNumber,APIKeys.countryCodeAPIKey:userModal.userCountryCode.replacingOccurrences(of: "+", with: ""),APIKeys.otpAPIKey:otpCode,APIKeys.otpIdAPIKey:otpID]
            
        }
        personalParams[APIKeys.nationalityAPIKey] = MIUserModel.getParamForIdText(id: userModal.nationalityModal.uuid, value: userModal.nationalityModal.name)
        
        if registerType != .None {
            personalParams[APIKeys.socialProviderAPIKey] = registerType.rawValue
            personalParams[APIKeys.socialAccessTokenAPIKey] = userModal.userSocialAccessToken
        }
        if visaOption == .VisaTypeSelect && userModal.visaType.name != kDONT_HAVE_WORK_AUTHORIZATION {
            personalParams[APIKeys.workVisaType] = MIUserModel.getParamForIdText(id: userModal.visaType.uuid, value: userModal.visaType.name)
        }
        
        personalParams[APIKeys.experienceLevelAPIKey] = userModal.userProfessionalType.rawValue
        if !userModal.cityName.isEmpty {
            var location = MIUserModel.getParamForIdText(id: userModal.userlocationModal.uuid, value: userModal.userlocationModal.name)
            location[APIKeys.otherTextAPIKey] = userModal.cityName
            personalParams[APIKeys.locationAPIKey] = location
            
        }else{
            personalParams[APIKeys.locationAPIKey] = MIUserModel.getParamForIdText(id: userModal.userlocationModal.uuid, value: userModal.userlocationModal.name)
            
        }
        if userModal.userProfessionalType == .Experienced {
            if userModal.userExperienceInYear == "0" && userModal.userExperienceInMonth == "0" {
                personalParams[APIKeys.experienceLevelAPIKey] = UserProfessionalCategory.Fresher.rawValue
                
            }else{
                personalParams[APIKeys.experienceAPIKey] =  [APIKeys.yearsAPIKey:userModal.userExperienceInYear,APIKeys.monthsAPIKey:userModal.userExperienceInMonth]
                
            }
        }
        
        personalParams[APIKeys.promotionAndSpecialOffersAPIKey] = userModal.allowPromotionOfferMails
        var dataParams = [[String:Any]]()
        if userModal.userJobPreference?.preferredIndustrys.count != 0 {
            for industru in userModal.userJobPreference?.preferredIndustrys ?? [MICategorySelectionInfo]() {
                dataParams.append(MIUserModel.getParamForIdText(id: industru.uuid, value:industru.name))
            }
        }
        personalParams[APIKeys.industriesAPIKey] = dataParams
        
        dataParams.removeAll()
        if userModal.userJobPreference?.preferredFunctions.count != 0 {
            for functions in userModal.userJobPreference?.preferredFunctions ?? [MICategorySelectionInfo](){
                dataParams.append(MIUserModel.getParamForIdText(id: functions.uuid, value:functions.name))
            }
        }
        personalParams[APIKeys.functionsAPIKey] = dataParams
        
        if let skills = userModal.userSkills {
            personalParams[APIKeys.skillsAPIKey] = MIUserSkills.getDictionaryArrayFromDataSource(skills: skills)
        }
        if !userModal.userResume.resumeBucket.isEmpty {
            var resumeBucket = [String:Any]()
            resumeBucket[APIKeys.bucketAPIKey] = userModal.userResume.resumeBucket
            resumeBucket[APIKeys.pathAPIKey] = userModal.userResume.resumePath
            personalParams[APIKeys.resumeFileAPIKey] = resumeBucket
        }
        return personalParams
    }
    
    class func getResumeDataParse(data:[String:Any]) {
        
        if let resumeData  = data[APIKeys.resumeAPIKey] as? [String:Any]  {
            if let resumeDataSkills  = resumeData[APIKeys.skillsAPIKey] as? [[String:Any]] , resumeDataSkills.count > 0 {
                MIUserModel.userSharedInstance.userSkills = MIUserSkills.getSkillFromResume(dataArray: resumeDataSkills)
                if let skillsArraySlice = MIUserModel.userSharedInstance.userSkills?.prefix(6) {
                    let skills = Array(skillsArraySlice)
                    MIUserModel.userSharedInstance.userSkills = skills
                }
            }
            if let work_expsData  = resumeData[APIKeys.work_expsAPIKey] as? [[String:Any]] ,work_expsData.count > 0 {
                let currentEmployment = work_expsData.filter({($0[APIKeys.end_dateAPIKey] as! String).lowercased() == "Present".lowercased()})
                if currentEmployment.count > 0 {
                    MIUserModel.userSharedInstance.userEmploymentDataList =  MIEmploymentDetailInfo.getEmploymentFromResumeParse(employement: currentEmployment.first!)
                    
                }else{
                    if work_expsData.count > 0 {
                        MIUserModel.userSharedInstance.userEmploymentDataList =  MIEmploymentDetailInfo.getEmploymentFromResumeParse(employement: work_expsData.first!)
                    }
                    
                }
            }
            if let educationsData  = resumeData[APIKeys.educationsAPIKey] as? [[String:Any]] ,educationsData.count > 0  {
                if let highestEducation = educationsData.first {
                    MIUserModel.userSharedInstance.userEducationDataList = [MIEducationInfo(educationDict: highestEducation)]
                    
                }
                
            }
        }
    }
}


class MIEducationInfo: NSObject, NSCopying {
    
    var educationId    = ""
    var title          = ""
    var titleDetail    = ""
    var isSelectedCell = false
    var shouldShowCheckBtn = false
    var highestQualificationObj = MICategorySelectionInfo()
    var specialisationObj = MICategorySelectionInfo()
    var collegeObj = MICategorySelectionInfo()
    var year    = ""
    var educationTypeObj = MICategorySelectionInfo() 
    var boardObj = MICategorySelectionInfo()
    var percentage    = ""
    var mediumObj = MICategorySelectionInfo()
    var isEducationDegree = true
    
    func copy(with zone: NSZone? = nil) -> Any {
        
        let eduInfo = MIEducationInfo(educationId: educationId, title: title, titleDetail: titleDetail, isSelectedCell: isSelectedCell, shouldShowCheckBtn: shouldShowCheckBtn, highestQualificationObj: highestQualificationObj, specialisationObj: specialisationObj, collegeObj: collegeObj, year: year, educationTypeObj: educationTypeObj, boardObj: boardObj, percentage: percentage, mediumObj: mediumObj, isEducationDegree: isEducationDegree)
        
        return eduInfo
    }
    
    init(educationId: String, title: String, titleDetail: String, isSelectedCell: Bool, shouldShowCheckBtn: Bool, highestQualificationObj: MICategorySelectionInfo, specialisationObj: MICategorySelectionInfo, collegeObj: MICategorySelectionInfo, year: String, educationTypeObj: MICategorySelectionInfo, boardObj: MICategorySelectionInfo, percentage: String, mediumObj: MICategorySelectionInfo, isEducationDegree: Bool) {
        
        self.educationId    = educationId
        self.title          = title
        self.titleDetail    = titleDetail
        self.isSelectedCell = isSelectedCell
        self.shouldShowCheckBtn         = shouldShowCheckBtn
        if let edu = highestQualificationObj.copy() as? MICategorySelectionInfo {
            self.highestQualificationObj    = edu
        }
        if let specl = specialisationObj.copy() as? MICategorySelectionInfo {
            self.specialisationObj    = specl
        }
        if let  college = collegeObj.copy() as? MICategorySelectionInfo {
            self.collegeObj    = college
        }
        self.year           = year
        if let  eduType = educationTypeObj.copy() as? MICategorySelectionInfo {
            self.educationTypeObj    = eduType
        }
        if let  board = boardObj.copy() as? MICategorySelectionInfo {
            self.boardObj    = board
        }
        self.percentage     = percentage
        if let  medium = mediumObj.copy() as? MICategorySelectionInfo {
            self.mediumObj    = medium
        }
        self.isEducationDegree          = isEducationDegree
    }
    
    init(educationDict:[String:Any]) {
        
        educationId = educationDict.stringFor(key: APIKeys.idAPIKey)
        if let highestQualification = educationDict[APIKeys.highestQualificationAPIKey] as? [String:Any] {
            highestQualificationObj = MICategorySelectionInfo(dictionary: highestQualification) ?? MICategorySelectionInfo()
            
            let highestQualificationUUID = highestQualificationObj.uuid
            if (highestQualificationUUID == kClass12Id || highestQualificationUUID == kHighSchool || highestQualificationUUID == kCLASS10) {
                isEducationDegree = false
            }
        }
        
        if let specialization = educationDict[APIKeys.specializationAPIKey] as? [String:Any] {
            specialisationObj = MICategorySelectionInfo(dictionary: specialization) ?? MICategorySelectionInfo()
        }
        if let college = educationDict[APIKeys.collegeAPIKey] as? [String:Any] {
            collegeObj = MICategorySelectionInfo(dictionary: college) ?? MICategorySelectionInfo()
        }
        if let board = educationDict[APIKeys.boardAPIKey] as? [String:Any] {
            boardObj = MICategorySelectionInfo(dictionary: board) ?? MICategorySelectionInfo()
        }
        if let educationType = educationDict[APIKeys.educationTypeAPIKey] as? [String:Any] {
            educationTypeObj = MICategorySelectionInfo(dictionary: educationType) ?? MICategorySelectionInfo()
        }
        if let medium = educationDict[APIKeys.mediumAPIKey] as? [String:Any] {
            mediumObj = MICategorySelectionInfo(dictionary: medium) ?? MICategorySelectionInfo()
        }
        year = educationDict.stringFor(key: APIKeys.yearOfPassingAPIKey)
        percentage = educationDict.stringFor(key: APIKeys.percentageAPIKey)
        
    }
    
    init(qualification:String ,specialisation:String,instituteName:String,year:String ) {
        self.highestQualificationObj.name = qualification
        self.specialisationObj.name = specialisation
        self.collegeObj.name = instituteName
        self.year = year
        
    }
    
    func checkModelIsEmpty() -> Bool {
        if self.highestQualificationObj.name.isEmpty && self.specialisationObj.name.count <= 1 && self.year.isEmpty && self.educationTypeObj.name.isEmpty {
            return true
        }
        return false
    }
    
    class func getEducationDataListParams(educationList:[MIEducationInfo],isforResgister:Bool) -> [[String:Any]] {
        var educationDetailParam = [[String:Any]]()
        
        for education in educationList {
            var eduParams = [String:Any]()
            if !education.educationId.isEmpty {
                eduParams["id"] = education.educationId
            }
            eduParams[MIEducationDetailViewControllerConstant.highestQualificationAPIKey] = MIUserModel.getParamForIdTextForUUIDNil(id: /*(education.highestQualificationObj.uuid.count == 0) ? kHighestQualificationOtherUUID :*/ education.highestQualificationObj.uuid , value: education.highestQualificationObj.name)
            
            if !education.specialisationObj.name.isEmpty {
                eduParams[MIEducationDetailViewControllerConstant.specializationAPIKey] = MIUserModel.getParamForIdTextForUUIDNil(id: /*(education.specialisationObj.uuid.count == 0) ? kSpecilisationOtherUUID :*/ education.specialisationObj.uuid, value: education.specialisationObj.name)
            }
            
            if !education.collegeObj.name.isEmpty {
                eduParams[MIEducationDetailViewControllerConstant.collegeAPIKey] = MIUserModel.getParamForIdTextForUUIDNil(id:(education.collegeObj.uuid.count == 0) ? kCollegeOtherUUID :  education.collegeObj.uuid , value: education.collegeObj.name)
            }
            if !education.mediumObj.name.isEmpty {
                eduParams[MIEducationDetailViewControllerConstant.mediumAPIKey] = MIUserModel.getParamForIdTextForUUIDNil(id: education.mediumObj.uuid, value: education.mediumObj.name)
            }
            if !education.isEducationDegree {
                if !education.boardObj.name.isEmpty {
                    eduParams[MIEducationDetailViewControllerConstant.boardAPIKey] = MIUserModel.getParamForIdTextForUUIDNil(id: education.boardObj.uuid, value: education.boardObj.name)
                }
            }
            eduParams[MIEducationDetailViewControllerConstant.yearOfPassingAPIKey] = Int(education.year)
            
            if !education.educationTypeObj.name.isEmpty {
                eduParams[MIEducationDetailViewControllerConstant.educationTypeAPIKey] = MIUserModel.getParamForIdTextForUUIDNil(id: education.educationTypeObj.uuid, value: education.educationTypeObj.name)
            }
            
            educationDetailParam.append(eduParams)
        }
        return educationDetailParam
    }
    class func getDictFromModelDataList(educationList:[MIEducationInfo],isForRegister:Bool) -> [String:Any] {
        var params = [String:Any]()
        
        let educationDetailParam =  self.getEducationDataListParams(educationList: educationList, isforResgister: isForRegister)
        params[MIEducationDetailViewControllerConstant.educationDetailsAPIKey] = educationDetailParam
        
        return params
    }
    
    class func getModelFromDataList(educationData:[[String:Any]]) -> [MIEducationInfo] {
        var educationDataSource  = [MIEducationInfo]()
        
        for dict in educationData {
            let educationObj = MIEducationInfo(educationDict: dict)
            educationDataSource.append(educationObj)
        }
        
        return educationDataSource
    }
}


class MIEmploymentDetailInfo: NSObject, NSCopying {
    
    var employmentId : String = ""
    var jobTitle : String = ""
    var designationObj = MICategorySelectionInfo()
    var companyObj = MICategorySelectionInfo()
    var experinceFrom :Date? = nil
    var experinceTill : Date? = nil
    var salaryModal = SalaryDetail()
    var noticePeroidDuration : String = ""
    var lastWorkingDate : Date? = nil
    var offeredSalaryModal = SalaryDetail()
    var offeredDesignationObj = MICategorySelectionInfo()
    var newCompanyObj = MICategorySelectionInfo()
    var isCurrentEmplyement : Bool = false
    var isServingNotice : Bool = false
    var sinceYear :  String = ""
    var sinceMonth : String = ""
    
    override init() {}
    
    init(isCurrent: Bool) {
        self.isCurrentEmplyement = isCurrent
    }
    
    init(employmentId: String, jobTitle: String, designationObj: MICategorySelectionInfo, companyObj: MICategorySelectionInfo, experinceFrom :Date? = nil, experinceTill: Date? = nil, salary:SalaryDetail, noticePeroidDuration: String, lastWorkingDate : Date? = nil, offeredDesignationObj: MICategorySelectionInfo, newCompanyObj: MICategorySelectionInfo, isCurrentEmplyement : Bool, isServingNotice: Bool, sinceYear: String, sinceMonth: String,offeredSalary:SalaryDetail) {
        
        self.employmentId = employmentId
        self.jobTitle = jobTitle
        if let des = designationObj.copy() as? MICategorySelectionInfo {
            self.designationObj = des
        }
        if let com = companyObj.copy() as? MICategorySelectionInfo {
            self.companyObj = com
        }
        self.experinceFrom = experinceFrom
        self.experinceTill = experinceTill
        if let salary = salary.copy() as? SalaryDetail {
            self.salaryModal = salary
        }
        self.noticePeroidDuration = noticePeroidDuration
        self.lastWorkingDate = lastWorkingDate
        if let offer = offeredSalary.copy() as? SalaryDetail {
            self.offeredSalaryModal = offer
        }
        // self.offeredSalaryModal  = offeredSalary
        //        self.offeredSalaryInLakh = offeredSalaryInLakh
        //        self.offeredSalaryInThousand  = offeredSalaryInThousand
        //        self.offeredSalaryModeSelectedAnnualy = offeredSalaryModeSelectedAnnualy
        if let offerdes = offeredDesignationObj.copy() as? MICategorySelectionInfo {
            self.offeredDesignationObj = offerdes
        }
        if let newCompany = newCompanyObj.copy() as? MICategorySelectionInfo {
            self.newCompanyObj = newCompany
        }
        // self.newCompanyObj = newCompanyObj
        self.isCurrentEmplyement = isCurrentEmplyement
        self.isServingNotice = isServingNotice
        self.sinceYear = sinceYear
        self.sinceMonth = sinceMonth
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copiedObj = MIEmploymentDetailInfo(employmentId: employmentId, jobTitle: jobTitle, designationObj: designationObj, companyObj: companyObj, experinceFrom: experinceFrom, experinceTill: experinceTill, salary: salaryModal, noticePeroidDuration: noticePeroidDuration, lastWorkingDate: lastWorkingDate, offeredDesignationObj: offeredDesignationObj, newCompanyObj: newCompanyObj, isCurrentEmplyement: isCurrentEmplyement, isServingNotice: isServingNotice, sinceYear: sinceYear, sinceMonth: sinceMonth,offeredSalary: offeredSalaryModal)
        return copiedObj
    }
    
    func checkModelIsEmpty() -> Bool {
        if self.designationObj.name.isEmpty && self.companyObj.name.isEmpty {
            return true
        }
        return false
    }
    class func getEmploymentFromResumeParse(employement:[String:Any]) -> [MIEmploymentDetailInfo] {
        
        var employmentList = [MIEmploymentDetailInfo]()
        let employmentData = MIEmploymentDetailInfo()
        if let company = employement[APIKeys.companyAPIKey] as? [String:Any] {
            employmentData.companyObj = MICategorySelectionInfo(dictionary: company) ?? MICategorySelectionInfo()
            
        }
        if let designation = employement[APIKeys.designationAPIKey] as? [String:Any] {
            employmentData.designationObj = MICategorySelectionInfo(dictionary: designation) ?? MICategorySelectionInfo()
            
        }
        if !employement.stringFor(key: APIKeys.start_dateAPIKey).isEmpty {
            employmentData.experinceFrom =  employement.stringFor(key: APIKeys.start_dateAPIKey).dateWith("MM-yyyy")
        }
        if !employement.stringFor(key: APIKeys.end_dateAPIKey).isEmpty {
            if employement.stringFor(key: APIKeys.end_dateAPIKey) == "Present" {
                employmentData.isCurrentEmplyement = true
            }else{
                employmentData.experinceTill = employement.stringFor(key: APIKeys.end_dateAPIKey).dateWith("MM-yyyy")
                
            }
        }else{
            employmentData.isCurrentEmplyement = true
        }
        
        let site = AppDelegate.instance.site
        employmentData.salaryModal.salaryCurrency = (site?.defaultCurrencyDetails.currency?.isoCode) ?? "INR"
        employmentData.offeredSalaryModal.salaryCurrency = (site?.defaultCurrencyDetails.currency?.isoCode) ?? "INR"
        
        employmentList.append(employmentData)
        return employmentList
        
    }
    class func getDictFromModelObjectListForUpdatePayload(employementList:[MIEmploymentDetailInfo]) -> [Any] {
        var employementDetailParam = [[String:Any]]()
        
        for employment in employementList {
            var params = [String:Any]()
            if !employment.employmentId.isEmpty {
                params[APIKeys.idAPIKey] = employment.employmentId
                
            }
            params[APIKeys.titleAPIKey] = employment.jobTitle
            
            params[APIKeys.designationAPIKey] = MIUserModel.getParamForIdTextForUUIDNil(id: employment.designationObj.uuid, value:employment.designationObj.name)
            
            params[APIKeys.companyAPIKey] = MIUserModel.getParamForIdTextForUUIDNil(id: employment.companyObj.uuid, value: employment.companyObj.name)
            if let fromDate = employment.experinceFrom {
                params[APIKeys.startDateAPIKey] = fromDate.getStringWithFormat(format: PersonalTitleConstant.dateFormatePattern)
            }
            
            if (employment.experinceTill != nil) && !employment.isCurrentEmplyement {
                params[APIKeys.endDateAPIKey] = employment.experinceTill!.getStringWithFormat(format: PersonalTitleConstant.dateFormatePattern)
            }else{
                params[APIKeys.endDateAPIKey] = ""
            }
            
            
            var noticePeroidParam = [String:Any]()
            if employment.isCurrentEmplyement && !employment.noticePeroidDuration.isEmpty {
                if !employment.salaryModal.salaryCurrency.isEmpty {
                    params[APIKeys.salaryAPIKey] = SalaryDetail.getSalaryParam(salary: employment.salaryModal, withConfidential: true)
                }
                if employment.isServingNotice {
                    if employment.lastWorkingDate != nil {
                        noticePeroidParam[APIKeys.lastWorkingDayAPIKey] = employment.lastWorkingDate!.getStringWithFormat(format: PersonalTitleConstant.dateFormatePattern)
                        
                        noticePeroidParam[APIKeys.daysAPIKey] = Date().getDaysDifferenceBetweenDatesWithComponents(toDate: employment.lastWorkingDate!)
                    }
                }else{
                    noticePeroidParam[APIKeys.lastWorkingDayAPIKey] = ""
                    noticePeroidParam[APIKeys.daysAPIKey] = self.getNoticePeroidDaysfromType(type: employment.noticePeroidDuration)
                }
                
                noticePeroidParam[APIKeys.servingAPIKey] = employment.isServingNotice
                params[APIKeys.noticePeriodAPIKey] = noticePeroidParam
            }
            
            //Offered salary
            if !employment.offeredSalaryModal.salaryCurrency.isEmpty {
                params[APIKeys.offeredSalaryAPIKey] = SalaryDetail.getSalaryParam(salary: employment.offeredSalaryModal, withConfidential: false)
            }
            if !employment.offeredDesignationObj.name.isEmpty {
                params[APIKeys.offeredDesignationAPIKey] = MIUserModel.getParamForIdText(id: employment.offeredDesignationObj.uuid, value: employment.offeredDesignationObj.name)
            }
            
            if !employment.newCompanyObj.name.isEmpty {
                params[APIKeys.newCompanyAPIKey] = MIUserModel.getParamForIdText(id: employment.newCompanyObj.uuid, value: employment.newCompanyObj.name)
            }
            
            employementDetailParam.append(params)
        }
        
        return employementDetailParam
    }
    class func getEmploymentJSONForProfileImprovment(modal:MIEmploymentDetailInfo)->[String:Any] {
        var employmentparams = [String:Any]()
        
        if !modal.employmentId.isEmpty {
            employmentparams["id"] = modal.employmentId
        }
        
        employmentparams[APIKeys.designationAPIKey] = MIUserModel.getParamForIdTextForUUIDNil(id: modal.designationObj.uuid, value: modal.designationObj.name)
        employmentparams[APIKeys.companyAPIKey] = MIUserModel.getParamForIdTextForUUIDNil(id: modal.companyObj.uuid, value: modal.companyObj.name)
        if modal.sinceYear.count != 0 {
            employmentparams[APIKeys.startDateAPIKey] = "\(modal.sinceYear)-\(modal.sinceMonth.getMonthNumberFromName())-01"
            
        }
        if modal.isCurrentEmplyement {
            var noticeParams = [String:Any]()
            noticeParams[APIKeys.daysAPIKey] = NoticePeroid(rawValue: modal.noticePeroidDuration)?.days
            noticeParams[APIKeys.servingAPIKey] = modal.isServingNotice
            if modal.isServingNotice {
                employmentparams[APIKeys.lastWorkingDayAPIKey] = modal.lastWorkingDate?.getStringWithFormat(format: PersonalTitleConstant.dateFormatePattern)
                if let lastDate = modal.lastWorkingDate {
                    noticeParams[APIKeys.daysAPIKey] =                             Date().getDaysDifferenceBetweenDatesWithComponents(toDate:lastDate)
                }
                
            }
            employmentparams[APIKeys.noticePeriodAPIKey] = noticeParams
        }
        
        return employmentparams
    }
    class func getParamsForUserEmploymentPayloadViaRegister(employmentSection:[SectionModel])
        -> [[String:Any]]{
            let data = employmentSection.filter({ ($0.sectionDataSource as? MIEmploymentDetailInfo)?.designationObj.name.isEmpty == false })
            
            var employmentList = [[String:Any]]()
            
            for section in data {
                var employmentparams = [String:Any]()
                
                if let modal = section.sectionDataSource as? MIEmploymentDetailInfo {
                    if !modal.employmentId.isEmpty {
                        employmentparams["id"] = modal.employmentId
                    }
                    
                    employmentparams[APIKeys.designationAPIKey] = MIUserModel.getParamForIdTextForUUIDNil(id: modal.designationObj.uuid, value: modal.designationObj.name)
                    employmentparams[APIKeys.companyAPIKey] = MIUserModel.getParamForIdTextForUUIDNil(id: modal.companyObj.uuid, value: modal.companyObj.name)
                    if section.sectionNumber == 0 {
                        //employmentparams[MIEmploymentDetailViewControllerConstant.currentyWorkinghere] = modal.isCurrentEmplyement
                    }
                    if let startDate = modal.experinceFrom {
                        employmentparams[APIKeys.startDateAPIKey] = startDate.getStringWithFormat(format: PersonalTitleConstant.dateFormatePattern)
                    }
                    if let endDate = modal.experinceTill {
                        employmentparams[APIKeys.endDateAPIKey] = endDate.getStringWithFormat(format: PersonalTitleConstant.dateFormatePattern)
                    }
                    if !modal.salaryModal.salaryCurrency.isEmpty {
                        //                    var salaryParam = [String:Any]()
                        //                    let lakhAmount = MIEmploymentDetailInfo.getSalaryAbsoluteValue(obj: modal)
                        //                    salaryParam[APIKeys.currencyAPIKey] = modal.currentSalaryCurrency
                        //                    salaryParam[APIKeys.absoluteValueAPIKey] = lakhAmount
                        //                    var salaryMode = [String:Any]()
                        //                    salaryMode[APIKeys.idAPIKey] = (modal.currentSalaryModeSelectedAnnualy) ? kannuallyModeSalaryUUID : kmonthlyModeSalaryUUID
                        //                    salaryMode[APIKeys.textAPIKey] = (modal.currentSalaryModeSelectedAnnualy) ? "Annually" : "Monthly"
                        //
                        //                    salaryParam[APIKeys.salaryModeAPIKey] = salaryMode
                        //                    employmentparams[APIKeys.salaryAPIKey] = (modal.currentSalaryInLakh.isEmpty && modal.currentSalaryInThousand.isEmpty) ? nil : salaryParam
                        employmentparams[APIKeys.salaryAPIKey] = SalaryDetail.getSalaryParam(salary: modal.salaryModal, withConfidential: modal.isCurrentEmplyement)
                        
                    }
                    if !modal.offeredSalaryModal.salaryCurrency.isEmpty {
                        //                    var salaryParam = [String:Any]()
                        //                    let lakhAmount = MIEmploymentDetailInfo.getOfferedSalaryAbsoluteValue(obj: modal)
                        //                    salaryParam[APIKeys.currencyAPIKey] = modal.offeredSalaryCurrency
                        //                    salaryParam[APIKeys.absoluteValueAPIKey] = lakhAmount
                        //                    var salaryMode = [String:Any]()
                        //                    salaryMode[APIKeys.idAPIKey] = (modal.offeredSalaryModeSelectedAnnualy) ? kannuallyModeSalaryUUID : kmonthlyModeSalaryUUID
                        //                    salaryParam[APIKeys.salaryModeAPIKey] = salaryMode
                        
                        employmentparams[APIKeys.offeredSalaryAPIKey] = SalaryDetail.getSalaryParam(salary: modal.offeredSalaryModal, withConfidential: false)
                    }
                    if modal.isCurrentEmplyement {
                        var noticeParams = [String:Any]()
                        noticeParams[APIKeys.daysAPIKey] = NoticePeroid(rawValue: modal.noticePeroidDuration)?.days
                        noticeParams[APIKeys.servingAPIKey] = modal.isServingNotice
                        if modal.isServingNotice {
                            noticeParams[APIKeys.lastWorkingDayAPIKey] = modal.lastWorkingDate?.getStringWithFormat(format: PersonalTitleConstant.dateFormatePattern)
                            if let lastDate = modal.lastWorkingDate {
                                noticeParams[APIKeys.daysAPIKey] =                             Date().getDaysDifferenceBetweenDatesWithComponents(toDate:lastDate)
                            }
                            if !modal.offeredDesignationObj.name.isEmpty {
                                employmentparams[APIKeys.offeredDesignationAPIKey] = MIUserModel.getParamForIdTextForUUIDNil(id: modal.offeredDesignationObj.uuid, value: modal.offeredDesignationObj.name)
                            }
                            if !modal.newCompanyObj.name.isEmpty {
                                employmentparams[APIKeys.newCompanyAPIKey] = MIUserModel.getParamForIdTextForUUIDNil(id: modal.newCompanyObj.uuid, value: modal.newCompanyObj.name)
                            }
                        }
                        employmentparams[APIKeys.noticePeriodAPIKey] = noticeParams
                    }
                }
                employmentList.append(employmentparams)
            }
            
            return employmentList
    }
    class func getDictFromModelObjectListForRegisterPayload(employementList:[MIEmploymentDetailInfo] ) -> [String:Any] {
        var params = [String:Any]()
        var employementDetailParam = [[String:Any]]()
        var employemntparams = [String:Any]()
        
        if let obj = employementList.first {
            
            if !obj.employmentId.isEmpty {
                params["id"] = obj.employmentId
            }
            params[APIKeys.titleAPIKey] = obj.jobTitle
            params[APIKeys.currentDesignationAPIKey] = MIUserModel.getParamForIdText(id: obj.designationObj.uuid, value: obj.designationObj.name)
            params[APIKeys.currentcompanyAPIKey] = MIUserModel.getParamForIdText(id: obj.companyObj.uuid, value: obj.companyObj.name)
            
            //            if !obj.salaryModal.salaryCurrency.isEmpty {
            //
            //                var salaryParam = [String:Any]()
            //                let lakhAmount = MIEmploymentDetailInfo.getSalaryAbsoluteValue(obj: obj)
            //                salaryParam[APIKeys.currencyAPIKey] = obj.salaryModal.salaryCurrency
            //                salaryParam[APIKeys.absoluteValueAPIKey] = lakhAmount
            //                var salaryMode = [String:Any]()
            //                salaryMode[APIKeys.uuidAPIKey] = (obj.currentSalaryModeSelectedAnnualy) ? kannuallyModeSalaryUUID : kmonthlyModeSalaryUUID
            //
            //                salaryParam[APIKeys.salaryModeAPIKey] = salaryMode
            //            }
            
            var experience = [String:Any]()
            if !MIUserModel.userSharedInstance.userExperienceInYear.isEmpty {
                experience[APIKeys.yearsAPIKey] = Int(MIUserModel.userSharedInstance.userExperienceInYear)
                
            }
            if !MIUserModel.userSharedInstance.userExperienceInMonth.isEmpty {
                experience[APIKeys.monthsAPIKey] = Int(MIUserModel.userSharedInstance.userExperienceInMonth)
                
            }
            if MIUserModel.userSharedInstance.userExperienceInYear.count > 0 || MIUserModel.userSharedInstance.userExperienceInMonth.count > 0 {
                params[APIKeys.experienceAPIKey] = experience
                
            }
            if !obj.newCompanyObj.name.isEmpty {
                params[APIKeys.newCompanyAPIKey] = MIUserModel.getParamForIdText(id: obj.newCompanyObj.uuid, value: obj.newCompanyObj.name)
                
            }
            
            var noticePeroidParam = [String:Any]()
            if obj.isCurrentEmplyement && !obj.noticePeroidDuration.isEmpty {
                
                if obj.isServingNotice {
                    if obj.lastWorkingDate != nil {
                        noticePeroidParam[APIKeys.lastWorkingDayAPIKey] = obj.lastWorkingDate!.getStringWithFormat(format: PersonalTitleConstant.dateFormatePattern)
                        noticePeroidParam[APIKeys.daysAPIKey] = Date().getDaysDifferenceBetweenDatesWithComponents(toDate: obj.lastWorkingDate!)
                    }
                }else{
                    noticePeroidParam[APIKeys.lastWorkingDayAPIKey] = ""
                    noticePeroidParam[APIKeys.daysAPIKey] = self.getNoticePeroidDaysfromType(type: obj.noticePeroidDuration)
                }
                
                noticePeroidParam[APIKeys.servingAPIKey] = obj.isServingNotice
                params[APIKeys.noticePeriodAPIKey] = noticePeroidParam
            }
            
            if !obj.offeredDesignationObj.name.isEmpty {
                params[APIKeys.offeredDesignationAPIKey] = MIUserModel.getParamForIdText(id: obj.offeredDesignationObj.uuid, value: obj.offeredDesignationObj.name)
            }
            
            if obj.isServingNotice {
                if !obj.offeredSalaryModal.salaryCurrency.isEmpty {
                    //                    var offeredSalaryParam = [String:Any]()
                    //                    let lakhAmount = MIEmploymentDetailInfo.getOfferedSalaryAbsoluteValue(obj: obj)
                    //                    if lakhAmount > 0 {
                    //                        offeredSalaryParam[APIKeys.currencyAPIKey] = obj.offeredSalaryCurrency
                    //                        offeredSalaryParam[APIKeys.absoluteValueAPIKey] = lakhAmount
                    //                        params[APIKeys.offeredSalaryAPIKey] = offeredSalaryParam
                    //                    }
                    params[APIKeys.offeredSalaryAPIKey] = SalaryDetail.getSalaryParam(salary: obj.offeredSalaryModal, withConfidential: false)
                    
                }
                
            }
            
            employemntparams[APIKeys.companyAPIKey] = MIUserModel.getParamForIdTextForUUIDNil(id: obj.companyObj.uuid, value: obj.companyObj.name)
            employemntparams[APIKeys.designationAPIKey] = MIUserModel.getParamForIdTextForUUIDNil(id: obj.designationObj.uuid, value: obj.designationObj.name)
            if !obj.salaryModal.salaryCurrency.isEmpty {
                //                var salaryParam = [String:Any]()
                //                let lakhAmount = MIEmploymentDetailInfo.getSalaryAbsoluteValue(obj: obj)
                //                salaryParam[APIKeys.currencyAPIKey] = obj.currentSalaryCurrency
                //                salaryParam[APIKeys.absoluteValueAPIKey] = lakhAmount
                //                var salaryMode = [String:Any]()
                //                salaryMode[APIKeys.uuidAPIKey] = (obj.currentSalaryModeSelectedAnnualy) ? kannuallyModeSalaryUUID : kmonthlyModeSalaryUUID
                //
                //                salaryParam[APIKeys.salaryModeAPIKey] = salaryMode
                //                employemntparams[APIKeys.salaryAPIKey] = salaryParam
                //
                //                params[APIKeys.currentSalaryAPIKey] = salaryParam
                params[APIKeys.currentSalaryAPIKey] = SalaryDetail.getSalaryParam(salary: obj.salaryModal, withConfidential: obj.isCurrentEmplyement)
                
            }
            if let fromDate = obj.experinceFrom {
                employemntparams[APIKeys.startDateAPIKey] = fromDate.getStringWithFormat(format: PersonalTitleConstant.dateFormatePattern)
            }
            
            if  (obj.experinceTill != nil) && !obj.isCurrentEmplyement {
                employemntparams[APIKeys.endDateAPIKey] = obj.experinceTill!.getStringWithFormat(format: PersonalTitleConstant.dateFormatePattern)
            }else{
                employemntparams[APIKeys.endDateAPIKey] = ""
            }
            
            employementDetailParam.append(employemntparams)
            params[APIKeys.employmentsAPIKey] = employementDetailParam
            
        }
        
        return params
    }
    //    class func getOfferedSalaryAbsoluteValue(obj:MIEmploymentDetailInfo) -> Double {
    //        var lakhAmount = 0
    //        if obj.offeredSalaryInLakh.isNumeric {
    //            lakhAmount = obj.offeredSalaryInLakh.isEmpty ? 0 : Int(obj.offeredSalaryInLakh) ?? 0
    //        }
    //        var thousandAmount = 0
    //        if obj.offeredSalaryInThousand.isNumeric {
    //            thousandAmount = obj.offeredSalaryInThousand.isEmpty ? 0 : Int(obj.offeredSalaryInThousand) ?? 0
    //        }
    //        if obj.offeredSalaryCurrency == "INR" {
    //            lakhAmount = (lakhAmount )*100000 + (thousandAmount )
    //        }
    //        return Double(lakhAmount )
    //    }
    class func getSalaryAbsoluteValue(obj:MIEmploymentDetailInfo) -> Double {
        var lakhAmount = 0
        if obj.salaryModal.salaryInLakh.isNumeric {
            lakhAmount = obj.salaryModal.salaryInLakh.isEmpty ? 0 : Int(obj.salaryModal.salaryInLakh) ?? 0
        }
        var thousandAmount = 0
        if obj.salaryModal.salaryThousand.isNumeric {
            thousandAmount = obj.salaryModal.salaryThousand.isEmpty ? 0 : Int(obj.salaryModal.salaryThousand) ?? 0
        }
        if obj.salaryModal.salaryCurrency == "INR" {
            lakhAmount = (lakhAmount )*100000 + (thousandAmount )
        }
        return Double(lakhAmount )
    }
    class func getModelFromDataSource(employmentDataList:[[String:Any]]) -> [MIEmploymentDetailInfo] {
        
        var employemntDataList  = [MIEmploymentDetailInfo]()
        for dict in employmentDataList {
            
            let employmentObj = MIEmploymentDetailInfo()
            employmentObj.employmentId = dict.stringFor(key: "id")
            employmentObj.jobTitle = dict.stringFor(key: APIKeys.titleAPIKey)
            if !dict.stringFor(key: APIKeys.startDateAPIKey).isEmpty {
                let dateData = dict.stringFor(key: APIKeys.startDateAPIKey).components(separatedBy: "-")
                if dateData.count > 0 {
                    employmentObj.sinceYear = dateData.first ?? ""
                    if dateData.count  > 1 {
                        employmentObj.sinceMonth = dateData[1]
                    }
                }
                employmentObj.experinceFrom = dict.stringFor(key: APIKeys.startDateAPIKey).dateWith(PersonalTitleConstant.dateFormatePattern)
            }
            
            if !dict.stringFor(key: APIKeys.endDateAPIKey).isEmpty {
                employmentObj.experinceTill = dict.stringFor(key: APIKeys.endDateAPIKey).dateWith(PersonalTitleConstant.dateFormatePattern)
                employmentObj.isCurrentEmplyement = false
            }else{
                employmentObj.isCurrentEmplyement = true
            }
            if let designation = dict[APIKeys.designationAPIKey] as? [String:Any] {
                employmentObj.designationObj = MICategorySelectionInfo(dictionary: designation) ?? MICategorySelectionInfo()
            }
            
            if let salary = dict[APIKeys.salaryAPIKey] as? [String:Any] {
                employmentObj.salaryModal = SalaryDetail(salary: salary) ?? SalaryDetail()
                
            }
            if let offeredSalary = dict[APIKeys.offeredSalaryAPIKey] as? [String:Any] {
                employmentObj.offeredSalaryModal = SalaryDetail(salary: offeredSalary) ?? SalaryDetail()
                
            }
            
            if let noticePeriod = dict[APIKeys.noticePeriodAPIKey] as? [String:Any]  {
                employmentObj.isServingNotice = noticePeriod.booleanFor(key: APIKeys.servingAPIKey)
                if employmentObj.isServingNotice {
                    employmentObj.noticePeroidDuration = "Serving Notice Period"
                    if !noticePeriod.stringFor(key: APIKeys.lastWorkingDayAPIKey).isEmpty {
                        employmentObj.lastWorkingDate = noticePeriod.stringFor(key: APIKeys.lastWorkingDayAPIKey).dateWith(PersonalTitleConstant.dateFormatePattern)
                    }
                    
                }else{
                    employmentObj.noticePeroidDuration = noticePeriod.stringFor(key: APIKeys.daysAPIKey)
                    employmentObj.noticePeroidDuration = MIEmploymentDetailInfo.getNoticePeroidTypefromdays(days: employmentObj.noticePeroidDuration)
                    employmentObj.lastWorkingDate = nil
                }
                //                if employmentObj.noticePeroidDuration != NoticePeroid.Serving_Notice_Peroid.rawValue {
                //                    employmentObj.isServingNotice = false
                //                    employmentObj.lastWorkingDate = nil
                //                }
            }
            if let designation = dict[APIKeys.designationAPIKey] as? [String:Any] {
                employmentObj.designationObj = MICategorySelectionInfo(dictionary: designation) ?? MICategorySelectionInfo()
            }
            if let company = dict[APIKeys.companyAPIKey] as? [String:Any] {
                employmentObj.companyObj = MICategorySelectionInfo(dictionary: company) ?? MICategorySelectionInfo()
            }
            if let newCompany = dict[APIKeys.newCompanyAPIKey] as? [String:Any] {
                employmentObj.newCompanyObj = MICategorySelectionInfo(dictionary: newCompany) ?? MICategorySelectionInfo()
            }
            if let offeredDesignation = dict[APIKeys.offeredDesignationAPIKey] as? [String:Any] {
                employmentObj.offeredDesignationObj = MICategorySelectionInfo(dictionary: offeredDesignation) ?? MICategorySelectionInfo()
            }
            
            employemntDataList.append(employmentObj)
            
        }
        
        return employemntDataList
        
    }
    class func getNoticePeroidTypefromdays(days:String) -> String {
        switch days {
        case "0":
            return "Serving Notice Period"
        case "14" , "15" :
            return "15 Days or Less"
        case "30" :
            return "1 Month"
        case "60" :
            return "2 Months"
        case "90" :
            return "3 Months"
        case "91" :
            return "More Than 3 Months"
        default:
            return ""
            
        }
    }
    class func getNoticePeroidDaysfromType(type:String) -> Int {
        
        switch type {
        case "Serving Notice Period":
            return 0
        case "15 Days or Less" :
            return 15
        case "1 Month" :
            return 30
        case "2 Months" :
            return 60
        case "3 Months" :
            return 90
        case "More Than 3 Months" :
            return 91
        default:
            return 0
        }
    }
}

class MIJobPreferencesModel: NSObject,NSCopying {
    
    
    
    var profileTitle = ""
    var preferredIndustrys = [MICategorySelectionInfo]()
    var preferredFunctions = [MICategorySelectionInfo]()
    var preferredRoles = [MICategorySelectionInfo]()
    var preferredLocationList = [MICategorySelectionInfo]()
    var residentList = [MICategorySelectionInfo]()
    var workAuthorizationList = [MICategorySelectionInfo]()
    var preferredJobType = MICategorySelectionInfo()
    var preferredEmploymentType = MICategorySelectionInfo()
    var preferredShift = MICategorySelectionInfo()
    var expectedSalary = SalaryDetail()
    var willingToWorkSixDay : Bool?
    var openToWorkWithStartUp : Bool?
    
    init(industry:[MICategorySelectionInfo],function:[MICategorySelectionInfo],role:[MICategorySelectionInfo],location:[MICategorySelectionInfo],residens:[MICategorySelectionInfo],workAuthorization:[MICategorySelectionInfo],jobtype:MICategorySelectionInfo,employmentType:MICategorySelectionInfo,shift:MICategorySelectionInfo,expSalary:SalaryDetail,sixday:Bool,startUp:Bool) {
        
        
        if let ind = industry.map({$0.copy()}) as? [MICategorySelectionInfo] {
            self.preferredIndustrys = ind
        }
        if let fun = function.map({$0.copy()}) as? [MICategorySelectionInfo] {
            self.preferredFunctions = fun
        }
        if let role = role.map({$0.copy()}) as? [MICategorySelectionInfo] {
            self.preferredRoles = role
        }
        if let loc = location.map({$0.copy()}) as? [MICategorySelectionInfo] {
            self.preferredLocationList = loc
        }
        if let res = residens.map({$0.copy()}) as? [MICategorySelectionInfo] {
            self.residentList = res
        }
        if let workauth = workAuthorization.map({$0.copy()}) as? [MICategorySelectionInfo] {
            self.workAuthorizationList = workauth
        }
        if let jobtype = jobtype.copy() as? MICategorySelectionInfo {
            self.preferredJobType = jobtype
            
        }
        if let employtype = employmentType.copy() as? MICategorySelectionInfo {
            self.preferredEmploymentType = employtype
            
        }
        if let jobshift = shift.copy() as? MICategorySelectionInfo {
            self.preferredShift = jobshift
        }
        if let salary = expSalary.copy() as? SalaryDetail {
            self.expectedSalary = salary
        }
        
        self.willingToWorkSixDay = sixday
        self.openToWorkWithStartUp = startUp
        
    }
    
    override init() {
        
    }
    
    class func getProfileJobPreferenceModel(obj:MIProfilePreferenceInfo) -> MIJobPreferencesModel {
        
        let objJobpre = MIJobPreferencesModel()
        objJobpre.preferredLocationList = obj.locArray
        objJobpre.preferredRoles = obj.rolesArray
        objJobpre.preferredIndustrys = obj.industryArray
        objJobpre.preferredFunctions = obj.functionArray
        return objJobpre
        
    }
    class func getObjectFromModel(params:[String:Any]) -> MIJobPreferencesModel {
        let objectPreferences = MIJobPreferencesModel()
        
        if let  functions = params[APIKeys.functionsAPIKey] as? [Any] {
            for function in functions {
                if let functionPrefernces = function as? [String :Any] {
                    if let function = MICategorySelectionInfo(dictionary: functionPrefernces) {
                        objectPreferences.preferredFunctions.append(function)
                        
                    }
                }
                
            }
        }
        if let  locations = params[APIKeys.locationsAPIKey] as? [Any] {
            for location in locations {
                if let locationPrefernces = location as? [String :Any] {
                    if let location = MICategorySelectionInfo(dictionary: locationPrefernces) {
                        objectPreferences.preferredLocationList.append(location)
                        
                    }
                }
                
            }
        }
        
        if let  industries = params[APIKeys.industriesAPIKey] as? [Any] {
            for industry in industries {
                if let industryPrefernces = industry as? [String :Any] {
                    if let industry = MICategorySelectionInfo(dictionary: industryPrefernces) {
                        objectPreferences.preferredIndustrys.append(industry)
                        
                    }
                }
                
            }
        }
        if let  roles = params[APIKeys.rolesAPIKey] as? [Any] {
            for role in roles {
                if let rolePrefernces = role as? [String :Any] {
                    if let role = MICategorySelectionInfo(dictionary: rolePrefernces) {
                        objectPreferences.preferredRoles.append(role)
                        
                    }
                }
            }
        }
        if let  jobType = params[APIKeys.jobTypeAPIKey] as? [String :Any] {
            objectPreferences.preferredJobType = MICategorySelectionInfo(dictionary: jobType) ?? MICategorySelectionInfo()
        }
        if let  preferredShift = params[APIKeys.preferredShiftAPIKey] as? [String :Any] {
            objectPreferences.preferredShift = MICategorySelectionInfo(dictionary: preferredShift) ?? MICategorySelectionInfo()
        }
        if let  employmentType = params[APIKeys.employmentTypeAPIKey] as? [String :Any] {
            objectPreferences.preferredEmploymentType = MICategorySelectionInfo(dictionary: employmentType) ?? MICategorySelectionInfo()
        }
        if let sixDayWorking = params[APIKeys.sixDayWeekAPIKey] as? Bool {
            objectPreferences.willingToWorkSixDay = sixDayWorking
        }
        if let startUp = params[APIKeys.startUpAPIKey] as? Bool {
            objectPreferences.openToWorkWithStartUp = startUp
        }
        if let expectedSalry = params[APIKeys.expectedSalaryAPIKey] as? [String:Any] {
            objectPreferences.expectedSalary = SalaryDetail(salary: expectedSalry) ?? SalaryDetail()
            //            if let currency = expectedSalry[APIKeys.currencyAPIKey] as? String {
            //                objectPreferences.expectedSalary.salaryCurrency = currency
            //
            //            }
            //            if let absoluteValue = expectedSalry[APIKeys.absoluteValueAPIKey] as? Int64 , absoluteValue > 0 {
            //                objectPreferences.expectedSalary.salaryInLakh = "\(absoluteValue/100000)"
            //                if objectPreferences.expectedSalary.salaryCurrency == "INR" {
            //                    let salaryLkh = absoluteValue/100000
            //                    objectPreferences.expectedSalary.salaryInLakh = "\(salaryLkh)"
            //                    objectPreferences.expectedSalary.salaryThousand = "\(absoluteValue%100000)"
            //
            //
            //                }else{
            //                    objectPreferences.expectedSalary.salaryInLakh =  "\(absoluteValue)"
            //                    objectPreferences.expectedSalary.salaryThousand =  "0"
            //                }
            //            }
            
        }
        return objectPreferences
    }
    class func getParamsForJobPreferenceViaRegister(obj:MIJobPreferencesModel) -> [String:Any] {
        var params = [String:Any]()
        var dataParams = [[String:Any]]()
        if obj.preferredLocationList.count > 0  {
            for locationModel in obj.preferredLocationList {
                dataParams.append(MIUserModel.getParamForIdText(id: locationModel.uuid, value:locationModel.name))
            }
        }
        params[APIKeys.locationsAPIKey] = dataParams
        
        dataParams.removeAll()
        if obj.preferredRoles.count > 0 {
            for roles in obj.preferredRoles {
                dataParams.append(MIUserModel.getParamForIdText(id: roles.uuid, value:roles.name))
            }
        }
        params[APIKeys.rolesAPIKey] = dataParams
        if obj.preferredJobType.name.count > 0 {
            params[APIKeys.jobTypeAPIKey] = obj.preferredJobType.uuid
            //MIUserModel.getParamForIdText(id: obj.preferredJobType.uuid, value: obj.preferredJobType.name)
        }
        
        var additionalPersonalDetail = [String:Any]()
        if !obj.profileTitle.isEmpty {
            additionalPersonalDetail[APIKeys.profileTitleAPIKey] = obj.profileTitle
        }
        dataParams.removeAll()
        if obj.residentList.count > 0 {
            for obj in obj.residentList {
                dataParams.append( MIUserModel.getParamForIdText(id: obj.uuid) )
            }
        }
        additionalPersonalDetail[APIKeys.residentCountriesAPIKey] = dataParams
        dataParams.removeAll()
        if obj.workAuthorizationList.count > 0 {
            for obj in obj.workAuthorizationList {
                dataParams.append( MIUserModel.getParamForIdText(id: obj.uuid) )
            }
        }
        additionalPersonalDetail[APIKeys.workAuthorizedCountriesAPIKey] = dataParams
        
        
        params[APIKeys.additionalPersonalDetailAPIKey] = additionalPersonalDetail
        
        return params
        
    }
    class func getParamFromModel(obj:MIJobPreferencesModel) -> [String:Any] {
        var params = [String:Any]()
        //var additionalPersonalDetailparams = [String:Any]()
        
        var dataParams = [[String:Any]]()
        
        if obj.preferredLocationList.count != 0  {
            for locationModel in obj.preferredLocationList {
                dataParams.append(MIUserModel.getParamForIdText(id: locationModel.uuid, value:locationModel.name))
            }
        }
        params[APIKeys.locationsAPIKey] = dataParams
        
        dataParams.removeAll()
        if obj.preferredIndustrys.count != 0 {
            for industru in obj.preferredIndustrys {
                dataParams.append(MIUserModel.getParamForIdText(id: industru.uuid, value:industru.name))
            }
        }
        params[APIKeys.industriesAPIKey] = dataParams
        
        dataParams.removeAll()
        if obj.preferredFunctions.count != 0 {
            for functions in obj.preferredFunctions {
                dataParams.append(MIUserModel.getParamForIdText(id: functions.uuid, value:functions.name))
            }
        }
        params[APIKeys.functionsAPIKey] = dataParams
        
        dataParams.removeAll()
        if obj.preferredRoles.count != 0 {
            for roles in obj.preferredRoles {
                dataParams.append(MIUserModel.getParamForIdText(id: roles.uuid, value:roles.name))
            }
            
        }
        params[APIKeys.rolesAPIKey] = dataParams
        
        dataParams.removeAll()
        if obj.preferredJobType.name.count != 0 {
            params[APIKeys.jobTypeAPIKey] = MIUserModel.getParamForIdText(id: obj.preferredJobType.uuid, value: obj.preferredJobType.name)
        }else{
            // params["jobType"] = MIUserModel.getParamForIdTextForUUIDNil()
            
        }
        
        if obj.preferredShift.name.count != 0 {
            params[APIKeys.preferredShiftAPIKey] = MIUserModel.getParamForIdText(id: obj.preferredShift.uuid, value: obj.preferredShift.name)
        }else{
          //  params[APIKeys.preferredShiftAPIKey] = MIUserModel.getParamForIdTextForUUIDNil()
            
        }
        if obj.preferredEmploymentType.name.count != 0 {
            params[APIKeys.employmentTypeAPIKey] = MIUserModel.getParamForIdText(id: obj.preferredEmploymentType.uuid, value: obj.preferredEmploymentType.name)
        }else{
            //  params["employmentType"] = MIUserModel.getParamForIdTextForUUIDNil()
            
        }
        
        if obj.expectedSalary.salaryInLakh.count > 0 || obj.expectedSalary.salaryThousand.count > 0  {
            params[APIKeys.expectedSalaryAPIKey] = SalaryDetail.getSalaryParam(salary: obj.expectedSalary, withConfidential: false)
            
        }else{
          //  params[APIKeys.expectedSalaryAPIKey] = [APIKeys.absoluteValueAPIKey : nil,APIKeys.currencyAPIKey :obj.expectedSalary.salaryCurrency]
            
        }
        if let sixDays = obj.willingToWorkSixDay {
            params[APIKeys.sixDayWeekAPIKey] = sixDays
            
        }
        if let strtUp = obj.openToWorkWithStartUp {
            params[APIKeys.startUpAPIKey] = strtUp
            
        }
        
        if !obj.profileTitle.isEmpty {
            params[APIKeys.additionalPersonalDetailAPIKey] = [APIKeys.profileTitleAPIKey:obj.profileTitle]
            
        }
        
        return params
        
    }
    func copy(with zone: NSZone? = nil) -> Any {
        let jobpre = MIJobPreferencesModel(industry: preferredIndustrys, function: preferredFunctions, role: preferredRoles, location: preferredLocationList, residens: residentList, workAuthorization: workAuthorizationList, jobtype: preferredJobType, employmentType: preferredEmploymentType, shift: preferredShift, expSalary: expectedSalary, sixday: willingToWorkSixDay ?? false, startUp: openToWorkWithStartUp ?? false)
        return jobpre
    }
}

class MIUserSkills : NSObject {
    
    var id  = ""
    var skillName = ""
    var skillId = ""
    var skillCategory = SkillCategory.NonITSkill
    init(name:String? = "",skillId:String? = "") {
        self.skillName = (name ?? "").withoutWhiteSpace()
        self.skillId = skillId ?? ""
    }
    
    public class func getSkillFromResume(dataArray:[[String:Any]]) -> [MIUserSkills] {
        var models:[MIUserSkills] = []
        for item in dataArray
        {
            if !item.stringFor(key: APIKeys.nameAPIKey).isEmpty {
                models.append(MIUserSkills(name: item.stringFor(key: APIKeys.nameAPIKey), skillId: item.stringFor(key: APIKeys.uuidAPIKey)))
            }
        }
        return models
    }
    public class func modelsFromDictionaryArray(array:[[String:Any]],category:SkillCategory = SkillCategory.NonITSkill) -> [MIUserSkills] {
        var models:[MIUserSkills] = []
        for item in array {
            
            if let info = MIUserSkills(dictionary:item) {
                if !info.skillName.isEmpty {
                    info.skillCategory = category
                    models.append(info)
                }
            }
        }
        return models
    }
    public class func getDictionaryArrayFromDataSource(skills:[MIUserSkills]) -> [[String:Any]] {
        var models:[[String:Any]] = []
        for item in skills {
            var skills = [String:Any]()
            skills[APIKeys.skillAPIKey] = MIUserModel.getParamForIdTextForUUIDNil(id: item.skillId, value: item.skillName.withoutWhiteSpace())
            models.append(skills)
        }
        return models
        
    }
    required public init?(dictionary: [String:Any]) {
        id   = dictionary.stringFor(key:APIKeys.idAPIKey)
        if let skillDic = dictionary[APIKeys.skillAPIKey] as? [String:Any] {
            skillId   = skillDic.stringFor(key:APIKeys.idAPIKey)
            skillName = skillDic.stringFor(key:APIKeys.textAPIKey).withoutWhiteSpace()
        }
        
    }
    
    public class func getITNonItSkill(params:[String:Any]) -> [MIUserSkills] {
        
        var models = [MIUserSkills]()
        if let skillSection = params["skillSection"] as? [String:Any],let skills = skillSection["skills"] as? [[String:Any]],skills.count > 0 {
            models.append(contentsOf:MIUserSkills.modelsFromDictionaryArray(array: skills,category: SkillCategory.NonITSkill))
        }
        if let itSection=params["itSkillSection"] as? [String:Any],let itskills = itSection["itSkills"] as? [[String:Any]],itskills.count > 0 {
            models.append(contentsOf: MIUserSkills.modelsFromDictionaryArray(array: itskills,category: SkillCategory.ITSkill))
        }
        return  models
    }
    static func == (lhs: MIUserSkills, rhs: MIUserSkills) -> Bool {
        return lhs.id != rhs.id
    }
}

extension  MIUserModel {
    
    class func getParamForIdText(id:String = "",value:String = "") -> [String:Any] {
        var params = [String:Any]()
        if id.isEmpty && value.isEmpty {
            params[MIEducationDetailViewControllerConstant.idAPIKey] = ""
            params[MIEducationDetailViewControllerConstant.textAPIKey] = ""
        }else if !id.isEmpty && !value.isEmpty {
            params[MIEducationDetailViewControllerConstant.idAPIKey] = id
            params[MIEducationDetailViewControllerConstant.textAPIKey] = value
        }else if id.isEmpty {
            params[MIEducationDetailViewControllerConstant.textAPIKey] = value
        }else if value.isEmpty {
            params[MIEducationDetailViewControllerConstant.idAPIKey] = id
        }else{
            params[MIEducationDetailViewControllerConstant.idAPIKey] = nil
            params[MIEducationDetailViewControllerConstant.textAPIKey] = nil
            
        }
        
        return params
    }
    class func getParamForIdTextForUUIDNil(id:String = "",value:String = "") -> [String:Any] {
        var params = [String:Any]()
        if !id.isEmpty {
            params[MIEducationDetailViewControllerConstant.idAPIKey] = id
            
        }
        params[MIEducationDetailViewControllerConstant.textAPIKey] = value
        
        return params
    }
}
