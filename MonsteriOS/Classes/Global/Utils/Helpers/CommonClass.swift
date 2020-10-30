//
//  CommonClass.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 11/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import UserNotifications
import GoogleSignIn
import FBSDKLoginKit
import Firebase




class CommonClass {
    
    
    static func deleteUserLogs() {
        
        AppDelegate.instance.authInfo = LoginAuth.init(accessToken: "", tokenType: "", expiresIn: nil, scope: nil, jti: nil)
        AppDelegate.instance.userInfo = MIProfilePersonalDetailInfo(dictionary: [:])
         
        for type in AppUserDefaults.Key.allCases {
            switch type {
            case  .SelectedSite, .SplashData, .PreviousCountry, .APIModeSelection:
                //Not to delete these
                break
            default:
                UserDefaults.standard.removeObject(forKey: type.rawValue)
            }
        }
        UserDefaults.standard.synchronize()
        // AppUserDefaults.removeValue(forKey: .UserData)
        // AppUserDefaults.removeValue(forKey: .LaunchCount)
        // AppUserDefaults.removeValue(forKey: .ProfileProgress)
        // AppUserDefaults.removeValue(forKey: .RatingSubmitted)
        // AppUserDefaults.removeValue(forKey: .AuthenticationInfo)
        
        GIDSignIn.sharedInstance()?.signOut()
        FBSDKAccessToken.setCurrent(nil)
        sessionId = ""
        MICookieHelper.clearCustomCookies()

        //AppUserDefaults.removeAllValues()
        MIFirebaseRemoteConfigInfo.getFirebaseRemoteConfigData()
        
    }
    
    static func selectCountry(for isoCode: String) {
     
        if let index = AppDelegate.instance.splashModel.sites.firstIndex(where: { $0.defaultCountryDetails.isoCode == isoCode }) {
            AppDelegate.instance.splashModel.sites[index].selected = true
            AppDelegate.instance.site = AppDelegate.instance.splashModel.sites[index]
            
            AppDelegate.instance.splashModel.commit()
            AppDelegate.instance.site?.commit()
            
            NotificationCenter.default.post(name: .CountryChanged, object: nil, userInfo: nil)
        }
        
    }
    
    @discardableResult
    static func checkForLogin() -> Bool {
       
        var status = false
        var viewController: UIViewController?
        
        if let authData = AppUserDefaults.value(forKey: .AuthenticationInfo, fallBackValue: "").stringValue.data(using: .utf8),
            let authInfo = try? JSONDecoder().decode(LoginAuth.self, from: authData) {
          //  JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.SPLASH)

            AppDelegate.instance.authInfo = authInfo
            //let userDict = AppUserDefaults.value(forKey: .UserData, fallBackValue: [:]).dictionaryObject ?? [:]
            let userDict = AppUserDefaults.unArchivedValue(forKey: .UserData) as? JSONDICT ?? [:]
            AppDelegate.instance.userInfo = MIProfilePersonalDetailInfo(dictionary: userDict)
            viewController = MIHomeTabbarViewController()
            
            status = true
        } else {
            UIApplication.shared.applicationIconBadgeNumber = 0
            AppDelegate.instance.authInfo = LoginAuth.init(accessToken: "", tokenType: "", expiresIn: nil, scope: nil, jti: nil)
            
            let rootVc = MISplashViewController()
            viewController = MINavigationViewController(rootViewController:rootVc)
            
            status = false
        }
        AppDelegate.instance.window?.rootViewController = viewController
        AppDelegate.instance.window?.makeKeyAndVisible()
        
        return status
    }
    
    static func isLoggedin() -> Bool {
        if let authData = AppUserDefaults.value(forKey: .AuthenticationInfo, fallBackValue: "").stringValue.data(using: .utf8),
            let _ = try? JSONDecoder().decode(LoginAuth.self, from: authData) {
            return true
        } else {
            AppDelegate.instance.authInfo = LoginAuth.init(accessToken: "", tokenType: "", expiresIn: nil, scope: nil, jti: nil)
            return false
        }
    }
    
    static func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            UNUserNotificationCenter.current().delegate = AppDelegate.instance
            
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                // Enable or disable features based on authorization.
            }
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        UIApplication.shared.registerForRemoteNotifications()
    }
}




extension CommonClass {
    
    class func googleAnalyticsScreen(_ delegate: Any) {
        
        var screenName : String = ""
        
        switch delegate {
            
        case is MILandingViewController:
            screenName = "Splash"
        case is MIBasicRegisterVC:
            screenName = "SignUp"
        case is MILoginViewController:
            screenName = "Sign_In_iOS"
        case is MIHomeViewController:
            screenName = "Home"
        case is MIOTPViewController:
            screenName = "OTP"
        case is MIProfileViewController:
            screenName = "SetProfile"
        case is MIUploadResumeViewController:
            screenName = "Upload resume"
        case is MIProfileViewController:
            screenName = "My_Profile"
        case is MITrackJobsHomeViewController:
            screenName = "Track jobs"
        case is MIJobDetailsViewController:
            screenName = "Job_Description_iOS"
        case is MISearchViewController:
            screenName = "Search_Job_iOS"
        case is MIFilterJobsViewController:
            screenName = "Filter"
        case is MISettingHomeViewController:
            screenName = "Settings"
        case is MIProfileVisibilityViewController:
            screenName = "ProfileVisibility"
        case is MIManageJobAlertVC:
            screenName = "Manage job alert"
        case is MIJobPreferenceViewController:
            screenName = "Job preference"
        case is MIManageSubscriptionsViewController:
            screenName = "ManageSubscription"
        case is MIChangeCountryView:
            screenName = "ChangeCountry"
        case is MIChangePasswordView:
            screenName = "Change password"
        case is MIForgotPasswordViewController:
            screenName = "ForgotPassword"
        case is MIEditProfileVC:
            screenName = "Edit profile"
        case is MIEmploymentDetailViewController:
            screenName = "EditWorkExperience"
        case is MIAwardsAchievementVC:
            screenName = "Awards achievement"
        case is MIBlockCompanyVIew:
            screenName = "Block companies"
        case is MIFeedbackViewController:
            screenName = "Feedback"
       case is MICoursesCertificatinVC:
            screenName = "Courses certification"
        case is MIEducationDetailViewController:
            screenName = "signup_education"

        case is MISRPJobListingViewController:
           
            if let srpvc = delegate as? MISRPJobListingViewController {
                if srpvc.jobTypes == JobTypes.walkIn {
                    screenName = "Walkin_iOS"
                } else if srpvc.jobTypes == JobTypes.nearBy {
                    screenName = "NearbyJobs"
                } else if srpvc.jobTypes == JobTypes.recruiter {
                    screenName = "Recruiter"
                } else if srpvc.jobTypes == JobTypes.contract {
                    screenName = "Contract_Jobs"
                } else if srpvc.jobTypes == JobTypes.all {
                    screenName = "Job Listing"
                }

            }
        case is MIProfessionalDetailViewController:
            screenName = "signup_register"

        default: break
            
        }
        
        
        Analytics.setScreenName(screenName, screenClass: String(describing: type(of: delegate)))
    }
    
    class func googleEventTrcking(_ category: String, action: String, label: String) {
        
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            "EventCategory": category,
            "EventAction": action,
            "EventLabel": label
            ])

    }
    
    class func predefinedLogIn(_ method: String){
        Analytics.logEvent(AnalyticsEventLogin, parameters: [ AnalyticsParameterMethod: method ])
    }
    
    class func predefinedViewSearchResult(_ searchTerm: String) {
        Analytics.logEvent(AnalyticsEventViewSearchResults, parameters: [ AnalyticsParameterSearchTerm: searchTerm ])
    }
    
    class func predefinedViewTerm(_ itemId: String, itemLocationId: String) {
        Analytics.logEvent(AnalyticsEventViewItem, parameters: [
        AnalyticsParameterItemID: itemId,
        AnalyticsParameterItemLocationID: itemLocationId
        ])
    }
    
    class func predefinedGenerateLead(_ value: String, currency: String ) {
        Analytics.logEvent(AnalyticsEventGenerateLead, parameters: [
            AnalyticsParameterValue: value, 
            AnalyticsParameterCurrency: currency
        ])
    }
    
    
    class func predefinedViewItemList(_ itemCategory: String) {
        Analytics.logEvent(AnalyticsEventViewItemList, parameters: [ AnalyticsParameterItemCategory: itemCategory ])
    }

   
}


extension CommonClass {
    
    class var showOCR: Bool {
        return AppDelegate.instance.site?.siteProps.filter({ $0.name == "showOcr2" }).first?.value.bool ?? false
    }
    
    class var enableResumeParse: Bool {
        return AppDelegate.instance.site?.siteProps.filter({ $0.name == "parseResumeEnable" }).first?.value.bool ?? false
    }
    
    class var showSocialLogin: Bool {
        return true//AppDelegate.instance.site?.siteProps.filter({ $0.name == "enable_social_login2" }).first?.value.bool ?? false
    }
        
    class var deleteProfilePic: Bool {
        return AppDelegate.instance.site?.siteProps.filter({ $0.name == "enable_delete_profile_image" }).first?.value.bool ?? false
    }
    
    class var enableVoiceSearch: Bool {
        return AppDelegate.instance.site?.siteProps.filter({ $0.name == "enableVoiceSearch" }).first?.value.bool ?? false
    }
    
    class var starRatingValue: Int {
        return AppDelegate.instance.site?.siteProps.filter({ $0.name == "star_rating_playstore" }).first?.value.parseInt ?? 5
    }
    
    class var forceUpdateInfo: ForceUpdate? {
        guard let data = AppDelegate.instance.site?.siteProps.filter({ $0.name == "forceUpdate" }).first?.value.data(using: .utf8) else { return nil }
        guard let info = try? JSONDecoder().decode(ForceUpdate.self, from: data) else { return nil }
        
        return info
    }
    
    class var minimumRatingDaysForJobApply: Int {
        let days = AppDelegate.instance.site?.siteProps.filter({ $0.name == "minimumRatingDaysForJobApply" }).first?.value.parseInt ?? 14
        return days
    }

    class var maximumRatingDaysForJobApply: Int {
        let days = AppDelegate.instance.site?.siteProps.filter({ $0.name == "maximumRatingDaysForJobApply" }).first?.value.parseInt ?? 30
        return days
    }
    
    class var minimumRatingDaysForAppShare: Int {
        let days = AppDelegate.instance.site?.siteProps.filter({ $0.name == "minimumRatingDaysForAppShare" }).first?.value.parseInt ?? 14
        return days
    }

    class var maximumRatingDaysForAppShare: Int {
        let days = AppDelegate.instance.site?.siteProps.filter({ $0.name == "maximumRatingDaysForAppShare" }).first?.value.parseInt ?? 30
        return days
    }
    
    class var minimumRatingDaysForJobShare: Int {
        let days = AppDelegate.instance.site?.siteProps.filter({ $0.name == "minimumRatingDaysForJobShare" }).first?.value.parseInt ?? 14
        return days
    }

    class var maximumRatingDaysForJobShare: Int {
        let days = AppDelegate.instance.site?.siteProps.filter({ $0.name == "maximumRatingDaysForJobShare" }).first?.value.parseInt ?? 30
        return days
    }
    

    class var minimumJobAppliesForRating: Int {
        let count = AppDelegate.instance.site?.siteProps.filter({ $0.name == "minimumJobAppliesForRating" }).first?.value.parseInt ?? 2
        return count
    }

    class var ratingFeedbacks: [String] {
        let feedback = AppDelegate.instance.site?.siteProps.filter({ $0.name == "ratingFeedbacks" }).first?.value.components(separatedBy: ", ")
        return feedback ?? []
    }
    
    class var matchingSkillPercentageForJD: Int {
        let percentage = AppDelegate.instance.site?.siteProps.filter({ $0.name == "matchingSkillPercentageForJD" }).first?.value.parseInt ?? 40
        return percentage
    }
    
    class var isTracking: Bool {
        return true
    }

    class var allDomains: [String] {
        return AppDelegate.instance.splashModel.sites.map({ $0.domain.replacingOccurrences(of: "www", with: "") })
    }
    
    class var covidFlagMobile: Bool {
        return AppDelegate.instance.site?.siteProps.filter({ $0.name == "covidFlagMobile" }).first?.value.bool ?? false
    }

}


