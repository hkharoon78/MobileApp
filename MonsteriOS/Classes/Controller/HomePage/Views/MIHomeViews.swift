//
//  MIHomePendingView.swift
//  MonsteriOS
//
//  Created by Piyush on 26/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIHomeUploadResumeView: UIView, PendingActionDelegate {
    
    
    @IBOutlet weak private var lblTitle: UILabel!
    @IBOutlet weak private var lblDesc: UILabel!
    @IBOutlet weak private var contentView: UIView?
    @IBOutlet weak private var uploadBtn: UIButton?
    @IBOutlet weak var btnNotNow: UIButton!
    @IBOutlet weak var imgBackGround: UIImageView!
    
    @IBOutlet weak var widthPrimaryConstant: NSLayoutConstraint!
    
    
    var pendingItemModel : MIPendingItemModel?
    var viewController: UIViewController?
    
    @IBAction func notNowClicked(_ sender: UIButton) {
        
        if pendingItemModel != nil {
            pendingItemModel?.pendingItemStateVisible = false
            if let parentVC =  self.superview?.superview?.superview?.parentViewController as? MIHomeViewController {
                if let pending = self.pendingItemModel {
                    parentVC.actionOnpendingItem(item: pending, actionPerformed: "Not_Now")
                }
            }
            self.removePendingItem()
            //self.checkForAllPendingAction()
            
            switch pendingItemModel?.pendingActionType {
            case .RESUME? , .RESUME_UPDATED_IN_LAST_90_DAYS? :
                CommonClass.googleEventTrcking("dashboard_screen", action: "upload_your_resume", label: "not_now")
                break
            case .VERIFY_EMAIL_ID?:
                CommonClass.googleEventTrcking("dashboard_screen", action: "verify_email", label: "not_now")
                break
            case .VERIFY_MOBILE_NUMBER?:
                CommonClass.googleEventTrcking("dashboard_screen", action: "verify_mobile", label: "not_now")
                break
            case .PROJECTS?:
                CommonClass.googleEventTrcking("dashboard_screen", action: "update_project", label: "not_now")
                break
            case .JOB_PREFERENCES_PREFERRED_LOCATION?,.JOB_PREFERENCES_INDUSTRY?,.JOB_PREFERENCES_FUNCTION?,.JOB_PREFERENCES_ROLE?:
                CommonClass.googleEventTrcking("dashboard_screen", action: "add_job_preference", label: "not_now")
                
                break
            case .PROFILE_PICTURE?:
                CommonClass.googleEventTrcking("dashboard_screen", action: "upload_profile_picture", label: "not_now")
                break
            case .COURSE_AND_CERTIFICATION?:
                CommonClass.googleEventTrcking("dashboard_screen", action: "add_courses_certifications", label: "not_now")
                break
            default:
                break
            }
        }
        
    }
    
    func removePendingItem(){
        if let parentVC =  self.superview?.superview?.superview?.parentViewController as? MIHomeViewController {
            
            let dataArray = parentVC.modulesArray.filter { $0.aliasName == MIHomeModuleEnums.pendingAction.rawValue }
            if dataArray.count > 0 {
                if let pendingItems = dataArray[0].dicModel[MIHomeModuleEnums.pendingAction.rawValue] as? [MIPendingItemModel] {
                    let visibleData = pendingItems.filter {$0.pendingItemStateVisible}
                    if visibleData.count == 0 {
                        if let pendingModel = dataArray.first {
                            if let index = parentVC.modulesArray.firstIndex(of:pendingModel) {
                                parentVC.modulesArray.remove(at: index)
                            }
                        }
                    }
                }
            }
            parentVC.tblView.reloadData()
            
        }
    }
    
    func checkForAllPendingAction(){
        if let parentVC =  self.superview?.superview?.superview?.parentViewController as? MIHomeViewController {
            parentVC.modulesArray.removeAll()
            parentVC.tblView.reloadData()
            parentVC.callApi()
            // parentVC.actionOnpendingItem(item: pendingItemModel, actionPerformed: actionPerformed)
        }
    }
    
    @IBAction func uploadClicked(_ sender: UIButton) {
        
        switch pendingItemModel?.pendingActionType {
        case .PROFILE_SUMMARY?:
            break
        case .RESUME? , .RESUME_UPDATED_IN_LAST_90_DAYS? :
            CommonClass.googleEventTrcking("dashboard_screen", action: "upload_your_resume", label: "upload")
            
            if let uploadResum = pendingItemModel?.pendingActionType.viewControler as? MIUploadResumeViewController {
                uploadResum.flowVia = .ViaPendingResume
                
                if let parentVC =  self.superview?.superview?.superview?.parentViewController as? MIHomeViewController {
                    if let pending = self.pendingItemModel {
                        parentVC.actionOnpendingItem(item: pending, actionPerformed: "Update")
                    }
                    
                    uploadResum.resumeUploadedAction = {  (status,name,result) in
                        if let pending = self.pendingItemModel {
                            pending.pendingItemStateVisible = false
                            self.checkForAllPendingAction()
                            
                        }
                        //parentVC.tblView.reloadData()
                    }
                    parentVC.navigationController?.pushViewController(uploadResum, animated: false)
                }
            }
            
        case .EDUCATION?:
            if let addEducationVc = pendingItemModel?.pendingActionType.viewControler as? MIEducationDetailViewController {
                addEducationVc.educationFlow = .ViaProfileAdd
                if let parentVC =  self.superview?.superview?.superview?.parentViewController as? MIHomeViewController {
                    if let pending = self.pendingItemModel {
                        parentVC.actionOnpendingItem(item: pending, actionPerformed: "Update")
                    }
                    addEducationVc.educationAddedSuccess = {  success in
                        if let pending = self.pendingItemModel {
                            pending.pendingItemStateVisible = false
                            self.checkForAllPendingAction()
                            
                        }
                        //parentVC.tblView.reloadData()
                    }
                    parentVC.navigationController?.pushViewController(addEducationVc, animated: false)
                    
                }
            }
            break
            
        case .PERSONAL?:
            if let personalVC = pendingItemModel?.pendingActionType.viewControler as? MIPersonalDetailVC {
                if let parentVC =  self.superview?.superview?.superview?.parentViewController as? MIHomeViewController {
                    if let pending = self.pendingItemModel {
                        parentVC.actionOnpendingItem(item: pending, actionPerformed: "Update")
                    }
                    personalVC.personalDetailUpdateSuccessCallBack = { status in
                        if let pending = self.pendingItemModel {
                            pending.pendingItemStateVisible = false
                            self.checkForAllPendingAction()
                            
                        }
                        // parentVC.tblView.reloadData()
                    }
                    
                    parentVC.navigationController?.pushViewController(personalVC, animated: false)
                    
                }
            }
            break
            
        case .VERIFY_EMAIL_ID?:
            CommonClass.googleEventTrcking("dashboard_screen", action: "verify_email", label: "verify")
            
            if let parentVC =  self.superview?.superview?.superview?.parentViewController as? MIHomeViewController {
                if let pending = self.pendingItemModel {
                    parentVC.actionOnpendingItem(item: pending, actionPerformed: "Update")
                }
                //   if let homeTab = parentVC.tabBarController as? MIHomeTabbarViewController {
                let emailVC = MIVerifyEmailTemplateViewController()
                emailVC.userEmail = AppDelegate.instance.userInfo.primaryEmail
                parentVC.navigationController?.pushViewController(emailVC, animated: true)
            }
            if let _ = self.pendingItemModel {
                self.checkForAllPendingAction()
                
            }
            
            
            
            break
            
        case .VERIFY_MOBILE_NUMBER?:
            CommonClass.googleEventTrcking("dashboard_screen", action: "verify_mobile", label: "verify")
            
            if AppDelegate.instance.userInfo.mobileNumber.count > 5 {
                if let mobileverifyVC = pendingItemModel?.pendingActionType.viewControler as? MIOTPViewController {
                    mobileverifyVC.openMode = .verifyMobileNumber
                    mobileverifyVC.delegate = self
                    mobileverifyVC.countryCode = AppDelegate.instance.userInfo.countryCode
                    mobileverifyVC.userName = AppDelegate.instance.userInfo.mobileNumber
                    mobileverifyVC.otpVerifySuccess = { status in
                        
                        if self.pendingItemModel != nil {
                            self.pendingItemModel?.pendingItemStateVisible = false
                            self.checkForAllPendingAction()
                            
                        }
                    }
                    
                    if let parentVC =  self.superview?.superview?.superview?.parentViewController as? MIHomeViewController {
                        if let pending = self.pendingItemModel {
                            parentVC.actionOnpendingItem(item: pending, actionPerformed: "Update")
                        }
                        parentVC.navigationController?.pushViewController(mobileverifyVC, animated: false)
                        
                    }
                }
            }else {
                let pendingAction = MIPendingActionViewController()
                pendingAction.pendingType = .ADD_MOBILE_NUMBER
                if let parentVC =  self.superview?.superview?.superview?.parentViewController as? MIHomeViewController {
                    if let pending = self.pendingItemModel {
                        parentVC.actionOnpendingItem(item: pending, actionPerformed: "Update")
                    }
                    pendingAction.pendingactionSuccess = {  status in
                        if let pendingItem = self.pendingItemModel {
                            pendingItem.pendingItemStateVisible = false
                            self.checkForAllPendingAction()
                            
                        }
                        // parentVC.tblView.reloadData()
                        
                    }
                    pendingAction.pendingType = .ADD_MOBILE_NUMBER
                    parentVC.navigationController?.pushViewController(pendingAction, animated: true)
                    
                }
                //  parentVC.navigationController?.pushViewController(pendingAction, animated: true)
                
                
            }
            
            
            break
            
        case .EMPLOYMENT?:
            if let employmentVC = pendingItemModel?.pendingActionType.viewControler as? MIEmploymentDetailViewController {
                if let parentVC =  self.superview?.superview?.superview?.parentViewController as? MIHomeViewController {
                    if let pending = self.pendingItemModel {
                        parentVC.actionOnpendingItem(item: pending, actionPerformed: "Update")
                    }
                    employmentVC.employementFlow = .ViaProfileAdd
                    employmentVC.employementAddedSuccess = {  status in
                        if let pending = self.pendingItemModel {
                            pending.pendingItemStateVisible = false
                            self.checkForAllPendingAction()
                            
                        }
                        // parentVC.tblView.reloadData()
                        
                    }
                    parentVC.navigationController?.pushViewController(employmentVC, animated: false)
                    
                }
                //self.checkForAllPendingAction()
            }
            break
            
        case .PROJECTS?:
            CommonClass.googleEventTrcking("dashboard_screen", action: "update_project", label: "showcase")
            if let projectVC = pendingItemModel?.pendingActionType.viewControler as? MIProjectDetailVC {
                if let parentVC =  self.superview?.superview?.superview?.parentViewController as? MIHomeViewController {
                    if let pending = self.pendingItemModel {
                        parentVC.actionOnpendingItem(item: pending, actionPerformed: "Update")
                    }
                    projectVC.projectAddedSuccess = {  status in
                        if let pending = self.pendingItemModel {
                            pending.pendingItemStateVisible = false
                            self.checkForAllPendingAction()
                            
                        }
                        // parentVC.tblView.reloadData()
                        
                    }
                    parentVC.navigationController?.pushViewController(projectVC, animated: false)
                    
                }
            }
            break
        case .JOB_PREFERENCES_PREFERRED_LOCATION?,.JOB_PREFERENCES_INDUSTRY?,.JOB_PREFERENCES_FUNCTION?,.JOB_PREFERENCES_ROLE?:
            CommonClass.googleEventTrcking("dashboard_screen", action: "add_job_preference", label: "update")
            
            if let jobPref = pendingItemModel?.pendingActionType.viewControler as? MIJobPreferenceViewController {
                if let parentVC =  self.superview?.superview?.superview?.parentViewController as? MIHomeViewController {
                    if let pending = self.pendingItemModel {
                        parentVC.actionOnpendingItem(item: pending, actionPerformed: "Update")
                    }
                    jobPref.flowVia = .ViaPendingAction
                    jobPref.jobpreferenceSuccessPendingAction={(status,model) in
                        let dataArray = parentVC.modulesArray.filter { $0.aliasName == MIHomeModuleEnums.pendingAction.rawValue }
                        //var jobpreferencePendingModel =  MIPendingItemModel(dict: [:])
                        if dataArray.count > 0 {
                            if let pendingItems = dataArray[0].dicModel[MIHomeModuleEnums.pendingAction.rawValue] as? [MIPendingItemModel] {
                                
                                if model.preferredRoles.count > 0 &&  model.preferredFunctions.count > 0 && model.preferredLocationList.count > 0 && model.preferredIndustrys.count > 0 {
                                    let functionArray = pendingItems.filter({$0.pendingActionType == PendingActionType.JOB_PREFERENCES_PREFERRED_LOCATION })
                                    functionArray[0].pendingItemStateVisible = false
                                    //jobpreferencePendingModel = functionArray[0]
                                    
                                }else{
                                    let functionArray = pendingItems.filter({$0.pendingActionType == PendingActionType.JOB_PREFERENCES_PREFERRED_LOCATION })
                                    functionArray[0].pendingItemStateVisible = true
                                    //jobpreferencePendingModel = functionArray[0]
                                    
                                }
                                
                            }
                        }
                        self.checkForAllPendingAction()
                        //parentVC.tblView.reloadData()
                    }
                    parentVC.navigationController?.pushViewController(jobPref, animated: false)
                }
            }
            break
            
        case .PROFILE_TITLE?:
            if let pendingAction = pendingItemModel?.pendingActionType.viewControler as? MIPendingActionViewController {
                if let parentVC =  self.superview?.superview?.superview?.parentViewController as? MIHomeViewController {
                    if let pending = self.pendingItemModel {
                        parentVC.actionOnpendingItem(item: pending, actionPerformed: "Update")
                    }
                    pendingAction.pendingactionSuccess = {  status in
                        if let pending = self.pendingItemModel {
                            pending.pendingItemStateVisible = false
                            self.checkForAllPendingAction()
                            
                        }
                        // parentVC.tblView.reloadData()
                        
                    }
                    pendingAction.pendingType = .PROFILE_TITLE
                    parentVC.navigationController?.pushViewController(pendingAction, animated: true)
                    
                }
            }
            
            break
        case .PROFILE_PICTURE?:
            CommonClass.googleEventTrcking("dashboard_screen", action: "upload_profile_picture", label: "upload")
            
            if let parentVC =  self.superview?.superview?.superview?.parentViewController as? MIHomeViewController {
                if let pending = self.pendingItemModel {
                    parentVC.actionOnpendingItem(item: pending, actionPerformed: "Update")
                }
                if let homeTab = parentVC.tabBarController as? MIHomeTabbarViewController {
                    homeTab.showActionSheetForUserSelection(personalDetail: nil)
                    homeTab.profilePictureSuccess = {  status in
                        if let pendingItem = self.pendingItemModel {
                            pendingItem.pendingItemStateVisible = false
                            self.checkForAllPendingAction()
                            
                        }
                        
                        // parentVC.tblView.reloadData()
                        
                    }
                }
                
            }
            break
        case .NOTICE_PERIOD?:
            if let pendingAction = pendingItemModel?.pendingActionType.viewControler as? MIPendingActionViewController {
                if let parentVC =  self.superview?.superview?.superview?.parentViewController as? MIHomeViewController {
                    if let pending = self.pendingItemModel {
                        parentVC.actionOnpendingItem(item: pending, actionPerformed: "Update")
                    }
                    pendingAction.pendingactionSuccess = {  status in
                        if let pendingItem = self.pendingItemModel {
                            pendingItem.pendingItemStateVisible = false
                            self.checkForAllPendingAction()
                            
                        }
                        // parentVC.tblView.reloadData()
                        
                    }
                    pendingAction.pendingType = .NOTICE_PERIOD
                    parentVC.navigationController?.pushViewController(pendingAction, animated: true)
                    
                }
            }
            break
        case .KEY_SKILL?:
            if let skillVC = pendingItemModel?.pendingActionType.viewControler as? MISkillAddViewController {
                if let parentVC =  self.superview?.superview?.superview?.parentViewController as? MIHomeViewController {
                    if let pending = self.pendingItemModel {
                        parentVC.actionOnpendingItem(item: pending, actionPerformed: "Update")
                    }
                    skillVC.flowVia = .ViaProfileAdd
                    skillVC.addSkillSuccess = {  status in
                        if let pendingItem = self.pendingItemModel {
                            pendingItem.pendingItemStateVisible = false
                            self.checkForAllPendingAction()
                            
                        }
                        // parentVC.tblView.reloadData()
                        
                    }
                    parentVC.navigationController?.pushViewController(skillVC, animated: true)
                    
                }
            }
            break
        case .IT_SKILL?:
            if let itskillVC = pendingItemModel?.pendingActionType.viewControler as? MIITSkillsVC {
                if let parentVC =  self.superview?.superview?.superview?.parentViewController as? MIHomeViewController {
                    if let pending = self.pendingItemModel {
                        parentVC.actionOnpendingItem(item: pending, actionPerformed: "Update")
                    }
                    itskillVC.addITSkillSuccess = {  status in
                        if let pendingItem = self.pendingItemModel {
                            pendingItem.pendingItemStateVisible = false
                            self.checkForAllPendingAction()
                            
                        }
                        // parentVC.tblView.reloadData()
                        
                    }
                    parentVC.navigationController?.pushViewController(itskillVC, animated: true)
                    
                }
            }
            break
        case .COURSE_AND_CERTIFICATION?:
            CommonClass.googleEventTrcking("dashboard_screen", action: "add_courses_certifications", label: "update")
            
            if let courseVC = pendingItemModel?.pendingActionType.viewControler as? MICoursesCertificatinVC {
                if let parentVC =  self.superview?.superview?.superview?.parentViewController as? MIHomeViewController {
                    if let pending = self.pendingItemModel {
                        parentVC.actionOnpendingItem(item: pending, actionPerformed: "Update")
                    }
                    courseVC.courseAddedSuccess = {  status in
                        if let pendingItem = self.pendingItemModel {
                            pendingItem.pendingItemStateVisible = false
                            self.checkForAllPendingAction()
                            
                        }
                        // parentVC.tblView.reloadData()
                        
                    }
                    parentVC.navigationController?.pushViewController(courseVC, animated: true)
                    
                }
            }
            break
            
        case .WORK_HISTORY?:
            
            break
        case .ADD_MOBILE_NUMBER?:
            if let pendingAction = pendingItemModel?.pendingActionType.viewControler as? MIPendingActionViewController {
                if let parentVC =  self.superview?.superview?.superview?.parentViewController as? MIHomeViewController {
                    if let pending = self.pendingItemModel {
                        parentVC.actionOnpendingItem(item: pending, actionPerformed: "Update")
                    }
                    pendingAction.pendingactionSuccess = {  status in
                        if let pendingItem = self.pendingItemModel {
                            pendingItem.pendingItemStateVisible = false
                            self.checkForAllPendingAction()
                            
                        }
                        // parentVC.tblView.reloadData()
                        
                    }
                    pendingAction.pendingType = .ADD_MOBILE_NUMBER
                    parentVC.navigationController?.pushViewController(pendingAction, animated: true)
                    
                }
            }
            break
            
        case .NATIONALITY?:
            if let pendingAction = pendingItemModel?.pendingActionType.viewControler as? MIPendingActionViewController {
                if let parentVC =  self.superview?.superview?.superview?.parentViewController as? MIHomeViewController {
                    if let pending = self.pendingItemModel {
                        parentVC.actionOnpendingItem(item: pending, actionPerformed: "Update")
                    }
                    pendingAction.pendingactionSuccess = {  status in
                        if let pendingItem = self.pendingItemModel {
                            pendingItem.pendingItemStateVisible = false
                            self.checkForAllPendingAction()
                            
                        }
                        // parentVC.tblView.reloadData()
                        
                    }
                    pendingAction.pendingType = .PROFILE_TITLE
                    parentVC.navigationController?.pushViewController(pendingAction, animated: true)
                }
            }
            break
            
        case .GLEAC_SKILLS:
            
            let data = [ "learnMore" : true ]
            MIApiManager.hitGleacSkillMapEventsAPI(CONSTANT_JOB_SEEKER_TYPE.HOME_PAGE, accessedUrl: CONSTANT_SCREEN_NAME.HOME, data: data) { (success, response, error, code) in
            }
            
            CommonClass.googleEventTrcking("dashboard_screen", action: "gleac_softskills", label: "learn_more_gleac")
            
            if let gleacSkillVC = pendingItemModel?.pendingActionType.viewControler as? MIGleacVC {
                if let parentVC =  self.superview?.superview?.superview?.parentViewController as? MIHomeViewController {
                    
//                    if let pending = self.pendingItemModel {
//                        parentVC.actionOnpendingItem(item: pending, actionPerformed: "Update")
//                    }
//                    gleacSkillVC.gleacReportUpdateCallBack = { update in
                        
//                        if let pending = self.pendingItemModel {
//                            pending.pendingItemStateVisible = false
//                            self.checkForAllPendingAction()
//                        }
//                    }

                    let nav =  UINavigationController(rootViewController: gleacSkillVC)
                    nav.modalPresentationStyle = .fullScreen
                    parentVC.present(nav, animated: false, completion: nil)
                }
            }
            break
            
        default:
            break
            
        }
        
    }
    
    //MARK:- Handle Call back on verify User
    func verifiedUser(_ id: String, openMode: OpenMode) {
        // if let parentVC =  self.superview?.superview?.superview?.parentViewController as? MIHomeViewController {
        if self.pendingItemModel != nil {
            self.pendingItemModel?.pendingItemStateVisible = false
            self.checkForAllPendingAction()
            
            // }
            //parentVC.tblView.reloadData()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = CornerRadius.viewCornerRadius
        self.contentView?.addShadow(opacity: 0.2)
        self.layoutIfNeeded()
        
        self.btnNotNow.isHidden = true
        
        self.btnNotNow.layer.cornerRadius = 4.0
        self.btnNotNow.layer.masksToBounds = true
         

    }

    
   
    
    class var view: MIHomeUploadResumeView {
        get {
            let header =  UINib(nibName: "MIHomeViews", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MIHomeUploadResumeView
            //            header.contentView.addShadow(opacity: 0.2)
            return header
        }
 
    }
    
    
    func showData(pendingItem: MIPendingItemModel) {
        
        pendingItemModel = pendingItem
        self.lblTitle.text = pendingItem.pendingActionType.title
        self.lblDesc.text = pendingItem.pendingActionType.description
        self.uploadBtn?.setTitle(pendingItem.pendingActionType.actionBtnTitle, for: .normal)
        self.uploadBtn?.setTitleColor(AppTheme.defaltBlueColor, for: .normal)
        
        self.widthPrimaryConstant.constant = 100
        if pendingItem.pendingActionType == .GLEAC_SKILLS {
            self.gleacCellClr()
        }
        
    }
    
    //change background clr of Gleac Card
    func gleacCellClr(){
        self.btnNotNow.isHidden = true
        
        self.widthPrimaryConstant.constant = 120
        
        self.imgBackGround.image = UIImage(named: "Gradient-box")
        self.lblTitle.textColor = .white
        self.lblDesc.textColor = .white
        self.uploadBtn?.backgroundColor = .white
        self.uploadBtn?.setTitleColor(UIColor(hex: "212B36"), for: .normal)
        
        self.gleacDescriptionBold()
    }
    
    func gleacDescriptionBold() {
        let attributed = NSMutableAttributedString(string: "85% of job success comes from Soft Skills. Show it in your profile in just" , attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont.customFont(type: .Regular, size: 12)])
               
        attributed.append(NSAttributedString(string: " 1 min ", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont.customFont(type: .Bold, size: 13)]))
               
        attributed.append(NSAttributedString(string: "and increase your chances of getting hired", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont.customFont(type: .Regular, size: 12)]))
       
        self.lblDesc.attributedText = attributed
    }
    
    
}

protocol MIHomeCareerServiceViewDelegate:class {
    func careerServiceClicked(url:String)
}

class MIHomeCareerServiceView: UIView {
    @IBOutlet weak private var imgView: UIImageView!
    @IBOutlet weak private var lblTitle: UILabel!
    @IBOutlet weak private var lblDesc: UILabel!
    @IBOutlet weak private var contentView: UIView?
    weak var delegate:MIHomeCareerServiceViewDelegate?
    var url = ""
    override func awakeFromNib() {
        self.contentView?.roundCorner(1, borderColor: Color.colorLightGrey, rad: CornerRadius.viewCornerRadius)
    }
    
    class var view: MIHomeCareerServiceView {
        get {
            let header = UINib(nibName: "MIHomeViews", bundle: nil).instantiate(withOwner: nil, options: nil)[1] as! MIHomeCareerServiceView
            return header
        }
    }
    
    @IBAction func careerServiceClicked(_ sender: UIButton) {
        if !url.isEmpty {
            if lblTitle.text == "Right Resume" {
                CommonClass.googleEventTrcking("upskill_screen", action: "career_services", label: "right_resume")
                
                MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.CAREER_SERVICES, data: ["eventValue" : CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK, "cardName": CONSTANT_EXTRA_NAME.RIGHT_RESUME], source: "", destination: CONSTANT_SCREEN_NAME.UPSKILL_SCREEN) { (success, response, error, code) in
                }
            }else if lblTitle.text == "Xpress Resume+" {
                CommonClass.googleEventTrcking("upskill_screen", action: "career_services", label: "xpress_resume")
                
                MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.CAREER_SERVICES, data: ["eventValue" : CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK, "cardName": CONSTANT_EXTRA_NAME.XPRESS_RESUME], source: "", destination: CONSTANT_SCREEN_NAME.UPSKILL_SCREEN) { (success, response, error, code) in
                }
                
            }else if lblTitle.text == "Career Booster" {
                CommonClass.googleEventTrcking("upskill_screen", action: "career_services", label: "career_booster")
                
                MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.CAREER_SERVICES, data: ["eventValue" : CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK, "cardName": CONSTANT_EXTRA_NAME.CAREER_BOOSTER], source: CONSTANT_SCREEN_NAME.DASHBOARD, destination: CONSTANT_SCREEN_NAME.UPSKILL_SCREEN) { (success, response, error, code) in
                }
            }
            self.delegate?.careerServiceClicked(url: url)
        }
        
    }
    
    func show(info:MIHomeCareerService) {
        imgView.cacheImage(urlString: info.image)
        lblTitle.text = info.name
        lblDesc.text  = info.ttlDescription
        self.url      = info.url
    }
}

protocol MIHomeEmploymentIndexViewDelegate:class {
    func employmentIndexUrlClicked(url:String, controllerTitle:String)
}

class MIHomeEmploymentIndexView: UIView {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var contentView: UIView?
    @IBOutlet weak var btnUrlLink: UIButton!
    private var url = ""
    var controllerTitle   = "Employment Index"
    weak var delegate:MIHomeEmploymentIndexViewDelegate?
    
    override func awakeFromNib() {
        self.roundCorner(0, borderColor: nil, rad: CornerRadius.viewCornerRadius)
        self.contentView?.roundCorner(0, borderColor: nil, rad: CornerRadius.viewCornerRadius)
        self.btnUrlLink.setTitleColor(AppTheme.defaltBlueColor, for: .normal)
    }
    
    class var view: MIHomeEmploymentIndexView {
        get {
            let header = UINib(nibName: "MIHomeViews", bundle: nil).instantiate(withOwner: nil, options: nil)[2] as! MIHomeEmploymentIndexView
            //            header.lblTitle.showAttributedTxt(boldString: "Employment Index")
            return header
        }
    }
    
    func show(info:MIHomeEmploymentIndex) {
        self.lblTitle.text = info.title
        self.lblDesc.text  = info.ttlDescription
        self.imgView.image = UIImage(named: info.imgName)
        self.btnUrlLink.setTitle(info.titleLink, for: .normal)
        self.url = info.url
        self.controllerTitle = info.controllerTitle
        var strArray = info.title.components(separatedBy: " ")
        if strArray.count > 1 {
            strArray.removeFirst()
            let boldString = strArray.joined(separator: " ")
            self.lblTitle.showAttributedTxt(semibold: boldString)
        }
    }
    
    @IBAction func linkUrlClicked(_ sender: UIButton) {
        if !url.isEmpty {
            self.delegate?.employmentIndexUrlClicked(url: self.url, controllerTitle: self.controllerTitle)
        }
    }
    
}

class MIHomeMonsterEducationView: UIView {
    @IBOutlet weak var lblCourseType: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTitleCourseType: UILabel!
    @IBOutlet weak var lblTitlekeyword: UILabel!
    
    @IBOutlet weak var lblCourseDetail: UILabel!
    @IBOutlet weak var contentView: UIView?
    var mosterEducationURL : String?
    override func awakeFromNib() {
        self.contentView?.roundCorner(1, borderColor: Color.colorLightGrey, rad: CornerRadius.viewCornerRadius)
        self.contentView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnEducation(_ :))))
    }
    
    class var view: MIHomeMonsterEducationView {
        get {
            let header = UINib(nibName: "MIHomeViews", bundle: nil).instantiate(withOwner: nil, options: nil)[3] as! MIHomeMonsterEducationView
            return header
        }
    }
    func showData(model:MIMonsterEducation){
        self.lblTitle.text = model.title
        self.lblCourseDetail.text = model.name
        self.lblCourseType.text = model.meta_keywords
        self.mosterEducationURL = model.link_rewrite
        self.lblTitleCourseType.textColor = AppTheme.defaltBlueColor
        self.lblTitlekeyword.textColor = AppTheme.defaltBlueColor
        
    }
    @objc func tapOnEducation(_ sender:UITapGestureRecognizer) {
        MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.MONSTER_EDUCATION, data: ["eventValue" : CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK, "cardName": (self.lblTitle.text ?? "") as String], source: "", destination: CONSTANT_SCREEN_NAME.UPSKILL_SCREEN) { (success, response, error, code) in
        }
        if let vcParent = self.superview?.superview?.superview?.parentViewController {
            if self.lblTitle.text == "Certified Compensation and Benefits Manager VS-1004" {
                CommonClass.googleEventTrcking("upskill_screen", action: "monster_eduacation", label: "benefit_management")
                
                
                
            }else if self.lblTitle.text == "Certified WiMAX (4G) Professional VS-1053" {
                CommonClass.googleEventTrcking("upskill_screen", action: "monster_eduacation", label: "wimax_professional")
                
                
                
            }
            
            let vc=Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
            vc.url = self.mosterEducationURL! + "?app=true"
            vc.ttl = self.lblTitle.text!
            let nav = MINavigationViewController(rootViewController:vc)
            nav.modalPresentationStyle = .fullScreen
            vcParent.present(nav, animated: true, completion: nil)
        }
        
    }
}

protocol MIHomeVideoDelegate:class {
    func videoClicked(url:String)
}

class MIHomeVideoView: UIView {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var contentView: UIView?
    @IBOutlet weak var btnVideoIcon: UIButton!
    private var videoUrl = ""
    weak var delegate:MIHomeVideoDelegate?
    override func awakeFromNib() {
        self.contentView?.roundCorner(1, borderColor: UIColor.colorWith(r: 238, g: 229, b: 229, a: 1.0), rad: CornerRadius.viewCornerRadius)
    }
    
    class var view: MIHomeVideoView {
        get {
            let header = UINib(nibName: "MIHomeViews", bundle: nil).instantiate(withOwner: nil, options: nil)[4] as! MIHomeVideoView
            return header
        }
    }
    
    @IBAction func btnVideoClicked(_ sender: UIButton) {
        CommonClass.googleEventTrcking("dashboard_screen", action: "expert_speaks", label: "play_\(sender.tag+1)")
        self.delegate?.videoClicked(url: videoUrl)
    }
    
    func showVideo(info:MIHomeVideos) {
        imgView.cacheImage(urlString: info.image)
        lblTitle.text = info.name
        self.videoUrl = info.video_url
        btnVideoIcon.isHidden = false
    }
}


class MIHomeArticleView: UIView {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var contentView: UIView?
    override func awakeFromNib() {
        self.contentView?.roundCorner(1, borderColor: UIColor.colorWith(r: 238, g: 229, b: 229, a: 1.0), rad: CornerRadius.viewCornerRadius)
    }
    
    class var view: MIHomeArticleView {
        get {
            let header = UINib(nibName: "MIHomeViews", bundle: nil).instantiate(withOwner: nil, options: nil)[5] as! MIHomeArticleView
            return header
        }
    }
    
    func show(info:MIHomeArticle) {
        lblTitle.text = info.title
        imgView.cacheImage(urlString: info.image)
    }
}

protocol MIHomeJobCategoryViewDelegate: class {
    func jobCategoryClicked(ttl: String, jobType:HomeJobCategoryType)
}

class MIHomeJobCategoryView: UIView {
    @IBOutlet weak var imgTopView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var contentView: UIView?
    private var linkURl = ""
    private var jobType = HomeJobCategoryType.walkin
    weak var delegate: MIHomeJobCategoryViewDelegate?

    override func awakeFromNib() {
        self.contentView?.roundCorner(1, borderColor: UIColor.colorWith(r: 178, g: 178, b: 178, a: 0.2), rad: CornerRadius.viewCornerRadius)
        self.imgTopView.circular(0, borderColor: nil)
    }
    
    class var view: MIHomeJobCategoryView {
        get {
            let header = UINib(nibName: "MIHomeViews", bundle: nil).instantiate(withOwner: nil, options: nil)[6] as! MIHomeJobCategoryView
            header.imgTopView.backgroundColor = AppTheme.defaltBlueColor
            return header
        }
    }
    
    @IBAction func categoryClicked(_ sender: UIButton) {
        self.delegate?.jobCategoryClicked(ttl: lblTitle.text ?? "", jobType: self.jobType)
    }
    
    func show(info: MIHomeJobCategory) {
        
        lblTitle.text = info.name
        linkURl = info.link_rewrite
        self.jobType = info.jobType
        lblTitle.setNeedsLayout()
        imgView.image = UIImage(named: info.imgName)
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
}

protocol MIHomeTopCompaniesViewDelegate: class {
    func topCompanyClicked(compId: String)
}

class MIHomeJobTopCompaniesView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var btnCompany: UIButton!
    
    var delegate: MIHomeTopCompaniesViewDelegate?
    var compId = 0
 
        
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView?.roundCorner(1, borderColor: UIColor.colorWith(r: 178, g: 178, b: 178, a: 0.2), rad: CornerRadius.viewCornerRadius)
    }
    
    class var view: MIHomeJobTopCompaniesView {
        get {
            let header = UINib(nibName: "MIHomeViews", bundle: nil).instantiate(withOwner: nil, options: nil)[7] as! MIHomeJobTopCompaniesView
            return header
        }
    }

    @IBAction func btnCompanyPressed(_ sender: Any) {
        self.delegate?.topCompanyClicked(compId: String(self.compId))
    }
    

    func showTopCompanies(compInfo: MIHomeJobTopCompanyModel) {
        self.btnCompany.sd_setImage(with: URL(string: compInfo.logo ?? ""), for: .normal, placeholderImage: #imageLiteral(resourceName: "ic-companyPlaceHolder"), completed: nil)
        self.compId = compInfo.companyId ?? 0
    }
    
    
}


