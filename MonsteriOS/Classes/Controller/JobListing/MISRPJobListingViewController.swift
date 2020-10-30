//
//  MISRPJobListingViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 09/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import SwipeCellKit
import MapKit
import MaterialShowcase

var sessionId = "" {
    didSet {
        if sessionId.count == 0 {
            MIApiManager.getSesssionIDAPI()
        }
    }
}

enum SRPOpenFrom {
    case fromwebview
    case others
}

class MISRPJobListingViewController: MIBaseViewController {
    //Override Variable if job is applied successfully,Job Applied method is available in Base Class
    override var myApplySuccessStoredProperty: String{
        didSet{
            if myApplySuccessStoredProperty.count > 0{
               
                
                let filterData=self.listView.jsonData?.data?.filter{$0.jobId == Int(myApplySuccessStoredProperty)}
                if filterData?.count ?? 0 > 0{
                    filterData![0].isApplied=true
                }
                isAppliedFlag=true
                self.listView.tableView.reloadData()
            }
        }
    }
    
    //Outlets and Variable
    @IBOutlet weak var listView: MISRPTableVIew!
    @IBOutlet weak var filterView: MIFilterMainView!
    @IBOutlet weak var filterViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var createJobAlertView: CreateJobAlertSRP!
   
    var selectedSkills = ""
    var selectedLocation = ""
    var companyIds = [Int]()
    var recruiterIds = 0
    var sortValue = 1
    var jobTypes:JobTypes! = .all
    var currentLocation = ""
    var currentRadius = 200
    var param = [String:Any]()
    private var nojobPopup  = MINoJobFoundPopupView.popup()
    var walkInFilter=[String:[FilterStructModel]]()
    let showcase  = MaterialShowcase()
    var searchIdNew=""
    var isCreateAlertShown = false
    lazy var cancelSelectionButton=UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(MISRPJobListingViewController.cancelSelection(_:)))
    
    var openSRPVC: SRPOpenFrom = .others
    var skillsWeb = ""
  
    // Filter view Hide/unhide with respect to Job Near Me
    var hideUnHideFilterView=false{
        didSet{
            if hideUnHideFilterView{
                filterView.isHidden=false
                filterViewHeightConstraint.constant=50
                if jobTypes != .nearBy{
                    let countString=NSMutableAttributedString(string:String(self.listView.jsonData?.meta?.paging?.total ?? 0), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 16)])
                    let resultString=NSAttributedString(string:SRPListingStoryBoardConstant.results, attributes: [NSAttributedString.Key.foregroundColor:UIColor.init(hex: "637381"),NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 16)])
                    countString.append(resultString)
                    filterView.resultLabel.attributedText=countString
                }else{
                    filterView.resultLabel.text="\(currentRadius) kms within \(MIAppLocationManager.locationManagerSharedInstance.currentCity)"
                }
            }else{
                filterView.isHidden=true
                filterViewHeightConstraint.constant=0
            }
        }
    }
    
    lazy   var searchBars:MISearchBar = MISearchBar(frame:CGRect(x: 0, y: 0, width:Double(self.view.frame.size.width-60), height: 30))
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(MISRPJobListingViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = Color.colorDarkBlack
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
//        self.listView.jsonData = nil
//        self.listView.tableView.reloadData()
//        self.startActivityIndicator()
//        self.param.removeValue(forKey: SRPListingDictKey.next.rawValue)
//        self.callSearchApi(param: self.param)
        self.refreshJobListForFirstPage()
        refreshControl.endRefreshing()
    }
    func refreshJobListForFirstPage(){
        self.listView.jsonData = nil
        self.listView.tableView.reloadData()
        self.startActivityIndicator()
        self.param.removeValue(forKey: SRPListingDictKey.next.rawValue)
        self.callSearchApi(param: self.param)
    }
    //MARK:View Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.setupUI()
        self.param[SRPListingDictKey.sort.rawValue]=self.sortValue
        self.param[SRPListingDictKey.query.rawValue]=self.selectedSkills
       
        if self.selectedLocation.count>0 {
            self.param[SRPListingDictKey.locations.rawValue]=self.selectedLocation.components(separatedBy: ",")
        }
        
        switch self.jobTypes {
        case .contract?,.walkIn?:
            self.param[SRPListingDictKey.jobTypes.rawValue]=[self.jobTypes.value]
        case .fresher?:
            self.param[SRPListingDictKey.experienceRanges.rawValue]=[self.jobTypes.value]
        case .company?:
            self.param[SRPListingDictKey.company.rawValue]=companyIds
            self.param[SRPListingDictKey.query.rawValue]=""
        case .recruiter?:
            self.param[SRPListingDictKey.recruiter.rawValue]=[recruiterIds]
            self.param[SRPListingDictKey.query.rawValue]=""
        case .itJobs?,.bpo?,.manufacture?,.finance?,.sales?:
            self.param[SRPListingDictKey.functions.rawValue]=[self.jobTypes.value]
        case .nearBy?:
            self.param[SRPListingDictKey.latitude.rawValue] = MIAppLocationManager.locationManagerSharedInstance.currentLocation?.coordinate.latitude
            self.param[SRPListingDictKey.longitude.rawValue] = MIAppLocationManager.locationManagerSharedInstance.currentLocation?.coordinate.longitude
            self.param[SRPListingDictKey.radius.rawValue] = currentRadius
            
        case .jobAlert?:
            self.param[SRPListingDictKey.query.rawValue]=""
        
        case .workFromHome?:
            self.param[SRPListingDictKey.jobTypes.rawValue]=[self.jobTypes.value]
        case .covid19Layoffs?:
            self.param[SRPListingDictKey.jobTypes.rawValue]=[self.jobTypes.value]
        default:
            break
        }
        
        self.startActivityIndicator()
        self.listView.tableView.addSubview(refreshControl)
        
        if openSRPVC == .fromwebview {
            self.param["skills"] = [self.skillsWeb]
        }
        callSearchApi(param:self.param)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshJobListData), name: NSNotification.Name.refreshJobList, object: nil)


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.backBarButtonItem?.title = ""
        
        CommonClass.googleAnalyticsScreen(self) //GA for screen
        JobSeekerSingleton.sharedInstance.addScreenName(screenName: self.jobTypes.jobSeekerTrackingDestinationPageURL)
        
        MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.SEARCH, data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.LANDING], destination: self.screenName) { (success, response, error, code) in
        }

        searchBars.setImage(UIImage(), for: .clear, state: .normal)
        switch jobTypes {
        case .nearBy?:
            self.navigationItem.title=ControllerTitleConstant.jobsNearMe
        case .walkIn?:
            self.navigationItem.title=HomeJobCategoryType.walkin.rawValue
        case .contract?:
            self.navigationItem.title=HomeJobCategoryType.contractJobs.rawValue
        case .fresher?:
            self.navigationItem.title=HomeJobCategoryType.fresherJobs.rawValue
        case .itJobs?:self.navigationItem.title=HomeJobCategoryType.itJobs.rawValue
        case .bpo?:self.navigationItem.title=HomeJobCategoryType.bpoCustomer.rawValue
        case .manufacture?:self.navigationItem.title=HomeJobCategoryType.manufature.rawValue
        case .finance?:self.navigationItem.title=HomeJobCategoryType.finance.rawValue
        case .sales?:self.navigationItem.title=HomeJobCategoryType.sales.rawValue
        case .allJobs?:
            self.navigationItem.title=HomeJobCategoryType.allJobs.rawValue
        case .company?,.recruiter?,.jobAlert?:
            self.navigationItem.title = self.selectedSkills
        case .workFromHome:
            self.navigationItem.title = HomeJobCategoryType.workFromHome.rawValue
            self.navigationController?.navigationBar.topItem?.title = ""
        case .covid19Layoffs:
            self.navigationItem.title = HomeJobCategoryType.covid19Layoff.rawValue
            self.navigationController?.navigationBar.topItem?.title = ""
        default:
            self.navigationItem.title=""
        }
        
        self.createJobAlertView.onOfSwitch.isOn = false
        searchBars.text = self.selectedSkills
        if isSavedOrUnsaved{
            self.removedSavedUnsavedImage()
        }
        self.checkNavigateAPI()
        
        if openSRPVC == .fromwebview {
            self.navigationController?.navigationBar.backItem?.title = ""
            self.navigationItem.titleView = nil
            self.searchBars.isHidden = true
            self.navigationItem.title = self.skillsWeb.capitalized
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationItem.title = ""
    } 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    func setupUI(){
        listView.delegate=self
        if self.jobTypes == .all{
            self.navigationItem.titleView=searchBars
        }
        searchBars.miDelegate=self
        filterView.delegate=self
        hideUnHideFilterView=false
        self.filterView.jobTypes = self.jobTypes
        self.filterView.setFilterTitle = .filter
       
        //Create Job Alert Action
        self.createJobAlertView.createAlertAction={[weak self](isCreate) in
             guard let `self`=self else {return}
            self.callAPIForSeekerJobMapEventSearch(type: CONSTANT_JOB_SEEKER_TYPE.SET_ALERT, data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK], source: self.jobTypes.jobSeekerTrackingDestinationPageURL)

            self.seekerSRPEvent(CONSTANT_JOB_SEEKER_TYPE.SET_ALERT)
            if isCreate{
                self.startActivityIndicator()
                self.callJobAlertApi()
            }
        }
        
    }
    
    @objc func refreshJobListData(){
        self.refreshJobListForFirstPage()

    }
    
    func joblistAPICallForNonLoginApplyFlow(jobToApply:String,flowType:NavigateAction,painationStart:String,searchId:String){
        self.listView.jsonData = nil
        self.listView.tableView.reloadData()
        self.param[SRPListingDictKey.next.rawValue] = painationStart.isEmpty ? nil :  painationStart
        self.startActivityIndicator()
        self.callSearchApi(param: self.param, jobapplyNav: flowType, jobid: jobToApply, searchId: searchId)
    }
    func callJobAlertApi(){
        self.nojobPopup.removeMe()
        let _ = MIAPIClient.sharedClient.load(path: APIPath.getJobAlert, method: .get, params: [:]) { [weak self](dataResponse, error,code) in
             guard let `self`=self else {return}
            DispatchQueue.main.async {
                self.stopActivityIndicator()
            if error != nil {
               // DispatchQueue.main.async {
                    self.createJobAlertView.onOfSwitch.isOn=false
               // }
                return
            }else{
                if let jsonData=dataResponse as? [String:Any]{
                    let jsonData=ManageJobAlertBaseModelMaster(dictionary: jsonData as NSDictionary)
                  //  DispatchQueue.main.async {
                       // self.stopActivityIndicator()
                        if jsonData?.data?.count==5{
                            let vc=MIManageJobAlertVC()
                            vc.manageAlertVia = .ViaReplace
                            jsonData?.data?.sort(by: {Calendar.current.compare(Date(timeIntervalSince1970: Double($0.updatedAt ?? 0)), to: Date(timeIntervalSince1970: Double($1.updatedAt ?? 0)), toGranularity: .minute) == .orderedDescending})
                            vc.jsonData=jsonData
                            vc.createJobAlertModel=self.getCreateJobAlertModel()
                            vc.alertCreatedSuccess={(true) in
                                self.createAlertSuccess()
                            }
                            self.navigationController?.pushViewController(vc, animated: true)
                        }else{

                            CommonClass.googleEventTrcking("search_screen", action: "create_job_alert", label: "toggle_on") //GA
                            
                            let vc=MICreateJobAlertViewController()
                            vc.modelData=self.getCreateJobAlertModel()
                            vc.jobAlertType = .fromSRP
                            vc.alertCreatedSuccess={(true) in
                                self.createAlertSuccess()
                                CommonClass.googleEventTrcking("search_screen", action: "create_job_alert", label: "save") //GA
                            }
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    //}
                }
             }
          }
       }
    }
    
    func callAPIForSeekerJobMapEventSearch(type:String,data:[String:Any],source:String) {
        
        MIApiManager.hitSeekerJourneyMapEvents(type, data: data, source: source, destination: self.jobTypes.jobSeekerTrackingDestinationPageURL) { (success, response, error, code) in
            
        }
    }
    
    func seekerSRPEvent(_ action: String, jobID: String? = nil) {
        
        let location = self.selectedLocation.components(separatedBy: ",")
      
        let industries = self.param["industries"] as? [String] ?? []
        let functions = self.param["functions"] as? [String] ?? []
        let salaryRanges = self.param["salaryRanges"] as? [String] ?? []
        let experienceRanges = self.param["experienceRanges"] as? [String] ?? []

        let jobType = self.param["jobTypes"] as? [String] ?? []
        let employerTypes = self.param["employerTypes"] as? [String] ?? []
        let qualifications = self.param["qualifications"] as? [String] ?? []
        let companies = self.param["companies"] as? [String] ?? []
        let jobCities = self.param["jobCities"] as? [String] ?? []
        let roles = self.param["roles"] as? [String] ?? []
        
        let filter = self.param["filter"] as? Bool ?? false

        var pageNumber = 1
        if let id = jobID {
            let index = (self.listView.jsonData?.data?.firstIndex(where: { $0.jobId?.stringValue == id }) ?? 0)+1
            pageNumber = index / (self.listView.jsonData?.meta?.paging?.limit ?? 1)
            if index % (self.listView.jsonData?.meta?.paging?.limit ?? 1) > 0 {
                pageNumber += 1
            }
        } else {
            pageNumber = (self.listView.jsonData?.data?.count ?? 1) / (self.listView.jsonData?.meta?.paging?.limit ?? 1)
        }
        
        let query = [
            "keywords" : self.selectedSkills.components(separatedBy: ","),

            "locations" : location,
            "experienceRanges" : experienceRanges,
            "functions" : functions,
            "industries" : industries,
            "salaryRanges" : salaryRanges,

            "qualifications" : qualifications,
            "employerTypes" : employerTypes,
            "experience" : "",
            "companies" : companies,
            "jobCities"  : jobCities,
            "roles" : roles,
            "jobTypes" : jobType,

            "filter" : filter,
            "sort" : self.sortValue == 1 ? "Relevance" : "Freshness",
            "pageSize" : self.listView.jsonData?.meta?.paging?.limit as Any,
            "pageNo" : pageNumber
        ]
       
        var data = [
            "resultCount" : self.listView.jsonData?.meta?.paging?.total as Any,
        ]
        if let id = jobID {
            let limit = self.listView.jsonData?.meta?.paging?.limit ?? 1
            var rank = (self.listView.jsonData?.data?.firstIndex(where: { $0.jobId?.stringValue == id }) ?? 0)+1
//            rank = rank % (pageNumber*limit)
//            rank = (rank==0) ? limit : rank
            rank = rank - ((pageNumber-1)*limit)

            data["jobRank"] = rank//(self.listView.jsonData?.data?.firstIndex(where: { $0.jobId?.stringValue == id }) ?? 0)+1
            data["jobId"] = id
        }
        if action == "JOB_APPLY" || action == "LANDING" {
            data["apiRequestTime"] = self.requestStartTime
            data["apiResponseTime"] = Date().timeIntervalSince1970
        }

        //if action == "LANDING" {
            data["query"] = query
        //}
        
        let param = [
            "apiId" : self.listView.jsonData?.meta?.version ?? "V1", //  Api version that is being called for vulture and other to check, that is been called from backend to check the speed
            "pageType" : "SRP",
            "action" : action,
            "searchId" : self.searchIdNew,//self.listView.jsonData?.meta?.resultId as Any,
            "sessionId" : sessionId,
            "source" : "homepage", //”homepage”, [JD] //referer
            "data" : data
            ] as [String : Any]
        
        MIApiManager.seekerABTestingAPI(param) { (result, error) in
        
        }
    }
    
    func getCreateJobAlertModel()->JobAlertModel{
        let modelData=JobAlertModel()
        if self.selectedSkills.components(separatedBy: ",").count > 5 {
           modelData.keywords=self.selectedSkills.components(separatedBy: ",").prefix(5).joined(separator: ",")
        }else{
            modelData.keywords=self.selectedSkills
        }
        var catInfo=[MICategorySelectionInfo]()
        for item in self.selectedSkills.components(separatedBy: ","){
            let categ=MICategorySelectionInfo()
            categ.name=item
            catInfo.append(categ)
        }
        modelData.masterData[MasterDataTitle.keywords.rawValue]=catInfo
        for (key,item) in self.param{
            if key==SRPListingDictKey.locations.rawValue{
                if let locArra=item as? [String]{
                    catInfo.removeAll()
                    for loc in locArra{
                        let categ=MICategorySelectionInfo()
                        categ.name=loc
                        catInfo.append(categ)
                    }
                    modelData.masterData[MasterDataTitle.desiredLocation.rawValue]=catInfo
                    modelData.desiredLocation=locArra.joined(separator: ",")
                }
            }
            if key==SRPListingDictKey.functions.rawValue{
                if let locArra=item as? [String]{
                    catInfo.removeAll()
                    for loc in locArra{
                        let categ=MICategorySelectionInfo()
                        categ.name=loc
                        catInfo.append(categ)
                    }
                    modelData.masterData[MasterDataTitle.funcionalArea.rawValue]=catInfo
                    modelData.functionalArea=locArra.joined(separator: ",")
                }
            }
            if key==SRPListingDictKey.roles.rawValue{
                if let locArra=item as? [String]{
                    catInfo.removeAll()
                    for loc in locArra{
                        let categ=MICategorySelectionInfo()
                        categ.name=loc
                        catInfo.append(categ)
                    }
                    modelData.masterData[MasterDataTitle.role.rawValue]=catInfo
                    modelData.role=locArra.joined(separator: ",")
                }
            }
            if key==SRPListingDictKey.industries.rawValue{
                if let locArra=item as? [String]{
                    catInfo.removeAll()
                    for loc in locArra{
                        let categ=MICategorySelectionInfo()
                        categ.name=loc
                        catInfo.append(categ)
                    }
                    modelData.masterData[MasterDataTitle.industry.rawValue]=catInfo
                    modelData.industry=locArra.joined(separator: ",")
                }
            }
        }
        modelData.frequency="Weekly"
        modelData.frequencyId="500730bf-fc6f-11e8-92d8-000c290b6677"
        
        return modelData
    }
    func createAlertSuccess(){
        self.createJobAlertView.isHidden=true
        self.isCreateAlertShown = true
        DispatchQueue.main.async {
            self.showAlert(title: "", message: "Job alert created successfully.",isErrorOccured:false)
        }
    }
    //MARK:It is Used when Multiple Apply Enable for cancelletion of Selection
    @objc func cancelSelection(_ sender:UIBarButtonItem){
        self.listView.isSelectionEnable=false
        if let modelData = self.listView.jsonData?.data{
            for item in modelData{
                item.isSelected=false
            }
        }
        self.filterView.setFilterTitle = .filter
        self.navigationItem.rightBarButtonItem=nil
    }
    //MARK:Job Search API Call
//    var apiRequestTime: Double?
//    var apiResponseTime: Double?
    
    func callSearchApi(param:[String:Any],jobapplyNav:NavigateAction? = NavigateAction.none,jobid:String? = "",searchId:String? = ""){
        
        self.nojobPopup.removeMe()
        self.createJobAlertView.isHidden=true
        self.requestStartTime = Date().timeIntervalSince1970
        
        
        MIAPIClient.sharedClient.load(path:APIPath.searchJob,method: .post, params:param) { [weak self] (dataResponse, error,code) in

            guard let `self` = self else {return}
            //self.apiResponseTime = Date().timeIntervalSince1970
             DispatchQueue.main.async {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
                    self.stopActivityIndicator()
                })
            self.param.removeValue(forKey: SRPListingDictKey.next.rawValue)
            self.listView.isPaginationRunning = false
            
            if error != nil{
              //  DispatchQueue.main.async {
                    
                    self.listView.tableView.tableFooterView?.isHidden=true
                    
                    if error?.errorDescription == ServiceError.noInternetConnection.errorDescription{
                        self.nojobPopup.show(ttl: ErrorAndValidationMsg.opps.rawValue, desc:ErrorAndValidationMsg.somethingWrong.rawValue,imgNm: "plugbase")
                        self.nojobPopup.addFromTop(onView: self.view, topHeight: 180, onCompletion: nil)
                    }else if code==401{
                      //  self.logoutToLogin()
                    }
                    else{
                    self.showAlert(title: "", message: error?.errorDescription)
                    }
               // }
                return
            }else{
                if let jsonData=dataResponse as? [String:Any]{
                    if self.listView.jsonData==nil {
                        self.listView.jsonData=JoblistingBaseModel(dictionary: jsonData as NSDictionary)
                       // if wkSelf.searchIdNew == ""{
                            if let metaData=self.listView.jsonData?.meta{
                                self.searchIdNew = metaData.resultId ?? ""
                            }
                      //  }
                        if let spns1=self.listView.jsonData?.sponsoredJobs?.first{
                            self.listView.jsonData?.data?.insert(spns1, at: 0)
                        }
                        if self.listView.jsonData?.sponsoredJobs?.count ?? 0 > 1 {
                            if let dataCount=self.listView.jsonData?.data?.count{
                                self.listView.jsonData?.data?.insert((self.listView.jsonData?.sponsoredJobs![1])!, at: dataCount > 6 ? 5 : dataCount-1)
                            }
                            
                        }
                      let _ = self.listView.jsonData?.data?.map({$0.resultId=self.searchIdNew})
                        
                    }else {
                        let paginData=JoblistingBaseModel(dictionary: jsonData as NSDictionary)
                        if let dataArray=paginData?.data{
                            for item in dataArray{
                                self.listView.jsonData?.data?.append(item)
                            }
                        }
                        self.listView.jsonData?.meta=paginData?.meta
                        self.listView.jsonData?.selectedFilters=paginData?.selectedFilters
                        self.listView.jsonData?.filters=paginData?.filters
                        let _ = self.listView.jsonData?.data?.map({$0.resultId=self.searchIdNew})
                    }
                    
                    if jobapplyNav == .apply {
                        //When user try to apply without login and get back here after login with check with work
                        if jobid?.isNumeric ?? false {
                            let job = self.listView.jsonData?.data?.filter({$0.jobId == Int(jobid ?? "0") })
                            if job?.count ?? 0 > 0 {
                                if let firstobj = job?.first,!(firstobj.isApplied ?? true) {
                                    if let jdId = jobid , !jdId.isEmpty{
                                        self.applyAction(jobId: jdId, redirectURl: firstobj.redirectUrl, searchId: firstobj.resultId,isAfterLoginAutoApply: false, jobApplyTracking: firstobj)
                                    }
                                }else if job?.first?.isApplied ?? false {
                                    self.showAlert(title: "", message: GenericErrorMessage.jobAlreadyApplied, isErrorOccured: false)
                                }
                            }
                        }
                      //  let jobfilter = self.listView.jsonData?.data?.filter({$.jobId})
                        
                    }
                   // DispatchQueue.main.async {
                        self.listView.tableView.tableFooterView?.isHidden=true
                        self.listView.tableView.reloadData()
                        self.hideUnHideFilterView=true

                        
                        if self.listView.jsonData?.data?.count == 0 || self.listView.jsonData?.data == nil {
                            self.hideUnHideFilterView=false

                            self.nojobPopup.show(ttl:"No Result", desc:"Sorry, there are no results for this search, Please try another phrase")
                            self.nojobPopup.addFromTop(onView: self.view, topHeight: 180, onCompletion: nil)
                        } else {
                            self.view.bringSubviewToFront(self.showcase)
                            
                            if self.jobTypes == .all && !self.isCreateAlertShown {
                                self.createJobAlertView.isHidden=false
                            }
                            self.nojobPopup.removeMe()
                            let shouldhideTutorial = userDefaults.bool(forKey: "srpFirstTimeTutorial")
                            if !shouldhideTutorial{
                                self.showTutorials()
                           }
                        }
                    //}
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
                self.seekerSRPEvent("LANDING")
            })
        }
        }
    }
    
    //MARK:Show Tutorial
    func showTutorials() {
        if let cell = self.listView.tableView.cellForRow(at: IndexPath(row: 0,section: 0)) as? SwipeTableViewCell{
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
    
    //MARK:Long Press Selection for Multiple Apply
    func longPressSelection(indexPath:IndexPath){
        self.navigationItem.rightBarButtonItem=self.cancelSelectionButton
        let filterData=self.listView.jsonData?.data?.filter({$0.isSelected})
        if filterData?.count == 0{
            self.filterView.setFilterTitle = .filter
            self.navigationItem.rightBarButtonItem=nil
        }else if filterData?.count == 1{
            self.filterView.setFilterTitle = .apply
        }else{
            self.filterView.setFilterTitle = .applyAll
        }
    }
    //MARK:Refreshing save jobs View if User is unsaved it
    func removedSavedUnsavedImage(){
       
        if self.listView.jsonData?.data?.count ?? 0 > 0{
            
            if self.tabBarController?.viewControllers?.count ?? 0 > 1{
                if let trackJobVcNav=self.tabBarController?.viewControllers?[1] as? MINavigationViewController{
                    if let trackJobVc=trackJobVcNav.viewControllers[0] as? MITrackJobsHomeViewController{
                        if trackJobVc.viewControllers.count > 1 {
                            if let savedTrackVc=trackJobVc.viewControllers[1] as? MISavedJobViewController{
                                let savedJobsInSRP=self.listView.jsonData?.data?.filter({$0.isSaved==true})
                                for item in savedJobsInSRP ?? []{
                                    if  let savedValue=savedTrackVc.savedJobData?.data?.contains(where: {$0.jobId == item.jobId}){
                                        if !savedValue{
                                            item.isSaved=false
                                        }
                                    }
                                }
                                self.listView.tableView.reloadData()
                                
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
}

//MARK:Extension for filter button action eg, edit map, sort, filter
extension MISRPJobListingViewController:FilterButtonActionDelegate{
    func sortAction(sortValue:Int) {
        self.sortValue = sortValue
        self.param[SRPListingDictKey.sort.rawValue] = self.sortValue
        self.param[SRPListingDictKey.next.rawValue] = 0
        self.startActivityIndicator()
        self.listView.jsonData?.data?.removeAll()
        self.listView.tableView.reloadData()
     
        if sortValue == 1{
            CommonClass.googleEventTrcking("search_screen", action: "sort", label: "relevance") //GA
        } else if sortValue == 2 {
            CommonClass.googleEventTrcking("search_screen", action: "sort", label: "freshness") //GA
        }
        
        self.callSearchApi(param: self.param)
        self.param.removeValue(forKey:SRPListingDictKey.next.rawValue )
    }
    
    func filterAction(filterType:FilterType) {
        switch self.filterView.setFilterTitle {
        case .filter:
            let filterVc=MIFilterJobsViewController()
            filterVc.filterJsonData=self.listView.jsonData?.filters
            filterVc.selectedFilterData = self.listView.jsonData?.selectedFilters
            filterVc.filterLabel=self.listView.jsonData?.filterLabels ?? [:]
            filterVc.jobType = self.jobTypes
            filterVc.queryItem=self.selectedSkills
            var previousSelectedFilter = [FilterModel]()
            if let selFilter = self.listView.jsonData?.selectedFilters?.filterValue {
                for (_,item) in selFilter{
                    previousSelectedFilter = item.filter({$0.isSelected})
                    if previousSelectedFilter.count > 0 {
                        break
                    }
                }
            }
           
            if filterType != .none  && previousSelectedFilter.count == 0 {
                if filterType == .experienceRange {
                    CommonClass.googleEventTrcking("search_screen", action: "open_filter_city", label: "open_filter_more_options")

                    filterVc.selectedFilterValue =  Seeker_Job_Event_Filter.experienceRanges.rawValue
                }else if filterType == .jobTypes {
                    CommonClass.googleEventTrcking("search_screen", action: "open_filter_city", label: "open_filter_more_options")

                    filterVc.selectedFilterValue =  Seeker_Job_Event_Filter.jobTypes.rawValue

                }else if filterType == .locations {
                    CommonClass.googleEventTrcking("search_screen", action: "open_filter_city", label: "open_filter_more_options")

                    filterVc.selectedFilterValue =  Seeker_Job_Event_Filter.jobCities.rawValue
                }
            }
            filterVc.delegate=self
            if self.walkInFilter["walkInDateRanges"] != nil{
                var filterArra=[FilterModel]()
                for item in walkInFilter["walkInDateRanges"] ?? []{
                    filterArra.append(FilterModel(title: item.title, isSelected: item.isSelected, isUserSelectEnable: true))
                }
                
           filterVc.walkInFilter["walkInDateRanges"]=filterArra
            }
            let nav = MINavigationViewController(rootViewController: filterVc)
            nav.modalPresentationStyle = .fullScreen

        self.present(nav, animated: true, completion: nil)
        case .apply:
            print("Apply Method Call")
        case .applyAll:
            print("Apply All Method Call")
        }
        
       
    }
    
    func editMapAction() {
        let mapView = MINearByJobMapView.mapHeaderView
        mapView.distanceSlider.value = Float(currentRadius)
        mapView.showHideMapViewOnController(parentView: self.view, show: true)
        if MIAppLocationManager.locationManagerSharedInstance.currentLocation != nil {
            mapView.showCircleWithRadius(radius:Double(mapView.distanceSlider.value/100.0), coordinate: (MIAppLocationManager.locationManagerSharedInstance.currentLocation?.coordinate)!, circleColor: UIColor(hex: "FF9900"), location: "innerCircle")
            mapView.showCircleWithRadius(radius:Double(mapView.distanceSlider.value), coordinate:(MIAppLocationManager.locationManagerSharedInstance.currentLocation?.coordinate)!, circleColor: UIColor(hex: "FFCC66"), location: "outerCircle")
        }
        mapView.delegate = self
    }
}

//MARK:Jobs Near me map filter Apply
extension MISRPJobListingViewController: NearByMapRadiusDelegate {
    func distanceRangeSelected(range: Float) {
        self.currentRadius = Int(range)
        self.param[SRPListingDictKey.radius.rawValue]=range
        self.listView.tableView.tableFooterView?.isHidden=true
        self.hideUnHideFilterView=false
        self.listView.jsonData=nil
        self.listView.tableView.reloadData()
        self.startActivityIndicator()
        self.callSearchApi(param: param)
    }
}
//MARK:Filter View Delegate, reloading when filter apply
extension MISRPJobListingViewController:FilterAppyDelegate{
    func applyFilter(filters: [String : Any],walkInfilter:[String:[FilterModel]]) {
        if filters.count > 0 {
            self.filterView.filterButton.isSelected = true
        }else{
            self.filterView.filterButton.isSelected = false

        }
        self.walkInFilter.removeAll()
        var newFilterArray=[FilterStructModel]()
        for item in walkInfilter["walkInDateRanges"] ?? []{
          newFilterArray.append(FilterStructModel(model:item))
        }
        self.walkInFilter["walkInDateRanges"]=newFilterArray
        
        var newFilter=filters
        newFilter[SRPListingDictKey.query.rawValue]=self.param[SRPListingDictKey.query.rawValue]
        newFilter[SRPListingDictKey.sort.rawValue]=self.sortValue
        newFilter[SRPListingDictKey.locations.rawValue]=self.param[SRPListingDictKey.locations.rawValue]
        switch self.jobTypes {
        case .contract?,.walkIn?:
            newFilter[SRPListingDictKey.jobTypes.rawValue]=[self.jobTypes.value]
        case .fresher?:
            newFilter[SRPListingDictKey.experienceRanges.rawValue]=[self.jobTypes.value]
        case .company?:
            newFilter[SRPListingDictKey.company.rawValue]=companyIds
        case .recruiter?:
            newFilter[SRPListingDictKey.recruiter.rawValue]=[recruiterIds]
        case .itJobs?,.bpo?,.manufacture?,.finance?,.sales?:
            newFilter[SRPListingDictKey.functions.rawValue]=[self.jobTypes.value]
        case .nearBy?:
            newFilter[SRPListingDictKey.latitude.rawValue]=MIAppLocationManager.locationManagerSharedInstance.currentLocation?.coordinate.latitude
            newFilter[SRPListingDictKey.longitude.rawValue]=MIAppLocationManager.locationManagerSharedInstance.currentLocation?.coordinate.longitude
            newFilter[SRPListingDictKey.radius.rawValue]=currentRadius
            
        
        default:
            break
        }
        newFilter["filter"]=true
        self.param=newFilter
        self.startActivityIndicator()
        self.listView.tableView.tableFooterView?.isHidden=true
        self.hideUnHideFilterView=false
        self.listView.jsonData=nil
        self.listView.tableView.reloadData()
        
        self.callSearchApi(param: newFilter)
    }
}
//MARK:Search bar Delegate Method
extension MISRPJobListingViewController:MISearchBarDelegate{
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        var newNavigationController = [UIViewController]()
        var prevView:UIViewController?
        
        if let vcs=self.navigationController?.viewControllers{
            for vc in vcs{
                if vc is MIAdvanceSearchViewController{
                    continue
                }
                if let prevVc=vc as? MISearchViewController{
                   self.setSearchViewController(vc: prevVc)
                    prevView=prevVc
                    continue
                }
            newNavigationController.append(vc)
            }
        }
        if (prevView != nil){
            newNavigationController.append(prevView!)
        }else{
            let prevV=MISearchViewController()
            if self.selectedSkills.count > 0 {
                prevV.selectedInfoArray=self.selectedSkills.components(separatedBy: ",")
            }
            if self.selectedLocation.count > 0{
                prevV.locationList=self.selectedLocation.components(separatedBy:",")
            }
            newNavigationController.append(prevV)
        }
        self.navigationController?.viewControllers=newNavigationController
       // self.setSearchViewController(vc:prevView! as! MISearchViewController)
        return false
    }
    
    func setSearchViewController(vc:MISearchViewController){
        if self.selectedSkills.count > 0 {
            vc.selectedInfoArray=self.selectedSkills.components(separatedBy: ",")
        }
        // prevVc.locationList=self.selectedLocation.components(separatedBy: ",")
        if self.selectedLocation.count > 0{
            vc.locationSelected(locArray: self.selectedLocation.components(separatedBy: ","))
        }else{
            vc.locationSelected(locArray: [])
        }
        //TODO:- Need to check the isAppending property 
        vc.showSelection(list: vc.selectedInfoArray,isAppending:false)
    }
}

//MARK:Handling Table Reloading,pagination,selection,apply,multiple selection
extension MISRPJobListingViewController : SRPTableViewDelegate {
   
    
       func tableViewDidSelection(indexPath: IndexPath) {
        self.longPressSelection(indexPath: indexPath)
        self.seekerSRPEvent("JOB_VIEW", jobID: self.listView.jsonData?.data?[indexPath.section].jobId?.stringValue)
        
        let sjsCount = self.listView.jsonData!.data![indexPath.section].jobTypes?.filter({$0.lowercased().contains("sjs")}).count ?? 0

        if sjsCount > 0 || self.listView.jsonData!.data![indexPath.section].isCJT == 1 {
            self.callIsViewedApi(jobId: self.listView.jsonData!.data![indexPath.section].jobId ?? 0)
            let vc=Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
            vc.url = self.getSJSURL(model: self.listView.jsonData!.data![indexPath.section])
            vc.ttl = "Detail"
            let nav = MINavigationViewController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen

            self.present(nav, animated: true, completion: nil)
        }else{
            let vc = MIJobDetailsViewController()
            vc.locationList = self.selectedLocation
            vc.delegate = self
            vc.searchIdNew = self.searchIdNew //self.listView.jsonData!.data![indexPath.section].resultId
            vc.searchIdForAB = self.searchIdNew
            vc.abTestingVersion = self.listView.jsonData?.meta?.version ?? "V1"
            vc.referralUrl = .SRP_JOBS
            vc.jobId = String(self.listView.jsonData!.data![indexPath.section].jobId ?? 0)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func callScrollEndAPI(param:[String:Any]){
        var newParam=param
        for (key,value) in self.param{
            newParam[key] = value
        }

        if let page = param["start"] as? String , page.isNumeric {
            if let value = Int(page) {
                let pageValue = value/10
                self.callAPIForSeekerJobMapEventSearch(type: CONSTANT_JOB_SEEKER_TYPE.NEXT_SCROLL, data: ["pageNumber":pageValue], source:"")
            }
        }
       self.callSearchApi(param: newParam)
        
    }
    
    func longPressSelected(indexPath:IndexPath){
        self.longPressSelection(indexPath: indexPath)
    }
    func applyAction(jobId: String, redirectURl: String?, searchId: String, isAfterLoginAutoApply: Bool?, jobApplyTracking: JoblistingData?) {
        self.callAPIForSeekerJobMapEventSearch(type: CONSTANT_JOB_SEEKER_TYPE.APPLY, data: ["jobId":jobId,"eventValue":"click"], source:"")
        navigateStartValue = nil
        self.eventTrackingValue = .SRP_JOBS
        if !CommonClass.isLoggedin() && (isAfterLoginAutoApply ?? false){
            if let section = self.listView.jsonData?.data?.firstIndex(where: {$0.jobId == Int(jobId )}) {
                navigateStartValue = "\((section / 10) * 10)"
            }

        }
        CommonClass.googleEventTrcking("search_screen", action: "apply", label: "")
        self.applyActionGlobal(jobId:jobId, redirectURl: redirectURl,searchId:searchId, jobApplyModel: jobApplyTracking) {
            self.seekerSRPEvent("JOB_APPLY", jobID: jobId)
        }
    }
    
    func jobsRightForYou() {
        self.callAPIForSeekerJobMapEventSearch(type: CONSTANT_JOB_SEEKER_TYPE.ARE_JOBS_RIGHT, data: ["eventValue":"click"], source:"")

    }
    func saveJob(jobId: String) {
        self.callAPIForSeekerJobMapEventSearch(type: CONSTANT_JOB_SEEKER_TYPE.SAVED_JOBS, data: ["jobId":jobId,"eventValue":"click"], source:"")
    }
    
}

//MARK:Job details Delegate Method
extension MISRPJobListingViewController:JobsAppliedOrSaveDelegate{
    func jobSaveUnsave(model: JoblistingData?, isSaved: Bool) {
        
        if let modelData=model{
            modelData.isSaved = isSaved
        }
        let filterData=self.listView.jsonData?.data?.filter({$0.jobId == model?.jobId})
        if filterData?.count ?? 0 > 0{
            filterData![0].isSaved = isSaved
        }
        
        self.listView.tableView.reloadData()
    }
    func jobApplied(model: JoblistingData?) {
        
        let filterData=self.listView.jsonData?.data?.filter{$0.jobId == model?.jobId}
        if filterData?.count ?? 0 > 0{
            filterData![0].isApplied=true
        }
        self.listView.tableView.reloadData()
    }
}



