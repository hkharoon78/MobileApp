//
//  MITrackCompaniesVC.swift
//  MonsteriOS
//
//  Created by Anushka on 22/02/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

enum OpenFrom {
    case fromCompany
    case fromRecruiter
}

protocol followdCompanyAndRecruiterDelegate{
    func followdCompanyAndRecruiterCount(count: String)
}

class MITrackCompaniesVC: MIBaseViewController {
    
    @IBOutlet weak var tableViewTrackCompanies: UITableView!
    @IBOutlet weak var lblCountFollowCompnay: UILabel!
    
    var open: OpenFrom = .fromCompany
    var delegate: followdCompanyAndRecruiterDelegate?
    var isPaginationRunning = false
    let spinner = UIActivityIndicatorView(style: .gray)
    
    var listing: FollowedComRecBaseModel? {
        didSet {
            DispatchQueue.main.async {[weak self] in
                self?.tableViewTrackCompanies.reloadData()
            }
        }
        
    }

    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
             
        self.initialSetUp()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let count = self.listing?.meta?.paging?.total ?? 0
        self.delegate?.followdCompanyAndRecruiterCount(count: "\(count)")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if open == .fromCompany {
            JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.COMPANY_YOU_FOLLOWING)
            self.title = "Companies you’re following"
        } else {
            JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.RECRUITERS_YOU_FOLLOWING)
           self.title = "Recruiters you’re following"
        }
    }
    
    func initialSetUp(){
        
        //self.trackCompaniesListingApi(path: MIAPIPath.getFollowedCompany.rawValue, param: [:])

        self.tableViewTrackCompanies.delegate = self
        self.tableViewTrackCompanies.dataSource = self
        
        self.tableViewTrackCompanies.tableFooterView=UIView(frame: .zero)
        self.spinner.tintColor = AppTheme.defaltTheme
        self.spinner.hidesWhenStopped=true
        self.spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.tableViewTrackCompanies.bounds.width, height: CGFloat(44))
        self.tableViewTrackCompanies.tableFooterView = spinner
        self.tableViewTrackCompanies.tableFooterView?.isHidden=true
        self.tableViewTrackCompanies.register(UINib(nibName: "MITrackCompaniesCell", bundle: nil), forCellReuseIdentifier: "MITrackCompaniesCell")
        self.setTitleAndCallAPI()
        
    }
    
    func setTitleAndCallAPI(){
        self.listing=nil
        self.tableViewTrackCompanies.reloadData()
        if open == .fromCompany {
           // self.title = "Companies you’re following"
            self.trackCompaniesListingApi(path: APIPath.getFollowedCompany, param: [:])
        } else {
            
            self.trackCompaniesListingApi(path: APIPath.getFollowedRecruiter, param: [:])
        }
    }
    

}


extension MITrackCompaniesVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listing?.data?.count == nil ? 0 : (self.listing?.data?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "MITrackCompaniesCell") as! MITrackCompaniesCell
        
        cell.modelData = self.listing?.data?[indexPath.row]
        cell.btnFollowCompnay.tag = indexPath.row
        cell.btnFollowCompnay.addTarget(self, action: #selector(btnFollowingPressed(_:)), for: .touchUpInside)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        let jobData=JoblistingData()
     
        jobData.company=self.listing!.data![indexPath.row].companyDetails
        jobData.recruiter=self.listing!.data![indexPath.row].recruiterDetails
        jobData.isRecruiterFollow=self.listing!.data![indexPath.row].isFollowed
        jobData.isCompanyFollow=self.listing!.data![indexPath.row].isFollowed
      
        let comDeta=MIRecruiterDetailsViewController()
        comDeta.compOrRecId = String(self.listing!.data![indexPath.row].id ?? 0)
       
        if self.open == .fromCompany{
            comDeta.recuterOrCompanyType = .company
        }else{
           comDeta.recuterOrCompanyType = .recuiter
        }
       
        comDeta.delegate=self
        comDeta.jobModel = jobData
        comDeta.isCompOrRecFollow = true
        
        self.navigationController?.pushViewController(comDeta, animated: true)
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
        
        if let paging=self.listing?.meta?.paging {
            if let cursor=paging.cursors{
               
                if let newNext=cursor.next{
                    
                    if let next=Int(newNext){
                        
                        if next < paging.total!{
                            spinner.startAnimating()
                            self.tableViewTrackCompanies.tableFooterView?.isHidden = false
                            
                            self.trackCompaniesListingApi(path: open == .fromCompany ? APIPath.getFollowedCompany : APIPath.getFollowedRecruiter, param: ["start": cursor.next ?? "10"])
                        }
                    }
                }
            }
        }
        
    }
    
    @objc func btnFollowingPressed(_ sender: UIButton){

        let index = sender.tableViewIndexPath(tableViewTrackCompanies)!
        
        if let row = self.listing?.data?[index.row]{
        //let id = row?.id
        let recruiterId = row.recruiterUuid
        let companyId = row.companyId
        
        if !row.isFollowed {
                        
            if open == .fromCompany {
                
                self.followUnfollowCompanyRecruiter(path: APIPath.followCompany + (companyId ?? "0"), method: .post, type: "company")
                
                self.listing = self.listing.map({ (obj) -> FollowedComRecBaseModel in
                    obj.meta?.paging?.total = (obj.meta?.paging?.total)! + 1
                    return obj
                })
                

            } else {
                
                self.followUnfollowCompanyRecruiter(path: APIPath.followRecruiter + (recruiterId ?? "0"), method: .post, type: "recruiter")
                
                self.listing = self.listing.map({ (obj) -> FollowedComRecBaseModel in
                    obj.meta?.paging?.total = (obj.meta?.paging?.total)! + 1
                    return obj
                })

                
            }
            
            
        } else {

            if open == .fromCompany {
                self.followUnfollowCompanyRecruiter(path: APIPath.unfollowCompany + (companyId ?? "0"), method: .delete, type: "company")
                
                self.listing = self.listing.map({ (obj) -> FollowedComRecBaseModel in
                    //obj.meta?.paging?.total -= 1
                    obj.meta?.paging?.total = (obj.meta?.paging?.total)! - 1
                    return obj
                })
                
                
            } else {
                self.followUnfollowCompanyRecruiter(path: APIPath.unfollowRecruiter + (recruiterId ?? "0"), method: .delete, type: "recruiter")
                
                self.listing = self.listing.map({ (obj) -> FollowedComRecBaseModel in
                    //obj.meta?.paging?.total -= 1
                    obj.meta?.paging?.total = (obj.meta?.paging?.total)! - 1
                    return obj
                })
                
            }
            
        }
        row.isFollowed = !row.isFollowed
      }
        
    }
    
}

extension MITrackCompaniesVC:CompanyDetailsDelegate{
    func companyFollowUnFollow(compId: Int, isFollow: Bool) {
       self.setTitleAndCallAPI()
    }
}

//API
extension MITrackCompaniesVC {
    
    //get listing of companies and recruiters
    func trackCompaniesListingApi(path: String, param: JSONDICT) {
        //self.startActivityIndicator()
        
        if self.listing == nil { self.startActivityIndicator() } // MIActivityLoader.showLoader() }
        
       let _ = MIAPIClient.sharedClient.load(path: path, method: .get, params: param) { [weak self](response, error,code) in
       
        DispatchQueue.main.async { self?.stopActivityIndicator()
        
        
        self?.isPaginationRunning = false
      //  DispatchQueue.main.async {
            MIActivityLoader.hideLoader()

            if error != nil {
              //  DispatchQueue.main.async {
                    self?.tableViewTrackCompanies.tableFooterView?.isHidden=true
                     if code==401{
                      //  self?.logoutToLogin()
                     }else{
                        self?.showAlert(title: "", message: error?.errorDescription)
                    }
             //   }
                return
                
            } else {
                if let responseData = response as? JSONDICT {
                    
                    if self?.listing == nil{
                        self?.listing = FollowedComRecBaseModel(dictionary: responseData as NSDictionary)
                    }else{
                        let pagingData = FollowedComRecBaseModel(dictionary: responseData as NSDictionary)
                        
                        if let dataArray = pagingData?.data{
                            for item in dataArray{
                                self?.listing?.data?.append(item)
                            }
                        }
                        self?.listing?.meta = pagingData?.meta
                    }
    
                    if let value = self?.listing?.meta?.paging?.total {
                        if self?.open == .fromCompany{
                            self?.lblCountFollowCompnay.text = "\(value) Companies"
                        } else {
                            self?.lblCountFollowCompnay.text = "\(value) Recruiters"
                        }
                    }
                    let _ = self?.listing?.data?.map({$0.recruiterDetails?.profileStatus == true})
                    self?.tableViewTrackCompanies.tableFooterView?.isHidden=true
                    self?.tableViewTrackCompanies.reloadData()
                }
             }
          }
       }
        
    }
    
 
    
    //follow and unfollow company and recruiter
    func followUnfollowCompanyRecruiter(path: String, method: RequestMethod, type: String) {
        
        let _ = MIAPIClient.sharedClient.load(path: path, method: method, params: [:]) { [weak self](response, error,code) in
          
            DispatchQueue.main.async {
                
                if error != nil {
                  //  DispatchQueue.main.async {
                        if code==401{
                          //  self?.logoutToLogin()
                        }else{
                            self?.showAlert(title: "", message: error?.errorDescription)
                        }
                      //  }
                    return
                } else {
                    if let responseData = response as? JSONDICT {
                        isNetwork=true
                        if let errorMessage = responseData["errorMessage"] as? String {
                            self?.toastView(messsage: errorMessage)
                        } else {
                            let successMessage = responseData["successMessage"] as? String ?? ""
                            self?.toastView(messsage: successMessage,isErrorOccured:false)
                            
                            if let value = self?.listing?.meta?.paging?.total {
                                if self?.open == .fromCompany{
                                    self?.lblCountFollowCompnay.text = "\(value) Companies"
                                } else {
                                    self?.lblCountFollowCompnay.text = "\(value) Recruiters"
                                }
                            }
                            
                        }
                        
                        self?.tableViewTrackCompanies.reloadData()
                    }
                }
                
            }
        }
        
     }
    
}
