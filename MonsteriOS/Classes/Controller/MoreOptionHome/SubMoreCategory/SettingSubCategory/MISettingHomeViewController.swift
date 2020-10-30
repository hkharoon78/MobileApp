//
//  MISettingHomeViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 27/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

protocol MISettingHomeViewControllerDelegate:class {
    func changeCountryDone()
}

class MISettingHomeViewController: MIBaseViewController {
  
    //MARK:Variable and Outlet
    var selectedSettingType:SettingsMore = .changepassword
    weak var delegate:MISettingHomeViewControllerDelegate?
    var isFromProfileVC = false
    var isFromApplyFlow = false
   
    lazy var changePasswordView:MIChangePasswordView={
        let passwordView=MIChangePasswordView()
        passwordView.viewController = self
        return passwordView
    }()
    
    lazy var profileVisibleView:MIProfileVisibilityView={
        let profileVisiView = MIProfileVisibilityView()
        return profileVisiView
    }()
    
    lazy var changeCountryView:MIChangeCountryView={
        let countryView=MIChangeCountryView()
        countryView.viewController = self
        return countryView
    }()
    
    lazy var blockCompanyView:MIBlockCompanyVIew={
        let blockView=MIBlockCompanyVIew()
        blockView.viewController = self
        return blockView
    }()
    
    
    //comment it
//    lazy var manageSubscriptionView:MIManageSubscriptionView={
//        let manageView=MIManageSubscriptionView()
//        manageView.viewController = self
//        return manageView
//    }()
//
//        lazy var changePasswordView: MIAddPreferredLocation={
//            let prefferedLocation = MIAddPreferredLocation()
//            prefferedLocation.viewController = self
//            return prefferedLocation
//        }()
//    //
//        lazy var blockCompanyView: MIAddEducationView={
//            let prefferedLocation = MIAddEducationView()
//            prefferedLocation.viewController = self
//            return prefferedLocation
//        }()

    
   
    //MARK:LifeCycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
        if isFromProfileVC {
            var nav = self.navigationController?.viewControllers
            let settingMainVC = MISettingMainViewController()
            if let vc = nav?.last as? MISettingHomeViewController {
                vc.delegate = settingMainVC
                nav?.removeLast()
                nav?.append(settingMainVC)
                nav?.append(vc)
            }
            
            self.navigationController?.viewControllers = nav ?? [UIViewController()]
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CommonClass.googleAnalyticsScreen(self) //GA for Screen
        self.navigationItem.leftBarButtonItem?.title = nil
        self.navigationItem.title = self.selectedSettingType.rawValue
     //   JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

        switch self.selectedSettingType {
            case .changecountry:
                JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.CHANGE_COUNTRY)
            case .changepassword:
                JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.CHANGE_PASSWORD)
            case .profileVisibility:
                JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.PROFILE_VISIBILITY)
            case .blockCompanies:
                JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.BLOCK_COMPANIES)
            default:
                break
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
        
        if self.selectedSettingType == .changecountry {
            shouldRunProfileApi = true
        }
    }
    
    func setUpUI(){
       
        if self.selectedSettingType != .changepassword{
            self.navigationItem.rightBarButtonItem=UIBarButtonItem(title:NavigationBarButtonTitle.done, style: .done, target: self, action: #selector(MISettingHomeViewController.doneNaviButtonAction))
        }
        
        switch self.selectedSettingType {
       
        case .changecountry:
            self.view.addSubview(changeCountryView)
            self.changeCountryView.translatesAutoresizingMaskIntoConstraints=false
            NSLayoutConstraint.activate([self.changeCountryView.topAnchor.constraint(equalTo:self.view.topAnchor),self.changeCountryView.bottomAnchor.constraint(equalTo:self.view.bottomAnchor),self.changeCountryView.leadingAnchor.constraint(equalTo:self.view.leadingAnchor),self.changeCountryView.trailingAnchor.constraint(equalTo:self.view.trailingAnchor)])
            
            if CommonClass.isLoggedin() {
                MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.SETTINGS, data: ["eventValue" : CONSTANT_JOB_SEEKER_EVENT_VALUE.CHANGECOUNTRY], source: "", destination: CONSTANT_SCREEN_NAME.SETTINGS) { (success, response, error, code) in
                }
            }
            
        case .changepassword:
            self.view.addSubview(changePasswordView)
            self.changePasswordView.translatesAutoresizingMaskIntoConstraints=false
            NSLayoutConstraint.activate([self.changePasswordView.topAnchor.constraint(equalTo:self.view.topAnchor),self.changePasswordView.bottomAnchor.constraint(equalTo:self.view.bottomAnchor),self.changePasswordView.leadingAnchor.constraint(equalTo:self.view.leadingAnchor),self.changePasswordView.trailingAnchor.constraint(equalTo:self.view.trailingAnchor)])
            
            MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.SETTINGS, data: ["eventValue" : CONSTANT_JOB_SEEKER_EVENT_VALUE.CHANGEPASSWORD], source: "", destination: CONSTANT_SCREEN_NAME.SETTINGS) { (success, response, error, code) in
            }
        
            
        case .profileVisibility:
            self.view.addSubview(profileVisibleView)
            self.profileVisibleView.translatesAutoresizingMaskIntoConstraints=false
            NSLayoutConstraint.activate([self.profileVisibleView.topAnchor.constraint(equalTo:self.view.topAnchor),self.profileVisibleView.bottomAnchor.constraint(equalTo:self.view.bottomAnchor),self.profileVisibleView.leadingAnchor.constraint(equalTo:self.view.leadingAnchor),self.profileVisibleView.trailingAnchor.constraint(equalTo:self.view.trailingAnchor)])
            
        case .blockCompanies:
            self.navigationItem.rightBarButtonItem = nil
            
            self.view.addSubview(blockCompanyView)
            self.blockCompanyView.translatesAutoresizingMaskIntoConstraints=false
            NSLayoutConstraint.activate([self.blockCompanyView.topAnchor.constraint(equalTo:self.view.topAnchor),self.blockCompanyView.bottomAnchor.constraint(equalTo:self.view.bottomAnchor),self.blockCompanyView.leadingAnchor.constraint(equalTo:self.view.leadingAnchor),self.blockCompanyView.trailingAnchor.constraint(equalTo:self.view.trailingAnchor)])
//        case .managesubscription:
//            self.view.addSubview(manageSubscriptionView)
//            self.manageSubscriptionView.translatesAutoresizingMaskIntoConstraints=false
//            NSLayoutConstraint.activate([self.manageSubscriptionView.topAnchor.constraint(equalTo:self.view.topAnchor),self.manageSubscriptionView.bottomAnchor.constraint(equalTo:self.view.bottomAnchor),self.manageSubscriptionView.leadingAnchor.constraint(equalTo:self.view.leadingAnchor),self.manageSubscriptionView.trailingAnchor.constraint(equalTo:self.view.trailingAnchor)])
        default:
            break
        }
    }
    
    //MARK:Navigation Done Button Action
    @objc func doneNaviButtonAction() {
      
        switch self.selectedSettingType {
            
        case .profileVisibility:
            print(self.profileVisibleView.onOffSwitch.isOn)
            
        case .changecountry:
            if !CommonClass.isLoggedin() {
                AppUserDefaults.save(value: self.changeCountryView.selectedCountry, forKey: .PreviousCountry)
            }
            CommonClass.selectCountry(for: self.changeCountryView.selectedCountry)

//            if let index = AppDelegate.instance.splashModel.sites
//                .firstIndex(where: { $0.defaultCountryDetails.isoCode == self.changeCountryView.selectedCountry }) {
//                AppDelegate.instance.splashModel.sites[index].selected = true
//                AppDelegate.instance.site = AppDelegate.instance.splashModel.sites[index]
//
//                AppDelegate.instance.splashModel.commit()
//                AppDelegate.instance.site?.commit()
//            }

            NotificationCenter.default.post(name: .CountryChanged, object: nil, userInfo: nil)
            self.delegate?.changeCountryDone()
            
            if self.navigationController?.viewControllers.first is MISettingHomeViewController {
            
                if !self.changeCountryView.selectedCountry.isEmpty {
                    let site = AppDelegate.instance.site
                    if let countryName = site?.defaultCountryDetails.langOne?.first?.name {
                        CommonClass.googleEventTrcking("Welcome-Screen", action: "Country", label: countryName)
                    }
                    self.dismiss(animated: false, completion: nil)
                }
                
            } else {
                shouldRunProfileApi = true
                self.navigationController?.popViewController(animated: false)
            }
            
        default:
            break
        }
    }

}
