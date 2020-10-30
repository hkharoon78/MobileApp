//
//  MIHomeTabbarViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 17/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import MZFormSheetPresentationController
import Photos
class MyShapeLayer: CAShapeLayer {
}

var tabBarProgress: CGFloat = 0.0
//var isCardVisibleViaDeep =  false
var canCallCardAPI =  true


class MIHomeTabbarViewController: UITabBarController {
    
    var popupControllers: Queue<UIViewController> = []
    
    let profileButton = UIButton.init(type: .custom)
    var jobPreferenceInfo = MIJobPreferencesModel()
    var profilePictureSuccess : ((Bool)->Void)?
    var skill: String?
    var isErrorOccuredOnProfileEngagement : Bool?
   
    var userITPlusNonItSkill = [MIUserSkills]()

    var progress: CGFloat = 0.0 {
        didSet {
            for layer in self.profileButton.layer.sublayers ?? [] {
                if layer is MyShapeLayer {
                    layer.removeFromSuperlayer()
                }
            }
            self.addProgressLayer(strokeColor: .white, progress: 1)
            self.addProgressLayer(strokeColor: AppTheme.defaltBlueColor, progress: progress)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 10)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 10)], for: .selected)
        
        self.tabBar.backgroundColor = .white
        tabBar.barTintColor = .white
        self.tabBar.tintColor   = AppTheme.defaltBlueColor
        
        let homeNavigation      = MINavigationViewController(rootViewController: MIHomeViewController())
        let trackNavigation     = MINavigationViewController(rootViewController: MITrackJobsHomeViewController())
        let profileNavigation   = MINavigationViewController(rootViewController: MIProfileViewController())
        let alertNavigation     = MINavigationViewController(rootViewController: MIUpSkillViewController())
        let moreNavigation      = MINavigationViewController(rootViewController: MIMoreTabHomeViewController())
        self.viewControllers=[homeNavigation,trackNavigation,profileNavigation,alertNavigation,moreNavigation]
        
        
        homeNavigation.tabBarItem.image = #imageLiteral(resourceName: "home-menu-fill-ico")
        trackNavigation.tabBarItem.image = #imageLiteral(resourceName: "job-menu-ico-fill")
        alertNavigation.tabBarItem.image = #imageLiteral(resourceName: "upskill-menufill-ico")
        moreNavigation.tabBarItem.image = #imageLiteral(resourceName: "more-menufill-ico")
        
        homeNavigation.tabBarItem.title = "Home"
        trackNavigation.tabBarItem.title = "Track" //ControllerTitleConstant.trackJobs
        profileNavigation.tabBarItem.title = "Profile"
        alertNavigation.tabBarItem.title = ControllerTitleConstant.upSkill
        moreNavigation.tabBarItem.title = ControllerTitleConstant.moreOption
        
        profileButton.setTitle("", for: .normal)
        profileButton.setTitleColor(AppTheme.grayColor, for: .normal)
        profileButton.setImage(UIImage(named: "m-icon"), for: .normal)
        profileButton.adjustsImageWhenHighlighted = false
        profileButton.backgroundColor = .white
        profileButton.addTarget(self, action: #selector(MIHomeTabbarViewController.profileViewSelected(_:)), for: .touchUpInside)
        self.view.insertSubview(profileButton, aboveSubview: self.tabBar)
        var centerYConstant = -5
        let heightWidht = 22
        
        if AppDelegate.isIPhoneXorXs() || AppDelegate.isIPhoneXmax(){
            centerYConstant = -22
        }
        
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ) {
            profileNavigation.tabBarItem.image = #imageLiteral(resourceName: "more-menufill-ico")

            NSLayoutConstraint.activate([
                profileButton.centerYAnchor.constraint(equalTo: self.tabBar.centerYAnchor,constant:CGFloat(-2)),
                profileButton.centerXAnchor.constraint(equalTo: self.tabBar.centerXAnchor,constant: -20),
                profileButton.widthAnchor.constraint(equalToConstant:CGFloat(heightWidht)),
                profileButton.heightAnchor.constraint(equalToConstant:CGFloat(heightWidht))
            ])
            
        }else{
            NSLayoutConstraint.activate([
                profileButton.centerYAnchor.constraint(equalTo: self.tabBar.centerYAnchor,constant:CGFloat(centerYConstant)),
                profileButton.centerXAnchor.constraint(equalTo: self.tabBar.centerXAnchor),
                profileButton.widthAnchor.constraint(equalToConstant:CGFloat(heightWidht)),
                profileButton.heightAnchor.constraint(equalToConstant:CGFloat(heightWidht))
            ])
        }
        MIApiManager.getOldSystemCookiesData()
        self.getProfileData()
        NotificationCenter.default.addObserver(self, selector: #selector(getProfileData), name: NSNotification.Name.CountryChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getProfileCards), name: NSNotification.Name.userEngagementSPL, object: nil)

        self.delegate = self
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.CountryChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.userEngagementSPL, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            guard self.popupControllers.count == 0 else {
                return
            }
            self.getProfileCards()

        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileButton.layer.cornerRadius = self.profileButton.frame.size.height/2
        profileButton.layer.borderWidth = 0.5
        profileButton.layer.borderColor = UIColor.white.cgColor
        profileButton.layer.masksToBounds = false
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        self.presentUserEngagementPopups()
//    }
    
    @objc func profileViewSelected(_ sender:UIButton) {
        JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.PROFILE_SCREEN)

        MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.PROFILE_PAGE, data: ["eventValue" : CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK], source: CONSTANT_SCREEN_NAME.DASHBOARD, destination: CONSTANT_SCREEN_NAME.PROFILE_SCREEN) { (success, response, error, code) in
        }
        
        CommonClass.googleEventTrcking("app_footer_screen", action: "profile", label: "")
        
        if let profileVc=self.viewControllers![2] as? MINavigationViewController{
            profileVc.popToRootViewController(animated: true)
        }
        self.selectedIndex = 2
    }
    
    @objc func getProfileCards() {
        
        guard canCallCardAPI else { return }
        canCallCardAPI = false
        self.popupControllers.removeAll()
       
        MIApiManager.profileEngagementAPI { (data, error) in
           // defer { canCallCardAPI = true }
            guard let model = data else { return }
            
            let cards = model.cards.map({ (obj) -> Card in
                var card = obj
                card.ruleApplied = model.ruleApplied
                card.ruleVersion = model.ruleVersion
                return card
            })
            
            for card in cards {
                switch card.text {
                case "WORK_EXPERIENCE":
                    let updateWorkExp = MIUpdateWorkExp()
                    updateWorkExp.popUpMode = .Fresher
                    updateWorkExp.card = card
                    self.popupControllers.enqueue(updateWorkExp)

                case "DESIGNATION":
                    let employment = MIEmploymentProfileImprovementVC()
                    employment.card = card
                    self.popupControllers.enqueue(employment)

                case "UPLOAD_RESUME":
                    let updateResume = MIUpdateWorkExp()
                    updateResume.popUpMode = .Resume
                    updateResume.card = card
                    self.popupControllers.enqueue(updateResume)

                case "SKILLS":
                    let skill = MISkillPopUpVC()
                    skill.card = card
                    self.popupControllers.enqueue(skill)
                    
                case "PREFERRED_LOCATION":
                    let addPreferedLocationVC = MIPopUpVC()
                    addPreferedLocationVC.card = card
                    self.popupControllers.enqueue(addPreferedLocationVC)
                    
                case "EDUCATION":
                    let addEducationVC = MIPopUpVC()
                    addEducationVC.card = card
                    self.popupControllers.enqueue(addEducationVC)
                    
                    break
                case "VERIFY_MOBILE_NUMBER":
                    let verifyPopup = MIVerifyMobilePopupVC()
                    verifyPopup.card = card
                    self.popupControllers.enqueue(verifyPopup)
                    
                default:
                    break
                }
                
                //                    if self.popupControllers.count >= 3 {
                //                        break
                //                    }
            }
            if cards.count > 0 {
                self.presentUserEngagementPopups()
            }
            
        }
        
    }
    
    
    func presentUserEngagementPopups() {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
         
            if let controller = self.presentedViewController {
                controller.dismiss(animated: false, completion: nil)
            }
            
            guard self.presentedViewController == nil else {
               // isCardVisible = false
                return
            }
            
            guard let controller = self.popupControllers.dequeue() else {
                // self.showInfoPopup()
               // isCardVisible = false
                return
            }
            let nav = MINavigationViewController(rootViewController: controller)
            nav.interactivePopGestureRecognizer?.isEnabled  = false
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
            
        }
        
    }

    @objc func jobAppliedSuccess(_ jobID: String) {

        DispatchQueue.once(executionToken: jobID) {
    
            var count = AppUserDefaults.value(forKey: .JobApplyCount, fallBackValue: 0).intValue
            count += 1
            AppUserDefaults.save(value: count, forKey: .JobApplyCount)
            
            if count >= CommonClass.minimumJobAppliesForRating {
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    self.showRatingView(from: .FromJobApply)
                }
            }

        }
    }
    
    //TODO:- Rating Popup
    func showRatingView(from: RatingFlow) {
//        let vc = MZFormSheetContentSizingNavigationController.instantiate(fromAppStoryboard: .Rating)
//        let formSheetController = MZFormSheetPresentationViewController(contentViewController: vc)
//        formSheetController.contentViewControllerTransitionStyle = .dropDown
//        formSheetController.allowDismissByPanningPresentedView = false
//        formSheetController.presentationController?.shouldCenterVertically = true
//
//
//        self.present(formSheetController, animated: true, completion: nil)
//
//        //formSheetController.willPresentContentViewControllerHandler = { vc in
//        //    let navigationController = vc as! UINavigationController
//        //    let presentedViewController = navigationController.viewControllers.first as! RatingPopupVC
//        //}
//
//        formSheetController.didPresentContentViewControllerHandler = { vc in
//            formSheetController.contentViewControllerTransitionStyle = .slideFromBottom
//        }

        
        
        
        
        switch from {
        case .FromJobApply:
            if let applyDate = UserDefaults.standard.value(forKey: AppUserDefaults.Key.JobApplyOnDate.rawValue) as? Date,
                let applyRating = AppUserDefaults.value(forKey: .JobApplyRating, fallBackValue: "").int {
                let days = (applyRating >= CommonClass.starRatingValue) ? CommonClass.minimumRatingDaysForJobApply : CommonClass.maximumRatingDaysForJobApply
                if Date.daysBetween(date1: Date(), date2: applyDate) < days {
                    return
                }
            }

        case .FromJobShare:
            if let shareDate = UserDefaults.standard.value(forKey: AppUserDefaults.Key.JobSharedOnDate.rawValue) as? Date,
                let shareRating = AppUserDefaults.value(forKey: .JobShareRating, fallBackValue: "").int {
                let days = (shareRating >= CommonClass.starRatingValue) ? CommonClass.minimumRatingDaysForJobShare : CommonClass.maximumRatingDaysForJobShare
                if Date.daysBetween(date1: Date(), date2: shareDate) < days {
                    return
                }
            }

        case .FromAppShare:
            if let shareDate = UserDefaults.standard.value(forKey: AppUserDefaults.Key.AppSharedOnDate.rawValue) as? Date,
                let shareRating = AppUserDefaults.value(forKey: .AppShareRating, fallBackValue: "").int {
                let days = (shareRating >= CommonClass.starRatingValue) ? CommonClass.minimumRatingDaysForAppShare : CommonClass.maximumRatingDaysForAppShare
                if Date.daysBetween(date1: Date(), date2: shareDate) < days {
                    return
                }
            }
        }


        let vc = MIRatingViewController.instantiate(fromAppStoryboard: .Rating)
        self.present(vc, animated: true, completion: nil)

        ratingFlowFrom = from
    }
    
    
    func addProgressLayer(strokeColor:UIColor,progress:CGFloat){
        let userProgressShapeLayer = MyShapeLayer()
        let remaingShapeLayer = MyShapeLayer()

        let lineWidth = 1.0
        let radius = self.profileButton.frame.size.width/2 + 1
//        if AppDelegate.isIPhoneXorXs() || AppDelegate.isIPhoneXmax() {
//          //  lineWidth = 2.0
//           // radius -= 2
//        }
        //  let beziarPath=UIBezierPath(arcCenter   : CGPoint(x: self.profileButton.frame.size.width/2, y: self.profileButton.frame.size.height/2),radius:radius,
        //                              startAngle  : -.pi/2,
        //                              endAngle    : -.pi/2 + .pi * 2 * progress,
        //                              clockwise   : true)
        let arcCenter=CGPoint(x: self.profileButton.frame.size.width/2, y: self.profileButton.frame.size.height/2)
        
        let piValue = -CGFloat.pi/2
        let newProg = .pi * 2 * progress
        let endAngle = piValue + newProg
        
        let beziarPath = UIBezierPath(arcCenter:arcCenter, radius:radius,startAngle: piValue, endAngle: endAngle, clockwise: true)
        userProgressShapeLayer.path = beziarPath.cgPath
        userProgressShapeLayer.strokeColor = strokeColor.cgColor
        userProgressShapeLayer.lineWidth = CGFloat(lineWidth)
        userProgressShapeLayer.fillColor = UIColor.clear.cgColor
        self.profileButton.layer.addSublayer(userProgressShapeLayer)
        
        let beziarPathSec = UIBezierPath(arcCenter:arcCenter, radius:radius,startAngle: endAngle, endAngle: piValue, clockwise: true)
        remaingShapeLayer.path = beziarPathSec.cgPath
        remaingShapeLayer.strokeColor = Color.colorLightGrey.cgColor
        remaingShapeLayer.lineWidth = CGFloat(lineWidth)
        remaingShapeLayer.fillColor = UIColor.clear.cgColor
        self.profileButton.layer.addSublayer(remaingShapeLayer)

    }
    
}

extension MIHomeTabbarViewController {
    
    @objc func getProfileData() {
      
        MIApiManager.getProfileAPI { [weak self] (status, response, error, code) in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                //                if let err = error {
                if let data = response as? JSONDICT {
                    if let errorMsg = data["errorMessage"] as? String {
                        self.showAlert(title: "", message: errorMsg)
                    }
                }
                //                }
                //                if let res = response as? [String:Any] {
                //                    if let errorMsg = res["errorMessage"] as? String{
                //                        self.showAlert(title: "", message: errorMsg)
                //                    }
                //                }
                guard let data = response as? JSONDICT else {
                    return
                }
                
                // if let personalDetailDic = data["personalDetailSection"] as? [String:Any] {
                //    let personalDetail = MIProfilePersonalDetailInfo(dictionary: personalDetailDic)
                //  print(data)
                
                if let personalDetailDic = data["personalDetailSection"] as? [String:Any] {
                    let personalDetail = MIProfilePersonalDetailInfo(dictionary: personalDetailDic)
                    //  print(personalDetailDic)
                    AppDelegate.instance.userInfo = personalDetail
                    AppDelegate.instance.userInfo.commit()
                }
                if let personalmanageDic = data["manageProfileSection"] as? [String:Any] {
                    if let profile=personalmanageDic["profiles"]as?[[String:Any]]{
                        let profileArray=MIExistingProfileInfo.modelsFromDictionaryArray(array: profile)
                        let site = AppDelegate.instance.site
                        let profileWithSite=profileArray.filter({$0.countryIsoCode.lowercased()==site?.defaultCountryDetails.isoCode.lowercased() && $0.active==true})
                        if let first=profileWithSite.first{
                            UserDefaults.standard.set(first.id, forKey:"profileId")
                        }
                    }
                }
                // }
                //Add/Edit Skill & IT Skill for job detail matchd data
                self.userITPlusNonItSkill.removeAll()
                self.userITPlusNonItSkill = MIUserSkills.getITNonItSkill(params: data)
                
                
                if let itSection=data["itSkillSection"] as? [String:Any],let itskills = itSection["itSkills"] as? [[String:Any]],itskills.count > 0 {
                    
                        if self.skill == nil{

                            let skills = MIProfileITSkills.modelsFromDictionaryArray(array: itskills)
                            var finalSkill=""
                            for (index,item) in skills.enumerated(){
                                if let newSkill = item.skill{
                                    if newSkill.name.count > 0 {
                                        finalSkill += newSkill.name
                                        if index != skills.count-1{
                                            finalSkill += ","
                                        }
                                    }
                                }
                            }
                            self.skill=finalSkill
                            //if let navView=self.viewControllers![0] as? MINavigationViewController{
                              //  if let homeView=navView.viewControllers.first as? MIHomeViewController{
                                //    if let tbl = homeView.tblView {
                                        // tbl.reloadData()
                                  //  }
                                    //homeView.tblView.reloadData()
                                // }
                            //}
                        }
 
                    }
                
                
                if
                    let pendingActionsSec = data["pendingActionSection"] as? [String:Any],
                    let pendingActionsDic = pendingActionsSec["pendingActions"] as? [[String:Any]] {
                    
                    var progress = 100 - pendingActionsDic.reduce(0, { $0+$1.intFor(key: "weightage") })
                    progress = progress < 0 ? 0 : progress
                    AppUserDefaults.save(value: progress, forKey: .ProfileProgress)
                    self.progress = CGFloat(progress)/100
                    tabBarProgress =  self.progress
                }
                
                if let jobPreferenceSection=data["jobPreferenceSection"] as? [String:Any],let data = jobPreferenceSection["jobPreference"] as? [String:Any] {
                    self.jobPreferenceInfo =    MIJobPreferencesModel.getObjectFromModel(params: data)
                    //    print(self.jobPreferenceInfo.preferredLocationList)
                    
                    //                    if let preferLocation = data["locations"] as? [[String:Any]] {
                    //                        print(preferLocation)
                    //                    }
                }
            }
        }
    }
    func showInfoPopup() {
        let controller = MIPopUpSuccessErrorVC()
        controller.popUpForError = isErrorOccuredOnProfileEngagement ?? true
        controller.isErrorCase = { isProfileCase in
            if let topViewController = self.selectedViewController as? MINavigationViewController {
                topViewController.popToRootViewController(animated: false)
                if isProfileCase {
                    self.selectedIndex = 2
                }else{
                    self.selectedIndex = 0
                    
                }
            }
        }
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: false, completion: nil)
    }
    func handlePopFinalState(isErrorHappen:Bool) {
        if self.isErrorOccuredOnProfileEngagement == nil {
            self.isErrorOccuredOnProfileEngagement = isErrorHappen
        }
    }
    
    func logoutUnAuthorizedUserPopUp() {
      
        let vPopup = MIJobPreferencePopup.popup()
        vPopup.setViewWithTitle(title: "Session Expired", viewDescriptionText:  ExtraResponse.unAuthorizedUser, or: "", primaryBtnTitle: "Ok", secondaryBtnTitle: "")
        vPopup.delegate = self
        vPopup.closeBtn.isHidden = true
        vPopup.addMe(onView: self.view, onCompletion: nil)

        
    }
    
    func logoutAsSessionExpired(){
        if !AppDelegate.instance.authInfo.accessToken.isEmpty {
            
            canCallCardAPI = true
            CommonClass.deleteUserLogs()
            AppUserDefaults.removeValue(forKey: .UserData)
            let rootVc = MISplashViewController()
            let nav = MINavigationViewController(rootViewController: rootVc)
            if let landVc=rootVc.landingNavigation.viewControllers.first as? MILandingViewController{
                landVc.navigationItem.title = ""
                landVc.applyLoginFlag=true
            }
            
            AppDelegate.instance.window?.rootViewController = nav
            AppDelegate.instance.window?.makeKeyAndVisible()
        }
    }
}

extension MIHomeTabbarViewController: UITabBarControllerDelegate {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {

        switch item.title {
            case ControllerTitleConstant.trackJobs:
                
             //       JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.TRACK_SCREEN)
                    MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.TRACK_JOB, data: ["eventValue" : CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK], source: CONSTANT_SCREEN_NAME.DASHBOARD, destination: CONSTANT_SCREEN_NAME.TRACK_SCREEN) { (success, response, error, code) in
                    }
                
                
                 CommonClass.googleEventTrcking("app_footer_screen", action: "track", label: "")
                break
            case ControllerTitleConstant.upSkill:
               
                MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.UPSKILL_SCREEN, data: ["eventValue" : CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK], source: CONSTANT_SCREEN_NAME.DASHBOARD, destination: CONSTANT_SCREEN_NAME.UPSKILL_SCREEN) { (success, response, error, code) in
                }
                
                CommonClass.googleEventTrcking("app_footer_screen", action: "upskill", label: "")
                break
            case "Profile":
               // JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.PROFILE_SCREEN)
                CommonClass.googleEventTrcking("app_footer_screen", action: "profile", label: "")
                break
            case "Home":
                MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.DASHBOARD_LANDING, data: ["eventValue" : CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK], source: CONSTANT_SCREEN_NAME.DASHBOARD, destination: CONSTANT_SCREEN_NAME.HOME) { (success, response, error, code) in
                    }

                CommonClass.googleEventTrcking("app_footer_screen", action: "dashboard", label: "")
                break
            case "More":
              //  JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.MORE_SCREEN)
            MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.MORE_SCREEN, data: ["eventValue" : CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK], source: CONSTANT_SCREEN_NAME.DASHBOARD, destination: CONSTANT_SCREEN_NAME.MORE_SCREEN) { (success, response, error, code) in
                }
                
                CommonClass.googleEventTrcking("app_footer_screen", action: "more", label: "")
                break
            default:
                break
        }
        }
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected view controller,\(viewController)")
       NotificationCenter.default.post(name: NSNotification.Name.refreshJobList, object: nil)

   //     NotificationCenter.default.post(NSNotification.Name.refreshJobList)
    }
}

extension MIHomeTabbarViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func showActionSheetForUserSelection(personalDetail:MIProfilePersonalDetailInfo?) {
        var optionArray = [String]()
        if CommonClass.deleteProfilePic && !(personalDetail?.avatar.isEmpty ?? true) {
            optionArray = ["Capture photo from camera","Select photo from gallery","Remove profile picture","Cancel"]
        }else{
            optionArray = ["Capture photo from camera","Select photo from gallery","Cancel"]
            
        }
        
        AKAlertController.actionSheet("Choose Option", message: "", sourceView: self, buttons: optionArray) { (vc, action, tag) in
            
            if tag == 0 {
                CommonClass.googleEventTrcking("profile_screen", action: "upload_profile_picture", label: "camera")
                self.openMediaOption(type:UIImagePickerController.SourceType.camera)
            }else if tag == 1 {
                CommonClass.googleEventTrcking("profile_screen", action: "upload_profile_picture", label: "gallery")
                self.openMediaOption(type: UIImagePickerController.SourceType.photoLibrary)
                
            } else if action.title == "Remove profile picture" {
                self.callAPIToRemoveProfilePic()
            }
        }
    }
    func openMediaOption(type:UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(type) {
            let pickerController = UIImagePickerController()
            pickerController.sourceType = type
            pickerController.delegate = self
            pickerController.allowsEditing = false
            
            if (type == .camera) ? AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .denied : PHPhotoLibrary.authorizationStatus() == .denied {
            
                self.showPopUpView( message: "You have to authorized Monster App to access photos/camera from your iPhone/iPad. Go to settings and authorize Monster app.", primaryBtnTitle: "Setting", secondaryBtnTitle: "Later") { (isPrimarBtnClicked) in
                    if isPrimarBtnClicked {
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                    print("Settings opened: \(success)") // Prints true
                                })
                            } else {
                                // Fallback on earlier versions
                                UIApplication.shared.openURL(settingsUrl)
                                
                            }
                        }
                    }
                }
                
                
                
//                let vPopup = MIJobPreferencePopup.popup()
//                vPopup.closeBtn.isHidden = true
//                vPopup.setViewWithTitle(title: "", viewDescriptionText:  "You have to authorized Monster App to access photos/camera from your iPhone/iPad. Go to settings and authorize Monster app.", or: "", primaryBtnTitle: "Setting", secondaryBtnTitle:"Later")
//                vPopup.completionHandeler = {
//                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
//                        return
//                    }
//
//                    if UIApplication.shared.canOpenURL(settingsUrl) {
//                        if #available(iOS 10.0, *) {
//                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
//                                print("Settings opened: \(success)") // Prints true
//                            })
//                        } else {
//                            // Fallback on earlier versions
//                            UIApplication.shared.openURL(settingsUrl)
//
//                        }
//                    }
//                }
//                vPopup.cancelHandeler = {
//
//                }
//                vPopup.addMe(onView: self.view, onCompletion: nil)

                
                
                
//
//                AKAlertController.alert("", message: "You have to authorized Monster App to access photos/camera from your iPhone/iPad. Go to settings and authorize Monster app.", buttons: ["Later","Setting"]) { (alertVC, alertAction, index) in
//
//                    if index == 1 {
//                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
//                            return
//                        }
//
//                        if UIApplication.shared.canOpenURL(settingsUrl) {
//                            if #available(iOS 10.0, *) {
//                                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
//                                    print("Settings opened: \(success)") // Prints true
//                                })
//                            } else {
//                                // Fallback on earlier versions
//                                UIApplication.shared.openURL(settingsUrl)
//
//                            }
//                        }
//                    }
//                }
                //   self.showAlert(title: "", message: "You have to authorized Monster App to access photos/camera from your iPhone/iPad. Go to settings and authorize Monster app.")
                
            }else{
                present(pickerController, animated: true, completion: nil)
                
            }
        }
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image=info[UIImagePickerController.InfoKey.originalImage]as?UIImage {
            
            let cropController = CropViewController(croppingStyle: CropViewCroppingStyle.default, image: image)
            cropController.delegate = self
            picker.dismiss(animated: true, completion: {
                self.present(cropController, animated: true, completion: nil)
            })
            
        }
    }
    
    private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Service Helper Method
    func callAPIToRemoveProfilePic() {
        MIActivityLoader.showLoader()
        MIApiManager.callAPIToRemoveProfilePic(path: APIPath.removeProfilePicApiEndPoint) { (success, response, error, code) in
            
            if error == nil && (code >= 200) && (code <= 299) {
                DispatchQueue.main.async {
                    MIActivityLoader.hideLoader()
                    
                    if let nav = self.viewControllers?[2] as? UINavigationController,
                        let profileVC = nav.viewControllers.first as? MIProfileViewController {
                        profileVC.personalDetail.avatar = ""
                        profileVC.tblHeader.show(info: profileVC.personalDetail)
                    }
                    
                    self.showAlert(title: "", message: "Your avatar removed successfully.",isErrorOccured:false)
                    
                }
                
            }else{
                self.handleAPIError(errorParams: response, error: error)
            }
            
        }
    }
    func callAPIForUploadAvatar(data:Data) {
       // MIActivityLoader.showLoader()
        
        let params = ["file" : data]
        let extenstion = "png"
        if !extenstion.isEmpty {
            imageCache.removeAllObjects()
            if let nav = self.viewControllers?[2] as? UINavigationController,
                let profileVC = nav.viewControllers.first as? MIProfileViewController {
                DispatchQueue.main.async {
                    profileVC.tblHeader.profileImgActivityIndicator.isHidden = false
                    profileVC.tblHeader.profileImgActivityIndicator.startAnimating()
                }
            }
            MIApiManager.callAPIForUploadAvatarResume(path: APIPath.uploadAvtarAPIEndpoint, params: params, extenstion: extenstion, filename: nil, customHeaderParams: [:]) {  (success, response, error, code) in
                DispatchQueue.main.async {
                  //  MIActivityLoader.hideLoader()
                    
                    if let nav = self.viewControllers?[2] as? UINavigationController,
                        let profileVC = nav.viewControllers.first as? MIProfileViewController {
                        profileVC.tblHeader.profileImgActivityIndicator.isHidden = true
                        profileVC.tblHeader.profileImgActivityIndicator.stopAnimating()
                    }
                    if error == nil && (code >= 200) && (code <= 299) {
                        JobSeekerSingleton.sharedInstance.fieldLevelDataArray = [CONSTANT_FIELD_LEVEL_NAME.PROFILE_PHOTO]
                        if self.selectedIndex == 2 {
                            if let nav = self.viewControllers?[2] as? UINavigationController,
                                let profileVC = nav.viewControllers.first as? MIProfileViewController {
                                profileVC.callApi()
                            }
                        }else{
                            if let success = self.profilePictureSuccess {
                                success(true)
                            }
                            shouldRunProfileApi = true
                        }
                        self.showAlert(title: "", message: "Your avatar updated successfully.",isErrorOccured:false)
                        
                    }else{
                        self.handleAPIError(errorParams: response, error: error)
                    }
                }
            }
        }else {
            //  MIActivityLoader.hideLoader()
            
            self.showAlert(title: "", message: "File format is not correct.")
            
        }
        
    }
   
    
}

extension MIHomeTabbarViewController : CropViewControllerDelegate {
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        cropViewController.dismiss(animated: true, completion: {
        if let profileVC = self.viewControllers?[2] as? MIProfileViewController {
            profileVC.tblHeader.removePlaceHolderIcon()
            profileVC.tblHeader.profileImgView.image = image
        }
        self.callAPIForUploadAvatar(data: image.resizeImage().jpegData(compressionQuality: 1) ?? Data())

            })
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: nil)
        
    }
    
}

let dis = DispatchGroup()

extension UIViewController   {
    var tabbarController: MIHomeTabbarViewController? {
        return (AppDelegate.instance.window?.rootViewController as? MIHomeTabbarViewController) ?? (AppDelegate.instance.window?.rootViewController?.presentedViewController?.presentedViewController as? MIHomeTabbarViewController)
    }
    
    @discardableResult
    func addTaskToDispatchGroup() -> Bool {
        if let tabbar = self.tabbarController {
            if (tabbar.isErrorOccuredOnProfileEngagement ?? false) == false {
                dis.enter()
                return true
            }
        }
        return false
    }
    
    func leaveDispatchGroup(_ leave: Bool) {
        if leave {
            dis.leave()
        }
    }
    
    func skipProfileEngagementPopup() {
        if let controller = self.tabbarController?.popupControllers.dequeue() {
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            MIActivityLoader.showLoader()
            dis.notify(queue: .main) {
                MIActivityLoader.hideLoader()
                canCallCardAPI = false
                self.dismiss(animated: false, completion: {
                    if let homeTab = self.tabbarController {
                        if  homeTab.isErrorOccuredOnProfileEngagement != nil {
                            homeTab.showInfoPopup()
                            
                        }
                        
                    }
                })
            }
        }
    }
    
    
}
extension MIHomeTabbarViewController: JobPreferencePopUpDelegate{
    func optionCompleteIgnoredSelected(popSelection: PopUpOptionSelection, popup: MIPopupView) {
        if popSelection == .Completed {
            self.logoutAsSessionExpired()
        }
    }
}


