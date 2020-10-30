//
//  MISettingMainViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 04/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MISettingMainViewController:UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblVersionNo: UILabel!

    var titleArray=SettingsMore.allCases
    var arrExistingProfile = [MIExistingProfileInfo]()
    var navigateToProfile=false{
 
        didSet{
//            if let fromSpply = self.parent as?  {
//                self.navigationController?.popToRootViewController(animated: false)
//            }else{
                self.tabBarController?.selectedIndex=2

      //      }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        titleArray = titleArray.filter { (option) -> Bool in
            if !CommonClass.showSocialLogin {
                return option != .manageSocial
            }
            return true
        }
        
         tableView.register(UINib(nibName:String(describing: MIMoreOptionTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIMoreOptionTableViewCell.self))
        
        tableView.delegate=self
        tableView.dataSource=self
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.bounces=true
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView=UIView(frame: .zero)
        NotificationCenter.default.addObserver(self, selector: #selector(countryChanged), name: .CountryChanged, object: nil)
                
    }
    
    @objc func countryChanged() {
//        let vc = MICreateNewProfileController()
//        self.navigationController?.pushViewController(vc, animated: true)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .CountryChanged, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        self.navigationItem.title=MoreOptionViewModelItemType.settings.value
        self.tableView.reloadData()
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)
       
        var versionDetail = "Version: \(CurrentAppVersion)"
        if apiMode == .RFS {
            versionDetail = "rfs " + versionDetail
        }else if apiMode == .QA {
            versionDetail = "qa1 " + versionDetail
        }
        self.lblVersionNo.text = versionDetail
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }
}

extension MISettingMainViewController: MISettingHomeViewControllerDelegate {
   
    func changeCountryDone() {
        self.callExistingProfileApi()
    }
    
    func callExistingProfileApi() {
        MIActivityLoader.showLoader()
        MIApiManager.callGetExistingProfile{ [weak wSelf = self] (isSuccess, response, error, code) in
           
            DispatchQueue.main.async {
                MIActivityLoader.hideLoader()
                wSelf?.arrExistingProfile.removeAll()
                
                if let res = response as? [[String:Any]],res.count > 0 {
                    wSelf?.arrExistingProfile = MIExistingProfileInfo.modelsFromDictionaryArray(array: res)
                }
                if let `self` = wSelf, self.arrExistingProfile.count > 0 {
//                    self.arrExistingProfile = self.arrExistingProfile.filter({$0.active == true})
                    if !self.arrExistingProfile.contains(where: { $0.countryIsoCode == AppDelegate.instance.site?.defaultCountryDetails.isoCode }) {
                        
//                        let vc = MICreateNewProfileController()
//                        vc.arrExistingProfile = self.arrExistingProfile
//                        self.navigationController?.pushViewController(vc, animated: true)
                     //   self.tabBarController?.tabBar.isHidden = true
                        
                        let vc = MICreateProfileVC()
                        vc.arrExistingProfile = self.arrExistingProfile
                        let nav = MINavigationViewController(rootViewController:vc) //UINavigationController(rootViewController: vc)
                        vc.objPreviousController = self
                        nav.modalPresentationStyle = .fullScreen
                        self.present(nav, animated: true, completion: nil)
                    } else {
                        
                        if let iso = AppDelegate.instance.site?.defaultCountryDetails.isoCode {
                            //MARK:- Country Changed Successfully
                            AppUserDefaults.save(value: iso, forKey: .PreviousCountry)
                        }

                        
                        self.arrExistingProfile = self.arrExistingProfile.filter({$0.countryIsoCode == AppDelegate.instance.site?.defaultCountryDetails.isoCode})
                        if self.arrExistingProfile.count > 0 {
                            let activeProfilemodelArray = self.arrExistingProfile.filter({$0.active == true})
                            if activeProfilemodelArray.count > 0, let model = activeProfilemodelArray.first {
                                UserDefaults.standard.set(model.id, forKey:"profileId")
                            }
                        }
                        MIApiManager.getOldSystemCookiesData()
                    }
                    
                } else {

                    let oldIso = AppUserDefaults.value(forKey: .PreviousCountry, fallBackValue: "").stringValue
                    CommonClass.selectCountry(for: oldIso)

//                    if let index = AppDelegate.instance.splashModel.sites.firstIndex(where: { $0.defaultCountryDetails.isoCode == oldIso }) {
//                        AppDelegate.instance.splashModel.sites[index].selected = true
//                        AppDelegate.instance.site = AppDelegate.instance.splashModel.sites[index]
//
//                        AppDelegate.instance.splashModel.commit()
//                        AppDelegate.instance.site?.commit()
//
//                        NotificationCenter.default.post(name: .CountryChanged, object: nil, userInfo: nil)
//                    }
                }
                self.tableView.reloadData()
            }
        }
        
    }
    
    
}

extension MISettingMainViewController:UITableViewDelegate,UITableViewDataSource{
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MIMoreOptionTableViewCell.self), for: indexPath)as?MIMoreOptionTableViewCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = self.titleArray[indexPath.row].rawValue
        cell.subTitlelabel.text = nil
        cell.accessoryType = .disclosureIndicator
        cell.tintColor = AppTheme.appGreyColor

        if self.titleArray[indexPath.row] == SettingsMore.changecountry{
            //let predicate = NSPredicate(format: "selected == %@", NSNumber(value: true))
            let name = AppDelegate.instance.site?.defaultCountryDetails.langOne?.first?.name

            cell.accessoryType = .none
            cell.subTitlelabel.text = name
        }
       
        if self.titleArray[indexPath.row] == SettingsMore.signout {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        switch titleArray[indexPath.row] {
        
        case .signout:
            let vPopup = MIJobPreferencePopup.popup()
            vPopup.setViewWithTitle(title: "", viewDescriptionText:  ExtraResponse.logoutMsg, or: "", primaryBtnTitle: "Yes", secondaryBtnTitle: "No")
            vPopup.delegate = self
            vPopup.closeBtn.isHidden = true
            vPopup.addMe(onView: self.view, onCompletion: nil)
           


            MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.SETTINGS, data: ["eventValue" : CONSTANT_JOB_SEEKER_EVENT_VALUE.SIGNOUT], source: "", destination: CONSTANT_SCREEN_NAME.SETTINGS) { (success, response, error, code) in
            }

                        
 
        case .profileVisibility:
            let vc = MIProfileVisibilityViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .privacyPolicy:
            //For View resume
//            let vc=Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
//            vc.url = "falcon/api/public/users/v1/view-resume"
//            vc.ttl = "Resume"
//            vc.isforResumeShow = true
//            self.present(MINavigationViewController(rootViewController:vc), animated: true, completion: nil)
           
            CommonClass.googleEventTrcking("settings_screen", action: "privacy_policy", label: "") //GA
            JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.PRIVACY_POLICY_SCREEN)

            let vc=Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
            vc.url = WebURl.privacyPolicyUrl
            vc.ttl = "Privacy Policy"
            //vc.modalPresentationStyle = .fullScreen
            let nav = MINavigationViewController(rootViewController:vc)
            nav.modalPresentationStyle = .fullScreen

            self.present(nav, animated: true, completion: nil)
            
        case .termsCondition:
            CommonClass.googleEventTrcking("settings_screen", action: "T&C", label: "") //GA
            JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.TERMS_CONDITION_SCREEN)

            let vc=Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
            vc.url = WebURl.termsConditionsUrl
            vc.ttl = "Terms & Conditions"
            let nav = MINavigationViewController(rootViewController:vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
            
        case .managesubscription:
            
            let vc =
                MIManageSubscriptionsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
    
        case .manageSocial:
            let vc = MIManageSocialVC()
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            self.navigateToNew(indexPath: indexPath)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        self.navigateToNew(indexPath: indexPath)
    }
    
    func navigateToNew(indexPath:IndexPath){
        let vc=MISettingHomeViewController()
        vc.selectedSettingType = self.titleArray[indexPath.row]
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func signOutCall() {
        
        MIActivityLoader.showLoader()
        let _ = MIAPIClient.sharedClient.load(path: APIPath.logout, method: .get, params: [:], completion: { (response, error,code) in
            
            DispatchQueue.main.async {
                MIActivityLoader.hideLoader()

                if code >= 200 && code <= 299 {
                    
                    covid19Flag = false
                    sessionId = ""
                    canCallCardAPI = true
                    CommonClass.deleteUserLogs()
                    AppUserDefaults.removeValue(forKey: .UserData)
                    
                    let rootVc = MISplashViewController()
                    let nav = MINavigationViewController(rootViewController: rootVc)
                    
                    
                    AppDelegate.instance.window?.rootViewController = nav
                    AppDelegate.instance.window?.makeKeyAndVisible()
                    if let landVc=rootVc.landingNavigation.viewControllers.first as? MILandingViewController{
                        landVc.navigationItem.title = ""
                        landVc.applyLoginFlag=true
                    }
                }
                else{
                    self.handleAPIError(errorParams: response, error: error)
                }
            }
        })
        
    }
    
}

extension MISettingMainViewController: JobPreferencePopUpDelegate {
    func optionCompleteIgnoredSelected(popSelection: PopUpOptionSelection, popup: MIPopupView) {
     
        if popSelection == .Completed {
            CommonClass.googleEventTrcking("settings_screen", action: "sign_out", label: "") //GA
            self.signOutCall()
        }
    }
    
}
