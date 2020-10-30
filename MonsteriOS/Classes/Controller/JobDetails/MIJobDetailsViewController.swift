//
//  MIJobDetailsViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 16/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
let savedIcon=#imageLiteral(resourceName: "star-fill")
let unSavedIcon=#imageLiteral(resourceName: "star-outline")

protocol JobsAppliedOrSaveDelegate{
    func jobSaveUnsave(model:JoblistingData?,isSaved:Bool)
    func jobApplied(model:JoblistingData?)
    func companyFollowUnFollow(compId:Int,isFollow:Bool)
}

protocol CompanyOrRecFollowDelegate{
    func companyRecuiterFollowUnFollow(type:CompanyOrRec,actionType:RequestMethod,id:String)
}

extension CompanyOrRecFollowDelegate{
    func companyRecuiterFollowUnFollow(type:CompanyOrRec,actionType:RequestMethod,id:String){}
}

extension JobsAppliedOrSaveDelegate{
    func companyFollowUnFollow(compId:Int,isFollow:Bool){}
}

class MIJobDetailsViewController: MIBaseViewController {
    
    //MARK:Outlets And Variables
    override var myApplySuccessStoredProperty: String{
        didSet{
            if myApplySuccessStoredProperty.count > 0 && !self.isApplyFromSimilarJobs{
                
                self.jsonData?.isApplied = true
                self.appliedOrSaved=true
                self.setIsApplied()
                
                for vc in self.navigationController?.viewControllers ?? []{
                    if let detailsVc=vc as? MIJobDetailsViewController{
                        if detailsVc.jobId==myApplySuccessStoredProperty{
                            detailsVc.jsonData?.isApplied = true
                            detailsVc.appliedOrSaved=true
                            detailsVc.setIsApplied()
                            detailsVc.delegate?.jobApplied(model: self.jsonData)
                            detailsVc.listView.tableView.reloadData()
                        }
                    }
                }
                
                self.delegate?.jobApplied(model: self.jsonData)
                self.listView.tableView.reloadData()
                if self.jsonData?.redirectUrl?.count == 0 || self.jsonData?.redirectUrl == nil {
                    let vc=MIJobAppliedSuccesViewController()
                    vc.jobModel=self.jsonData
                    vc.abTestingVersion = abTestingVersion
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }else if myApplySuccessStoredProperty.count > 0 && self.isApplyFromSimilarJobs {
                if  self.myApplySuccessStoredProperty.isNumeric {
                    if let data = self.similarJobsData?.data?.filter({$0.jobId != Int(self.myApplySuccessStoredProperty )}) {
                        self.similarJobsData?.data = data
                        self.myApplySuccessStoredProperty = ""
                        self.listView.tableView.reloadData()
                        self.navigationController?.navigationBar.isHidden=false
                        self.title=ControllerTitleConstant.jobDetails
                        self.navigationItem.leftBarButtonItem?.title = nil
                        
                    }
                }
            }
        }
    }
    
    var autoApply = false
    
    override var appliedVenue: WalkInVenue?{
        didSet{
            self.jsonData?.walkInVenue = appliedVenue
        }
    }
    
    var compRecDelegate:CompanyOrRecFollowDelegate?
    var isCompDelegate=false
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var applieddetailsLabel: UILabel!
    @IBOutlet weak var listView: MIJobDetailsTableView!
    
    var appliedOrSaved=false
    var isApplyFromSimilarJobs=false
    var searchIdNew=""
    var referralUrl:EventTrackingValue = .NONE
    var abTestingVersion = ""
    
    var searchIdForAB=""
    var locationList = ""
    
    //MARK:Life Cycle Method
    var jsonData:JoblistingData?
    var savedJobData:JoblistingBaseModel?
    var similarJobsData:JoblistingBaseModel?
    var jobId:String = ""
    var delegate:JobsAppliedOrSaveDelegate?
    private var nojobPopup  = MINoJobFoundPopupView.popup()
    lazy var savedButton=UIBarButtonItem(image: unSavedIcon, style: .done, target: self, action: #selector(MIJobDetailsViewController.savedAndShareButtonAction(_:)))
    lazy var shareButton=UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(MIJobDetailsViewController.savedAndShareButtonAction(_:)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let location = self.jsonData?.location
        CommonClass.predefinedViewTerm(self.jobId, itemLocationId: locationList) //Firebase predefined view_item //
        
        self.view.backgroundColor = AppTheme.viewBackgroundColor
        self.applyButton.showPrimaryBtn()
        self.applyButton.setTitle("Apply", for: .normal)
        self.applieddetailsLabel.textColor = .white
        self.applieddetailsLabel.font = UIFont.customFont(type: .Semibold, size: 15)
        self.applieddetailsLabel.text = " Applied "
        self.applieddetailsLabel.textAlignment = .center
        self.applyButton.isHidden=true
        self.applieddetailsLabel.isHidden=true
        listView.isHidden=true
        bottomView.isHidden=true
        
        self.getJobDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CommonClass.googleAnalyticsScreen(self) //GA for Screen
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)
        
        self.seekerJourneyMapEvents(type: CONSTANT_JOB_SEEKER_TYPE.VIEW_JOB, data:  ["eventValue" : CONSTANT_JOB_SEEKER_EVENT_VALUE.LANDING, "jobId": self.jobId])
        
        //        if  navigateJobId?.isNumeric ?? false {
        //            if let data = self.similarJobsData?.data?.filter({$0.jobId != Int(navigateJobId ?? "0")}) {
        //                self.similarJobsData?.data = data
        //                navigateJobId = nil
        //            }
        //        }
        
        self.listView.tableView.reloadData()
        self.navigationController?.navigationBar.isHidden=false
        self.title=ControllerTitleConstant.jobDetails
        self.navigationItem.leftBarButtonItem?.title = nil
        self.checkNavigateAPI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title=""
    }
    
    deinit {
        kActivityIndicator.stopAnimating()
    }
    func refereshJobDetailAfterLogin(jobApplyNav:NavigateAction,jobApplyId:String){
        self.getJobDetails(jobapplyNav: jobApplyNav,jobid: jobApplyId)
    }
    func seekerJDEvent(_ action: String, similarJob: [String: Any]? = nil, source: String = "",version:String) {
        
        var data = [
            "jobId" : self.jobId as Any,
        ]
        
        if let job = similarJob {
            data["similarJobs"] = job
            
        }
        if action == "JOB_APPLY" || action == "LANDING" {
            data["apiRequestTime"] = self.requestStartTime
            data["apiResponseTime"] = Date().timeIntervalSince1970
        }
        
        var param = [
            "apiId" : version.isEmpty ? (abTestingVersion.isEmpty ? "V1" : abTestingVersion) : version ,
            "pageType" : "JD",
            "action" : action, //[RELATED_SEARCHES]
            "sessionId" : sessionId,
            "source" : source.isEmpty ? referralUrl.rawValue : source,
            "data" : data
            ] as [String : Any]
        
        param["searchId"] = self.searchIdForAB
        
        MIApiManager.seekerABTestingAPI(param) { (result, error) in
            
        }
    }
    
    
    func setIsApplied(){
        listView.isHidden=false
        bottomView.isHidden=false
        savedButton.tag=0
        shareButton.tag=1
        self.navigationItem.rightBarButtonItems=nil
        self.navigationItem.rightBarButtonItems=[shareButton,savedButton]
        
        if appliedOrSaved{
            self.applyButton.isHidden=true
            self.bottomView.backgroundColor = AppTheme.greenColor
            self.applieddetailsLabel.isHidden=false
            if let model=jsonData{
                if model.isApplied != nil,model.isApplied!{
                    self.applieddetailsLabel.text="Applied"
                    if jsonData?.jobAppliedDate != nil{
                        self.applieddetailsLabel.text=formatPostedDate(dateValue: model.jobAppliedDate!, titl: SRPListingStoryBoardConstant.applied )
                    }
                }
                
            }
            //self.applieddetailsLabel.text
        }else{
            applieddetailsLabel.isHidden=true
            self.applyButton.isHidden=false
            // self.bottomView.backgroundColor = .green
        }
    }
    
    func getJobDetails(jobapplyNav:NavigateAction? = NavigateAction.none,jobid:String? = ""){
        self.nojobPopup.removeMe()
        self.startActivityIndicator()
        self.requestStartTime = Date().timeIntervalSince1970
        let _ = MIAPIClient.sharedClient.load(path: APIPath.getJobDetails, method: .get, params: ["jobId":self.jobId,"searchId":searchIdNew,"referralUrl":referralUrl.rawValue]) { [weak self](responseData, error,code) in
            
            DispatchQueue.main.async {
                guard let wkSelf=self else {return}
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
                    wkSelf.stopActivityIndicator()
                })
                if error != nil{
                    //  DispatchQueue.main.async {
                    // MIActivityLoader.hideLoader()
                    if error?.errorDescription == ServiceError.noInternetConnection.errorDescription{
                        wkSelf.nojobPopup.show(ttl: ErrorAndValidationMsg.opps.rawValue, desc:ErrorAndValidationMsg.somethingWrong.rawValue,imgNm: "plugbase")
                        wkSelf.nojobPopup.addFromTop(onView: wkSelf.view, topHeight:80, onCompletion: nil)
                    }else if code==401{
                        //  wkSelf.logoutToLogin()
                    }
                    else{
                        wkSelf.showAlert(title: "", message: error?.errorDescription)
                    }
                    
                    //   }
                    return
                }else{
                    if let jsonData=responseData as? [String:Any]{
                        wkSelf.listView.sectionTitle.removeAll()
                        if let details=jsonData["job"] as? NSDictionary{
                            wkSelf.jsonData=JoblistingData(dictionary: details)
                            //Add Clever Tap Event for View Jobs
                            // DispatchQueue.main.async{
                            if wkSelf.jsonData != nil{
                                let modelData=JoblistingCellModel(model: wkSelf.jsonData!)
                                printDebug(modelData)
                            }
                            // }
                        }
                        if let similarJob=jsonData["similar_jobs"] as? [String:Any]{
                            wkSelf.similarJobsData=JoblistingBaseModel(dictionary: similarJob as NSDictionary)
                        }
                        if let viewsCount=jsonData["viewed_count"] as? [String:Any]{
                            if let views=viewsCount["views"]as?Int{
                                wkSelf.listView.totalViews=String(views)
                            }
                        }
                        //  DispatchQueue.main.async {
                        wkSelf.listView.modelData = wkSelf.jsonData
                        wkSelf.listView.similarJobsData = wkSelf.similarJobsData
                        if wkSelf.jsonData?.isSaved != nil{
                            if (wkSelf.jsonData?.isSaved!)!{
                                wkSelf.savedButton.image=savedIcon
                            }
                        }
                        if let isApled=wkSelf.jsonData?.isApplied{
                            if isApled{
                                wkSelf.appliedOrSaved=true
                            }
                        }
                        
                        wkSelf.setIsApplied()
                        if jobapplyNav == .apply {
                            //Case for Job apply
                            if wkSelf.isApplyFromSimilarJobs {
                                //    wkSelf.isApplyFromSimilarJobs = false
                                //Case for Similar job apply
                                if jobid?.isNumeric ?? false {
                                    let job = wkSelf.similarJobsData?.data?.filter({$0.jobId == Int(jobid ?? "0") })
                                    if job?.count ?? 0 > 0 {
                                        if let filterObject = job?.first,!(filterObject.isApplied ?? true),let jobid  = filterObject.jobId {
                                            wkSelf.applyAction(jobId: "\(jobid)")
                                            if let data = wkSelf.similarJobsData?.data?.filter({$0.jobId != jobid}) {
                                                wkSelf.similarJobsData?.data = data
                                                navigateJobId = nil
                                                
                                            }
                                        }else if job?.first?.isApplied ?? false {
                                            self?.showAlert(title: "", message: GenericErrorMessage.jobAlreadyApplied, isErrorOccured: false)
                                            
                                        }
                                    }
                                }
                            }else{
                                wkSelf.isApplyFromSimilarJobs = false
                                //Case for Job Apply
                                if !wkSelf.appliedOrSaved {
                                    wkSelf.applyAction(jobId: wkSelf.jobId)
                                }else if wkSelf.appliedOrSaved {
                                    self?.showAlert(title: "", message: GenericErrorMessage.jobAlreadyApplied, isErrorOccured: false)
                                }
                            }
                            // }
                        }
                        wkSelf.listView.tableView.reloadData()
                        //   DispatchQueue.main.async {
                        //   self?.stopActivityIndicator()
                        if wkSelf.autoApply {
                            wkSelf.applyAction(jobId: wkSelf.jobId)
                        }
                        //   }
                    }
                    //  DispatchQueue.main.async {
                    wkSelf.seekerJDEvent("LANDING",version:"")
                    //   }
                }
            }
        }
    }
    
    //MARK:Save And Share navigation Button Action
    @objc func savedAndShareButtonAction(_ sender:UIBarButtonItem){
        switch sender.tag {
        case 0:
            if AppDelegate.instance.authInfo.accessToken.isEmpty{
                self.seekerJourneyMapEvents(type: CONSTANT_JOB_SEEKER_TYPE.SAVED_JOBS, data: ["eventValue" : CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK, "jobId"  : self.jobId])
                
                self.showLoginAlert(msg: "Please log in to continue.",navaction: .save,jobId: self.jobId)
            }else{
                kActivityIndicator.startAnimating()
                if sender.image == savedIcon{
                    self.saveUnSaveApiCall(path: APIPath.unsaveJob, sender: sender)
                }else{
                    self.seekerJourneyMapEvents(type: CONSTANT_JOB_SEEKER_TYPE.SAVED_JOBS, data: ["eventValue" : CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK, "jobId"  : self.jobId])
                    CommonClass.googleEventTrcking("job_detail_screen", action: "save", label: "")
                    
                    self.saveUnSaveApiCall(path: APIPath.saveJob, sender: sender)
                }
            }
            self.seekerJDEvent("SAVE_JOB",version:"")
            
        case 1:
            let data =  ["eventValue" :CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK, "jobId" : self.jobId]
            self.seekerJourneyMapEvents(type: CONSTANT_JOB_SEEKER_TYPE.SHARE_JOB, data: data)
            
            self.shareAction(sender)
            self.seekerJDEvent("SHARE",version: "")
        default:
            break
        }
    }
    
    func saveUnSaveApiCall(path:String,sender:UIBarButtonItem){
        
        
        let _ = MIAPIClient.sharedClient.load(path:path, method: path==APIPath.saveJob ? .post : .delete, params: ["jobId":self.jobId]) { [weak self] (responseData, error,code) in
            guard let wkSelf=self else {return}
            DispatchQueue.main.async {
                kActivityIndicator.stopAnimating()
                
                if error != nil{
                    //  DispatchQueue.main.async {
                    if code==401{
                        // self?.logoutToLogin()
                    }else{
                        self?.showAlert(title: "", message: error!.errorDescription)
                    }
                    //  }
                    return
                } else {
                    //  DispatchQueue.main.async {
                    // kActivityIndicator.stopAnimating()
                    isSavedOrUnsaved=true
                    
                    if path==APIPath.saveJob{
                        wkSelf.delegate?.jobSaveUnsave(model: wkSelf.jsonData, isSaved: true)
                        sender.image = savedIcon
                        for vc in wkSelf.navigationController?.viewControllers ?? []{
                            if let detailsVc=vc as? MIJobDetailsViewController{
                                detailsVc.savedButton.image=savedIcon
                                detailsVc.delegate?.jobSaveUnsave(model: wkSelf.jsonData, isSaved: true)
                            }
                        }
                        
                    } else {
                        wkSelf.delegate?.jobSaveUnsave(model: wkSelf.jsonData, isSaved: false)
                        sender.image = unSavedIcon
                        for vc in wkSelf.navigationController?.viewControllers ?? []{
                            if let detailsVc=vc as? MIJobDetailsViewController{
                                detailsVc.savedButton.image=unSavedIcon
                                detailsVc.delegate?.jobSaveUnsave(model: wkSelf.jsonData, isSaved: false)
                            }
                        }
                        //   wkSelf.showAlert(title: "", message: "Unsaved Successfully",isErrorOccured:false)
                    }
                    // }
                }
            }
        }
    }
    //MARK:Share Method
    func shareAction(_ sender:UIBarButtonItem){
        
        let firstActivityItem = self.jsonData?.title ?? ""
        
        let sharUrl="https://\(WebURl.domain ?? "monsterindia.com")/seeker/job-details?id="
        let secondActivityItem : URL = URL(string:sharUrl+jobId)!
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem,secondActivityItem], applicationActivities: nil)
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.barButtonItem = sender
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = .any
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo, .openInIBooks
        ]
        
        //GA get medium
        activityViewController.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            let activityType = activityType?.rawValue
            let type = activityType?.components(separatedBy: ".").last?.lowercased()
            
            CommonClass.googleEventTrcking("job_detail_screen", action: "share", label: type ?? "")
            if completed && CommonClass.isLoggedin() {
                self.tabbarController?.showRatingView(from: .FromJobShare)
            }
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func applyButtonAction(_ sender: Any) {
        self.isApplyFromSimilarJobs = false
        self.applyAction(jobId: self.jobId)
        self.seekerJourneyMapEvents(type: CONSTANT_JOB_SEEKER_TYPE.JD_APPLY, data: ["eventValue" : CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK, "jobId": self.jobId])
        CommonClass.googleEventTrcking("job_detail_screen", action: "apply", label: self.jobId) //GA
    }
    
    func applyAction(jobId: String) {
        MIActivityLoader.showLoader()
        self.eventTrackingValue = .JOBDETAIL_APPLY
        self.requestStartTime = Date().timeIntervalSince1970
        self.applyActionGlobal(jobId: jobId, redirectURl: self.jsonData?.redirectUrl,searchId:searchIdNew, jobApplyModel: self.jsonData) {
            self.seekerJDEvent("JOB_APPLY",version:(self.isApplyFromSimilarJobs  ?  (self.similarJobsData?.meta?.version ?? "V1") : ""))
        }
    }
    
    func seekerJourneyMapEvents(type: String, data: [String: Any]) {
        MIApiManager.hitSeekerJourneyMapEvents(type, data: data, source: "", destination: CONSTANT_SCREEN_NAME.JOBDETAIL) { (success, response, error, code) in
        }
    }
    
    func skipJob(jobId:String) {
        
        if CommonClass.isLoggedin() {
            if jobId.isEmpty{
                return
            }
            let _ = MIAPIClient.sharedClient.load(path: APIPath.skippedJob, method: .post, params: ["jobId":jobId]) { (response, error, code) in
                
                if code >= 200 && code < 300 {
                    if let message = (response as? JSONDICT)?.stringFor(key: "successMessage") {
                        self.showAlert(title: "", message: message,isErrorOccured: false)
                        
                    }
                }
            }
        }else{
            self.showAlert(title: "", message: "Please log in to continue.")
        }
        
    }
}

enum ApplyErrorCode:String{
    case CANNOT_APPLY = "CANNOT_APPLY"
    case INCOMPLETE_PROFILE="INCOMPLETE_PROFILE"
    case RESUME_UNAVAILABLE="RESUME_UNAVAILABLE"
    case SCREENING_QUESTIONNAIRE="SCREENING_QUESTIONNAIRE"
    case MULTIPLE_PROFILES="MULTIPLE_PROFILES"
    case MULTIPLE_PROFILES_NO_POPUP="MULTIPLE_PROFILES_NO_POPUP"
    case APPLY_REDIRECT="APPLY_REDIRECT"
    case APPLY_REDIRECT_STAGE_NONE="APPLY_REDIRECT_STAGE_NONE"
    case APPLY_REDIRECT_STAGE_ONE="APPLY_REDIRECT_STAGE_ONE"
    case APPLY_REDIRECT_STAGE_TWO="APPLY_REDIRECT_STAGE_TWO"
    case APPLY_REDIRECT_STAGE_THREE="APPLY_REDIRECT_STAGE_THREE"
    case PROFILE_NOT_FOUND = "PROFILE_NOT_FOUND"
    case WALKIN_PRO="WALKIN_PRO"
    case NON_LOGIN="401 UNAUTHORIZED"
    // case APPLY_REDIRECT_STAGE_NONE="APPLY_REDIRECT_STAGE_NONE"
}



