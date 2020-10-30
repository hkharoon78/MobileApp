//
//  AppDelegate.swift
//  MonsterIndia
//
//  Created by Monster on 11/10/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import StoreKit
import CoreData
import DropDown
import SwiftyJSON
import GoogleSignIn
import UserNotifications
import Fabric
import Crashlytics
import FBSDKCoreKit
import Firebase

//TODO:- Heighly Focus, When Releasing to AppStore, Make it Equivalent to Appstore Release
//MARK:- To check version Comparison
var CurrentAppVersion = "5.0.16"


@UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var deviceToken = ""
    var authInfo: LoginAuth!
    var site: Site?
    var splashModel: SplashModel = SplashModel.blankInit()
    
    var userInfo = MIProfilePersonalDetailInfo(dictionary: [:])
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        // AKDeviceConsole.startService()
        
        AppDelegate.instance.initializeFBSDK(site)
        JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.SPLASH_SCREEN)

        UIApplication.shared.applicationIconBadgeNumber = 0
        NewRelic.start(withApplicationToken:kNewRelicApplicationToken)
        NewRelic.enableCrashReporting(true)
        NRLogger.setLogLevels(NRLogLevelNone.rawValue)
        
        GIDSignIn.sharedInstance().clientID = kGmailClientId

        Fabric.with([Crashlytics.self]) //Fabric Initialization
        Crashlytics.sharedInstance().debugMode = true

        let gai: GAI? = GAI.sharedInstance()
        gai?.tracker(withTrackingId: googleAnalyticsTrackingId)
        gai?.trackUncaughtExceptions = true
        gai?.logger.logLevel = .verbose
        
        MIApiManager.getSesssionIDAPI()
        
        FirebaseApp.configure()
        MIFirebaseRemoteConfigInfo.getFirebaseRemoteConfigData()
        Messaging.messaging().delegate = self
 
        DropDown.startListeningToKeyboard()
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = AppTheme.viewBackgroundColor
        
        CommonClass.registerForRemoteNotification()
        MIAppLocationManager.locationManagerSharedInstance.appStartUpdatingLocation()
        
        if
            let data = AppUserDefaults.unArchivedValue(forKey: .SplashData) as? String,
            let d = data.data(using: .utf8) {
            let splash = try? JSONDecoder().decode(SplashModel.self, from: d)
            self.splashModel = splash ?? SplashModel.blankInit()
        }
        if
            let data = AppUserDefaults.unArchivedValue(forKey: .SelectedSite) as? String,
            let d = data.data(using: .utf8) {
            self.site = try? JSONDecoder().decode(Site.self, from: d)

            let iso = self.site?.defaultCountryDetails.isoCode ?? ""
            let oldIso = AppUserDefaults.value(forKey: .PreviousCountry, fallBackValue: "").stringValue
            
            if oldIso != iso && oldIso != "" {
                CommonClass.selectCountry(for: oldIso)
            }
        }
        
        if site != nil {
            CommonClass.checkForLogin()
        }
    
                 
        return true
    }
    
    func initializeFBSDK(_ site: Site?) {
        switch site?.context {
        case "rexmonster":
            FBSDKSettings.setAppID("2202822979737806")
        case "monstergulf":
            FBSDKSettings.setAppID("776627922732996")
        case "monstersingapore":
            FBSDKSettings.setAppID("2321740241404008")
        case "monsterthailand":
            FBSDKSettings.setAppID("434863447348842")
        case "monsterphilippines":
            FBSDKSettings.setAppID("422628918571957")
        case "monstervietnam":
            FBSDKSettings.setAppID("629624047504556")
        case "monstermalaysia":
            FBSDKSettings.setAppID("688558738251762")
        case "monsterindonesia":
            FBSDKSettings.setAppID("301538607398265")
        case "monsterhongkong":
            FBSDKSettings.setAppID("2402443739779164")
        default:
            FBSDKSettings.setAppID("2202822979737806")
        }
    }

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        self.deviceToken = token
        NSLog("Device Token:- \( token )")
        //CleverTap.sharedInstance()?.setPushToken(deviceToken)
         Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        printDebug("i am not available in simulator \n \(error)")
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        if let url = userActivity.webpageURL,
            userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            self.handleUniversalLinks(url)
        }
//        https://www.monsterindia.com/search/java-jobs-in-noida
//        https://www.monsterindia.com/search/java-jobs
//        https://www.monsterindia.com/search/jobs-in-noida
//        https://www.monsterindia.com/search/strawberry-infotech-private-limited-100524-jobs-career
//        https://www.monsterindia.com/job/php-developer-bhopal-location-immediate-joiner-preferred-strawberry-infotech-private-limited-bhopal-568579
        
        /*
         View job : https://www.monsterindia.com/seeker/job-details?id=<job_id>
         Job apply : https://www.monsterindia.com/seeker/job-details?id=<job_id>&autoApply=true   Login Popup
         Set job alert : https://my.monster.com.vn/create-free-job-alert.html //Login
         Update job alert : https://www.monsterindia.com/seeker/job-alerts?id=<job_alert_id>  //Login
         Register now : https://www.monsterindia.com/seeker/registration
         Registration : https://www.monsterindia.com/seeker/registration
         Update profile:  https://www.monsterindia.com/seeker/profile   //Login
         Edit job preference : https://www.monsterindia.com/seeker/profile       //Login


         View all jobs : https://www.monsterindia.com/search/results?query=
         

//Discussion Required
         Job alert feedback :  //Login
                https://www.monsterindia.com/seeker/jobalert-feedback?response=yes/no&id=
         Verify email : https://www.monsterindia.com/rio/api/public/users/v1/verify-email/e0041f78-5eaf-4596-8e0a-f413f7928fe5/dGVzdGRlZXBzaGlraGExNkB5b3BtYWlsLmNvbQ==

         */
        return false
    }
    
    func handleUniversalLinks(_ url: URL) {
        
        var path = url.pathComponents.filter({ $0 != "/" }).first ?? ""
        if path == "seeker" {
            path = url.pathComponents.filter({ $0 != "/" }).last ?? ""
        }
    
        MIAPIClient.sharedClient.validiateSEO(["url": url.absoluteString]) { (result, error, status) in
            guard let data = result else { return }
            DispatchQueue.main.async {
                self.handleDeepLinkNavigation(path, url: url.absoluteString, data: data)
            }
        }
        
        if let spl = self.getQueryStringParameter(url: url.absoluteString, param: "spl") {
            UserEngagementConstant.instance.parseSPLValues(spl)
            UserEngagementConstant.instance.mapSourcePage(path)

            canCallCardAPI = true
            NotificationCenter.default.post(name: NSNotification.Name.userEngagementSPL, object: nil)
        } else {
            UserEngagementConstant.instance.reset()
        }
    }
    
    func handleDeepLinkNavigation(_ `case`: String, url: String, data: Any?) {
        
        var navigation: MINavigationViewController?
        var tabbar: MIHomeTabbarViewController?
        if CommonClass.isLoggedin() {
            tabbar = (self.window?.rootViewController as? MIHomeTabbarViewController) ?? (self.window?.rootViewController?.presentedViewController?.presentedViewController as? MIHomeTabbarViewController)
            tabbar?.presentedViewController?.dismiss(animated: false, completion: nil)
            tabbar?.selectedIndex = 0
            navigation = tabbar?.viewControllers?[tabbar!.selectedIndex] as? MINavigationViewController
        } else {
            navigation = self.window?.rootViewController?.presentedViewController as? MINavigationViewController
            navigation?.presentedViewController?.dismiss(animated: false, completion: nil)
        }
        
        switch `case` {
        case "search":
            if let dict = data as? JSONDICT {
                //SRP In case of Query
                let jobListing=MISRPJobListingViewController()
                jobListing.selectedSkills = dict["query"] as? String ?? ""
                
                if let locations = dict["locations"] as? [String] {
                    jobListing.selectedLocation = locations.joined(separator: ",")
                    jobListing.jobTypes = .all
                }
                if let companyIds = dict["companyIds"] as? [Int] {
                    jobListing.jobTypes = .company
                    jobListing.companyIds = companyIds
                }
                
                navigation?.popToRootViewController(animated: false)
                navigation?.pushViewController(jobListing, animated: true)
            }
            
        case "job":
            guard
                let dict = data as? JSONDICT,
                let jobId = (dict["jobIds"] as? [Int])?.first?.stringValue
            else { return }
            
            let vc=MIJobDetailsViewController()
            vc.jobId = jobId
            navigation?.pushViewController(vc, animated: true)
            
        case "create-free-job-alert.html", "job-alerts":
            guard CommonClass.isLoggedin() else {
                let vc = MICreateJobAlertViewController()
                vc.jobAlertType = .create
                navigateVc = vc
                navigateAction = .deepUrlCreateAlert
                 if let id = self.getQueryStringParameter(url: url, param: "id") {
                navigateJobId = id
                }
                guard navigation?.viewControllers.last is MILoginViewController else {
                    let vc1 = MILoginViewController.newInstance
                    navigation?.pushViewController(vc1, animated: true)
                    return
                }
                return
            }
            
            tabbar?.selectedIndex = 4
            navigation = tabbar?.viewControllers?[4] as? MINavigationViewController


            if let id = self.getQueryStringParameter(url: url, param: "id") {
                if id.isEmpty {
                    let jobAlertVc=MIManageJobAlertVC()
                    navigation?.pushViewController(jobAlertVc, animated: true)
                } else {
                    MIAPIClient.sharedClient.load(path: APIPath.getJobAlert + "/" + id, method: .get, params: [:]) { (response, error, errorCode) in
                        if error == nil{
                            if let jsonData=response as? [String:Any]{
                                
                                let jobAlertModel=JobAlertModelDataWithMaster(dictionary: jsonData as NSDictionary)
                                DispatchQueue.main.async {
                                    let vc = MICreateJobAlertViewController()

                                    if jobAlertModel != nil {
                                        vc.jobAlertType = .edit
                                        vc.modelData = JobAlertModel(model:jobAlertModel!)
                                    }
                                    navigation?.pushViewController(vc, animated: true)
                                }
                            }
                        }
                    }
                }
            } else {
                let vc = MICreateJobAlertViewController()
                vc.jobAlertType = .create
                navigation?.pushViewController(vc, animated: true)
            }
            
        case "job-details":
            guard let id = self.getQueryStringParameter(url: url, param: "id") else { return }

            let vc=MIJobDetailsViewController()
            vc.jobId = id
            vc.autoApply = ( self.getQueryStringParameter(url: url, param: "autoApply") == "true" )
            navigation?.pushViewController(vc, animated: true)
            
        case "registration":
            if CommonClass.isLoggedin() { return }
            
            let vc = MIBasicRegisterVC()
            navigation?.pushViewController(vc, animated: true)

        case "profile":
            guard CommonClass.isLoggedin() else {
                navigateVc=MIProfileViewController()
                navigateAction = .deepProfileUrl
                
                guard navigation?.viewControllers.last is MILoginViewController else {
                    let vc = MILoginViewController.newInstance
                    navigation?.pushViewController(vc, animated: true)
                    return
                }
                
                return
            }

            tabbar?.selectedIndex = 2
            (tabbar?.viewControllers?[2] as? MINavigationViewController)?.popToRootViewController(animated: true)
            
        default:
            guard let u = URL(string: url) else { return }
            UIApplication.shared.open(u)
        }
        
    }
    
    //Called when a notification is delivered to a foreground app.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    //Called on Tap of Notification:
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
      // CleverTap.sharedInstance()?.handleNotification(withData: response.notification.request.content.userInfo)

        let userInfo = response.notification.request.content.userInfo
        printDebug(userInfo)
        let pushData = JSON(userInfo)["aps"]
        

     //   let deepLinkId = JSON(userInfo)["wzrk_acct_id"]
        
        self.handlePushNotification(userInfo, openViaDidReceive:true)


        UIApplication.shared.applicationIconBadgeNumber = 0
        
        switch UIApplication.shared.applicationState {
        case .active:
            //Notify App On Receiving Push
          
            //  self.handlePushNotification(userInfo, openViaDidReceive:true)
            break
        case .inactive:
           // self.handlePushNotification(userInfo, openViaDidReceive:true)
            break
        default: break
        }
      //  self.handlePushNotification(pushData)
        completionHandler()
    }
    func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
    //Received in Foreground:
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        defer { completionHandler(.noData) }
        
       // CleverTap.sharedInstance()?.handleNotification(withData: userInfo)
        printDebug(userInfo)
        //let pushData = JSON(userInfo)["aps"]
    }
    
    private func handlePushNotification(_ payload: [AnyHashable:Any],openViaDidReceive:Bool) {
        //Handle Push
        
        if let deeplinkUrl = payload["wzrk_dl"] as? String {
            
            if let id = self.getQueryStringParameter(url: deeplinkUrl, param: "jobid") {
               
                if let tabbar = self.window?.rootViewController as? MIHomeTabbarViewController {
                   // tabbar.selectedIndex = 0
                    if let presentVC  = tabbar.presentedViewController {
                        presentVC.dismiss(animated: false, completion: nil)
                    }
                    self.pushJobDetail(tabbar: tabbar, jobID: id)
                }
            }
        }
        
    }
    
    func pushJobDetail(tabbar:MIHomeTabbarViewController,jobID:String) {
        
        if let nav=tabbar.viewControllers?[tabbar.selectedIndex] as? MINavigationViewController {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                let jobdetailVC = MIJobDetailsViewController()
                jobdetailVC.jobId = jobID
                jobdetailVC.referralUrl = .NOTIFICATION
                nav.pushViewController(jobdetailVC, animated: true)
            }
            
        }

    }
    
    func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
       // CleverTap.sharedInstance()?.handleOpen(url, sourceApplication: nil)
        
        guard url.scheme == "monsterseeker" else {
            return GIDSignIn.sharedInstance().handle(url as URL?,
                                                     sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        }
        
        if let tabbar = self.window?.rootViewController as? MIHomeTabbarViewController{
            self.handleDeeplinkingURL(tabbar: tabbar, url: url)
        }else {
            return true
        }
        return true
    }
    
    func handleDeeplinkingURL(tabbar:MIHomeTabbarViewController,url:URL){
        
        if let presentVC  = tabbar.presentedViewController {
            presentVC.dismiss(animated: false, completion: nil)
        }
        
        switch url.path.lowercased() {
        case "/home/home":
            tabbar.selectedIndex = 0
            //Already Set because of new stack
            break
            
        case "/home/trackjobs":
            tabbar.selectedIndex = 1
            
        case "/home/profile":
            tabbar.selectedIndex = 2
            
        case "/home/upskill":
            tabbar.selectedIndex = 3
            
        case "/home/more":
            tabbar.selectedIndex = 4
            
        case "/home/managejobalert":
            tabbar.selectedIndex = 4
            (tabbar.viewControllers?[4] as? UINavigationController)?
                .pushViewController(MIManageJobAlertVC(), animated: true)
            
        case "/home/createjobalert":
            tabbar.selectedIndex = 4
            let vc = MIManageJobAlertVC()
            (tabbar.viewControllers?[4] as? UINavigationController)?
                .pushViewController(vc, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                vc.createButtonAction()
            }
            
        case "/home/profilevisibility":
            tabbar.selectedIndex = 4
            let vc = MIProfileVisibilityViewController()
            (tabbar.viewControllers?[4] as? UINavigationController)?
                .pushViewController(vc, animated: true)
            
        case "/home/managesubscription":
            tabbar.selectedIndex = 4
            let vc = MIManageSubscriptionsViewController()
            (tabbar.viewControllers?[4] as? UINavigationController)?
                .pushViewController(vc, animated: true)
            
        case "/home/blockcompanies":
            tabbar.selectedIndex = 4
            let vc=MISettingHomeViewController()
            vc.selectedSettingType = .blockCompanies
            (tabbar.viewControllers?[4] as? UINavigationController)?
                .pushViewController(vc, animated: true)
            
        case "/home/uploadresume":
            tabbar.selectedIndex = 2
            let vc = MIUploadResumeViewController()
            vc.flowVia = .ViaPendingResume
            (tabbar.viewControllers?[2] as? UINavigationController)?
                .pushViewController(vc, animated: true)
            
        case "/home/editprimarypage":
            tabbar.selectedIndex = 2
            guard let profileVC = (tabbar.viewControllers?[2] as? UINavigationController)?.topViewController as? MIProfileViewController else {
                return
            }
            
            profileVC.profileAPISucced = {
                profileVC.btnEditProfilePressed()
            }
            
        default:
            break
        }
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
       // CleverTap.sharedInstance()?.handleOpen(url, sourceApplication: nil)

        return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
         //sessionId = ""
        MIFirebaseRemoteConfigInfo.getFirebaseRemoteConfigData()

    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
       
        self.fetchSplashAPIData()
        self.getCountryCurrencyMasterData()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
       // sessionId=""
       // searchId=""
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    //For iOS 9 and lower devices.
    // Applications default directory address
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "MonsteriOS", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        do {
            // If your looking for any kind of migration then here is the time to pass it to the options
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch let  error as NSError {
            print("Ops there was an error \(error.localizedDescription)")
            abort()
        }
        return coordinator
    }()
    
    
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "MonsteriOS")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        if #available(iOS 10.0, *) {
            persistentContainer.viewContext.mergePolicy = NSMergePolicy.overwrite
            return persistentContainer.viewContext
        } else {
            let coordinator = self.persistentStoreCoordinator
            var context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            context.persistentStoreCoordinator = coordinator
            context.mergePolicy = NSOverwriteMergePolicy
            return context
        }
    }()
    
    
    // MARK: - Core Data Saving support
    func saveContext () {
        
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }
}

extension AppDelegate {
    
    static var instance: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
}


extension AppDelegate: MISettingHomeViewControllerDelegate {
    
    func fetchSplashAPIData() {
        if self.site == nil {
            self.openCountrySeletion()
        }
        
        if AppDelegate.instance.splashModel.sites.count == 0 {
            MIActivityLoader.showLoader()
        }
        
        MIApiManager.splashAPI { (result, error) in
            MIActivityLoader.hideLoader()
            guard var data = result else { return }
            
            let siteArr = data.sites.map({ (site) -> Site in
                var s = site
                s.selected = (site.defaultCountryDetails.isoCode == AppDelegate.instance.site?.defaultCountryDetails.isoCode)
                return s
            })
            
            data.sites = siteArr
            data.commit()
            
            AppDelegate.instance.splashModel.deviceName = data.deviceName
            AppDelegate.instance.splashModel.sites      = data.sites

            let ios = AppDelegate.instance.site?.defaultCountryDetails.isoCode
            AppDelegate.instance.site = data.sites.filter({ $0.defaultCountryDetails.isoCode == ios}).first
            AppDelegate.instance.site?.commit()
            
            guard data.sites.count > 0 else { return }
            
            if AppDelegate.instance.site == nil {
                let isoCode = MIAppLocationManager.locationManagerSharedInstance.isoCode
                
                CommonClass.selectCountry(for: isoCode)

                self.openCountrySeletion()
            }
            
        }
    }
    
    func getCountryCurrencyMasterData() {
        
        MIApiManager.splashMasterDataAPI(.COUNTRY) { (result, error) in
            if let countries = result?.countries {
                AppDelegate.instance.splashModel.countries = countries
                AppDelegate.instance.splashModel.commit()
            }
        }
        
        MIApiManager.splashMasterDataAPI(.CURRENCY) { (result, error) in
            if let currencies = result?.currencies {
                AppDelegate.instance.splashModel.currencies = currencies
                AppDelegate.instance.splashModel.commit()
            }
        }
        
    }
    
    func openCountrySeletion() {
        if AppDelegate.instance.splashModel.sites.count == 0 { return }
        
        let vc=MISettingHomeViewController()
        vc.delegate = self
        vc.selectedSettingType = .changecountry
        let nav = MINavigationViewController(rootViewController: vc)
        vc.title = "Select Country"
        nav.modalPresentationStyle = .fullScreen
        self.window?.rootViewController?.present(nav, animated: true, completion: nil)
    }
    
    func changeCountryDone() {
        CommonClass.checkForLogin()
    }
    
}
