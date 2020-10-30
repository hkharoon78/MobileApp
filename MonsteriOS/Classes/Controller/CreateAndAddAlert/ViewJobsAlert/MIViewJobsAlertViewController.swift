//
//  MIViewJobsAlertViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 16/04/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import SwipeCellKit

class MIViewJobsAlertViewController: MIBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var jsonModelData:JoblistingBaseModel?
    var modelData:JobAlertModel?
    var isPaginationRunning = false
    let spinner = UIActivityIndicatorView(style: .gray)
    private var nojobPopup  = MINoJobFoundPopupView.popup()
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName:String(describing: MIJobListingTableCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIJobListingTableCell.self))
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
        self.callSimilaryJobsApi(next: 0)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title=self.modelData?.alertName
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

    }

    func callSimilaryJobsApi(next:Int){
        
        var param=[String:Any]()
         param["query"]=self.modelData?.keywords
            param[FilterType.functions.rawValue.lowercased()] = self.modelData?.functionalArea?.count ?? 0 > 0 ?  self.modelData?.functionalArea?.components(separatedBy: ",") : nil
        param[FilterType.locations.rawValue.lowercased()] = self.modelData?.desiredLocation?.count ?? 0 > 0 ?  self.modelData?.desiredLocation?.components(separatedBy: ",") : nil
      
        if self.modelData?.experience != nil {
            param["experienceRanges"] = [(self.modelData?.experience!)!  + "~" + (self.modelData?.experience!)!]
        }
        param[FilterType.industries.rawValue.lowercased()] = self.modelData?.industry?.count ?? 0 > 0 ?  self.modelData?.industry?.components(separatedBy: ",") : nil
        
        if self.modelData?.salary != nil , let salaryInt=Int((self.modelData?.salary!)!),salaryInt > 0{
           param["salaryRanges"]=[String(salaryInt*100000)+"~"+String(salaryInt*100000)]
        }
        
        param[SRPListingDictKey.next.rawValue]=next
        let _ = MIAPIClient.sharedClient.load(path: APIPath.searchJob, method: .post, params: param) { (response, error,code) in
            DispatchQueue.main.async {
            self.stopActivityIndicator()

            self.isPaginationRunning=false
            if error != nil{
               // DispatchQueue.main.async {
                    self.tableView.tableFooterView?.isHidden=true
                    if error?.errorDescription == ServiceError.noInternetConnection.errorDescription{
                        self.nojobPopup.show(ttl: ErrorAndValidationMsg.opps.rawValue, desc:ErrorAndValidationMsg.somethingWrong.rawValue,imgNm: "plugbase")
                        self.nojobPopup.addFromTop(onView: self.view, topHeight:66, onCompletion: nil)
                    }else if code==401{
                       // self.logoutToLogin()
                    }
                    else{
                        self.showAlert(title: "", message: error!.errorDescription)
                    }
               // }
                return
            }else{
                if let jsonData=response as? [String:Any]{
                    let alrtJobbase=JoblistingBaseModel(dictionary: jsonData as NSDictionary)
                    if self.jsonModelData==nil{
                    self.jsonModelData=alrtJobbase
                    }else{
                        for item in alrtJobbase?.data ?? []{
                            self.jsonModelData?.data?.append(item)
                        }
                        self.jsonModelData?.meta=alrtJobbase?.meta
                    }
                   // DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.tableView.tableFooterView?.isHidden=true
                      //  self.stopActivityIndicator()
                        if self.jsonModelData?.data?.count == 0 || self.jsonModelData?.data == nil{
                            self.nojobPopup.show(ttl:ErrorAndValidationMsg.noJobFound.rawValue, desc:ErrorAndValidationMsg.noAlertJobAvailable.rawValue,imgNm:"icon")
                            self.nojobPopup.addFromTop(onView: self.view, topHeight: 66, onCompletion: nil)
                        }
                   // }
                }
            }
            }
        }
        
    }

}

extension MIViewJobsAlertViewController:UITableViewDelegate,UITableViewDataSource,SwipeTableViewCellDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.jsonModelData?.data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MIJobListingTableCell.self), for: indexPath) as! MIJobListingTableCell
        let modelData=self.jsonModelData?.data![indexPath.section]
        cell.modelData=JoblistingCellModel(model: modelData!,isSearchLogo:modelData!.isSearchLogo ?? 0)
        cell.saveUnSaveAction={(save) in
            if let modelData=self.jsonModelData?.data![indexPath.section]{
                modelData.isSaved=save
            }
            self.tableView.reloadData()
        }
        cell.delegate = self
        return cell

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
            if let data=self.jsonModelData?.data,data.count > (indexPath.section){
                data[indexPath.section].isViewed=true
                if let cell = self.tableView.cellForRow(at: indexPath) as? MIJobListingTableCell {
                    cell.enable(on: false)
                }
               // self.tableView.reloadRows(at: [indexPath], with: .automatic)
               
                
                if self.jsonModelData!.data![indexPath.section].jobTypes?.filter({$0.lowercased().contains("sjs")}).count ?? 0 > 0 || jsonModelData!.data![indexPath.section].isCJT == 1{
                    self.callIsViewedApi(jobId: self.jsonModelData!.data![indexPath.section].jobId ?? 0)
                    let vc=Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
                   
                        vc.url = getSJSURL(model: jsonModelData!.data![indexPath.section])
    
                    vc.ttl = "Detail"
                    let nav = MINavigationViewController(rootViewController:vc)
                    nav.modalPresentationStyle = .fullScreen
                    self.present(nav, animated: true, completion: nil)
                }else{
                let vc=MIJobDetailsViewController()
                vc.jobId = String(self.jsonModelData!.data![indexPath.section].jobId!)
                vc.delegate=self
                vc.referralUrl = .JOBALERT_JOBS
                vc.abTestingVersion = self.jsonModelData?.meta?.version ?? "V1"
                vc.searchIdForAB = String(self.jsonModelData!.data![indexPath.section].resultId)
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
            self.applyAction(jobId: String(model!.jobId!), redirctURl: model?.redirectUrl, jobApplyTracking: model!)
            // handle action by updating model with deletion
        }
        applyAction.backgroundColor = AppTheme.greenColor
        return [applyAction]
    }
    
    func applyAction(jobId: String,redirctURl:String?, jobApplyTracking: JoblistingData) {
        self.applyActionGlobal(jobId: jobId, redirectURl: redirctURl, jobApplyModel: jobApplyTracking)
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




extension MIViewJobsAlertViewController:JobsAppliedOrSaveDelegate{
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
