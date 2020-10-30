//
//  MINetworkJobsViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 21/02/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwipeCellKit

class MINetworkJobsViewController: MIBaseViewController,IndicatorInfoProvider {

    var jsonData=[AppliedJobModel]()
    let tableView=UITableView()
    var delegate:JobDetailsNavigationDelegate!
    var controllerType:TrackJobsType = .viewed
    var isPaginationRunning = false
    var networkJobsData:JoblistingBaseModel?
    private var nojobPopup  = MINoJobFoundPopupView.popup()
    let spinner = UIActivityIndicatorView(style: .gray)
    lazy var networkHeaderView:MINetworkHeaderView={
        let netView=MINetworkHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 90))
        return netView
    }()
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(MINetworkJobsViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = Color.colorDarkBlack
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        // self.callApi()
        self.startActivityIndicator()
        self.networkJobsData = nil
        self.tableView.reloadData()
        self.getJobTracsApi(path: self.controllerType.apiPath, param: [:])
        refreshControl.endRefreshing()
    }
    //MARK:Life Cycle Method
    override func loadView() {
        super.loadView()
        self.view.addSubview(tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints=false
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: self.view.topAnchor),tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

        tableView.register(UINib(nibName:String(describing: MIJobListingTableCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIJobListingTableCell.self))
        tableView.delegate=self
        tableView.dataSource=self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.bounces=true
        tableView.tableFooterView=UIView(frame: .zero)
        spinner.tintColor = AppTheme.defaltTheme
        spinner.hidesWhenStopped=true
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        tableView.addSubview(self.refreshControl)
        self.tableView.tableFooterView?.isHidden=true
        self.tableView.tableFooterView=spinner
      
        networkHeaderView.companyTapAction={
            if let count = Int(self.networkHeaderView.companyCountLabel.text ?? "0"){
                if count > 0{
                    self.seekerJourneyMapEventsNetwork(type: CONSTANT_JOB_SEEKER_TYPE.COMPANIES_FOLLOWED, data: ["eventValue": CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK
                    ])
                    
                    CommonClass.googleEventTrcking("track_screen", action: "network", label: "companies")
                    let vc = MITrackCompaniesVC()
                    vc.open = .fromCompany
                    vc.delegate=self
                    self.navigationController?.pushViewController(vc, animated: true)
                }
              }
            }
        
        networkHeaderView.recuiterTapAction={
            if let count = Int(self.networkHeaderView.recuiterCountLabel.text ?? "0"){
                if count > 0{
                    self.seekerJourneyMapEventsNetwork(type: CONSTANT_JOB_SEEKER_TYPE.RECRUITER_FOLLOWED, data: ["eventValue": CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK])
                    
                    CommonClass.googleEventTrcking("track_screen", action: "network", label: "recruiters")

            let vc = MITrackCompaniesVC()
            vc.open = .fromRecruiter
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        

        
    }
    
    func setTableHeaderView(){
        tableView.tableFooterView?.backgroundColor=UIColor.colorWith(r: 244, g: 246, b: 248, a: 1)
        if self.controllerType == .viewed{
            
           
            self.tableView.tableHeaderView = networkHeaderView
            self.tableView.tableHeaderView?.isHidden=false
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if  isNetwork{
            self.startActivityIndicator()
            self.networkJobsData=nil
            self.tableView.reloadData()
            self.getJobTracsApi(path: self.controllerType.apiPath, param: [:])
        }
        if JobSeekerSingleton.sharedInstance.dataArray?.last != self.screenName {
            JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

        }
    }
    
    func getJobTracsApi(path:String,param:[String:Any]){
        self.tableView.tableHeaderView?.isHidden=true
        self.nojobPopup.removeMe()
        let _ = MIAPIClient.sharedClient.load(path:path, method: .get, params:param) { (responseDat, error,code) in
            DispatchQueue.main.async {
                self.stopActivityIndicator()

            self.isPaginationRunning = false
            if error != nil{
              //  DispatchQueue.main.async {
                   // self.stopActivityIndicator()
                    self.tableView.tableFooterView?.isHidden=true
                    if error?.errorDescription == ServiceError.noInternetConnection.errorDescription{
                        self.nojobPopup.show(ttl: ErrorAndValidationMsg.opps.rawValue, desc:ErrorAndValidationMsg.somethingWrong.rawValue,imgNm: "plugbase")
                        self.nojobPopup.addFromTop(onView: self.view, topHeight: 0, onCompletion: nil)
                    }else if code==401{
                       // self.logoutToLogin()
                    }
                    else{
                        self.showAlert(title: "", message: error?.errorDescription)
                    }
             //   }
                return
            }else{
                if let jsonData=responseDat as? [String:Any]{
                    // print(jsonData)
                    if self.controllerType == .viewed{
                        self.setAppliedJobsData(response: jsonData)
                        isNetwork=false
                    }
                   // DispatchQueue.main.async {
                        
                        self.tableView.reloadData()
                     //   self.stopActivityIndicator()
                        self.tableView.tableFooterView?.isHidden=true
                        
                   // }
                }
            }
        }
        }
    }
    
    
    func setAppliedJobsData(response:[String:Any]){
        if self.networkJobsData == nil{
            self.networkJobsData=JoblistingBaseModel(dictionary: response as NSDictionary)
        }else{
            let paginData=JoblistingBaseModel(dictionary: response as NSDictionary)
            if let dataArray=paginData?.data{
                for item in dataArray{
                    self.networkJobsData?.data?.append(item)
                }
            }
            self.networkJobsData?.meta=paginData?.meta
            self.networkJobsData?.selectedFilters=paginData?.selectedFilters
            self.networkJobsData?.filters=paginData?.filters
        }
    
        DispatchQueue.main.async {
            if self.networkJobsData?.data?.count == 0 || self.networkJobsData?.data == nil{
                self.nojobPopup.show(ttl: "No Nework Jobs found..", desc: "You can’t see any jobs here because you have not followed any company/recruiter.",imgNm:"nojobfound")
                self.nojobPopup.addFromTop(onView: self.view, topHeight: 0, onCompletion: nil)
            }else{
                if let compCount=response["followedCompanyCount"] as? Int{
                    self.networkHeaderView.companyCountLabel.text=String(compCount)
                }else{
                    self.networkHeaderView.companyCountLabel.text="0"

                }
                if let recCount=response["followedRecruiterCount"] as? Int{
                    self.networkHeaderView.recuiterCountLabel.text=String(recCount)
                }else{
                    self.networkHeaderView.recuiterCountLabel.text="0"

                }
                self.setTableHeaderView()
            }
        }
        
        
    }
    //MARK:Delegate Method to show Title
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title:self.controllerType.value)
    }
    
    func seekerJourneyMapEventsNetwork(type: String, data: [String: Any]) {
        MIApiManager.hitSeekerJourneyMapEvents(type, data: data, source: "", destination: CONSTANT_SCREEN_NAME.NETWORK_SCREEN) { (success, response, error, code) in
        }
    }
    
}

//MARK:UITableView Delegate and Data Source Method
extension MINetworkJobsViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.networkJobsData?.data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MIJobListingTableCell.self), for: indexPath) as! MIJobListingTableCell
        let modelData=self.networkJobsData?.data![indexPath.section]
        cell.modelData=JoblistingCellModel(model: modelData!,isSaved: false,isSearchLogo:modelData!.isSearchLogo ?? 0)
        cell.saveUnSaveAction = {(save) in
           
            if let modelData = self.networkJobsData?.data![indexPath.section]{
                modelData.isSaved = save
                if save{
    
                    self.seekerJourneyMapEventsNetwork(type: CONSTANT_JOB_SEEKER_TYPE.SAVED_JOBS, data: ["eventValue": CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK, "jobId": modelData.jobId ?? ""])
                }
                CommonClass.googleEventTrcking("track_screen", action: "network", label: save ? "follow" : "unfollow")
            }
            self.tableView.reloadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "f4f6f8")
        return v
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //if let _dele=self.delegate{
            if let jobId=self.networkJobsData?.data![indexPath.section].jobId{
                self.networkJobsData?.data?[indexPath.section].isViewed = true
                if let cell = self.tableView.cellForRow(at: indexPath) as? MIJobListingTableCell {
                    cell.enable(on: false)
                }
                //self.tableView.reloadRows(at: [indexPath], with: .automatic)
             
                
                if self.networkJobsData?.data![indexPath.section].jobTypes?.filter({$0.lowercased().contains("sjs")}).count ?? 0 > 0 || self.networkJobsData?.data![indexPath.section].isCJT == 1{
                     self.callIsViewedApi(jobId: jobId)
                    let vc=Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
                    vc.url = self.getSJSURL(model: self.networkJobsData!.data![indexPath.section])
                    vc.ttl = "Detail"
                    let nav = MINavigationViewController(rootViewController:vc)
                    nav.modalPresentationStyle = .fullScreen
                    self.present(nav, animated: true, completion: nil)
                }else{
                    CommonClass.googleEventTrcking("track_screen", action: "network", label: "card-detail")
                    let detailsPage=MIJobDetailsViewController()
                    detailsPage.jobId=String(jobId)
                    detailsPage.delegate=self
                    detailsPage.referralUrl = .NETWORK_JOBS
                    detailsPage.abTestingVersion = self.networkJobsData?.meta?.version ?? "V1"
                    detailsPage.searchIdForAB = String(self.networkJobsData!.data![indexPath.section].resultId)
                    self.parent?.navigationController?.pushViewController(detailsPage, animated: true)
                    }
            }
            
            
       // }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 2.0 {
            if !self.isPaginationRunning {
                self.isPaginationRunning = true
                //self.loadMore()
                self.callPagination()

            }

        }
    }
    
    
    func callPagination(){
        
        if let paging=networkJobsData?.meta?.paging{
            if let cursor=paging.cursors{
                if let newNext=cursor.next{
                    if let next=Int(newNext){
                        if next < paging.total!{
                            spinner.startAnimating()
                            self.tableView.tableFooterView?.isHidden = false
                            self.getJobTracsApi(path: self.controllerType.apiPath, param: [SRPListingDictKey.next.rawValue:cursor.next ?? "10"])
                            
                        }
                    }
                }
            }
        }
    }

}

extension MINetworkJobsViewController:JobsAppliedOrSaveDelegate{
        func jobApplied(model: JoblistingData?) {
            if let netWorkIndex=self.networkJobsData?.data?.firstIndex(where: {$0.jobId == model?.jobId}){
                self.networkJobsData?.data?[netWorkIndex].isApplied=true
                self.tableView.reloadRows(at: [IndexPath(row: 0, section: netWorkIndex)], with: .automatic)
            }
        }
        func jobSaveUnsave(model: JoblistingData?, isSaved: Bool) {
            
            if let netWorkIndex=self.networkJobsData?.data?.firstIndex(where: {$0.jobId == model?.jobId}){
                self.networkJobsData?.data?[netWorkIndex].isSaved=isSaved
                self.tableView.reloadRows(at: [IndexPath(row: 0, section: netWorkIndex)], with: .automatic)
            }

        }
}
extension MINetworkJobsViewController:followdCompanyAndRecruiterDelegate{
    func followdCompanyAndRecruiterCount(count: String) {
//        self.networkJobsData=nil
//        self.tableView.reloadData()
//        self.getJobTracsApi(path: self.controllerType.apiPath, param: [:])
    }
}

