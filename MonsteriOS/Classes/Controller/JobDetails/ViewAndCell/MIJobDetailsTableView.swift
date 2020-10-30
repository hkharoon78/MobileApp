//
//  MIJobDetailsTableView.swift
//  MonsteriOS
//
//  Created by ishteyaque on 15/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
enum JobDetailsSectionTitle:String{
    case jobTitle=""
    case jobDetails="Job Details"
    case jobDescription="Job Description"
    case aboutCompany="About Company"
    case aboutRecuiter="About Recruiter"
    case similarJobs="Similar Jobs"
}

class MIJobDetailsTableView: UIView {
    var sectionTitle=[String]()
    var isJobDescMore=true
    var isCompanyMore=true
    var modelData:JoblistingData?{
        didSet{
            if self.modelData != nil{
                self.sectionTitle.append(JobDetailsSectionTitle.jobTitle.rawValue)
                self.sectionTitle.append(JobDetailsSectionTitle.jobDescription.rawValue)
                self.sectionTitle.append(JobDetailsSectionTitle.jobDetails.rawValue)
                if modelData?.hideCompanyName == 0{
                    self.sectionTitle.append(JobDetailsSectionTitle.aboutCompany.rawValue)
                    if modelData?.recruiter?.kiwiSocialId != nil{
                       self.sectionTitle.append(JobDetailsSectionTitle.aboutRecuiter.rawValue)
                    }
                }
                
            }
            
        }
    }
    var similarJobsData:JoblistingBaseModel?{
        didSet{
            if similarJobsData?.data?.count ?? 0 > 0{
                self.sectionTitle.append(JobDetailsSectionTitle.similarJobs.rawValue)
            }else if similarJobsData?.data?.count == 0{
                if let index=self.sectionTitle.firstIndex(of:JobDetailsSectionTitle.similarJobs.rawValue){
                    self.sectionTitle.remove(at:index)
                    self.tableView.reloadData()
                }
               
            }
        }
    }
    var totalViews="1"
    @IBOutlet weak var tableView: UITableView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        configure()
    }
    
    
    func configure(){
        tableView.register(UINib(nibName:String(describing: MIJobTitleTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIJobTitleTableViewCell.self))
        tableView.register(UINib(nibName:String(describing: MIJobDetailTitleTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIJobDetailTitleTableViewCell.self))
        tableView.register(UINib(nibName:String(describing: MIWalkinInfoTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIWalkinInfoTableViewCell.self))
        
        tableView.register(UINib(nibName:String(describing: MIJobDetailsTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIJobDetailsTableViewCell.self))
        
        tableView.register(UINib(nibName:String(describing: MIJobDescriptionTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIJobDescriptionTableViewCell.self))
        
        tableView.register(UINib(nibName:String(describing: MIAboutCompanyTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIAboutCompanyTableViewCell.self))
        
        tableView.register(UINib(nibName:String(describing: MISwippingTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MISwippingTableViewCell.self))
        tableView.register(UINib(nibName:String(describing: MIHorizontalScrollTableCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIHorizontalScrollTableCell.self))
        
        tableView.delegate=self
        tableView.dataSource=self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView=UIView(frame: .zero)
        tableView.bounces=true
        tableView.separatorStyle = .none
       
    }
    
}

extension MIJobDetailsTableView: UITableViewDelegate,UITableViewDataSource{
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sectionTitle[section]==JobDetailsSectionTitle.aboutCompany.rawValue{
            return 2
        } else if section == 0 {
            return self.modelData?.walkInVenue?.addresses != nil ? 2 : 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        switch sectionTitle[indexPath.section] {
        case JobDetailsSectionTitle.jobTitle.rawValue:
            if indexPath.row==0{
                //Mark:- Sprint 4
            /*    guard let cell=tableView.dequeueReusableCell(withIdentifier: String(describing: MIJobTitleTableViewCell.self), for: indexPath)as?MIJobTitleTableViewCell else {
                    return UITableViewCell()
                }
                if let details=self.modelData {
                    cell.modelData=JoblistingCellModel(model: details, isSearchLogo:modelData!.isJdLogo ?? 0)
                }
                cell.totalViewLabel.text = "Total Views: " + totalViews
                cell.companyDetailAction={[weak self]() in
                    guard let `self` = self else {return}
                    if  self.modelData?.isMicrosite == 1 && self.modelData?.micrositeUrl != nil{
                        let vc=Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
                        vc.url = "https:\(self.modelData?.micrositeUrl ?? "")"
                        vc.ttl = "Detail"
                        let nav = MINavigationViewController(rootViewController:vc)
                        nav.modalPresentationStyle = .fullScreen
                        self.parentViewController?.present(nav, animated: true, completion: nil)
                    }else{
                        
                        let comDeta=MIRecruiterDetailsViewController()
                        comDeta.compOrRecId = String(self.modelData?.companyId ?? 0)
                        comDeta.recuterOrCompanyType = .company
                        comDeta.delegate=self
                        comDeta.jobModel = self.modelData
                        comDeta.isCompOrRecFollow = self.modelData?.isCompanyFollow ?? false
                        self.parentViewController?.navigationController?.pushViewController(comDeta, animated: true)
                        
                    }
                }
                return cell*/
                
                //Mark:- Sprint 5
                let cell = tableView.dequeueReusableCell(withClass: MIJobDetailTitleTableViewCell.self, for: indexPath)
                let userSkills = self.parentViewController?.tabbarController?.userITPlusNonItSkill ?? []

                if let details = self.modelData {
                    let modelData=JoblistingCellModel(model: details, isSearchLogo: details.isJdLogo ?? 0)
                    cell.populateData(modelData, userSkills: userSkills)
                }
                cell.totalViewLabel.text = "Total Views: " + totalViews
                cell.companyDetailAction={[weak self]() in
                    guard let `self` = self else {return}
                    if  self.modelData?.isMicrosite == 1 && self.modelData?.micrositeUrl != nil{
                        let vc=Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
                        vc.url = "https:\(self.modelData?.micrositeUrl ?? "")"
                        vc.ttl = "Detail"
                        let nav = MINavigationViewController(rootViewController:vc)
                        nav.modalPresentationStyle = .fullScreen
                        self.parentViewController?.present(nav, animated: true, completion: nil)
                    } else {

                        let comDeta=MIRecruiterDetailsViewController()
                        comDeta.compOrRecId = String(self.modelData?.companyId ?? 0)
                        comDeta.recuterOrCompanyType = .company
                        comDeta.delegate=self
                        comDeta.jobModel = self.modelData
                        comDeta.isCompOrRecFollow = self.modelData?.isCompanyFollow ?? false
                        self.parentViewController?.navigationController?.pushViewController(comDeta, animated: true)
                    }
                }
                cell.addSkillAction = { [weak self] unMatchedSkills in
                    CommonClass.googleEventTrcking("job_detail_screen", action: "add_skills", label: "")
                    let skillsVC = MISkillAddViewController()
                    skillsVC.flowVia = .ViaJobDetail
                    skillsVC.selectedSkills = self?.parentViewController?.tabbarController?.userITPlusNonItSkill ?? []
                    skillsVC.suggestedSkillData = unMatchedSkills
                    self?.parentViewController?.navigationController?.pushViewController(skillsVC, animated: true)

                    skillsVC.callBackAfterResponse = { [weak self] _ in
                        cell.notReused = true
                        self?.tableView.reloadData()
                    }
                }

                return cell
                
            }else{
                guard let cell=tableView.dequeueReusableCell(withIdentifier: String(describing: MIWalkinInfoTableViewCell.self), for: indexPath)as?MIWalkinInfoTableViewCell else {
                    return UITableViewCell()
                }
                cell.modelData = WalkinInfoCellModel(model: self.modelData?.walkInVenue,isApplied:self.modelData?.isApplied ?? false)
                return cell
            }
            
        case JobDetailsSectionTitle.jobDetails.rawValue:
            guard let cell=tableView.dequeueReusableCell(withIdentifier: String(describing: MIJobDetailsTableViewCell.self), for: indexPath)as?MIJobDetailsTableViewCell else {
                return UITableViewCell()
            }
            cell.jobDetails=JobDetailsModel(industryTitle: self.modelData?.industries?.joined(separator: ",") ?? "", roleTitle: self.modelData?.roles?.joined(separator: ",") ?? "", functionalTitle: self.modelData?.functions?.joined(separator: ",") ?? "")
            cell.experLevelIsHidden=true
            return cell
            
        case JobDetailsSectionTitle.jobDescription.rawValue:
            guard let cell=tableView.dequeueReusableCell(withIdentifier: String(describing: MIJobDescriptionTableViewCell.self), for: indexPath)as?MIJobDescriptionTableViewCell else {
                return UITableViewCell()
            }
            let companyDesp=self.modelData?.description ?? ""
            cell.isReadMore=self.isJobDescMore
            cell.descriptionTitle=companyDesp
            cell.moreAction={ [weak self] in
                guard let `self`=self else {return}
                self.isJobDescMore = !self.isJobDescMore
                if let sectionNumbr = self.sectionTitle.firstIndex(of: JobDetailsSectionTitle.jobDescription.rawValue) {
                    self.tableView.reloadData()
                    self.tableView.scrollToRow(at:IndexPath(row: 0, section: sectionNumbr) , at:
                        self.isJobDescMore  ? .bottom : .top , animated: false)
                }
                
                //GA
                if self.isJobDescMore {
                    CommonClass.googleEventTrcking("job_detail_screen", action: "view_less", label: "")
                } else {
                    CommonClass.googleEventTrcking("job_detail_screen", action: "view_more", label: "")
                }
                
            }
            
            return cell
            
        case JobDetailsSectionTitle.aboutCompany.rawValue:
           
            if indexPath.row==0{
                guard let cell=tableView.dequeueReusableCell(withIdentifier: String(describing: MIAboutCompanyTableViewCell.self), for: indexPath)as?MIAboutCompanyTableViewCell else {
                    return UITableViewCell()
                }
                
                cell.compOrRec = .company
                cell.companyDetails=CompanyDetailsModel(comapanyTitle:self.modelData?.company?.name ?? "", comanyFunctional:self.modelData?.company?.industries?.joined(separator: ",") ?? "", comapanyImageURL:self.modelData?.company?.logo,isFollow:modelData?.isCompanyFollow ?? false)
                
                
                cell.followAndUnfollowAction={ [weak self] (follow) in
                    guard let `self`=self else {return}
                    
                    CommonClass.googleEventTrcking("job_detail_screen", action: follow ? "unfollow" : "follow", label: "company") //GA
                    
                    if follow{
                        self.followAndUnfollowCmpanyOrRecuiter(path: APIPath.unfollowCompany + String(self.modelData?.companyId ?? 0), method: .delete, type: .company)
                        
                    }else{
                        self.followAndUnfollowCmpanyOrRecuiter(path: APIPath.followCompany + String(self.modelData?.companyId ?? 0), method: .post, type: .company)
                        
                        if let pv=self.parentViewController as? MIJobDetailsViewController{
                            pv.seekerJDEvent("FOLLOW_COMPANY", version: "")
                        }

                    }
                }
                cell.moreJobsAction={ [weak self] in
                    guard let `self`=self else {return}
                    let jobListing=MISRPJobListingViewController()
                    jobListing.jobTypes = .company
                    jobListing.companyIds = [self.modelData?.companyId ?? 0]
                    jobListing.selectedSkills = self.modelData?.company?.name ?? ""
                  
                    if let parentVc=self.parentViewController{
                        parentVc.navigationController?.pushViewController(jobListing, animated: true)
                    }
                    
                    CommonClass.googleEventTrcking("job_detail_screen", action: "more_jobs", label: "") //GA
                    
                }
                cell.comapanyDetailsAction={ [weak self] in
                    guard let `self`=self else {return}
                    
                    if  self.modelData?.isMicrosite == 1 && self.modelData?.micrositeUrl != nil{
                        let vc=Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
                        vc.url = "https:\(self.modelData?.micrositeUrl ?? "")"
                        vc.ttl = "Detail"
                        let nav = MINavigationViewController(rootViewController:vc)
                        nav.modalPresentationStyle = .fullScreen
                        self.parentViewController?.present(nav, animated: true, completion: nil)
                    } else {
                    let comDeta = MIRecruiterDetailsViewController()
                    comDeta.compOrRecId = String(self.modelData?.companyId ?? 0)
                    comDeta.recuterOrCompanyType = .company
                   // comDeta.companyJson = self.modelData?.company
                    comDeta.delegate=self
                    comDeta.jobModel = self.modelData
                    comDeta.isCompOrRecFollow = self.modelData?.isCompanyFollow ?? false
                    self.parentViewController?.navigationController?.pushViewController(comDeta, animated: true)
                    
                    }
                }
                return cell
            }
            else{
                guard let cell=tableView.dequeueReusableCell(withIdentifier: String(describing: MIJobDescriptionTableViewCell.self), for: indexPath)as?MIJobDescriptionTableViewCell else {
                    return UITableViewCell()
                }
                cell.isReadMore=self.isCompanyMore
                cell.descriptionTitle=self.modelData?.company?.about ?? ""
                cell.moreAction={ [weak self] in
                    guard let `self`=self else {return}
                    self.isCompanyMore = !self.isCompanyMore
                    self.tableView.reloadData()
                    //self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
                return cell
            }
        case JobDetailsSectionTitle.aboutRecuiter.rawValue:
            
            guard let cell=tableView.dequeueReusableCell(withIdentifier: String(describing: MIAboutCompanyTableViewCell.self), for: indexPath)as?MIAboutCompanyTableViewCell else {
                return UITableViewCell()
            }
            
            cell.compOrRec = .recruiter
            cell.companyDetails=CompanyDetailsModel(comapanyTitle:self.modelData?.recruiter?.name ?? self.modelData?.recruiterName ?? "", comanyFunctional:self.modelData?.recruiter?.designations ?? "", comapanyImageURL:self.modelData?.recruiter?.avatarUrl,isFollow:modelData?.isRecruiterFollow ?? false,recImageString:self.modelData?.recruiter?.avatarUrl,isFollowShow:self.modelData?.recruiter?.profileStatus ?? true)
            
            cell.followAndUnfollowAction={ [weak self] (follow) in
                guard let `self`=self else {return}
                
                CommonClass.googleEventTrcking("job_detail_screen", action: follow ? "unfollow" : "follow" , label: "recuiter") //GA
                
                if follow{
                    self.followAndUnfollowCmpanyOrRecuiter(path: APIPath.unfollowRecruiter + (self.modelData?.recruiter?.recruiterUuid ?? ""), method: .delete, type: .recruiter)
                    
                }else{
                    self.followAndUnfollowCmpanyOrRecuiter(path: APIPath.followRecruiter + (self.modelData?.recruiter?.recruiterUuid ?? ""), method: .post, type: .recruiter)
                    
                    if let pv=self.parentViewController as? MIJobDetailsViewController{
                        pv.seekerJDEvent("FOLLOW_RECRUITER",version: "")
                    }
                }
            }
            cell.moreJobsAction={ [weak self] in
                guard let `self`=self else {return}
                let jobListing=MISRPJobListingViewController()
                jobListing.jobTypes = .recruiter
                jobListing.recruiterIds = self.modelData?.recruiterId ?? 0
                jobListing.selectedSkills = self.modelData?.recruiter?.name ?? self.modelData?.recruiterName ?? ""
                if let parentVc=self.parentViewController{
                    parentVc.navigationController?.pushViewController(jobListing, animated: true)
                }
                
                CommonClass.googleEventTrcking("job_detail_screen", action: "posted_jobs", label: "") //GA
                
            }
            
            cell.recruiterDetailsAction = { [weak self] in
                guard let `self`=self else {return}
                let comDeta=MIRecruiterDetailsViewController()
                comDeta.compOrRecId = String(self.modelData?.recruiterId ?? 0)
                comDeta.recuterOrCompanyType = .recuiter
//                comDeta.companyJson = self.modelData?.recruiter
                comDeta.delegate=self
                comDeta.jobModel = self.modelData
                comDeta.isCompOrRecFollow = self.modelData?.isRecruiterFollow ?? false
                self.parentViewController?.navigationController?.pushViewController(comDeta, animated: true)
                
            }
            
            return cell
            
        default:
            guard let cell=tableView.dequeueReusableCell(withIdentifier: String(describing: MIHorizontalScrollTableCell.self), for: indexPath) as? MIHorizontalScrollTableCell else {
                return UITableViewCell()
            }
            cell.isNoMoreAdd=false
            cell.isApplyViewShow=true
            cell.jobListingModel = self.similarJobsData
          
            cell.swipeCardSelection={ [weak self] (index,bool) -> Void in
                
                guard let `self`=self else {return}
                
                if !bool{
                    if let parentVc=self.parentViewController{
                        
                        let similarJobs = [
                            "jobId" : self.similarJobsData?.data?[index].jobId?.stringValue as Any,
                            "clickedOn" : "JD",// [APPLY]
                            "jobRank" : index+1
                            ] as [String : Any]
                        if let pv = self.parentViewController as? MIJobDetailsViewController{
                            pv.seekerJDEvent("SIMILAR_JOBS", similarJob: similarJobs,version: self.similarJobsData?.meta?.version ?? "V1" )
                        }
                        if self.similarJobsData?.data![index].jobTypes?.filter({ $0.lowercased().contains("sjs") }).count ?? 0 > 0 || self.similarJobsData?.data![index].isCJT == 1 {
                            if let pv=parentVc as? MIJobDetailsViewController{
                                pv.callIsViewedApi(jobId: self.similarJobsData?.data?[index].jobId ?? 0)
                            }
                            let vc=Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
                            if let newVc=parentVc as? MIJobDetailsViewController{
                                vc.url = newVc.getSJSURL(model: self.similarJobsData!.data![index])
                            }
                            vc.ttl = "Detail"
                            let nav = MINavigationViewController(rootViewController:vc)
                            nav.modalPresentationStyle = .fullScreen

                            parentVc.present(nav, animated: true, completion: nil)
                        } else{
                            let vc=MIJobDetailsViewController()
                            vc.delegate=self
                            vc.compRecDelegate=self
                            vc.isCompDelegate=true
                            vc.referralUrl = .SIMILAR_JOBS
                           
                            vc.abTestingVersion = self.similarJobsData?.meta?.version ?? "V1"

                            if let jobId=self.similarJobsData?.data![index].jobId{
                                vc.jobId=String(jobId)
                                vc.searchIdForAB = String(self.similarJobsData!.data![index].resultId)
                            }
                            parentVc.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
            
            cell.applyCardSelection={[weak self](jobId,redirectUrl,isApplied) in
                
                if isApplied {
                    let data = ["eventValue" : CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK, "jobId": String(jobId ?? 0)]
                    MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.SIMILAR_JOB_APPLY, data: data, source: CONSTANT_SCREEN_NAME.JOBDETAIL, destination: CONSTANT_SCREEN_NAME.JOBDETAIL) { (success, response, error, code) in
                    }
                    
                    guard let `self`=self else {return}
                    
                    let index = (self.similarJobsData?.data?.firstIndex(where: { $0.jobId == jobId }) ?? 0) + 1
                    
                    let similarJobs = [
                        "jobId" : jobId?.stringValue as Any,
                        "clickedOn" : "APPLY",
                        "jobRank" : index as Any
                        ] as [String : Any]
                    if let pv = self.parentViewController as? MIJobDetailsViewController{
                        pv.seekerJDEvent("SIMILAR_JOBS", similarJob: similarJobs, source: "JD",version: self.similarJobsData?.meta?.version ?? "V1")
                    }
                    
                    if let parentVc=self.parentViewController as? MIJobDetailsViewController{
                        
                        parentVc.isApplyFromSimilarJobs=true
                        parentVc.eventTrackingValue = .SIMILAR_JOBS
                        parentVc.applyActionGlobal(jobId: String(jobId ?? 0), redirectURl: redirectUrl, jobApplyModel: self.modelData)
                       //parentVc.applyAction(jobId: String(jobId ?? 0), redirectURl: redirectUrl)
                    }

                }else{
                    guard let `self`=self else {return}

                    if let parentVc=self.parentViewController as? MIJobDetailsViewController,  jobId ?? 0 > 0 {
                        guard let jobSkipId = jobId?.stringValue else {return}
                        parentVc.skipJob(jobId: jobSkipId)
                    }
                }
                
            }
            return cell
            //}
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
      
        if self.sectionTitle[section]==JobDetailsSectionTitle.similarJobs.rawValue{
          headerView.viewAllButton.isHidden=false
            headerView.viewAllAction={[weak self] in
               
                CommonClass.googleEventTrcking("job_detail_screen", action: "similar_jobs", label: "view_all") //GA
                
                let vc=MIViewAllJobsViewController()
                vc.controllerType = .similarJobs
                vc.param["jobId"]=self?.modelData?.jobId
                self?.parentViewController?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        return headerView
    }
    
    
    func followAndUnfollowCmpanyOrRecuiter(path:String,method:RequestMethod,type:CompanyOrRec) {
        if AppDelegate.instance.authInfo.accessToken.isEmpty{
            if type == .company{
                navigateAction = .followCompany
                let id=path.components(separatedBy: APIPath.followCompany)
                if id.count > 1{
                    navigateJobId=id[1]
                }
            } else {
                navigateAction = .followRecruiter
                let id=path.components(separatedBy: APIPath.followRecruiter)
                if id.count > 1{
                    navigateJobId=id[1]
                }
            }
            
            self.parentViewController?.showLoginAlert(msg: "Please log in to continue.",navaction: navigateAction,jobId: navigateJobId)
        }else{
            let _ = MIAPIClient.sharedClient.load(path: path, method: method, params: [:]) { [weak self](responseData, error,code) in
                DispatchQueue.main.async {
                if error != nil {
                    
                  //  DispatchQueue.main.async {
                        if code==401{
                          //  self?.parentViewController?.logoutToLogin()
                        }else{
                        self?.parentViewController?.showAlert(title: "", message: error?.errorDescription)
                        }
                  //  }
                    return
                }else{
                    if let jsonData=responseData as? [String:Any]{
                       // DispatchQueue.main.async {
                            isNetwork=true
                            self?.parentViewController?.showAlert(title: "", message:jsonData["successMessage"]as?String,isErrorOccured:false)
                            switch method{
                            case .post:
                                if type == .company{
                                    
                                    self?.modelData?.isCompanyFollow = true
                                    for vc in self?.parentViewController?.navigationController?.viewControllers ?? []{
                                        if let detailsVc=vc as? MIJobDetailsViewController{
                                            if detailsVc.listView.modelData?.companyId==self?.modelData?.companyId{
                                                detailsVc.listView.modelData?.isCompanyFollow=true
                                            }
                                        }
                                    }

                                }else{
                                    self?.modelData?.isRecruiterFollow = true
                                    for vc in self?.parentViewController?.navigationController?.viewControllers ?? []{
                                        if let detailsVc=vc as? MIJobDetailsViewController{
                                            if detailsVc.listView.modelData?.recruiter?.recruiterUuid==self?.modelData?.recruiter?.recruiterUuid{
                                                detailsVc.listView.modelData?.isRecruiterFollow=true
                                            }
                                        }
                                    }
                                }
                            case .delete:
                                if type == .company{
                                    self?.modelData?.isCompanyFollow = false
                                    for vc in self?.parentViewController?.navigationController?.viewControllers ?? []{
                                        if let detailsVc=vc as? MIJobDetailsViewController{
                                            if detailsVc.listView.modelData?.companyId==self?.modelData?.companyId{
                                                detailsVc.listView.modelData?.isCompanyFollow=false
                                            }
                                        }
                                    }

                                }else{
                                    self?.modelData?.isRecruiterFollow = false
                                    for vc in self?.parentViewController?.navigationController?.viewControllers ?? []{
                                        if let detailsVc=vc as? MIJobDetailsViewController{
                                            if detailsVc.listView.modelData?.recruiter?.recruiterUuid==self?.modelData?.recruiter?.recruiterUuid{
                                                detailsVc.listView.modelData?.isRecruiterFollow=false
                                            }
                                        }
                                    }
                                }
                            default:
                                break
                            }
//                            if let parent=self.parentViewController as? MIJobDetailsViewController{
//                                if parent.isCompDelegate{
//                                    var id=""
//                                    if type == .company{
//                                      id=String(self.modelData?.company?.companyId ?? 0)
//                                    }else{
//                                        id = self.modelData?.recruiter?.recruiterUuid ?? "0"
//                                    }
//                                    if let _del=parent.compRecDelegate{
//                                        _del.companyRecuiterFollowUnFollow(type: type, actionType: method, id: id)
//                                    }
//                                }
//                            }
                            self?.tableView.reloadData()
                     //   }
                    }
                    
                }
                }
            }
            
        }
    }
    
}


extension MIJobDetailsTableView:CompanyDetailsDelegate{
    func jobApplied(jobId: Int) {
        self.modelData?.isApplied = true
        if let parentVc=self.parentViewController as? MIJobDetailsViewController{
            parentVc.delegate?.jobApplied(model: self.modelData)
        }
        self.tableView.reloadData()
    }
    func jobSavedUnsaved(jobId: Int, isSave: Bool) {
        self.modelData?.isSaved = isSave
        if let parentVc=self.parentViewController as? MIJobDetailsViewController{
            parentVc.delegate?.jobSaveUnsave(model: modelData, isSaved: isSave)
        }
        self.tableView.reloadData()
    }
    func companyFollowUnFollow(compId: Int, isFollow: Bool) {
       // self.modelData?.isCompanyFollow=isFollow
      //  self.tableView.reloadData()
    }
}

extension MIJobDetailsTableView:JobsAppliedOrSaveDelegate{
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

extension MIJobDetailsTableView:CompanyOrRecFollowDelegate{
  
    func companyRecuiterFollowUnFollow(type: CompanyOrRec, actionType: RequestMethod, id: String) {
        if let parent=self.parentViewController as? MIJobDetailsViewController{
            if parent.isCompDelegate{
                if let _del=parent.compRecDelegate{
                    _del.companyRecuiterFollowUnFollow(type: type, actionType: actionType, id: id)
                }
            }
        }
        switch type {
        case .company:
            switch actionType{
            case .post:
                if self.modelData?.company?.companyId == Int(id){
                   self.modelData?.isCompanyFollow=true
                }
            case .delete:
                if self.modelData?.company?.companyId == Int(id){
                    self.modelData?.isCompanyFollow=false
                }
            default:
                break
            }
        case .recruiter:
            switch actionType{
            case .post:
                if self.modelData?.recruiter?.recruiterUuid == id{
                    self.modelData?.isRecruiterFollow=true
                }

            case .delete:
                if self.modelData?.recruiter?.recruiterUuid == id{
                    self.modelData?.isRecruiterFollow=false
                }
            default:
                break
            }
        }
        self.tableView.reloadData()
    }
}


