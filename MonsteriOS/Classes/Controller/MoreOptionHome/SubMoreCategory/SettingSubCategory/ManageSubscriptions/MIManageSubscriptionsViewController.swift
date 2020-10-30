//
//  MIManageSubscriptionsViewController.swift
//  MonsteriOS
//
//  Created by Anushka on 19/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIManageSubscriptionsViewController: MIBaseViewController {

    //MARK:- IBoutlet
    @IBOutlet weak var tableViewManageSubscriptions: UITableView!
    
    var selectedIndex = 8 //9// for next phase
    
    var manageSubDic = [
        "Recommended_jobs"            : true,
        "Job_alert"                   : true,
        "Application_status_update"   : true,
        "Profile_views"               : true,
        "Improve_profile"             : true,
        "Recruiter_communications"    : true,
        "Promotion"                   : true,
        "Career_advice"               : true
    ]
    

    //MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetUp()
        
    }
    
    func initialSetUp(){
        
        self.tableViewManageSubscriptions.delegate = self
        self.tableViewManageSubscriptions.dataSource = self
        
        self.tableViewManageSubscriptions.register(UINib(nibName: "MIManageSubsTopTableViewCell", bundle: nil), forCellReuseIdentifier: "MIManageSubsTopTableViewCell")
        self.tableViewManageSubscriptions.register(UINib(nibName: "MIManageSubsNotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "MIManageSubsNotificationTableViewCell")
        self.tableViewManageSubscriptions.register(UINib(nibName: "MIManageSubsNotificationDesTableViewCell", bundle: nil), forCellReuseIdentifier: "MIManageSubsNotificationDesTableViewCell")
        self.tableViewManageSubscriptions.register(UINib(nibName: "MIManageSubsNotificationSaveTableViewCell", bundle: nil), forCellReuseIdentifier: "MIManageSubsNotificationSaveTableViewCell")
        self.tableViewManageSubscriptions.register(UINib(nibName: "MIManageSubsFooterTableViewCell", bundle: nil), forCellReuseIdentifier: "MIManageSubsFooterTableViewCell")
        self.tableViewManageSubscriptions.register(UINib(nibName: "MIManageSubsReadMoreTableViewCell", bundle: nil), forCellReuseIdentifier: "MIManageSubsReadMoreTableViewCell")
        
       self.getEmailPreferencesResponse()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CommonClass.googleAnalyticsScreen(self) //GA for Screen
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

        self.navigationItem.title = ControllerTitleConstant.manageSubscription
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    } 
    
}

//MARK:- table view delegate and data source
extension MIManageSubscriptionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return selectedIndex
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 1:
            return 4
        case 2:
            return 3
        case 3:
            return 0 //hide recruiter Communication
        default:
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
       
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MIManageSubsTopTableViewCell") as! MIManageSubsTopTableViewCell
            return cell
            
        case 1:
            switch indexPath.row {
            case 1, 2, 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "MIManageSubsNotificationTableViewCell") as! MIManageSubsNotificationTableViewCell
                
                cell.switchOnOff.onTintColor = AppTheme.defaltBlueColor
                cell.switchOnOff.addTarget(self, action: #selector(switchOnOffPressed(_:)), for: .valueChanged)
    
                switch indexPath.row{
                case 1:
                    cell.lblNotification.text = ManageSubscriptions.recommendedJobs
                    cell.switchOnOff.isOn = self.manageSubDic["Recommended_jobs"]!
                case 2:
                    cell.lblNotification.text = ManageSubscriptions.jobAlert
                    cell.switchOnOff.isOn = self.manageSubDic["Job_alert"]!
                default:
                    cell.lblNotification.text = ManageSubscriptions.applicationStatus
                    cell.switchOnOff.isOn = self.manageSubDic["Application_status_update"]!
                }
                
                return cell
                
            default:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "MIManageSubsNotificationDesTableViewCell") as! MIManageSubsNotificationDesTableViewCell
                
                cell.lblNotificationDes.text! = ManageSubscriptions.jobNotification
                
                return cell
            }
        
        case 2:
            switch indexPath.row {
            case 1, 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "MIManageSubsNotificationTableViewCell") as! MIManageSubsNotificationTableViewCell
              
                cell.switchOnOff.onTintColor = AppTheme.defaltBlueColor
                cell.switchOnOff.addTarget(self, action: #selector(switchOnOffPressed(_:)), for: .valueChanged)

                
                switch indexPath.row{
                case 1:
                    cell.lblNotification.text = ManageSubscriptions.profileViews
                    cell.switchOnOff.isOn = self.manageSubDic["Profile_views"]!
                default:
                    cell.lblNotification.text = ManageSubscriptions.improveProfileStrength
                    cell.switchOnOff.isOn = self.manageSubDic["Improve_profile"]!
                }
                
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "MIManageSubsNotificationDesTableViewCell") as! MIManageSubsNotificationDesTableViewCell
                cell.lblNotificationDes.text = ManageSubscriptions.profileRelatedNotification
                return cell
            }
        
        case 3, 4, 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MIManageSubsNotificationTableViewCell") as! MIManageSubsNotificationTableViewCell
           
            cell.switchOnOff.onTintColor = AppTheme.defaltBlueColor
            cell.switchOnOff.addTarget(self, action: #selector(switchOnOffPressed(_:)), for: .valueChanged)

            
            switch indexPath.section{
            case 3:
                cell.lblNotification.text = ManageSubscriptions.recruiterCommunications
                cell.switchOnOff.isOn = self.manageSubDic["Recruiter_communications"]!
            case 4:
                cell.lblNotification.text = ManageSubscriptions.promotionsAndSpecialOffers
                cell.switchOnOff.isOn = self.manageSubDic["Promotion"]!
            default:
                cell.lblNotification.text = ManageSubscriptions.careerAdviceAndTips
                cell.switchOnOff.isOn = self.manageSubDic["Career_advice"]!
            }
            
            return cell
            
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MIManageSubsNotificationTableViewCell") as! MIManageSubsNotificationTableViewCell
            
             cell.switchOnOff.onTintColor = AppTheme.defaltBlueColor
             cell.switchOnOff.addTarget(self, action: #selector(switchOnOffPressed(_:)), for: .valueChanged)
            
            cell.switchOnOff.isOn = false
            
            cell.lblNotification.text = ManageSubscriptions.deactivateAc
            
            return cell
        
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MIManageSubsNotificationSaveTableViewCell") as! MIManageSubsNotificationSaveTableViewCell
            
            cell.btnSave.backgroundColor = AppTheme.defaultGreenColor
            cell.btnSave.addTarget(self, action: #selector(btnSavePressed(_:)), for: .touchUpInside)
            return cell
                    
        
        case 8:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MIManageSubsFooterTableViewCell") as! MIManageSubsFooterTableViewCell
            

            cell.btnMore.addTarget(self, action: #selector(btnReadMorePressed(_:)), for: .touchUpInside)
            cell.btnMore.tag = indexPath.section
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MIManageSubsReadMoreTableViewCell") as! MIManageSubsReadMoreTableViewCell
            
            cell.btnLess.tag = indexPath.section
            
            cell.lblDeactivationMsg.text = ManageSubsCellConstant.readMore
            cell.btnDeactivate.addTarget(self, action: #selector(btnDeleteDeactivatePressed(_:)), for: .touchUpInside)
            cell.btnDelete.addTarget(self, action: #selector(btnDeleteDeactivatePressed(_:)), for: .touchUpInside)
            cell.btnLess.addTarget(self, action: #selector(btnLessPressed(_:)), for: .touchUpInside)
            cell.btnProceed.addTarget(self, action: #selector(btnProceedPressed(_:)), for: .touchUpInside)

            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
        switch section{
        case 0, 3, 7:
            return 0
        default:
            return 50.0
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headerArr = ["", "Jobs Notification", "Profile Related Notifications", "Recruiter Communications", "Career Advice and Tips", "Promotions & Special Offers", ManageSubscriptions.deactivateAcTitle, "",  ""]
        return headerArr[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(hexString: "F4F6F8")//UIColor(red: 244/255, green: 246/255, blue: 248/255, alpha: 0.1)
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor("7f8e94")
        header.textLabel?.font = UIFont.customFont(type: .Regular, size: 16)
    }
    
    
    
    @objc func switchOnOffPressed(_ sender: UISwitch){

        var lbl = ""
        if sender.isOn {
            lbl = "toggle_on"
        } else {
            lbl = "toggle_off"
        }
       
        let index = sender.tableViewIndexPath(self.tableViewManageSubscriptions)
       
        switch index?.section {
       
        case 1:
          
            switch index?.row {
            case 1:
                self.manageSubDic["Recommended_jobs"] = sender.isOn
                CommonClass.googleEventTrcking("settings_screen", action: "manage_subscription", label: "\("recommended_jobs_" + lbl)" ) //GA
            case 2:
                self.manageSubDic["Job_alert"] = sender.isOn
                CommonClass.googleEventTrcking("settings_screen", action: "manage_subscription", label: "\("job_alert_" + lbl)" ) //GA
            case 3:
                self.manageSubDic["Application_status_update"] = sender.isOn
                CommonClass.googleEventTrcking("settings_screen", action: "manage_subscription", label: "\("application_status_update_" + lbl)" ) //GA
            default:
                break
            }
            
        case 2:
            switch index?.row {
            case 1:
                self.manageSubDic["Profile_views"] = sender.isOn
                CommonClass.googleEventTrcking("settings_screen", action: "manage_subscription", label: "\("profile_views_" + lbl)" ) //GA
            case 2:
                self.manageSubDic["Improve_profile"] = sender.isOn
                CommonClass.googleEventTrcking("settings_screen", action: "manage_subscription", label: "\("improve_profile_" + lbl)" ) //GA
            default:
                break
            }
        
        case 3:
            self.manageSubDic["Recruiter_communications"] = sender.isOn
            CommonClass.googleEventTrcking("settings_screen", action: "manage_subscription", label: "\("recruiter_communications_" + lbl)" ) //GA
        case 4:
            self.manageSubDic["Promotion"] = sender.isOn
            CommonClass.googleEventTrcking("settings_screen", action: "manage_subscription", label: "\("promotion_" + lbl)" ) //GA
        case 5:
            self.manageSubDic["Career_advice"] = sender.isOn
            CommonClass.googleEventTrcking("settings_screen", action: "manage_subscription", label: "\("career_advice_" + lbl)" ) //GA
            
        case 6:
            if sender.isOn {
                CommonClass.googleEventTrcking("settings_screen", action: "manage_subscription", label: "deactivate_account_toggle_on")
                
                let vPopup = MIJobPreferencePopup.popup()
                vPopup.setViewWithTitle(title: "", viewDescriptionText: ManageSubscriptions.deactivateMsg, or: "", primaryBtnTitle: "Deactivate & Logout", secondaryBtnTitle: "Cancel")
                vPopup.delegate = self
                vPopup.closeBtn.isHidden = true
                vPopup.addMe(onView: self.view, onCompletion: nil)
            }
            
        default:
            break

        }
        
        
    }
    
    @objc func btnSavePressed(_ sender: UIButton){
        CommonClass.googleEventTrcking("settings_screen", action: "manage_subscription", label: "save") //GA
        self.saveEmailPreferencesResponse()
    }
    
    @objc func btnReadMorePressed(_ sender: UIButton){
        
        if selectedIndex == 8 {
            selectedIndex = selectedIndex+1
            self.tableViewManageSubscriptions.reloadData()
            sender.isHidden = true

            DispatchQueue.main.async {
                self.tableViewManageSubscriptions.scrollToRow(at: IndexPath(row: 0, section: 8), at: .top, animated: false)
            }
        }
    }
    
    @objc func btnLessPressed(_ sender: UIButton) {
        
        if selectedIndex == 9 {
            selectedIndex -= 1
            
            self.tableViewManageSubscriptions.reloadData()
            
            let cell = self.tableViewManageSubscriptions.cellForRow(at: IndexPath(row: 0, section: 7)) as!MIManageSubsFooterTableViewCell
            cell.btnMore.isHidden = false
            
            DispatchQueue.main.async {
                self.tableViewManageSubscriptions.scrollToRow(at: IndexPath(row: 0, section: 7), at: .top, animated: false)
            }
            
        }
        
    }
    
    @objc func btnDeleteDeactivatePressed(_ sender: UIButton) {
        
        let cell = sender.tableViewCell() as! MIManageSubsReadMoreTableViewCell

        cell.btnDelete.isSelected = false
        cell.btnDeactivate.isSelected = false
        
        sender.isSelected = true
        
    }
    

    
    @objc func btnProceedPressed(_ sender: UIButton) {
      
        let cell = sender.tableViewCell() as! MIManageSubsReadMoreTableViewCell
        
        if cell.btnDeactivate.isSelected {
            let controller = MIDeactivateAccountViewController()
            self.navigationController?.pushViewController(controller, animated: true)
            
        } else if cell.btnDelete.isSelected{
            let controller = MIDeleteAccountViewController()
            self.navigationController?.pushViewController(controller, animated: true)
            
        } else {
        
        }

    }

    
}


//MARK:- API
extension MIManageSubscriptionsViewController {
    
    func getEmailPreferencesResponse() {
        
        MIApiManager.hitGetEmailPreferencesAPI { (success, response, error, code) in
            
            DispatchQueue.main.async {
                
                if let responseData = response as? JSONDICT, code == 200 || code == 204 {
                    
                    let jobNotification = responseData["jobNotification"] as! JSONDICT
                    self.manageSubDic["Recommended_jobs"] = jobNotification["recommendedJobs"] as? Bool
                    self.manageSubDic["Job_alert"] = jobNotification["jobAlert"] as? Bool
                    self.manageSubDic["Application_status_update"] = jobNotification["applicationStatus"] as? Bool
                    
                    let profileRelatedNotification = responseData["profileRelatedNotification"] as! JSONDICT
                    self.manageSubDic["Profile_views"] = profileRelatedNotification["profileViews"] as? Bool
                    self.manageSubDic["Improve_profile"] = profileRelatedNotification["improveProfileStrength"] as? Bool
                    
                    self.manageSubDic["Recruiter_communications"] = responseData["recruiterCommunications"] as? Bool
                    self.manageSubDic["Promotion"] = responseData["promotionsAndSpecialOffers"] as? Bool
                    self.manageSubDic["Career_advice"] = responseData["careerAdviceAndTips"] as? Bool
                    
                    self.tableViewManageSubscriptions.reloadData()
                    
                    
                } else {
                    if (!MIReachability.isConnectedToNetwork()){
                        self.toastView(messsage: ExtraResponse.noInternet)
                    }
                }
            }
        }
        
    }
    
    func saveEmailPreferencesResponse() {
        
        MIActivityLoader.showLoader()
        MIApiManager.hitEmailPreferencesAPI(self.manageSubDic["Recommended_jobs"]!,
                                            jobAlert: self.manageSubDic["Job_alert"]!,
                                            applicationStatus: self.manageSubDic["Application_status_update"]!,
                                            profileViews: self.manageSubDic["Profile_views"]!,
                                            improveProfileStrength: self.manageSubDic["Improve_profile"]!,
                                            recruiterCommunications: self.manageSubDic["Recruiter_communications"]!,
                                            promotionsAndSpecialOffers: self.manageSubDic["Promotion"]!,
                                            careerAdviceAndTips: self.manageSubDic["Career_advice"]!)
        { (success, response, error, code) in
            DispatchQueue.main.async {
                MIActivityLoader.hideLoader()
            

                
                var keyResponse = [String]()
                for data in self.manageSubDic {
                    if data.value {
                        keyResponse.append(data.key)
                    }
                }                
                
                if let responseData = response as? JSONDICT {
                    
                    if let successMessage = responseData["successMessage"] as? String {
                        self.toastView(messsage: successMessage,isErrorOccured:false)
                    } else if let errorMessage = responseData["errorMessage"] as? String {
                        self.toastView(messsage: errorMessage)
                    }
                } else {
                    if (!MIReachability.isConnectedToNetwork()){
                        self.toastView(messsage: ExtraResponse.noInternet)
                    }
                }
            }
        }
        
    }
    
    
       func deactivateApi() {
           MIApiManager.hitDeativateUserAPI { (success, response, error, code) in
               
               DispatchQueue.main.async {
                   if let responseData = response as? JSONDICT {
                      
                       if let successMessage = responseData["successMessage"] as? String {
                           //self.toastView(messsage: successMessage,isErrorOccured:false)
                           CommonClass.deleteUserLogs()
                           self.logOutData()                        
                       } else if let errorMessage = responseData["errorMessage"] as? String {
                           self.toastView(messsage: errorMessage)
                           self.tableViewManageSubscriptions.reloadData()
                       }
                   } else {
                       if (!MIReachability.isConnectedToNetwork()){
                           self.toastView(messsage: ExtraResponse.noInternet)
                           self.tableViewManageSubscriptions.reloadData()
                       }
                   }
                   
               }
           }
       }
       
    
    func logOutData() {
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
       
    
}

extension MIManageSubscriptionsViewController: JobPreferencePopUpDelegate {
    func optionCompleteIgnoredSelected(popSelection: PopUpOptionSelection, popup: MIPopupView) {
     
        if popSelection == .Completed {
            CommonClass.googleEventTrcking("settings_screen", action: "manage_subscription", label: "Deactivate_and_logout")
            self.deactivateApi()
        } else if popSelection == .Ignored {
            CommonClass.googleEventTrcking("settings_screen", action: "manage_subscription", label: "Deactivate_Cancel")
            self.tableViewManageSubscriptions.reloadData()
        }
    }
    
}







