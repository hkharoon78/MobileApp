//
//  MISelectExistingProfileViewController.swift
//  MonsteriOS
//
//  Created by Piyush on 22/02/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

protocol MISelectExistingProfileViewControllerDelegate:class {
    func profileSelected(info:MIExistingProfileInfo)
}

class MISelectExistingProfileViewController: MIBaseViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tblView: UITableView!
    var arrExistingProfile = [MIExistingProfileInfo]()
    weak var delegate:MISelectExistingProfileViewControllerDelegate?
    private var cellId = "existingProfileCell"
    var isFromManageProfile = false
    var objPreviousController = UIViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Select an existing profile"
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

    }

    func setUI() {
        self.tblView.register(UINib(nibName: "MISelectExistingProfileCell", bundle: nil), forCellReuseIdentifier: cellId)
        self.tblView.tableFooterView = UIView()
        self.tblView.reloadData()
//        self.arrExistingProfile = self.arrExistingProfile.filter({$0.active == true})
    }
 
    @IBAction func continueClicked(_ sender: UIButton) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrExistingProfile.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tblView.dequeueReusableCell(withIdentifier: cellId) as? MISelectExistingProfileCell {
            cell.show(info: arrExistingProfile[indexPath.row])
            return cell
        }
        let cell = UITableViewCell(style: .default, reuseIdentifier: "default")
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFromManageProfile {
            shouldRunProfileApi = true
            self.callImportProfile(info: arrExistingProfile[indexPath.row])
        }
        self.delegate?.profileSelected(info: arrExistingProfile[indexPath.row])
    }
    
    func callImportProfile(info:MIExistingProfileInfo) {
        self.startActivityIndicator()
        let param = [
            "profileId" : "\(info.id)"
            ] as [String : Any]
        
        MIApiManager.callImportProfile(param:  param){ [weak wSelf = self] (isSuccess, response, error, code) in
            DispatchQueue.main.async {
                self.stopActivityIndicator()
                if let res = response as? [String:Any] {
                    if isSuccess {
//                        if let iso = AppDelegate.instance.site?.defaultCountryDetails.isoCode {
//                            //MARK:- Country Changed Successfully
//                            AppUserDefaults.save(value: iso, forKey: .PreviousCountry)
//                        }
                        
                        if let errorMsg = res["errorMessage"] as? String,!errorMsg.isEmpty {
                            wSelf?.showAlert(title: "", message: res.stringFor(key: "errorMessage"),isErrorOccured:true)

                            //AKAlertController.alert("Alert", message: res.stringFor(key: "errorMessage"))
                        } else {
                            if let iso = AppDelegate.instance.site?.defaultCountryDetails.isoCode {
                                //MARK:- Country Changed Successfully
                                AppUserDefaults.save(value: iso, forKey: .PreviousCountry)
                            }

                            let id = res.intFor(key: "id")
                            UserDefaults.standard.set(id, forKey:"profileId")
                            wSelf?.showAlert(title: "", message: "Your profile imported Successfully",isErrorOccured:false)
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.8, execute: {
                                if self.tabBarController == nil {
                                    
                                    
                                    //self.objPreviousController.navigationController?.popViewController(animated: false)
                                        //self.objPreviousController.navigationController?.popToRootViewController(animated: false)
                                    //self.objPreviousController.navigationController?.tabBarController?.selectedIndex = 2
                                    self.dismiss(animated: true, completion: nil)
                                    if let settingVc=self.objPreviousController as? MISettingMainViewController{
                                        settingVc.navigateToProfile=true
                                    }
                                    

                                }else{
                                    if let nav = wSelf?.navigationController?.viewControllers {
                                        for vc in nav {
                                            if let _ = vc as? MIProfileViewController{
                                                self.navigationController?.popToViewController(vc, animated: true)
                                            }
                                            else if let _ = vc as? MISettingMainViewController{
                                                self.dismiss(animated: true, completion: nil)
                                                //                                            self.navigationController?.popToViewController(vc, animated: true)
                                            }
                                        }
                                    }
                                }

                            })
                            MIApiManager.getOldSystemCookiesData()
                        }
                        
                    } else {
                       wSelf?.showAlert(title: "", message: res.stringFor(key: "errorMessage"),isErrorOccured:true)

                        // AKAlertController.alert("Alert", message: res.stringFor(key: "errorMessage"))
                    }
                }
                
            }
        }
    }

    
}
