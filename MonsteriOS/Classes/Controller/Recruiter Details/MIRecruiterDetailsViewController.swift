//
//  MIRecruiterDetailsViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 05/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SwipeCellKit

protocol CompanyDetailsDelegate {
    func jobSavedUnsaved(jobId:Int,isSave:Bool)
    func jobApplied(jobId:Int)
    func companyFollowUnFollow(compId:Int,isFollow:Bool)
}

extension CompanyDetailsDelegate{
    func jobSavedUnsaved(jobId:Int,isSave:Bool){}
    func jobApplied(jobId:Int){}
    func companyFollowUnFollow(compId:Int,isFollow:Bool){}
}

class MIRecruiterDetailsViewController: MIBaseViewController {
    var followStatus = true
    
    let tableView=UITableView()
    var jsonData=[AppliedJobModel]()
    var recuterOrCompanyType:RecuiterOrCompany = .company
    var isCompanyReadMore=true
    var sectionTitle=[String]()
    var compOrRecId = ""
    var isCompanyMore = true
    var isCompOrRecFollow = false
    var delegate:CompanyDetailsDelegate?
    var jobModel:JoblistingData?
    
    override var myApplySuccessStoredProperty: String{
        didSet{
            if myApplySuccessStoredProperty.count > 0{
                let filterData=self.companyJobJson?.data?.filter{$0.jobId == Int(myApplySuccessStoredProperty)}
                if filterData?.count ?? 0 > 0{
                    filterData![0].isApplied=true
                }
                isAppliedFlag=true
                self.tableView.reloadData()
                delegate?.jobApplied(jobId:Int(myApplySuccessStoredProperty)!)
            }
        }
    }
    var companyJobJson:JoblistingBaseModel?{
        didSet{
            if companyJobJson?.data?.count ?? 0 > 0{
                self.sectionTitle.append(setionCompanyTitleEnum.activeJob.rawValue)
            }
        }
    }
    var companyJson:Company?{
        didSet{
            sectionTitle.append("")
            if companyJson?.about?.count ?? 0 > 0{
                self.sectionTitle.append(setionCompanyTitleEnum.aboutComp.rawValue)
            }
        }
    }
    let spinner = UIActivityIndicatorView(style: .gray)
    var isPaginationRunning = false
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(MISRPJobListingViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = Color.colorDarkBlack
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        if let index = self.sectionTitle.firstIndex(of: setionCompanyTitleEnum.activeJob.rawValue) {
            self.sectionTitle.remove(at: index)
        }
        self.companyJobJson = nil
        self.tableView.reloadData()
        self.startActivityIndicator()
        self.getJobApi(param: [self.recuterOrCompanyType.jobFilterType:[self.compOrRecId]])
        refreshControl.endRefreshing()
        
    }
    
    // private var nojobPopup  = MINoJobFoundPopupView.popup()
    enum setionCompanyTitleEnum:String{
        case aboutComp="About Company"
        case activeJob="Active Open Jobs"
        case specilaztion="Specialization"
        case jobs="Jobs"
    }
    override func loadView() {
        super.loadView()
        self.view.addSubview(tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints=false
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: self.view.topAnchor),tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName:String(describing: MIRecuiterAndCompanyTopTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIRecuiterAndCompanyTopTableViewCell.self))
        tableView.register(UINib(nibName:String(describing: MIJobDetailsTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIJobDetailsTableViewCell.self))
        tableView.register(UINib(nibName:String(describing: MIJobDescriptionTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIJobDescriptionTableViewCell.self))
        tableView.register(UINib(nibName:String(describing: MIJobListingTableCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIJobListingTableCell.self))
        tableView.register(UINib(nibName:String(describing: MIAppliedSavedNetworkTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIAppliedSavedNetworkTableViewCell.self))
        tableView.register(UINib(nibName:String(describing: MIActiveExpiredSelectionTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIActiveExpiredSelectionTableViewCell.self))
        
        tableView.delegate=self
        tableView.dataSource=self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView=UIView(frame: .zero)
        tableView.bounces=true
        tableView.separatorStyle = .none
        sectionTitle.append("")
        
        if self.recuterOrCompanyType == .company{
            if self.jobModel?.company?.about?.count ?? 0 > 0{
                self.sectionTitle.append(setionCompanyTitleEnum.aboutComp.rawValue)
            }
        }else{
            if self.jobModel?.recruiter?.functions?.count ?? 0 > 0 || self.jobModel?.recruiter?.industries?.count ?? 0 > 0 || self.jobModel?.recruiter?.levelHiringFor?.count ?? 0 > 0{
                self.sectionTitle.append(setionCompanyTitleEnum.specilaztion.rawValue)
            }
        }
        self.tableView.addSubview(self.refreshControl)
        self.startActivityIndicator()
        self.getJobApi(param: [self.recuterOrCompanyType.jobFilterType:[self.compOrRecId]])
        self.tableView.reloadData()
        spinner.tintColor = AppTheme.defaltTheme
        spinner.hidesWhenStopped=true
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        self.tableView.tableFooterView = spinner
        self.tableView.tableFooterView?.isHidden=true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title=self.recuterOrCompanyType.name

        if self.recuterOrCompanyType == .company {
            JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.COMPANY_DETAIL)
        }else{
            JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.RECRUITER_DETAIL)
        }
        self.checkNavigateAPI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }
    
    func refereshDataAfterLoginFlowForApply(jobId:String,navigationFor:NavigateAction,start:String){
        
        if let index = self.sectionTitle.firstIndex(of: setionCompanyTitleEnum.activeJob.rawValue) {
            self.sectionTitle.remove(at: index)
        }
        self.companyJobJson = nil
        self.tableView.reloadData()
        self.startActivityIndicator()
        var param : [String:Any] = [self.recuterOrCompanyType.jobFilterType:[self.compOrRecId]]
        if !start.isEmpty {
            param[SRPListingDictKey.next.rawValue] = start
        }
        self.getJobApi(param: param,jobId: jobId,navFlowFor: navigationFor)
        
    }
    
    func getJobApi(param:[String:Any],jobId:String? = "",navFlowFor:NavigateAction? = NavigateAction.none){
        let _ = MIAPIClient.sharedClient.load(path: APIPath.searchJob, method: .post, params: param){[weak self] (responseDat, error,code) in
            DispatchQueue.main.async {
                self?.stopActivityIndicator()
                self?.isPaginationRunning = false
                if error != nil{
                    //  DispatchQueue.main.async {
                    // self?.stopActivityIndicator()
                    self?.tableView.tableFooterView?.isHidden=true
                    //}
                    return
                }else{
                    if let jsonData=responseDat as? [String:Any]{
                        let jobData=JoblistingBaseModel(dictionary: jsonData as NSDictionary)
                        let filterData=jobData?.data?.filter({$0.activeJob == true})
                        jobData?.data=filterData
                        if self?.companyJobJson == nil{
                            self?.companyJobJson=jobData
                        }else{
                            for item in filterData ?? []{
                                self?.companyJobJson?.data?.append(item)
                            }
                            self?.companyJobJson?.meta=jobData?.meta
                        }
                        if navFlowFor == .apply {
                            //When user try to apply without login and get back here after login with check with work
                            if jobId?.isNumeric ?? false {
                                let job = self?.companyJobJson?.data?.filter({$0.jobId == Int(jobId ?? "0") })
                                if job?.count ?? 0 > 0 {
                                    if let firstobj = job?.first,!(firstobj.isApplied ?? true) {
                                        if let jdId = jobId , !jdId.isEmpty{
                                            self?.applyActionGlobal(jobId: jdId, redirectURl: firstobj.redirectUrl, jobApplyModel: self?.jobModel)
                                        
                                            //self.applyAction(jobId: jdId, redirectURl: firstobj.redirectUrl, searchId: firstobj.resultId,isAfterLoginAutoApply: false)
                                        }
                                    }else if job?.first?.isApplied ?? false {
                                        self?.showAlert(title: "", message: GenericErrorMessage.jobAlreadyApplied, isErrorOccured: false)
                                        
                                    }
                                }
                            }
                          //  let jobfilter = self.listView.jsonData?.data?.filter({$.jobId})
                            
                        }
                        
                        
                        //  DispatchQueue.main.async {
                        self?.tableView.reloadData()
                        self?.tableView.tableFooterView?.isHidden=true
                        // self?.stopActivityIndicator()
                        //  }
                    }
                }
            }
        }
    }
    
}

extension MIRecruiterDetailsViewController:UITableViewDelegate,UITableViewDataSource,SwipeTableViewCellDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.sectionTitle[section] == setionCompanyTitleEnum.activeJob.rawValue{
            return self.companyJobJson?.data?.count ?? 0
        }
        if self.sectionTitle[section] == setionCompanyTitleEnum.aboutComp.rawValue{
            return  1
        }
        if self.sectionTitle[section] == setionCompanyTitleEnum.specilaztion.rawValue{
            return  1
        }
        if self.sectionTitle[section] == ""{
            return  1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            guard let cell=tableView.dequeueReusableCell(withIdentifier: String(describing: MIRecuiterAndCompanyTopTableViewCell.self), for: indexPath)as?MIRecuiterAndCompanyTopTableViewCell else {
                return UITableViewCell()
            }
            cell.recuiterOrCompany = recuterOrCompanyType
            
            if recuterOrCompanyType == .company{
                
                cell.companyDetails=CompanyDetailsModel(comapanyTitle: self.jobModel?.company?.name ?? "", comanyFunctional:jobModel?.company?.industries?.joined(separator: ", ") ?? "", comapanyImageURL: self.jobModel?.company?.logo, isFollow:self.jobModel?.isCompanyFollow ?? false, location:jobModel?.company?.location?.city ?? jobModel?.company?.location?.country ?? "")
            } else{
                cell.companyDetails=CompanyDetailsModel(comapanyTitle: self.jobModel?.recruiter?.name ?? self.jobModel?.recruiterName ?? "", comanyFunctional:String(jobModel?.recruiter?.followersCount ?? 0), comapanyImageURL: self.jobModel?.recruiter?.avatarUrl ?? "", isFollow:self.jobModel?.isRecruiterFollow ?? false, location:self.jobModel?.hideCompanyName == 0  ?  jobModel?.recruiter?.companyName ?? self.jobModel?.company?.name ?? "" :  companyConfidential,recImageString:"",isFollowShow:self.jobModel?.recruiter?.profileStatus ?? true)
            }
            
            
            cell.followAndUnfollowAction={[weak self](follow) in
                guard let wkSelf=self else {return}
                let recId = wkSelf.jobModel?.recruiter?.recruiterUuid ?? "0"
                
//                if follow{
//                    wkSelf.followAndUnfollowCmpanyOrRecuiter(path: wkSelf.recuterOrCompanyType == .company ?APIPath.unfollowCompany + wkSelf.compOrRecId : APIPath.unfollowRecruiter + recId, method: .delete, type: wkSelf.recuterOrCompanyType == .company ? .company : .recruiter)
//
//                }else{
//                    wkSelf.followAndUnfollowCmpanyOrRecuiter(path: wkSelf.recuterOrCompanyType == .company ?APIPath.followCompany + wkSelf.compOrRecId : APIPath.followRecruiter + recId , method: .post, type: wkSelf.recuterOrCompanyType == .company ? .company : .recruiter)
//
//                }
                
                if self!.followStatus {
                    if follow{
                        wkSelf.followAndUnfollowCmpanyOrRecuiter(path: wkSelf.recuterOrCompanyType == .company ?APIPath.unfollowCompany + wkSelf.compOrRecId : APIPath.unfollowRecruiter + recId, method: .delete, type: wkSelf.recuterOrCompanyType == .company ? .company : .recruiter)
                        
                    }else{
                        wkSelf.followAndUnfollowCmpanyOrRecuiter(path: wkSelf.recuterOrCompanyType == .company ?APIPath.followCompany + wkSelf.compOrRecId : APIPath.followRecruiter + recId , method: .post, type: wkSelf.recuterOrCompanyType == .company ? .company : .recruiter)
                       
                    }
                }
                
                

                
            }
            
            return cell
        }
        
        if self.sectionTitle[indexPath.section] == setionCompanyTitleEnum.specilaztion.rawValue{
            
            guard let cell=tableView.dequeueReusableCell(withIdentifier: String(describing: MIJobDetailsTableViewCell.self), for: indexPath)as?MIJobDetailsTableViewCell else {
                return UITableViewCell()
            }
            cell.jobDetails=JobDetailsModel(industryTitle:self.jobModel?.recruiter?.industries?.joined(separator: ",") ?? "", roleTitle: "", functionalTitle: self.jobModel?.recruiter?.functions?.joined(separator: ",") ?? "",expLevel:self.jobModel?.recruiter?.levelHiringFor?.joined(separator: ",") ?? "")
            return cell
        }
        
        // switch self.recuterOrCompanyType {
        // case .recuiter:
        //            if indexPath.section == 1{
        //                guard let cell=tableView.dequeueReusableCell(withIdentifier: String(describing: MIJobDetailsTableViewCell.self), for: indexPath)as?MIJobDetailsTableViewCell else {
        //                    return UITableViewCell()
        //                }
        //                cell.jobDetails=JobDetailsModel(industryTitle: "Information Technology and Services,…", roleTitle: "User Experience Designer", functionalTitle: "IT",expLevel:"Mid-Fresher")
        //                return cell
        //            }
        //            if indexPath.section == 2 && indexPath.row==0{
        //                    guard let cell=tableView.dequeueReusableCell(withIdentifier: String(describing: MIActiveExpiredSelectionTableViewCell.self), for: indexPath)as?MIActiveExpiredSelectionTableViewCell else {
        //                        return UITableViewCell()
        //                    }
        //                    cell.jobButtonAction={(tag) in
        //                        self.tableView.reloadRows(at: self.reloadRowsWithActive(), with: .automatic)
        //                    }
        //                    return cell
        //                 }
        //        case .company:
        
        if self.sectionTitle[indexPath.section] == setionCompanyTitleEnum.aboutComp.rawValue {
            guard let cell=tableView.dequeueReusableCell(withIdentifier: String(describing: MIJobDescriptionTableViewCell.self), for: indexPath)as?MIJobDescriptionTableViewCell else {
                return UITableViewCell()
            }
            cell.isReadMore=self.isCompanyMore
            cell.descriptionTitle=self.jobModel?.company?.about ?? ""
            cell.moreAction={[weak self] in
                guard let wkSelf=self else {return}
                wkSelf.isCompanyMore = !wkSelf.isCompanyMore
                wkSelf.tableView.reloadData()
                
                //GA
                if wkSelf.isCompanyMore  {
                    CommonClass.googleEventTrcking("company_details_screen", action: "view_less", label: "")
                } else {
                    CommonClass.googleEventTrcking("company_details_screen", action: "view_more", label: "")
                }
            }
            return cell
        }
        //}
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MIJobListingTableCell.self), for: indexPath) as! MIJobListingTableCell
        
        let modelData=self.companyJobJson?.data![indexPath.row]
        cell.modelData=JoblistingCellModel(model: modelData!,isSearchLogo:modelData?.isSearchLogo ?? 0)
        cell.saveUnSaveAction={ [weak self] (save) in
            guard let wkSelf=self else {return}
            
            if let modelData=wkSelf.companyJobJson?.data![indexPath.row]{
                modelData.isSaved=save
                wkSelf.delegate?.jobSavedUnsaved(jobId: modelData.jobId ?? 0, isSave: save)
            }
            
            wkSelf.tableView.reloadRows(at: [indexPath], with: .automatic)
            if save{

                let lbl = "\(indexPath.row)" + "-" + "\(modelData?.jobId ?? 0)"
                
                self?.seekerJourneyMapEventsNetwork(type: CONSTANT_JOB_SEEKER_TYPE.SAVED_JOBS, data: ["eventValue" : CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK, "jobId": modelData?.jobId ?? 0])
                CommonClass.googleEventTrcking("company_details_screen", action: "save", label: lbl)
            }
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.sectionTitle[indexPath.section] == setionCompanyTitleEnum.activeJob.rawValue{
            self.companyJobJson?.data?[indexPath.row].isViewed=true
            if let cell = self.tableView.cellForRow(at: indexPath) as?  MIJobListingTableCell {
                cell.enable(on: false)
            }
            //            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            
            if let company = self.companyJobJson {
                
                if let dataValue = company.data {
                    if dataValue[indexPath.row].jobTypes?.filter({$0.lowercased().contains("sjs")}).count ?? 0 > 0 || dataValue[indexPath.row].isCJT == 1 {
                        guard let jdId = dataValue[indexPath.row].jobId , jdId != 0 else {
                            return
                        }
                        self.callIsViewedApi(jobId: jdId)
                        let vc=Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
                        vc.url = self.getSJSURL(model: dataValue[indexPath.row])
                        vc.ttl = "Detail"
                        let nav = MINavigationViewController(rootViewController:vc)
                        nav.modalPresentationStyle = .fullScreen
                        self.present(nav, animated: true, completion: nil)
                        
                    }else{
                        
                        let vc = MIJobDetailsViewController()
                        guard let jdId = dataValue[indexPath.row].jobId , jdId != 0 else {
                            return
                        }
                        let lbl = "\(indexPath.row)" + "-" + String(jdId)

                        CommonClass.googleEventTrcking("company_details_screen", action: "job_card", label: lbl)
                        
                        vc.jobId = "\(jdId)"
                        vc.delegate=self
                        vc.referralUrl = self.recuterOrCompanyType.eventTrack
                        vc.abTestingVersion = company.meta?.version ?? "V1"
                        vc.searchIdForAB =  String(dataValue[indexPath.row].resultId)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                }
            }
            
            
            //            if self.companyJobJson!.data![indexPath.row].jobTypes?.filter({$0.lowercased().contains("sjs")}).count ?? 0 > 0 || self.companyJobJson!.data![indexPath.row].isCJT == 1 {
            //                    self.callIsViewedApi(jobId: self.companyJobJson?.data?[indexPath.row].jobId ?? 0)
            //                    let vc=Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
            //                    vc.url = self.getSJSURL(model: self.companyJobJson!.data![indexPath.row])
            //                    vc.ttl = "Detail"
            //                    let nav = MINavigationViewController(rootViewController:vc)
            //                    nav.modalPresentationStyle = .fullScreen
            //                    self.present(nav, animated: true, completion: nil)
            //            }else{
            //                //GA
            //                let lbl = ("\(indexPath.row)") + "-" + String(self.companyJobJson!.data![indexPath.row].jobId!)
            //                CommonClass.googleEventTrcking("company_details_screen", action: "job_card", label: lbl)
            //
            //                let vc=MIJobDetailsViewController()
            //                vc.jobId = String(self.companyJobJson!.data![indexPath.row].jobId!)
            //                vc.delegate=self
            //                vc.referralUrl = self.recuterOrCompanyType.eventTrack
            //                vc.searchIdForAB =  String(self.companyJobJson!.data![indexPath.section].resultId)
            //                self.navigationController?.pushViewController(vc, animated: true)
            //
            //
            //            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section==0{
            return 0
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView=MITableSectionView()
        headerView.sectionTitlelabel.text=self.sectionTitle[section]
        headerView.viewAllButton.isHidden=true
        return headerView
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        if self.sectionTitle[indexPath.section] == setionCompanyTitleEnum.activeJob.rawValue{
            guard orientation == .left else { return nil }
            var title=SRPListingStoryBoardConstant.Apply
            if self.companyJobJson?.data![indexPath.row].jobTypes?.filter({$0.lowercased().contains(JobTypes.walkIn.value.lowercased())}).count ?? 0 > 0{
                title=SRPListingStoryBoardConstant.imIntersted
            }
            if let modelData=self.companyJobJson?.data![indexPath.row]{
                if modelData.isApplied != nil{
                    if modelData.isApplied!{
                        title=SRPListingStoryBoardConstant.Applied
                    }
                }
            }
            let applyAction = SwipeAction(style: .default, title:title) {[weak self] action, indexPath in
                // handle action by updating model with deletion
                navigateStartValue = nil
                if let jobId=self?.companyJobJson?.data![indexPath.row].jobId{
                    if let modelData=self?.companyJobJson?.data![indexPath.row]{
                        if modelData.isApplied != nil{
                            if modelData.isApplied!{
                                return
                            }
                        }
                    }
                    
                    self?.eventTrackingValue=self?.recuterOrCompanyType.eventTrack ?? .NONE
                    
                    self?.seekerJourneyMapEventsNetwork(type: CONSTANT_JOB_SEEKER_TYPE.APPLY, data: ["eventValue" : CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK, "jobId": jobId])
                    
                    //  self?.applyActionGlobal(jobId: String(jobId), redirectURl: self?.companyJobJson?.data![indexPath.section].redirectUrl)
                    if !CommonClass.isLoggedin(){
                        navigateStartValue = "\((indexPath.row / 10) * 10)"
                    }
                    self?.applyActionGlobal(jobId: String(jobId), redirectURl: self?.companyJobJson?.data?[indexPath.row].redirectUrl ?? "", jobApplyModel: self?.jobModel)
                    
                }
            }
            applyAction.backgroundColor = AppTheme.greenColor
            return [applyAction]
        }else{
            return nil
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
            //self.loadMore()
        }
    }
    func callPagination(){
        if let paging=self.companyJobJson?.meta?.paging{
            if let cursor=paging.cursors{
                if let newNext=cursor.next{
                    if let next=Int(newNext){
                        if next < paging.total!{
                            spinner.startAnimating()
                            self.tableView.tableFooterView?.isHidden = false
                            self.getJobApi(param: [self.recuterOrCompanyType.jobFilterType:[self.compOrRecId],SRPListingDictKey.next.rawValue:cursor.next ?? "10"])
                        }
                    }
                }
            }
        }
    }
    
    func seekerJourneyMapEventsNetwork(type: String, data: [String: Any]) {
        MIApiManager.hitSeekerJourneyMapEvents(type, data: data, source: "", destination: self.recuterOrCompanyType == .company ? CONSTANT_SCREEN_NAME.COMPANY_DETAIL : CONSTANT_SCREEN_NAME.RECRUITER_DETAIL) { (success, response, error, code) in
        }
    }
    
    func reloadRowsWithActive()->[IndexPath]{
        var indexArray=[IndexPath]()
        for i in 1 ..< self.jsonData.count{
            indexArray.append(IndexPath(row: i, section: 2))
        }
        return indexArray
    }
    
    func followAndUnfollowCmpanyOrRecuiter(path:String,method:RequestMethod,type:CompanyOrRec){
        if AppDelegate.instance.authInfo.accessToken.isEmpty{
            if type == .company{
                navigateAction = .followCompany
                let id=path.components(separatedBy: APIPath.followCompany)
                if id.count > 1{
                    navigateJobId=id[1]
                }
            }else{
                navigateAction = .followRecruiter
                let id=path.components(separatedBy: APIPath.followRecruiter)
                if id.count > 1{
                    navigateJobId=id[1]
                }
            }
            
            self.showLoginAlert(msg: "Please log in to continue.",navaction: navigateAction,jobId: navigateJobId)
        }else{
            self.followStatus = false
            let _ = MIAPIClient.sharedClient.load(path: path, method: method, params: [:]) { [weak self] (responseData, error,code) in
                  self?.followStatus = true
                
                DispatchQueue.main.async {
                    if error != nil {
                        //  DispatchQueue.main.async {
                        if code==401{
                            //self?.logoutToLogin()
                        }else{
                            self?.showAlert(title: "", message: error?.errorDescription)
                        }
                        //   }
                        return
                    }else{
                        if let jsonData=responseData as? [String:Any]{
                            // DispatchQueue.main.async {
                            isNetwork=true
                            self?.showAlert(title: "", message:jsonData["successMessage"]as?String,isErrorOccured:false)
                            switch method{
                            case .post:
                                if type == .company{
                                    self?.jobModel?.isCompanyFollow=true
                                    self?.jobModel?.company?.isCompanyFollow = true
                                    // self.isCompOrRecFollow = true
                                    CommonClass.googleEventTrcking("company_details_screen", action: "follow", label: "")
                                } else{
                                    self?.jobModel?.isRecruiterFollow=true
                                    //self.modelData?.isRecruiterFollow = true
                                }
                                self?.isCompOrRecFollow = true
                            case .delete:
                                if type == .company{
                                    self?.jobModel?.isCompanyFollow=false
                                    self?.jobModel?.company?.isCompanyFollow = false
                                    
                                    CommonClass.googleEventTrcking("company_details_screen", action: "unfollow", label: "")
                                }else{
                                    self?.jobModel?.isRecruiterFollow=false
                                    //self.modelData?.isRecruiterFollow = false
                                }
                               
                                self?.isCompOrRecFollow = false
                                
                            default:
                                break
                            }
                            if let wkself=self{
                                wkself.delegate?.companyFollowUnFollow(compId: Int(wkself.compOrRecId)!, isFollow: wkself.isCompOrRecFollow)
                            }
                            
                            self?.tableView.reloadData()
                            //  }
                        }
                        
                    }
                }
            }
            
        }
    }
    
}

extension MIRecruiterDetailsViewController: JobsAppliedOrSaveDelegate{
    func jobSaveUnsave(model: JoblistingData?, isSaved: Bool) {
        if let modelData=model{
            modelData.isSaved = isSaved
        }
        let filterData=companyJobJson?.data?.filter({$0.jobId == model?.jobId})
        if filterData?.count ?? 0 > 0{
            filterData![0].isSaved = isSaved
            delegate?.jobSavedUnsaved(jobId: filterData![0].jobId ?? 0, isSave: isSaved)
        }
        self.tableView.reloadData()
    }
    func jobApplied(model: JoblistingData?) {
        let filterData=companyJobJson?.data?.filter{$0.jobId == model?.jobId}
        if filterData?.count ?? 0 > 0{
            filterData![0].isApplied=true
            self.delegate?.jobApplied(jobId: filterData![0].jobId ?? 0)
        }
        self.tableView.reloadData()
    }
    func companyFollowUnFollow(compId: Int, isFollow: Bool) {
        self.isCompOrRecFollow=isFollow
        self.delegate?.companyFollowUnFollow(compId: compId, isFollow: isFollow)
        self.tableView.reloadData()
    }
}





extension UIButton{
    func showAsFollow(){
        self.layer.cornerRadius = CornerRadius.btnCornerRadius
        self.backgroundColor    = AppTheme.btnCTAGreenColor
        self.tintColor          = UIColor.white
        self.titleLabel?.font = UIFont.customFont(type: .Regular, size: CGFloat(14))
        self.setTitleColor(UIColor.white, for: .normal)
    }
    func showAsUnfollow(){
        self.layer.cornerRadius = CornerRadius.btnCornerRadius
        self.layer.borderColor=AppTheme.btnCTAGreenColor.cgColor
        self.backgroundColor = UIColor.white
        self.tintColor = AppTheme.btnCTAGreenColor
        self.layer.borderWidth=1
        self.layer.cornerRadius=2
        self.layer.masksToBounds=false
        self.setTitleColor(AppTheme.btnCTAGreenColor, for: .normal)
    }
}



