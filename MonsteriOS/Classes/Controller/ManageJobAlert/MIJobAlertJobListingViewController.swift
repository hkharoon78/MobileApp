//
//  MIJobAlertJobListingViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 19/02/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIJobAlertJobListingViewController: UIViewController {

    private var param=[String:Any]()
    var modelData:JobAlertModel?
    private var nojobPopup  = MINoJobFoundPopupView.popup()
    @IBOutlet weak var listView: MISRPTableVIew!
    override func viewDidLoad() {
        super.viewDidLoad()
           listView.delegate=self
        param[FilterType.skills.rawValue.lowercased()]=self.modelData?.keywords?.components(separatedBy: ",")
        param[FilterType.functions.rawValue.lowercased()]=self.modelData?.functionalArea?.components(separatedBy: ",")
        param[FilterType.locations.rawValue.lowercased()]=self.modelData?.desiredLocation?.components(separatedBy: ",")
        param["experience"]=self.modelData?.experience
        param[FilterType.skills.rawValue.lowercased()]=self.modelData?.keywords?.components(separatedBy: ",")
        param[FilterType.industries.rawValue.lowercased()]=self.modelData?.industry?.components(separatedBy: ",")
        param["salary"]=self.modelData?.salary != nil ? Int((self.modelData?.salary!)!)! * 100000 : 0
        // param["jobFreshness"]=7
        param["sort"]=2
        self.callSearchApi(param: param)
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = self.modelData?.alertName
    }


    func callSearchApi(param:[String:Any]){
        self.nojobPopup.removeMe()
        kActivityView.startAnimating()
        let _ = MIAPIClient.sharedClient.load(path:MIAPIPath.searchJob.rawValue,method: .post, params:param) { (dataResponse, error) in
            if error != nil{
                DispatchQueue.main.async {
                    kActivityView.stopAnimating()
                    self.listView.tableView.tableFooterView?.isHidden=true
                    if error?.errorDescription == ServiceError.noInternetConnection.errorDescription{
                        self.nojobPopup.show(ttl: ErrorAndValidationMsg.opps.rawValue, desc:ErrorAndValidationMsg.somethingWrong.rawValue,imgNm: "plugbase")
                        self.nojobPopup.addFromTop(onView: self.view, topHeight: 180, onCompletion: nil)
                    }else{
                        self.showAlert(title: "", message: error?.errorDescription)
                    }
                }
                return
            }else{
                if let jsonData=dataResponse as? [String:Any]{
                    if self.listView.jsonData==nil{
                        self.listView.jsonData=JoblistingBaseModel(dictionary: jsonData as NSDictionary)
                        
                    }else{
                        let paginData=JoblistingBaseModel(dictionary: jsonData as NSDictionary)
                        if let dataArray=paginData?.data{
                            for item in dataArray{
                                self.listView.jsonData?.data?.append(item)
                            }
                        }
                        self.listView.jsonData?.meta=paginData?.meta
                        self.listView.jsonData?.selectedFilters=paginData?.selectedFilters
                        self.listView.jsonData?.filters=paginData?.filters
                        
                    }
                    DispatchQueue.main.async {
                        self.listView.tableView.tableFooterView?.isHidden=true
                        self.listView.tableView.reloadData()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
                            kActivityView.stopAnimating()
                        })
                        // kActivityView.stopAnimating()
                        
                        if self.listView.jsonData?.data?.count == 0 || self.listView.jsonData?.data == nil {
                            addGAEnum(enumType: .nojobsfound_search)
                            self.nojobPopup.show(ttl: "No jobs Found", desc: "No jobs available according to your job Alert",imgNm:"icon")
                            self.nojobPopup.addFromTop(onView: self.view, topHeight: 180, onCompletion: nil)
                        }
                    }
                }
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MIJobAlertJobListingViewController:JobsAppliedOrSaveDelegate{
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


extension MIJobAlertJobListingViewController:SRPTableViewDelegate{
    func tableViewDidSelection(indexPath: IndexPath) {
        //self.longPressSelection(indexPath: indexPath)
        let vc=MIJobDetailsViewController()
        vc.delegate=self
        vc.jobId = String(self.listView.jsonData!.data![indexPath.section].jobId ?? 0)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func callScrollEndAPI(param:[String:Any]){
        var newParam=param
        for (key,value) in self.param{
            newParam[key]=value
        }
        self.callSearchApi(param: newParam)
    }
    
    func longPressSelected(indexPath:IndexPath){
       // self.longPressSelection(indexPath: indexPath)
    }
    
    func applyAction(jobId: String,redirectURl: String?) {
        if AppDelegate.instance.authInfo.accessToken.isEmpty{
            self.showLoginAlert(msg: "Please Login/Register to Apply",navaction: .apply,jobId: jobId)
            // self.showAlert(title: "", message: "Please Login/Register to Apply")
        }else if redirectURl != nil{
            let alertController=UIAlertController(title: "", message: jobPostedOn, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                self.forceApply(jobId: jobId)
                DispatchQueue.main.async {
                    let vc=Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
                    vc.url = redirectURl!
                    vc.ttl = ""
                    self.present(MINavigationViewController(rootViewController:vc), animated: true, completion: nil)
                }
                
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
        }
        else{
            let _ = MIAPIClient.sharedClient.load(path:MIAPIPath.canApply.rawValue, method: .post, params: ["jobId":jobId]) { (responseData,error) in
                if error != nil{
                    if let errorRespons=responseData as? [String:Any]{
                        let response=ApplyErrorBase(dictionary: errorRespons as NSDictionary)
                        if response?.errorCode == ApplyErrorCode.CANNOT_APPLY.rawValue{
                            if response?.payload?.result?.next == ApplyErrorCode.INCOMPLETE_PROFILE.rawValue{
                                //Go to incomplete
                                if let pendingArray=response?.payload?.result?.pendingActions{
                                    let pendFilter=pendingArray.filter({$0.pendingActionType.rawValue == PendingActionType.EDUCATION.rawValue || $0.pendingActionType.rawValue == PendingActionType.EMPLOYMENT.rawValue})
                                    if pendFilter.count > 0{
                                        self.initiatePendingView(pendingMode: pendFilter[0], jobId: jobId,redirectURL: redirectURl)
                                    }
                                }
                            }else{
                                DispatchQueue.main.async {
                                    self.forceApply(jobId: jobId)
                                }
                            }
                        }else{
                            DispatchQueue.main.async {
                                kActivityView.stopAnimating()
                                self.showAlert(title: "", message: errorRespons["errorMessage"]as?String)
                            }
                        }
                    }else{
                        DispatchQueue.main.async {
                            kActivityView.stopAnimating()
                            self.showAlert(title: "", message:error?.errorDescription)
                        }
                    }
                    return
                }else{
                    DispatchQueue.main.async {
                        CommonClass.recordClevarTapEvent("ApplyJobs", properties: ["job_id":jobId,"page_name":"Job Listing"])
                        // addGAEnum(enumType: .srp_walkin_applyjob)
                        self.showAlert(title: "", message: "Successfully Applied")
                        let filterData=self.listView.jsonData?.data?.filter{$0.jobId == Int(jobId)}
                        if filterData?.count ?? 0 > 0{
                            filterData![0].isApplied=true
                        }
                        isAppliedFlag=true
                        self.listView.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func forceApply(jobId:String){
        let _ = MIAPIClient.sharedClient.load(path:MIAPIPath.forceApply.rawValue, method: .post, params: ["job":["jobId":jobId],"profileId":UserDefaults.standard.integer(forKey: "profileId")]) { (responseData,error) in
            if error == nil{
                DispatchQueue.main.async {
                    kActivityView.stopAnimating()
                    //   addGAEnum(enumType: .srp_walkin_applyjob)
                    CommonClass.recordClevarTapEvent("ApplyJobs", properties: ["job_id":jobId,"page_name":"Job Listing"])
                    self.showAlert(title: "", message: "Successfully Applied")
                    let filterData=self.listView.jsonData?.data?.filter{$0.jobId == Int(jobId)}
                    if filterData?.count ?? 0 > 0{
                        filterData![0].isApplied=true
                    }
                    isAppliedFlag=true
                    self.listView.tableView.reloadData()
                }
            }else{
                DispatchQueue.main.async {
                    kActivityView.stopAnimating()
                }
            }
        }
    }
    
    func initiatePendingView(pendingMode:MIPendingItemModel,jobId:String,redirectURL:String?){
        DispatchQueue.main.async {
            let pendVc=MIApplyViewController()
            pendVc.pendingItemModel=pendingMode
            pendVc.pendinActionSuccess = { (Bool) in
                self.applyAction(jobId:jobId, redirectURl: redirectURL )
            }
            //pendVc.modalPresentationStyle = .overCurrentContext
            let navigation=MINavigationViewController(rootViewController:pendVc)
            navigation.modalPresentationStyle = .overCurrentContext
            self.tabBarController?.present(navigation, animated: true, completion: nil)
        }
    }
}
