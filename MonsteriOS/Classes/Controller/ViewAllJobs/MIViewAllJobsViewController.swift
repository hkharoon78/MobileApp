//
//  MIViewAllJobsViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 17/04/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import SwipeCellKit
import MaterialShowcase

enum ViewAllControllerType{
    case recomended
    case similarJobs
    case appliedAlsoAplplied
    case jobAlertApi
    
    var title:String{
        switch self {
        case .recomended:
            return "Recommended Jobs"
        case .similarJobs:
            return "Similar Jobs"
        case .appliedAlsoAplplied:
            return "People also applied for"
        case .jobAlertApi:
            return ""
        }
    }
    var urlPath:String{
        switch self {
        case .recomended:
            return APIPath.suggestedJobs
        case .similarJobs:
            return APIPath.similarJobs
        case .appliedAlsoAplplied:
            return APIPath.appliedalsoapplied
        case .jobAlertApi:
            return APIPath.searchJob
        }
    }
    var pageName:String{
        switch self {
        case .recomended:
            return "Recomended_Jobs"
        case .similarJobs:
            return "Similar_Jobs"
        case .appliedAlsoAplplied:
            return "People_applied_for"
        case .jobAlertApi:
            return "JobAlert_Jobs"
        }
    }
    var eventType:EventTrackingValue{
        switch self {
        case .recomended:
            return .RECOMMENDED_JOBS
        case .similarJobs:
            return .SIMILAR_JOBS
        case .appliedAlsoAplplied:
            return .APPLIED_ALSOAPPLIED_JOBS
        case .jobAlertApi:
            return .JOBALERT_JOBS
        }
    }
    var jobSeekerDestinationUrl:String {
        switch self {
        case .recomended:
            return CONSTANT_SCREEN_NAME.RECOMMENDED_JOBS
        case .similarJobs:
            return CONSTANT_SCREEN_NAME.SIMILAR_JOB
        case .appliedAlsoAplplied:
            return CONSTANT_SCREEN_NAME.APPLIED_ALSO_APPLY_JOB
        case .jobAlertApi:
            return CONSTANT_SCREEN_NAME.MANAGEVIEWJOB
        }
        
    }
    //    var jobSeekerSourceUrl:String {
    //        switch self {
    //        case .recomended:
    //            return CONSTANT_SCREEN_NAME.HOME
    //        case .similarJobs:
    //            return CONSTANT_SCREEN_NAME.JOBDETAIL
    //        case .appliedAlsoAplplied:
    //            return CONSTANT_SCREEN_NAME.JOBDETAIL
    //        case .jobAlertApi:
    //            return CONSTANT_SCREEN_NAME.MANAGEJOBALERT
    //        }
    //
    //    }
}

class MIViewAllJobsViewController: MIBaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var jsonModelData:JoblistingBaseModel?
    var isPaginationRunning = false
    var param=[String:Any]()
    var nextPage=0
    var controllerType:ViewAllControllerType! = ViewAllControllerType.recomended
    let spinner = UIActivityIndicatorView(style: .gray)
    private var nojobPopup  = MINoJobFoundPopupView.popup()
    var jobAlertitle=""
    let showcase  = MaterialShowcase()
    
    var searchIdForAB = ""
    
    override var myApplySuccessStoredProperty: String{
        didSet{
            if myApplySuccessStoredProperty.count > 0{
                let filterData=self.jsonModelData?.data?.filter{$0.jobId == Int(myApplySuccessStoredProperty)}
                if filterData?.count ?? 0 > 0{
                    filterData![0].isApplied=true
                }
                self.tableView.reloadData()
            }
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(MISRPJobListingViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = Color.colorDarkBlack
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
//        self.jsonModelData = nil
//        self.tableView.reloadData()
//        self.startActivityIndicator()
//        nextPage = 0
//        self.callSimilaryJobsApi(next: nextPage)
        self.loadAPIDataWithInitialPage()
        refreshControl.endRefreshing()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName:String(describing: MIJobListingTableCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIJobListingTableCell.self))
        tableView.register(UINib(nibName:String(describing: MIFeedbackTableCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIFeedbackTableCell.self))
        
        tableView.delegate=self
        tableView.dataSource=self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        //tableView.tableFooterView=UIView(frame: .zero)
        tableView.bounces=true
        spinner.tintColor = AppTheme.defaltTheme
        spinner.hidesWhenStopped=true
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        self.tableView.tableFooterView = spinner
        self.tableView.tableFooterView?.isHidden=true
        self.startActivityIndicator()
        self.tableView.addSubview(refreshControl)
        self.callSimilaryJobsApi(next: nextPage)
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(refreshJobListData), name: NSNotification.Name.refreshJobList, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        JobSeekerSingleton.sharedInstance.addScreenName(screenName: controllerType.jobSeekerDestinationUrl)
        if self.controllerType == ViewAllControllerType.jobAlertApi{
            self.navigationItem.title=self.jobAlertitle
        }else{
            self.navigationItem.title=self.controllerType.title
        }
        MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.SEARCH, data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.LANDING], destination: self.screenName) { (success, response, error, code) in
            
        }
    }
    func loadAPIDataWithInitialPage(){
        self.jsonModelData = nil
        self.tableView.reloadData()
        self.startActivityIndicator()
        nextPage = 0
        self.callSimilaryJobsApi(next: nextPage)
    }
    @objc func refreshJobListData(){

        self.loadAPIDataWithInitialPage()
    }
    func callSimilaryJobsApi(next:Int){
        param[SRPListingDictKey.next.rawValue]=next
        self.requestStartTime = Date().timeIntervalSince1970
        let _ = MIAPIClient.sharedClient.load(path:controllerType.urlPath, method:controllerType == .jobAlertApi ? .post : .get, params: param) { [weak self] (response, error, code) in
            DispatchQueue.main.async {
                
                guard let wkself=self else {return}
                wkself.stopActivityIndicator()
                
                wkself.isPaginationRunning=false
                if error != nil{
                    //  DispatchQueue.main.async {
                    wkself.tableView.tableFooterView?.isHidden=true
                    if error?.errorDescription == ServiceError.noInternetConnection.errorDescription{
                        wkself.nojobPopup.show(ttl: ErrorAndValidationMsg.opps.rawValue, desc:ErrorAndValidationMsg.somethingWrong.rawValue,imgNm: "plugbase")
                        wkself.nojobPopup.addFromTop(onView: wkself.view, topHeight:66, onCompletion: nil)
                    }else if code==401{
                        //  wkself.logoutToLogin()
                    }
                    else{
                        wkself.showAlert(title: "", message: error!.errorDescription)
                    }
                    //  }
                    return
                }else{
                    if let jsonData=response as? [String:Any]{
                        
                        let alrtJobbase=JoblistingBaseModel(dictionary: jsonData as NSDictionary)
                        if wkself.jsonModelData == nil{
                            wkself.jsonModelData=alrtJobbase
                            
                            wkself.searchIdForAB = alrtJobbase?.meta?.resultId ?? ""
                        }else{
                            for item in alrtJobbase?.data ?? []{
                                wkself.jsonModelData?.data?.append(item)
                            }
                            wkself.jsonModelData?.meta=alrtJobbase?.meta
                        }
                        // DispatchQueue.main.async {
                        wkself.tableView.reloadData()
                        wkself.tableView.tableFooterView?.isHidden=true
                        //  wkself.stopActivityIndicator()
                        // }
                        
                        //set tutorial in view all jobs
                        if wkself.controllerType == ViewAllControllerType.recomended {
                            //   DispatchQueue.main.async {
                            
                            wkself.view.bringSubviewToFront(self!.showcase)
                            let shouldhideTutorial = userDefaults.bool(forKey: "srpFirstTimeTutorial")
                            if !shouldhideTutorial{
                                self?.showTutorials()
                            }
                            //   }
                        }
                        
                    }
                }
                
                //DispatchQueue.main.async {
                wkself.abTestingRecommendedJobEvent("LANDING")
                // }
            }
        }
        
    }
    
    //MARK:Show Tutorial
    func showTutorials(){
        if let cell = self.tableView.cellForRow(at: IndexPath(row: 0,section: 0)) as? MIJobListingTableCell{
            cell.showSwipe(orientation: .left, animated: true, completion: nil)
            
            userDefaults.set(true, forKey: "srpFirstTimeTutorial")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showcase.setTargetView(view: cell)
                self.showcase.isTapRecognizerForTargetView=false
                self.showcase.targetHolderColor = .clear
                self.showcase.backgroundViewType = .full
                self.showcase.targetHolderRadius = self.view.frame.width/1.5
                self.showcase.primaryText = "Apply Job"
                self.showcase.secondaryText = "Swipe right to apply job"
                self.showcase.aniRippleColor = .clear
                self.showcase.show(completion:nil)
            }
        }
    }
    
    func abTestingRecommendedJobEvent(_ action: String, jobID: String?=nil) {
        guard self.controllerType == .recomended else { return }
        
        var pageNumber = 1
        if let id = jobID {
            let index = (self.jsonModelData?.data?.firstIndex(where: { $0.jobId?.stringValue == id }) ?? 0)+1
            pageNumber = index / (self.jsonModelData?.meta?.paging?.limit ?? 1)
            if index % (self.jsonModelData?.meta?.paging?.limit ?? 1) > 0 {
                pageNumber += 1
            }
        } else {
            pageNumber = (self.jsonModelData?.data?.count ?? 1) / (self.jsonModelData?.meta?.paging?.limit ?? 1)
        }
        
        var data = [
            "resultCount":self.jsonModelData?.meta?.paging?.total as Any,
            "query" : [
                "pageSize" : self.jsonModelData?.meta?.paging?.limit as Any,
                "pageNo" : pageNumber
            ]
        ]
        if action == "LANDING" {
            data["apiRequestTime"] = self.requestStartTime
            data["apiResponseTime"] = Date().timeIntervalSince1970
        }
        if let id = jobID {
            let limit = self.jsonModelData?.meta?.paging?.limit ?? 1
            var rank = (self.jsonModelData?.data?.firstIndex(where: { $0.jobId?.stringValue == jobID }) ?? 0)+1
            //rank = rank % (pageNumber*limit)
            //rank = (rank==0) ? limit : rank
            rank = rank - ((pageNumber-1)*limit)
            
            data["jobId"] = id
            data["jobRank"] = rank
        }
        
        let param = [
            "apiId" : self.jsonModelData?.meta?.version ?? "V1",
            "pageType" : "RECOMMENDED_JOBS",
            "action" : action,//LANDING
            "searchId" : searchIdForAB,
            "sessionId" : sessionId,
            "source" : "homepage", //”homepage”, [JD]
            "data" : data
            ] as [String : Any]
        
        MIApiManager.seekerABTestingAPI(param) { (result, error) in
        }
    }
    
}

extension MIViewAllJobsViewController: UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.jsonModelData?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentDate = Date().getStringWithFormat(format: "dd/MM/yyyy")
        let lastDate = AppUserDefaults.value(forKey: .JobFeedbackLastDate, fallBackValue: "").stringValue
        if lastDate != currentDate {
            AppUserDefaults.removeValue(forKey: .JobFeedbackQueries)
        }
        
        let query = self.controllerType.title
        
        let queries = AppUserDefaults.value(forKey: .JobFeedbackQueries, fallBackValue: []).arrayObject as? [String] ?? []
        
        let resultID = self.jsonModelData?.meta?.resultId
        
        if (section+1) % 8 == 0 && !queries.contains(query) && resultID != nil && CommonClass.isLoggedin() {
            // For displaying feedback card
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MIJobListingTableCell.self), for: indexPath) as! MIJobListingTableCell
            let modelData=self.jsonModelData?.data![indexPath.section]
            cell.modelData=JoblistingCellModel(model: modelData!,isSearchLogo:modelData!.isSearchLogo ?? 0)
            
            cell.saveUnSaveAction={ [weak self] save in
                if let modelData=self?.jsonModelData?.data?[indexPath.section]{
                    modelData.isSaved=save
                    //GA
                    if save {
                        let lbl = "\(indexPath.row)" + "-" + String(modelData.jobId ?? 0)
                        
                        self?.seekerJourneyMapEvents(type: CONSTANT_JOB_SEEKER_TYPE.SAVED_JOBS, data: ["eventValue" : CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK, "jobId": String(modelData.jobId ?? 0)])
                        
                        CommonClass.googleEventTrcking("similar_jobs_screen", action: "save", label: lbl)
                        
                        self?.abTestingRecommendedJobEvent("SAVE_JOB", jobID: modelData.jobId?.stringValue)
                        
                    }
                }
                self?.tableView.reloadData()
            }
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withClass: MIFeedbackTableCell.self, for: indexPath)
            
            cell.likeButton.addTarget(self, action: #selector(likeAction), for: .touchUpInside)
            cell.dislikeButton.addTarget(self, action: #selector(disLikeAction), for: .touchUpInside)
            
            return cell
        }
    }
    
    
    @objc func likeAction() {
        self.submitFeedback(1)
        CommonClass.googleEventTrcking("similar_jobs_screen", action: "feedback", label: "positive")
    }
    
    @objc func disLikeAction() {
        self.submitFeedback(0)
        CommonClass.googleEventTrcking("similar_jobs_screen", action: "feedback", label: "negative")
    }
    
    func submitFeedback(_ value: Int) {
        guard let resultID = self.jsonModelData?.meta?.resultId else { return }
        
        let param = [
            "resultId" : resultID,
            "feedback" : value.stringValue,
            "pageName" : self.controllerType.pageName,
            "appVersion" : UIApplication.appVersion()
        ]
        
        let currentDate = Date().getStringWithFormat(format: "dd/MM/yyyy")
        
        
        MIApiManager.jobFeedbackAPI(param) {  (result, error) in
            
            var query = ""
            if self.controllerType == ViewAllControllerType.jobAlertApi{
                if let keyword = self.param["query"] as? String {
                    query = keyword
                }else{
                    query = self.jobAlertitle
                }
            }else{
                query = self.controllerType.title
            }
            if !query.isEmpty {
                var queries = AppUserDefaults.value(forKey: .JobFeedbackQueries, fallBackValue: []).arrayObject ?? []
                queries.append(query)
                AppUserDefaults.save(value: queries, forKey: .JobFeedbackQueries)
            }
            AppUserDefaults.save(value: currentDate, forKey: .JobFeedbackLastDate)
            
            self.toastView(messsage: "Thank you for your valuable feedback",isErrorOccured:false)
            
            self.tableView.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view=UIView()
        view.backgroundColor = AppTheme.viewBackgroundColor
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row == 0 else { return }
        
        self.abTestingRecommendedJobEvent("JOB_VIEW", jobID: self.jsonModelData?.data?[indexPath.section].jobId?.stringValue)
        
        if let data=self.jsonModelData?.data,data.count > (indexPath.section){
            data[indexPath.section].isViewed=true
            if let cell = tableView.cellForRow(at: indexPath) as? MIJobListingTableCell {
                cell.enable(on: false)
            }
            // self.tableView.reloadRows(at: [indexPath], with: .automatic)
            
            if self.self.jsonModelData!.data![indexPath.section].jobTypes?.filter({$0.lowercased().contains("sjs")}).count ?? 0 > 0 || self.jsonModelData!.data![indexPath.section].isCJT == 1{
                self.callIsViewedApi(jobId: data[indexPath.section].jobId ?? 0)
                
                let vc=Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
                vc.url = self.getSJSURL(model: self.jsonModelData!.data![indexPath.section])
                vc.ttl = "Detail"
                let nav = MINavigationViewController(rootViewController:vc)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }else{
                let vc=MIJobDetailsViewController()
                vc.jobId = String(self.jsonModelData!.data![indexPath.section].jobId!)
                vc.delegate=self
                vc.referralUrl = self.controllerType.eventType
                vc.abTestingVersion = self.jsonModelData?.meta?.version ?? "V1"
                vc.searchIdForAB =  String(self.jsonModelData!.data![indexPath.section].resultId)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if let modelData=self.jsonModelData?.data![indexPath.section]{
            if modelData.isApplied != nil{
                if modelData.isApplied!{
                    return nil
                }
            }
        }
        guard orientation == .left else { return nil }
        var title=SRPListingStoryBoardConstant.Apply
        if self.jsonModelData?.data![indexPath.section].jobTypes?.filter({$0==JobTypes.walkIn.value}).count ?? 0 > 0{
            title=SRPListingStoryBoardConstant.imIntersted
        }
        
        let applyAction = SwipeAction(style: .default, title:title) { action, indexPath in
            let model=self.jsonModelData?.data![indexPath.section]
            
            self.seekerJourneyMapEvents(type: CONSTANT_JOB_SEEKER_TYPE.APPLY, data: ["eventValue" : CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK, "jobId": String(model!.jobId!)])
            
            self.applyAction(jobId: String(model!.jobId!), redirctURl: model?.redirectUrl, jobApplyTracking: model!)
            // handle action by updating model with deletion
        }
        applyAction.backgroundColor = AppTheme.greenColor
        return [applyAction]
    }
    
    func applyAction(jobId: String,redirctURl:String?, jobApplyTracking: JoblistingData) {
        self.eventTrackingValue=self.controllerType.eventType 
        
        self.requestStartTime = Date().timeIntervalSince1970
        
        self.applyActionGlobal(jobId: jobId, redirectURl: redirctURl, jobApplyModel: jobApplyTracking) {
            self.abTestingRecommendedJobEvent("JOB_APPLY", jobID: jobId)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 2.0 {
            if !isPaginationRunning{
                isPaginationRunning = true
                self.callPagination()
                
            }
        }
    }
    
    func seekerJourneyMapEvents(type: String, data: [String: Any]) {
        MIApiManager.hitSeekerJourneyMapEvents(type, data: data, source: "", destination: self.controllerType.jobSeekerDestinationUrl) { (success, response, error, code) in
        }
    }
    
    func callPagination(){
        if let paging=self.jsonModelData?.meta?.paging{
            if let cursor=paging.cursors{
                if let newNext=cursor.next{
                    if let next=Int(newNext){
                        if next < paging.total!{
                            spinner.startAnimating()
                            self.tableView.tableFooterView?.isHidden = false
                            self.callSimilaryJobsApi(next: next)
                        }
                    }
                }
            }
        }
    }
    
    
}




extension MIViewAllJobsViewController:JobsAppliedOrSaveDelegate{
    func jobSaveUnsave(model: JoblistingData?, isSaved: Bool) {
        
        if let modelData=model{
            modelData.isSaved = isSaved
        }
        let filterData=jsonModelData?.data?.filter({$0.jobId == model?.jobId})
        if filterData?.count ?? 0 > 0{
            filterData![0].isSaved = isSaved
        }
        self.tableView.reloadData()
    }
    func jobApplied(model: JoblistingData?) {
        
        let filterData=jsonModelData?.data?.filter{$0.jobId == model?.jobId}
        if filterData?.count ?? 0 > 0{
            filterData![0].isApplied=true
        }
        self.tableView.reloadData()
    }
}
