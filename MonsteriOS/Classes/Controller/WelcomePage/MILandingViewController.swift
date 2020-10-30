//
//  MILandingViewController.swift
//  MonsteriOS
//
//  Created by Rakesh on 24/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MILandingViewController: UIViewController {
    
    @IBOutlet weak var btnCountry: UIButton!
    @IBOutlet var search_txtField : UITextField!
    
    @IBOutlet var register_Btn : UIButton!
    @IBOutlet var loginBtn : UIButton!
    
    var applyLoginFlag=false{
        didSet{
            let vc = MILoginViewController.newInstance
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        for family in UIFont.familyNames {
//            print("\(family)")
//
//            for name in UIFont.fontNames(forFamilyName: family) {
//                print("\(name)")
//            }
//        }
        
        search_txtField.attributedPlaceholder = NSAttributedString(string: "Search jobs by skills, title, company…", attributes:[NSAttributedString.Key.foregroundColor: UIColor.init(hex: "B8C5D5"), NSAttributedString.Key.font : SourceSansPro.Regular.ofSize(14)])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        CommonClass.googleAnalyticsScreen(self) //GA for Screen
        self.title = ""
        self.navigationItem.hidesBackButton = true
        self.navigationController?.isNavigationBarHidden = true
        
        //Set country Name
        let site = AppDelegate.instance.site
        self.btnCountry.isHidden = false
        if let countryName = site?.defaultCountryDetails.langOne?.first?.name {
            self.btnCountry.setTitle(countryName.uppercased() + "  ", for: .normal)
        } else {
            self.btnCountry.isHidden = true
        }
        navigateVc=nil
        navigateAction = .none
        navigateStartValue=nil
        
        MIUserModel.resetUserResumeData()
        
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)
        
        MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.SPLASH_SCREEN, data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.LANDING], destination: CONSTANT_SCREEN_NAME.WELCOME) { (success, response, error, code) in
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.title = ""
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.hidesBackButton = false
    }
            
    //MARK: - IBAction Methods
    @IBAction func loginBtnClicked(_ sender : UIButton) {
        CommonClass.googleEventTrcking("welcome-screen", action: "login", label: "")
        let vc = MILoginViewController.newInstance
        self.navigationController?.pushViewController(vc, animated: true)
        
        MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.LOGIN, data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK], destination: CONSTANT_SCREEN_NAME.WELCOME) { (success, response, error, code) in
        }
        
    }
    
    @IBAction func registertionBtnClicked(_ sender : UIButton) {
        
        CommonClass.googleEventTrcking("welcome-screen", action: "register", label: "")
        let vc = MIBasicRegisterVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
        MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.REGISTER, data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK], destination: CONSTANT_SCREEN_NAME.WELCOME) { (success, response, error, code) in
        }
        
    }
    
    @IBAction func btnCountryPressed(_ sender: UIButton) {
        
        let vc=MISettingHomeViewController()
        vc.selectedSettingType = .changecountry
        
        let nav = MINavigationViewController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        
        self.navigationController?.present(nav, animated: true, completion: nil)
        vc.title = "Select Country"
        
        //        MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.CHANGE_COUNTRY, data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK], destination: CONSTANT_SCREEN_NAME.WELCOME) { (success, response, error, code) in
        //        }
        
    }
    
}

extension MILandingViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        CommonClass.googleEventTrcking("welcome-Screen", action: "search", label: "")
        let vc = MISearchViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
        MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.SEARCH_BAR, data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK], destination: CONSTANT_SCREEN_NAME.WELCOME) { (success, response, error, code) in
        }
        
        return false
    }
}
