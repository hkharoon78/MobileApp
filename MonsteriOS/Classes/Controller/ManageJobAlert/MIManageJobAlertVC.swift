//
//  MIManageJobAlertVC.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 16/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

enum ManageAlertFlowVia {
    case ManageAlert
    case ViaReplace
}

extension UIViewController{
//    func logoutToLogin(){
//        
//    }
}

class MIManageJobAlertVC: MIBaseViewController {

    let tableView = UITableView()
    var jsonData:ManageJobAlertBaseModelMaster?
    var delegate:CreateJobAlertDelegate?
    var createAlertParam:[String:Any]?
    var createJobAlertModel:JobAlertModel?
    private var nojobPopup  = MINoJobFoundPopupView.popup()
    var manageJobAlertList  = [JobAlertModel]()
    var manageAlertVia : ManageAlertFlowVia = .ManageAlert
    var alertCreatedSuccess:((Bool)->Void)?
    var index:IndexPath?
  
    lazy var headerView: MICreateHeaderView = {
        let manageHeaderView = MICreateHeaderView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 85))
        manageHeaderView.backgroundColor=AppTheme.viewBackgroundColor
        return manageHeaderView
    }()
    
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints=false
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: self.view.topAnchor),tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)])
        self.tableView.backgroundColor = UIColor.init(hex: "F4F6F8")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.register(UINib(nibName:String(describing: MIJobAlertTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIJobAlertTableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.bounces=true
        //MIActivityLoader.showLoader()
        
        
        if self.manageAlertVia != .ViaReplace{
            self.startActivityIndicator()
            self.callJobAlertApi()
        }
        self.setUpUI()
        
        if let vcs=self.navigationController?.viewControllers{
            for (index,vc) in vcs.enumerated(){
                if let _ = vc as? MICreateJobAlertSuccessViewController{
                    self.navigationController?.viewControllers.remove(at: index)
                    break
                }
                
            }
        }

//        if manageAlertVia == .ViaReplace {
//            headerView.titleLabel.text=StoryboardConstant.manageMaxFiveAlert
//            headerView.imageIcon.image = UIImage(named: "base")
//            tableView.tableHeaderView=headerView
//            tableView.tableHeaderView?.backgroundColor=AppTheme.viewBackgroundColor
//        }else{
//            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createButtonAction))
//
//        }
    }
    
    func setUpUI(){
        if manageAlertVia == .ViaReplace {
            headerView.titleLabel.text=StoryboardConstant.manageMaxFiveAlert
            headerView.imageIcon.image = UIImage(named: "base")
            tableView.tableHeaderView=headerView
            tableView.tableHeaderView?.backgroundColor=AppTheme.viewBackgroundColor
            self.navigationItem.rightBarButtonItem = nil
            //self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action:#selector(cancelButtonAction) )
        }else{
            self.tableView.tableHeaderView = UIView(frame: .zero)
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createButtonAction))
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CommonClass.googleAnalyticsScreen(self) //GA for Screen
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

        self.title = ControllerTitleConstant.jobAlert
    }
    
    func callJobAlertApi(){
        
        self.nojobPopup.removeMe()
        
        let _ = MIAPIClient.sharedClient.load(path: APIPath.getJobAlert, method: .get, params: [:]) { [weak self] (dataResponse,error,code) in
            guard let `self`=self else {return}
            DispatchQueue.main.async {
                self.stopActivityIndicator()

            if error != nil {
               // DispatchQueue.main.async {
                    //self.createJobAlertView.onOfSwitch.isOn=false
                    
                    if error?.errorDescription == ServiceError.noInternetConnection.errorDescription{
                        self.nojobPopup.show(ttl: ErrorAndValidationMsg.opps.rawValue, desc:ErrorAndValidationMsg.somethingWrong.rawValue,imgNm: "plugbase")
                        self.nojobPopup.addFromTop(onView: self.view, topHeight:66, onCompletion: nil)
                        
                    }else if code==401{
                        //self.logoutToLogin()
                    }
                    else{
                        self.showAlert(title: "", message: error!.errorDescription)
                    }
                   // self.showAlert(title: "", message: error!.errorDescription)
               // }
                return
            }else{
                
                if let jsonData=dataResponse as? [String:Any]{
                    self.jsonData=ManageJobAlertBaseModelMaster(dictionary: jsonData as NSDictionary)
                        self.jsonData?.data?.sort(by: {Calendar.current.compare(Date(timeIntervalSince1970: Double($0.updatedAt ?? 0)), to: Date(timeIntervalSince1970: Double($1.updatedAt ?? 0)), toGranularity: .minute) == .orderedDescending})
                   // DispatchQueue.main.async {
                      //  self.stopActivityIndicator()
                        if self.jsonData?.data?.count == 0 || self.jsonData?.data == nil{
                        self.nojobPopup.show(ttl:ErrorAndValidationMsg.noJobAlert.rawValue, desc:ErrorAndValidationMsg.createJobAlert.rawValue,imgNm:"icon")
                        self.nojobPopup.addFromTop(onView: self.view, topHeight: 66, onCompletion: nil)
                        }

                        self.tableView.reloadData()
                    //}
                }
            }
        }
        }
    }
    
//    func createJobAlert(param:[String:Any]){
//        MIActivityLoader.showLoader()
//        let _ = MIAPIClient.sharedClient.load(path: MIAPIPath.getJobAlert.rawValue, method: .post, params: param) { (response, error) in
//            if error != nil{
//                DispatchQueue.main.async {
//                    MIActivityLoader.hideLoader()
//                }
//                return
//            }else{
//                DispatchQueue.main.async {
//                    MIActivityLoader.hideLoader()
//                    //self.navigationController?.popViewController(animated: false)
//                    var newNavigationController=[UIViewController]()
//                    //var count=0
//                    if let vcs=self.navigationController?.viewControllers{
//                        for vc in vcs{
//                            if let _ = vc as? MICreateJobAlertViewController{
//                                continue
//                            }else if let manageVc = vc as? MIManageJobAlertVC{
//                                if manageVc.manageAlertVia == .ViaReplace{
//                                    continue
//                                }else{
//                                    newNavigationController.append(vc)
//                                }
//                            }
//                            else{
//                                newNavigationController.append(vc)
//                            }
//                        }
//                    }
//                    newNavigationController.append(MICreateJobAlertSuccessViewController())
//                    self.navigationController?.viewControllers=newNavigationController
//                }
//            }
//        }
//    }
    
    func replaceJobAlert(alertId: String){
        self.nojobPopup.removeMe()
        self.startActivityIndicator()
        let _ = MIAPIClient.sharedClient.load(path: APIPath.deleteJobAlert+alertId, method: .delete, params: [:]) { (response, erro,code) in
            DispatchQueue.main.async {
                self.stopActivityIndicator()
            if erro != nil{
               // DispatchQueue.main.async {
                    self.showAlert(title: "", message: erro?.errorDescription)
               // }
                return
            }else{
               // DispatchQueue.main.async {
                    //self.stopActivityIndicator()
                    let filterJsonData=self.jsonData?.data?.filter({$0.id != alertId })
                    self.jsonData?.data = filterJsonData
                    if self.jsonData?.data?.count == 0{
                        self.nojobPopup.show(ttl:ErrorAndValidationMsg.noJobAlert.rawValue, desc:ErrorAndValidationMsg.createJobAlert.rawValue,imgNm:"icon")
                        self.nojobPopup.addFromTop(onView: self.view, topHeight: 66, onCompletion: nil)
                    }
                    self.manageAlertVia = .ManageAlert
                    self.setUpUI()
                    self.tableView.reloadData()
                    //self.navigateToCreateAlert()
               // }
            }
        }
        }
    }

    //MARK: - Helper Methods
 
    @objc func createButtonAction() {
        if self.jsonData?.data?.count ?? 0 >= 5{
            self.showAlert(title: "Alert!", message: StoryboardConstant.manageMaxFiveAlert)
           // self.manageAlertVia = .ViaReplace
           // self.setUpUI()
           // self.tableView.reloadData()
        
        }else{
            self.navigateToCreateAlert()
        }
    }
    
    @objc func cancelButtonAction() {
        self.manageAlertVia = .ManageAlert
        self.setUpUI()
        self.tableView.reloadData()
    }
    
    func navigateToCreateAlert(){
        CommonClass.googleEventTrcking("more_screen", action: "manage_job_alert", label: "add")//GA

        let vc = MICreateJobAlertViewController()
        vc.jobAlertType = .create
        //vc.editJobJsonData = self.jsonData
        vc.delegate=self
        //vc.previousJobAlertCount = self.jsonData?.data?.count ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension MIManageJobAlertVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonData?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MIJobAlertTableViewCell", for: indexPath) as! MIJobAlertTableViewCell
        
        cell.editButton.addTarget(self, action: #selector(editButtonAction(_:)), for: .touchUpInside)
        cell.editButton.tag=indexPath.row
        cell.editOrDeleteAction = {(index) in
            if index == 0 {
                self.navigateToViewAlertJob(index: indexPath.row)
                CommonClass.googleEventTrcking("more_screen", action: "manage_job_alert", label: "view_jobs")
            } else if index == 1 {
                CommonClass.googleEventTrcking("more_screen", action: "manage_job_alert", label: "edit")
                
                let vc = MICreateJobAlertViewController()
                vc.jobAlertType = .edit
                vc.modelData = JobAlertModel(model: self.jsonData!.data![indexPath.row])
                vc.delegate=self
                self.navigationController?.pushViewController(vc, animated: true)
            } else if index == 2 {
                self.index = indexPath
                
                CommonClass.googleEventTrcking("more_screen", action: "manage_job_alert", label: "delete")
                
                let vPopup = MIJobPreferencePopup.popup()
                vPopup.setViewWithTitle(title: "", viewDescriptionText: "Are you sure want to delete?", or: "", primaryBtnTitle: "Yes", secondaryBtnTitle: "No")
                vPopup.delegate = self
                vPopup.closeBtn.isHidden = true
                vPopup.addMe(onView: self.view, onCompletion: nil)
                
//                let alertController=UIAlertController(title:nil, message: "Are you sure want to delete?", preferredStyle: .alert)
//                let okAction=UIAlertAction(title: "YES", style: .destructive) { (action) in
//                    self.replaceJobAlert(alertId: self.jsonData!.data![indexPath.row].id!)
//                }
//                alertController.addAction(okAction)
//                alertController.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
//               self.present(alertController, animated: true, completion: nil)
                
           }
            
        }
        cell.showDataWithModel(obj:JobAlertModel(model: jsonData!.data![indexPath.row]))
        cell.showEditReplaceOption(flowVia: manageAlertVia)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      self.navigateToViewAlertJob(index:indexPath.row)
    }
    
    func navigateToViewAlertJob(index:Int){
        let vc=MIViewAllJobsViewController()
        let jobAlertData = JobAlertModel(model: jsonData!.data![index])

        var param=[String:Any]()
        param["query"]=jobAlertData.keywords
        param[FilterType.functions.rawValue.lowercased()] = jobAlertData.functionalArea?.count ?? 0 > 0 ?  jobAlertData.functionalArea?.components(separatedBy: ",") : nil
        param[FilterType.locations.rawValue.lowercased()] = jobAlertData.desiredLocation?.count ?? 0 > 0 ?  jobAlertData.desiredLocation?.components(separatedBy: ",") : nil
        if jobAlertData.experience != nil {
            param["experienceRanges"] = [(jobAlertData.experience!)  + "~" + (jobAlertData.experience!)]
        }
        param[FilterType.industries.rawValue.lowercased()] = jobAlertData.industry?.count ?? 0 > 0 ?  jobAlertData.industry?.components(separatedBy: ",") : nil
        if jobAlertData.salary != nil , let salaryInt=Int((jobAlertData.salary!)),salaryInt > 0{
            param["salaryRanges"]=[String(salaryInt*100000)+"~"+String(salaryInt*100000)]
        }
        vc.param=param
        vc.controllerType = .jobAlertApi
        vc.jobAlertitle = jobAlertData.alertName ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func editButtonAction(_ sender: UIButton) {
       if manageAlertVia == .ViaReplace {
        let vc = MICreateJobAlertViewController()
        vc.jobAlertType = .fromSRPReplace
        self.createJobAlertModel?.id=self.jsonData!.data![sender.tag].id
        vc.modelData=self.createJobAlertModel
        vc.alertCreatedSuccess={ (bool) in
            if let action=self.alertCreatedSuccess{
                action(true)
            }
            self.navigationController?.popViewController(animated: false)
        }
        self.navigationController?.pushViewController(vc, animated: true)
      
       }else{
        if let cell=self.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0))as?MIJobAlertTableViewCell{
            cell.dropDown.show()
        }
       }
      
    }
}

extension MIManageJobAlertVC:CreateJobAlertDelegate{
    func jobAlertEditedAndCreated() {
        //MIActivityLoader.showLoader()
        self.startActivityIndicator()
        self.callJobAlertApi()
    }
}

extension MIManageJobAlertVC: JobPreferencePopUpDelegate{
    func optionCompleteIgnoredSelected(popSelection: PopUpOptionSelection, popup: MIPopupView) {
        if popSelection == .Completed {
            self.replaceJobAlert(alertId: self.jsonData!.data![(self.index?.row)!].id!)
        }
    }
}
