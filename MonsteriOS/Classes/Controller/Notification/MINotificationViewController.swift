//
//  MINotificationViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 10/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MINotificationViewController: MIBaseViewController {
    let tableView=UITableView()
    var viewModel=[NotificationViewModel]()
    override func loadView() {
        super.loadView()
        self.view.addSubview(tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints=false
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: self.view.topAnchor),tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName: String(describing: MINotificationTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MINotificationTableViewCell.self))
        self.tableView.register(UINib(nibName: String(describing: MINoticationPendingActionCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MINoticationPendingActionCell.self))
        //MINoticationPendingActionCell
        tableView.delegate=self
        tableView.dataSource=self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.bounces = true
        tableView.showsVerticalScrollIndicator = false
        
        if let path = Bundle.main.path(forResource: "parser", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            
                if let jsonResult = jsonResult as? NSDictionary{
                    if let jsonModelData=NotificationBaseModel(dictionary: jsonResult){
                        for item in jsonModelData.subSection ?? []{
                            if item.notifications == nil{
                                self.viewModel.append(NotificationViewModel(model: Notifications(model: item)))
                            }else{
                                for notif in item.notifications ?? []{
                                    self.viewModel.append(NotificationViewModel(model: notif))
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            } catch {
                // handle error
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = ControllerTitleConstant.notification
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

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
extension MINotificationViewController:UITableViewDelegate,UITableViewDataSource{
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model=self.viewModel[indexPath.row]
        if model.pendingActionType == .JOB_ALERTS || model.pendingActionType == .RECOMMENDED_JOBS || model.pendingActionType == .SIMILAR_JOBS || model.pendingActionType == .OTHER{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MINotificationTableViewCell.self), for: indexPath)as?MINotificationTableViewCell else{
                return UITableViewCell()
            }
        cell.viewModel=model
        return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MINoticationPendingActionCell.self), for: indexPath)as?MINoticationPendingActionCell else{
                return UITableViewCell()
            }
            cell.viewModel = model
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var model=self.viewModel[indexPath.row]
        switch model.pendingActionType {
        case .RECOMMENDED_JOBS:
            model.actionTaken=true
            self.viewModel[indexPath.row]=model
            let vc=MIViewAllJobsViewController()
            vc.controllerType = .recomended
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .SIMILAR_JOBS:
            model.actionTaken=true
            self.viewModel[indexPath.row]=model
            let vc=MIViewAllJobsViewController()
            vc.controllerType = .similarJobs
            vc.param["jobId"] = model.similarJobId
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .JOB_ALERTS :
            model.actionTaken=true
            self.viewModel[indexPath.row]=model
            let vc=MIViewAllJobsViewController()
            vc.controllerType = .jobAlertApi
            vc.jobAlertitle = model.title
            vc.param["query"] = model.jobSearchRequest?.query ?? model.jobSearchRequest?.keywords?.joined(separator: ",")
            vc.param[SRPListingDictKey.locations.rawValue]=model.jobSearchRequest?.locations
            vc.param[SRPListingDictKey.roles.rawValue]=model.jobSearchRequest?.roles
            vc.param[SRPListingDictKey.industries.rawValue]=model.jobSearchRequest?.industries
            vc.param[SRPListingDictKey.functions.rawValue]=model.jobSearchRequest?.functions
            vc.param[SRPListingDictKey.salary.rawValue]=model.jobSearchRequest?.salaryRanges
            vc.param[SRPListingDictKey.experienceRanges.rawValue]=model.jobSearchRequest?.experienceRanges
            self.navigationController?.pushViewController(vc, animated: true)
        case .OTHER:
            let vc=MINotificationPendingViewController()
            vc.prevPendingAction=self.viewModel.filter({$0.pendingActionType != .JOB_ALERTS || $0.pendingActionType != .RECOMMENDED_JOBS || $0.pendingActionType != .SIMILAR_JOBS || $0.pendingActionType != .OTHER})
            model.actionTaken=true
            vc.delegate=self
            self.viewModel[indexPath.row]=model
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        self.tableView.reloadData()

    }
   
}

extension MINotificationViewController:PendingActionCompletedDelegate{
    func pendingActionSuccess() {
       
    }
}

