//
//  MICreateJobAlertSuccessViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 21/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SwipeCellKit

class MICreateJobAlertSuccessViewController: MIBaseViewController {
    
    //MARK:Outlets And Variables
    
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
    let tableView=UITableView()
    var jsonModelData:JoblistingBaseModel?
    var savedJobData:JoblistingBaseModel?
    var modelData:JobAlertModel?
    var jobAlertType:CreateJobAlertType = .create
    var flowViaReplaceResult : ManageAlertFlowVia = .ManageAlert
 
    //MARK:Life Cycle Method
    override func loadView() {
        super.loadView()
        self.view.addSubview(tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints=false
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: self.view.topAnchor),tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = AppTheme.viewBackgroundColor
      
        // tableView.register(UINib(nibName:String(describing: MIAppliedSavedNetworkTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIAppliedSavedNetworkTableViewCell.self))
        tableView.register(UINib(nibName:String(describing: MICreateAlertSuccessTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MICreateAlertSuccessTableViewCell.self))
        tableView.register(UINib(nibName:String(describing: MIJobListingTableCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIJobListingTableCell.self))
        
        tableView.delegate=self
        tableView.dataSource=self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.tableFooterView=UIView(frame: .zero)
        tableView.bounces=true
        MIActivityLoader.showLoader()
        self.callSimilaryJobsApi()
       
        if let vcs=self.navigationController?.viewControllers{
            for (index,vc) in vcs.enumerated(){
                if let _ = vc as? MICreateJobAlertViewController{
                    self.navigationController?.viewControllers.remove(at: index)
                    break
                }
                
            }
        }
       
    }

    func callSimilaryJobsApi(){
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
        param["limits"]=30
        let _ = MIAPIClient.sharedClient.load(path: APIPath.searchJob, method: .post, params: param) { (response, error,code) in
            DispatchQueue.main.async {
                MIActivityLoader.hideLoader()
            if error != nil{
                //DispatchQueue.main.async {
                    
                    //self.listView.tableView.tableFooterView?.isHidden=true
               // }
                return
            }else{
                if let jsonData=response as? [String:Any]{
                    //if let jobsData=jsonData["data"] as? [String:Any]{
                        self.jsonModelData=JoblistingBaseModel(dictionary: jsonData as NSDictionary)
                   // }
                   // DispatchQueue.main.async {
                     //   MIActivityLoader.hideLoader()
                        self.tableView.reloadData()
                   // }
                }
        }
        }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = self.jobAlertType == .edit ? ControllerTitleConstant.updateJobAlertSuccess: ControllerTitleConstant.createJobAlertSuccess
        
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)
       
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //self.navigationItem.hidesBackButton = false

    }
    

}

//MARK:UItableView Delegate and Data source
extension MICreateJobAlertSuccessViewController:UITableViewDelegate,UITableViewDataSource,SwipeTableViewCellDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.jsonModelData?.data != nil ? (self.jsonModelData?.data!.count)! + 1 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.section==0 {
            guard let cell=tableView.dequeueReusableCell(withIdentifier: String(describing: MICreateAlertSuccessTableViewCell.self), for: indexPath) as? MICreateAlertSuccessTableViewCell else {
                return UITableViewCell()
            }
            let titleAttribute=NSMutableAttributedString(string: "Your Job Alert ", attributes: [NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.font:UIFont.customFont(type: .light, size: 16)])
            let alertName=NSAttributedString(string: self.modelData?.alertName ?? "", attributes: [NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.font:UIFont.customFont(type: .Semibold, size: 15)])
            titleAttribute.append(alertName)
            var hasBeenString=" has been "
            if self.jobAlertType == .edit{
                hasBeenString+="Updated "
            }else{
                hasBeenString+="Created "
            }
            let hasbee=NSAttributedString(string: hasBeenString, attributes: [NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.font:UIFont.customFont(type: .light, size: 16)])
            titleAttribute.append(hasbee)
            cell.createdAlertTitle.attributedText = titleAttribute
            
            let subTitleString=NSMutableAttributedString(string: "You will now receive job alerts in your email ", attributes: [NSAttributedString.Key.foregroundColor:UIColor.init(hex: "8894a2"),NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 14)])
            let emailName=NSAttributedString(string: self.modelData?.email ?? "", attributes: [NSAttributedString.Key.foregroundColor:AppTheme.defaltBlueColor,NSAttributedString.Key.font:UIFont.customFont(type: .Semibold, size: 14)])
            subTitleString.append(emailName)
            let onceInWeek=NSAttributedString(string: " once a \(self.modelData?.frequency ?? "") for the job matching the below criteria.", attributes: [NSAttributedString.Key.foregroundColor:UIColor.init(hex: "8894a2"),NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 14)])
            subTitleString.append(onceInWeek)
            
            cell.createdAlertSubtitle.attributedText = subTitleString
            cell.manageAction={
                DispatchQueue.main.async {
                    if let vcs=self.navigationController?.viewControllers{
                        for (index,vc) in vcs.enumerated(){
                            if let _ = vc as? MIManageJobAlertVC{
                                self.navigationController?.viewControllers.remove(at: index)
                                break
                            }
                            
                        }
                    }
                    let manageJob=MIManageJobAlertVC()
                    self.navigationController?.pushViewController(manageJob, animated: true)
                }
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MIJobListingTableCell.self), for: indexPath) as! MIJobListingTableCell
            let modelData = self.jsonModelData?.data![indexPath.section-1]
            cell.modelData = JoblistingCellModel(model: modelData!,isSearchLogo:modelData!.isJdLogo ?? 0)
            cell.saveUnSaveAction={(save) in
                if let modelData=self.jsonModelData?.data![indexPath.section-1]{
                   modelData.isSaved=save
                }
                self.tableView.reloadData()
            }
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section==0{
            return 0
        }else if section==1{
            return 50
        }
        return 8
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section==1{
            let headerView=MITableSectionView()
            headerView.sectionTitlelabel.text="Job Matching Your Alert"
            headerView.viewAllButton.isHidden=true
            //headerView.topView1.backgroundColor=AppTheme.viewBackgroundColor
            return headerView
        }
        let view=UIView()
        view.backgroundColor = AppTheme.viewBackgroundColor
        return view
    }
    
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section >= 1{
        if let data=self.jsonModelData?.data,data.count > (indexPath.section-1){
            data[indexPath.section-1].isViewed=true
            
            if let cell = self.tableView.cellForRow(at:indexPath) as? MIJobListingTableCell {
                cell.enable(on: false)
            }
            
    //        self.tableView.reloadRows(at: [indexPath], with: .automatic)
            
            if let model = self.jsonModelData{
                
                if let data = model.data {
                    if (data[indexPath.section - 1].jobTypes?.filter({$0.lowercased().contains("sjs")}).count ?? 0 > 0 || data[indexPath.section-1].isCJT == 1) {
                        
                        guard let jobId = data[indexPath.section - 1].jobId , jobId != 0 else{
                            return
                        }
                        
                        self.callIsViewedApi(jobId: jobId)
                        let vc = Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
                        vc.url = getSJSURL(model:data[indexPath.section-1])
                        let nav = MINavigationViewController(rootViewController:vc)
                        nav.modalPresentationStyle = .fullScreen
                        vc.ttl = "Detail"
                        self.present(nav, animated: true, completion: nil)

                    }else{
                        let vc = MIJobDetailsViewController()
                        guard let jobId = data[indexPath.section - 1].jobId , jobId != 0 else{
                            return
                        }
                        vc.jobId = String(jobId)
                        vc.delegate=self
                        vc.referralUrl = .JOBALERT_JOBS
                        vc.searchIdForAB =  data[indexPath.section - 1].resultId
                        vc.abTestingVersion = model.meta?.version ?? "V1"
                        //String(self.jsonModelData!.data![indexPath.section-1].resultId)
                        self.navigationController?.pushViewController(vc, animated: true)

                    }
                }
            }
            
            
            
//                if (self.jsonModelData!.data![indexPath.section-1].jobTypes?.filter({$0.lowercased().contains("sjs")}).count ?? 0 > 0 || jsonModelData!.data![indexPath.section-1].isCJT == 1) {
//
//                    self.callIsViewedApi(jobId: self.jsonModelData!.data![indexPath.section-1].jobId ?? 0)
//                    let vc=Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
//
//                    vc.url = getSJSURL(model: jsonModelData!.data![indexPath.section-1])
//                    let nav = MINavigationViewController(rootViewController:vc)
//                    nav.modalPresentationStyle = .fullScreen
//                    vc.ttl = "Detail"
//                    self.present(nav, animated: true, completion: nil)
//            }else{
//                    let vc=MIJobDetailsViewController()
//                    vc.jobId = String(self.jsonModelData!.data![indexPath.section-1].jobId!)
//                    vc.delegate=self
//                    vc.referralUrl = .JOBALERT_JOBS
//                    vc.searchIdForAB = String(self.jsonModelData!.data![indexPath.section].resultId)
//                    self.navigationController?.pushViewController(vc, animated: true)
//            }
        }
    
    }
   }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if let modelData=self.jsonModelData?.data![indexPath.section-1]{
            if modelData.isApplied != nil{
                if modelData.isApplied!{
                    return nil
                }
            }
        }
        guard orientation == .left else { return nil }
        var title=SRPListingStoryBoardConstant.Apply
        if self.jsonModelData?.data![indexPath.section-1].jobTypes?.filter({$0==JobTypes.walkIn.value}).count ?? 0 > 0{
            title=SRPListingStoryBoardConstant.imIntersted
        }
        let applyAction = SwipeAction(style: .default, title:title) { action, indexPath in
            let model=self.jsonModelData?.data![indexPath.section-1]
            self.applyAction(jobId: String(model!.jobId!), redirctURl: model?.redirectUrl, jobApplyTracking: model!)
            // handle action by updating model with deletion
        }
        applyAction.backgroundColor = AppTheme.greenColor
        return [applyAction]
    }
    
    func applyAction(jobId: String,redirctURl:String?, jobApplyTracking: JoblistingData) {
        self.eventTrackingValue = .JOBALERT_JOBS
        self.applyActionGlobal(jobId: jobId, redirectURl: redirctURl, jobApplyModel: jobApplyTracking)
    }
    

}


extension MICreateJobAlertSuccessViewController:JobsAppliedOrSaveDelegate{
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
