//
//  MIProfileVisibilityViewController.swift
//  MonsteriOS
//
//  Created by Anushka on 11/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIProfileVisibilityViewController: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var tableViewProfileVisibility: UITableView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var viewContainerSave: UIView!
    
    var responseArr = jsonArr()
    var jobSearchStage = ""
    
    weak var delegate:MIProfileTableHeaderDelegate?

    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()
    }
    
    func initialSetup() {
        
        self.title = ControllerTitleConstant.profileVisibility
        
        self.tableViewProfileVisibility.delegate = self
        self.tableViewProfileVisibility.dataSource = self
        
        self.tableViewProfileVisibility.register(UINib(nibName: "MIProfileVisibilityTableViewCell", bundle: nil), forCellReuseIdentifier: "MIProfileVisibilityTableViewCell")
        self.tableViewProfileVisibility.register(UINib(nibName: "MIMIProfileVisibilityJobSearchTableViewCell", bundle: nil), forCellReuseIdentifier: "MIMIProfileVisibilityJobSearchTableViewCell")
        self.tableViewProfileVisibility.register(UINib(nibName: "MIProfileVisibilityJobSearchReasonTableViewCell", bundle: nil), forCellReuseIdentifier: "MIProfileVisibilityJobSearchReasonTableViewCell")
        
        self.getJobSearchStage()
        self.btnSave.isHidden = true
        self.viewContainerSave.isHidden =  true
        
        self.tableViewProfileVisibility.rowHeight = UITableView.automaticDimension
        self.tableViewProfileVisibility.estimatedRowHeight = 44.0

        
        let cell = self.tableViewProfileVisibility.cellForRow(at: IndexPath(row: 0, section: 0)) as? MIProfileVisibilityTableViewCell
        cell?.onOffSwitch.isOn = AppDelegate.instance.userInfo.visibility

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        CommonClass.googleAnalyticsScreen(self) //GA for Screen
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)
        
//        if self.responseArr.isEmpty {
//            self.btnSave.isHidden = true
//            self.viewContainerSave.isHidden =  true
//        } else {
//            self.btnSave.isHidden = false
//            self.viewContainerSave.isHidden =  false
//        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    //MARK:- IBAction
    @IBAction func btnSavePressed(_ sender: UIButton){
        guard jobSearchStage != "" else { self.toastView(messsage: ExtraResponse.selectReason)
            return
        }
         self.jobSearchStageAPI()
    }
    

}

//MARK:- API
extension MIProfileVisibilityViewController {
    
    func profileVisibility(_ visibility: Bool) {
        
        MIApiManager.hitProfileVisibiltyAPI(visibility) { (success, response, error, code) in
            
            DispatchQueue.main.async {
                
                if let responseData = response as? JSONDICT {
                    
                    //save visibility in DB
                    AppDelegate.instance.userInfo.visibility = visibility
                    AppDelegate.instance.userInfo.commit()
                    
                    if let successMessage = responseData["successMessage"] as? String {
                        self.toastView(messsage: successMessage,isErrorOccured:false)
                    } else if let errorMessage = responseData["errorMessage"] as? String {
                        self.toastView(messsage: errorMessage)
                    }else{
                        if let err = error {
                            self.handleAPIError(errorParams: response, error: err)
                        }
                    }
                    
                }
            }
        }
        
    }
    
    func getJobSearchStage() {
        
        MIApiManager.hitGetJobSearchStageAPI { (success, response, error, code) in
            DispatchQueue.main.async {
                if let responseData = response as? JSONDICT {
                   
                    if let arr = responseData["data"] as? jsonArr {
                        self.responseArr = arr
                    }
                    if !(self.responseArr.isEmpty) {
                        self.getJobSearchStageStatus()
                    }
                        self.tableViewProfileVisibility.reloadData()
                    }
                }
            }
        
    }
    
    func getJobSearchStageStatus() {
        
        MIApiManager.hitGetJobSearchStageStatusAPI { (success, response, error, code) in
            DispatchQueue.main.async {
                if let responseData = response as? JSONDICT {
                    self.jobSearchStage = responseData.dictionaryFor(key: "jobSearchStage").stringFor(key: "id")
                    self.tableViewProfileVisibility.reloadData()
                }
            }
        }
    }
    
    func jobSearchStageAPI() {
        
        MIActivityLoader.showLoader()
        
        MIApiManager.hitJobSearchStageAPI(jobSearchStage) { (success, response, error, code) in
            DispatchQueue.main.async {
                MIActivityLoader.hideLoader()
                
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
    
}

//MARK:- tableview delegate and data source
extension MIProfileVisibilityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard self.responseArr.count != 0 else { return 1 }
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        switch section{
        case 0,1:
            return 1
        default:
            return self.responseArr.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MIProfileVisibilityTableViewCell") as! MIProfileVisibilityTableViewCell
            
            cell.hideShowLabel.isHidden = true
            
            cell.nameLabel.text! = AppDelegate.instance.userInfo.fullName
            cell.emailLabel.text! = AppDelegate.instance.userInfo.primaryEmail
            cell.profileImageView.addPlaceHolderIcon(AppDelegate.instance.userInfo.fullName, font: UIFont.customFont(type: .Semibold, size: 25))

            cell.profileImageView.isUserInteractionEnabled = false

            if !AppDelegate.instance.userInfo.avatar.isEmpty {
                cell.profileImageView.isUserInteractionEnabled = true
                cell.profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileImgTapped(_:))))
                cell.profileImageView.removePlaceHolderIcon()
                cell.profileImageView.cacheImage(urlString: AppDelegate.instance.userInfo.avatar)
                
            }

            if AppDelegate.instance.userInfo.countryCode.isBlank {
                 cell.mobileNumberLabel.text! = AppDelegate.instance.userInfo.mobileNumber
            } else {
                cell.mobileNumberLabel.text = "+" + AppDelegate.instance.userInfo.countryCode + " " + AppDelegate.instance.userInfo.mobileNumber
            }
            
            if AppDelegate.instance.userInfo.visibility {
                cell.hideShowLabel.text = ProfileVisibiltyConstant.hide
            } else {
                cell.hideShowLabel.text = ProfileVisibiltyConstant.show
            }
           
            cell.onOffSwitch.isOn = AppDelegate.instance.userInfo.visibility
            cell.onOffSwitch.addTarget(self, action: #selector(switchOnOffAction(_:)), for: .valueChanged)
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MIMIProfileVisibilityJobSearchTableViewCell") as! MIMIProfileVisibilityJobSearchTableViewCell
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MIProfileVisibilityJobSearchReasonTableViewCell") as! MIProfileVisibilityJobSearchReasonTableViewCell
            
            let row = self.responseArr[indexPath.row]
           cell.lblJobSearchReason.text! = row["name"] as! String
           cell.btnJobSearchReason.isSelected = (row["uuid"] as? String == self.jobSearchStage)
           return cell

        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
       
        guard indexPath.section == 2 else { return }
        
        let row = self.responseArr[indexPath.row]
        let id = row["uuid"] as! String
        self.jobSearchStage = id
        
        UIView.performWithoutAnimation {
            tableView.beginUpdates()
            tableView.reloadSections(IndexSet(integer: 2), with: .none)
            tableView.endUpdates()
        }
        
        //GA
        if indexPath.row == 0 {
            CommonClass.googleEventTrcking("settings_screen", action: "profile_visibility", label: "just_starting")
        } else if indexPath.row == 1 {
            CommonClass.googleEventTrcking("settings_screen", action: "profile_visibility", label: "actively_interviewing")
        } else if indexPath.row == 2 {
            CommonClass.googleEventTrcking("settings_screen", action: "profile_visibility", label: "close_to_offer")
        } else if indexPath.row == 3 {
            CommonClass.googleEventTrcking("settings_screen", action: "profile_visibility", label: "have_offer")
        } else {
            CommonClass.googleEventTrcking("settings_screen", action: "profile_visibility", label: "not_looking")
        }
       
        self.jobSearchStageAPI()

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    @objc func profileImgTapped(_ gesture: UITapGestureRecognizer) {
//        guard let image = (gesture.view as? UIImageView)?.image else { return }
//
//        let imgView = UIImageView(image: image)
//        
//        imgView.image = image
//        imgView.contentMode = .scaleAspectFit
//        imgView.clipsToBounds = true
//        guard let cell = self.tableViewProfileVisibility.cellForRow(at: IndexPath(row: 0, section: 0)) as? MIProfileVisibilityTableViewCell else { return }
//
//        let view = UIView(frame:CGRect(x: cell.profileImageView.center.x-(cell.profileImageView.frame.size.width/2), y: cell.profileImageView.center.y+(cell.profileImageView.frame.size.height/2), width: cell.profileImageView.frame.size.width, height: cell.profileImageView.frame.size.height))
//        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
//        view.isUserInteractionEnabled = true
//        view.addTapGestureRecognizer { (tapsender) in
//
//            view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
//            UIView.animate(withDuration: 0.70, delay: 0.4, options: .allowUserInteraction, animations: {
//                
//                view.frame = CGRect(x: cell.profileImageView.center.x-(cell.profileImageView.frame.size.width/2), y: cell.profileImageView.center.y+(cell.profileImageView.frame.size.height/2), width: cell.profileImageView.frame.size.width, height: cell.profileImageView.frame.size.height)
//                view.circular(4, borderColor: UIColor(hex: "ffffff"))
//                view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
//                imgView.frame = CGRect(x: cell.profileImageView.center.x-(cell.profileImageView.frame.size.width/2), y: cell.profileImageView.center.y+(cell.profileImageView.frame.size.height/2), width: cell.profileImageView.frame.size.width, height: cell.profileImageView.frame.size.height)
//
//            }) { (status) in
//                view.removeFromSuperview()
//
//            }
//
//        }
//        view.roundCorner(2, borderColor: UIColor(hex: "ffffff"), rad: 2)
//        view.addSubview(imgView)
//        let rootView = kAppDelegate.window
//        rootView?.addSubview(view)
//        UIView.animate(withDuration: 0.70) {
//            
//            if let tabBar = self.tabBarController as? MIHomeTabbarViewController {
//                view.frame = CGRect(x: 0, y: 0, width: tabBar.view.frame.width, height: kAppDelegate.window?.frame.size.height ?? kScreenSize.height)
//
//                let yPosition = view.frame.height/2  - image.size.height/2
//
//                imgView.frame = CGRect(x: 0, y: yPosition, width: view.frame.width, height: image.size.height)
//                view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
//                
//            }
//
//                           }
//        
        
//        let enlargeVC = MIImageEnlargeViewController()
//        enlargeVC.modalPresentationStyle = .overCurrentContext
//        enlargeVC.img = image
//        self.present(enlargeVC, animated: false, completion: nil)
        
    }
    
    @objc func switchOnOffAction(_ sender: UISwitch) {
        
        let cell = sender.tableViewCell() as! MIProfileVisibilityTableViewCell
        
        if sender.isOn {
            cell.hideShowLabel.text = ProfileVisibiltyConstant.hide
            CommonClass.googleEventTrcking("settings_screen", action: "profile_visibility", label: "toggle_on") //GA
        } else{
            cell.hideShowLabel.text = ProfileVisibiltyConstant.show
            CommonClass.googleEventTrcking("settings_screen", action: "profile_visibility", label: "toggle_off") //GA
        }
        
        self.profileVisibility(sender.isOn)

    }
    
}


