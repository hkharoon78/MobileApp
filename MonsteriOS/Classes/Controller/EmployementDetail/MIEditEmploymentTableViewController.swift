//
//  MIEditEmploymentTableViewController.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 11/10/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIEditEmploymentTableViewController: UITableViewController {
    
    var fieldDataSource = [String]()
    var userEmploymentsDataSource = [SectionModel]()
    var selectedIndexPath : IndexPath?
    
    private var sectionModel: SectionModel!
    
    var editingIndex = 0
    
    let footer = MISingleButtonView.singleBtnView
    
    var updateDataCompletion: ((SectionModel)->Void)?
    
    private var errorData : (index:Int, primaryError:String, secondryError: String) = (-1,"","") {
        didSet {
            guard errorData.index >= 0 else { return }
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.sectionModel = self.userEmploymentsDataSource[self.editingIndex].copy() as? SectionModel
        self.fieldDataSource = self.sectionModel.sectionRowFieldTitle
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.register(UINib(nibName:String(describing: MITextFieldTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MITextFieldTableViewCell.self))
        tableView.register(UINib(nibName:String(describing: MIEmploymentSalaryTableCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIEmploymentSalaryTableCell.self))
        tableView.register(UINib(nibName:String(describing: MIEmployementDateTableCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIEmployementDateTableCell.self))
        
        
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.estimatedRowHeight = tableView.rowHeight
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.sectionHeaderHeight = tableView.sectionHeaderHeight
        self.tableView.estimatedSectionHeaderHeight = UITableView.automaticDimension
        self.tableView.sectionFooterHeight = tableView.sectionFooterHeight
        self.tableView.estimatedSectionFooterHeight = UITableView.automaticDimension
        
        self.tableView.separatorStyle = .none
        
        
        footer.btn_delete.setTitle("UPDATE", for: .normal)
        footer.btn_delete.showPrimaryBtn()
        footer.btn_leadingConstraint.constant = 15
        footer.btn_trailingConstairnt.constant = 15
        self.tableView.tableFooterView = footer
        footer.btnActionCallBack = { [weak self] sectionCount in
            guard let `self` = self else { return }
            
            if self.validateEmployementData(sectionObj: self.sectionModel) {
                let empl = self.sectionModel.sectionDataSource as? MIEmploymentDetailInfo ?? MIEmploymentDetailInfo()
                if empl.employmentId.isEmpty {
                    self.updateDataCompletion?(self.sectionModel)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.callAPIForUpdateUserEmployment()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

        self.title = MIEmploymentDetailViewControllerConstant.title
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.sectionModel.sectionRowFieldTitle.count
    }
    
    
    override  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let title = sectionModel.sectionRowFieldTitle[indexPath.row]
        
        guard let userEmployment = sectionModel.sectionDataSource as? MIEmploymentDetailInfo else {
            return UITableViewCell()
        }
        
        let primaryError  = (self.errorData.index == indexPath.row) ? self.errorData.primaryError : ""
        let secondryError = (self.errorData.index == indexPath.row) ? self.errorData.secondryError : ""
        
        
        if title == MIEmploymentDetailViewControllerConstant.selectDate {
            
            let dateCell = tableView.dequeueReusableCell(withClass: MIEmployementDateTableCell.self, for: indexPath)
            dateCell.showEmploymentWorkDuration(obj: userEmployment)
            
            if !primaryError.isEmpty {
                dateCell.showError(with: primaryError, animated: false)
            }
            if !secondryError.isEmpty {
                dateCell.showErrorOnSecondryTF(with: secondryError, animated: false)
            }
            
            dateCell.presentButton.isHidden = (self.sectionModel.sectionNumber != 0)
            
            dateCell.checkBoxSelectionAction = { (isSelected, cell) in
                self.view.endEditing(true)
                
                (self.sectionModel.sectionDataSource as? MIEmploymentDetailInfo)?.isCurrentEmplyement = false
                self.sectionModel.sectionRowFieldTitle = self.manageTitleForSectionRowModel(modal: self.sectionModel.sectionDataSource as? MIEmploymentDetailInfo ?? MIEmploymentDetailInfo(), sectionNumber: self.sectionModel.sectionNumber)
                
                if let userEmployment = self.sectionModel.sectionDataSource as? MIEmploymentDetailInfo {
                    userEmployment.isCurrentEmplyement = isSelected
                    userEmployment.experinceTill = nil
                    self.sectionModel.sectionRowFieldTitle = self.manageTitleForSectionRowModel(modal: userEmployment, sectionNumber: self.sectionModel.sectionNumber)
                    self.tableView.reloadData()
                }
                
            }
            
            dateCell.pickDateCallBack = { (cell, dateSelected, fieldName) in
                self.view.endEditing(true)
                
                if let emp = self.sectionModel.sectionDataSource as? MIEmploymentDetailInfo {
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
                    self.tableView.reloadData()
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
                //currentSalryCell.showCalulatedSalary = userEmployment.isCurrentEmplyement
                currentSalryCell.showDataForCurrentSalary(object: userEmployment)
                currentSalryCell.title_Lbl.text = userEmployment.isCurrentEmplyement ? "Current Salary" : "Salary (Optional)"
                currentSalryCell.btn_salaryHideFromEmployer.isHidden = !userEmployment.isCurrentEmplyement
            }else{
                currentSalryCell.showDataForOfferedSalary(object: userEmployment)
                currentSalryCell.btn_salaryHideFromEmployer.isHidden = true
                currentSalryCell.title_Lbl.text = "Offered Salary (Optional)"
            }
            currentSalryCell.currencyCallBack = { (cell,type) in
                self.view.endEditing(true)
                
                if let userEmployment = self.sectionModel.sectionDataSource as? MIEmploymentDetailInfo {
                    if type == "CURRENCY" {
                        self.pushStaticMasterController(type: .CURRENCY
                            , data:(title == MIEmploymentDetailViewControllerConstant.salary) ? (userEmployment.salaryModal.salaryCurrency.isEmpty ? [] : [userEmployment.salaryModal.salaryCurrency]) : userEmployment.offeredSalaryModal.salaryCurrency.isEmpty ? [] : [userEmployment.offeredSalaryModal.salaryCurrency], title: title, sectionobj:self.sectionModel)
                    }else if type == "LAKH" {
                        self.pushStaticMasterController(type: .SALARYINLAKH
                            , data:(title == MIEmploymentDetailViewControllerConstant.salary) ? (userEmployment.salaryModal.salaryInLakh.isEmpty ? [] : [userEmployment.salaryModal.salaryInLakh]) : userEmployment.offeredSalaryModal.salaryInLakh.isEmpty ? [] : [userEmployment.offeredSalaryModal.salaryInLakh],title: title, sectionobj:self.sectionModel)
                    }else if type == "THOUSAND" {
                        self.pushStaticMasterController(type: .SALARYINTHOUSAND
                            , data:(title == MIEmploymentDetailViewControllerConstant.salary) ? (userEmployment.salaryModal.salaryThousand.isEmpty ? [] : [userEmployment.salaryModal.salaryThousand]) : userEmployment.offeredSalaryModal.salaryThousand.isEmpty ? [] : [userEmployment.offeredSalaryModal.salaryThousand], title: title, sectionobj:self.sectionModel)
                    }else if type == "OFFERED_AN" { //Annual Mode
                        
                        userEmployment.offeredSalaryModal.salaryMode = MICategorySelectionInfo(dictionary: ["name":"Annually","uuid":kannuallyModeSalaryUUID]) ?? MICategorySelectionInfo()
                        userEmployment.offeredSalaryModal.salaryModeAnually = true
                        
                    }else if type == "OFFERED_MO" { //Monthly Mode
                        userEmployment.offeredSalaryModal.salaryMode = MICategorySelectionInfo(dictionary: ["name":"Monthly","uuid":kmonthlyModeSalaryUUID]) ?? MICategorySelectionInfo()
                        userEmployment.offeredSalaryModal.salaryModeAnually = false
                    }else if type == "CURRENT_AN" { //Annual Mode
                        
                        userEmployment.salaryModal.salaryMode = MICategorySelectionInfo(dictionary: ["name":"Annually","uuid":kannuallyModeSalaryUUID]) ?? MICategorySelectionInfo()
                        userEmployment.offeredSalaryModal.salaryModeAnually = true
                        
                    }else if type == "CURRENT_MO" { //Monthly Mode
                        userEmployment.salaryModal.salaryMode = MICategorySelectionInfo(dictionary: ["name":"Monthly","uuid":kmonthlyModeSalaryUUID]) ?? MICategorySelectionInfo()
                        userEmployment.offeredSalaryModal.salaryModeAnually = false
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
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)

        self.errorData = (-1, "", "")
        
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
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        //        let sectionModel = self.userEmploymentsDataSource[self.editingIndex]
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
    
}


extension MIEditEmploymentTableViewController {
    
    func callAPIForUpdateUserEmployment() {
        let params = MIEmploymentDetailInfo.getParamsForUserEmploymentPayloadViaRegister(employmentSection: self.userEmploymentsDataSource)
        
        MIActivityLoader.showLoader()
        
        MIApiManager.callAPIForUpdateEmploymentEducation(methodType:.put, path: APIPath.updateEmploymentDetailApiEndpoint, params: params, customHeaderParams: [:]) { (success, response, error, code) in
            DispatchQueue.main.async {
                // self.stopActivityIndicator()
                MIActivityLoader.hideLoader()
                
                if error == nil && (code >= 200) && (code <= 299) {
                    
                    self.userEmploymentsDataSource[self.editingIndex] = self.sectionModel
                    
                    var employmentTempData = [MIEmploymentDetailInfo]()
                    
                    for (_,modal) in self.userEmploymentsDataSource.enumerated() {
                        if let emyObj = modal.sectionDataSource as? MIEmploymentDetailInfo {
                            employmentTempData.append(emyObj)
                        }
                    }
                    MIUserModel.userSharedInstance.userEmploymentDataList = employmentTempData
                    
                    self.navigationController?.popViewController(animated: true)
                    
                }else{
                    self.handleAPIError(errorParams: response, error: error)
                }
            }
        }
    }
    
    
    func validateEmployementData(sectionObj : SectionModel) -> Bool {
        
        let arr = sectionObj.sectionRowFieldTitle
        
        guard let employment = sectionObj.sectionDataSource as? MIEmploymentDetailInfo else { return true }
        if employment.designationObj.name.isEmpty {
            if let index = arr.firstIndex(of: MIEmploymentDetailViewControllerConstant.jobDesignation) {
                let indexPath = IndexPath(row: index, section: 0)
                
                let msg = (sectionObj.sectionNumber == 0) ? MIEmploymentDetailViewControllerConstant.emptyMostRecentDesignation : MIEmploymentDetailViewControllerConstant.emptyDesignation
                self.errorData = (indexPath.row, msg, "")
                
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
            return false
        }
        if employment.companyObj.name.isEmpty {
            if let index = arr.firstIndex(of: MIEmploymentDetailViewControllerConstant.companyName) {
                let indexPath = IndexPath(row: index, section: 0)
                
                let msg = (sectionObj.sectionNumber == 0) ? MIEmploymentDetailViewControllerConstant.emptyMostRecentCompanyName : MIEmploymentDetailViewControllerConstant.emptyCompanyName
                self.errorData = (indexPath.row, msg, "")
                
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
            return false
        }
        
        if let index = arr.firstIndex(of: MIEmploymentDetailViewControllerConstant.selectDate) {
            let indexPath = IndexPath(row: index, section: 0)
            defer { self.tableView.scrollToRow(at: indexPath, at: .top, animated: false) }
            
            if employment.isCurrentEmplyement  {
                if (employment.experinceFrom == nil) {
                    self.errorData = (indexPath.row, MIEmploymentDetailViewControllerConstant.emptyStartDate, "")
                    return false
                }
//                if (employment.salaryModal.salaryInLakh.isEmpty && employment.salaryModal.salaryThousand.isEmpty) {
//                    self.errorData = (indexPath.row, MIEmploymentDetailViewControllerConstant.emptyCurrentSalary, "")
//                    return false
//                }
            }else{
                if employment.experinceFrom == nil {
                    self.errorData = (indexPath.row, MIEmploymentDetailViewControllerConstant.emptyStartDate, "")
                    return false
                    
                }else if employment.experinceTill == nil {
                    self.errorData = (indexPath.row, "", MIEmploymentDetailViewControllerConstant.emptyEndDate)
                    return false
                }
            }
        }
        
        
        if employment.isCurrentEmplyement {
            if (employment.salaryModal.salaryInLakh.isEmpty &&  employment.salaryModal.salaryThousand.isEmpty) {
                self.showAlert(title: "", message:MIEmploymentDetailViewControllerConstant.emptyCurrentSalary )
                return false

                }
        }
        
        if sectionObj.sectionNumber == 0 && employment.isCurrentEmplyement {
            
            if employment.noticePeroidDuration.isEmpty  {
                if let index = arr.firstIndex(of: MIEmploymentDetailViewControllerConstant.noticePeroid) {
                    let indexPath = IndexPath(row: index, section: 0)
                    self.errorData = (indexPath.row, MIEmploymentDetailViewControllerConstant.emptyNoticePeroid, "")
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                }
                return false
                
            } else if employment.isServingNotice && (employment.lastWorkingDate == nil) {
                if let index = arr.firstIndex(of: MIEmploymentDetailViewControllerConstant.lastWorkingDay) {
                    let indexPath = IndexPath(row: index, section: 0)
                    self.errorData = (indexPath.row, MIEmploymentDetailViewControllerConstant.emptyLastWorking, "")
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
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
                    employmentModel.salaryModal.absoluteValue = 0

                    if type == .CURRENCY {
                        employmentModel.salaryModal.salaryInLakh = ""
                        employmentModel.salaryModal.salaryThousand = ""
                        employmentModel.salaryModal.salaryCurrency = value
                    }else if type == .SALARYINLAKH {
                        employmentModel.salaryModal.salaryInLakh = value
                    }else if type == .SALARYINTHOUSAND {
                        employmentModel.salaryModal.salaryThousand = value
                    }
                    
                }
                if title == MIEmploymentDetailViewControllerConstant.newOfferedSalary {
                    employmentModel.offeredSalaryModal.absoluteValue = 0
                    if type == .CURRENCY {
                        employmentModel.offeredSalaryModal.salaryInLakh = ""
                        employmentModel.offeredSalaryModal.salaryThousand = ""
                        employmentModel.offeredSalaryModal.salaryCurrency = value
                    }else if type == .SALARYINLAKH {
                        employmentModel.offeredSalaryModal.salaryInLakh = value
                    }else if type == .SALARYINTHOUSAND {
                        employmentModel.offeredSalaryModal.salaryThousand = value
                    }
                }
                self.tableView.reloadData()
                
            }
            self.navigationController?.pushViewController(staticMasterVC, animated: true)
        }
        
    }
    
    func manageTitleForSectionRowModel(modal:MIEmploymentDetailInfo,sectionNumber:Int) -> [String]{
        
        if sectionNumber == 0 {
            if modal.isServingNotice {
                self.filterTitleWithValue(values:[])
                
            } else if modal.isCurrentEmplyement {
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
            if let index = fieldDataSource.index(of:obj) {
                fieldDataSource.remove(at: index)
            }
        }
    }
    
}

extension MIEditEmploymentTableViewController : MIMasterDataSelectionViewControllerDelegate {
    
    func masterDataSelected(selectedCategoryInfo: [MICategorySelectionInfo], selectedListInfo: [String], enumName: String) {
        if let index = selectedIndexPath {
            //            let sectionModel = self.userEmploymentsDataSource[self.editingIndex]
            
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
            self.tableView.reloadData()
        }
    }
}

extension MIEditEmploymentTableViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.autocapitalizationType = .words
        let txtFldPosition = textField.convert(CGPoint.zero, to: self.tableView)
        if let indexPath = self.tableView.indexPathForRow(at: txtFldPosition) {
            
            let title = sectionModel.sectionRowFieldTitle[indexPath.row]
            let userEmployment = sectionModel.sectionDataSource as? MIEmploymentDetailInfo

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
                    self.tableView.reloadData()
                }
            }
        }
        textField.returnKeyType = .done
        return true
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let txtFldPosition = textField.convert(CGPoint.zero, to: self.tableView)
        if let indexPath = self.tableView.indexPathForRow(at: txtFldPosition) {
            //            let sectiondModel = self.userEmploymentsDataSource[self.editingIndex]
            let title = sectionModel.sectionRowFieldTitle[indexPath.row]
            if title == MIEmploymentDetailViewControllerConstant.salary {
                if let emplymentObj = sectionModel.sectionDataSource  as? MIEmploymentDetailInfo {
                    emplymentObj.salaryModal.salaryInLakh     = textField.text ?? ""
                    emplymentObj.salaryModal.salaryThousand = ""
                    emplymentObj.salaryModal.absoluteValue = 0

                }
            }
            if title == MIEmploymentDetailViewControllerConstant.newOfferedSalary {
                if let emplymentObj = sectionModel.sectionDataSource  as? MIEmploymentDetailInfo {
                    emplymentObj.offeredSalaryModal.salaryInLakh     = textField.text ?? ""
                    emplymentObj.offeredSalaryModal.salaryThousand = ""
                    emplymentObj.offeredSalaryModal.absoluteValue = 0
                }
            }
            self.tableView.reloadData()

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
        let txtFldPosition = textField.convert(CGPoint.zero, to: self.tableView)
        if let indexPath = self.tableView.indexPathForRow(at: txtFldPosition) {
            //            let sectiondModel = self.userEmploymentsDataSource[self.editingIndex]
            let title = sectionModel.sectionRowFieldTitle[indexPath.row]
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
    
    func setMainViewFrame(originY: CGFloat) {
        var frame = self.view.frame
        frame.origin.y = CGFloat(originY)
        self.view.frame = frame
    }
}

extension MIEditEmploymentTableViewController {
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

extension MIEditEmploymentTableViewController : JobPreferencePopUpDelegate {
    func optionCompleteIgnoredSelected(popSelection: PopUpOptionSelection, popup: MIPopupView) {

        if popSelection == .Completed {
            //            self.callAPIForDeleteEmployment(itemIndex: self.itemSectionIndexForDelete)
        }
    }
    
}
