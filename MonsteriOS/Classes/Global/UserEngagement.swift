//
//  UserEngagement.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 23/09/19.
//  Copyright © 2019 Monster. All rights reserved.
//


class UserEngagementConstant {
    
    var sourceTraffic = UserEngagement.TRAFFIC_DIRECT
    var sourcePage    = UserEngagement.PAGE_DASHBOARD
    var spl = ""
    
    static let instance = UserEngagementConstant()
    
    private init() { }
    
    func reset() {
        sourceTraffic = UserEngagement.TRAFFIC_DIRECT
        sourcePage    = UserEngagement.PAGE_DASHBOARD
        spl = ""
    }
    
    func parseSPLValues(_ str: String) {
        self.spl = str
        
        if (str.count > 3) {
            
            let spl = str[3..<str.count]
            var campaignFor = ""
            var campaignChannel = ""
            for value in UserEngagement.CF_VALUES_ARR {
                if (spl.hasPrefix(value)) {
                    campaignFor = value
                    break
                }
            }
            if !campaignFor.isEmpty {
                for value in UserEngagement.CC_VALUES_ARR {
                    if (spl.hasPrefix(campaignFor + "_" + value)) {
                        campaignChannel = value
                        break
                    }
                }
                if !campaignChannel.isEmpty {
                 self.sourceTraffic = self.mapCFandCC(campaignFor, campaignChannel)
                }
            }
        }
    }

    func mapSourcePage(_ path: String) {
        
        switch path {
        case "search":
            self.sourcePage = UserEngagement.PAGE_SRP
            
        case "job":
            self.sourcePage = UserEngagement.PAGE_JD
            
        case "job-details":
            self.sourcePage = UserEngagement.PAGE_JD
            
        default:
            self.sourcePage    = UserEngagement.PAGE_DASHBOARD
        }

    }
    
    private func mapCFandCC(_ campaignFor: String, _ campaignChannel: String) -> String {
        
        switch (campaignFor + campaignChannel) {
            
        case (UserEngagement.CF_PROFILE_UPDATE + UserEngagement.CC_MANUAL_MAILER),
             (UserEngagement.CF_PROFILE_UPDATE + UserEngagement.CC_AUTO_MAILER):
            return UserEngagement.TRAFFIC_PROFILE_MAILER
            
        case (UserEngagement.CF_ACQ + UserEngagement.CC_AUTO_MAILER),
             (UserEngagement.CF_BRAND + UserEngagement.CC_AUTO_MAILER),
             (UserEngagement.CF_RESUME_UPLOAD + UserEngagement.CC_AUTO_MAILER),
             (UserEngagement.CF_ACQ + UserEngagement.CC_MANUAL_MAILER),
             (UserEngagement.CF_BRAND + UserEngagement.CC_MANUAL_MAILER),
             (UserEngagement.CF_RESUME_UPLOAD + UserEngagement.CC_MANUAL_MAILER),
             (UserEngagement.CF_JOB_APPLY + UserEngagement.CC_MANUAL_MAILER):
            return UserEngagement.TRAFFIC_OTHER_MAILER
            
        case (UserEngagement.CF_JOB_APPLY + UserEngagement.CC_AUTO_MAILER),
             (UserEngagement.CF_JOB_APPLY + UserEngagement.CC_JOB_ALERT),
             (UserEngagement.CF_ACQ + UserEngagement.CC_JOB_ALERT),
             (UserEngagement.CF_BRAND + UserEngagement.CC_JOB_ALERT),
             (UserEngagement.CF_PROFILE_UPDATE + UserEngagement.CC_JOB_ALERT),
             (UserEngagement.CF_RESUME_UPLOAD + UserEngagement.CC_JOB_ALERT):
            return UserEngagement.TRAFFIC_JOB_ALERT_MAILER
            
        default:
            return UserEngagement.TRAFFIC_OTHER_SOURCES
        }
    }
    
    
    
    struct UserEngagement {
        
        static let WORK_EXPERIENCE = "WORK_EXPERIENCE"
        static let DESIGNATION = "DESIGNATION"
        static let UPLOAD_RESUME = "UPLOAD_RESUME"
        static let SKILLS = "SKILLS"
        static let PREFERRED_LOCATION = "PREFERRED_LOCATION"
        static let EDUCATION = "EDUCATION"
        static let VERIFY_MOBILE_NUMBER = "VERIFY_MOBILE_NUMBER"
        
        //TRAFFICS
        static let TRAFFIC_DIRECT = "direct"
        static let TRAFFIC_PROFILE_MAILER = "profile targeted mailer"
        static let TRAFFIC_JOB_ALERT_MAILER = "job alert mailer"
        static let TRAFFIC_OTHER_MAILER = "other mailers"
        static let TRAFFIC_OTHER_SOURCES = "other sources"
        static let TRAFFIC_SEO = "seo"
        static let TRAFFIC_BROWSING = "during browsing"
        
        //PAGES
        static let PAGE_DASHBOARD = "dashboard"
        static let PAGE_SRP = "srp"
        static let PAGE_JD = "jd"
        static let PAGE_HOMEPAGE = "homepage"
        static let PAGE_ANY = "any"
        
        //CAMPAIGN FOR
        static let CF_ACQ = "Acq"
        static let CF_BRAND = "Brand"
        static let CF_PROFILE_UPDATE = "Profile_Update"
        static let CF_RESUME_UPLOAD = "Resume_Upload"
        static let CF_JOB_APPLY = "Job_Apply"
        
        static let CF_VALUES_ARR = [CF_ACQ, CF_BRAND, CF_PROFILE_UPDATE, CF_RESUME_UPLOAD, CF_JOB_APPLY]
        
        //CAMPAIGN CHANNEL
        static let CC_AUTO_MAILER = "Auto_Mailer"
        static let CC_MANUAL_MAILER = "Manual_Mailer"
        static let CC_JOB_ALERT = "Job_Alert"
        static let CC_SEARCH = "Search"
        static let CC_DISPLAY = "Display"
        static let CC_CONTENT = "Content"
        static let CC_SOCIAL = "Social"
        static let CC_JOB_BOARD = "Job_Board"
        static let CC_REMARKETING = "Remarketing"
        
        static let CC_VALUES_ARR = [CC_AUTO_MAILER, CC_CONTENT, CC_DISPLAY, CC_JOB_ALERT, CC_JOB_BOARD, CC_MANUAL_MAILER, CC_REMARKETING, CC_SEARCH, CC_SOCIAL]
    }
    

}


