//
//  MIEnums.swift
//  MonsteriOS
//
//  Created by Monster on 15/10/18.
//  Copyright © 2018 Monster. All rights reserved.
//


import UIKit

struct Storyboard {
    static let main = UIStoryboard(name: "Main", bundle: nil)
}

struct Color {

    static let colorDefault         = UIColor.colorWith(r: 108, g: 84,  b: 218, a: 1.0)
    static let colorLightDefault    = UIColor.colorWith(r: 92,  g: 74,  b: 174, a: 1.0)
    static let colorDarkBlack       = UIColor.colorWith(r: 33,  g: 43,  b: 54,  a: 1.0)
    static let colorBtnBorder       = UIColor.colorWith(r: 224, g: 220, b: 220, a: 1.0)
    static let colorStatusBarView   = UIColor.colorWith(r: 81,  g: 45,  b: 168, a: 1.0)
    static let colorStatusBarTop    = UIColor.colorWith(r: 103, g: 58,  b: 183, a: 1.0)
    static let colorGrey            = UIColor.colorWith(r: 238, g: 238, b: 238, a: 1.0)
    static let colorLightGrey       = UIColor.colorWith(r: 223, g: 227, b: 232, a: 1.0)
    static let colorClearBtnBorder  = UIColor.colorWith(r: 196, g: 205, b: 213, a: 1.0)
    static let colorTextLight       = UIColor.colorWith(r: 145, g: 158, b: 171, a: 1.0)
    static let shadowTopViewColor   = UIColor.colorWith(r: 0,   g: 0,   b: 0,   a: 0.1).cgColor
    static let shadowViewColor      = UIColor.colorWith(r: 0,   g: 0,   b: 0,   a: 0.02).cgColor
  //  static let secondaryBtnColor    = UIColor.colorWith(r: 43,   g: 148,   b: 255,   a: 1)
   // static let blueThemeColor       = UIColor.colorWith(r: 26,   g: 149,   b: 224,   a: 1)
    static let secondaryBtnColor    = UIColor.colorWith(r: 43,   g: 148,   b: 255,   a: 1)
    static let blueThemeColor       = UIColor(hex: "0091FF")
    static let errorColor           = UIColor(hex: "f44336")
}

struct CornerRadius {
    static let btnCornerRadius  = CGFloat(4.0)
    static let viewCornerRadius = CGFloat(4.0)
}

struct BorderWidth {
    static let btnBorderWidth  = CGFloat(1.0)
}

struct Shadow {
    static let shadowViewOffset   = CGSize(width: 0.5, height: 0.5)
    static let shadowViewRadius   = 1
    static let shadowViewOpacity  = 1
}

var kmiddlewareApiBaseURL = (apiMode == .Production) ? "https://www.monsterindia.com" : kBaseUrl

var APIPath = APIPathURL()

class APIPathURL {

    //Falcon APIs
    var languageCreateProfileApi    =  "\(kBaseUrl)/falcon/api/users/v1/personal-details/languages"
    var getProfileApi               =  "\(kBaseUrl)/falcon/api/users/v1/me/profiles?fields="
    var getExistingProfileApi       =  "\(kBaseUrl)/falcon/api/users/v1/profiles"
    var importProfileApi            =  "\(kBaseUrl)/falcon/api/users/v1/import-profile"
    var createEmptyProfileApi       =  "\(kBaseUrl)/falcon/api/users/v1/empty-profile"
    var updateProfileTitleApi       = "\(kBaseUrl)/falcon/api/users/v1/profile-title"
    var downloadResumeApi           =  "\(kBaseUrl)/falcon/api/public/users/v1/download-resume?profileId="
    var registerPersonalDetailVersion_2_ApiEndpoint = "\(kBaseUrl)/falcon/api/public/users/v2/register/personal-details"
   // var registerPersonalDetailApiEndpoint   = "\(kBaseUrl)/falcon/api/public/users/v1/register/personal-details"
  //  var jobPreferenceApiEndpoint            = "\(kBaseUrl)/falcon/api/users/v1/register/job-preferences"
    var jobPreferenceVer_2_ApiEndpoint      = "\(kBaseUrl)/falcon/api/users/v2/register/job-preferences"
    var educationalDetail_Version2_ApiEndpoint = "\(kBaseUrl)/falcon/api/users/v2/register/educational-details"
 //   var educationalDetailApiEndpoint           = "\(kBaseUrl)/falcon/api/users/v1/register/educational-details"
    var employmentDetailVer_2_ApiEndpoint      = "\(kBaseUrl)/falcon/api/users/v2/register/employment-details"
  //  var employmentDetailApiEndpoint            = "\(kBaseUrl)/falcon/api/users/v1/register/employment-details"
    var uploadResumeAPIEndpoint                = "\(kBaseUrl)/falcon/api/users/v1/me/upload-resume"
    var blockCompanies       = "\(kBaseUrl)/falcon/api/users/v1/block-companies"
    var deactivateUser       = "\(kBaseUrl)/falcon/api/users/v1/deactivate-user"
    var deleteProfile        = "\(kBaseUrl)/falcon/api/users/v1/profiles/13/delete"
    var profileVisibilty     = "\(kBaseUrl)/falcon/api/users/v1/profile-visibility"
    var emailPreferences     = "\(kBaseUrl)/falcon/api/users/v1/email-preferences"
    var updateEducationalDetailApiEndpoint  = "\(kBaseUrl)/falcon/api/users/v1/education-details"
    var updateEmploymentDetailApiEndpoint   = "\(kBaseUrl)/falcon/api/users/v1/employment-details"
    var jobSearchStage              = "\(kBaseUrl)/falcon/api/users/v1/job-search-stage"
    var getBlockCompany             = "\(kBaseUrl)/falcon/api/users/v1/blocked-companies"
    var onlinePresence              = "\(kBaseUrl)/falcon/api/users/v1/social-presence"
    var deleteOnlinePresence        = "\(kBaseUrl)/falcon/api/users/v1/social-presence"
    var awardsAchivement            = "\(kBaseUrl)/falcon/api/users/v1/awards"
    var coursesCertification        = "\(kBaseUrl)/falcon/api/users/v1/course-and-certification"
    var unblockCompany              = "\(kBaseUrl)/falcon/api/users/v1/unblock-company"
    var manageActiveProfile         = "\(kBaseUrl)/falcon/api/users/v1/profiles/"
    var manageDeleteProfile         = "\(kBaseUrl)/falcon/api/users/v1/profiles"
    var deleteEmploymentDetails = "\(kBaseUrl)/falcon/api/users/v1/employment-details"
    var deleteEducationDetails  = "\(kBaseUrl)/falcon/api/users/v1/education-details"
    var userProjects            = "\(kBaseUrl)/falcon/api/users/v1/projects"
    var postITSkill             = "\(kBaseUrl)/falcon/api/users/v1/it-skills"
   // var deleteSkill             = "\(kBaseUrl)/falcon/api/users/v1/skills"
    var personalDetailPUTAPIEndpoint = "\(kBaseUrl)/falcon/api/users/v1/personal-details"
    var personalDetailGETAPIEndpoint = "\(kBaseUrl)/falcon/api/users/v1/me/profiles?fields=additional_profiles,personal_details"
    var skillAddUpdateDeleteAPIEndpoint          = "\(kBaseUrl)/falcon/api/users/v1/skills"
    var uploadAvtarAPIEndpoint   = "\(kBaseUrl)/falcon/api/users/v1/me/upload-avatar"
   // var deleteSkillEndPoint      = "\(kBaseUrl)/falcon/api/users/v1/skills"
    var jobPreferenceEditApiEndpoint         = "\(kBaseUrl)/falcon/api/users/v1/job-preferences"
    var jobPreferenceGETApiEndpoint          = "\(kBaseUrl)/falcon/api/users/v1/me/profiles?fields=job_preferences"
    var removeProfilePicApiEndPoint = "\(kBaseUrl)/falcon/api/users/v1/remove-picture"
    var uploadResumeForOCREndPoint  = "\(kBaseUrl)/falcon/api/public/users/v1/upload-and-ocr-resume"
    var profileTitleApiEndPoint     = "\(kBaseUrl)/falcon/api/users/v1/profile-title"
    var uploadOptionaResumeForOCREndPoint = "\(kBaseUrl)/falcon/api/public/users/v1/upload-images-resume"
    var logout = "/rio/api/users/v1/logout"
    var recruiterActionAll           = "\(kBaseUrl)/falcon/api/users/v1/me/recruiters/actions/all"
    var recruiterActionProfileViewed = "\(kBaseUrl)/falcon/api/users/v1/me/recruiters/actions/viewed"
    var recruiterActionContracted    = "\(kBaseUrl)/falcon/api/users/v1/me/recruiters/actions/contacted"
    var recruiterActionConsidered    = "\(kBaseUrl)/falcon/api/users/v1/me/recruiters/actions/considered"
    var preferredLocation = "\(kBaseUrl)/falcon/api/users/v1/preferred-location"
    var updateNoticePeroidAPIEndpoint   = "\(kBaseUrl)/falcon/api/users/v1/notice-period"
    var uploadResumeForDocParse         = "\(kBaseUrl)/falcon/api/public/users/v2/upload-and-parse-resume"
    var uploadResumeForImagesParser = "\(kBaseUrl)/falcon/api/users/v2/upload-images-resume"
    var updateWorkExp = "\(kBaseUrl)/falcon/api/users/v1/experience"
    var skillItImprovementEndpoint = "\(kBaseUrl)/falcon/api/users/v1/skills-and-it-skills"
    var validiateEmail    = "\(kBaseUrl)/falcon/api/public/users/v1/check-email-existence"
    var validiateMobile   = "\(kBaseUrl)/falcon/api/public/users/v1/check-mobile-number-existence"
    var skippedJob    = "/falcon/api/users/v1/jobs/save/skipped"
    var viewedJobs    = "/falcon/api/track/v1/jobs/viewed"
    var canApply      = "/falcon/api/users/v3/jobs/can/apply"
    var forceApply    = "/falcon/api/users/v3/jobs/apply"
    var getJobAlert   = "/falcon/api/users/v3/jobs/alerts"
    var deleteJobAlert = "/falcon/api/users/v3/jobs/alerts/"
    var covidFlag      = "\(kBaseUrl)/falcon/api/users/v1/covid-layoff"
    
     
  
    //Middleware API
    var gleacCandidateID     = "\(kmiddlewareApiBaseURL)/middleware/gleac/api/users/v1/candidate"
    var gleacInstruction     = "\(kmiddlewareApiBaseURL)/middleware/gleac/api/users/v1/instructions/"
    var gleacMarkReport      = "\(kmiddlewareApiBaseURL)/middleware/gleac/api/users/v1/mark-report"
    var gleacSkillResult     = "\(kmiddlewareApiBaseURL)/middleware/gleac/api/users/v1/result"
    
    
    //RIO APIs
    var loginApi         = "\(kBaseUrl)/rio/oauth/token"
    var linkSocial       = "\(kBaseUrl)/rio/api/users/v1/social/link"
    var unlinkSocial     = "\(kBaseUrl)/rio/api/users/v1/social/unlink"
    var sendOTP          = "\(kBaseUrl)/rio/api/public/users/v1/send-otp"
    var changePassword        = "\(kBaseUrl)/rio/api/users/v2/change-password"
    var appleRefreshTokenAPI = "\(kBaseUrl)/rio/api/private/users/v1/fetch-refresh-token"
    var sendOTPEmailEndPoint  = "\(kBaseUrl)/rio/api/users/v1/send-email-otp"
    var sendOTPMobileEndPoint = "\(kBaseUrl)/rio/api/users/v1/send-otp"
    var validateEmailEndPoint = "\(kBaseUrl)/rio/api/users/v1/vaidate-email-detail"
    var validateMobileEndPoint    = "\(kBaseUrl)/rio/api/users/v1/vaidate-mobile-detail"
    var verifyemailApiEndPoint    = "\(kBaseUrl)/rio/api/users/v1/verify-email"
    var anonyymousClaimOnRegister = "\(kBaseUrl)/rio/api/public/anonymous-users/v1/send-otp"
    var updateUserDataAPIEndpoint = "\(kBaseUrl)/rio/api/users/v1/me"
    var rioAutoLoginOldSystemEndpoint = "/rioautologin.html?auth_token="

    
    //MACAW APIs
    var splashAPI           = "\(kBaseUrl)/macaw/api/public/mobiles/configs/v2/splash-screen"
    var splashMasterAPI     = "\(kBaseUrl)/macaw/api/public/mobiles/configs/v2/splash-screen/master-data?type="
    var reSendOTP           = "\(kBaseUrl)/macaw/api/public/users/v1/send-otp"
    var recentSearchGETAPIEndpoint  = "\(kBaseUrl)/macaw/api/public/events/v1/ml/recent-searches?limit=40"
    var validiateSEOURL     = "/macaw/api/public/parse/v1/seo-urls"
    var similarJobs         = "/macaw/api/search/v1/ml/similar-jobs"
    var appliedalsoapplied  = "/macaw/api/public/users/v1/ml/jobs/applied-also-applied"
    var suggestedJobs = "/macaw/api/users/v1/ml/jobs/suggested"
    var appliedJob    = "/macaw/api/users/v1/jobs/applied"
    var getJobDetails = "/macaw/api/public/search/v1/job-detail"
    var saveJob     = "/macaw/api/users/v1/jobs/save"
    var unsaveJob   = "/macaw/api/users/v1/jobs/unsave"
    var savedJob    = "/macaw/api/users/v1/jobs/saved"
    var netwrokJob  = "/macaw/api/users/v1/ml/jobs/network"
    var searchJob   = "/macaw/api/public/search/v3/jobs"
    var companyDetails       = "\(kBaseUrl)/macaw/api/search/v1/company-detail/"


    //PENGUIN APIs
    var jobFeedback           = "\(kBaseUrl)/penguin/api/public/events/v1/results/feedback"
    var recentSearchDeleteApi = "\(kBaseUrl)/penguin/api/public/events/v1/ml/recent-searches/devicesAndLabels"
    var recentSearchDeleteAll = "\(kBaseUrl)/penguin/api/public/events/v1/ml/recent-searches/devices"
    var reportBug                   = "\(kBaseUrl)/penguin/api/public/events/v1/bugs"
    var trackingEvents    = "\(kBaseUrl)/penguin/api/public/events/user-engage/v1"
    var seekerMapEvents   = "\(kBaseUrl)/penguin/api/public/events/new/v2/publish"
    var applyTrackEvent   = "/penguin/api/public/events/new/v2/publish"
    var getSessionIdEndPoint = "\(kBaseUrl)/penguin/api/public/events/new/v2/publish/sessionid"
    var abTestingAPI        = "\(kBaseUrl)/penguin/api/public/events/v1/ab-testing"
    var fieldLevelTrackingEndPoint        = "\(kBaseUrl)/penguin/api/public/events/v1/field-level-update"
    var gleacSkillMapEvents  = "\(kBaseUrl)/penguin/api/public/events/v1/gleac"


    
    
//    //THOR APIs
//    var homeApi          = "\(kBaseUrl)/thor/api/public/sites/v1/load-data?site=rexmonster&tenant=android&category=home&lang=en"
//    var upskillApi = "\(kBaseUrl)/thor/api/public/sites/v1/load-data?site=rexmonster&tenant=android&category=upskill&lang=en"
    
    //RAVEN APIs
    var autoSuggestApi   = "\(kBaseUrl)/raven/api/public/search/v1/auto-fill?query="
    var suggestedKeyword = "\(kBaseUrl)/raven/api/public/search/v1/suggested-keywords?query="
    var locationApi      =  "\(kBaseUrl)/raven/api/public/search/v1/auto-fill?type=locations&query="
//    var srpListingApi    =  "\(kBaseUrl)/raven/api/public/search/v1/jobs?jobTypes=walkin"
    var masterListingApi =  "\(kBaseUrl)/raven/api/public/search/v1/master-data?type="
    var getJobSearchStage    = "\(kBaseUrl)/raven/api/public/search/v1/master-data?type=JOB_SEARCH_STAGE&limit=1000"
    //var companyDetails       = "\(kBaseUrl)/raven/api/public/search/v1/company-detail"
    var searchSuggestedSkill = "/raven/api/public/search/v1/master-data"

    
    //VULTURE APIs
    var skipCards            = "\(kBaseUrl)/vulture/api/v1/seeker-cards/skip"
    var profileEngagementURL = "\(kBaseUrl)/vulture/api/v1/seeker-cards"

    
    //SWARM APIs
    var followCompany      = "/swarm/api/v1/seeker/follow/company/"
    var unfollowCompany    = "/swarm/api/v1/seeker/unfollow/company/"
    var followRecruiter    = "/swarm/api/v1/seeker/follow/recruiter/"
    var unfollowRecruiter  = "/swarm/api/v1/seeker/unfollow/recruiter/"
    var getFollowedCompany = "/swarm/api/v1/seeker/following/companies"
    var getFollowedRecruiter = "/swarm/api/v1/seeker/following/recruiters"

    
    //ANONYMOUS APIs
    var voiceSearchAPI   = "\(kBaseUrl)/voice-search/api/v1/getSemantic"
    
}

enum FontName : String {
    case Regular
    case Medium
    case Semibold
    case light
    case Bold
    var name : String {
        switch self {
        case .Regular:
            return "Roboto-Regular"//"Poppins-Regular"
        case .Medium, .Semibold:
            return "Roboto-Medium"//"Poppins-Medium"
        case .light:
            return "Roboto-Light"//Poppins-Light"
        case .Bold:
            return "Roboto-bold"//"Poppins-Bold"
        }
    }
}

enum VersionError: Error {
    case invalidResponse, invalidBundleInfo
}

public enum MasterDataType: String {
    
    case COMPANY        = "COMPANY"
    case DESIGNATION    = "DESIGNATION"
    case SKILL          = "SKILL"
    case ITSkill        = "SKILL&category=IT"
    case FUNCTION       = "FUNCTION"
    case ROLE           = "ROLE"
    case COLLEGE        = "COLLEGE"
    case LOCATION       = "LOCATION"
    case COUNTRY        = "COUNTRY"
    case SPECIALIZATION = "SPECIALIZATION"
    case NATIONALITY    = "NATIONALITY"
    case BOARD          = "BOARD"
    case INDUSTRY       = "INDUSTRY"
    case DISABILITY     = "DISABILITY"
    case LANGUAGE       = "LANGUAGE"
    case MEDIUM         = "MEDIUM"
    case GENDER         = "GENDER"
    case JOB_TYPE       = "JOB_TYPE"
    case VISA_TYPE      = "VISA_TYPE"
    case HIGHEST_QUALIFICATION     = "HIGHEST_QUALIFICATION"
    case MARITIAL_STATUS           = "MARITAL_STATUS"
    case EMPLOYMENT_SHIFT          = "EMPLOYMENT_SHIFT"
    case PROBLEM_WITH_SITE         = "PROBLEM_WITH_SITE"
    case RESERVATION_CATEGORY      = "RESERVATION_CATEGORY"
    case EDUCATION_TYPE            = "EDUCATION_TYPE"
    case IT_SKILL_EXPERIENCE       = "IT_SKILL_EXPERIENCE"
    case JOB_ALERT_FREQUENCY       = "JOB_ALERT_FREQUENCY"
    case LANGUAGE_LEVEL            = "LANGUAGE_LEVEL"
    case LANGUAGE_PROFICIENCY      = "LANGUAGE_PROFICIENCY"
    case EMPLOYMENT_TYPE           = "EMPLOYMENT_TYPE"
    case DISABILITY_SUBTYPE        = "DISABILITY_SUBTYPE"
    case DISABILITY_DETAIL         = "DISABILITY_DETAIL"
    case SALARY_MODE               = "SALARY_MODE"

    
    
    var shouldShowAdd:Bool {
        switch self {
        case .INDUSTRY:
            return false
        case .FUNCTION:
            return false
        case .ROLE:
            return false
        case .LOCATION:
            return false
        case .EDUCATION_TYPE:
            return false
        case .VISA_TYPE:
            return false
        case .DISABILITY_DETAIL:
            return false
        case .COUNTRY:
            return false
        case .RESERVATION_CATEGORY:
            return false
        case .MARITIAL_STATUS:
            return false
        case .GENDER:
            return false
        case .JOB_TYPE:
            return false
        case .EMPLOYMENT_TYPE:
            return false
        case .EMPLOYMENT_SHIFT:
            return false
        case .LANGUAGE:
            return false
        case .LANGUAGE_PROFICIENCY:
            return false
        case .NATIONALITY:
            return false

        default:
            return true
        }
    }
    var excludedData:[MICategorySelectionInfo] {
        switch self {
        default:
            return []
        }
    }
    var masterTitle:String {
        switch self {
        case .JOB_TYPE:
            return "JOB TYPE"
        case .VISA_TYPE:
            return "VISA TYPE"
        case .HIGHEST_QUALIFICATION:
            return "HIGHEST QUALIFICATION"
        case .MARITIAL_STATUS:
            return "MARITAL STATUS"
        case .EMPLOYMENT_SHIFT:
            return "EMPLOYMENT SHIFT"
        case .PROBLEM_WITH_SITE:
            return "PROBLEM WITH SITE"
        case .RESERVATION_CATEGORY:
            return "RESERVATION CATEGORY"
        case .EDUCATION_TYPE:
            return "EDUCATION TYPE"
        case .IT_SKILL_EXPERIENCE:
            return "IT SKILL EXPERIENCE"
        case .JOB_ALERT_FREQUENCY:
            return "FREQUENCY"
        case .LANGUAGE:
            return "LANGUAGE"
        case .LANGUAGE_LEVEL:
            return "LANGUAGE LEVEL"
        case .LANGUAGE_PROFICIENCY:
            return "LANGUAGE PROFICIENCY"
        case .EMPLOYMENT_TYPE:
            return "EMPLOYMENT TYPE"
        case .DISABILITY_DETAIL:
            return "DISABILITY DETAIL"
        case .DISABILITY_SUBTYPE:
            return "SUBTYPE"
        case .DISABILITY:
            return "TYPE"
        case .SALARY_MODE:
            return "SALARY MODE"
        case .COLLEGE:
            return "INSTITUTE"
        case .ITSkill:
            return "IT Skill"

        default:
            return self.rawValue
        }
    }
    
    var isFromDB:Bool {
        get {
            switch self {
            case .FUNCTION: return false
            case .ROLE: return false
            case .INDUSTRY: return false
            case .COUNTRY: return false
            case .NATIONALITY: return false
            case .HIGHEST_QUALIFICATION: return false
            case .BOARD: return false
            case .GENDER: return false
            case .COLLEGE: return false
            case .SPECIALIZATION: return false
            case .DISABILITY: return false
            case .LANGUAGE: return false
            case .MEDIUM: return false
            case .MARITIAL_STATUS: return false
            case .EMPLOYMENT_SHIFT: return false
            case .PROBLEM_WITH_SITE: return false
            case .RESERVATION_CATEGORY: return false
            case .EDUCATION_TYPE: return false
            case .IT_SKILL_EXPERIENCE: return false
            case .JOB_ALERT_FREQUENCY: return false
            case .LANGUAGE_LEVEL: return false
            case .LANGUAGE_PROFICIENCY: return false
            case .EMPLOYMENT_TYPE: return false
            case .JOB_TYPE: return false
            case .VISA_TYPE: return false
            case .DISABILITY_DETAIL: return false
            case .DISABILITY_SUBTYPE: return false
            case .SALARY_MODE: return false

            default:
                return false
            }
        }
    }
    
    var isOptional:Bool {
        get {
            switch self {
            default:
                return true
            }
        }
        
    }
    
    var isMultiSelected : Bool {
        get {
            switch self {
                case .COMPANY : return false
                case .DESIGNATION : return false
                case .SKILL : return false
                case .FUNCTION : return false
                case .ROLE : return false
                case .COLLEGE : return false
                case .LOCATION : return false
                case .COUNTRY : return false
                case .SPECIALIZATION : return false
                case .NATIONALITY : return false
                case .BOARD : return false
                case .INDUSTRY : return false
                case .HIGHEST_QUALIFICATION : return false
                case .DISABILITY : return false
                case .LANGUAGE : return false
                case .MEDIUM : return false
                case .MARITIAL_STATUS : return false
                case .EMPLOYMENT_SHIFT : return false
                case .PROBLEM_WITH_SITE : return false
                case .RESERVATION_CATEGORY : return false
                case .EDUCATION_TYPE : return false
                case .IT_SKILL_EXPERIENCE : return false
                case .JOB_ALERT_FREQUENCY : return false
                case .LANGUAGE_LEVEL : return false
                case .LANGUAGE_PROFICIENCY : return false
                case .EMPLOYMENT_TYPE : return false
                case .GENDER : return false
                case .JOB_TYPE : return false
                case .VISA_TYPE : return false
                case .DISABILITY_SUBTYPE : return false
                case .DISABILITY_DETAIL : return false
                case .SALARY_MODE : return false
                case .ITSkill: return false

            }
        }
    }
    
}

var sinceYear : [String] {
    let currentYear = Calendar.current.component(Calendar.Component.year, from: Date())
    var passingYear = [String]()
    for year in (currentYear - 80)..<(currentYear+1) {
        passingYear.append("\(year)")
    }
    return passingYear.reversed()
}

public enum StaticMasterData : String {
    
    case PASSINGYEAR = "PASSING_YEAR"
    case SALARYINLAKH = "LAKH"
    case SALARYINTHOUSAND = "THOUSNAD"
    case EXPEREINCEINYEAR = "EXPERIENCE_YEAR"
    case EXPEREINCEINMONTH = "EXPERIENCE_MONTH"
    case CURRENCY = "CURRENCY"
    case EDUCATIONTYPE = "EDUCATION_TYPE"
    case FREQUENCY = "FREQUENCY"
    case NOTICEPEROID = "NOTICE PEROID"
    case PERCENTAGE = "PERCENTAGE"
    case PREFERRED_SHIFT = "Preferred Shift"
    case TILL_MONTH = "Month"
    case TILL_YEAR = "Year"
    case LAST_USED = "LAST USED"

    
    var dataListValues : [String] {
        switch self {
        case .LAST_USED:
            let currentYear = Calendar.current.component(Calendar.Component.year, from: Date())
            var passingYear = [String]()
            for year in (currentYear - 90)..<(currentYear) {
                passingYear.append("\(year)")
            }
            return passingYear.reversed()
        case .TILL_MONTH:
            var expInMonth = [String]()
            for index in 1...12 {
                expInMonth.append("\(index)")
            }
            return expInMonth
            
        case .TILL_YEAR:
            let currentYear = Calendar.current.component(Calendar.Component.year, from: Date())
            var passingYear = [String]()
            for year in (currentYear - 70)..<(currentYear + 2) {
                passingYear.append("\(year)")
            }
            return passingYear.reversed()

        case .PASSINGYEAR:
              let currentYear = Calendar.current.component(Calendar.Component.year, from: Date())
              var passingYear = [String]()
              for year in (currentYear - 50)..<(currentYear + 6) {
                passingYear.append("\(year)")
              }
              return passingYear.reversed()
        case .SALARYINLAKH:
            var lakhArray = [String]()
            for index in 0..<50 {
                lakhArray.append("\(index)")
            }
            for indexInterval in stride(from: 50, to: 100, by: 5) {
                lakhArray.append("\(indexInterval)")
            }
            return lakhArray

        case .SALARYINTHOUSAND:
            var thousnadArray = [String]()
            for salaryThousand in stride(from: 0, to: 96000, by: 5000) {
                thousnadArray.append("\(salaryThousand)")

            }
            return thousnadArray

        case .EXPEREINCEINYEAR:
            var expInYear = [String]()
            for index in stride(from: 0, to: 51, by: 1) {
                expInYear.append("\(index)")

            }
            return expInYear
        case .EXPEREINCEINMONTH:
            var expInMonth = [String]()
            for index in 0..<12 {
                expInMonth.append("\(index)")
            }
            return expInMonth
        case .CURRENCY:
            let currencyList = AppDelegate.instance.splashModel.currencies?.map({ $0.isoCode }) ?? []
            return currencyList
        case .EDUCATIONTYPE:
            return ["Full Time","Part Time","Correspondence"]
        case .FREQUENCY:
            return ["Daily","Weekly","Monthly"]
        case .NOTICEPEROID:
            return ["Serving Notice Period","15 Days or Less","1 Month","2 Months","3 Months","More Than 3 Months"]
        case .PERCENTAGE:
            var percentage = [String]()
            percentage = ["<40 %","40 % - 44.9 %","45 % - 49.99 %","50 % - 54.99 %","55 % - 59.99 %","60 % - 64.99 %","65 % - 69.99 %","70 % - 74.99 %","75 % - 79.99 %","80 % - 84.99 %","85 % - 89.99 %","90 % - 94.99 %","95 % - 100 %"]

            return percentage
        case .PREFERRED_SHIFT:
            return ["Day Shift","Night Shift","Rotating Shift","Not interested in Shift Anymore"]
        }
      
    }
    
    
    
    var staticMasterDataTitle : String {
        
        switch self {
        case .PASSINGYEAR:
            return "Year Of Passing"
        case .SALARYINLAKH:
            return "Salary In Lakh"
        case .SALARYINTHOUSAND:
            return "Salary In Thousand"
        case .EXPEREINCEINMONTH:
            return "Experience In Month"
        case .EXPEREINCEINYEAR:
            return "Experience In Year"
        case .CURRENCY:
            return "Currency"
        case .EDUCATIONTYPE:
            return "Education Type"
        case .FREQUENCY:
            return "Frequency"
        case .NOTICEPEROID:
            return "Notice Period"
        case .PERCENTAGE:
            return "Percentage"
            
        case .PREFERRED_SHIFT:
            return "Preferred Shift"
            
        case .TILL_MONTH:
            return "Month"
            
        case .TILL_YEAR:
            return "Year"
        case .LAST_USED:
            return "Last Used"
        }
    }
    
    var masterDataUnit : String {
        
        switch self {
        case .PASSINGYEAR:
            return ""
        case .SALARYINLAKH:
            return "Lac"
        case .SALARYINTHOUSAND:
            return ""
        case .EXPEREINCEINMONTH:
            return ""
        case .EXPEREINCEINYEAR:
            return ""
        case .CURRENCY:
            return ""
        case .EDUCATIONTYPE:
            return ""
        case .FREQUENCY:
            return ""
        case .NOTICEPEROID:
            return ""
        case .PERCENTAGE:
            return ""
        case .PREFERRED_SHIFT:
            return ""
        case .TILL_MONTH:
            return ""
        case .TILL_YEAR,.LAST_USED:
            return ""
        }
    }
    
}
struct APIKeys {

    static let functionsAPIKey = "functions"
    static let locationsAPIKey = "locations"
    static let industriesAPIKey = "industries"
    static let rolesAPIKey = "roles"
    static let preferredShiftAPIKey = "preferredShift"
    static let employmentTypeAPIKey = "employmentType"
    static let sixDayWeekAPIKey = "sixDayWeek"
    static let startUpAPIKey = "startUp"
    static let expectedSalaryAPIKey = "expectedSalary"
    static let currencyAPIKey = "currency"
    static let confidentialAPIKey = "confidential"
    static let absoluteValueAPIKey = "absoluteValue"
    static let profileTitleAPIKey = "profileTitle"
    static let additionalPersonalDetailAPIKey = "additionalPersonalDetail"
    static let titleAPIKey = "title"
    static let employmentsAPIKey = "employments"
    static let designationAPIKey = "designation"
    static let currentDesignationAPIKey = "currentDesignation"
    static let currentcompanyAPIKey = "currentCompany"
    static let companyAPIKey = "company"
    static let currentSalaryAPIKey = "currentSalary"
    static let salaryAPIKey = "salary"
    static let lakhsAPIKey = "lakhs"
    static let thousandsAPIKey = "thousands"
    static let startDateAPIKey = "startDate"
    static let endDateAPIKey = "endDate"
    static let locationAPIKey = "location"
    static let noticePeriodAPIKey = "noticePeriod"
    static let daysAPIKey = "days"
    static let servingAPIKey = "serving"
    static let lastWorkingDayAPIKey = "lastWorkingDay"
    static let offeredDesignationAPIKey = "offeredDesignation"
    static let newCompanyAPIKey = "newCompany"
    static let offeredSalaryAPIKey = "offeredSalary"
    static let experienceAPIKey = "experience"
    static let yearAPIKey = "years"
    static let monthAPIKey = "months"
    static let fullNameAPIKey = "fullName"
    static let emailAPIKey = "email"
    static let passwordAPIKey = "password"
    static let mobileNumberAPIKey = "mobileNumber"
    static let countryCodeAPIKey = "countryCode"
    static let resumeTextAPIKey = "resumeText"
    static let detailsAPIKey = "details"
    static let contentAPIKey = "content"
    static let profileAPIKey = "profileTitle"
    static let mobileNumbersAPIKey = "mobileNumbers"
    static let experienceLevelAPIKey = "experienceLevel"
    static let homeTownAPIKey = "homeTown"
    static let genderAPIKey = "gender"
    static let dobAPIKey = "dob"
    static let maritalStatusAPIKey = "maritalStatus"
    static let workAuthorizedCountriesAPIKey = "workAuthorizedCountries"
    static let workStatusUSAAPIKey = "workStatusUSA"
    static let residentCountriesAPIKey = "residentCountries"
    static let categoryAPIKey = "category"
    static let disabilityAPIKey = "disability"
    static let passportNumberAPIKey = "passportNumber"
    static let permanentAddressAPIKey = "permanentAddress"
    static let pincodeAPIKey = "pincode"
    static let differentlyAbledAPIKey = "differentlyAbled"
    static let nationalityAPIKey = "nationality"
    static let disabilitytypeAPIKey = "type"
    static let disabilitysubtypeAPIKey = "subType"
    static let disabilitydetailsAPIKey = "detail"
    static let disabilitydescriptionAPIKey = "description"
    static let disabilitycertificationNoAPIKey = "certificate"
    static let disabilityissueByAPIKey = "issuer"
    static let resumeAPIKey = "resume"
    static let bucketAPIKey = "bucket"
    static let pathAPIKey = "path"
    static let detailAPIKey = "detail"
    static let otpAPIKey = "otp"
    static let otpIdAPIKey = "otpId"
    static let socialProviderAPIKey = "socialProvider"
    static let socialAccessTokenAPIKey = "socialAccessToken"
    // static let currentLocationWorkVisaAPIKey = "currentLocationWorkVisa"
    // static let uaeWorkVisaTypeAPIKey = "uaeWorkVisaType"
    static let otherTextAPIKey = "otherText"
    static let yearsAPIKey = "years"
    static let monthsAPIKey = "months"
    static let promotionAndSpecialOffersAPIKey = "promotionAndSpecialOffers"

    static let skillsAPIKey = "skills"
    static let resumeFileAPIKey = "resumeFile"
    static let work_expsAPIKey = "work_exps"
    static let end_dateAPIKey = "end_date"
    static let educationsAPIKey = "educations"
    static let idAPIKey = "id"
    static let highestQualificationAPIKey = "highestQualification"
    static let specializationAPIKey = "specialization"
    static let collegeAPIKey = "college"
    static let boardAPIKey = "board"
    static let educationTypeAPIKey = "educationType"
    static let mediumAPIKey = "medium"
    static let yearOfPassingAPIKey = "yearOfPassing"
    static let percentageAPIKey = "percentage"
    static let start_dateAPIKey = "start_date"
    static let uuidAPIKey = "uuid"
    static let salaryModeAPIKey = "salaryMode"
    static let jobTypeAPIKey = "jobType"
    static let nameAPIKey = "name"
    static let skillAPIKey = "skill"
    static let textAPIKey = "text"
    static let jobPreferenceSectionAPIKey = "jobPreferenceSection"
    static let jobPreferenceAPIKey = "jobPreference"
    static let currentLocationAPIKey = "currentLocation"
    static let errorCodeAPIKey = "errorCode"
    static let personalDetailSectionAPIKey = "personalDetailSection"
    static let personalDetailsAPIKey = "personalDetails"
    static let workVisaType = "workVisaType"
    static let workVisaTypeUpdated = "workVisaTypeUpdated"

    

    
}
struct MIEmploymentDetailViewControllerConstant {
    
    static let title = "Work Experience"
    static let nxtBtnTitle = "Update"
    static let addAnotherBtnTitle = "+ Add another job"
    static let addTitle = "Add"
    static let servingNoticePeroid = "Serving Notice Period"
    static let jobdescription = "Describe your Job Profile"
    static let jobDesignation = "Designation"
    static let companyName = "Company"
    static let noticePeroid = "Notice Period"
    static let lastWorkingDay = "Last working day"
    static let offeredDesignation = "Offered Designation (Optional)"
    static let newCompanyName = "New Company (Optional)"
    static let currentyWorkinghere = "Currently working here"
    static let selectDate = "Select Date"
    static let newCompany = "NewCompany"
    static let salary = "Salary (Optional)"
    static let newOfferedSalary = "New Offered Salary (Optional)"

    
    
    //Error Messages
    static let emptyJobdescription = "Please enter your job profile description."
    static let employmentFromTillDate = "Please check your employment date. From date should be smaller than till date."
    static let emptyJobTitle = "Please select your job title."
    static let emptyCompanyName = "Please select your company name."
    static let emptyFromDate = "Please select work employement from date."
    static let emptyTillDate = "Please select work employement till date."
    static let emptyStartDate = "Please select work employement start date."
    static let emptyEndDate = "Please select work employement end date."
    static let emptyCurrentSalaryCurrency = "Please select current salary currency."
    static let emptySalaryLac = "Please select salary."
    static let emptyCurrentSalary = "Please enter current salary."
    static let emptySalaryThousand = "Please select current salary in thousand."
    static let emptyNoticePeroid = "Please select your notice period duration."
    static let emptyLastWorking =  "Please select your last working day."
    static let emptyDesignation = "Please select your designation."
    static let emptyCurrentSalaryDetail = "Please fill all details for your current salary."
    static let emptyOfferedSalaryDetail = "Please fill all details for your offered salary."
    static let emptyYearOfExpereience = "Select your work experience."
    static let emptyMonthOfExpereience = "Select your work experience."
    static let emptySelectCurrentSalary = "Please select Current Salary."
    static let emptyEnterSalaryLac = "Please enter salary."
    static let emptyWorkOfExpereience = "Select your work experience."
    static let emptyMostRecentDesignation = "Please select your most recent designation."
    static let emptyMostRecentCompanyName = "Please select your most recent company."
    static let lastWorkingDateMinValue = "Last working day should be  greater than or equal to current day."
    static let checkLastWorkingdate = "Check your last working day."

}

struct MIEducationDetailViewControllerConstant  {
    static let title = "Education"
    static let addAnother = "+ Add another"
    static let highestQualification = "Highest Qualification"
    static let specialisation = "Specialization/Major"
    static let instituteName = "University/Institute"
    static let passignYear = "Year of Graduation"
    static let educationType = "Education Type"
    static let board = "Board"
    static let medium = "Medium"
    static let percentage = "Percentage"
    static let search = "Search"
    
    
    //Validation Messages
    static let emptyHighestQualification = "Please select your highest qualification."
    static let emptySpecialisation = "Please select specialization."
    static let emptyInstitueName = "Please select your institute's name."
    static let emptyYear = "Please select year of graduation."
    static let emptyEducationType = "Please select education type."
    static let emptyBoard = "Please select Board."
    static let emptypercentage = "Please enter your percentage/grade."
    static let emptyMedium = "Please select medium."

    
    //API Keys for Qualification
    static let educationDetailsAPIKey = "educationDetails"
    static let textAPIKey = "text"
    static let idAPIKey = "id"
    static let highestQualificationAPIKey = "highestQualification"
    static let specializationAPIKey = "specialization"
    static let collegeAPIKey = "college"
    static let boardAPIKey = "board"
    static let yearOfPassingAPIKey = "yearOfPassing"
    static let educationTypeAPIKey = "educationType"
    static let percentageAPIKey = "percentage"
    static let profileTypeAPIKey = "profileType"
    static let createdAtAPIKey = "createdAt"
    static let updatedAtAPIKey = "updatedAt"
    static let skillsAPIKey = "skills"
    static let skillAPIKey = "skill"
    static let mediumAPIKey = "medium"

    
    

}
struct SectionNameConstant {
    static let jobPerences = "Job Preferences"
    static let itSkill = "IT Skills"
    static let personalDetails = "Personal Details"
    static let languages = "Languages"

    
}
struct PersonalTitleConstant {
    static let homeTown = "Home Town"
    static let PermanentAddress = "Permanent Address"
    static let Gender = "Gender"
    static let PinCode = "Pin Code"
    static let MaritalStatus = "Marital Status"
    static let DOB = "Date Of Birth"
    static let PassportNumber = "Passport Number"
    static let Category = "Category"
    static let USAPermit = "Work Permit for USA"
    static let CountryPermit = "Work Permit for Other Country"
    static let Nationality = "Nationality"
    static let SpeciallAbled = "Speciall Abled"
    static let disabilityType = "Type"
    static let disabilitySubtype = "SubType"
    static let disabilityDetails = "Details"
    static let disabilityDescription = "Description"
    static let disabilityCertificationNo = "Certification No"
    static let disabilityIssueBy = "Issued By"
    static let saveDisability = "Save"
    static let countriesAuthorized = "Countries Where I Am authorized To Work"

    
    //Error Message
    static let hometownEmpty = "Select your home town."
    static let PermanentAddressEmpty = "Permanent address can't be empty."
    static let GenderEmpty = "Select your gender."
    static let PinCodeEmpty = "Pincode can't be empty."
    static let MaritalStatusEmpty = "Select ypur maritial status."
    static let CategoryEmpty = "Select your category."
    static let CountryPermitEmpty = "Select your work permit country."
    static let NationalityEmpty = "Please select your nationality."
    static let dobEmty = "Select your date of birth."
    static let passportNumberEmpty = "Passport number can't be empty."
    static let disabilitytypeEmpty = "Please select speciall abled type."
    static let disabilitysubtypeEmpty = "Please select speciall abled subtype."
    static let disabilitydetailsEmpty = "Please select speciall abled details."
    static let disabilitydescriptionEmpty = "Speciall abled Description can't be empty."
    static let disabilitycertificationNoEmpty = "Speciall abled Certification No can't be empty"
    static let disabilityissueByEmpty = "Speciall abled Issued by can't be empty."
    
   
    
    // Advance Search Keyword
    static let jobKeyword  = "Key skills"
    static let location    = "Locations"
    static let year        = "Work Experience"
    static let salary      = "Current Salary"
    static let industry    = "Industry"
    static let function    = "Function"
    
    
    //Comman keys
    static let dateFormatePattern  = "yyyy-MM-dd"

}
struct GenericErrorMessage {
    static let jobAlreadyApplied = "You have already applied for this job."
}
struct ShareAppURL{
    static let appStoreUrl = "https://itunes.apple.com/in/app/monster-jobs/id525775161?mt=8"
    static let rateAppUrl  = "https://itunes.apple.com/app/id525775161?action=write-review"
}

class WebURl {
    
    class var domain: String? {
        //let predicate = NSPredicate(format: "selected == %@", NSNumber(value: true))
        //let site = CoreDataHelper.getDataForClass(Sites.self, predicate: predicate).first
        
        //return AppDelegate.instance.site?.domain
        
        let domainName = AppDelegate.instance.site?.domain
        let domain = (domainName?.replacingOccurrences(of: "www", with: "") ?? ".monsterindia.com")
        
        switch apiMode {
        case .QA:
            return "qa1" + domain
        case .RFS:
            return "rfs" + domain
        case .Production:
            return "www" + domain
        default:
           return "www.monsterindia.com"
        }

                
    }
    
    class var privacyPolicyUrl: String {
        return "https://" +  (domain ?? "www.monsterindia.com") + "/privacy.html?app=true"
    }
    class var termsConditionsUrl: String {
        return "https://" +  (domain ?? "www.monsterindia.com") + "/terms-of-use.html?app=true"
    }
    class var faqUrl: String {
        return "https://" +  (domain ?? "www.monsterindia.com") + "/24x7/faq.html?app=true"
    }
    
    class var covidUrl: String {
//        let domainForQARFS = (domain?.replacingOccurrences(of: "www", with: "") ?? ".monsterindia.com")
//       
//        if apiMode == .QA {
//            return "https://" + "qa1" + domainForQARFS + "/trex/ios/en/covid-19"
//        } else if apiMode == .RFS {
//            return "https://" + "rfs" + domainForQARFS + "/trex/ios/en/covid-19"
//        } else {
//            return "https://" +  (domain ?? "www.monsterindia.com") + "/trex/ios/en/covid-19"
//        }
        
        return "https://" +  (domain ?? "www.monsterindia.com") + "/trex/ios/en/covid-19"
    }
  
}

enum MISpamMail:String {
 
    case gulfiso        = "SA"
    case hongkongiso  = "HK"
    case singaporeiso   = "SG"
    case indiaiso       = "IN"
    case philipinsISO   = "PH"
    case thailanISO     = "TH"
    case vietnamISO     = "VN"
    case malaysiyaISO   = "MY"
    case indonesiaISO   = "ID"
    
    var spamMail:String {
        let commonMail = "spam@"
        switch self {
        case .gulfiso:
            return "\(commonMail)monstergulf.com"
        case .hongkongiso:
            return "\(commonMail)monster.com.hk"
        case .singaporeiso:
            return "\(commonMail)monster.com.sg"
        case .philipinsISO:
            return "\(commonMail)monster.com.ph"
        case .thailanISO:
            return "\(commonMail)monster.co.th"
        case .vietnamISO:
            return "\(commonMail)monster.com.vn"
        case .malaysiyaISO:
            return "\(commonMail)monster.com.my"
        case .indonesiaISO:
            return "\(commonMail)monster.co.id"
        default:
            return "\(commonMail)monsterindia.com"
        }
    }
}

enum VisaOptionOpen {
    case None
    case VisaTypeSelect
}

enum RegisterVia : String {
    case None = "None"
    case Facebook = "facebook"
    case Google = "google"
    case Apple = "apple"
}

enum SkillCategory:String {
    case NonITSkill = "NonITSkill"
    case ITSkill = "ITSkill"

}
