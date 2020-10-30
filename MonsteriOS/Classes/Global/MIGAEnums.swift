//
//  MIGAEnums.swift
//  MonsteriOS
//
//  Created by Piyush on 18/02/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import Foundation
import UIKit

enum MIGAEnums: String {
    
    case country_action         = "country"
    case register_action        = "register"
    case login_action           = "login"
    case search_action          = "search"
    case forgot_password_action   = "forgot_password"
    case login_cta_action         = "login_cta"
    case login_via_otp_action     = "login_via_otp"
    case social_action            = "social"
    case show_password_action     = "show_password_cta"
    case next_action              = "next"
    case change_action         = "change"
    case resend_otp_action         = "resend_otp"
    case reset_my_password_action         = "reset_my_password"
    case country_code_action         = "country_code"
    case t_c_action         = "t&c"
    case total_experience_action         = "total_experience"
    case already_registered_popup_action         = "already_registered_popup"
    case claim_number_popup_action         = "claim_number_popup"
    case enter_otp_action         = "enter_otp"
    case back_action         = "back"
    case dashboard_action         = "dashboard"
    case track_action         = "track"
    case profile_action         = "profile"
    case upskill_action         = "upskill"
    case more_action         = "more"
  //  case search_action         = "search"
    case upload_your_resume_action         = "upload_your_resume"
    case verify_email_action         = "verify_email"
    case verify_mobile_action         = "verify_mobile"
    case upload_profile_picture_action         = "upload_profile_picture"
    case add_job_preference_action         = "add_job_preference"
    case add_courses_certifications_action         = "add_courses_certifications"
    case update_project_action         = "update_project"
    case jobs_by_category_action         = "jobs_by_category"
    case expert_speaks_action         = "expert_speaks"
    case monster_employment_index_action         = "monster_employment_index"
    case monster_salary_index_action         = "monster_salary_index"
    case be_safe_action         = "be_safe"
    case saved_action         = "saved"
    case network_action         = "network"
    case applied_action         = "applied"
    case settings_action         = "settings"
    case edit_icon_action         = "edit_icon"
    case email_verify_action         = "email_verify"
    case mobile_verify_action         = "mobile_verify"
    case manage_profiles_action         = "manage_profiles"
    case upload_resume_action         = "upload_resume"
    case skills_action         = "skills"
    case it_skills_action         = "it_skills"
    case job_preferences_action         = "job_preferences"
    case work_experiences_action         = "work_experiences"
    case educational_experience_action         = "educational_experience"
    case projects_action         = "projects"
    case courses_certifications_action         = "courses_certifications"
    case personal_details_action         = "personal_details"
    case awards_achievements_action         = "awards_achievements"
    case online_presence_action         = "online_presence"
    case language_known_action         = "language_known"
    case career_services_action         = "career_services"
    case monster_education_action         = "monster_education"
    case career_advice_articles_action         = "career_advice_articles"
    case recommended_jobs_action         = "recommended_jobs"

    

    var category:String {
        switch self {
            case .country_action,
                 .register_action,
                 .login_action,
                 .search_action:
                  return "welcome_screen"
            case .forgot_password_action,
                 .login_cta_action,
                 .login_via_otp_action,
                 .social_action,
                 .show_password_action:
                  return "log_in_screen"
            case .next_action:
                  return "forgot_Password_screen"
            case .change_action,
                 .resend_otp_action,
                 .reset_my_password_action:
                  return "enter_otp_screen"
            case .country_code_action,
                 .upload_resume_action,
                 .t_c_action,
                 .total_experience_action,
                 .already_registered_popup_action,
                 .claim_number_popup_action,
                 .enter_otp_action,
                 .back_action:
                 return "registration_screen"
            case .dashboard_action,
                 .track_action,
                 .profile_action,
                 .upskill_action,
                 .more_action:
                 return "app_footer_screen"
            case .upload_your_resume_action,
                 .verify_email_action,
                 .verify_mobile_action,
                 .upload_profile_picture_action,
                 .add_job_preference_action,
                 .add_courses_certifications_action,
                 .update_project_action,
                 .recommended_jobs_action,
                 .jobs_by_category_action,
                 .expert_speaks_action,
                 .monster_employment_index_action,
                 .monster_salary_index_action,
                 .be_safe_action:
                 return "dashboard_screen"
            case .applied_action,
                 .saved_action,
                 .network_action:
                 return "track_screen"
            case .settings_action,
                 .edit_icon_action,
                 .email_verify_action,
                 .mobile_verify_action,
                 .manage_profiles_action,
                 .skills_action,
                 .it_skills_action,
                 .job_preferences_action,
                 .work_experiences_action,
                 .educational_experience_action,
                 .projects_action,
                 .courses_certifications_action,
                 .personal_details_action,
                 .awards_achievements_action,
                 .online_presence_action,
                 .language_known_action:
                 return "profile_screen"
            case .career_services_action,
                 .monster_education_action,
                 .career_advice_articles_action:
                 return "upskill_screen"
            
            default:
                return ""
        }
    }
}

enum Seeker_Job_Event_Filter : String {
    
    case industries = "Industries"
    case experienceRanges = "Experience Ranges"
    case qualifications = "Qualifications"
    case employerTypes = "Employer Types"
    case functions = "Functions"
    case jobCities = "Job Cities"
    case roles = "Roles"
    case companies = "Companies"
    case salaryRanges = "Salary Ranges"
    case jobTypes = "Job Types"
    case jobFreshness = "Job Freshness"

    var jobskeer_data_filter : String {
        switch self {
        case .industries:
             return CONSTANT_JOB_SEEKER_FILTER.INDUSTRY_FILTER
        case .experienceRanges:
            return CONSTANT_JOB_SEEKER_FILTER.EXPERIENCE_FILTER
        case .qualifications:
            return CONSTANT_JOB_SEEKER_FILTER.QUALIFICATION_FILTER
        case .employerTypes:
            return CONSTANT_JOB_SEEKER_FILTER.EMPLOYER_TYPE_FILTER
        case .functions:
            return CONSTANT_JOB_SEEKER_FILTER.FUNCTION_FILTER
        case .jobCities:
            return CONSTANT_JOB_SEEKER_FILTER.CITY_FILTER
        case .roles:
            return CONSTANT_JOB_SEEKER_FILTER.ROLE_FILTER
        case .companies:
            return CONSTANT_JOB_SEEKER_FILTER.TOP_COMPANIES_FILTER
        case .salaryRanges:
            return CONSTANT_JOB_SEEKER_FILTER.SALARY_FILTER
        case .jobTypes:
            return CONSTANT_JOB_SEEKER_FILTER.JOB_TYPE_FILTER
        case .jobFreshness:
            return CONSTANT_JOB_SEEKER_FILTER.JOB_FRESHNESS_FILTER
        }
    }
}

struct CONSTANT_JOB_SEEKER_FILTER {

    static let FUNCTION_FILTER     = "FUNCTION"
    static let ROLE_FILTER     = "ROLE"
    static let EXPERIENCE_FILTER     = "EXPERIENCE"
    static let CITY_FILTER     = "CITY"
    static let SALARY_FILTER     = "SALARY"
    static let EMPLOYER_TYPE_FILTER     = "EMPLOYER_TYPE"
    static let TOP_COMPANIES_FILTER     = "TOP_COMPANIES"
    static let INDUSTRY_FILTER     = "INDUSTRY"
    static let JOB_FRESHNESS_FILTER     = "JOB_FRESHNESS"
    static let JOB_TYPE_FILTER     = "JOB_TYPE"
    static let QUALIFICATION_FILTER     = "QUALIFICATION"

}

struct CONSTANT_JOB_SEEKER_EVENT_VALUE {
    
    static let LANDING     = "landing"
    static let CLICK     = "click"
    static let CLICK_SUBMIT     = "clickAndSubmit"
    static let CLICK_CHANGE     = "clickAndChange"
    static let CLEAR_ALL     = "clearAll"
    static let SWIPE     = "swipe"
    static let EDIT_PREFERENCES     = "editPreferenecs"
    static let APPLIED              = "applied"
    static let SAVED                = "saved"
    static let NETWORK              = "network"
    static let VIEWALL              = "viewAll"
    static let SIGNOUT              = "signout"
    static let CHANGEPASSWORD       = "changePassword"
    static let CHANGECOUNTRY        = "changeCountry"
    static let NEVER        = "never"
    static let NOTNOW        = "notNow"
    static let OK        = "ok"
    static let CANCEL        = "cancel"
    static let SUBMIT        = "submit"
    
}

struct CONSTANT_JOB_SEEKER_TYPE {
    
    static let SPLASH_SCREEN   = "SPLASH_SCREEN"
    static let CHANGE_COUNTRY   = "CHANGE_COUNTRY"
    static let SEARCH_BAR       = "SEARCH_BAR"
    static let LOGIN            = "LOGIN"
    static let LOGIN_WITH_OTP   = "LOGIN_WITH_OTP"
    static let SOCIAL_LOGIN     = "SOCIAL_LOGIN"
    static let FORGOT_PASSWORD  = "FORGOT_PASSWORD"
    static let REGISTER         = "REGISTER"
    static let REGISTER_PERSONAL = "REGISTER_PERSONAL"
    static let REGISTER_EMPLOYMENT = "REGISTER_EMPLOYMENT"
    static let REGISTER_EDUCATION = "REGISTER_EDUCATION"

    static let SEARCH     = "SEARCH"
    static let SEARCH_BUTTON     = "SEARCH_BUTTON"
    static let SET_ALERT     = "SET_ALERT"
    static let FILTER_APPLY     = "FILTER_APPLY"
    static let APPLY     = "JOB_APPLY"
    static let SAVE_JOB     = "SAVE_JOB"
    static let SAVE_SEARCH     = "SAVE_SEARCH"
    static let NEXT_SCROLL     = "NEXT_SCROLL"
    static let ARE_JOBS_RIGHT     = "ARE_JOBS_RIGHT"
    static let SUGGESTIONS_CLICK     = "SUGGESTIONS_CLICK"
    static let DASHBOARD_LANDING     = "DASHBOARD"
    static let DASHBOARD_SEARCH_BUTTON     = "DASHBOARD_SEARCH_BUTTON"
    static let PENDING_ACTIONS     = "PENDING_ACTIONS"
    static let ADD_LOCATION     = "ADD_LOCATION"
    static let ADVANCED_SEARCH     = "ADVANCED_SEARCH"
    static let CURRENT_LOCATION     = "CURRENT_LOCATION"
    static let RECENT_SEARCHES     = "RECENT_SEARCHES"
    static let JOBS_BY_CATEGORY     = "JOBS_BY_CATEGORY"
    static let VOICE_SEARCH     = "VOICE_SEARCH"
    static let RECOMMENDED_JOBS     = "RECOMMENDED_JOBS"
    static let PREF_LOCATION     = "PREF_LOCATION"
    static let SIMILAR_JOB_APPLY     = "SIMILAR_JOB_APPLY"
    
    static let HOME_PAGE                = "HOMEPAGE"
    static let BENCHMARK_YOURSELF       = "BENCHMARK_YOURSELF"
    static let GLEAC_PAGE               = "GLEAC_PAGE"
    
    static let TRACK_JOB                = "TRACK_JOB"
    static let COMPANIES_FOLLOWED       = "COMPANIES_FOLLOWED"
    static let RECRUITER_FOLLOWED       = "RECRUITER_FOLLOWED"
    static let UPSKILL_SCREEN           = "UPSKILL_SCREEN"
    static let PROFILE_PAGE             = "PROFILE_PAGE"
    static let MORE_SCREEN              = "MORE_SCREEN"
    static let CAREER_SERVICES          = "CAREER_SERVICES"
    static let MONSTER_EDUCATION        = "MONSTER_EDUCATION"
    static let SETTINGS                 = "SETTINGS"
    static let FEEDBACK                 = "FEEDBACK"
    static let SHARE_APP                = "SHARE_APP"
    static let MANAGE_JOB_ALERT         = "MANAGE_JOB_ALERT"
    static let JD_APPLY                 = "JD_APPLY"
    static let SAVED_JOBS               = "SAVED_JOBS"
    static let SHARE_JOB                = "SHARE_JOB"
    static let RATE_YOUR_EXPERIENCE     = "RATE_YOUR_EXPERIENCE"
    static let REGISTER_JOB_PREFERENCE  = "REGISTER_JOB_PREFERENCE"
    static let VIEW_JOB  = "VIEW_JOB"

    
    
}

struct CONSTANT_SCREEN_NAME {
    
    static let SPLASH_SCREEN = "SPLASH_SCREEN"
    static let HOME     = "HOME_SCREEN"
    static let WELCOME  = "WELCOME_SCREEN"
    static let SEARCH   = "SEARCH_SCREEN"
    static let SRP      = "SRP_SCREEN"
    static let FILTER   = "FILTER_SCREEN"
    static let JOBDETAIL = "JOB_DETAIL_SCREEN"
    static let LOGIN     = "LOGIN_SCREEN"
    static let LOGIN_VIA_OTP     = "LOGIN_VIA_OTP_SCREEN"

    static let FORGOT_PASSWORD     = "FORGOT_PASSWORD_SCREEN"
    static let REGISTER_PERSONAL  = "REGISTER_PERSONAL_SCREEN"
    static let REGISTER_EDIT_EMPLOYMENT  = "REGISTER_EDIT_EMPLOYMENT_SCREEN"
    static let TERMS_CONDITION_SCREEN  = "TERMS_CONDITION_SCREEN"
    static let PRIVACY_POLICY_SCREEN  = "PRIVACY_POLICY_SCREEN"

    static let REGISTER_EMPLOYMENT  = "REGISTER_EMPLOYMENT_SCREEN"
    static let EMPLOYMENT  = "EMPLOYMENT_SCREEN"
    static let REGISTER_EDIT_EDUCATION  = "REGISTER_EDIT_EDUCATION_SCREEN"
    static let REGISTER_EDUCATION  = "REGISTER_EDUCATION_SCREEN"
    static let REGISTER_JOB_PREFERENCE  = "REGISTER_JOB_PREFERENCE_SCREEN"
    static let ADDLOCATION  = "ADD_LOCATION_SCREEN"
    static let SPLASH       = "SPLASH_SCREEN"
    static let MANAGEJOBALERT     = "MANAGE_JOB_ALERT_SCREEN"
    static let ADVANCESEARCH      = "ADVANCE_SEARCH_SCREEN"
    static let USER_ENGAGEMENT_PREFERRED_LOCATION      = "USER_ENGAGEMENT_PREFERRED_LOCATION_SCREEN"
    static let USER_ENGAGEMENT_EDUCATION      = "USER_ENGAGEMENT_EDUCATION_SCREEN"
    static let COMPANY_YOU_FOLLOWING       = "COMPANY_YOU_FOLLOWING_SCREEN"
    static let RECRUITERS_YOU_FOLLOWING       = "RECRUITERS_YOU_FOLLOWING_SCREEN"
    static let RECRUITER_DETAIL       = "RECRUITER_DETAIL_SCREEN"
    static let COMPANY_DETAIL       = "COMPANY_DETAIL_SCREEN"
    static let SPEECH_RECOGNITION       = "SPEECH_RECOGNITION_SCREEN"
    //static let REGISTER_EDUCATION_SCREEN  = "REGISTER_EDUCATION_SCREEN"
    static let EDUCATION_SCREEN  = "EDUCATION_SCREEN"
    static let RECOMMENDED_JOBS     = "RECOMMENDED_JOBS_SCREEN"
    static let SIMILAR_JOB     = "SIMILAR_JOB_SCREEN"
    static let APPLIED_ALSO_APPLY_JOB     = "APPLIED_ALSO_APPLY_SCREEN"
    static let MANAGEVIEWJOB     = "MANAGE_VIEW_JOB_SCREEN"
    
    static let GLEAC_BENCHMARK_SCREEN     = "GLEAC_BENCHMARK_SCREEN"
    static let GLEAC_TEST_SCREEN          = "GLEAC_TEST_SCREEN"
    static let GLEAC_VIEW_REPORT_SCREEN   = "GLEAC_VIEW_REPORT_SCREEN"
        
    static let TRACK_SCREEN          = "TRACK_SCREEN"
    static let DASHBOARD             = "DASHBOARD"
    static let UPSKILL_SCREEN        = "UPSKILL_SCREEN"
    static let PROFILE_SCREEN        = "PROFILE_SCREEN"
    static let MORE_SCREEN           = "MORE_SCREEN"
    static let SETTINGS              = "SETTINGS_SCREEN"
    static let CHANGE_COUNTRY        = "CHANGE_COUNTRY_SCREEN"
    static let CHANGE_PASSWORD       = "CHANGE_PASSWORD_SCREEN"
    static let PROFILE_VISIBILITY    = "PROFILE_VISIBILITY_SCREEN"
    static let BLOCK_COMPANIES       = "BLOCK_COMPANIES_SCREEN"
    static let APPLIED_SCREEN        = "APPLIED_SCREEN"
    static let SAVED_SCREEN          = "SAVED_SCREEN"
    static let NETWORK_SCREEN        = "NETWORK_SCREEN"
    static let USER_ENGAGMENT_WORK_EXPERIENCE_SCREEN        = "USER_ENGAGMENT_WORK_EXPERIENCE_SCREEN"
    static let USER_ENGAGMENT_RESUME_SCREEN        = "USER_ENGAGEMENT_UPLOAD_RESUME_SCREEN"

    
}

extension UIViewController {
    var screenName: String {

        
            switch  self {
            case is MIHomeViewController:
                return "HOME_SCREEN"
                //            case "MIPopUpVC":
            //                return "POPUP_SCREEN"
            case is MIVerifyMobilePopupVC:
                return "USER_ENGAGEMENT_VERIFY_MOBILE_SCREEN"
            case is MIViewAllJobsViewController:
                return "SRP_SCREEN"
            case is MITrackCompaniesVC:
                return "TRACK_COMPANIES_SCREEN"
            case is MINonLoginApplyViewController:
                return "NON_LOGIN_APPLY_SCREEN"
            case is MIWalkinVenueViewController:
                return "WALK_IN_VENUE_SCREEN"
            case is MICreateProfileVC :
                return "CREATE_PROFILE_SCREEN"
            case is MISplashViewController:
                return "SPLASH_SCREEN"
            case is MIWebViewViewController:
                return "PRIVACY_POLICY_SCREEN"
            case is MINotificationViewController:
                return "NOTIFICATION_SCREEN"
            case is MINotificationPendingViewController :
                return "NOTIFICATION_PENDING_SCREEN"
            case is MIRecruiterDetailsViewController:
                return "RECRUITER_DETAIL_SCREEN"
            case  is MIFeedbackViewController:
                return "FEEDBACK_SCREEN"
            case is MIRecuiterActionViewController:
                return "RECRUITER_ACTION_SCREEN"
            case is MIManageSubscriptionsViewController:
                return "MANAGE_SUBSCRIPTION_SCREEN"
            case is MISettingMainViewController:
                return "SETTING_SCREEN"
            case is MIMoreTabHomeViewController:
                return "MORE_SCREEN"
            case is MIQuestionnaireViewController:
                return "QUESTIONNAIRE_SCREEN"
            case is MIFilterJobsViewController:
                return "FILTER_SCREEN"
            case is MIAppliedSavedNetworkViewController:
                return "APPLIED_SCREEN"
            case is MISavedJobViewController:
                return "SAVED_SCREEN"
            case is MINetworkJobsViewController:
                return "NETWORK_SCREEN"
            case is MIJobAppliedSuccesViewController:
                return "JOB_APPLIED_SUCCESS_SCREEN"
            case is MIJobDetailsViewController:
                return "JOB_DETAIL_SCREEN"
            case is MICreateJobAlertViewController:
                return "CREATE_JOB_ALERT_SCREEN"
            case is MICreateJobAlertSuccessViewController:
                return "CREATE_JOB_ALERT_SUCCESS_SCREEN"
            case is MIMasterDataSelectionViewController:
                return "MASTER_DATA_SCREEN"
            case is MIResetOTPViewController:
                return "RESET_OTP_SCREEN"
            case is MIOTPViewController:
                return "OTP_SCREEN"
            case is MIProfessionalDetailViewController:
                return "EXPERIENCE_SCREEN"
            case is MILoginViewController:
                return "LOGIN_SCREEN"
            case is MIJobPreferenceVC:
                return "REGISTER_JOB_PREFERENCE_SCREEN"
            case is MIBasicRegisterVC:
                return "REGISTER_PERSONAL_SCREEN"
            case is MIForgotPasswordViewController:
                return "FORGOT_PASSWORD_SCREEN"
            case is MIEducationDetailViewController:
                return "EDUCATION_SCREEN"
            case is MIEducationByUserVC:
                return "REGISTER_EDUCATION_SCREEN"
            case is MIJobPreferenceViewController:
                return "JOB_PREFERENCE_SCREEN"
            case is MIEmploymentDetailViewController:
                return "EMPLOYMENT_SCREEN"
            case is MIEmployementForUserVC:
                return "REGISTER_EMPLOYMENT_SCREEN"
            case is MISkillAddViewController:
                return "SKILL_SCREEN"
            case is MISearchViewController:
                return "SEARCH_SCREEN"
            case is MIAdvanceSearchViewController:
                return "ADVANCE_SEARCH_SCREEN"
            case is MIAdvanceSearchJobViewController:
                return "ADVANCE_SEARCH_KEYWORD_SCREEN"
            case is MIImagePickerViewController:
                return "CUSTOM_GALLERY_SCREEN"
            case is MIUploadResumeViewController:
                return "UPLOAD_RESUME_SCREEN"
            case is MIEditProfileVC:
                return "EDIT_PROFILE_SCREEN"
            case is MISelectExistingProfileViewController:
                return "SELECT_EXISTING_PROFILE_SCREEN"
            case is MIPendingActionViewController:
                return "PEDNING_ACTION_SCREEN"
            case is MIPersonalDetailVC:
                return "PERSONAL_DETAIL_SCREEN"
            case is MIProfileLanguageVC:
                return "LANGUAGE_SCREEN"
            case is MIProfileViewController:
                return "PROFILE_SCREEN"
            case is MIProjectDetailVC:
                return "PROJECT_DETAIL_SCREEN"
            case is MIManageJobAlertVC:
                return "MANAGE_JOB_ALERT_SCREEN"
            case is MISRPJobListingViewController:
                return "SRP_SCREEN"
            case is MIVerifyMailViewController:
                return "VERIFY_MAIL_SCREEN"
            case is MIUpSkillViewController:
                return "UP_SKILL_SCREEN"
            case is MIPopUpSuccessErrorVC:
                return "USER_ENGAGMENT_ERROR_SUCCESS_SCREEN"
            case is MISkillPopUpVC:
                return "USER_ENGAGMENT_SKILL_SCREEN"
            case is MIEmploymentProfileImprovementVC:
                return "USER_ENGAGMENT_EMPLOYMENT_SCREEN"
            case is MIUpdateWorkExp:
                return "USER_ENGAGMENT_WORK_EXPERIENCE_SCREEN"
//            case is MISpeechRecognitionVC:
//                return "SPEECH_RECOGNITION_SCREEN" // Due to iOS 10 case
            case is MIMultiprofileApplyViewController:
                return "MULTIPLE_PROFILE_APPLY_SCREEN"
            case is MIApplyViewController:
                return "APPLY_CHECK_PENDING_ITEM_SCREEN"
            case is MIStaticMasterDataViewController:
                return "STATIC_MASTER_DATA_SCREEN"
            case is MIManageSocialVC:
                return "MANAGE_SOCIAL_SCREEN"
            case is MIDeleteAccountViewController:
                return "DELETE_ACCOUNT_SCREEN"
            case is MIDeactivateAccountViewController:
                return "DEACTIVATE_SCREEN"
            case is MIProfileVisibilityViewController:
                return "PROFILE_VISIBILITY_SCREEN"
            case is MITrackJobsHomeViewController:
                return "TRACK_SCREEN"
            case is MIHomeTabbarViewController:
                return "DASHBOARD_SCREEN"
            case is MICountryCodePickerVC:
                return "COUNTRY_CODE_PICKER_SCREEN"
            case is MILandingViewController:
                return "WELCOME_SCREEN"
            case is MIVerifyEmailTemplateViewController:
                return "VERIFY_EMAIL_TEMPLATE_SCREEN"
            case is MIITSkillsVC:
                return "IT_SKILL_SCREEN"
            case is MIAwardsAchievementVC:
                return "AWARDS_SCREEN"
            case is MIOnlinePresenceVC:
                return "ONLINE_PRESENCE_SCREEN"
            case is MILanguageKnownVC:
                return "LANGUAGE_SCREEN"
            case is MICoursesCertificatinVC:
                return "COURSE_CERTIFICATION_SCREEN"
            case is MIExpertSpeaksVC:
                return "EXPERT_SPEAK_SCREEN"
            case is ThankuRatingPopupVC:
                return "THANK_YOU_RATING_SCREEN"
            case is RatingViewController:
                return "RATING_FEEDBACK_SCREEN"
            case is MIViewJobsAlertViewController:
                 return "VIEW_JOBS_ALERT_SCREEN"
            case is MIEditEmploymentTableViewController:
                 return "REGISTER_EDIT_EMPLOYMENT_SCREEN"
            case is MISearchLocationViewController:
                 return "SEARCH_LOCATION_SCREEN"
            case is RatingPopupVC:
                return "RATING_SCREEN"
            case is MIWorkExperienceVC:
                return "WORK_EXPERIENCE_SCREEN"
            case is MIGleacVC:
                return "GLEAC_BENCHMARK_SCREEN"

            default :
                return ""
            }
    }
   
    
    
}

struct CONSTANT_EXTRA_NAME {
    static let RIGHT_RESUME      = "RIGHT_RESUME"
    static let XPRESS_RESUME     = "XPRESS_RESUME"
    static let CAREER_BOOSTER    = "CAREER_BOOSTER"
    static let SKIP_THIS_STEP    = "click"
    static let VALIDATION_ERROR_MESSAGES    = "validationErrorMessages"
    
}


struct CONSTANT_FIELD_LEVEL_NAME {
    static let VERIFY_MOBILE      = "VERIFY_MOBILE"
    static let VERIFY_EMAIL     = "VERIFY_EMAIL"
    static let KEY_SKILLS    = "KEY_SKILLS"
    static let IT_SKILLS    = "IT_SKILLS"
    static let EDUCATION    = "EDUCATION"
    static let CUR_LOCATION    = "CUR_LOCATION"
    static let TOTAL_WORK_EXP    = "TOTAL_WORK_EXP"
    static let WORK_HISTORY    = "WORK_HISTORY"
    static let CUR_SALARY    = "CUR_SALARY"
    static let CUR_DESIGNATION    = "CUR_DESIGNATION"
    static let NOTICE_PERIOD    = "NOTICE_PERIOD"
    static let PREF_INDUSTRY    = "PREF_INDUSTRY"
    static let PREF_FUNCTION    = "PREF_FUNCTION"
    static let PREF_ROLE    = "PREF_ROLE"
    static let PREF_LOCATION    = "PREF_LOCATION"
    static let EXP_SALARY    = "EXP_SALARY"
    static let OFFERED_SALARY    = "OFFERED_SALARY"
    static let PREF_JOB_TYPE    = "PREF_JOB_TYPE"
    static let PROFILE_TITLE    = "PROFILE_TITLE"
    static let COURES_CERTS    = "COURES_CERTS"
    static let PROJECTS    = "PROJECTS"
    static let NATIONALITY    = "NATIONALITY"
    static let SUMMARY    = "SUMMARY"
    static let LANG_KNOWN    = "LANG_KNOWN"
    static let PROFILE_PHOTO    = "PROFILE_PHOTO"
    static let MOBILE_NUMBER_CHANGED    = "MOBILE_NUMBER_CHANGED"
    static let UPLOAD_RESUME    = "UPLOAD_RESUME"
    static let ADD_MOBILE_NUMBER    = "ADD_MOBILE_NUMBER"


}

//func addGAEnum(enumType:MIGAEnums) {
//    CommonClass.googleEventTrcking(enumType.category, action: enumType.action, label: enumType.rawValue)
//}


