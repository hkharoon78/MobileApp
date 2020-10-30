//
//  MIJobAppliedSuccesViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 07/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIJobAppliedSuccesViewController: MIBaseViewController {

    let tableView=UITableView()
    var jobModel:JoblistingData?
    var similarJobsData:JoblistingBaseModel?
    var setionTitle=["",""]
    var abTestingVersion = "V1"
    override func loadView() {
        super.loadView()
        self.view.addSubview(tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints=false
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: self.view.topAnchor),tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        self.view.backgroundColor = AppTheme.viewBackgroundColor
        self.tableView.register(UINib(nibName: String(describing: MIJobAppliedSuccessCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIJobAppliedSuccessCell.self))
        self.tableView.register(UINib(nibName: String(describing: MIJobAppliedCompanyDetailsCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIJobAppliedCompanyDetailsCell.self))
        tableView.register(UINib(nibName:String(describing: MISwippingTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MISwippingTableViewCell.self))
        tableView.register(UINib(nibName:String(describing: MIHorizontalScrollTableCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIHorizontalScrollTableCell.self))
         tableView.register(UINib(nibName:String(describing: MIWalkinInfoTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIWalkinInfoTableViewCell.self))
        tableView.delegate=self
        tableView.dataSource=self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.bounces = true
        tableView.backgroundColor = AppTheme.viewBackgroundColor
        
        if let vcs = self.navigationController?.viewControllers{
            for (index,vc) in vcs.enumerated(){
                if let _ = vc as? MIJobDetailsViewController{
                    self.navigationController?.viewControllers.remove(at: index)
                    break
                }
                
            }
        }
        self.getSimilarJobsApi()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title="Job Applied"
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

    }

    func getSimilarJobsApi(){
        self.startActivityIndicator()
        //self.tableView.reloadData()
        
        let _ = MIAPIClient.sharedClient.load(path: APIPath.appliedalsoapplied, method: .get, params: ["jobId":self.jobModel?.jobId ?? 0,"limit":30]) { [weak self](response, error,code) in
            DispatchQueue.main.async {
                self?.stopActivityIndicator()
            
            if error != nil{
                
                return
            }else{
                if let jsonData=response as? [String:Any]{
                    self?.similarJobsData = JoblistingBaseModel(dictionary: jsonData as NSDictionary)
                    self?.similarJobsData?.data=self?.similarJobsData?.data?.filter({$0.isApplied == false})
                    
                    if self?.similarJobsData?.data?.count ?? 0 > 0{
                        self?.setionTitle.append("")
                    }
                  //  DispatchQueue.main.async {
                       // self?.stopActivityIndicator()
                        self?.tableView.reloadData()
                  //  }
                    
                }
            }
        }
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

extension MIJobAppliedSuccesViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return setionTitle.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
           return  self.jobModel?.walkInVenue?.addresses != nil ? 2 : 1
        }
        if section == 1 {
            if (self.jobModel?.hideCompanyName == 1) {
                return 0
            }
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0{
            guard let cell=tableView.dequeueReusableCell(withIdentifier: String(describing: MIJobAppliedSuccessCell.self), for: indexPath)as?MIJobAppliedSuccessCell else {
                return UITableViewCell()
            }
           
            // let role = self.jobModel?.roles?.joined(separator: ",") ?? ""
              //  cell.jobTitleLabel.text = (self.jobModel?.title ?? "") + " at " + (self.jobModel?.company?.name ?? "")
            let jobTitle = (self.jobModel?.title ?? "")
            let companyName = ((self.jobModel?.hideCompanyName == 1) ? "*Confidential*" : (self.jobModel?.company?.name ?? ""))
                
            cell.jobTitleLabel.text = jobTitle + " at " + companyName

            cell.successTitleLabel.text = "You have successfully submitted your application for "
            return cell
                
            }else{
            guard let cell=tableView.dequeueReusableCell(withIdentifier: String(describing: MIWalkinInfoTableViewCell.self), for: indexPath)as?MIWalkinInfoTableViewCell else {
                return UITableViewCell()
            }
            cell.modelData = WalkinInfoCellModel(model: self.jobModel?.walkInVenue)
            return cell
            }
        case 1:
            guard let cell=tableView.dequeueReusableCell(withIdentifier: String(describing: MIJobAppliedCompanyDetailsCell.self), for: indexPath)as?MIJobAppliedCompanyDetailsCell else {
                return UITableViewCell()
            }
           
            //cell.followTitleLabel.text="Follow the company and the Recruiter to stay updated"
            if self.jobModel?.hideCompanyName == 0 {
                cell.followTitleLabel.text = " Follow the company  to stay updated"
                   
                if self.jobModel?.recruiter?.kiwiSocialId != nil { //modelData?.recruiter?.kiwiSocialId != nil{
                    cell.followTitleLabel.text = " Follow the company and the Recruiter to stay updated"
                }
            }
            
            if self.jobModel != nil{
                cell.modelData=JobAppliedCompAndRecuiDetails(model: self.jobModel!)
            }
            
            cell.followAndUnfollowCompAction={[weak self] (follow) in
                guard let wkSelf=self else {return}
                if follow{
                    wkSelf.followAndUnfollowCmpanyOrRecuiter(path: APIPath.unfollowCompany + String(wkSelf.jobModel?.companyId ?? 0), method: .delete, type: .company)
                }else{
                    wkSelf.followAndUnfollowCmpanyOrRecuiter(path: APIPath.followCompany + String(wkSelf.jobModel?.companyId ?? 0), method: .post, type: .company)
                }
            }
            cell.followAndUnfollowRecAction={[weak self] (follow) in
                 guard let wkSelf=self else {return}
                if follow{
                    if let uuid = wkSelf.jobModel?.recruiter?.recruiterUuid,uuid.count > 0 {
                        wkSelf.followAndUnfollowCmpanyOrRecuiter(path: APIPath.unfollowRecruiter + uuid, method: .delete, type: .recruiter)

                    }
                }else{
                    if let uuid = wkSelf.jobModel?.recruiter?.recruiterUuid,uuid.count > 0 {
                        wkSelf.followAndUnfollowCmpanyOrRecuiter(path: APIPath.followRecruiter + uuid, method: .post, type: .recruiter)

                    }
                }
            }
            return cell
        case 2:
            guard let cell=tableView.dequeueReusableCell(withIdentifier: String(describing: MIHorizontalScrollTableCell.self), for: indexPath) as? MIHorizontalScrollTableCell else {
                return UITableViewCell()
            }
            cell.isNoMoreAdd=false
            cell.jobListingModel = self.similarJobsData
            cell.isApplyViewShow=true
            cell.swipeCardSelection={[weak self] (index,bool) -> Void in
                guard let `self`=self else {return}
                if !bool{
                    if self.similarJobsData?.data![index].jobTypes?.filter({$0.lowercased().contains("sjs")}).count ?? 0 > 0 || self.similarJobsData?.data![index].isCJT == 1{
                        self.callIsViewedApi(jobId: self.similarJobsData?.data?[index].jobId ?? 0)
                        let vc=Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
                        vc.url = self.getSJSURL(model: self.similarJobsData!.data![index])
                        vc.ttl = "Detail"
                        let nav = MINavigationViewController(rootViewController:vc)
                        nav.modalPresentationStyle = .fullScreen

                        self.present(nav, animated: true, completion: nil)
                    }else{
                       let vc=MIJobDetailsViewController()
                        vc.delegate=self
                        vc.referralUrl = .APPLIED_ALSOAPPLIED_JOBS
                        if let jobId=self.similarJobsData?.data![index].jobId{
                            vc.jobId=String(jobId)
                            vc.abTestingVersion = self.similarJobsData?.meta?.version ?? "V1"
                            vc.searchIdForAB = String(self.similarJobsData!.data![index].resultId)
                        }
                       self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            cell.applyCardSelection={[weak self](jobId,redirectUrl,isApplied) in
                guard let `self`=self else {return}
                if isApplied {
                    self.eventTrackingValue = .APPLIED_ALSOAPPLIED_JOBS
                    self.applyActionGlobal(jobId: String(jobId ?? 0), redirectURl: redirectUrl, jobApplyModel: self.jobModel)

                }else{
                    self.skipJob(jobId: jobId?.stringValue ?? "")
                }
                
            }
            return cell
        default:
            break
        }
       return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section==0{
            return 0
        }
        if section == 1 {
            if (self.jobModel?.hideCompanyName == 1) {
                return 0
            }
        }
        if section == 2{
            return 60
        }
        return 80
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section==1{
            let updateView=MIJobAppliedSuccesHeader(frame: CGRect(x: 0, y: 0, width: self.view.frame.height, height: 80))
            updateView.backgroundColor = AppTheme.viewBackgroundColor
            updateView.mobileOrEmaiLabel.text="The company may try to reach you at \(AppDelegate.instance.userInfo.mobileNumber) (or) \(AppDelegate.instance.userInfo.primaryEmail)"
            return updateView
        }
        
        if section == 2{
            let headerView=MITableSectionView()
            headerView.sectionTitlelabel.text="People also applied for"
            headerView.viewAllButton.isHidden=false
            headerView.viewAllAction={[weak self] in
                let vc=MIViewAllJobsViewController()
                vc.controllerType = .appliedAlsoAplplied
               vc.param["jobId"]=self?.jobModel?.jobId
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            return headerView
        }
        return UIView()
    }
    
    func followAndUnfollowCmpanyOrRecuiter(path:String,method:RequestMethod,type:CompanyOrRec){
      
            let _ = MIAPIClient.sharedClient.load(path: path, method: method, params: [:]) { [weak self](responseData, error,code) in
                DispatchQueue.main.async {
                if error != nil {
                   // DispatchQueue.main.async {
                        if code==401{
                         //   self?.logoutToLogin()
                        }else{
                        self?.showAlert(title: "", message: error?.errorDescription)
                        }
                   // }
                    return
                }else{
                    if let jsonData=responseData as? [String:Any]{
                       // DispatchQueue.main.async {
                            isNetwork=true
                            self?.showAlert(title: "", message:jsonData["successMessage"]as?String,isErrorOccured:false)
                            switch method{
                            case .post:
                                if type == .company{
                                    self?.jobModel?.isCompanyFollow = true
                                    //self.isCompOrRecFollow = true
                                }else{
                                    self?.jobModel?.isRecruiterFollow = true
                                    //self.modelData?.isRecruiterFollow = true
                                }
                            case .delete:
                                if type == .company{
                                    self?.jobModel?.isCompanyFollow = false
                                   // self.isCompOrRecFollow = false
                                }else{
                                    self?.jobModel?.isRecruiterFollow = false
                                    //self.modelData?.isRecruiterFollow = false
                                }
                            default:
                                break
                            }
                            
                            self?.tableView.reloadData()
                       // }
                    }
                    
                }
        }
            }
    }
    
}

extension MIJobAppliedSuccesViewController:JobsAppliedOrSaveDelegate{
    func jobApplied(model: JoblistingData?) {
        let filterData=self.similarJobsData?.data?.filter{$0.jobId == model?.jobId}
        if filterData?.count ?? 0 > 0{
            filterData![0].isApplied=true
        }
        self.similarJobsData?.data=self.similarJobsData?.data?.filter({$0.isApplied != true})
        self.tableView.reloadData()
        //self.tblView.reloadData()
    }
    func jobSaveUnsave(model: JoblistingData?, isSaved: Bool) {
        
    }
    
}
