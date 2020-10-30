//
//  MICreateJobAlertViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 19/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MICreateJobAlertViewController: MIBaseViewController {
    
    //MARK:Outlets And Variables

    @IBOutlet weak var listView: MICreateJobAlertTableView!
    @IBOutlet weak var createJobButton: UIButton!
    
    var jobAlertType:CreateJobAlertType = .create
    var modelData:JobAlertModel?
    var delegate:CreateJobAlertDelegate?
    var alertCreatedSuccess:((Bool)->Void)?
    
    //MARK:Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        
    }
    func setUpUI(){
        self.createJobButton.showPrimaryBtn()
        if modelData == nil{
            modelData=JobAlertModel()

            if AppDelegate.instance.site?.defaultCountryDetails.isoCode.oneOf("SA", "SG") ?? false {
                modelData?.frequency="Weekly"
                modelData?.frequencyId="500730bf-fc6f-11e8-92d8-000c290b6677"
            } else {
                modelData?.frequency="Daily"
                modelData?.frequencyId="3651c8e0-fc6f-11e8-92d8-000c290b6677"
            }
        }
        modelData?.email = AppDelegate.instance.userInfo.primaryEmail
        if modelData?.email == nil {
            modelData?.email = ""
        }
       // self.createJobButton.backgroundColor=Color.colorDefault
      //  self.createJobButton.setTitleColor(.white, for: .normal)
        self.view.backgroundColor=AppTheme.viewBackgroundColor
        self.listView.jobAlertType = self.jobAlertType
        self.listView.modelData=modelData
        self.listView.delegate=self
        self.listView.tableView.backgroundColor = AppTheme.viewBackgroundColor
        //MICreateAlertTextViewCell
        switch self.jobAlertType {
        case .create,.fromSRP,.fromSRPReplace:
            self.createJobButton.setTitle(self.jobAlertType.value, for: .normal)
        case .edit:
            let deleteBarButton=UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(MICreateJobAlertViewController.deleteButtonAction(_:)))
            self.navigationItem.rightBarButtonItem = deleteBarButton
            self.createJobButton.setTitle(self.jobAlertType.value, for: .normal)
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch self.jobAlertType {
        case .edit:
            self.title=ControllerTitleConstant.editJobAlert
        case .create:
            self.title=ControllerTitleConstant.createJobAlert
        case .fromSRP:
            self.title=ControllerTitleConstant.createJobAlert
        case .fromSRPReplace:
            self.title="Replace Job Alert"
        }
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

    }
    
    //MARK:Delete Button Navigation Action
    @objc func deleteButtonAction(_ sender:UIBarButtonItem) {
        
        self.showPopUpView(message: ExtraResponse.deleteAlert, primaryBtnTitle: "Yes", secondaryBtnTitle: "No") { (isPrimarBtnClicked) in
                       if isPrimarBtnClicked {
                           self.startActivityIndicator()
                           let _ = MIAPIClient.sharedClient.load(path: APIPath.deleteJobAlert+self.modelData!.id!, method: .delete, params: [:]) { (response, erro,code) in
                               DispatchQueue.main.async {
                                   self.stopActivityIndicator()

                               if erro != nil{
                                  // DispatchQueue.main.async {
                                       if code==401{
                                         //  self.logoutToLogin()
                                       }
                                   //}
                                   return
                               }else{
                                 //  DispatchQueue.main.async {
                                      // self.stopActivityIndicator()
                                       self.navigationController?.popViewController(animated: true)
                                       self.delegate?.jobAlertEditedAndCreated()
                                  // }
                               }
                           }
                           }
                       }
                   }
        
        
        
//        let vPopup = MIJobPreferencePopup.popup()
//        vPopup.setViewWithTitle(title: "", viewDescriptionText:  ExtraResponse.deleteAlert, or: "", primaryBtnTitle: "Yes", secondaryBtnTitle: "No")
//        vPopup.completionHandeler = {
//            self.startActivityIndicator()
//            let _ = MIAPIClient.sharedClient.load(path: APIPath.deleteJobAlert+self.modelData!.id!, method: .delete, params: [:]) { (response, erro,code) in
//                DispatchQueue.main.async {
//                    self.stopActivityIndicator()
//
//                if erro != nil{
//                   // DispatchQueue.main.async {
//                        if code==401{
//                          //  self.logoutToLogin()
//                        }
//                    //}
//                    return
//                }else{
//                  //  DispatchQueue.main.async {
//                       // self.stopActivityIndicator()
//                        self.navigationController?.popViewController(animated: true)
//                        self.delegate?.jobAlertEditedAndCreated()
//                   // }
//                }
//            }
//            }
//        }
//        vPopup.cancelHandeler = {
//
//        }
//        vPopup.addMe(onView: self.view, onCompletion: nil)
//
////
//
//
//        let alertController=UIAlertController(title:nil, message: "Are you sure want to delete?", preferredStyle: .alert)
//        let okAction=UIAlertAction(title: "YES", style: .destructive) { (action) in
//            self.startActivityIndicator()
//            let _ = MIAPIClient.sharedClient.load(path: APIPath.deleteJobAlert+self.modelData!.id!, method: .delete, params: [:]) { (response, erro,code) in
//                DispatchQueue.main.async {
//                    self.stopActivityIndicator()
//
//                if erro != nil{
//                   // DispatchQueue.main.async {
//                        if code==401{
//                          //  self.logoutToLogin()
//                        }
//                    //}
//                    return
//                }else{
//                  //  DispatchQueue.main.async {
//                       // self.stopActivityIndicator()
//                        self.navigationController?.popViewController(animated: true)
//                        self.delegate?.jobAlertEditedAndCreated()
//                   // }
//                }
//            }
//            }
//        }
//        alertController.addAction(okAction)
//        alertController.addAction(UIAlertAction(title: "NO", style: .default, handler:nil))
//        self.present(alertController, animated: true, completion: nil)
        
    }
    
    //MARK:Create And Save Button Action
    @IBAction func createOrSaveChangesAction(_ sender: UIButton) {
        self.view.endEditing(true)
        //var name=""
        if self.modelData?.keywords == nil || self.modelData?.keywords?.count == 0{
            if let index=self.listView.textFieldTitleHolderArray.firstIndex(of: StoryboardConstant.keywords){
                
                let indexPath = IndexPath(row: index, section: 0)
                self.listView.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
//                guard let cell=self.listView.tableView.cellForRow(at: indexPath) as? MITextViewTableViewCell else{
//                    return
//                }
                self.listView.errorData = (indexPath.row,"Keywords can not be blank.")
              //  cell.showError(with:"Keywords can not be blank." )
            }
        }else if self.modelData?.alertName?.count == 0 || self.modelData?.alertName==nil{
            if let index=self.listView.textFieldTitleHolderArray.firstIndex(of: StoryboardConstant.alertName){
                let indexPath = IndexPath(row: index, section: 0)
                
                self.listView.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
//                guard let cell=self.listView.tableView.cellForRow(at: indexPath) as? MITextFieldTableViewCell else{
//                    return
//                }
                self.listView.errorData = (indexPath.row,"Name of Alert can not be blank.")

               // cell.showError(with:"Name of Alert can not be blank." )
            }
        }else if self.modelData?.email?.count == 0{
            if let index=self.listView.textFieldTitleHolderArray.firstIndex(of: StoryboardConstant.emailId){
                
                let indexPath = IndexPath(row: index, section: 0)
                self.listView.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
//                guard let cell=self.listView.tableView.cellForRow(at: indexPath) as? MITextFieldTableViewCell else{
//                    return
//                }
                self.listView.errorData = (indexPath.row,"Email ID can not be blank.")

//                cell.showError(with:"Email ID can not be blank." )
            }
        }else if let email=self.modelData?.email , !email.isValidEmail{
            if let index=self.listView.textFieldTitleHolderArray.firstIndex(of: StoryboardConstant.emailId){
                self.listView.tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .top, animated: false)
//                guard let cell=self.listView.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? MITextFieldTableViewCell else{
//                    return
//                }
                self.listView.errorData = (index,"Enter valid Email ID")

                //cell.showError(with:"Enter valid Email ID" )
            }
        }
        else{
            if let index=self.listView.textFieldTitleHolderArray.firstIndex(of: StoryboardConstant.frequency){
                self.listView.tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .top, animated: false)
                guard let cell=self.listView.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? MIFrequencyTableViewCell else{
                    return
                }
                self.modelData?.frequency=cell.viewModel.title
                self.modelData?.frequencyId=cell.viewModel.id
            }
            self.createJobAlert(param: self.modelData?.getDictionaryJson() ?? [:])
        }
        
    }
    
    func createJobAlert(param:[String:Any]){
        
        self.startActivityIndicator()
        
        let _ = MIAPIClient.sharedClient.load(path: APIPath.getJobAlert, method:self.jobAlertType == .create || self.jobAlertType == .fromSRP ? .post : .put, params: param) { (response, error,code) in
           DispatchQueue.main.async {
            self.stopActivityIndicator()

            if error != nil{
               // DispatchQueue.main.async {
                    if code==401{
                        //self.logoutToLogin()
                    }else{
                        self.showAlert(title: "", message: error!.errorDescription)
                    }
               // }
                return
            } else {
               // DispatchQueue.main.async {

                   // self.stopActivityIndicator()
                    if self.jobAlertType == .fromSRP ||  self.jobAlertType == .fromSRPReplace {
                        self.navigationController?.popViewController(animated: false)
                        if let action=self.alertCreatedSuccess{
                            action(true)
                        }
                        
                    }
                        //                    else if self.jobAlertType == .fromSRPReplace{
                        //
                        //                       self.navigationController?.popViewController(animated: false)
                        //                    }
                    else{
                        self.delegate?.jobAlertEditedAndCreated()
                        // if self.jobAlertType == .create{
                        let successVc=MICreateJobAlertSuccessViewController()
                        successVc.jobAlertType = self.jobAlertType
                        successVc.modelData = self.modelData
                        self.navigationController?.pushViewController(successVc, animated: true)
                        //}else{
                        // self.navigationController?.popViewController(animated: true)
                        // }
                    }
               // }
            }
            }
        }
        
    }
    
    func navigateToListView(title:String?) {
     
        switch title {
        case StoryboardConstant.salary,StoryboardConstant.experience:
            let staticMasterVC = MIStaticMasterDataViewController.newInstance
            if title == StoryboardConstant.salary{
                staticMasterVC.staticMasterType = .SALARYINLAKH
                if let data = self.modelData?.salary {
                    staticMasterVC.selectedDataArray = [data]
                }
            }else if title == StoryboardConstant.experience{
                staticMasterVC.staticMasterType = .EXPEREINCEINYEAR
                if let data = self.modelData?.experience {
                    staticMasterVC.selectedDataArray = [data]
                }
            }
            //            else{
            //                staticMasterVC.staticMasterType = .FREQUENCY
            //                if let data = self.modelData?.frequency {
            //                    staticMasterVC.selectedDataArray = [data]
            //                }
            //            }
            staticMasterVC.title = title
            staticMasterVC.delagate = self
            self.navigationController?.pushViewController(staticMasterVC, animated: true)
        default:
            let vc = MIMasterDataSelectionViewController.newInstance
            vc.delegate = self
            vc.title=title
            switch title{
            case StoryboardConstant.frequency:
                if let data = self.modelData?.frequency {
                    vc.selectedInfoArray = [data]
                }
                vc.masterType = MasterDataType(rawValue:MasterDataTitle.frequency.funName)!
                vc.limitSelectionCount = 1
            case MasterDataTitle.keywords.rawValue:
                let tuples = self.getSelectedMasterDataFor(dataSource:self.modelData?.masterData[MasterDataTitle.keywords.rawValue] ?? [])
                vc.selectedInfoArray = tuples.masterDataNames
                vc.selectDataArray = tuples.masterDataObject
                vc.limitSelectionCount=30
                //vc.selectedInfoArray=self.modelData?.keywords?.components(separatedBy: ",") ?? []
                vc.masterType = MasterDataType(rawValue: MasterDataTitle.keywords.funName)!
            case MasterDataTitle.funcionalArea.rawValue:
                let tuples = self.getSelectedMasterDataFor(dataSource:self.modelData?.masterData[MasterDataTitle.funcionalArea.rawValue] ?? [])
                vc.selectedInfoArray = tuples.masterDataNames
                vc.selectDataArray = tuples.masterDataObject
                vc.limitSelectionCount = 2
                //vc.selectedInfoArray=self.modelData?.functionalArea?.components(separatedBy: ",") ?? []
                vc.masterType = MasterDataType(rawValue: MasterDataTitle.funcionalArea.funName)!
            case MasterDataTitle.industry.rawValue:
                let tuples = self.getSelectedMasterDataFor(dataSource:self.modelData?.masterData[MasterDataTitle.industry.rawValue] ?? [])
                vc.selectedInfoArray = tuples.masterDataNames
                vc.selectDataArray = tuples.masterDataObject
                vc.limitSelectionCount = 2
                // vc.selectedInfoArray=self.modelData?.industry?.components(separatedBy: ",") ?? []
                vc.masterType = MasterDataType(rawValue: MasterDataTitle.industry.funName)!
            case MasterDataTitle.desiredLocation.rawValue:
                let tuples = self.getSelectedMasterDataFor(dataSource:self.modelData?.masterData[MasterDataTitle.desiredLocation.rawValue] ?? [])
                vc.selectedInfoArray = tuples.masterDataNames
                vc.selectDataArray = tuples.masterDataObject
                vc.limitSelectionCount = 1
                //vc.selectedInfoArray=self.modelData?.desiredLocation?.components(separatedBy: ",") ?? []
                vc.masterType = MasterDataType(rawValue: MasterDataTitle.desiredLocation.funName)!
            case MasterDataTitle.role.rawValue:
                
                let funcTuples = self.getSelectedMasterDataFor(dataSource:self.modelData?.masterData[MasterDataTitle.funcionalArea.rawValue] ?? [])
                if funcTuples.masterDataObject.count > 0 {
                    let tuples = self.getSelectedMasterDataFor(dataSource:self.modelData?.masterData[MasterDataTitle.role.rawValue] ?? [])
                    
                    vc.selectedInfoArray = tuples.masterDataNames
                    vc.selectDataArray = tuples.masterDataObject
                    vc.limitSelectionCount = 2
                    //vc.selectedInfoArray=self.modelData?.role?.components(separatedBy: ",") ?? []
                    vc.masterType = MasterDataType(rawValue: MasterDataTitle.role.funName)!
                    vc.parentId = MICategorySelectionInfo.getParentUUIDs(modalDataSource: funcTuples.masterDataObject)
                }else{
                    if let index=self.listView.textFieldTitleHolderArray.firstIndex(of: StoryboardConstant.funcionalArea){
                        self.listView.tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .top, animated: false)
                        guard let cell=self.listView.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? MITextViewTableViewCell else{
                            return
                        }
                        cell.showError(with:"Please select function area first." )
                    }
                    // self.showAlert(title: "", message: "Please select function area first.")
                    return
                }
            default:
                break
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
   
    func getSelectedMasterDataFor(dataSource:[MICategorySelectionInfo]) -> (masterDataNames:[String],masterDataObject:[MICategorySelectionInfo]) {
        
        var selectedInfoArray = [String]()
        var selectDataArray = [MICategorySelectionInfo]()
        if (dataSource.count) > 0 {
            selectedInfoArray = (dataSource.map({ $0.name}))
            selectDataArray = dataSource
        }
        return (selectedInfoArray,selectDataArray)
        
    }
    func removeChildModel(parentModels:[MICategorySelectionInfo],childs:[MICategorySelectionInfo]) {
        if parentModels.count == 0 {
            self.modelData?.masterData[MasterDataTitle.role.rawValue] = [MICategorySelectionInfo]()
            self.modelData?.role = nil
            return
        }
        
        self.modelData?.masterData[MasterDataTitle.role.rawValue] = childs.filter({(mod:MICategorySelectionInfo) -> Bool in
            return  parentModels.contains(where: {mod.parentUuid.contains($0.uuid)})
        })
        
        
        let tuples = self.getSelectedMasterDataFor(dataSource:self.modelData?.masterData[MasterDataTitle.role.rawValue] ?? [])
        
        self.modelData?.role = tuples.masterDataNames.joined(separator: ",")
        self.listView.tableView.reloadData()
    }
    
}


extension MICreateJobAlertViewController:MIMasterDataSelectionViewControllerDelegate {
    func masterDataSelected(selectedCategoryInfo: [MICategorySelectionInfo], selectedListInfo: [String], enumName: String) {
        if selectedListInfo.filter({$0.count > 0}).count > 0 {
            self.listView.errorData = (-1,"")
        }
        switch enumName{
        case MasterDataTitle.keywords.funName:
            self.modelData?.keywords = selectedListInfo.joined(separator: ",")
            self.modelData?.masterData[MasterDataTitle.keywords.rawValue]=selectedCategoryInfo
        case MasterDataTitle.funcionalArea.funName:
            self.modelData?.functionalArea = selectedListInfo.joined(separator: ",")
            self.modelData?.masterData[MasterDataTitle.funcionalArea.rawValue]=selectedCategoryInfo
            self.removeChildModel(parentModels: selectedCategoryInfo, childs: self.modelData?.masterData[MasterDataTitle.role.rawValue] ?? [MICategorySelectionInfo]())
            
        case MasterDataTitle.industry.funName:
            self.modelData?.industry = selectedListInfo.joined(separator: ",")
            self.modelData?.masterData[MasterDataTitle.industry.rawValue]=selectedCategoryInfo
        case MasterDataTitle.desiredLocation.funName:
            self.modelData?.desiredLocation = selectedListInfo.joined(separator: ",")
            self.modelData?.masterData[MasterDataTitle.desiredLocation.rawValue]=selectedCategoryInfo
        case MasterDataTitle.role.funName:
            self.modelData?.role = selectedListInfo.joined(separator: ",")
            self.modelData?.masterData[MasterDataTitle.role.rawValue]=selectedCategoryInfo
        case MasterDataTitle.frequency.funName:
            self.modelData?.frequency = selectedListInfo.joined(separator: ",")
            if selectedCategoryInfo.count > 0{
                self.modelData?.frequencyId = selectedCategoryInfo[0].uuid
            }
        default:
            break
        }
        self.listView.tableView.reloadData()
    }
}

extension MICreateJobAlertViewController:MIStaticMasterDataSelectionDelegate{
    func staticMasterDataSelected(selectedData:[String],masterType:String){
        if selectedData.count > 0 {
            self.listView.errorData = (-1,"")
        }
        if masterType == StaticMasterData.SALARYINLAKH.rawValue{
            self.modelData?.salary = selectedData.joined(separator: ",")
        }else if masterType == StaticMasterData.EXPEREINCEINYEAR.rawValue{
            self.modelData?.experience = selectedData.joined(separator: ",")
            
        }
        //        else{
        //            self.modelData?.frequency = selectedData.joined(separator: ",")
        //        }
        self.listView.tableView.reloadData()
    }
}


extension MICreateJobAlertViewController:CreateJobAlertListDelegate{
    func navigateToMaster(title: String?) {
        self.navigateToListView(title: title)
    }
}
