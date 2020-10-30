//
//  MIEmployementForUserVC.swift
//  MonsteriOS
//
//  Created by Rakesh on 18/07/19.
//  Copyright © 2019 Monster. All rights reserved.
//  From: Signup

import UIKit

class SectionModel : NSObject, NSCopying {
    
    var sectionName = ""
    var sectionDataSource : Any?
    var sectionRowFieldTitle = [String]()
    var sectionNumber = 0
    var isSectionExpand = false
    
    init(name:String,dataSource:Any?,sectionFields:[String],number:Int) {
        sectionName = name
        sectionDataSource = dataSource
        sectionRowFieldTitle = sectionFields
        sectionNumber = number
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        
        var dataSourceCopy: Any?
        if let obj = self.sectionDataSource as? MIEmploymentDetailInfo {
            dataSourceCopy = obj.copy()
        }
        if let obj = self.sectionDataSource as? MIEducationInfo {
            dataSourceCopy = obj.copy()
        }
        let copy = SectionModel(name: sectionName, dataSource: dataSourceCopy, sectionFields: sectionRowFieldTitle, number: sectionNumber)
        return copy
    }
}
//extension Collection where Iterator.Element == SectionModel {
//    // `Collection` can be `Sequence`, etc
//}

class MIEmployementForUserVC: MIBaseViewController {
    
    var fieldDataSource = [String]()
    var userEmploymentsDataSource = [SectionModel]()
    var tblFooter = MIDoubleButtonView.doubleBtnView
    var selectedIndexPath : IndexPath?
    var isFreshOrExper:ProfessionalDetailsEnum = .Fresher
    let popup = MIJobPreferencePopup.popup()
    var itemSectionIndexForDelete = -1
    var progView = MIProgressView.header
    
    @IBOutlet weak var tblView : UITableView!
    @IBOutlet weak var progressView : UIView!
    
    private var errorData : (index:Int, primaryError:String, secondryError: String) = (-1,"","") {
        didSet {
            guard errorData.index >= 0 else { return }
            self.tblView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initilizeDataOnLoad()
        
       
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = MIEmploymentDetailViewControllerConstant.title
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)
        let eventData = [
                   "eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.LANDING,
                   ] as [String : Any]
               MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.REGISTER_EMPLOYMENT, data: eventData, destination: CONSTANT_SCREEN_NAME.REGISTER_EMPLOYMENT) { (success, response, error, code) in
               }
        if MIUserModel.userSharedInstance.isEmploymentUploaded {
            tblFooter.nxtBtnBgView_TopConstraint.constant = 0
        }
        if let employment = MIUserModel.userSharedInstance.userEmploymentDataList {
            if employment.count == self.userEmploymentsDataSource.count {
                for (index,value) in employment.enumerated() {
                    self.userEmploymentsDataSource[index].sectionDataSource = value
                }
            }
        }
        self.tblView.reloadData()
        
        if !self.progressView.subviews.contains(progView) {
            progView = MIProgressView.header
            progView.progressViewStatus(num: 3, completed: 0, current: 0 )
            progView.frame = CGRect(x: 0, y: 0, width: kScreenSize.width, height: 44)
            self.progressView.addSubview(progView)
        }
    }
    
    func initilizeDataOnLoad() {
        
        //Register Cell
        tblView.register(UINib(nibName:String(describing: MICompletedEduEmpTableCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MICompletedEduEmpTableCell.self))
        tblView.register(UINib(nibName:String(describing: MITextFieldTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MITextFieldTableViewCell.self))
        tblView.register(UINib(nibName: String(describing: MIEduEmpHeaderView.self), bundle: nil), forHeaderFooterViewReuseIdentifier: String(describing: MIEduEmpHeaderView.self))
        self.tblView.register(UINib(nibName:String(describing: MIEmploymentSalaryTableCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIEmploymentSalaryTableCell.self))
        self.tblView.register(UINib(nibName:String(describing: MIEmployementDateTableCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIEmployementDateTableCell.self))
        self.tblView.register(nib: MISeparateCheckTickCell.loadNib(), withCellClass: MISeparateCheckTickCell.self)
        
        //Set tableview Attribute property
        self.tblView.keyboardDismissMode = .onDrag
        self.tblView.estimatedRowHeight = tblView.rowHeight
        self.tblView.rowHeight = UITableView.automaticDimension
        self.tblView.sectionHeaderHeight = tblView.sectionHeaderHeight
        self.tblView.estimatedSectionHeaderHeight = UITableView.automaticDimension
        self.tblView.sectionFooterHeight = tblView.sectionFooterHeight
        self.tblView.estimatedSectionFooterHeight = UITableView.automaticDimension
        
        //Setting Back Button
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(MIEmployementForUserVC.backBtnAction))
        
        
        let empModel = MIEmploymentDetailInfo(isCurrent: true)
        userEmploymentsDataSource.append(SectionModel(name: "Add Current Employment", dataSource: empModel, sectionFields: self.manageTitleForSectionRowModel(modal: empModel, sectionNumber: 0), number: 0))
        
        tblFooter.btn_next.showPrimaryBtn()
        tblFooter.btn_next.setImage(UIImage(named: "whiteRightArrow"), for: .normal)
        tblFooter.btn_next.setTitle("Next: Education Details", for: .normal)
        
        tblFooter.setTitleForAddAnother(title: "+ Add Previous Employment")
        self.tblView.tableFooterView = tblFooter
        
        tblFooter.addAnotherCallBack = {
            if let obj = self.userEmploymentsDataSource.last,
                self.validateEmployementData(sectionObj: obj, addPrevious: true) {
                
//                let eventData = [
//                    //"eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK_SUBMIT,
//                    "addPreviousEmployment" : CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK
//                    ] as [String : Any]
//
//                MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.REGISTER_EMPLOYMENT, data: eventData, destination: CONSTANT_SCREEN_NAME.REGISTER_EMPLOYMENT) { (success, response, error, code) in
//                }
                
                self.userEmploymentsDataSource.append(SectionModel(name: "Add Previous Employment", dataSource: MIEmploymentDetailInfo(), sectionFields: self.manageTitleForSectionRowModel(modal: MIEmploymentDetailInfo(), sectionNumber: self.userEmploymentsDataSource.count), number: self.userEmploymentsDataSource.count))
            }
            self.tblView.reloadData()
        }
        
        tblFooter.nextBtnCallBack = {
            CommonClass.googleEventTrcking("registration_screen", action: "next", label: "page_2_workexp")
            self.submitEmploymentData()
        }
        //Manage progress view
        
        if isFreshOrExper == .Experienced {
            if let vcs=self.navigationController?.viewControllers{
                for (index,vc) in vcs.enumerated(){
                    if let _ = vc as? MIOTPViewController{
                        self.navigationController?.viewControllers.remove(at: index)
                        break
                    }
                }
            }
        }
    }
    
    func submitEmploymentData() {
        //        let vc = MIEducationByUserVC()
        //        vc.isFreshOrExper = self.isFreshOrExper
        //        self.navigationController?.pushViewController(vc, animated: true)
        //        return
        
        if self.userEmploymentsDataSource.count == 1 {
            if !self.validateEmployementData(sectionObj: self.userEmploymentsDataSource[0]) { return }
        }
        
        self.view.endEditing(true)
        var isAllEmployementVerified = true
        for obj in self.userEmploymentsDataSource {
            if let emp = obj.sectionDataSource as? MIEmploymentDetailInfo,
                self.userEmploymentsDataSource.last == obj {
                
                if emp.companyObj.name.isEmpty && emp.designationObj.name.isEmpty {
                    self.userEmploymentsDataSource.last?.sectionDataSource = MIEmploymentDetailInfo()
                    self.tblView.reloadData()
                    if self.userEmploymentsDataSource.count == 1 { return }
                    continue
                }
            }
            if !self.validateEmployementData(sectionObj: obj) {
                isAllEmployementVerified = false
                
                let isLastSection = (self.userEmploymentsDataSource.last == obj)
                if !isLastSection {
                    self.navigateToEditEmploymentVC(at: obj.sectionNumber)
                }
                
                break
            }
        }
        if isAllEmployementVerified {
            if MIUserModel.userSharedInstance.isEmploymentUploaded {
                self.PushEducationViewController()
                
            }else{
                self.callAPIForSubmitUserEmployment()
            }
        }
    }
    
    //MARK: - Helper Methods
    func validateEmployementData(sectionObj : SectionModel, addPrevious: Bool = false) -> Bool {
        let arr = sectionObj.sectionRowFieldTitle
        
        guard let employment = sectionObj.sectionDataSource as? MIEmploymentDetailInfo else { return true }
        let isLastSection = (self.userEmploymentsDataSource.last == sectionObj)
        
        var validationMessage = [[String: Any]]()
        defer {
            var eventData = [
                "validationErrorMessages" : validationMessage
                ] as [String : Any]
            if addPrevious {
                eventData["addPreviousEmployment"] = CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK
            } else {
                eventData["eventValue"] = CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK
            }
           
            if addPrevious || (!(!addPrevious && validationMessage.isEmpty) || isLastSection) {
                MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.REGISTER_EMPLOYMENT, data: eventData, destination: CONSTANT_SCREEN_NAME.REGISTER_EMPLOYMENT) { (success, response, error, code) in
                }
            }
        }
        
        if employment.designationObj.name.isEmpty {
            if let index = arr.firstIndex(of: MIEmploymentDetailViewControllerConstant.jobDesignation), isLastSection {
                let indexPath = IndexPath(row: index, section: sectionObj.sectionNumber)
                
                let msg = (sectionObj.sectionNumber == 0) ? MIEmploymentDetailViewControllerConstant.emptyMostRecentDesignation : MIEmploymentDetailViewControllerConstant.emptyDesignation
                self.errorData = (indexPath.row, msg, "")
                let field = (sectionObj.sectionNumber == 0 ? "Current " : "") + MIEmploymentDetailViewControllerConstant.jobDesignation
                validationMessage.append(["field":field, "message" : msg])
                
                self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
            return false
        }
        if employment.companyObj.name.isEmpty {
            if let index = arr.firstIndex(of: MIEmploymentDetailViewControllerConstant.companyName), isLastSection {
                let indexPath = IndexPath(row: index, section: sectionObj.sectionNumber)
                
                let msg = (sectionObj.sectionNumber == 0) ? MIEmploymentDetailViewControllerConstant.emptyMostRecentCompanyName : MIEmploymentDetailViewControllerConstant.emptyCompanyName
                self.errorData = (indexPath.row, msg, "")
                let field = (sectionObj.sectionNumber == 0 ? "Current " : "") + MIEmploymentDetailViewControllerConstant.companyName
                validationMessage.append(["field":field, "message" : msg])
                
                self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
            return false
        }
        
        
        if let index = arr.firstIndex(of: MIEmploymentDetailViewControllerConstant.selectDate), isLastSection {
            let indexPath = IndexPath(row: index, section: sectionObj.sectionNumber)
            
            if employment.isCurrentEmplyement  {
                if (employment.experinceFrom == nil) {
                    self.errorData = (indexPath.row, MIEmploymentDetailViewControllerConstant.emptyStartDate, "")
                    
                    validationMessage.append(["field":"Start Date", "message" : MIEmploymentDetailViewControllerConstant.emptyStartDate])
                    
                    self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
                    return false
                }
                
                
            }else{
                if employment.experinceFrom == nil {
                    self.errorData = (indexPath.row, MIEmploymentDetailViewControllerConstant.emptyStartDate, "")
                    
                    validationMessage.append(["field":"Start Date", "message" : MIEmploymentDetailViewControllerConstant.emptyStartDate])
                    
                    self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
                    return false
                    
                }else if employment.experinceTill == nil {
                    self.errorData = (indexPath.row, "", MIEmploymentDetailViewControllerConstant.emptyEndDate)
                    
                    validationMessage.append(["field":"End Date", "message" : MIEmploymentDetailViewControllerConstant.emptyEndDate])
                    
                    self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
                    return false
                }
            }
        }
        
        if employment.isCurrentEmplyement {
            if (employment.salaryModal.salaryInLakh.isEmpty &&  employment.salaryModal.salaryThousand.isEmpty) {
                self.showAlert(title: "", message:MIEmploymentDetailViewControllerConstant.emptyCurrentSalary )
                
                validationMessage.append(["field":"Current Salary", "message" : MIEmploymentDetailViewControllerConstant.emptyCurrentSalary])
                
                return false
                
            }
        }
        
        if sectionObj.sectionNumber == 0 && employment.isCurrentEmplyement {
            
            if employment.noticePeroidDuration.isEmpty  {
                if let index = arr.firstIndex(of: MIEmploymentDetailViewControllerConstant.noticePeroid), isLastSection {
                    let indexPath = IndexPath(row: index, section: sectionObj.sectionNumber)
                    self.errorData = (indexPath.row, MIEmploymentDetailViewControllerConstant.emptyNoticePeroid, "")
                    
                    validationMessage.append(["field":MIEmploymentDetailViewControllerConstant.noticePeroid, "message" : MIEmploymentDetailViewControllerConstant.emptyNoticePeroid])
                    
                    self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
                }
                return false
                
            } else if employment.isServingNotice && (employment.lastWorkingDate == nil) {
                if let index = arr.firstIndex(of: MIEmploymentDetailViewControllerConstant.lastWorkingDay), isLastSection {
                    let indexPath = IndexPath(row: index, section: sectionObj.sectionNumber)
                    self.errorData = (indexPath.row, MIEmploymentDetailViewControllerConstant.emptyLastWorking, "")
                    
                    validationMessage.append(["field":MIEmploymentDetailViewControllerConstant.lastWorkingDay, "message" : MIEmploymentDetailViewControllerConstant.emptyLastWorking])
                    
                    self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
                }
                return false
            }
        }
        
        return true
    }
    
    func pushToMasterDataSelection(fieldName:String,selectionLimit:Int,model:MIEmploymentDetailInfo) {
        let vc = MIMasterDataSelectionViewController.newInstance
        vc.delegate = self
        vc.limitSelectionCount = selectionLimit
        if fieldName == MIEmploymentDetailViewControllerConstant.jobDesignation {
            vc.masterType = .DESIGNATION
            if !model.designationObj.name.isEmpty {
                vc.selectDataArray  = [model.designationObj]
                vc.selectedInfoArray = [model.designationObj.name]
            }
        }
        if fieldName == MIEmploymentDetailViewControllerConstant.companyName {
            vc.masterType = .COMPANY
            if !model.companyObj.name.isEmpty {
                vc.selectDataArray  = [model.companyObj]
                vc.selectedInfoArray = [model.companyObj.name]
            }
        }
        if fieldName == MIEmploymentDetailViewControllerConstant.offeredDesignation {
            vc.masterType = .DESIGNATION
            if !model.offeredDesignationObj.name.isEmpty {
                vc.selectDataArray  = [model.offeredDesignationObj]
                vc.selectedInfoArray = [model.offeredDesignationObj.name]
            }
        }
        if fieldName == MIEmploymentDetailViewControllerConstant.newCompanyName {
            vc.masterType = .COMPANY
            if !model.newCompanyObj.name.isEmpty {
                vc.selectDataArray  = [model.newCompanyObj]
                vc.selectedInfoArray = [model.newCompanyObj.name]
            }
        }
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func pushStaticMasterController(type:StaticMasterData,data:[String],title:String,sectionobj:SectionModel) {
        if let employmentModel = sectionobj.sectionDataSource as? MIEmploymentDetailInfo {
            let staticMasterVC = MIStaticMasterDataViewController.newInstance
            staticMasterVC.title = "Selection"
            staticMasterVC.staticMasterType = type
            staticMasterVC.selectedDataArray = data
            staticMasterVC.selectedData = { value in
                
                if title == MIEmploymentDetailViewControllerConstant.noticePeroid {
                    employmentModel.noticePeroidDuration = value
                    employmentModel.isServingNotice = false
                    if value == NoticePeroid.Serving_Notice_Peroid.rawValue {
                        employmentModel.isServingNotice = true
                    }
                    sectionobj.sectionRowFieldTitle = self.manageTitleForSectionRowModel(modal: employmentModel, sectionNumber: sectionobj.sectionNumber)
                    employmentModel.lastWorkingDate = nil
                }
                if title == MIEmploymentDetailViewControllerConstant.salary {
                    if type == .CURRENCY {
                        employmentModel.salaryModal.salaryInLakh = ""
                        employmentModel.salaryModal.salaryThousand = ""
                        employmentModel.salaryModal.absoluteValue = 0
                        employmentModel.salaryModal.salaryCurrency = value
                    }else if type == .SALARYINLAKH {
                        employmentModel.salaryModal.salaryInLakh = value
                    }else if type == .SALARYINTHOUSAND {
                        employmentModel.salaryModal.salaryThousand = value
                    }
                    
                }
                if title == MIEmploymentDetailViewControllerConstant.newOfferedSalary {
                    if type == .CURRENCY {
                        employmentModel.offeredSalaryModal.salaryInLakh = ""
                        employmentModel.offeredSalaryModal.salaryThousand = ""
                        employmentModel.offeredSalaryModal.absoluteValue = 0
                        employmentModel.offeredSalaryModal.salaryCurrency = value
                    }else if type == .SALARYINLAKH {
                        employmentModel.offeredSalaryModal.absoluteValue = 0
                        employmentModel.offeredSalaryModal.salaryInLakh = value
                    }else if type == .SALARYINTHOUSAND {
                        employmentModel.offeredSalaryModal.absoluteValue = 0
                        employmentModel.offeredSalaryModal.salaryThousand = value
                    }
                }
                self.tblView.reloadData()
            }
            self.navigationController?.pushViewController(staticMasterVC, animated: true)
        }
        
    }
    
    func manageTitleForSectionRowModel(modal:MIEmploymentDetailInfo,sectionNumber:Int) -> [String]{
        
        if sectionNumber == 0 {
            if modal.isServingNotice {
                self.filterTitleWithValue(values:[])
                
            }else if modal.isCurrentEmplyement {
                self.filterTitleWithValue(values: [MIEmploymentDetailViewControllerConstant.lastWorkingDay,
                                                   MIEmploymentDetailViewControllerConstant.newOfferedSalary,
                                                   MIEmploymentDetailViewControllerConstant.offeredDesignation,
                                                   MIEmploymentDetailViewControllerConstant.newCompanyName])
            }else{
                self.filterTitleWithValue(values: [MIEmploymentDetailViewControllerConstant.noticePeroid,
                                                   MIEmploymentDetailViewControllerConstant.lastWorkingDay,
                                                   MIEmploymentDetailViewControllerConstant.newOfferedSalary,
                                                   MIEmploymentDetailViewControllerConstant.offeredDesignation,
                                                   MIEmploymentDetailViewControllerConstant.newCompanyName])
            }
            
        }else{
            self.filterTitleWithValue(values: [//MIEmploymentDetailViewControllerConstant.currentyWorkinghere,
                MIEmploymentDetailViewControllerConstant.noticePeroid,
                MIEmploymentDetailViewControllerConstant.lastWorkingDay,
                MIEmploymentDetailViewControllerConstant.newOfferedSalary,
                MIEmploymentDetailViewControllerConstant.offeredDesignation,
                MIEmploymentDetailViewControllerConstant.newCompanyName])
            
        }
        return fieldDataSource
    }
    
    func filterTitleWithValue(values:[String]) {
        
        fieldDataSource = [MIEmploymentDetailViewControllerConstant.jobDesignation,
                           MIEmploymentDetailViewControllerConstant.companyName,
                           //MIEmploymentDetailViewControllerConstant.currentyWorkinghere,
            MIEmploymentDetailViewControllerConstant.selectDate,
            MIEmploymentDetailViewControllerConstant.salary,
            MIEmploymentDetailViewControllerConstant.noticePeroid,
            MIEmploymentDetailViewControllerConstant.lastWorkingDay,
            MIEmploymentDetailViewControllerConstant.newOfferedSalary,
            MIEmploymentDetailViewControllerConstant.offeredDesignation,
            MIEmploymentDetailViewControllerConstant.newCompanyName]
        
        for obj in values {
            if let index = fieldDataSource.firstIndex(of:obj) {
                fieldDataSource.remove(at: index)
            }
        }
    }
    
    func callAPIForSubmitUserEmployment() {
        var params = [String:Any]()
        let employmentParams = MIEmploymentDetailInfo.getParamsForUserEmploymentPayloadViaRegister(employmentSection: self.userEmploymentsDataSource)
        if employmentParams.isEmpty { return }
        params["employments"] = employmentParams
        
        
        if let primaryEmployment = self.userEmploymentsDataSource.first?.sectionDataSource as? MIEmploymentDetailInfo, primaryEmployment.isCurrentEmplyement {
            params[APIKeys.currentDesignationAPIKey] = MIUserModel.getParamForIdTextForUUIDNil(id: primaryEmployment.designationObj.uuid, value: primaryEmployment.designationObj.name)
            params[APIKeys.currentcompanyAPIKey] = MIUserModel.getParamForIdTextForUUIDNil(id: primaryEmployment.companyObj.uuid, value: primaryEmployment.companyObj.name)
            if !primaryEmployment.salaryModal.salaryCurrency.isEmpty {
                //            var salaryParam = [String:Any]()
                //                let lakhAmount = MIEmploymentDetailInfo.getSalaryAbsoluteValue(obj: primaryEmployment)
                //                salaryParam[APIKeys.currencyAPIKey] = primaryEmployment.currentSalaryCurrency
                //                salaryParam[APIKeys.absoluteValueAPIKey] = lakhAmount
                //                var salaryMode = [String:Any]()
                //                salaryMode["uuid"] = (primaryEmployment.currentSalaryModeSelectedAnnualy) ? kannuallyModeSalaryUUID : kmonthlyModeSalaryUUID
                //                salaryMode["text"] = (primaryEmployment.currentSalaryModeSelectedAnnualy) ? "Annually" : "Monthly"
                
                //          salaryParam["salaryMode"] =
                params[APIKeys.currentSalaryAPIKey] = SalaryDetail.getSalaryParam(salary: primaryEmployment.salaryModal, withConfidential: false)
            }
        }
        MIActivityLoader.showLoader()
        
        MIApiManager.callAPIForEmploymentEducationSkillDetail(method:.post,apiPath: APIPath.employmentDetailVer_2_ApiEndpoint, params: params) { (success, response, error, code) in
            DispatchQueue.main.async {
                //self.stopActivityIndicator()
                MIActivityLoader.hideLoader()
                
                if error == nil && (code >= 200) && (code <= 299) {
                    
                    
                    if let result = response as? [String:Any],let employmentDetailSection = result["employmentDetailSection"] as? [String:Any],let dataList = employmentDetailSection["employments"] as? [[String:Any]] , dataList.count > 0 {
                        
                        self.userEmploymentsDataSource = self.userEmploymentsDataSource
                            .filter({ ($0.sectionDataSource as? MIEmploymentDetailInfo)?.designationObj.name.isEmpty == false })
                        
                        if dataList.count == self.userEmploymentsDataSource.count {
                            var employmentTempData = [MIEmploymentDetailInfo]()
                            MIUserModel.userSharedInstance.isEmploymentUploaded = true
                            for (index,modal) in self.userEmploymentsDataSource.enumerated() {
                                if let emyObj = modal.sectionDataSource as? MIEmploymentDetailInfo {
                                    emyObj.employmentId = dataList[index].stringFor(key: "id")
                                    employmentTempData.append(emyObj)
                                }
                            }
                            
                            MIUserModel.userSharedInstance.userEmploymentDataList = employmentTempData
                        }
                    }
                    self.PushEducationViewController()
                    
                }else{
                    //   self.stopActivityIndicator()
                    self.handleAPIError(errorParams: response, error: error)
                }
            }
            
        }
    }
    
    func PushEducationViewController() {
        if let instance = RegisterFlowInstances.instance.controllers
            .filter({ $0 is MIEducationByUserVC }).first {
            self.navigationController?.pushViewController(instance, animated: true)
        } else {
            let vc = MIEducationByUserVC()
            vc.isFreshOrExper = self.isFreshOrExper
            self.navigationController?.pushViewController(vc, animated: true)
            
            RegisterFlowInstances.instance.controllers.append(vc)
        }
    }
    
    @objc private func backBtnAction() {
        CommonClass.googleEventTrcking("registration_screen", action: "back", label: "page_2_workexp")
        self.navigationController?.popViewController(animated: false)
    }
}

extension MIEmployementForUserVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return userEmploymentsDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var isLastSection = (section == self.userEmploymentsDataSource.count - 1)
        if MIUserModel.userSharedInstance.isEmploymentUploaded { isLastSection = false }
        
        return isLastSection ? self.userEmploymentsDataSource[section].sectionRowFieldTitle.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var isLastSection = (indexPath.section == self.userEmploymentsDataSource.count - 1)
        if MIUserModel.userSharedInstance.isEmploymentUploaded { isLastSection = false }
        
        let sectionModel = self.userEmploymentsDataSource[indexPath.section]
        let title = sectionModel.sectionRowFieldTitle[indexPath.row]
        
        guard let userEmployment = sectionModel.sectionDataSource as? MIEmploymentDetailInfo else {
            return UITableViewCell()
        }
        
        let primaryError  = (self.errorData.index == indexPath.row) ? self.errorData.primaryError : ""
        let secondryError = (self.errorData.index == indexPath.row) ? self.errorData.secondryError : ""
        
        
        if isLastSection {
            
            if title == MIEmploymentDetailViewControllerConstant.selectDate {
                
                let dateCell = tableView.dequeueReusableCell(withClass: MIEmployementDateTableCell.self, for: indexPath)
                dateCell.showEmploymentWorkDuration(obj: userEmployment)
                
                if !primaryError.isEmpty {
                    dateCell.showError(with: primaryError, animated: false)
                }
                if !secondryError.isEmpty {
                    dateCell.showErrorOnSecondryTF(with: secondryError, animated: false)
                }
                
                dateCell.presentButton.isHidden = (tableView.numberOfSections != 1)
                
                dateCell.checkBoxSelectionAction = { (isSelected, cell) in
                    self.view.endEditing(true)
                    guard let btnCLickedCellIndexPath = self.tblView.indexPath(for: cell) else { return }
                    _ = self.userEmploymentsDataSource.map {($0.sectionDataSource as? MIEmploymentDetailInfo)?.isCurrentEmplyement = false}
                    _ = self.userEmploymentsDataSource.map { $0.sectionRowFieldTitle = self.manageTitleForSectionRowModel(modal: $0.sectionDataSource as? MIEmploymentDetailInfo ?? MIEmploymentDetailInfo(), sectionNumber: $0.sectionNumber)}
                    let sectionModel = self.userEmploymentsDataSource[btnCLickedCellIndexPath.section]
                    
                    if let userEmployment = sectionModel.sectionDataSource as? MIEmploymentDetailInfo {
                        userEmployment.isCurrentEmplyement = isSelected
                        userEmployment.experinceTill = nil
                        sectionModel.sectionRowFieldTitle = self.manageTitleForSectionRowModel(modal: userEmployment, sectionNumber: sectionModel.sectionNumber)
                        self.tblView.reloadData()
                    }
                    
                }
                
                dateCell.pickDateCallBack = { (cell, dateSelected, fieldName) in
                    self.view.endEditing(true)
                    guard let btnCLickedCellIndexPath = self.tblView.indexPath(for: cell) else { return }
                    
                    let sectionModel = self.userEmploymentsDataSource[btnCLickedCellIndexPath.section]
                    if let emp = sectionModel.sectionDataSource as? MIEmploymentDetailInfo {
                        if fieldName == "FROM_DATE" {
                            emp.experinceFrom = dateSelected
                            
                        }else if fieldName == "TILL_DATE" {
                            emp.experinceTill = dateSelected
                        }
                        if emp.experinceTill != nil && emp.experinceFrom != nil {
                            
                            if emp.experinceFrom?.compareWithDate(date: emp.experinceTill!) == .orderedDescending {
                                if fieldName == "FROM_DATE" {
                                    self.errorData = (indexPath.row, "", MIEmploymentDetailViewControllerConstant.employmentFromTillDate)
                                } else {
                                    self.errorData = (indexPath.row, MIEmploymentDetailViewControllerConstant.employmentFromTillDate, "")
                                }
                                emp.experinceTill = nil
                            }
                        }
                        self.tblView.reloadData()
                    }
                }
                
                dateCell.primaryTextFieldAction = { tf in
                    self.errorData = (-1, "", "")
                }
                
                dateCell.secondryTextFieldAction = { tf in
                    self.errorData = (-1, "", "")
                }
                
                return dateCell
                
            }else if title == MIEmploymentDetailViewControllerConstant.salary || title == MIEmploymentDetailViewControllerConstant.newOfferedSalary {
                
                let currentSalryCell = tableView.dequeueReusableCell(withClass: MIEmploymentSalaryTableCell.self, for: indexPath)
                
                currentSalryCell.salaryTxtField.delegate = self
                currentSalryCell.showCalulatedSalary = true

                if title == MIEmploymentDetailViewControllerConstant.salary  {
                    currentSalryCell.showDataForCurrentSalary(object: userEmployment)
                  //  currentSalryCell.showCalulatedSalary = userEmployment.isCurrentEmplyement
                    currentSalryCell.title_Lbl.text = (userEmployment.isCurrentEmplyement) ? "Current Salary" : " Salary (optional)"
                    currentSalryCell.btn_salaryHideFromEmployer.isHidden = !userEmployment.isCurrentEmplyement
                }else{
                    currentSalryCell.btn_salaryHideFromEmployer.isHidden = true
                //    currentSalryCell.calculatedSalaryLabel.isHidden = false
                    currentSalryCell.showDataForOfferedSalary(object: userEmployment)
                }
                currentSalryCell.currencyCallBack = { (cell,type) in
                    self.view.endEditing(true)
                    guard let btnCLickedCellIndexPath = self.tblView.indexPath(for: cell) else {
                        return
                    }
                    let sectionModel = self.userEmploymentsDataSource[btnCLickedCellIndexPath.section]
                    
                    if let userEmployment = sectionModel.sectionDataSource as? MIEmploymentDetailInfo {
                        if type == "CURRENCY" {
                            self.pushStaticMasterController(type: .CURRENCY
                                , data:(title == MIEmploymentDetailViewControllerConstant.salary) ? (userEmployment.salaryModal.salaryCurrency.isEmpty ? [] : [userEmployment.salaryModal.salaryCurrency]) : userEmployment.offeredSalaryModal.salaryCurrency.isEmpty ? [] : [userEmployment.offeredSalaryModal.salaryCurrency], title: title, sectionobj:sectionModel)
                        } else if type == "LAKH" {
                            self.pushStaticMasterController(type: .SALARYINLAKH
                                , data:(title == MIEmploymentDetailViewControllerConstant.salary) ? (userEmployment.salaryModal.salaryInLakh.isEmpty ? [] : [userEmployment.salaryModal.salaryInLakh]) : userEmployment.offeredSalaryModal.salaryInLakh.isEmpty ? [] : [userEmployment.offeredSalaryModal.salaryInLakh],title: title, sectionobj:sectionModel)
                        } else if type == "THOUSAND" {
                            self.pushStaticMasterController(type: .SALARYINTHOUSAND
                                , data:(title == MIEmploymentDetailViewControllerConstant.salary) ? (userEmployment.salaryModal.salaryThousand.isEmpty ? [] : [userEmployment.salaryModal.salaryThousand]) : userEmployment.offeredSalaryModal.salaryThousand.isEmpty ? [] : [userEmployment.offeredSalaryModal.salaryThousand], title: title, sectionobj:sectionModel)
                        }else if type == "OFFERED_AN" { //Annual Mode
                            
                            userEmployment.offeredSalaryModal.salaryMode = MICategorySelectionInfo(dictionary: ["name":"Annually","uuid":kannuallyModeSalaryUUID]) ?? MICategorySelectionInfo()
                            userEmployment.offeredSalaryModal.salaryModeAnually = true
                            
                        }else if type == "OFFERED_MO" { //Monthly Mode
                            userEmployment.offeredSalaryModal.salaryMode = MICategorySelectionInfo(dictionary: ["name":"Monthly","uuid":kmonthlyModeSalaryUUID]) ?? MICategorySelectionInfo()
                            userEmployment.offeredSalaryModal.salaryModeAnually = false
                        }else if type == "CURRENT_AN" { //Annual Mode
                            
                            userEmployment.salaryModal.salaryMode = MICategorySelectionInfo(dictionary: ["name":"Annually","uuid":kannuallyModeSalaryUUID]) ?? MICategorySelectionInfo()
                            userEmployment.salaryModal.salaryModeAnually = true
                            
                        }else if type == "CURRENT_MO" { //Monthly Mode
                            userEmployment.salaryModal.salaryMode = MICategorySelectionInfo(dictionary: ["name":"Monthly","uuid":kmonthlyModeSalaryUUID]) ?? MICategorySelectionInfo()
                            userEmployment.salaryModal.salaryModeAnually = false
                        }
                    }
                }
                return currentSalryCell
                
            } else {
                let tfCell = tableView.dequeueReusableCell(withClass: MITextFieldTableViewCell.self, for: indexPath)
                tfCell.secondryTextField.isHidden = true
                tfCell.showError(with: primaryError, animated: false)
                self.showEmploymentForUser(tfCell, model: userEmployment, title: title, sectionIndex: sectionModel.sectionNumber)
                return tfCell
            }
            
        } else {
            let cell = tableView.dequeueReusableCell(withClass: MICompletedEduEmpTableCell.self, for: indexPath)
            
            cell.titleLabel.text = userEmployment.designationObj.name
            let experinceFrom = userEmployment.experinceFrom?.getStringWithFormat(format: "MMM, yyyy") ?? ""
            let experinceTill = userEmployment.isCurrentEmplyement ? "Present" : (userEmployment.experinceTill?.getStringWithFormat(format: "MMM, yyyy") ?? "")
            cell.descLabel.text  = [userEmployment.companyObj.name, experinceFrom + " to " + experinceTill].joined(separator: " | ")
            cell.optionClicked = { sender in
                let controller = MIPopOverController()
                controller.profileType  = MIProfileEnums.workExperience
                controller.preferredContentSize = CGSize(width: 140, height: indexPath.section == 0 ? 40 : 80)
                controller.delegate = self
                controller.info     = [indexPath.section]
                self.showPopup(controller, sourceView: sender)
                controller.tableView.isScrollEnabled = (indexPath.section != 0)
            }
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        var isLastSection = (indexPath.section == self.userEmploymentsDataSource.count - 1)
        if MIUserModel.userSharedInstance.isEmploymentUploaded { isLastSection = false }
        guard isLastSection else { return }
        
        self.errorData = (-1, "", "")
        
        let sectionModel = self.userEmploymentsDataSource[indexPath.section]
        if let userEmployment = sectionModel.sectionDataSource as? MIEmploymentDetailInfo {
            selectedIndexPath = indexPath
            
            let title = sectionModel.sectionRowFieldTitle[indexPath.row]
            if title == MIEmploymentDetailViewControllerConstant.noticePeroid {
                self.pushStaticMasterController(type: .NOTICEPEROID
                    , data: userEmployment.noticePeroidDuration.isEmpty ? [] : [userEmployment.noticePeroidDuration], title: title, sectionobj:sectionModel)
            }else{
                self.pushToMasterDataSelection(fieldName: title, selectionLimit: 1, model: userEmployment)
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let sectionModel = self.userEmploymentsDataSource[indexPath.section]
        let title = sectionModel.sectionRowFieldTitle[indexPath.row]
        if  title == MIEmploymentDetailViewControllerConstant.jobDesignation ||
            title == MIEmploymentDetailViewControllerConstant.companyName ||
            title == MIEmploymentDetailViewControllerConstant.newCompanyName ||
            title == MIEmploymentDetailViewControllerConstant.offeredDesignation ||
            title == MIEmploymentDetailViewControllerConstant.noticePeroid ||
            title == MIEmploymentDetailViewControllerConstant.lastWorkingDay {
            
            return indexPath
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var isLastSection = (section == self.userEmploymentsDataSource.count - 1)
        if MIUserModel.userSharedInstance.isEmploymentUploaded { isLastSection = false }
        
        return isLastSection ? UITableView.automaticDimension : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: MIEduEmpHeaderView.self)) as? MIEduEmpHeaderView
        
        headerView?.titleLabel.text = self.userEmploymentsDataSource[section].sectionName
        headerView?.deleteButton.isHidden = (section == 0)
        
        headerView?.deleteButton.addTarget(self, action: #selector(deleteLastItem), for: .touchUpInside)
        
        return headerView
    }
    
    @objc func deleteLastItem() {
        self.popup.setViewWithTitle(title: "", viewDescriptionText:  ExtraResponse.deleteAlert, or: "", primaryBtnTitle: "Yes", secondaryBtnTitle: "No")
        self.popup.delegate = self
        self.popup.tag = 1
        self.popup.closeBtn.isHidden = true
        self.popup.addMe(onView: self.view, onCompletion: nil)
        MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.REGISTER_EMPLOYMENT, data: ["remove":"click"], destination: self.screenName) { (success, response, error, code) in
                   
               }
    }
    
    func callAPIForDeleteEmployment(itemIndex:Int) {
        if let emply = self.userEmploymentsDataSource[itemIndex].sectionDataSource as? MIEmploymentDetailInfo {
            let param = [
                "id" : emply.employmentId
                ] as [String : Any]
            // self.startActivityIndicator()
            MIActivityLoader.showLoader()
            
            MIApiManager.deleteEmploymentDetails(.delete, param: param) { [weak self] (result, error) in
                defer {MIActivityLoader.hideLoader() }
                guard let `self` = self else { return }
                // guard let data = result else { return }
                DispatchQueue.main.async {
                    self.itemSectionIndexForDelete = -1
                    
                    if itemIndex < self.userEmploymentsDataSource.count {
                        self.userEmploymentsDataSource.remove(at: itemIndex)
                        self.tblView.reloadData()
                    }
                }
                
            }
        }
        
//        let eventData = [
//
//            "remove" : CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK
//            ] as [String : Any]
//        MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.REGISTER_EMPLOYMENT, data: eventData, destination: CONSTANT_SCREEN_NAME.REGISTER_EMPLOYMENT) { (success, response, error, code) in
//        }
        
    }
}

extension MIEmployementForUserVC: JobPreferencePopUpDelegate{
    
    func optionCompleteIgnoredSelected(popSelection: PopUpOptionSelection, popup: MIPopupView) {
        if popSelection == .Completed {
            if popup.tag == 0 {
                self.callAPIForDeleteEmployment(itemIndex: self.itemSectionIndexForDelete)
            } else {
                self.userEmploymentsDataSource.last?.sectionDataSource = MIEmploymentDetailInfo()
                self.tblView.reloadData()
            }
            
        }
    }
}


extension MIEmployementForUserVC : MIMasterDataSelectionViewControllerDelegate {
    
    func masterDataSelected(selectedCategoryInfo: [MICategorySelectionInfo], selectedListInfo: [String], enumName: String) {
        if let index = selectedIndexPath {
            let sectionModel = self.userEmploymentsDataSource[index.section]
            
            let title = sectionModel.sectionRowFieldTitle[index.row]
            if let model = sectionModel.sectionDataSource as? MIEmploymentDetailInfo {
                if title == MIEmploymentDetailViewControllerConstant.jobDesignation {
                    model.designationObj = selectedCategoryInfo.first ?? MICategorySelectionInfo()
                }
                if title == MIEmploymentDetailViewControllerConstant.companyName {
                    model.companyObj = selectedCategoryInfo.first ?? MICategorySelectionInfo()
                    
                }
                if title == MIEmploymentDetailViewControllerConstant.newCompanyName {
                    model.newCompanyObj = selectedCategoryInfo.first ?? MICategorySelectionInfo()
                    
                }
                if title == MIEmploymentDetailViewControllerConstant.offeredDesignation {
                    model.offeredDesignationObj = selectedCategoryInfo.first ?? MICategorySelectionInfo()
                    
                }
            }
            
            selectedIndexPath = nil
            self.tblView.reloadData()
        }
    }
}

extension MIEmployementForUserVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.autocapitalizationType = .words
        let txtFldPosition = textField.convert(CGPoint.zero, to: self.tblView)
        if let indexPath = self.tblView.indexPathForRow(at: txtFldPosition) {
            
            let sectiondModel = self.userEmploymentsDataSource[indexPath.section]
            let title = sectiondModel.sectionRowFieldTitle[indexPath.row]
            let userEmployment = sectiondModel.sectionDataSource as? MIEmploymentDetailInfo
            
            if title == MIEmploymentDetailViewControllerConstant.salary {
                //For Salary if currency is not INR
                self.setMainViewFrame(originY: 0)
                let movingHeight = textField.movingHeightIn(view : self.view)
                if movingHeight > 0 {
                    UIView.animate(withDuration: 0.3) {
                        self.setMainViewFrame(originY: -movingHeight)
                    }
                }
            }
            if title == MIEmploymentDetailViewControllerConstant.newOfferedSalary {
                //For Offered Salary if currency is not INR
                self.setMainViewFrame(originY: 0)
                let movingHeight = textField.movingHeightIn(view : self.view) + 25
                if movingHeight > 0 {
                    UIView.animate(withDuration: 0.3) {
                        self.setMainViewFrame(originY: -movingHeight)
                    }
                }
            }
            
            if title == MIEmploymentDetailViewControllerConstant.lastWorkingDay {
                //For last day working
                self.errorData = (-1, "", "")
                AKDatePicker.openPicker(in: textField, currentDate: userEmployment?.lastWorkingDate, minimumDate: Date(), maximumDate: Date().plus(years: 1), pickerMode: .date) { (date) in
                    userEmployment?.lastWorkingDate  = date
                    self.tblView.reloadData()
                }
            }
        }
        textField.returnKeyType = .done
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let txtFldPosition = textField.convert(CGPoint.zero, to: self.tblView)
        if let indexPath = self.tblView.indexPathForRow(at: txtFldPosition) {
            let sectiondModel = self.userEmploymentsDataSource[indexPath.section]
            let title = sectiondModel.sectionRowFieldTitle[indexPath.row]
            if title == MIEmploymentDetailViewControllerConstant.salary {
                if let emplymentObj = sectiondModel.sectionDataSource  as? MIEmploymentDetailInfo {
                    emplymentObj.salaryModal.salaryInLakh     = textField.text ?? ""
                    emplymentObj.salaryModal.salaryThousand = ""
                    emplymentObj.salaryModal.absoluteValue = 0
                }
            }
            if title == MIEmploymentDetailViewControllerConstant.newOfferedSalary {
                if let emplymentObj = sectiondModel.sectionDataSource  as? MIEmploymentDetailInfo {
                    emplymentObj.offeredSalaryModal.salaryInLakh     = textField.text ?? ""
                    emplymentObj.offeredSalaryModal.salaryThousand = ""
                    emplymentObj.offeredSalaryModal.absoluteValue = 0
                }
            }
            self.tblView.reloadData()

            UIView.animate(withDuration: 0.3) {
                self.setMainViewFrame(originY: 0)
            }
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        let searchString = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
        let txtFldPosition = textField.convert(CGPoint.zero, to: self.tblView)
        if let indexPath = self.tblView.indexPathForRow(at: txtFldPosition) {
            let sectiondModel = self.userEmploymentsDataSource[indexPath.section]
            let title = sectiondModel.sectionRowFieldTitle[indexPath.row]
            if title == MIEmploymentDetailViewControllerConstant.salary || title == MIEmploymentDetailViewControllerConstant.newOfferedSalary {
                if (searchString.count) > 11 {
                    return false
                }
            }
            if searchString.count <= 11 || string.isEmpty {
                let allowedCharacters = CharacterSet.decimalDigits
                let characterSet = CharacterSet(charactersIn: string)
                return allowedCharacters.isSuperset(of: characterSet)
            }
        }
        
        return false
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

extension MIEmployementForUserVC {
    func showEmploymentForUser(_ cell: MITextFieldTableViewCell, model: MIEmploymentDetailInfo, title:String, sectionIndex:Int) {
        cell.titleLabel.text = title
        cell.primaryTextField.delegate = self
        cell.primaryTextField.placeholder = title
        cell.primaryTextField.isUserInteractionEnabled = false
        cell.primaryTextField.setRightViewForTextField("darkRightArrow", width: 15)
        
        switch title {
        case MIEmploymentDetailViewControllerConstant.jobDesignation:
            cell.titleLabel.text = (sectionIndex == 0) ? "Current " + title : title
            cell.primaryTextField.text = model.designationObj.name
            cell.primaryTextField.placeholder = (sectionIndex == 0) ? "Most Recent Designation" : "Please select your designation"
        case MIEmploymentDetailViewControllerConstant.companyName:
            cell.titleLabel.text = (sectionIndex == 0) ? "Current " + title : title
            cell.primaryTextField.text = model.companyObj.name
            cell.primaryTextField.placeholder = (sectionIndex == 0) ? "Most Recent Company" : "Please enter company name"
        case MIEmploymentDetailViewControllerConstant.servingNoticePeroid:
            cell.primaryTextField.text = model.noticePeroidDuration
        case MIEmploymentDetailViewControllerConstant.lastWorkingDay:
            cell.primaryTextField.isUserInteractionEnabled = true
            cell.primaryTextField.text = model.lastWorkingDate?.getStringWithFormat(format: "dd-MM-yyyy")
            cell.primaryTextField.setRightViewForTextField("calendarBlue")
        case MIEmploymentDetailViewControllerConstant.offeredDesignation:
            cell.primaryTextField.text = model.offeredDesignationObj.name
        case MIEmploymentDetailViewControllerConstant.newCompanyName:
            cell.primaryTextField.text = model.newCompanyObj.name
        case MIEmploymentDetailViewControllerConstant.noticePeroid:
            cell.primaryTextField.text = model.noticePeroidDuration
            cell.primaryTextField.placeholder = "Select"
            
        default:
            cell.primaryTextField.text = ""
        }
    }
}

extension MIEmployementForUserVC: MIPopOverControllerDelegate {
    
    func popOverClicked(actionType: MIProfileActionEnum, info: Any, profileType: MIProfileEnums) {
        
        switch actionType {
        case .edit:
            if let section = info as? Int {
                self.navigateToEditEmploymentVC(at: section)
            }
        case .delete:
            if MIUserModel.userSharedInstance.isEducationUploaded {
                if let section = info as? Int {
                    self.itemSectionIndexForDelete = section
                    
                    self.popup.setViewWithTitle(title: "Delete Employment", viewDescriptionText:"Are you sure you want to delete this detail ?" , primaryBtnTitle: "Yes", secondaryBtnTitle: "No", secondaryBtnTextColor: UIColor(hex: "5c4aae"))
                    self.popup.delegate = self
                    self.popup.tag = 0
                    self.popup.addMe(onView: self.view, onCompletion: nil)
                }
                
            }else{
                if let section = info as? Int {
                    self.userEmploymentsDataSource.remove(at: section)
                    self.tblView.reloadData()
                }
            }
            MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.REGISTER_EMPLOYMENT, data: ["remove":"click"], destination: self.screenName) { (success, response, error, code) in
                       
                   }
            
        }
    }
    
    func navigateToEditEmploymentVC(at index: Int) {
        let vc = MIEditEmploymentTableViewController()
        vc.userEmploymentsDataSource = self.userEmploymentsDataSource
        vc.editingIndex = index
        
        vc.updateDataCompletion = { data in
            self.userEmploymentsDataSource[index] = data
            self.tblView.reloadData()
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = CGRect(x: 14, y: 0, width: 4, height: 30)
        
        presentationController.canOverlapSourceViewRect = true
        presentationController.permittedArrowDirections = [.up]
        
        self.present(controller, animated: true)
    }
    
    
}
