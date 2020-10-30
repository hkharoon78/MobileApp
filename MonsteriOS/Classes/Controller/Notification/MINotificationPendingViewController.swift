//
//  MINotificationPendingViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 11/07/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
class MINotificationPendingViewController: MIBaseViewController {
    let tableView=UITableView()
    var viewModel=[NotificationViewModel]()
    var allViewModel=[NotificationViewModel]()
    var prevPendingAction=[NotificationViewModel]()
    var delegate:PendingActionCompletedDelegate?
    override func loadView() {
        super.loadView()
        self.view.addSubview(tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints=false
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: self.view.topAnchor),tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName: String(describing: MINoticationPendingActionCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MINoticationPendingActionCell.self))
        tableView.delegate=self
        tableView.dataSource=self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.bounces = true
        tableView.showsVerticalScrollIndicator = false
        self.getAllPendingAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = ControllerTitleConstant.notificationPending
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)
    }
    
    func getAllPendingAction(){
        MIApiManager.getProfileAPI { [weak self] (status, response, error, code) in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                guard let data = response as? JSONDICT else {
                    return
                }
                if
                    let pendingActionsSec = data["pendingActionSection"] as? [String:Any],
                    let pendingActionsDic = pendingActionsSec["pendingActions"] as? [[String:Any]] {
                    var pendngAction=pendingActionsDic.map{PendingAction(dict: $0 as NSDictionary)}.filter({$0.weightage != 0})
                    for item in self.prevPendingAction{
                        if let idx=self.find(array: pendngAction, search: item){
                            pendngAction.remove(at: idx)
                        }
                    }
                    for item in pendngAction{
                        self.allViewModel.append(NotificationViewModel(model: Notifications(model: item)))
                       self.viewModel=self.allViewModel.unique(map: {$0.pendingActionType.title})
                       // self.viewModel.append(NotificationViewModel(model: Notifications(model: item)))
                    }
                  
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func find(array:[PendingAction],search:NotificationViewModel)->Int?{
        for (index,item) in array.enumerated(){
            if item.pendingActionType==search.pendingActionType{
                return index
            }
        }
        return nil
    }
    
}
extension MINotificationPendingViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model=self.viewModel[indexPath.row]
    
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MINoticationPendingActionCell.self), for: indexPath)as?MINoticationPendingActionCell else{
                return UITableViewCell()
            }
            cell.viewModel = model
            cell.delegate=self
            return cell
        
    }
   
    
}

extension MINotificationPendingViewController:PendingActionCompletedDelegate{
    func pendingActionSuccess() {
        delegate?.pendingActionSuccess()
    }
}

struct PendingAction{
    var name:String?
    var weightage:Int
    var pendingActionType:PendingActionType
    init(dict:NSDictionary) {
        name=dict["name"] as? String ?? ""
        weightage=dict["weightage"] as? Int ?? 0
        pendingActionType = name.map { PendingActionType(rawValue: $0) ?? .NONE } ?? .NONE
    }
}
