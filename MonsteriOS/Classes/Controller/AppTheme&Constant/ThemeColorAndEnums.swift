//
//  ThemeColorAndEnums.swift
//  MonsteriOS
//
//  Created by ishteyaque on 20/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation
import UIKit.UIColor

//Track Job Type
enum TrackJobsType {
    case applied
    case saved
    case viewed
    case jobAlert
    var value:String{
        switch self{
        case .applied:
            return ControllerTitleConstant.appliedJobs
        case .saved:
            return ControllerTitleConstant.savedJobs
        case .viewed:
            return ControllerTitleConstant.viewedJobs
        case .jobAlert:
            return ControllerTitleConstant.jobAlert
        }
    }
    var apiPath:String{
        switch self {
        case .applied:
           return APIPath.appliedJob
        case .saved:
            return APIPath.savedJob
        case .viewed:
            return APIPath.netwrokJob
        default:
           return APIPath.savedJob
        }
    }
}
//Create Job Alert Controller Constant
struct StoryboardConstant{
    static let createButtonTitle="Create Job Alert"
    static let alertName="Job Alert Name"
    static let alertNamePlaceHolder="Enter a name for this job alert"
    static let keywords="Keywords"
    static let keywordsPlaceHolder="Skills,Designation,Role,Company Name"
    static let desiredLocation="Current Location"
    static let desiredLocationPlaceHolder="Select your current location"
    static let experience="Total Experience"
    static let experiencePlaceHolder="Your total experience as of today"
    static let salary="Min Salary"
    static let funcionalArea="Preferred Function"
    static let funcionalAreaPlaceHolder="Maximum of 2 functions can be selected"
    static let industry="Preferred Industry"
    static let industryPlaceHolder="Maximum of 2 industries can be selected"
    static let role="Preferred Role"
    static let rolePlaceHolder="Maximum of 2 roles can be selected"
    static let titleText="Create free job alerts and never miss out. Get most relevant jobs directly into your inbox"
    static let manageMaxFiveAlert = "You have already created 5 Job Alerts. To continue creating this alert you need to replace an existing alert."
    static let emailId="Email ID"
    static let emailIdPlaceHolder="Enter your Email ID"
    static let frequency="Frequency"
    
  
    
}
enum MasterDataTitle:String, CaseIterable{
    case createButtonTitle="Create Job Alert"
    case alertName="Name of the Alert"
    case keywords="Keywords"
    case desiredLocation="Current Location"
    case experience="Total Experience"
    case salary="Min Salary"
    case funcionalArea="Preferred Function"
    case industry="Preferred Industry"
    case role="Preferred Role"
    case frequency="Frequency"
    case titleText="Let us know your job preferences and we will mail jobs directely to your inbox"
    var funName:String{
        switch self {
        case .keywords:
            return MasterDataType.SKILL.rawValue
        case .funcionalArea:
            return MasterDataType.FUNCTION.rawValue
        case .industry:
            return MasterDataType.INDUSTRY.rawValue
        case .role:
            return MasterDataType.ROLE.rawValue
        case .desiredLocation:
            return MasterDataType.LOCATION.rawValue
        case .experience:
            return MasterDataType.IT_SKILL_EXPERIENCE.rawValue
        case .salary:
            return "Min Salary"
        case .frequency:
            return MasterDataType.JOB_ALERT_FREQUENCY.rawValue
        default:
            return ""
        }
    }
}

// View Controller Title Constant

struct ControllerTitleConstant{
    static let createJobAlert="Create Job Alert"
    static let editJobAlert="Edit Job Alert"
    static let jobDetails="Detail"
    static let trackJobs="Track"
    static let trackJobsTitle = "Track Jobs"
    static let appliedJobs="Applied"
    static let savedJobs="Saved"
    static let viewedJobs="Network"
    static let jobAlert="Manage Job Alerts"
    static let resumeHeadLine="Resume Headline"
    static let uploadResume="Upload your Resume"
    static let photos="Photos"
    static let otp="Enter OTP"
    static let createJobAlertSuccess="Job Alert Created"
    static let updateJobAlertSuccess="Job Alert Updated"
    static let filter="Refine Results"
    static let qestionnaire="Screeing Questionnaire"
    static let moreOption="More"
    static let moreOptions = "More Options" 
    static let settingChangeCountry="Change Country"
    static let changePassword="Change Password"
    static let notification="Notifications"
    static let selectSalary = "Select Salary"
    static let xpressResume = "Xpress Resume+"
    static let technology = "Technology"
    static let iAmInterested = "I am interested"
    static let upSkill       = "Upskill"
    static let upSkillViewCart   = "cart"
    static let deactivate        = "Deactivate"
    static let deleteAccount     = "Delete Account"
    static let jobsNearMe = "Jobs Near Me"
    static let manageProfile = "Manage Profiles"
    static let manageSubscription = "Manage Subscription"
    static let profileVisibility = "Contact Visibility"
    static let onlinePresence = "Online Presence"
    static let notificationPending = "Other Pending Action"

}

//Navigation bar button title
struct NavigationBarButtonTitle {
    static let done="Done"
    static let cancel="Cancel"
    static let skip="Skip"
    static let manage="Manage"
    static let delete="Delete"
    static let clearAll="Clear All"
    static let addMore  = "Add more"
}
enum CreateJobAlertType{
    case create
    case edit
    case fromSRP
    case fromSRPReplace
    var value:String{
        switch self {
        case .create:
            return "Create Job Alert"
        case .edit:
            return "Save Changes"
        case .fromSRP:
            return "Create Job Alert"
        case .fromSRPReplace:
            return "Replace"
        }
    }
}

enum FilterType:String,CaseIterable {
//    case location="Location"
//    case experience="Experience"
//    case salary="Salary"
//    case industry="Industry"
//    case jobType="Job Type"
//    case function="Function"
//    case role="Role"
//    case education="Education"
    //case jobFreshness="Job Freshness"
    case skills = "Skills"
    case salaryRange="SalaryRanges"
    case qualifications="Qualifications"
    case employerTypes="EmployerTypes"
    case functions="Functions"
    case industries="Industries"
    case jobFreshness="JobFreshness"
    case locations="Locations"
    case employmentTypes="EmploymentTypes"
    case jobTypes="JobTypes"
    case experienceRange="ExperienceRanges"
    case none="None"

    var title:String?{
        switch self {
        case .experienceRange:
            return "Experience"
        case .salaryRange:
            return "Salary"
        case .none:
            return ""
        default:
            return self.rawValue
        }
    }
}

struct ChangePasswordStoryBoardConstant{
    static let submit="Submit"
    static let oldPassword="Old Password"
    static let newpassword="New Password"
    static let confirmPassword="Confirm Password"
}

enum MoreOptionViewModelItemType{
    case recruiterActions
    case careerServices
    case monsterEducation
    case articles
    case shareApp
    case settings
    case feedback
    case contactUs
    
    case manageJobAlert
    case rateApp
    case faq
    case updateApp

    var value:String{
        switch self {
            
        case .recruiterActions:
            return "Recruiter Actions"
        case .careerServices:
            return "Career Services"
        case .monsterEducation:
            return "Monster Education"
        case .articles:
            return "Articles"
        case .shareApp:
            return "Share app"
        case .settings:
            return "Settings"
        case .feedback:
            return "Feedback"
        case .contactUs:
            return "Contact Us"
//        case .privacyPolicy:
//            return "Privacy Policy"
//        case .termsCondition:
//            return "Terms & Condition"
        case .manageJobAlert:
            return "Manage Job Alert"
        case .rateApp:
            return "Rate App"
        case .faq:
            return "FAQ"
        case .updateApp:
            return "Update App"
            
        }
    }
}

enum CarrierServices:String,CaseIterable{
    case xpressresume="Xpress Resume"
    case rightResume="Right Resume"
    case careerBooster="Career Booster"
    case resumeHighlighter="Resume Highlighter"
}

enum SettingsMore:String,CaseIterable{
    case profileVisibility="Contact Visibility"
    case managesubscription="Manage Subscription"
    case blockCompanies="Block Companies"
    case changecountry="Change Country"
    case changepassword="Change Password"
    case privacyPolicy="Privacy Policy"
    case termsCondition="Terms & Condition"
    case manageSocial="Manage Social Accounts"
    case signout="Signout"
    
}
struct ProfileVisibiltyConstant{
    static let titleText="By disabling, recruiter will not be able to search your contact details & resume."
    static let noteText="Note: "
    static let bottomTitle="This applies to all of your resumes."
    static let hide="Hide"
    static let show="Show"
}

struct BlockCompanyContant{
    static let title="By using this feature you shall hide your profile (with resume) from all companies you have selected below."
    static let placeHolder="Enter Company Name"
    static let blockButtonTitle="Block"
    static let blockCompaniesList = "Your Block Companies List"
}


struct ManageSubsCellConstant{
    static let title="Which Email Id’s, SMS and Mobile Notification do you want to receive?"
    static let description="Choose the emails,sms and notifications you would like to receive. Please note that you cannot opt out of receiving transactional messages or messages related to payment, security or legal notifications"
    static let email="Email"
    static let sms="SMS"
    static let pushNoti="Push Notification"
    static let footerCellTitle="Not looking for a job change right now"
    static let footerCellDesc="This will stop all communication from Monsterindia and recruiters. Your profile will be completely deactivated for 6 months. But, if you login during this duration, your profile will become active again."
    static let footerCellDeact="Your account will be deactivated for"
    static let footerDropPlaceholder="Select Your Option"
    
    static let readMore =
    """
    Kindly note that the deactivation makes you ineligible to:

    * Login to your 'My Monster' account.

    * Apply to jobs.

    * Receive job alerts via email/SMS.

    * Receive offers or discounts on resume services.

    * Connect with other professionals.

    * Above all, it makes your RESUME invisible to employers

    """
}

struct DeactivateAccount{
    
    static let deactivateTillLogin      = "Deactivate till I login again."
    static let onDeactivating           = "On deactivating, all communication from Monster will stop."
    static let deactivatingMyAccount    = "Deactivating my account till I login to Monster from all platform. I understand that this will completely make my profile invisible to recruiters. I will not hear back from  Monster unless I login again on the platform."
    
}


enum ManageSubscSection:String,CaseIterable {
    
    case recommendedJobs="Recommended Jobs"//"الوظائف التي تم التوصية بها"//
    case jobAlert="Job Alert"
    case communicationfromRecruiter="Communication from Recruiter"
    case appliedjobs="Applied jobs"
    case profileRelated="Profile Related"
    case promotionsandSpecialOffers="Promotions and Special Offers"
}

enum ManageSubscriptionDropDownData:String,CaseIterable {
    
    case daily="Daily"
    case weekly="Weekly"
    case fifteen="Fifteen Days"
    case monthly="Monthly"
}


enum EduCourseDescription : String {
    case courseType = "Course Type: "
    case keywords = "Keywords: "
    case courseProvidedBy = "Course Provider: "

}

enum JobDetailsTitleDescription{
  
    case industry
    case function
    case role
    case expLabel
    var value:String {
        switch self {
        case .industry:
            return "Industry: "
        case .function:
            return "Function: "
        case .role:
            return "Role: "
        case .expLabel:
            return "Levels: "
            
        }
    }
}
struct FollowAndMore {
    
    static let follow="Follow"
    static let moreJobs="  More Jobs  "
    static let postedJob="  Posted Jobs  "
    static let unfollow="Following"
}

struct FeedbackStoryBoardConstant {
    
    static let title="Report a Bug/Abuse"
    static let selectTitle="Problem with site"
    static let dropDownPlaceHolder="Type of Issue"
    static let namePlaceHolder="Name"
    static let phonePlaceHolder="Contact No."
    static let emailPlaceHolder="Email"
    static let emailValidationText="Email will be validated and only used to respond to this inquiry."
    static let detailsTextPlaceHolder="Description of Issue"
    static let uploadImageText="Upload Image"
    static let uploadButtonTitle="Upload"
    static let detailsLabelText="Please include as many details as possible. This can include the URL of the posting, any related emails and their message headers, actions you've already taken,any responses you've received, etc."
    static let submitButtonTitle="Submit"
}

enum RecuiterOrCompany {
    
    case recuiter
    case company
    var name:String{
        switch self{
        case .recuiter:
            return "Recruiter Details"
        case .company:
            return "Company Details"
        }
    }
    var sectionTitle:[String]{
        switch self{
        case .recuiter:
            return ["","Specilaztion","Jobs"]
        case .company:
            return ["","About Company","Active Open Jobs"]
        }
    }
    var jobFilterType:String{
        switch self {
        case .company:
            return SRPListingDictKey.company.rawValue
        case .recuiter:
            return SRPListingDictKey.recruiter.rawValue
        }
    }
    var eventTrack:EventTrackingValue{
        switch self {
        case .company:
            return EventTrackingValue.COMPANY_JOBS
        case .recuiter:
            return EventTrackingValue.RECRUITER_JOBS
        }
    }
}


struct AppTheme {
    
    static let defaultGreenColor = UIColor(hex: 0x14B438)
    static let appGreyColor = UIColor(hex: 0x505050)
    static let defaltBlueColor = UIColor(hex: "0091FF")
    static let viewBackgroundColor=UIColor.init(hex: "f4f6f8")
    static let textColor=UIColor.init(hex: "212b36")
    static let defaltTheme=UIColor.init(hex: "5c4aae")
    static let lightGrayColor = UIColor.init(hex: "8d92a3")
    static let grayColor = UIColor.init(hex: "637381")
    static let placeholderColor = UIColor.init(hex: "6C727C")
    static let errorColor = UIColor.init(red: 255, green: 215, blue: 214)
    static let defaltLightBlueColor =  UIColor(red: 0, green: 145, blue: 255, alpha: 0.3)
    static let greenColor = UIColor.init(hex: "4bca81")
    static let defaltSkyBlueColor = UIColor(hex: "1a95e0")
    static let btnCTAGreenColor = UIColor.init(hex: "14b438")
    static let dimlightGrayColor = UIColor.init(hex: "dfe3e8")

    
}

enum ErrorAndValidationMsg:String {
    
    case title="Error!"
    case emailId="Please enter your email"
    case password="Please enter password. Minimum 6 characters required."
    case validEmail="Please enter a valid e-mail ID."
    case emptyExperienceLevel = "Please select Total experience."
    case passwordless="Password should have a minimum of 6 characters."
    case passwordValid = "Password should be of minimum 6 characters with at least 1 uppercase alphabet, 1 lowercase alphabet, 1 number and 1 special character"
    case name="Please enter your full name."
    case countryNumberCode="Please select country code for mobile number."
    case mobileNumber="Please enter your mobile number."
    case tenDigitMobileNumber="Mobile number should be of 10 digits."
    case validNumber="Please enter a valid mobile number."
    case privacyTerms="Please agree terms and conditions."
    case locationError="Location can't be empty."
    case opps="Oops!.."
    case somethingWrong="Something wrong with your connection, Please try again."
    case noJobFound="No jobs Found"
    case noJobAvailable="No jobs available according to your searching"
    case noAlertJobAvailable="No jobs available according to your job alert"
    case noJobAlert="No Job Alert"
    case createJobAlert="Please add some job alerts, by tapping ‘+’ icon"
    case visaTypeEmpty = "Please select visa type."
    case CurrentLocationError = "Please enter your current location."
    case CurrentCityError = "Please enter your city name."
    case skillEmpty = "Please enter skills. Atleast one skill is required"
    case preferedIndustryEmpty = "Please select preferred industry."
    case preferedFunctionEmpty = "Please select preferred function."


}


struct RegisterViewStoryBoardConstant {
    static let title = "Create your Account"
    static let experienceLevel = "Experience Level"
    static let fullName = "Full Name"
    static let mobileNumber = "Mobile Number"
    static let location = "Location"
    static let email = "Email ID"
    static let password = "Password"
    static let minPassword = "minimum 6 characters"
    static let signUpWith = "Sign up with"
    static let allActiPriv = "All your activities remain private."
    static let countryCode = "+91"
    static let privacyStat = "Privacy Statement,"
    static let terms = "Terms of Use"
    static let visaType = "visaType"
    static let profileTitle = "Profile Title"
    static let workExperience = "Work Experience"
    static let defaultpref = "Default Preferences"
    static let iAgree = "I agree with Monster’s "
    static let and = " and "
    static let register = "Register"
    static let nationality = "Nationality"
    static let uploadPhoto = "Upload New Photo"
    static let salary = "Salary (Annually)"
    static let registerViaManual = "manual"
    static let visaTypeField = "Select Visa Type"
    static let currentLocation="Current Location"
    static let totalExperience="Total Experience"
    static let skills="Key Skills"
    static let fieldSpace = "Field Space"
    static let uploadResume = "Upload Resume"
    static let promotions = "Promotions"
    static let registerAggrement = "By Registering, you agree to our "
    static let termsAndConditions = "Terms and Conditions, "
    static let privacyPolicy = "Privacy Policy "
    static let normalterms = "and default mailer and communications settings governing the use of monsterindia.com "
    static let cityName = "Enter Your City Name"

   

}

enum FlowVia : String {
    case ViaSignUp = "ViaSignUPFlow"
    case ViaProfileEdit  = "ViaProfileFlowEdit"
    case ViaProfileAdd  = "ViaProfileFlowAdd"
    case ViaPendingResume  = "ViaPendingResume"
    case ViaPendingAction  = "ViaPendingAction"
    case ViaRegister = "ViaRegister"
    case ViaJobDetail = "ViaJobDetail"

    var serviceType:ServiceMethod {
        switch self {
        case .ViaProfileAdd:
            return .post
        case .ViaProfileEdit, .ViaRegister, .ViaJobDetail:
            return .put
        default:
            return .post
            
        }
    }
    
    var educationSuccessMessage:String {
        switch self {
        case .ViaProfileAdd:
            return "Education added successfully."
        case .ViaProfileEdit:
            return "Education updated successfully."
        default:
            return "Education added successfully."
        }
    }
    
    var employmentSuccessMessage:String {
        switch self {
        case .ViaProfileAdd:
            return "Employment added successfully."
        case .ViaProfileEdit:
            return "Employment updated successfully."
        default:
            return "Employment added successfully."
        }
    }

    
}


struct  ManageSubscriptions {
    
    static let jobNotification = "Get Job recommendation, job alerts and notifications about your job application"
    static let  recommendedJobs = "Recommended Jobs basis your profile data and activity "
    static let  jobAlert = "Job Alert created by you (3 ALERTS- MANAGE ALERTS)"
    static let  applicationStatus = "Application status update"
    static let  profileRelatedNotification = "Get insights on your profile views and tips on how to improve your profile strength."
    static let  profileViews = "Profile Views"
    static let  improveProfileStrength = "Improve Profile strength"
    static let  recruiterCommunications = "This section includes communication related to job opportunities and messages from recruiter & Job updated from recruiter you are following"
    static let  promotionsAndSpecialOffers = "Receive the latest market information, industry trends, and tips and advice to help you build a successful career."
    static let  careerAdviceAndTips = "Receive communication related to Monster paid services and other related services offered by Monster partner websites."
    static let notLookigforjob = "Not looking for a job change right now"
    static let allCommunications = "This will stop all communication from Monsterindia and recruiters. Your profile will be completely deactivated for 6 months. But, if you login during this duration, your profile will become active again.  Read More"
    static let acDeactivateFor = "Your account will be deactivated for"
    static let saveSubscriptions = "Saved subscriptions notifications details"
    
    static let deactivateAcTitle = "Deactivate Account"
    static let deactivateAc      = "This will stop all communication from Monster and connected recruiters. Your profile will be completely deactivated until you log in again."
    static let deactivateMsg     = "Are you sure you want to deactivate your account? "
    
}

struct ChangePassword {
    static let oldPasswd        = "Enter old password"
    static let newPasswd        = "Enter new password"
    static let confirmPasswd    = "Enter confirm password"
    static let samePasswd       = "Password do not match"
    static let changePasswd     = "Password change successfully"
    static let errorPasswd      = "Failed to update password"
    static let minPasswd        = "Please enter password atleast 6 characters"

}

struct FeedbackSetting {
    
    static let selectIssue        = "Please select Issue"
    static let nameFeedBack       = "Please enter name atleast 3 characters"
    static let nameValidFeedBack  = "Please enter a valid Name"
    static let phoneFeedback      = "Please enter Contact No."
    static let phoneValidFeedback = "Please enter a valid Contact No."
    static let emailFeedback      = "Please enter Email"
    static let emailValidFeedback = "Please enter a valid Email address"
    static let detailsFeedback    = "Please Enter the Description"
    static let feedback           = "feedback Send Successfuly"

}

struct OnlinePresence {
    
    static let profilename       = "Please enter Profile Name"
    static let url               = "Please enter URL"
    static let validurl          = "Please enter valid URL"
    static let description       = "Please enter Description"
    
}

struct AwardAchievement {
    static let title             = "Please enter Title"
    static let date              = "Please select Date"
    static let description       = "Please enter Description"
}

struct CoursesCertifications {
    static let name      = "Please enter Certification Name"
    static let issuer    = "Please enter Certification Issued By"
}

struct ExtraResponse {
   
    static let deleteAlert   = "Are you sure you want to delete this detail ?"
    static let logoutMsg     = "Are you sure you want to signout ?"
    static let blockCompany  = "Select company name"
    static let selectReason  = "Please Select reason"
    static let noInternet    = "No Internet"
    static let unAuthorizedUser    = "Your session has been expired "
    static let resumeUploaded    = "File uploaded successfully. "

    
    
}



enum HomeJobCategoryType:String,CaseIterable{
    case allJobs="All Jobs"
    //case govtJobs="Govt Jobs"
    case contractJobs="Contract Jobs"
    case walkin="Walk-in Jobs"
    case fresherJobs="Fresher Jobs"
    case itJobs="IT Jobs"
    case bpoCustomer="Call Centre/BPO/Customer Service"
    case manufature="Manufacturing/Engineering Jobs"
    case finance="Finance & Account Jobs"
    case sales="Sales/ Business Development Jobs"
    case nearMe="Jobs Near Me"
    
    case workFromHome = "Work From Home"
    case covid19Layoff = "Jobs For Covid-19 Layoffs"
  
    var jobType:JobTypes!{
        switch self{
        case .allJobs:
            return .allJobs
        case .nearMe:
            return .nearBy
        case .contractJobs:
            return .contract
        case .fresherJobs:
            return .fresher
        case .walkin:
            return .walkIn
        case .itJobs:
            return .itJobs
        case .bpoCustomer:
            return .bpo
        case .manufature:
            return .manufacture
        case .finance:
            return .finance
        case .sales:
            return .sales
      
        case .workFromHome:
            return .workFromHome
        case .covid19Layoff:
            return .covid19Layoffs
        }
    }
    
    var jobSeekerJourneyCardName:String {
        switch self{
        case .allJobs:
            return "All_Jobs".uppercased()
        case .nearMe:
            return "Jobs_Near_Me".uppercased()
        case .contractJobs:
            return "Contract_Jobs".uppercased()
        case .fresherJobs:
            return "Fresher_Jobs".uppercased()
        case .walkin:
            return "Walk_in_Jobs".uppercased()
        case .itJobs:
            return "IT_Jobs".uppercased()
        case .bpoCustomer:
            return "Call_Centre_BPO_Customer_Service".uppercased()
        case .manufature:
            return "Manufacturing_Engineering_Jobs".uppercased()
        case .finance:
            return "Finance_&_Account_Jobs".uppercased()
        case .sales:
            return "Sales_Business_Development_Jobs".uppercased()
        
        case .workFromHome:
            return "Work_from_Home".uppercased()
        case .covid19Layoff:
            return "Jobs_for_çovid-19".uppercased()
            
        }
    }
}
enum JobTypes{
    case all
    case allJobs
    case walkIn
    case nearBy
    case contract
    case fresher
    case itJobs
    case bpo
    case manufacture
    case finance
    case sales
    case company
    case recruiter
    case jobAlert
    case workFromHome
    case covid19Layoffs
    
    var value:String{
        switch self {
        case .all:
            return ""
        case .nearBy:
            return ""
        case .walkIn:
            return "WalkIn Job"
        case .contract:
            return "Contract Job"
        case .fresher:
            return "0~1"
        case .allJobs:
            return ""
        case .itJobs:
            return "IT"
        case .bpo:
            return "Call Centre, BPO, Customer Service"
        case .manufacture:
            return "Manufacturing/Engineering/R&D"
        case .finance:
            return "Finance & Accounts"
        case .sales:
            return "Sales"
        case .company:
            return "Company"
        case .recruiter:
            return "Recuiter"
        case .jobAlert:
            return "JobAlert"
        case .workFromHome:
            return "Work From Home"
        case .covid19Layoffs:
            return "Jobs For Covid-19 Layoffs"
            
        }
        
    }
    
    var keyValue:String{
        switch self {
        case .walkIn,.contract:
            return "Job Types"
        case .fresher:
            return "Experience Ranges"
        case .all,.allJobs,.company,.recruiter,.jobAlert:
            return ""
        default:
            return "Functions"
        }
    }
//    var jobSeekerTrackingSourcePageURL:String {
//        switch self {
//        case .all:
//            return "SRP_SCREEN"
//        case .nearBy:
//            return CONSTANT_SCREEN_NAME.HOME
//        case .walkIn:
//            return CONSTANT_SCREEN_NAME.HOME
//        case .contract:
//            return CONSTANT_SCREEN_NAME.HOME
//        case .fresher:
//            return CONSTANT_SCREEN_NAME.HOME
//        case .allJobs:
//            return ""
//        case .itJobs:
//            return CONSTANT_SCREEN_NAME.HOME
//        case .bpo:
//            return CONSTANT_SCREEN_NAME.HOME
//        case .manufacture:
//            return CONSTANT_SCREEN_NAME.HOME
//        case .finance:
//            return CONSTANT_SCREEN_NAME.HOME
//        case .sales:
//            return CONSTANT_SCREEN_NAME.HOME
//        case .company:
//            return CONSTANT_SCREEN_NAME.JOBDETAIL
//        case .recruiter:
//            return CONSTANT_SCREEN_NAME.HOME
//        case .jobAlert:
//            return "JOB_ALERT_SCREEN"
//        }
//    }
    var jobSeekerTrackingDestinationPageURL:String {
        switch self {
        case .all:
            return "SRP_SCREEN"
        case .nearBy:
            return "JOB_NEAR_ME_JOB_SCREEN"
        case .walkIn:
            return "WALK_IN_JOB_SCREEN"
        case .contract:
            return "CONTRACT_JOB_SCREEN"
        case .fresher:
            return "FRESHER_JOB_SCREEN"
        case .allJobs:
            return ""
        case .itJobs:
            return "IT_JOB_SCREEN"
        case .bpo:
            return "CALL_CENTRE_BPO_JOB_SCREEN"
        case .manufacture:
            return "MANUFACTURING_JOB_SCREEN"
        case .finance:
            return "FINANCE_JOB_SCREEN"
        case .sales:
            return "SALES_JOB_SCREEN"
        case .company:
            return "COMPANY_MORE_JOB_SCREEN"
        case .recruiter:
            return "RECRUITER_POSTED_JOBS_SCREEN"
        case .jobAlert:
            return "JOB_ALERT_SCREEN"
      
        case .workFromHome:
            return "Work_From_Home_Screen"
        case .covid19Layoffs:
            return "Jobs For Covid-19 Layoffs_Screen"
        }
    }
    
}
enum SRPListingDictKey:String{
    case query="query"
    case jobTypes="jobTypes"
    case locations="locations"
    case experienceRanges="experienceRanges"
    case functions="functions"
    case company="companyIds"
    case recruiter="recruiterIds"
    case next="start"
    case limits="limit"
    case sort="sort"
    case industries="industries"
    case roles="roles"
    case salary = "salaryRanges"
    case latitude="latitude"
    case longitude="longitude"
    case radius="radius"
    case jobCities="jobCities"

    
}

enum CleverTapSearchKeywords:String,CaseIterable{
    case locations="locations"
    case experienceRanges="experienceRanges"
    case salaryRanges="salaryRanges"
    case roles="roles"
    case industries="industries"
    case query="query"
    case functions="functions"
    
    
    var cleverKey:String{
        switch self {
        case .locations:
            return "search_location"
        case .query:
            return "search_keyword"
        case .experienceRanges:
            return "search_exp"
        case .roles:
            return "search_role"
        case .industries:
            return "search_industry"
        case .salaryRanges:
            return "search_salary"
        case .functions:
            return "search_function"
        }
    }
}

