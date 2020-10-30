//
//  MICreateProfileVC.swift
//  MonsteriOS
//
//  Created by Anushka on 12/03/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MICreateProfileVC: MIBaseViewController {
    
    @IBOutlet weak var tableViewCreateProfile: UITableView!
    
    let profileArr = ["Create a new profile using details of an exisiting profile", "Create a fresh profile"]
    var arrExistingProfile = [MIExistingProfileInfo]()
    var objPreviousController = UIViewController()
    //MARK:-view Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetUp()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Create new profile"
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""

        if (self.isBeingDismissed || self.isMovingFromParent) {
            let oldIso = AppUserDefaults.value(forKey: .PreviousCountry, fallBackValue: "").stringValue
            guard let iso = AppDelegate.instance.site?.defaultCountryDetails.isoCode,
                !iso.isEmpty//,
                //!oldIso.isEmpty
                else { return }
            
            if oldIso != iso {
                CommonClass.selectCountry(for: oldIso)
//                if let index = AppDelegate.instance.splashModel.sites.firstIndex(where: { $0.defaultCountryDetails.isoCode == oldIso }) {
//                    AppDelegate.instance.splashModel.sites[index].selected = true
//                    AppDelegate.instance.site = AppDelegate.instance.splashModel.sites[index]
//
//                    AppDelegate.instance.splashModel.commit()
//                    AppDelegate.instance.site?.commit()
//
//                    NotificationCenter.default.post(name: .CountryChanged, object: nil, userInfo: nil)
//                }
            }
            
        }
        
    }
    
    
    func initialSetUp(){
        
        //self.title = "Create new profile"
        if self.tabBarController == nil {
            self.navigationItem.leftBarButtonItem=UIBarButtonItem(image: #imageLiteral(resourceName: "back_bl"), style: .done, target: self, action:#selector(MICreateProfileVC
                .backButtonAction(_:)))

        }

        self.tableViewCreateProfile.delegate = self
        self.tableViewCreateProfile.dataSource = self
        
        self.tableViewCreateProfile.register(UINib(nibName: "MICreateProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "MICreateProfileTableViewCell")
        
    }

    @objc func backButtonAction(_ sender:UIBarButtonItem){
        let oldIso = AppUserDefaults.value(forKey: .PreviousCountry, fallBackValue: "").stringValue
        guard let iso = AppDelegate.instance.site?.defaultCountryDetails.isoCode,
            !iso.isEmpty//,
            //!oldIso.isEmpty
            else { return }
        
        if oldIso != iso {
            CommonClass.selectCountry(for: oldIso)

//            if let index = AppDelegate.instance.splashModel.sites.firstIndex(where: { $0.defaultCountryDetails.isoCode == oldIso }) {
//                AppDelegate.instance.splashModel.sites[index].selected = true
//                AppDelegate.instance.site = AppDelegate.instance.splashModel.sites[index]
//
//                AppDelegate.instance.splashModel.commit()
//                AppDelegate.instance.site?.commit()
//
//                NotificationCenter.default.post(name: .CountryChanged, object: nil, userInfo: nil)
//            }
        }
        self.dismiss(animated: true, completion: nil)
        
    }

}

//MARK:- tableview delegate and data source
extension MICreateProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.profileArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MICreateProfileTableViewCell") as! MICreateProfileTableViewCell
        cell.accessoryButtonClicked={[weak self] in
            
             self?.createProfile(indexPath: indexPath)
        }
        cell.lblProfileName.text = self.profileArr[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        self.createProfile(indexPath: indexPath)

    }
    
    func createProfile(indexPath:IndexPath){
        switch indexPath.row {
        case 0:
            if arrExistingProfile.count >= 1 {
                let vc = MISelectExistingProfileViewController()
                vc.arrExistingProfile = self.arrExistingProfile
                vc.isFromManageProfile = true
                vc.objPreviousController = self.objPreviousController
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                self.callExistingProfileApi()
            }
            
        case 1:
            let vPopup = MIJobPreferencePopup.popup()
            vPopup.setViewWithTitle(title: "", viewDescriptionText: "Are you sure want to create a new profile ?", or: "", primaryBtnTitle: "Create", secondaryBtnTitle: "Cancel")
            vPopup.delegate = self
            vPopup.closeBtn.isHidden = true
            vPopup.addMe(onView: self.view, onCompletion: nil)
            
//            DispatchQueue.main.async {
//                AKAlertController.alert("Alert", message: "Are you sure want to create a new profile?", buttons: ["Cancel","Create"]) { (_, _, index) in
//                    if index == 1 {
//                        self.createNewProfile()
//                    }
//                }
//            }
            
            
        default:
            break
        }

    }

    
}

extension MICreateProfileVC: JobPreferencePopUpDelegate {
   
    func optionCompleteIgnoredSelected(popSelection: PopUpOptionSelection, popup: MIPopupView) {
        if popSelection == .Completed {
            self.createNewProfile()
        }
    }
    
}

//MARK:- API
extension MICreateProfileVC {
    
    func createNewProfile() {
        self.startActivityIndicator()
        
        MIApiManager.callCreateEmptyProfile{ [weak wSelf = self] (isSuccess, response, error, code) in
            
            DispatchQueue.main.async {
                self.stopActivityIndicator()
                if let res = response as? [String:Any] {
                    
                    if let errorMsg = res["errorMessage"] as? String,!errorMsg.isEmpty {
                        wSelf?.showAlert(title: "", message:res.stringFor(key: "errorMessage") ,isErrorOccured:true)

                       // AKAlertController.alert("Alert", message: res.stringFor(key: "errorMessage"))
                    } else {
                        if let iso = AppDelegate.instance.site?.defaultCountryDetails.isoCode {
                            //MARK:- Country Changed Successfully
                            AppUserDefaults.save(value: iso, forKey: .PreviousCountry)
                        }

                        let id = res.intFor(key: "id")
                        UserDefaults.standard.set(id, forKey:"profileId")
                        
                        wSelf?.showAlert(title: "", message: "New profile created successfully",isErrorOccured:false)
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.8, execute: {
                            if self.tabBarController == nil {
                                self.dismiss(animated: true, completion: nil)
                                if let settingVc=self.objPreviousController as? MISettingMainViewController{
                                    settingVc.navigateToProfile=true
                                }
                                //                                self.dismiss(animated: true, completion: nil)
//                                self.objPreviousController.navigationController?.popViewController(animated: false)
//                                self.objPreviousController.tabBarController?.selectedIndex = 2
                            }else{
                                if let nav = wSelf?.navigationController?.viewControllers {
                                    for vc in nav {
                                        shouldRunProfileApi = true
                                        
                                        if let _ = vc as? MIProfileViewController{
                                            self.navigationController?.popToViewController(vc, animated: true)
                                        }
                                        else if let _ = vc as? MISettingMainViewController {
                                            self.navigationController?.popToViewController(vc, animated: true)
                                        }
                                    }
                                }
                            }

                        })
                            MIApiManager.getOldSystemCookiesData()

                    }
                }else{
                    if let err = error {
                        self.handleAPIError(errorParams: response, error: err)

                    }
                }
            }
        }
        
    }
    
    func callExistingProfileApi() {
     
        self.startActivityIndicator()
       
        MIApiManager.callGetExistingProfile{ [weak wSelf = self] (isSuccess, response, error, code) in
           
            DispatchQueue.main.async {
               
                self.stopActivityIndicator()
                if let err = error {
                    self.handleAPIError(errorParams: response, error: err)
                    return
                }
                wSelf?.arrExistingProfile.removeAll()
               
                
                if let res = response as? [[String:Any]],res.count > 0 {
                    wSelf?.arrExistingProfile = MIExistingProfileInfo.modelsFromDictionaryArray(array: res)
                }
                
                if let `self` = wSelf, self.arrExistingProfile.count > 0 {
                    
                    let vc = MISelectExistingProfileViewController()
                    vc.arrExistingProfile = self.arrExistingProfile
                    vc.isFromManageProfile = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
        }
    }
    
}



