//
//  MIAppliedSavedNetworkViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 21/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwipeCellKit
var isSavedOrUnsaved=true
var isAppliedFlag=true
var isNetwork=true
class MIAppliedSavedNetworkViewController: MIBaseViewController,IndicatorInfoProvider {

    //MARK:Outlets And Variables
    var jsonData=[AppliedJobModel]()
    let tableView=UITableView()
    var delegate:JobDetailsNavigationDelegate!
    var controllerType:TrackJobsType = .applied
    var isPaginationRunning = false
    var appliedJobData:JoblistingBaseModel?
    private var nojobPopup  = MINoJobFoundPopupView.popup()
    let spinner = UIActivityIndicatorView(style: .gray)
//    lazy var networkHeaderView:MINetworkHeaderView={
//        let netView=MINetworkHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 90))
//        return netView
//    }()
    
    lazy var headerView:MICreateHeaderView={
        let headerViewdata=MICreateHeaderView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 80))
        headerViewdata.topView.backgroundColor = UIColor.colorWith(r: 255, g: 202, b: 0, a: 0.3)
        headerViewdata.titleLabel.font=UIFont.customFont(type: .Medium, size: 14)
        headerViewdata.imageIcon.image = UIImage(named:"group")
        headerViewdata.titleLabel.text = "Monster or it’s partners do not charge any money from job seekers for job offers."
        return headerViewdata
    }()
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(MIAppliedSavedNetworkViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = Color.colorDarkBlack
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        // self.callApi()
        self.startActivityIndicator()
        self.appliedJobData = nil
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
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        tableView.addSubview(self.refreshControl)
        tableView.tableHeaderView = headerView
        self.tableView.tableFooterView=spinner
        self.tableView.tableFooterView?.isHidden=true
       // tableView.tableHeaderView?.backgroundColor = .red //UIColor.colorWith(r: 255, g: 202, b: 0, a: 0.3)
        //tableView.tableFooterView?.backgroundColor=UIColor.colorWith(r: 244, g: 246, b: 248, a: 1)
//        if self.controllerType == .viewed{
//            networkHeaderView.companyTapAction={
//                self.tableView.reloadData()
//            }
//            networkHeaderView.recuiterTapAction={
//                self.tableView.reloadData()
//            }
//            self.tableView.tableHeaderView = networkHeaderView
//
//        }
        
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.controllerType == .applied && isAppliedFlag{
            self.startActivityIndicator()
            self.appliedJobData=nil
            self.tableView.reloadData()
            self.getJobTracsApi(path: self.controllerType.apiPath, param: [:])
        }
        if JobSeekerSingleton.sharedInstance.dataArray?.last != self.screenName {
            JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

        }
      
        
    }
    
    func getJobTracsApi(path:String,param:[String:Any]){
       self.nojobPopup.removeMe()
        
        let _ = MIAPIClient.sharedClient.load(path:path, method: .get, params:param) { (responseDat, error,code) in
            DispatchQueue.main.async {
                self.isPaginationRunning = false
                self.stopActivityIndicator()
            if error != nil{
              //  DispatchQueue.main.async {
                   // self.stopActivityIndicator()
                    self.tableView.tableFooterView?.isHidden=true
                    if error?.errorDescription == ServiceError.noInternetConnection.errorDescription{
                        self.nojobPopup.show(ttl: ErrorAndValidationMsg.opps.rawValue, desc:ErrorAndValidationMsg.somethingWrong.rawValue,imgNm: "plugbase")
                        self.nojobPopup.addFromTop(onView: self.view, topHeight: 0, onCompletion: nil)
                    }else if code==401{
                        //self.logoutToLogin()
                    }
                    else{
                        self.showAlert(title: "", message: error?.errorDescription)
                    }
               // }
                return
            }else{
                if let jsonData=responseDat as? [String:Any]{
                   // print(jsonData)
                    if self.controllerType == .applied{
                        self.setAppliedJobsData(response: jsonData)
                        isAppliedFlag=false
                    }
                   // DispatchQueue.main.async {
                        
                        self.tableView.reloadData()
                       // self.stopActivityIndicator()
                        self.tableView.tableFooterView?.isHidden=true
                        }
                   // }
            }
        }
        }
    }
    

    func setAppliedJobsData(response:[String:Any]){
        if self.appliedJobData == nil{
            self.appliedJobData=JoblistingBaseModel(dictionary: response as NSDictionary)
        }else{
            let paginData=JoblistingBaseModel(dictionary: response as NSDictionary)
            if let dataArray=paginData?.data {
                for item in dataArray{
                    self.appliedJobData?.data?.append(item)
                }
            }
            self.appliedJobData?.meta=paginData?.meta
            self.appliedJobData?.selectedFilters=paginData?.selectedFilters
            self.appliedJobData?.filters=paginData?.filters
        }
        
        for item in self.appliedJobData?.data ?? []{
            item.isApplied=true
        }
        DispatchQueue.main.async {
            if self.appliedJobData?.data?.count == 0 || self.appliedJobData?.data == nil{
                self.nojobPopup.show(ttl: "No Applied Jobs found…", desc: "You can’t see any jobs here because you have not applied for any jobs.",imgNm:"nojobfound")
                self.nojobPopup.addFromTop(onView: self.view, topHeight: 0, onCompletion: nil)
            }
        }

        
    }
    //MARK:Delegate Method to show Title
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title:self.controllerType.value)
    }
    
    
}

//MARK:UITableView Delegate and Data Source Method
extension MIAppliedSavedNetworkViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
            return self.appliedJobData?.data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MIJobListingTableCell.self), for: indexPath) as! MIJobListingTableCell
        let modelData=self.appliedJobData?.data?[indexPath.section]
        cell.modelData=JoblistingCellModel(model: modelData!, isSaved: false,isSearchLogo:modelData!.isSearchLogo ?? 0)
        cell.saveUnSaveAction={ [weak self] save in
            if let modelData=self?.appliedJobData?.data?[indexPath.section]{
                modelData.isSaved = save
            }
            
            // self?.tableView.reloadData()
        }
        cell.savedButton.isHidden=true

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
                if let jobId=self.appliedJobData?.data?[indexPath.section].jobId{
                    self.appliedJobData?.data?[indexPath.section].isViewed = true
                    if let cell = self.tableView.cellForRow(at: indexPath) as? MIJobListingTableCell {
                        cell.enable(on: false)
                    }
                //    self.tableView.reloadRows(at: [indexPath], with: .automatic)

                    
                    if self.appliedJobData?.data![indexPath.section].jobTypes?.filter({$0.lowercased().contains("sjs")}).count ?? 0 > 0 || self.appliedJobData?.data![indexPath.section].isCJT == 1{
                        self.callIsViewedApi(jobId: jobId)
                        let vc=Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
                        vc.url = self.getSJSURL(model: self.appliedJobData!.data![indexPath.section])
                        vc.ttl = "Detail"
                        let nav = MINavigationViewController(rootViewController:vc)
                        nav.modalPresentationStyle = .fullScreen
                        self.present(nav, animated: true, completion: nil)
                    }else{
                        CommonClass.googleEventTrcking("track_screen", action: "applied", label: "card_detail")
                        let detailsPage=MIJobDetailsViewController()
                        detailsPage.jobId=String(jobId)
                        detailsPage.abTestingVersion = self.appliedJobData?.meta?.version ?? "V1"
                        detailsPage.referralUrl = .APPLIED_JOBS
                        detailsPage.searchIdForAB =   String(self.appliedJobData!.data![indexPath.section].resultId)
                        self.navigationController?.pushViewController(detailsPage, animated: true)
                    }
            
        }
    }
  
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 2.0 {
            if !isPaginationRunning {
                isPaginationRunning = true
                self.callPagination()

            }
            //self.loadMore()
        }
    }
  
    
    func callPagination(){
        
        guard let paging = appliedJobData?.meta?.paging else { return }
        guard let cursor = paging.cursors else { return }
        guard let newNext = cursor.next else { return }
        
        if let next = Int(newNext), next < paging.total! {
            spinner.startAnimating()
            self.tableView.tableFooterView?.isHidden = false
            self.getJobTracsApi(path: self.controllerType.apiPath, param: [SRPListingDictKey.next.rawValue:cursor.next ?? "10"])
        }
        
    }

}
