//
//  MIBaseViewController.swift
//  MonsteriOS
//
//  Created by Monster on 15/10/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

enum EventTrackingValue:String {
    
    case RECOMMENDED_JOBS="RECOMMENDED_JOBS"
    case APPLIED_JOBS="APPLIED_JOBS"
    case SAVED_JOBS="SAVED_JOBS"
    case SRP_JOBS="SRP_JOBS"
    case NETWORK_JOBS="NETWORK_JOBS"
    case RECRUITER_JOBS="RECRUITER_JOBS"
    case COMPANY_JOBS="COMPANY_JOBS"
    case SIMILAR_JOBS="SIMILAR_JOBS"
    case APPLIED_ALSOAPPLIED_JOBS="APPLIED_ALSOAPPLIED_JOBS"
    case JOBALERT_JOBS="JOBALERT_JOBS"
    case JOBDETAIL_APPLY="JOB_DETAIL_SCREEN"
    case NOTIFICATION="NOTIFICATION"
    case NONE=""
    
    
}

class MIBaseViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView?
    @IBOutlet weak var statusBarView: UIView?
    @IBOutlet weak var topViewTopConstraint: NSLayoutConstraint?
    @IBOutlet weak var tblViewBottomConstraint: NSLayoutConstraint!
    var isLoaded = false
    @IBOutlet weak var searchBarHeightConstraint: NSLayoutConstraint?
    
    var myApplySuccessStoredProperty:String=""
    var appliedVenue:WalkInVenue?
    var activityIndicat:MIActivityIndicator?
    var baseSearchId=""
    var eventTrackingValue:EventTrackingValue = .NONE
    
    var requestStartTime: Double = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicat = MIActivityIndicator().activityIndicatorView(onView: self.view)
        activityIndicat?.stopAnimating()
        statusBarView?.backgroundColor = UIColor.white
        topView?.backgroundColor       = UIColor.white
        topView?.addShadow(opacity: 0.1)
        
        if kIsiPhone6Plus {
            searchBarHeightConstraint?.constant = 80
        }
        if kIsiPhoneXS || kIsiPhoneXSMax {
            topViewTopConstraint?.constant = 20
            searchBarHeightConstraint?.constant = 100
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !isLoaded {
            self.initUI()
            self.isLoaded = true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(invalidAuthToken), name: .invalidAuth, object: nil)
    }
    
    @objc func invalidAuthToken() {
        self.logoutToLogin()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
        // self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.view.endEditing(true)
        NotificationCenter.default.removeObserver(self, name: .invalidAuth, object: nil)
        //self.stopActivityIndicator()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // kActivityIndicator.stopAnimating()
        self.activityIndicat?.stopAnimating()
    }
    internal func initUI() { // call super.initUI after all calls
    }
    
    internal func retry() { // get called once internet popup hitted with retry
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func startActivityIndicator() {
        //      self.startActivityIndicator()
        if activityIndicat == nil {
            activityIndicat = MIActivityIndicator().activityIndicatorView(onView: self.view)
            
        }
        activityIndicat?.startAnimating()
    }
    
    func stopActivityIndicator() {
        //      self.stopActivityIndicator()
        MIActivityLoader.hideLoader()
        activityIndicat?.stopAnimating()
    }
    
    @IBAction func backPopClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getSJSURL(model:JoblistingData)->String {
        //https://\(WebURl.domain ?? "monsterindia.com")/seeker/job-details?id=
        var baseUrl="https://\(WebURl.domain ?? "monsterindia.com")/job-vacancy-"
        if model.title != nil {
            baseUrl += model.title!.withoutSpecialCharacters.replacingOccurrences(of: " ", with: "-")
        }
        if model.company?.name != nil {
            baseUrl += "-"
            baseUrl += model.company?.name!.withoutSpecialCharacters.replacingOccurrences(of: " ", with: "-") ?? ""
        }
        
        var locationArray=[String]()
        if let location=model.location{
            for item in location {
                if item.city != nil {
                    locationArray.append(item.city!.withoutSpecialCharacters.withoutWhiteSpace())
                }else if item.country != nil {
                    locationArray.append(item.country!.withoutSpecialCharacters.withoutWhiteSpace())
                }
            }
        }
        if locationArray.count > 0 {
            baseUrl += "-"
            baseUrl += locationArray.joined(separator: "-")
        }
        
        if let minimum=model.minimumExperience?.years {
            baseUrl += "-"
            baseUrl += String(minimum)
        }
        if let maximum=model.maximumExperience?.years  {
            baseUrl += "-"
            baseUrl += String(maximum) + "-years"
        }
        if model.kiwiJobId != nil {
            baseUrl += "-"
            baseUrl += model.kiwiJobId!
        }
        baseUrl += ".html"
        //baseUrl += model.location?.map({$0.city ?? $0.country}) ?? []//replacingOccurrences(of: " ", with: "-") ?? ""
        
        return baseUrl.encodedUrl()
    }
    
    //MARK:Can Apply method
    func applyActionGlobal(jobId: String,redirectURl: String?,param:[String:Any] = [:],searchId:String="", jobApplyModel: JoblistingData? = nil,  completion: (()->Void)? = nil) {
        

        CommonClass.predefinedGenerateLead(jobApplyModel?.industries?.joined(separator: ", ") ?? "", currency: jobApplyModel?.functions?.joined(separator: ", ") ?? "")
        
        //Checking user is login or not
        self.baseSearchId = searchId
        self.startActivityIndicator()
        
        //        DispatchQueue.main.async {
        //         //  if !AppDelegate.instance.authInfo.accessToken.isEmpty{
        //               self.initiateApplyActionEvent(actionType: "APPLY_JOB_INIT", jobId: jobId, jobModel: nil)
        //         //   }
        //        }
        
        let _ = MIAPIClient.sharedClient.load(path:APIPath.canApply, method: .post, params: param.isEmpty ? ["jobId":jobId] : param) {  [weak self](responseData,error,code)  in
            guard let `self` = self else { return }
            
            DispatchQueue.main.async {
                completion?()
                self.stopActivityIndicator()
                // DispatchQueue.main.async {
                if error != nil {
                    if let errorRespons=responseData as? [String:Any] {
                        self.errorCodeApplyHand(errorRespons: errorRespons, jobId: jobId, redirectURL: redirectURl)
                    }
                    else {
                        navigateStartValue = nil
                        // DispatchQueue.main.async {
                        self.showAlert(title: "", message:error?.errorDescription)
                        //}
                    }
                    return
                }else{
                    //  DispatchQueue.main.async {
                    if let errorRespons=responseData as? [String:Any]{
                        let applySuccessModel=ApplySuccessModel(dictionary: errorRespons as NSDictionary)
                        //self.initiateApplyActionEvent(actionType: "APPLY_JOB_SUCCESS", jobId: jobId, jobModel: applySuccessModel?.job)
                    }
                    self.showAlert(title: "", message: "Application Sent Successfully",isErrorOccured:false)
                    isAppliedFlag = true
                    self.myApplySuccessStoredProperty = jobId
                    self.stopActivityIndicator()
                    
                    self.applySuccess(jobId)
                    //   }
                }
            }
        }
        //}
    }
    
    func applySuccess(_ jobID: String) {
        // currentAppliedJobID = jobID
        self.tabbarController?.jobAppliedSuccess(jobID)
        
        //let info = ["jobid": jobID]
        //NotificationCenter.default.post(name: .JobAppliedNotification, object: nil, userInfo: info)
    }
    
    //MARK: Force Apply method
    func forceApplyGlobal(jobId:String,param:[String:Any]=[:]){
        self.startActivityIndicator()
        
        let _ = MIAPIClient.sharedClient.load(path:APIPath.forceApply, method: .post, params: param.isEmpty ?["job":["jobId":jobId],"profileId":UserDefaults.standard.integer(forKey: "profileId")] : param) {[weak self] (responseData,error,code) in
            
            guard let `self`=self else {return}
            DispatchQueue.main.async {
                self.stopActivityIndicator()
                if error == nil{
                    //  DispatchQueue.main.async {
                    
                    
                    if let errorRespons=responseData as? [String:Any]{
                        let applySuccessModel=ApplySuccessModel(dictionary: errorRespons as NSDictionary)
                        
                        //    self.initiateApplyActionEvent(actionType: "APPLY_JOB_SUCCESS", jobId: jobId, jobModel: applySuccessModel?.job)
                        
                        if (applySuccessModel?.next == ApplyErrorCode.APPLY_REDIRECT_STAGE_NONE.rawValue || applySuccessModel?.next == ApplyErrorCode.APPLY_REDIRECT_STAGE_ONE.rawValue) && (applySuccessModel?.job?.redirectUrl?.count ?? 0 > 0){
                            let vc=Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
                            vc.url = applySuccessModel?.job?.redirectUrl ?? ""
                            vc.ttl = ""
                            let nav = MINavigationViewController(rootViewController:vc)
                            nav.modalPresentationStyle = .fullScreen
                            self.present(nav, animated: true, completion: nil)
                        }
                    }
                    
                    self.showAlert(title: "", message: "Application Sent Successfully",isErrorOccured:false)
                    isAppliedFlag=true
                    self.appliedVenue=WalkInVenue(newDict: param)
                    self.myApplySuccessStoredProperty=jobId
                    
                    self.applySuccess(jobId)
                    //  }
                }else{
                    // DispatchQueue.main.async {
                    // self.stopActivityIndicator()
                    if let errorRespons=responseData as? [String:Any]{
                        self.errorCodeApplyHand(errorRespons: errorRespons, jobId: jobId, redirectURL: nil)
                    }else{
                        self.showAlert(title: "", message: error?.errorDescription)
                    }
                    // }
                }
            }
        }
    }
    
    func errorCodeApplyHand(errorRespons:[String:Any],jobId:String,redirectURL:String?){
        
        let response=ApplyErrorBase(dictionary: errorRespons as NSDictionary)
        var actionType="APPLY_JOB_POPUP_"
        
        if response?.errorCode == ApplyErrorCode.CANNOT_APPLY.rawValue{
            if response?.payload?.result?.next == ApplyErrorCode.INCOMPLETE_PROFILE.rawValue{
                //Go to incomplete profile details
                
                if let pendingArray=response?.payload?.result?.pendingActions{
                    let pendFilter=pendingArray.filter({$0.pendingActionType.rawValue == PendingActionType.EDUCATION.rawValue || $0.pendingActionType.rawValue == PendingActionType.EMPLOYMENT.rawValue})
                    if pendFilter.count > 0{
                        // self.initiateApplyActionEvent(actionType:"", jobId:jobId, jobModel: response?.payload?.result?.job)
                        actionType += pendFilter[0].pendingActionType.rawValue
                        self.initiatePendingViewGlobal(pendingMode: pendFilter[0], jobId: jobId,redirectURL: redirectURL)
                    }
                }
            }
                //Having multiple profile
            else if response?.payload?.result?.next == ApplyErrorCode.MULTIPLE_PROFILES.rawValue{
                if let profileArray=response?.payload?.result?.profiles{
                    actionType += ApplyErrorCode.MULTIPLE_PROFILES.rawValue
                    self.initialteMultiProfileView(jobId: jobId, profileArray: profileArray)
                }
            }
                //  Job has question
            else if response?.payload?.result?.next == ApplyErrorCode.SCREENING_QUESTIONNAIRE.rawValue{
                if let model=response?.payload?.result?.screeningQuestionnaire?.questions{
                    actionType += ApplyErrorCode.SCREENING_QUESTIONNAIRE.rawValue
                    self.initiateQuestionnarie(jobId: jobId, model: model)
                }
            }
                //Job Redirect URL
            else if response?.payload?.result?.next == ApplyErrorCode.APPLY_REDIRECT_STAGE_NONE.rawValue{
                DispatchQueue.main.async {
                    if AppDelegate.instance.authInfo.accessToken.isEmpty{
                        //Redirect Stage for non Logged In
                        actionType += "STAGE_NONE"
                        self.initiateNonLoggedInApply(jobId: jobId, redirectUrl:response?.payload?.result?.job?.redirectUrl ?? "" )
                        
                    }else{
                        actionType += "REDIRECT"
                        self.appleRedirectPopUp(jobId: jobId, redirectUrl:response?.payload?.result?.job?.redirectUrl ?? "" )
                    }
                }
                
            }
            else if response?.payload?.result?.next == ApplyErrorCode.APPLY_REDIRECT_STAGE_ONE.rawValue{
                actionType += "REDIRECT"
                self.appleRedirectPopUp(jobId: jobId, redirectUrl:response?.payload?.result?.job?.redirectUrl ?? "" )
            }
            else if response?.payload?.result?.next == ApplyErrorCode.WALKIN_PRO.rawValue{
                actionType += ApplyErrorCode.WALKIN_PRO.rawValue
                self.initiateWalkInPro(jobId: jobId, model: response?.payload?.result?.job?.walkInSchedules ?? [])
            }
                
            else{
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    self.forceApplyGlobal(jobId: jobId)
                }
            }
        }
            //Profile not found for that country
        else if response?.errorCode == ApplyErrorCode.PROFILE_NOT_FOUND.rawValue{
            DispatchQueue.main.async {
                self.stopActivityIndicator()
                //                AKAlertController.alert("", message: errorRespons["errorMessage"]as?String, acceptMessage: "Change Country") {
                //                    let vc=MISettingHomeViewController()
                //                    vc.selectedSettingType = .changecountry
                //                    //vc.isFromProfileVC = true
                //                    self.navigationController?.pushViewController(vc, animated: true)
                //                    vc.title = "Select Country"
                //                }
                
                
                self.showPopUpView(message: errorRespons["errorMessage"] as? String ?? "Profile Not Found", primaryBtnTitle: NSLocalizedString("mbdoccapture.createProfileTile", comment: ""), secondaryBtnTitle: NSLocalizedString("mbdoccapture.changeCountry", comment: "")) { (isPrimarBtnClicked) in
                        if isPrimarBtnClicked {
                            let vc = MICreateProfileVC()
                            shouldRunProfileApi = true
                            self.navigationController?.pushViewController(vc, animated: true)

                        }else{
                                let vc=MISettingHomeViewController()
                                vc.selectedSettingType = .changecountry
                                vc.isFromProfileVC = true
                                self.navigationController?.pushViewController(vc, animated: true)
                                
                                vc.title = "Select Country"


                        }
                      
                }

                
                
                
//                let vPopup = MIJobPreferencePopup.popup()
//                vPopup.setViewWithTitle(title: "", viewDescriptionText:  errorRespons["errorMessage"] as? String ?? "Profile Not Found", or: "", primaryBtnTitle: NSLocalizedString("mbdoccapture.createProfileTile", comment: ""), secondaryBtnTitle:NSLocalizedString("mbdoccapture.changeCountry", comment: ""))
//                vPopup.completionHandeler = {
//                    let vc = MICreateProfileVC()
//                    shouldRunProfileApi = true
//                    self.navigationController?.pushViewController(vc, animated: true)
//
//                }
//                vPopup.cancelHandeler = {
//                        let vc=MISettingHomeViewController()
//                        vc.selectedSettingType = .changecountry
//                        vc.isFromProfileVC = true
//                        self.navigationController?.pushViewController(vc, animated: true)
//
//                        vc.title = "Select Country"
//
//
//                }
//                vPopup.addMe(onView: self.view, onCompletion: nil)

//                let alert = UIAlertController(title: "", message: errorRespons["errorMessage"]as?String, preferredStyle: UIAlertController.Style.alert)
//                let createBtn = UIAlertAction(title: NSLocalizedString("mbdoccapture.createProfileTile", comment: ""), style: .default, handler: { (action: UIAlertAction) in
//                    let vc = MICreateProfileVC()
//                    shouldRunProfileApi = true
//                    self.navigationController?.pushViewController(vc, animated: true)
//                })
//                let changeCountryBtn = UIAlertAction(title: NSLocalizedString("mbdoccapture.changeCountry", comment: ""), style: .default, handler: { (action: UIAlertAction) in
//                    let vc=MISettingHomeViewController()
//                    vc.selectedSettingType = .changecountry
//                    vc.isFromProfileVC = true
//                    self.navigationController?.pushViewController(vc, animated: true)
//
//                    vc.title = "Select Country"
//                })
//                alert.addAction(createBtn)
//                alert.addAction(changeCountryBtn)
//
//                // show the alert
//                self.present(alert, animated: true, completion: nil)
            }
        }else if response?.errorCode == ApplyErrorCode.NON_LOGIN.rawValue{
            actionType += "WITHOUT_LOGIN"
            DispatchQueue.main.async {
                self.stopActivityIndicator()
                if AppDelegate.instance.authInfo.accessToken.isEmpty{
                    self.showLoginAlert(msg:"Please log in to continue.",navaction: .apply,jobId: jobId)
                }else{
                    self.logoutToLogin()
                }
            }
        }
        else{
            DispatchQueue.main.async {
                self.stopActivityIndicator()
                self.showAlert(title: "", message: errorRespons["errorMessage"]as?String)
            }
        }
        //        DispatchQueue.main.async {
        //             self.initiateApplyActionEvent(actionType: actionType, jobId: jobId, jobModel: response?.payload?.result?.job)
        //        }
        
    }
    
    //MARK:Pending Profile Details
    func initiatePendingViewGlobal(pendingMode:MIPendingItemModel,jobId:String,redirectURL:String?){
        
        DispatchQueue.main.async {
            self.stopActivityIndicator()
            

            self.showPopUpView(title: pendingMode.pendingActionType.title, message: pendingMode.pendingActionType.applydescription, primaryBtnTitle: pendingMode.pendingActionType.actionBtnTitle, secondaryBtnTitle: "Not Now") { (isPrimarBtnClicked) in
                if isPrimarBtnClicked {
                    
                    switch pendingMode.pendingActionType {
                    case .PROFILE_SUMMARY:
                        break
                    case .RESUME:
                        if let uploadResum = pendingMode.pendingActionType.viewControler as? MIUploadResumeViewController {
                            uploadResum.flowVia = .ViaPendingResume
                            uploadResum.resumeUploadedAction = {(status,name,result) in
                                self.successUpdate(jobId: jobId)
                            }
                            
                            self.navigationController?.pushViewController(uploadResum, animated: false)
                        }
                    case .EDUCATION:
                        if let addEducationVc = pendingMode.pendingActionType.viewControler as? MIEducationDetailViewController {
                            addEducationVc.educationFlow = .ViaProfileAdd
                            
                            addEducationVc.educationAddedSuccess = {success in
                                
                                self.successUpdate(jobId: jobId)
                            }
                            self.navigationController?.pushViewController(addEducationVc, animated: false)
                        }
                        break
                    case .PERSONAL:
                        if let personalVC = pendingMode.pendingActionType.viewControler as? MIPersonalDetailVC {
                            personalVC.personalDetailUpdateSuccessCallBack = {status in
                                self.successUpdate(jobId: jobId)
                            }
                            self.navigationController?.pushViewController(personalVC, animated: false)
                        }
                        break
                        
                    case .VERIFY_EMAIL_ID:
                        if let emailverifyVC = pendingMode.pendingActionType.viewControler as? MIForgotPasswordViewController {
                            self.navigationController?.pushViewController(emailverifyVC, animated: false)
                        }
                        break
                        
                    case .VERIFY_MOBILE_NUMBER:
                        if let emailverifyVC = pendingMode.pendingActionType.viewControler as? MIForgotPasswordViewController {
                            self.navigationController?.pushViewController(emailverifyVC, animated: false)
                        }
                        break
                        
                    case .EMPLOYMENT:
                        if let employmentVC = pendingMode.pendingActionType.viewControler as? MIEmploymentDetailViewController {
                            
                            employmentVC.employementFlow = .ViaProfileAdd
                            employmentVC.employementAddedSuccess = {status in
                                self.successUpdate(jobId: jobId)
                            }
                            self.navigationController?.pushViewController(employmentVC, animated: false)
                        }
                        break
                        
                    case .PROJECTS:
                        if let projectVC = pendingMode.pendingActionType.viewControler as? MIProjectDetailVC {
                            self.navigationController?.pushViewController(projectVC, animated: false)
                        }
                        break
                        
                    default:
                        break
                        
                    }
                    
                }
            }
            
            
//            let vPopup = MIJobPreferencePopup.popup()
//            vPopup.setViewWithTitle(title: pendingMode.pendingActionType.title, viewDescriptionText:  pendingMode.pendingActionType.applydescription, or: "", primaryBtnTitle: pendingMode.pendingActionType.actionBtnTitle, secondaryBtnTitle: "Not Now")
//            vPopup.closeBtn.isHidden = true
//            vPopup.addMe(onView: self.view, onCompletion: nil)
//
//            vPopup.completionHandeler = {
//
//                switch pendingMode.pendingActionType {
//                case .PROFILE_SUMMARY:
//                    break
//                case .RESUME:
//                    if let uploadResum = pendingMode.pendingActionType.viewControler as? MIUploadResumeViewController {
//                        uploadResum.flowVia = .ViaPendingResume
//                        uploadResum.resumeUploadedAction = {(status,name,result) in
//                            self.successUpdate(jobId: jobId)
//                        }
//
//                        self.navigationController?.pushViewController(uploadResum, animated: false)
//                    }
//                case .EDUCATION:
//                    if let addEducationVc = pendingMode.pendingActionType.viewControler as? MIEducationDetailViewController {
//                        addEducationVc.educationFlow = .ViaProfileAdd
//
//                        addEducationVc.educationAddedSuccess = {success in
//
//                            self.successUpdate(jobId: jobId)
//                        }
//                        self.navigationController?.pushViewController(addEducationVc, animated: false)
//                    }
//                    break
//                case .PERSONAL:
//                    if let personalVC = pendingMode.pendingActionType.viewControler as? MIPersonalDetailVC {
//                        personalVC.personalDetailUpdateSuccessCallBack = {status in
//                            self.successUpdate(jobId: jobId)
//                        }
//                        self.navigationController?.pushViewController(personalVC, animated: false)
//                    }
//                    break
//
//                case .VERIFY_EMAIL_ID:
//                    if let emailverifyVC = pendingMode.pendingActionType.viewControler as? MIForgotPasswordViewController {
//                        self.navigationController?.pushViewController(emailverifyVC, animated: false)
//                    }
//                    break
//
//                case .VERIFY_MOBILE_NUMBER:
//                    if let emailverifyVC = pendingMode.pendingActionType.viewControler as? MIForgotPasswordViewController {
//                        self.navigationController?.pushViewController(emailverifyVC, animated: false)
//                    }
//                    break
//
//                case .EMPLOYMENT:
//                    if let employmentVC = pendingMode.pendingActionType.viewControler as? MIEmploymentDetailViewController {
//
//                        employmentVC.employementFlow = .ViaProfileAdd
//                        employmentVC.employementAddedSuccess = {status in
//                            self.successUpdate(jobId: jobId)
//                        }
//                        self.navigationController?.pushViewController(employmentVC, animated: false)
//                    }
//                    break
//
//                case .PROJECTS:
//                    if let projectVC = pendingMode.pendingActionType.viewControler as? MIProjectDetailVC {
//                        self.navigationController?.pushViewController(projectVC, animated: false)
//                    }
//                    break
//
//                default:
//                    break
//
//                }
//
//            }
            //            let pendVc = MIApplyViewController()
            //            pendVc.pendingItemModel = pendingMode
            //            pendVc.pendinActionSuccess = { (Bool) in
            //                self.forceApplyGlobal(jobId: jobId)
            //               // self.applyActionGlobal(jobId:jobId, redirectURl: redirectURL )
            //                if let navView = self.tabBarController?.viewControllers?[0] as? MINavigationViewController {
            //                    if let homeView = navView.viewControllers.first as? MIHomeViewController{
            //                        homeView.modulesArray.removeAll()
            //                        homeView.tblView.reloadData()
            //                        homeView.callApi()
            //
            //
            //
            //        }
            //
            //     }
            //
            //            }
            
        }
    }
    func successUpdate(jobId: String) {
        self.forceApplyGlobal(jobId: jobId)
        // self.applyActionGlobal(jobId:jobId, redirectURl: redirectURL )
        
        if let navView = self.tabBarController?.viewControllers?[0] as? MINavigationViewController {
            if let homeView = navView.viewControllers.first as? MIHomeViewController {
                homeView.modulesArray.removeAll()
                homeView.tblView.reloadData()
                homeView.callApi()
            }
        }
    }
    
    //MARK:Multiple profile selection
    func initialteMultiProfileView(jobId:String,profileArray:[MIExistingProfileInfo]){
        DispatchQueue.main.async {
            self.stopActivityIndicator()
            let pendVc=MIMultiprofileApplyViewController()
            pendVc.existingProfileModels=profileArray
            pendVc.applyActionSuccess={(isActive,profileId) in
                self.forceApplyGlobal(jobId: jobId, param: ["job":["jobId":jobId],"profileId":profileId,"multipleProfilePopUpVisible":false])
            }
            
            let navigation=MINavigationViewController(rootViewController:pendVc)
            navigation.modalPresentationStyle = .overCurrentContext
            self.tabBarController?.present(navigation, animated: true, completion: nil)
        }
    }
    //MARK:Questionnarie
    func initiateQuestionnarie(jobId:String,model:[Questions]){
        DispatchQueue.main.async {
            self.stopActivityIndicator()
            let pendVc=MIQuestionnaireViewController()
            pendVc.questionModels=model
            pendVc.submitActionSuccess={(para) in
                self.forceApplyGlobal(jobId: jobId, param: ["job":["jobId":jobId],"profileId":UserDefaults.standard.integer(forKey: "profileId"),"answers":para])
            }
            let navigation = MINavigationViewController(rootViewController:pendVc)
            navigation.modalPresentationStyle = .fullScreen
            self.tabBarController?.present(navigation, animated: true, completion: nil)
        }
    }
    
    func initiateWalkInPro(jobId:String,model:[WalkInSchedule]){
        DispatchQueue.main.async {
            self.stopActivityIndicator()
            let pendVc=MIWalkinVenueViewController()
            pendVc.walkInVenueArray=model
            pendVc.submitActionSuccess={(param) in
                self.forceApplyGlobal(jobId: jobId, param: ["job":["jobId":jobId],"profileId":UserDefaults.standard.integer(forKey: "profileId"),"walkInVenue":param])
                
            }
            //  pendVc.modalPresentationStyle = .fullScreen
            let navigation=MINavigationViewController(rootViewController:pendVc)
            navigation.modalPresentationStyle = .fullScreen
            self.tabBarController?.present(navigation, animated: true, completion: nil)
        }
    }
    
    func appleRedirectPopUp(jobId:String,redirectUrl:String){
        DispatchQueue.main.async {
            self.stopActivityIndicator()
            
            self.showPopUpView(message: jobPostedOn, primaryBtnTitle: "OK", secondaryBtnTitle: "Cancel") { (isPrimarBtnClicked) in
                if isPrimarBtnClicked {
                    self.forceApplyGlobal(jobId: jobId,param:["job":["jobId":jobId],"profileId":UserDefaults.standard.integer(forKey: "profileId"),"redirectFlowUserDetail":["name":AppDelegate.instance.userInfo.fullName,"email":AppDelegate.instance.userInfo.primaryEmail,"mobileNumber":["countryCode":AppDelegate.instance.userInfo.countryCode,"mobileNumber":AppDelegate.instance.userInfo.mobileNumber]]])

                }
            }
            
            
//            let vPopup = MIJobPreferencePopup.popup()
//            vPopup.closeBtn.isHidden = true
//
//            vPopup.setViewWithTitle(title: "", viewDescriptionText:  jobPostedOn, or: "", primaryBtnTitle: "Ok", secondaryBtnTitle:"Cancel")
//            vPopup.completionHandeler = {
//                self.forceApplyGlobal(jobId: jobId,param:["job":["jobId":jobId],"profileId":UserDefaults.standard.integer(forKey: "profileId"),"redirectFlowUserDetail":["name":AppDelegate.instance.userInfo.fullName,"email":AppDelegate.instance.userInfo.primaryEmail,"mobileNumber":["countryCode":AppDelegate.instance.userInfo.countryCode,"mobileNumber":AppDelegate.instance.userInfo.mobileNumber]]])
//
//            }
//            vPopup.cancelHandeler = {
//                    
//
//            }
//            vPopup.addMe(onView: self.view, onCompletion: nil)

            
//            let alertController=UIAlertController(title: "", message: jobPostedOn, preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
//
//                self.forceApplyGlobal(jobId: jobId,param:["job":["jobId":jobId],"profileId":UserDefaults.standard.integer(forKey: "profileId"),"redirectFlowUserDetail":["name":AppDelegate.instance.userInfo.fullName,"email":AppDelegate.instance.userInfo.primaryEmail,"mobileNumber":["countryCode":AppDelegate.instance.userInfo.countryCode,"mobileNumber":AppDelegate.instance.userInfo.mobileNumber]]])
//                //  DispatchQueue.main.async {
//                //  self.stopActivityIndicator()
//                //                let vc=Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
//                //                vc.url = redirectUrl
//                //                vc.ttl = ""
//                //                self.present(MINavigationViewController(rootViewController:vc), animated: true, completion: nil)
//                //   }
//
//            }))
//            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func initiateNonLoggedInApply(jobId:String,redirectUrl:String){
        // MINonLoginApplyViewController
        self.stopActivityIndicator()
        let pendVc=MINonLoginApplyViewController()
        pendVc.submitActionSuccess={(param) in
            if param.count > 0{
                self.forceApplyGlobal(jobId:jobId, param: ["job":["jobId":jobId],"redirectFlowUserDetail":param])
            }else{
                self.forceApplyGlobal(jobId:jobId, param: ["job":["jobId":jobId]])
            }
            DispatchQueue.main.async {
                self.stopActivityIndicator()
                //                let vc=Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
                //                vc.url = redirectUrl
                //                vc.ttl = ""
                //                self.present(MINavigationViewController(rootViewController:vc), animated: true, completion: nil)
            }
            
        }
        pendVc.modalPresentationStyle = .fullScreen
        let navigation=MINavigationViewController(rootViewController:pendVc)
        navigation.modalPresentationStyle = .fullScreen
        self.present(navigation, animated: true, completion: nil)
    }
    
    func initiateApplyActionEvent(actionType:String, jobId:String, jobModel:JoblistingData?) {
        
        var param=[String:Any]()
        param["type"] = actionType
        param["currentTimestamp"] = Date().currentTimeMillis()
        param["sessionId"] = sessionId
        
        let site = AppDelegate.instance.site
        param["countryCode"] = site?.defaultCountryDetails.isoCode
        param["siteContext"] = site?.context
        param["referralUrl"] = self.eventTrackingValue.rawValue
        param["tenant"] = "iOS"
        param["userAgent"] = UIDevice.modelName
        param["deviceId"] = UIDevice.current.identifierForVendor!.uuidString
        
        var dataParam = [String:Any]()
        dataParam["jobId"] = jobId
        dataParam["searchId"] = self.baseSearchId
        dataParam["locations"] = jobModel?.location?.map({$0.city ?? $0.country ?? ""})
        dataParam["industries"] = jobModel?.industries
        dataParam["functions"] = jobModel?.functions
        dataParam["roles"] = jobModel?.roles
        dataParam["jobTypes"] = jobModel?.jobTypes
        dataParam["employmentTypes"] = jobModel?.employmentTypes
        dataParam["recruiterId"] = jobModel?.recruiterId
        dataParam["companyId"] = jobModel?.companyId
        dataParam["companyName"] = jobModel?.company?.name
        dataParam["skills"] = jobModel?.skills?.map({$0.text ?? ""})
        param["data"] = dataParam
        
        
        let _ = MIAPIClient.sharedClient.load(path: APIPath.applyTrackEvent, method: .post, params: ["events":[param]]) { (response, error,code) in
            if error != nil{
                return
            }
        }
    }
    
    func callIsViewedApi(jobId:Int) {
        
        let _ = MIAPIClient.sharedClient.load(path: APIPath.viewedJobs, method: .post, params: ["jobId":jobId]) { (response, error, code) in
            
            return
        }
    }
    
    
    
}


public extension UIDevice {
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad Mini 5"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
}


extension MIBaseViewController: MILoginEmailCellDelegate {
    
    func txtFldDidBeginEditing(fld: UITextField) {
        self.setMainViewFrame(originY: 0)
        let movingHeight = fld.movingHeightIn(view : self.view)
        if movingHeight > 0 {
            UIView.animate(withDuration: 0.3) {
                self.setMainViewFrame(originY: -movingHeight)
            }
        }
    }
    
    func txtFldDidEndEditing(fld: UITextField) {
        UIView.animate(withDuration: 0.3) {
            self.setMainViewFrame(originY: 0)
        }
    }
    
    
    func setMainViewFrame(originY: CGFloat)    {
        var frame = self.view.frame
        frame.origin.y = CGFloat(originY)
        self.view.frame = frame
    }
    
}


