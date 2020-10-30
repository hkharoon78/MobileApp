//
//  MIProfileViewedContractedConsideredVC.swift
//  MonsteriOS
//
//  Created by Anushka on 24/06/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

enum OpenProfile {
   
    case fromProfileViewed
    case fromContracted
    case fromConsidered
   
    var title:String {
        switch self {
        case .fromProfileViewed:
            return "Profile Viewed"
        case .fromConsidered:
            return "Considered"
        case .fromContracted:
            return "Contacted"
        }
    }
    
    var recruiterActionTitle: String {
       
        switch self {
        case .fromProfileViewed:
            return "Recruiters view your profile"
        case .fromConsidered:
            return "Recruiters considered your profile"
        case .fromContracted:
            return "Recruiters contacted you"

        }
    }
    
    var path: String {
       
        switch self {
        case .fromProfileViewed:
            return APIPath.recruiterActionProfileViewed
        case .fromConsidered:
            return APIPath.recruiterActionConsidered
        case .fromContracted:
            return APIPath.recruiterActionContracted
        }
    }
    var jsonpath: String {
        
        switch self {
        case .fromProfileViewed:
            return "Viewed"
        case .fromConsidered:
            return "Considered"
        case .fromContracted:
            return "Contacted"
        }
    }
}

class MIProfileViewedContractedConsideredVC: UIViewController {

    //MARK:- viewOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblCount: UILabel!
    
    var openVC: OpenProfile = .fromProfileViewed
    var lblCountData = ""
    var jsonRecruiterData = [RecuiterActionCellViewModel]()
    let spinner = UIActivityIndicatorView(style: .gray)

  
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()
    }
    
    func initialSetup() {
        self.recruiterActionAPI()
        
        self.lblCount.text = self.lblCountData + " " + self.openVC.recruiterActionTitle
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.tableFooterView=UIView(frame: .zero)
        self.spinner.tintColor = AppTheme.defaltTheme
        self.spinner.hidesWhenStopped=true
        self.spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.tableView.bounds.width, height: CGFloat(44))
        self.tableView.tableFooterView = spinner
        self.tableView.tableFooterView?.isHidden=true
        
        self.tableView.register(UINib(nibName: String(describing: MIProfileViewedContractedConsideredCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIProfileViewedContractedConsideredCell.self))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = self.openVC.title
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }



}


extension MIProfileViewedContractedConsideredVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonRecruiterData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MIProfileViewedContractedConsideredCell.self)) as? MIProfileViewedContractedConsideredCell else {
            return UITableViewCell()
        }
        
        cell.btnFollow.addTarget(self, action: #selector(btnFollowPressed(_:)), for: .touchUpInside)
        cell.btnFollow.tag=indexPath.row
        cell.controllerType = self.openVC
        cell.modelData = self.jsonRecruiterData[indexPath.row]
        
        return cell
    
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = self.jsonRecruiterData[indexPath.row]
       
        switch openVC {
        case .fromContracted:
           
            row.msgViewed = true
            self.tableView.reloadData()

            let vc = MIRecruiterMessageVC()
            vc.topViewModel = self.jsonRecruiterData[indexPath.row]
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            break
        }
    }
    
    @objc func btnFollowPressed(_ sender: UIButton) {
        //sender.isSelected = !sender.isSelected
        
        let model = self.jsonRecruiterData[sender.tag]
        if model.isFollowed{
            self.followAndUnfollowCmpanyOrRecuiter(path: APIPath.unfollowRecruiter + (model.recruiterID ?? "0"), method: .delete,index:sender.tag)
        }else{
            self.followAndUnfollowCmpanyOrRecuiter(path: APIPath.followRecruiter + (model.recruiterID ?? "0"), method: .post,index:sender.tag)
        }
        
    }
    
    func followAndUnfollowCmpanyOrRecuiter(path:String,method:RequestMethod,index:Int){
        let _ = MIAPIClient.sharedClient.load(path: path, method: method, params: [:]) { [weak self](responseData, error,code) in
           
            guard let `self` = self else{return}
            if error != nil {
                DispatchQueue.main.async {
                    if code==401{
                       // self.logoutToLogin()
                    }else{
                        self.showAlert(title: "", message: error?.errorDescription)
                    }
                }
                return
            }else{
                if let jsonData=responseData as? [String:Any]{
                    DispatchQueue.main.async {
                        self.showAlert(title: "", message:jsonData["successMessage"]as?String,isErrorOccured:false)
                        self.jsonRecruiterData[index].isFollowed = !self.jsonRecruiterData[index].isFollowed
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
}

extension MIProfileViewedContractedConsideredVC {
    
    func recruiterActionAPI() {
    
        if let path = Bundle.main.path(forResource: openVC.jsonpath, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                
                if let jsonResult1 = jsonResult as? NSDictionary{
                   
                    switch self.openVC{
                    case .fromConsidered:
                        let baseModel=RecruiterActionConsideredBase(dictionary: jsonResult1)
                        for item in baseModel?.data ?? []{
                            self.jsonRecruiterData.append(RecuiterActionCellViewModel(model: item))
                        }
                        break
                    case .fromContracted:
                        let baseModel=RecruiterActionContractedBase(dictionary: jsonResult1)
                        for item in baseModel?.data ?? []{
                            self.jsonRecruiterData.append(RecuiterActionCellViewModel(model: item))
                        }
                        break
                    case .fromProfileViewed:
                        let baseModel=RecruiterActionViewedBase(dictionary: jsonResult1)
                        for item in baseModel?.data ?? []{
                            self.jsonRecruiterData.append(RecuiterActionCellViewModel(model: item))
                        }
                    
                        break
                    }
                    self.tableView.reloadData()
                }
            } catch {
                // handle error
            }
        }
        
    }
    
    
}


