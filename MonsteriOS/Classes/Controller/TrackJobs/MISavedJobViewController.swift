//
//  MISavedJobViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 31/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class MISavedJobViewController: MIBaseViewController,IndicatorInfoProvider {
    
    //var jsonData=[AppliedJobModel]()
    let tableView=UITableView()
    var delegate:JobDetailsNavigationDelegate!
    var controllerType:TrackJobsType = .saved
    var savedJobData:JoblistingBaseModel?
    private var nojobPopup  = MINoJobFoundPopupView.popup()
    let spinner = UIActivityIndicatorView(style: .gray)
    var isPaginationRunning = false
    
    lazy var networkHeaderView:MINetworkHeaderView={
        let netView=MINetworkHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 90))
        return netView
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(MISavedJobViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = Color.colorDarkBlack
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        // self.callApi()
        self.startActivityIndicator()
        self.savedJobData = nil
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
       // JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

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
        tableView.addSubview(self.refreshControl)
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        self.tableView.tableFooterView?.isHidden=true
        self.tableView.tableFooterView=spinner
        NotificationCenter.default.addObserver(self, selector: #selector(refreshJobListData), name: NSNotification.Name.refreshJobList, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshSavedData()
        if JobSeekerSingleton.sharedInstance.dataArray?.last != self.screenName {
            JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

        }
      
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        kActivityIndicator.stopAnimating()
    }
    func refreshSavedData(){
        if self.controllerType == .saved && isSavedOrUnsaved{
            self.startActivityIndicator()
            self.savedJobData = nil
            self.tableView.reloadData()
            self.getJobTracsApi(path: self.controllerType.apiPath, param: [:])
        }
    }
    @objc func refreshJobListData(){
        self.refreshSavedData()

    }
    func getJobTracsApi(path:String,param:[String:Any]){
        nojobPopup.removeMe()
        let _ = MIAPIClient.sharedClient.load(path:path, method: .get, params:param) { (responseDat, error,code) in
            DispatchQueue.main.async {
            self.isPaginationRunning = false
            self.stopActivityIndicator()

            if error != nil{
               // DispatchQueue.main.async {
                    self.tableView.tableFooterView?.isHidden=true
                    if error?.errorDescription == ServiceError.noInternetConnection.errorDescription{
                        self.nojobPopup.show(ttl: ErrorAndValidationMsg.opps.rawValue, desc:ErrorAndValidationMsg.somethingWrong.rawValue,imgNm: "plugbase")
                        self.nojobPopup.addFromTop(onView: self.view, topHeight: 66, onCompletion: nil)
                    }else if code==401{
                       // self.logoutToLogin()
                    }
                    else{
                        self.showAlert(title: "", message: error?.errorDescription)
                    }
                //}
                return
            }else{
                if let jsonData=responseDat as? [String:Any]{
                    if self.controllerType == .saved{
                        self.setSavedJobsData(response: jsonData)
                        isSavedOrUnsaved=false
                    }
                    
                   // DispatchQueue.main.async {
                        self.tableView.reloadData()
                       // self.stopActivityIndicator()
                        self.tableView.tableFooterView?.isHidden=true
                   // }
                }
            }
        }
        }
    }
    
    func setSavedJobsData(response:[String:Any]){
        if self.savedJobData == nil{
            self.savedJobData=JoblistingBaseModel(dictionary: response as NSDictionary)
        }else{
            let paginData=JoblistingBaseModel(dictionary: response as NSDictionary)
            if let dataArray=paginData?.data{
                for item in dataArray{
                    self.savedJobData?.data?.append(item)
                }
            }
            self.savedJobData?.meta=paginData?.meta
            self.savedJobData?.selectedFilters=paginData?.selectedFilters
            self.savedJobData?.filters=paginData?.filters
        }
        if let data=self.savedJobData?.data{
            for item in data{
                item.isSaved=true
            }
        }
        DispatchQueue.main.async {
            self.showNoSavedJob()
        }
    }
    
    func showNoSavedJob(){
        if self.savedJobData?.data?.count == 0 || self.savedJobData?.data == nil{
            self.nojobPopup.show(ttl: "No Saved Jobs found…", desc: "You can’t see any jobs here because you have not saved any jobs. You can save a job by clicking on ‘star’ icon",imgNm:"nojobfound")
            self.nojobPopup.addFromTop(onView: self.view, topHeight: 0, onCompletion: nil)
        }
    }
    
    //MARK:Delegate Method to show Title
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title:self.controllerType.value)
    }
    
    
}

//MARK:UITableView Delegate and Data Source Method
extension MISavedJobViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.savedJobData?.data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MIJobListingTableCell.self), for: indexPath) as! MIJobListingTableCell
        let modelData=self.savedJobData?.data?[indexPath.section]
        cell.modelData=JoblistingCellModel(model: modelData!,isSaved: true,isSearchLogo:modelData!.isSearchLogo ?? 0)
        cell.saveUnSaveAction = { [weak self] save in
            CommonClass.googleEventTrcking("track_screen", action: "saved", label: "unfollow")

            if !save {
                if let modelData=self?.savedJobData?.data?[indexPath.section] {
                    if let saved=self?.savedJobData?.data {
                        if let indexOf = saved.index(where:{$0.jobId==modelData.jobId}){
                            self?.savedJobData?.data?.remove(at: indexOf)
                        }
                    }
                    self?.showNoSavedJob()
                    self?.tableView.reloadData()
                }
            }
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
        // if let _dele=self.delegate{
        switch self.controllerType{
        case .saved:
            if let jobId=self.savedJobData?.data![indexPath.section].jobId{
                self.savedJobData?.data?[indexPath.section].isViewed=true
               if let cell = self.tableView.cellForRow(at: indexPath) as? MIJobListingTableCell {
                    cell.enable(on: false)
                }
                // self.tableView.reloadRows(at: [indexPath], with: .automatic)
      
                if self.savedJobData?.data![indexPath.section].jobTypes?.filter({$0.lowercased().contains("sjs")}).count ?? 0 > 0 || self.savedJobData?.data![indexPath.section].isCJT == 1{
                    self.callIsViewedApi(jobId: jobId)
                    let vc=Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
                    vc.url = self.getSJSURL(model: self.savedJobData!.data![indexPath.section])
                    vc.ttl = "Detail"
                    let nav = MINavigationViewController(rootViewController:vc)
                    nav.modalPresentationStyle = .fullScreen
                    self.present(nav, animated: true, completion: nil)
                }else{
                    CommonClass.googleEventTrcking("track_screen", action: "saved", label: "card_detail")
                    let detailsPage=MIJobDetailsViewController()
                    detailsPage.jobId=String(jobId)
                    detailsPage.referralUrl = .SAVED_JOBS
                    detailsPage.delegate=self
                    detailsPage.abTestingVersion = self.savedJobData?.meta?.version ?? "V1"
                    detailsPage.searchIdForAB =  String(self.savedJobData!.data![indexPath.section].resultId)
                    self.parent?.navigationController?.pushViewController(detailsPage, animated: true)
                }
            }
        default:
            break
        }
        
        //}
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 2.0 {
            if !self.isPaginationRunning {
                self.isPaginationRunning = true
                self.callPagination()
                
            }
            
            //self.loadMore()
        }
    }
    
    func callPagination(){
        
        if let paging=self.savedJobData?.meta?.paging{
            if let cursor=paging.cursors{
                if let newNext=cursor.next{
                    if let next=Int(newNext){
                        if next < paging.total!{
                            spinner.startAnimating()
                            self.tableView.tableFooterView?.isHidden = false
                            self.getJobTracsApi(path: self.controllerType.apiPath, param: [SRPListingDictKey.next.rawValue:cursor.next ?? "10",SRPListingDictKey.limits.rawValue:20])
                            
                        }
                    }
                }
            }
        }
    }
    
}

extension MISavedJobViewController:JobsAppliedOrSaveDelegate{
    func jobApplied(model: JoblistingData?) {
        if let netWorkIndex=self.savedJobData?.data?.firstIndex(where: {$0.jobId == model?.jobId}){
            self.savedJobData?.data?[netWorkIndex].isApplied=true
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: netWorkIndex)], with: .automatic)
        }
    }
    func jobSaveUnsave(model: JoblistingData?, isSaved: Bool) {
        
        if let netWorkIndex=self.savedJobData?.data?.firstIndex(where: {$0.jobId == model?.jobId}){
            self.savedJobData?.data?.remove(at: netWorkIndex)
            self.showNoSavedJob()
            self.tableView.reloadData()
            // self.tableView.reloadRows(at: [IndexPath(row: 0, section: netWorkIndex)], with: .automatic)
        }
    }
}
