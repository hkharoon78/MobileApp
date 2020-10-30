//
//  MIManageProfileViewController.swift
//  MonsteriOS
//
//  Created by Anushka on 15/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIManageProfileViewController: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var tableViewManegeProfile: UITableView!
    var existingProfileModels = [MIExistingProfileInfo]()
    
    
    //MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetUp()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = ControllerTitleConstant.manageProfile

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }
    
    func initialSetUp() {
        
        self.title = ControllerTitleConstant.manageProfile

        self.tableViewManegeProfile.delegate = self
        self.tableViewManegeProfile.dataSource = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createButtonAction))

        self.tableViewManegeProfile.register(UINib(nibName: "MIManageProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "MIManageProfileTableViewCell")
        
        let site = AppDelegate.instance.site
        if let countryIsoCode = site?.defaultCountryDetails.isoCode {
            self.existingProfileModels = self.existingProfileModels.filter({$0.countryIsoCode.lowercased() == countryIsoCode.lowercased()})
        }

        
    }
    

    
    //MARK: - Helper Methods
    @objc func createButtonAction() {

        if self.existingProfileModels.count >= 5 {
           self.toastView(messsage: "You have already created 5 Profiles. To continue creating this alert you need to delete an existing profile.", isErrorOccured: true)
            // AKAlertController.alert("Alert!", message: "You have already created 5 Profiles. To continue creating this alert you need to delete an existing profile.")
        } else {
            let vc = MICreateProfileVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }

}

//MARK:- table view delegate and data source
extension MIManageProfileViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // guard self.existingProfileModels != nil else {return 0}
        return self.existingProfileModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "MIManageProfileTableViewCell") as! MIManageProfileTableViewCell
        
        let row = self.existingProfileModels[indexPath.row]

        if row.title.isEmpty {
            cell.lblManageProfileName.text = "Profile title not available"
        } else {
            cell.lblManageProfileName.text = row.title
        }
        
        
        cell.btnDeleteProfile.isHidden = false
        cell.btnActiveProfile.isHidden = true
        
        if self.existingProfileModels.count  <= 1 {
            cell.btnDeleteProfile.isHidden = true
          
            cell.btnActiveProfile.isHidden = false
            cell.switchOnOffProfile.isHidden = true
        }
        cell.btnDeleteProfile.addTarget(self, action: #selector(btnDeleteProfilePressed(_:)), for: .touchUpInside)


       // let active =  row.active
        cell.switchOnOffProfile.onTintColor = AppTheme.defaltBlueColor
        cell.switchOnOffProfile.setOn(row.active, animated: false)
        cell.switchOnOffAction={() in
            if !row.active{
                self.activeProfile(row.id)
            } else {
                
                tableView.reloadData()
                self.showAlert(title: "Alert!", message: "You can’t deactivate an active profile. However, you can choose to make one of the following profiles active.")
            }
        }
       // cell.switchOnOffProfile.addTarget(self, action: #selector(switchOnOff(_:)), for: .touchUpInside)

        return cell
        
    }
    
    @objc func btnDeleteProfilePressed(_ sender: UIButton) {
        
        let indexPath = sender.tableViewIndexPath(self.tableViewManegeProfile)!
        let row = self.existingProfileModels[indexPath.row]
        let profileId =  row.id
        let active = row.active
        
        if !active  && self.existingProfileModels.count >= 1 {
            self.showPopUpView(title: "Delete Profile", message: "Are you sure ? Deleting a profile means you won’t be able to apply to a job and recruiters won’t be able to contact you.", primaryBtnTitle: "Cancel", secondaryBtnTitle: "OK") { (isPrimarBtnClicked) in
                if !isPrimarBtnClicked {
                    self.existingProfileModels = self.existingProfileModels.filter({ $0.id != profileId })
                    self.tableViewManegeProfile.reloadData()
                    
                    self.deleteProfile(profileId)
                }
            }
            
            
       //     let vPopup = MIJobPreferencePopup.popup()
//            vPopup.closeBtn.isHidden = true
//            vPopup.setViewWithTitle(title: "Delete Profile", viewDescriptionText:  "Are you sure? Deleting a profile means you won’t be able to apply to a job and recruiters won’t be able to contact you.", or: "", primaryBtnTitle: "Cancel", secondaryBtnTitle:"OK")
//            vPopup.completionHandeler = {
//
//            }
//            vPopup.cancelHandeler = {
//                self.existingProfileModels = self.existingProfileModels.filter({ $0.id != profileId })
//                self.tableViewManegeProfile.reloadData()
//
//                self.deleteProfile(profileId)
//
//            }
//            vPopup.addMe(onView: self.view, onCompletion: nil)
//
            
//            AKAlertController.alert("Delete Profile", message: "Are you sure? Deleting a profile means you won’t be able to apply to a job and recruiters won’t be able to contact you.", buttons: ["Cancel", "OK"]) { (_, _, index) in
//                if index == 1 {
//
//                    self.existingProfileModels = self.existingProfileModels.filter({ $0.id != profileId })
//                    self.tableViewManegeProfile.reloadData()
//
//                    self.deleteProfile(profileId)
//
//                }
//            }
        } else {
            self.showAlert(title: "Alert!", message: "At least one profile needs to be active at a time." )
        }
        
    }
    
    @objc func switchOnOff(_ sender: UISwitch){
     
        
        if let indexPath = sender.tableViewIndexPath(self.tableViewManegeProfile) {
            let row = self.existingProfileModels[indexPath.row]
            let active = row.active
            let profileId =  row.id
            
            if !active {
                
    //            self.existingProfileModels = self.existingProfileModels.map({ (obj) -> MIExistingProfileInfo in
    //                obj.active = false
    //                return obj
    //            })
             //   self.existingProfileModels[indexPath.row].active = true
                
               // let rows = self.tableViewManegeProfile.numberOfRows(inSection: indexPath.section)
    //            for row in 0..<rows {
    //
    //                if let cell = self.tableViewManegeProfile.cellForRow(at: IndexPath(row: row, section: indexPath.section)) as? MIManageProfileTableViewCell {
    //                    cell.switchOnOffProfile.setOn(false, animated: false)
    //                }
    //            }
          //      sender.isSelected = true

                self.activeProfile(profileId)
            } else {
                self.tableViewManegeProfile.reloadData()
                self.showAlert(title: "Alert!", message: "You can’t deactivate an active profile. However, you can choose to make one of the following profiles active.")
                //sender.isOn = true
                
                return

            }
        }
    }
    
}

//MARK:- API
extension MIManageProfileViewController {
    
    func activeProfile(_ id: Int) {
       
        MIActivityLoader.showLoader()
        
        MIApiManager.hitManageActiveProfile(id) { (success, response, error, code) in

            DispatchQueue.main.async {
                MIActivityLoader.hideLoader()
                if error != nil{
                    self.tableViewManegeProfile.reloadData()
                }
                
                if let responseData = response as? JSONDICT {
                    
                    if let successMessage = responseData["successMessage"] as? String {
                        self.toastView(messsage: successMessage,isErrorOccured:false)
                        for item in self.existingProfileModels {
                            if item.id == id{
                                item.active = true
                            }else{
                                item.active = false
                            }
                        }
                        shouldRunProfileApi = true
                        
                    } else if let errorMessage = responseData["message"] as? String {
                        self.toastView(messsage: errorMessage)
                    } else {
                        self.toastView(messsage: "We have activated your Profile and now you search, find and apply to jobs.",isErrorOccured:false)
                    }
                    
                    self.tableViewManegeProfile.reloadData()
                    
                } else {
                    if (!MIReachability.isConnectedToNetwork()){
                        self.toastView(messsage: ExtraResponse.noInternet)
                        self.tableViewManegeProfile.reloadData()
                    }
                }
            }
            
        }

        
    }
    
    func deleteProfile(_ id: Int){
        MIActivityLoader.showLoader()
        
        MIApiManager.hitManageDeleteProfile(id, completion: { (success, response, error, code) in

            DispatchQueue.main.async {
                MIActivityLoader.hideLoader()

                if let responseData = response as? JSONDICT {
                    
                    if let successMessage = responseData["successMessage"] as? String {
                        self.toastView(messsage: successMessage,isErrorOccured:false)
                    } else if let errorMessage = responseData["errorMessage"] as? String {
                        self.toastView(messsage: errorMessage)
                    } else {
                        self.toastView(messsage: "Your Profile has been deleted successfully.",isErrorOccured:false)
                    }
                    shouldRunProfileApi = true
                    
                    self.tableViewManegeProfile.reloadData()
                } else {
                    if (!MIReachability.isConnectedToNetwork()){
                        self.toastView(messsage: ExtraResponse.noInternet)
                        //self.tableViewManegeProfile.reloadData()
                    }
                }
            }
        })
        
    }
    
}

