//
//  MINoticationPendingActionCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 10/07/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

protocol PendingActionCompletedDelegate {
    func pendingActionSuccess()
}

class MINoticationPendingActionCell: UITableViewCell {

    @IBOutlet weak var pendingTitleLabel: UILabel!{
        didSet{
            pendingTitleLabel.textColor = UIColor.init(hex: "212b36")
            pendingTitleLabel.font = UIFont.customFont(type: .Medium, size: 16)
        }
    }
    @IBOutlet weak var actionButton: UIButton!
    var delegate:PendingActionCompletedDelegate?
    var viewModel:NotificationViewModel!{
        didSet{
            self.pendingTitleLabel.text=viewModel.title
            self.actionButton.setTitle(viewModel.buttonTitle, for: .normal)
            if viewModel.actionTaken{
                self.actionButton.isEnabled=false
                self.actionButton.alpha = 0.5
            }else{
                self.actionButton.isEnabled=true
                self.actionButton.alpha = 1
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.pendingTitleLabel.text=nil
        self.selectionStyle = .none
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.pendingTitleLabel.text = nil
        self.actionButton.isEnabled=true
        self.actionButton.alpha=1
    }

    @IBAction func pendingButtonAction(_ sender: Any) {
        self.pendigAction()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func pendigAction(){
        
        switch viewModel.pendingActionType {
        case .PROFILE_SUMMARY:
            break
        case .RESUME , .RESUME_UPDATED_IN_LAST_90_DAYS :
            
            if let uploadResum = viewModel.pendingActionType.viewControler as? MIUploadResumeViewController {
                uploadResum.flowVia = .ViaPendingResume
                
                if let parentVC =  self.superview?.parentViewController {
                    
                    uploadResum.resumeUploadedAction = { [weak self]  (status,name,result) in
                        
                      self?.checkPendingAction()
                    }
                    parentVC.navigationController?.pushViewController(uploadResum, animated: false)
                }
            }
            
        case .EDUCATION:
            if let addEducationVc = viewModel.pendingActionType.viewControler as? MIEducationDetailViewController {
                addEducationVc.educationFlow = .ViaProfileAdd
                if let parentVC =  self.superview?.parentViewController {
                    addEducationVc.educationAddedSuccess = { [weak self] success in
                        self?.checkPendingAction()
                    }
                    parentVC.navigationController?.pushViewController(addEducationVc, animated: false)
                    
                }
            }
            break
            
        case .PERSONAL:
            if let personalVC = viewModel.pendingActionType.viewControler as? MIPersonalDetailVC {
                if let parentVC =  self.superview?.parentViewController  {
                    personalVC.personalDetailUpdateSuccessCallBack = {[weak self] status in
                        self?.checkPendingAction()
                    }
                    
            parentVC.navigationController?.pushViewController(personalVC, animated: false)
                    
                }
            }
            break
            
        case .VERIFY_EMAIL_ID:
            
            if let parentVC =  self.superview?.parentViewController {
                let emailVC = MIVerifyEmailTemplateViewController()
                emailVC.userEmail = AppDelegate.instance.userInfo.primaryEmail
                self.checkPendingAction()
                parentVC.navigationController?.pushViewController(emailVC, animated: true)
            }
            break
            
        case .VERIFY_MOBILE_NUMBER:
            if AppDelegate.instance.userInfo.mobileNumber.count > 5 {
                if let mobileverifyVC = viewModel.pendingActionType.viewControler as? MIOTPViewController {
                    mobileverifyVC.openMode = .verifyMobileNumber
                    mobileverifyVC.delegate = self
                    mobileverifyVC.countryCode = AppDelegate.instance.userInfo.countryCode
                    mobileverifyVC.userName = AppDelegate.instance.userInfo.mobileNumber
                    mobileverifyVC.otpVerifySuccess = { [weak self] status in
                        self?.checkPendingAction()
                    }
                    
                    if let parentVC =  self.superview?.parentViewController {
                parentVC.navigationController?.pushViewController(mobileverifyVC, animated: false)
                        
                    }
                }
            }else{
                let vc = MIEditProfileVC()
                vc.basicProfileInfo = AppDelegate.instance.userInfo
                
                if let parentVC =  self.superview?.parentViewController {
                    //  parentVC.navigationController?.pushViewController(mobileverifyVC, animated: false)
                    
                    vc.editProfileSuccess = {[weak self] status in
                        
                        if status {
                          self?.checkPendingAction()
                        }
                    }
                    parentVC.navigationController?.pushViewController(vc, animated: true)
                    
                    
                }
            }
            
            
            break
            
        case .EMPLOYMENT:
            if let employmentVC = viewModel.pendingActionType.viewControler as? MIEmploymentDetailViewController {
                if let parentVC =  self.superview?.parentViewController  {
                    employmentVC.employementFlow = .ViaProfileAdd
                    employmentVC.employementAddedSuccess = { [weak self] status in
                        self?.checkPendingAction()
                    }
                    parentVC.navigationController?.pushViewController(employmentVC, animated: false)
                    
                }
                //self.checkForAllPendingAction()
            }
            break
            
        case .PROJECTS:
            if let projectVC = viewModel.pendingActionType.viewControler as? MIProjectDetailVC {
                if let parentVC =  self.superview?.parentViewController {
                    projectVC.projectAddedSuccess = { [weak self] status in
                        self?.checkPendingAction()
                    }
                    parentVC.navigationController?.pushViewController(projectVC, animated: false)
                    
                }
            }
            break
        case .JOB_PREFERENCES_PREFERRED_LOCATION,.JOB_PREFERENCES_INDUSTRY,.JOB_PREFERENCES_FUNCTION,.JOB_PREFERENCES_ROLE:
            if let jobPref = viewModel.pendingActionType.viewControler as? MIJobPreferenceViewController {
                if let parentVC =  self.superview?.parentViewController{
                    
                    jobPref.flowVia = .ViaPendingAction
                    jobPref.jobpreferenceSuccessPendingAction={[weak self](status,model) in
                        self?.checkPendingAction(model)
                    }
                    parentVC.navigationController?.pushViewController(jobPref, animated: false)
                }
            }
            break
            
        case .PROFILE_TITLE:
            if let pendingAction = viewModel.pendingActionType.viewControler as? MIPendingActionViewController {
                if let parentVC =  self.superview?.parentViewController  {
                    pendingAction.pendingactionSuccess = { [weak self] status in
                       
                      self?.checkPendingAction()
                    }
                    pendingAction.pendingType = .NOTICE_PERIOD
                    parentVC.navigationController?.pushViewController(pendingAction, animated: true)
                    
                }
            }
            
            break
        case .PROFILE_PICTURE:
            if let parentVC =  self.superview?.parentViewController  {
                
                if let homeTab = parentVC.tabBarController as? MIHomeTabbarViewController {
                    homeTab.showActionSheetForUserSelection(personalDetail: nil)
                    homeTab.profilePictureSuccess = { [weak self] status in
                       self?.checkPendingAction()
                    }
                }
                
            }
            break
        case .NOTICE_PERIOD:
            if let pendingAction = viewModel.pendingActionType.viewControler as? MIPendingActionViewController {
                if let parentVC =  self.superview?.parentViewController {
                    pendingAction.pendingactionSuccess = {  [weak self] status in
                        self?.checkPendingAction()
                    }
                    pendingAction.pendingType = .NOTICE_PERIOD
                    parentVC.navigationController?.pushViewController(pendingAction, animated: true)
                    
                }
            }
            break
        case .KEY_SKILL:
            if let skillVC = viewModel.pendingActionType.viewControler as? MISkillAddViewController {
                if let parentVC =  self.superview?.parentViewController {
                    skillVC.flowVia = .ViaProfileAdd
                    skillVC.addSkillSuccess = {[weak self] status in
                        self?.checkPendingAction()
                    }
                    parentVC.navigationController?.pushViewController(skillVC, animated: true)
                    
                }
            }
            break
        case .IT_SKILL:
            if let itskillVC = viewModel.pendingActionType.viewControler as? MIITSkillsVC {
                if let parentVC =  self.superview?.parentViewController  {
                    itskillVC.addITSkillSuccess = {  [weak self] status in
                        self?.checkPendingAction()
                    }
                    parentVC.navigationController?.pushViewController(itskillVC, animated: true)
                    
                }
            }
            break
        case .COURSE_AND_CERTIFICATION:
            if let courseVC = viewModel.pendingActionType.viewControler as? MICoursesCertificatinVC {
                if let parentVC =  self.superview?.parentViewController{
                    courseVC.courseAddedSuccess = {  [weak self] status in
                        self?.checkPendingAction()
                    }
                    parentVC.navigationController?.pushViewController(courseVC, animated: true)
                    
                }
            }
            break
            
        case .WORK_HISTORY:
            
            break
        case .NATIONALITY:
            if let pendingAction = viewModel.pendingActionType.viewControler as? MIPendingActionViewController {
                if let parentVC =  self.superview?.parentViewController{
                    pendingAction.pendingactionSuccess = {  [weak self] status in
                        self?.checkPendingAction()
                    }
                    pendingAction.pendingType = .NATIONALITY
                    parentVC.navigationController?.pushViewController(pendingAction, animated: true)
                }
            }
            break
            
        default:
            break
            
        }
    }
    func checkPendingAction(_ model:MIJobPreferencesModel? = nil){
        delegate?.pendingActionSuccess()
        if let parentVc=self.superview?.parentViewController{
            if let pv=parentVc as? MINotificationViewController{
            for (index,var item) in pv.viewModel.enumerated(){
                if item.keyValue==self.viewModel.keyValue && item.pendingActionType == viewModel.pendingActionType && item.title == viewModel.title{
                    item.actionTaken=true
                    pv.viewModel[index]=item
                    break
                }
            }
            pv.tableView.reloadData()
            }else if let pv=parentVc as? MINotificationPendingViewController{
                if model != nil{
                    if model?.preferredLocationList.count != 0{
                        for (index,item) in pv.allViewModel.enumerated(){
                            if item.pendingActionType == PendingActionType.JOB_PREFERENCES_PREFERRED_LOCATION{
                                pv.allViewModel.remove(at: index)
                            }
                        }
                    }
                    if model?.preferredRoles.count != 0{
                        for (index,item) in pv.allViewModel.enumerated(){
                            if item.pendingActionType == PendingActionType.JOB_PREFERENCES_ROLE{
                                pv.allViewModel.remove(at: index)
                            }
                        }
                    }
                    if model?.preferredFunctions.count != 0{
                        for (index,item) in pv.allViewModel.enumerated(){
                            if item.pendingActionType == PendingActionType.JOB_PREFERENCES_FUNCTION{
                                pv.allViewModel.remove(at: index)
                            }
                        }
                    }
                    if model?.preferredIndustrys.count != 0{
                        for (index,item) in pv.allViewModel.enumerated(){
                            if item.pendingActionType == PendingActionType.JOB_PREFERENCES_INDUSTRY{
                                pv.allViewModel.remove(at: index)
                            }
                        }
                    }
                pv.viewModel=pv.allViewModel.unique(map: {$0.pendingActionType.title})
                }else{
                for (index,var item) in pv.viewModel.enumerated(){
                    if item.keyValue==self.viewModel.keyValue && item.pendingActionType == viewModel.pendingActionType && item.title == viewModel.title{
                        item.actionTaken=true
                        pv.viewModel[index]=item
                        break
                    }
                }
                }
                pv.tableView.reloadData()
            }
            if let tabbar=parentVc.tabBarController as? MIHomeTabbarViewController{
                if let homeNav=tabbar.viewControllers?[0] as? MINavigationViewController{
                    if let homeVc=homeNav.viewControllers[0] as? MIHomeViewController{
                        homeVc.modulesArray.removeAll()
                    }
                }
                
            }
        }
    }
}

extension MINoticationPendingActionCell:PendingActionDelegate{
    func verifiedUser(_ id: String, openMode: OpenMode) {
        self.checkPendingAction()
    }
}
