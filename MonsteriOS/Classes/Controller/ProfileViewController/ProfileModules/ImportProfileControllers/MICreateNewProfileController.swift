//
//  MICreateNewProfileController.swift
//  MonsteriOS
//
//  Created by Piyush on 21/02/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MICreateNewProfileController: MIBaseViewController {

    @IBOutlet weak var btnExistingProfile: UIButton!
    @IBOutlet weak var btnCreateNewProfile: UIButton!
    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var lblSelectExisting: UILabel!
    @IBOutlet weak var imgViewRightDirection: UIImageView!
    
    private var defaultTitle = "Select existing profile"
    var arrExistingProfile = [MIExistingProfileInfo]()
    var info:MIExistingProfileInfo?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Create your Profile"

    }
    
    func setUI() {
        
        self.btnCreate.roundCorner(0, borderColor: nil, rad: CornerRadius.btnCornerRadius)
        self.setBtnSelection(btnCreateExistProfileSelected: true)
        self.lblSelectExisting.text = defaultTitle
//        self.callApi()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
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
    
    @IBAction func selectExistingProfileClicked(_ sender: UIButton) {
        if self.btnExistingProfile.isSelected == true {
            let vc = MISelectExistingProfileViewController()
            vc.arrExistingProfile = self.arrExistingProfile
            vc.delegate = self
          //  vc.objPreviousController =
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func profileImportClicked(_ sender: UIButton) {
        if self.btnExistingProfile == sender {
            self.setBtnSelection(btnCreateExistProfileSelected: true)
        } else {
            self.setBtnSelection(btnCreateExistProfileSelected: false)
        }
    }
    
    @IBAction func createProfileClicked(_ sender: UIButton) {
        
        if self.btnExistingProfile.isSelected {
            if let existProfileInfo = self.info {
                self.startActivityIndicator()
                let param = [
                    "profileId" : "\(existProfileInfo.id)"
                    ] as [String : Any]
                //profileId: "\(existProfileInfo.id)" ,
                MIApiManager.callImportProfile(param:  param){ [weak wSelf = self] (isSuccess, response, error, code) in
                    DispatchQueue.main.async {
                        self.stopActivityIndicator()
                        if let res = response as? [String:Any] {
                            if isSuccess {
                                if let iso = AppDelegate.instance.site?.defaultCountryDetails.isoCode {
                                    //MARK:- Country Changed Successfully
                                    AppUserDefaults.save(value: iso, forKey: .PreviousCountry)
                                }

                                let id = res.intFor(key: "id")
                                UserDefaults.standard.set(id, forKey:"profileId")
                                
                                if let errorMsg = res["errorMessage"] as? String,!errorMsg.isEmpty {
                                    wSelf?.showAlert(title: "", message: res.stringFor(key: "errorMessage"),isErrorOccured:true)

                                    //AKAlertController.alert("Alert", message: res.stringFor(key: "errorMessage"))
                                } else {
                                  //  wSelf?.showAlert(title: "", message: "Your profile imported Successfully",isErrorOccured:false)
                                    
                                    wSelf?.showAlert(title: "", message: "Your profile imported Successfully", isErrorOccured: false, successComplitionHandler: {
                                        wSelf?.navigationController?.popViewController(animated: true)

                                    })
                                    
                                }
                                
                            } else {
                                wSelf?.showAlert(title: "", message: res.stringFor(key: "errorMessage"),isErrorOccured:true)

                           //     AKAlertController.alert("Alert", message: res.stringFor(key: "errorMessage"))
                            }
                        }
                        
                    }
                }
            } else {
                self.showAlert(title: "", message: "Please select an existing profile")
            }
        } else {
            self.startActivityIndicator()
            MIApiManager.callCreateEmptyProfile{ [weak wSelf = self] (isSuccess, response, error, code) in
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    if let res = response as? [String:Any] {
                        if isSuccess {
                            if let iso = AppDelegate.instance.site?.defaultCountryDetails.isoCode {
                                //MARK:- Country Changed Successfully
                                AppUserDefaults.save(value: iso, forKey: .PreviousCountry)
                            }
                       //     self.cleverTapEventforAddNewProfile()
                            let id = res.intFor(key: "id")
                            UserDefaults.standard.set(id, forKey:"profileId")
                            if let errorMsg = res["errorMessage"] as? String,!errorMsg.isEmpty {
                                wSelf?.showAlert(title: "", message: res.stringFor(key: "errorMessage"),isErrorOccured:true)

                              //  AKAlertController.alert("Alert", message: res.stringFor(key: "errorMessage"))
                            } else {
                                wSelf?.showAlert(title: "", message: "New profile created successfully",isErrorOccured:false)
                                wSelf?.navigationController?.popViewController(animated: true)
                            }
                            
                        } else {
                            wSelf?.showAlert(title: "", message: res.stringFor(key: "errorMessage"),isErrorOccured:true)

                            //AKAlertController.alert("Alert", message: res.stringFor(key: "errorMessage"))
                        }
                    }
                }
            }
        }
        
    }
    

    func setBtnSelection(btnCreateExistProfileSelected:Bool) {
        if btnCreateExistProfileSelected == true {
            self.btnExistingProfile.isSelected  = true
            self.btnCreateNewProfile.isSelected = false
            self.lblSelectExisting.textColor = UIColor(red: 33, green: 43, blue: 54)
            self.imgViewRightDirection.image = UIImage(named: "right-arrow")
        } else {
            self.btnCreateNewProfile.isSelected = true
            self.btnExistingProfile.isSelected  = false
            self.lblSelectExisting.textColor = UIColor.lightGray
            self.imgViewRightDirection.image = UIImage(named: "right_direction_arrow")

        }
    }
}

extension MICreateNewProfileController:MISelectExistingProfileViewControllerDelegate {
    
    func profileSelected(info: MIExistingProfileInfo) {
        self.lblSelectExisting.text = info.countryName
        self.navigationController?.popViewController(animated: true)
        self.info = info
    }
    
    
}
