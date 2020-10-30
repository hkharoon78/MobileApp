//
//  MIEmploymentDetailViewController.swift
//  MonsteriOS
//
//  Created by Monster on 02/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//  From: Profile

import UIKit
import DropDown

class MIEmploymentDetailViewController: MIBaseViewController,UITextViewDelegate {
    
    @IBOutlet weak private var tblView: UITableView!
    @IBOutlet weak private var nextBtn: UIButton!
    
    private let currentJobCellId   = "current_job_cell"
    private let tblHeader          = MIProgressView.header
    private var tFooter            = MILoginFooterView.header
    var empDetailArray    = [MIEmploymentDetailInfo]()
    var isBeforeUpdateCurrentEmp = false
    var previousOfferedAbsoluteValue = 0
    
    private var masterData      = [String:[MICategorySelectionInfo]]()
    private var selectedIndexPath : IndexPath?
    var employementAddedSuccess : ((Bool) -> Void)?
    var employementFlow : FlowVia = .ViaRegister
    // let dropDownPicker = DropDown()
    var error: (message: String, index: Int,isPrimaryError:Bool) = ("", -1,false)
    
    var employmentTitle = [String]()
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        //Professional Details
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CommonClass.googleAnalyticsScreen(self) //GA for Screen
        self.navigationItem.leftBarButtonItem?.title = nil
        self.title = "Work Experience"
        if employementFlow == .ViaRegister {
            JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.REGISTER_EDIT_EMPLOYMENT)
            
        }else{
            JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.EMPLOYMENT)
            
        }
        
    }
    
    override func  viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }
    deinit {
        //print("MIEmploymentDetailViewController  deinitlized:",self)
    }
    class var newInstance:MIEmploymentDetailViewController {
        get {
            return Storyboard.main.instantiateViewController(withIdentifier: "MIEmploymentDetailViewController") as! MIEmploymentDetailViewController
        }
    }
    
    func setUI() {
        
        self.nextBtn.setTitle(MIEmploymentDetailViewControllerConstant.nxtBtnTitle, for: .normal)
        self.tblView.tableHeaderView = UIView()
        if employementFlow == .ViaProfileAdd {
            self.generateEmploymentData()
            self.nextBtn.setTitle("Save", for: .normal)
        }
        if let obj = self.empDetailArray.first {
            isBeforeUpdateCurrentEmp = obj.isCurrentEmplyement
            previousOfferedAbsoluteValue = SalaryDetail.getAbsoulateValueData(salaryData: obj.offeredSalaryModal)
        }
        nextBtn.showPrimaryBtn()
        
        self.tblView.register(UINib(nibName:String(describing: MITextFieldTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MITextFieldTableViewCell.self))
        self.tblView.register(UINib(nibName:String(describing: MITextViewTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MITextViewTableViewCell.self))
        self.tblView.register(UINib(nibName:String(describing: MIEmploymentSalaryTableCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MIEmploymentSalaryTableCell.self))
        self.tblView.register(UINib(nibName:String(describing: MICurrentJobCell.self) , bundle: nil), forCellReuseIdentifier: currentJobCellId)
        
        self.tblView.keyboardDismissMode = .onDrag
        
        self.manageTitle()
        tblView.estimatedRowHeight = tblView.rowHeight
        tblView.separatorStyle = .none
        tblView.rowHeight = UITableView.automaticDimension
        self.tblView.reloadData()
        
    }
    
    func manageTitle() {
        if let obj = self.empDetailArray.first {
            if obj.isServingNotice {
                employmentTitle = [MIEmploymentDetailViewControllerConstant.jobdescription,MIEmploymentDetailViewControllerConstant.jobDesignation,MIEmploymentDetailViewControllerConstant.companyName,MIEmploymentDetailViewControllerConstant.currentyWorkinghere,MIEmploymentDetailViewControllerConstant.selectDate,MIEmploymentDetailViewControllerConstant.salary,MIEmploymentDetailViewControllerConstant.noticePeroid,MIEmploymentDetailViewControllerConstant.lastWorkingDay,MIEmploymentDetailViewControllerConstant.newOfferedSalary,MIEmploymentDetailViewControllerConstant.offeredDesignation,MIEmploymentDetailViewControllerConstant.newCompanyName]
                
            }else if obj.isCurrentEmplyement {
                employmentTitle = [MIEmploymentDetailViewControllerConstant.jobdescription,MIEmploymentDetailViewControllerConstant.jobDesignation,MIEmploymentDetailViewControllerConstant.companyName,MIEmploymentDetailViewControllerConstant.currentyWorkinghere,MIEmploymentDetailViewControllerConstant.selectDate,MIEmploymentDetailViewControllerConstant.salary,MIEmploymentDetailViewControllerConstant.noticePeroid]
                
            }else{
                employmentTitle = [MIEmploymentDetailViewControllerConstant.jobdescription,MIEmploymentDetailViewControllerConstant.jobDesignation,MIEmploymentDetailViewControllerConstant.companyName,MIEmploymentDetailViewControllerConstant.currentyWorkinghere,MIEmploymentDetailViewControllerConstant.selectDate]
            }
        }
    }
    
    func generateEmploymentData() {
        self.empDetailArray.append(MIEmploymentDetailInfo())
        self.tblView.reloadData()
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
    
    //MARK: - IBAction Methods
    @IBAction func nextClicked(_ sender: UIButton) {
        // let vc = MIEducationBackgroundViewController.newInstance
        self.view.endEditing(true)
        var isAllEmployementVerified = true
        for obj in self.empDetailArray {
            if !self.validateEmployementData(modelObj: obj) {
                isAllEmployementVerified = false
                break
            }
        }
        if isAllEmployementVerified {
            self.callAPIForAddUpdateEmployment()
        }
    }
    
    @IBAction func yearWorkExperinceClicked(_ sender : UIButton) {
        
        let staticMasterVC = MIStaticMasterDataViewController.newInstance
        staticMasterVC.title = "Selection"
        staticMasterVC.staticMasterType = .EXPEREINCEINYEAR
        if !MIUserModel.userSharedInstance.userExperienceInYear.isEmpty {
            staticMasterVC.selectedDataArray = [MIUserModel.userSharedInstance.userExperienceInYear]
        }
        staticMasterVC.delagate = self
        self.navigationController?.pushViewController(staticMasterVC, animated: true)
        
        
    }
    @IBAction func monthWorkExperinceClicked(_ sender : UIButton) {
        
        let staticMasterVC = MIStaticMasterDataViewController.newInstance
        staticMasterVC.title = "Selection"
        staticMasterVC.staticMasterType = .EXPEREINCEINMONTH
        if !MIUserModel.userSharedInstance.userExperienceInMonth.isEmpty {
            staticMasterVC.selectedDataArray = [MIUserModel.userSharedInstance.userExperienceInMonth]
        }
        staticMasterVC.delagate = self
        self.navigationController?.pushViewController(staticMasterVC, animated: true)
        
    }
    
    //Mark: - Service Helper Methods
    func callAPIForAddUpdateEmployment(){
        var params = [[String:Any]]()
        var serviceType : ServiceMethod = .put
        
        if self.employementFlow == .ViaProfileAdd {
            serviceType = .post
        }
        params = (MIEmploymentDetailInfo.getDictFromModelObjectListForUpdatePayload(employementList:self.empDetailArray) as! [[String:Any]])
        
        self.startActivityIndicator()
        
        MIApiManager.callAPIForUpdateEmploymentEducation(methodType: serviceType, path: APIPath.updateEmploymentDetailApiEndpoint, params: params, customHeaderParams: [:] ) {[weak self] (success, response, error, code) in
            DispatchQueue.main.async {
                guard let wself = self else {return }
                wself.stopActivityIndicator()
                
                if error == nil && (code >= 200) && (code <= 299) {
                    wself.checkFieldUpdateData()
                  //  wself.showAlert(title: "", message: wself.employementFlow.employmentSuccessMessage,isErrorOccured:false)
                    
                    if let action = wself.employementAddedSuccess {
                        action(true)
                    }
                    shouldRunProfileApi = true
                    wself.showAlert(title: "", message: wself.employementFlow.employmentSuccessMessage, isErrorOccured: false) {
                                           wself.navigationController?.popViewController(animated: false)

                                       }
                }else{
                    wself.handleAPIError(errorParams: response, error: error)
                }
            }
        }
    }
    func fieldUpdateForCurrentCase(emp:MIEmploymentDetailInfo) -> [String] {
        var fields = [String]()
        fields.append(CONSTANT_FIELD_LEVEL_NAME.CUR_DESIGNATION)
        fields.append(CONSTANT_FIELD_LEVEL_NAME.NOTICE_PERIOD)
        fields.append(CONSTANT_FIELD_LEVEL_NAME.CUR_SALARY)

        //   if emp.isServingNotice {
        if emp.offeredSalaryModal.absoluteValue > 0 ||  previousOfferedAbsoluteValue > 0  {
            fields.append(CONSTANT_FIELD_LEVEL_NAME.OFFERED_SALARY)
        }
        //  }
        return fields
    }
    func checkFieldUpdateData(){
        if let emp = self.empDetailArray.first {
            var dataFields = [String]()
            if self.employementFlow == .ViaProfileAdd {
                if emp.isCurrentEmplyement {
                    dataFields.append(contentsOf: self.fieldUpdateForCurrentCase(emp: emp))
                }else{
                    dataFields.append(CONSTANT_FIELD_LEVEL_NAME.WORK_HISTORY)
                }
            }else{
                if (isBeforeUpdateCurrentEmp == emp.isCurrentEmplyement) {
                    if emp.isCurrentEmplyement {
                        dataFields.append(contentsOf: self.fieldUpdateForCurrentCase(emp: emp))
                    }else{
                        dataFields.append(CONSTANT_FIELD_LEVEL_NAME.WORK_HISTORY)
                    }
                }else{
                    dataFields.append(CONSTANT_FIELD_LEVEL_NAME.WORK_HISTORY)
                    dataFields.append(contentsOf: self.fieldUpdateForCurrentCase(emp: emp))
                }
            }
            JobSeekerSingleton.sharedInstance.fieldLevelDataArray = dataFields
        }
    }
}

extension MIEmploymentDetailViewController: UITableViewDataSource,UITableViewDelegate,MILoginFooterViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.empDetailArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.employmentTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowObj  = self.empDetailArray[indexPath.section]
        let title = self.employmentTitle[indexPath.row]
        
        if  title == MIEmploymentDetailViewControllerConstant.companyName || title == MIEmploymentDetailViewControllerConstant.noticePeroid || title == MIEmploymentDetailViewControllerConstant.lastWorkingDay  || title == MIEmploymentDetailViewControllerConstant.offeredDesignation || title == MIEmploymentDetailViewControllerConstant.newCompanyName || title == MIEmploymentDetailViewControllerConstant.selectDate || title == MIEmploymentDetailViewControllerConstant.jobDesignation {
            let cell = tableView.dequeueReusableCell(withClass: MITextFieldTableViewCell.self, for: indexPath)
            cell.primaryTextField.tag = indexPath.row
            cell.primaryTextField.isUserInteractionEnabled = false
            cell.primaryTextField.delegate = self
            cell.secondryTextField.isHidden = true
            cell.titleLabel.text = title
            cell.rightTitleLabel.isHidden = true
            cell.primaryTextField.placeholder = title
            cell.verifyBtn.isHidden = true
            cell.secondryTextField.setRightViewForTextField("darkRightArrow")
            cell.primaryTextField.setRightViewForTextField("darkRightArrow")
            cell.revertTextFields()
            if self.error.index == indexPath.row {
                if error.isPrimaryError {
                    cell.showError(with: self.error.message,animated:false)
                }else{
                    cell.showErrorOnSecondryTF(with: self.error.message,animated: false)
                }
            } else {
                cell.showError(with: "",animated:false)
                cell.showErrorOnSecondryTF(with:"",animated:false)
            }
            
            if title == MIEmploymentDetailViewControllerConstant.jobDesignation {
                cell.primaryTextField.text = rowObj.designationObj.name
            }
            if title == MIEmploymentDetailViewControllerConstant.companyName {
                cell.primaryTextField.text = rowObj.companyObj.name
            }
            if title == MIEmploymentDetailViewControllerConstant.noticePeroid {
                cell.primaryTextField.text = rowObj.noticePeroidDuration
            }
            if title == MIEmploymentDetailViewControllerConstant.lastWorkingDay {
                cell.primaryTextField.text = rowObj.lastWorkingDate?.getStringWithFormat(format: "dd MMM, yyyy")
                cell.primaryTextField.setRightViewForTextField("calendarBlue")
                cell.primaryTextField.isUserInteractionEnabled = true
            }
            if title == MIEmploymentDetailViewControllerConstant.offeredDesignation {
                cell.primaryTextField.text = rowObj.offeredDesignationObj.name
                
            }
            if title == MIEmploymentDetailViewControllerConstant.newCompanyName {
                cell.primaryTextField.text = rowObj.newCompanyObj.name
                
            }
            if title == MIEmploymentDetailViewControllerConstant.selectDate {
                cell.rightTitleLabel.isHidden = false
                cell.titleLabel.text = "From"
                cell.rightTitleLabel.text = "Till"
                cell.secondryTextField.isHidden = false
                cell.makeEqualTextFields()
                cell.primaryTextField.placeholder = "Select Till Date"
                cell.secondryTextField.placeholder = "Select From Date"
                cell.primaryTextField.setRightViewForTextField("calendarBlue")
                cell.secondryTextField.setRightViewForTextField("calendarBlue")
                cell.secondryTextField.isUserInteractionEnabled = true
                cell.secondryTextField.delegate = self
                cell.secondryTextField.text = rowObj.experinceFrom?.getStringWithFormat(format: "MMM, yyyy")
                if rowObj.isCurrentEmplyement {
                    cell.primaryTextField.isUserInteractionEnabled = false
                    cell.primaryTextField.setRightViewForTextField()
                    cell.primaryTextField.text = "Present"
                }else{
                    cell.primaryTextField.isUserInteractionEnabled = true
                    cell.primaryTextField.text = rowObj.experinceTill?.getStringWithFormat(format: "MMM, yyyy")
                    
                }
            }
            return cell
        }
        if title == MIEmploymentDetailViewControllerConstant.jobdescription {
            
            let tvCell = tableView.dequeueReusableCell(withClass: MITextViewTableViewCell.self, for: indexPath)
            tvCell.maxCharaterCount = 1000
            tvCell.textView.text = rowObj.jobTitle
            if tvCell.textView.text.count > 200 {
                tvCell.textView.isScrollEnabled = true
                tvCell.tvContainerViewHtConstraint.constant = 155

            }else{
                tvCell.textView.isScrollEnabled = false
                tvCell.tvContainerViewHtConstraint.constant = 40

            }
            tvCell.textView.isUserInteractionEnabled = true
            tvCell.textView.placeholder = title as NSString
            tvCell.textView.delegate = self
            tvCell.textView.tag = indexPath.row
            tvCell.accessoryImageView.isHidden = true
            tvCell.showCounterLabel = true
            return tvCell
        }
        if title == MIEmploymentDetailViewControllerConstant.currentyWorkinghere {
            if let cell = tableView.dequeueReusableCell(withIdentifier: currentJobCellId) as? MICurrentJobCell {
                cell.titleLbl.text = MIEmploymentDetailViewControllerConstant.currentyWorkinghere
                cell.selectionBtn.isSelected = rowObj.isCurrentEmplyement
                cell.delegate = self
                return cell
            }
        }
        
        if title == MIEmploymentDetailViewControllerConstant.salary || title == MIEmploymentDetailViewControllerConstant.newOfferedSalary {
            let currentSalryCell = tableView.dequeueReusableCell(withClass: MIEmploymentSalaryTableCell.self, for: indexPath)
            currentSalryCell.salaryTxtField.delegate = self
            currentSalryCell.salaryTxtField.tag = indexPath.row
            currentSalryCell.showCalulatedSalary = true
            if title == MIEmploymentDetailViewControllerConstant.salary {
                currentSalryCell.showDataForCurrentSalary(object: rowObj)
                currentSalryCell.title_Lbl.text = "Current Salary"
                currentSalryCell.btn_salaryHideFromEmployer.isHidden = !rowObj.isCurrentEmplyement
                
            }else {
                currentSalryCell.showDataForOfferedSalary(object: rowObj)
                currentSalryCell.btn_salaryHideFromEmployer.isHidden = true
                
            }
            if self.error.index == indexPath.row {
                if error.isPrimaryError {
                    self.showAlert(title: nil, message: self.error.message)
                    //                       currentSalryCell.calculatedSalaryLabel.textColor = Color.errorColor
                    //                       currentSalryCell.calculatedSalaryLabel.isHidden = false
                    //                       currentSalryCell.calculatedSalaryLabel.text = self.error.message
                    //                       currentSalryCell.calculatedSalaryLabel.font = UIFont.customFont(type: .Regular, size: 12)
                }
            } else {
                //currentSalryCell.calculatedSalaryLabel.isHidden = true
                // currentSalryCell.calculatedSalaryLabel.text = ""
            }
            
            //   currentSalryCell.calculatedSalaryLabel.isHidden = false
            currentSalryCell.currencyCallBack = { [weak self](cell,type) in
                guard let wself = self else {return}
                wself.view.endEditing(true)
                
                
                wself.manageError(message: "", indexRow: -1, isPrimary: true)
                wself.selectedIndexPath = wself.tblView.indexPath(for: cell)
                if type == "CURRENCY" {
                    var dataList = [String]()
                    if title == MIEmploymentDetailViewControllerConstant.salary {
                        if !(rowObj.salaryModal.salaryCurrency.isEmpty)  {
                            dataList.append((rowObj.salaryModal.salaryCurrency))
                        }
                    }else {
                        if !(rowObj.offeredSalaryModal.salaryCurrency.isEmpty)  {
                            dataList.append((rowObj.offeredSalaryModal.salaryCurrency))
                        }
                    }
                    
                    wself.pushStaticMasterController(type: .CURRENCY, data: dataList)
                    
                }else if type == "LAKH" {
                    var dataList = [String]()
                    if title == MIEmploymentDetailViewControllerConstant.salary {
                        if !(rowObj.salaryModal.salaryInLakh.isEmpty) {
                            dataList.append(rowObj.salaryModal.salaryInLakh)
                        }
                    }else {
                        if !(rowObj.offeredSalaryModal.salaryInLakh.isEmpty) {
                            dataList.append(rowObj.offeredSalaryModal.salaryInLakh)
                        }
                    }
                    wself.pushStaticMasterController(type: .SALARYINLAKH, data: dataList)
                }else if type == "THOUSAND" {
                    var dataList = [String]()
                    if title == MIEmploymentDetailViewControllerConstant.salary {
                        if !(rowObj.salaryModal.salaryThousand.isEmpty) {
                            dataList.append(rowObj.salaryModal.salaryThousand)
                        }
                    }else {
                        if !(rowObj.offeredSalaryModal.salaryThousand.isEmpty) {
                            dataList.append(rowObj.offeredSalaryModal.salaryThousand)
                        }
                    }
                    wself.pushStaticMasterController(type: .SALARYINTHOUSAND, data: dataList)
                }else if type == "OFFERED_AN" {
                    rowObj.offeredSalaryModal.salaryModeAnually = true
                    rowObj.offeredSalaryModal.salaryMode.uuid = kannuallyModeSalaryUUID
                    rowObj.offeredSalaryModal.salaryMode.name = "Annually"
                    
                }else if type == "OFFERED_MO" {
                    rowObj.offeredSalaryModal.salaryModeAnually = false
                    rowObj.offeredSalaryModal.salaryMode.uuid = kmonthlyModeSalaryUUID
                    rowObj.offeredSalaryModal.salaryMode.name = "Monthly"
                    
                }else if type == "CURRENT_AN" {
                    rowObj.salaryModal.salaryModeAnually = true
                    rowObj.salaryModal.salaryMode.uuid = kannuallyModeSalaryUUID
                    rowObj.salaryModal.salaryMode.name = "Annually"
                    
                }else if type == "CURRENT_MO" {
                    rowObj.salaryModal.salaryModeAnually = false
                    rowObj.salaryModal.salaryMode.uuid = kmonthlyModeSalaryUUID
                    rowObj.salaryModal.salaryMode.name = "Monthly"
                    
                }
            }
            return currentSalryCell
            
        }
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = MIEmptyHeader.header
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndexPath = indexPath
        self.view.endEditing(true)
        let title = self.employmentTitle[indexPath.row]
        self.manageError(message: "", indexRow: -1, isPrimary: true)
        
        if title == MIEmploymentDetailViewControllerConstant.companyName || title == MIEmploymentDetailViewControllerConstant.offeredDesignation || title == MIEmploymentDetailViewControllerConstant.newCompanyName || title == MIEmploymentDetailViewControllerConstant.jobDesignation {
            let secObj = self.empDetailArray[indexPath.section]
            let vc = MIMasterDataSelectionViewController.newInstance
            vc.title = "Search"
            vc.delegate = self
            vc.limitSelectionCount = 1
            if title == MIEmploymentDetailViewControllerConstant.companyName {//For company Master data
                vc.masterType = MasterDataType.COMPANY
                if !secObj.companyObj.name.isEmpty {
                    let tuples = self.getSelectedMasterDataFor(dataSource: [secObj.companyObj])
                    vc.selectedInfoArray = tuples.masterDataNames
                    vc.selectDataArray = tuples.masterDataObject
                }
            }else if title == MIEmploymentDetailViewControllerConstant.jobDesignation {//For Designation Master data
                vc.masterType = MasterDataType.DESIGNATION
                if !secObj.designationObj.name.isEmpty {
                    let tuples = self.getSelectedMasterDataFor(dataSource:[secObj.designationObj])
                    vc.selectedInfoArray = tuples.masterDataNames
                    vc.selectDataArray = tuples.masterDataObject
                }
            }else if title == MIEmploymentDetailViewControllerConstant.offeredDesignation {//For Offered Designation Master data
                vc.masterType = MasterDataType.DESIGNATION
                if !secObj.offeredDesignationObj.name.isEmpty {
                    let tuples = self.getSelectedMasterDataFor(dataSource:[secObj.offeredDesignationObj])
                    vc.selectedInfoArray = tuples.masterDataNames
                    vc.selectDataArray = tuples.masterDataObject
                }
            }else {//For New Company Master data
                vc.masterType = MasterDataType.COMPANY
                if !secObj.newCompanyObj.name.isEmpty {
                    let tuples = self.getSelectedMasterDataFor(dataSource: [secObj.newCompanyObj])
                    vc.selectedInfoArray = tuples.masterDataNames
                    vc.selectDataArray = tuples.masterDataObject
                }
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        if title == MIEmploymentDetailViewControllerConstant.noticePeroid {
            self.view.endEditing(true)
            let sectionObj = self.empDetailArray[(indexPath.section)]
            var dataList = [String]()
            if !sectionObj.noticePeroidDuration.isEmpty {
                dataList = [sectionObj.noticePeroidDuration]
            }
            selectedIndexPath = indexPath
            self.pushStaticMasterController(type: .NOTICEPEROID, data: dataList)
            return
        }
        if title == MIEmploymentDetailViewControllerConstant.currentyWorkinghere {
            let secObj = self.empDetailArray[indexPath.section]
            secObj.isCurrentEmplyement = !secObj.isCurrentEmplyement
            secObj.experinceTill = nil
            secObj.noticePeroidDuration = ""
            _ = self.empDetailArray.map { $0.isServingNotice = false}
            secObj.lastWorkingDate = nil
            secObj.offeredSalaryModal = SalaryDetail()
            secObj.newCompanyObj = MICategorySelectionInfo()
            secObj.offeredDesignationObj = MICategorySelectionInfo()
            
            self.manageTitle()
            self.tblView.reloadData()
        }
        
    }
    
    
    func footerBtnClicked(_ sender: AKLoadingButton) {
        self.view.endEditing(true)
        guard let lastModal = self.empDetailArray.last else {
            return
        }
        if self.validateEmployementData(modelObj: lastModal) {
            self.generateEmploymentData()
            self.tblView.reloadData()
        }
        
    }
    func pushStaticMasterController(type:StaticMasterData,data:[String]) {
        let staticMasterVC = MIStaticMasterDataViewController.newInstance
        staticMasterVC.title = "Selection"
        staticMasterVC.staticMasterType = type
        staticMasterVC.selectedDataArray = data
        staticMasterVC.delagate = self
        self.navigationController?.pushViewController(staticMasterVC, animated: true)
    }
    func getIndexPathFromView(view:UIView) -> IndexPath? {
        let buttonPosition:CGPoint = view.convert(CGPoint.zero, to:self.tblView)
        let indexPath = self.tblView.indexPathForRow(at: buttonPosition)
        selectedIndexPath = indexPath
        return indexPath
    }
    
    
    //MARK: - Helper Methods
    func manageError(message:String,indexRow:Int,isPrimary:Bool) {
        self.error = (message,indexRow,isPrimary)
        if indexRow > -1 {
            self.tblView.reloadData()
            self.tblView.scrollToRow(at: IndexPath(row: indexRow, section: 0), at: .top, animated: false)
        }
    }
    func validateEmployementData(modelObj : MIEmploymentDetailInfo) -> Bool {
        //Check Job Title
        if modelObj.designationObj.name.isEmpty {
            if let index = self.employmentTitle.firstIndex(of: MIEmploymentDetailViewControllerConstant.jobDesignation) {
                self.manageError(message: MIEmploymentDetailViewControllerConstant.emptyJobTitle, indexRow: index, isPrimary: true)
            }
            return false
        }
        
        //Check Company Name
        if modelObj.companyObj.name.isEmpty {
            if let index = self.employmentTitle.firstIndex(of: MIEmploymentDetailViewControllerConstant.companyName) {
                self.manageError(message: MIEmploymentDetailViewControllerConstant.emptyCompanyName, indexRow: index, isPrimary: true)
            }
            return false
        }
        
        //Check From to till date
        if modelObj.experinceFrom == nil {
            if let index = self.employmentTitle.firstIndex(of: MIEmploymentDetailViewControllerConstant.selectDate) {
                self.manageError(message: MIEmploymentDetailViewControllerConstant.emptyFromDate, indexRow: index, isPrimary: false)
            }
            return false
        }
        if modelObj.experinceTill == nil && !modelObj.isCurrentEmplyement{
            if let index = self.employmentTitle.firstIndex(of: MIEmploymentDetailViewControllerConstant.selectDate) {
                self.manageError(message: MIEmploymentDetailViewControllerConstant.emptyTillDate, indexRow: index, isPrimary: true)
            }
            return false
        }
        
        
        //Check is Current employment selected for the section model
        
        if modelObj.isCurrentEmplyement {
            if (modelObj.salaryModal.salaryInLakh.isEmpty && modelObj.salaryModal.salaryThousand.isEmpty) {
                self.showAlert(title: "", message:MIEmploymentDetailViewControllerConstant.emptyCurrentSalary )
                return false
            }
            //Check Notice Peroid
            if modelObj.noticePeroidDuration.isEmpty {
                if let index = self.employmentTitle.firstIndex(of: MIEmploymentDetailViewControllerConstant.noticePeroid) {
                    self.manageError(message: MIEmploymentDetailViewControllerConstant.emptyNoticePeroid, indexRow: index, isPrimary: true)
                }
                return false
            }
            //Check Is serving notice
            
            if modelObj.isServingNotice {
                if modelObj.lastWorkingDate == nil {
                    if let index = self.employmentTitle.firstIndex(of: MIEmploymentDetailViewControllerConstant.lastWorkingDay) {
                        self.manageError(message: MIEmploymentDetailViewControllerConstant.emptyLastWorking, indexRow: index, isPrimary: true)
                    }
                    return false
                }
                else if modelObj.lastWorkingDate != nil {
                    // if modelObj.lastWorkingDate?.compareWithDate(date: Date()) == .orderedAscending {
                    if let index = self.employmentTitle.firstIndex(of: MIEmploymentDetailViewControllerConstant.lastWorkingDay) {
                        let days = Date().getDaysDifferenceBetweenDatesWithComponents(toDate: modelObj.lastWorkingDate ?? Date().minus(days: 3))
                        print(days)
                        if days < 0 {
                            self.manageError(message: MIEmploymentDetailViewControllerConstant.lastWorkingDateMinValue, indexRow: index, isPrimary: true)
                            return false
                        }
                    }
                }
            }
        }
        return true
    }
    
    //MARK: - UITextView Delegate
    func textViewDidChange(_ textView: UITextView) {
        
        let fixedWidth: CGFloat = textView.frame.size.width
        let txtFldPosition = textView.convert(CGPoint.zero, to: self.tblView)
        if  let indexPath = self.tblView.indexPathForRow(at: txtFldPosition) {
            let title = self.employmentTitle[indexPath.row]
            if title == MIEmploymentDetailViewControllerConstant.jobdescription {
                let cell = self.tblView.cellForRow(at: IndexPath(row: indexPath.row , section:indexPath.section)) as! MITextViewTableViewCell
                let newSize: CGSize = textView.sizeThatFits(CGSize(width:fixedWidth,height:.greatestFiniteMagnitude))

                if textView.text.count > 200 {
                    self.tblView.beginUpdates()

//                    var frame = cell.textView.frame
//                    frame.size.height = newSize.height
                    cell.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: cell.frame.size.width, height: 200)
                    cell.tvContainerViewHtConstraint.constant = 140
                    textView.isScrollEnabled = true
                 //   self.tblView.endUpdates()
                    self.tblView.endUpdates()

                    textView.layoutIfNeeded()
                    cell.layoutIfNeeded()
                    return
                }
                self.tblView.beginUpdates()
                textView.isScrollEnabled = false
                cell.tvContainerViewHtConstraint.constant = newSize.height
                var frame = cell.textView.frame
                frame.size.height = newSize.height
                cell.textView.frame = frame
                self.tblView.endUpdates()
                textView.layoutIfNeeded()

                
            }
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        let txtFldPosition = textView.convert(CGPoint.zero, to: self.tblView)
        if let indexPath = self.tblView.indexPathForRow(at: txtFldPosition) {
            let title = self.employmentTitle[indexPath.row]
            if title == MIEmploymentDetailViewControllerConstant.jobdescription {
                let sectionModel = self.empDetailArray[indexPath.section]
                sectionModel.jobTitle = textView.text.withoutWhiteSpace()
            }
            
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "" {
            return true
        }
        let profileTitle = textView.text.appending(text)
        if let index = self.employmentTitle.firstIndex(of: MIEmploymentDetailViewControllerConstant.jobdescription) {
            if profileTitle.count > 1000 {
                DispatchQueue.main.async {
                        self.manageError(message: "Job description can't exceed 1000 charaters.", indexRow: index, isPrimary: true)
                    
                }
                return false
            }else{
                let sectionModel = self.empDetailArray.last
                sectionModel?.jobTitle = profileTitle.withoutWhiteSpace()

            }
            
        }
        
        
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

extension MIEmploymentDetailViewController : CurrentJobSelectionDelegate {
    
    func currentJobSelection(isCurrentJob: Bool, sender: UIButton) {
        
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to:self.tblView)
        let indexPath = self.tblView.indexPathForRow(at: buttonPosition)
        _ = self.empDetailArray.map { $0.isCurrentEmplyement = false}
        _ = self.empDetailArray.map { $0.isServingNotice = false}
        
        let sectionObj = self.empDetailArray[(indexPath?.section)!]
        sectionObj.isCurrentEmplyement = isCurrentJob
        
        //Reset all data for section model when current job option updated
        sectionObj.noticePeroidDuration = ""
        sectionObj.lastWorkingDate = nil
        sectionObj.offeredSalaryModal = SalaryDetail()
        sectionObj.newCompanyObj = MICategorySelectionInfo()
        sectionObj.offeredDesignationObj = MICategorySelectionInfo()
        self.manageTitle()
        self.tblView.reloadData()
    }
    
}

extension MIEmploymentDetailViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.manageError(message: "", indexRow: -1, isPrimary: true)
        textField.autocapitalizationType = .words
        let txtFldPosition = textField.convert(CGPoint.zero, to: self.tblView)
        if let indexPath = self.tblView.indexPathForRow(at: txtFldPosition) {
            let title = self.employmentTitle[indexPath.row]
            if title == MIEmploymentDetailViewControllerConstant.selectDate {
                
                MIDatePicker.selectDate(title: "", hideCancel: false, datePickerMode: .date, selectedDate: nil, minDate:Date().minus(years:50), maxDate: Date()) { [weak self](date) in
                    guard let wself = self else {return}
                    
                    let sectionObj = wself.empDetailArray[indexPath.section]
                    if let cell = wself.tblView.cellForRow(at: indexPath) as? MITextFieldTableViewCell{
                        if textField == cell.secondryTextField {
                            sectionObj.experinceFrom = date
                        }else {
                            sectionObj.experinceTill = date
                        }
                        
                        if sectionObj.experinceTill != nil && sectionObj.experinceFrom != nil {
                            
                            if sectionObj.experinceFrom?.compareWithDate(date: sectionObj.experinceTill!) == .orderedDescending {
                                wself.showAlert(title: "", message: MIEmploymentDetailViewControllerConstant.employmentFromTillDate)
                                sectionObj.experinceTill = nil
                                return
                            }
                        }
                        wself.tblView.reloadData()
                    }
                    
                }
                
                return false
                
            }
            if title == MIEmploymentDetailViewControllerConstant.lastWorkingDay {
                self.view.endEditing(true)
                
                //For last day working
                MIDatePicker.selectDate(title: "", hideCancel: false, datePickerMode: .date, selectedDate:  Date(), minDate: Date(), maxDate: Date().plus(years: 1)) {[weak self] (date) in
                    guard let wself = self else {return}
                    let sectionModel = wself.empDetailArray[(indexPath.section)]
                    sectionModel.lastWorkingDate  = date
                    textField.text = date.getStringWithFormat(format: "dd MMM, yyyy")
                    wself.tblView.reloadData()
                }
                return false
            }
            
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
            textField.returnKeyType = .done
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let txtFldPosition = textField.convert(CGPoint.zero, to: self.tblView)
        if let indexPath = self.tblView.indexPathForRow(at: txtFldPosition) {
            let title = self.employmentTitle[indexPath.row]
            
            if title == MIEmploymentDetailViewControllerConstant.salary {
                let sectionModel = self.empDetailArray[(indexPath.section)]
                sectionModel.salaryModal.salaryInLakh     = textField.text ?? ""
                sectionModel.salaryModal.salaryThousand = ""
            }
            if title == MIEmploymentDetailViewControllerConstant.newOfferedSalary {
                let sectionModel = self.empDetailArray[(indexPath.section)]
                sectionModel.offeredSalaryModal.salaryInLakh     = textField.text ?? ""
                sectionModel.offeredSalaryModal.salaryThousand = ""
            }
            self.tblView.reloadData()
        }
        UIView.animate(withDuration: 0.3) {
            self.setMainViewFrame(originY: 0)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let searchString = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
        let txtFldPosition = textField.convert(CGPoint.zero, to: self.tblView)
        let indexPath = self.tblView.indexPathForRow(at: txtFldPosition)
        let title = self.employmentTitle[indexPath!.row]
        if string == "" {
            return true
        }
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
        return false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

//extension MIEmploymentDetailViewController : SalaryOptionSelectionDelegate {
//    
//    func optionSelectedWith(value: String, sender: UIButton, type: SalaryOptionPicked) {
//        
//        let cgPoint = sender.convert(CGPoint.zero, to: self.tblView)
//        let indexPath = self.tblView.indexPathForRow(at: cgPoint)
//        let sectionModel = self.empDetailArray[(indexPath?.section)!]
//        let title = self.employmentTitle[indexPath!.row]
//        
//        switch type {
//        case .Currency:
//            (title == MIEmploymentDetailViewControllerConstant.salary) ? (sectionModel.salaryModal.salaryCurrency = value) : (sectionModel.offeredSalaryModal.salaryCurrency = value)
//        case .Lakh:
//            (title == MIEmploymentDetailViewControllerConstant.salary) ? (sectionModel.salaryModal.salaryInLakh = value) : (sectionModel.offeredSalaryModal.salaryInLakh = value)
//        case .Thousand:
//            (title == MIEmploymentDetailViewControllerConstant.salary) ? (sectionModel.salaryModal.salaryThousand = value) : (sectionModel.offeredSalaryModal.salaryThousand = value)
//        }
//        self.tblView.reloadData()
//    }
//    
//}

extension MIEmploymentDetailViewController :  MIMasterDataSelectionViewControllerDelegate {
    
    func masterDataSelected(selectedCategoryInfo: [MICategorySelectionInfo], selectedListInfo: [String], enumName: String) {
        
        if let sectionPath  = selectedIndexPath {
            let sectionModel = self.empDetailArray[sectionPath.section]
            let title = self.employmentTitle[sectionPath.row]
            
            if title == MIEmploymentDetailViewControllerConstant.companyName {
                sectionModel.companyObj = selectedCategoryInfo.first ?? MICategorySelectionInfo()
                masterData[enumName] = selectedCategoryInfo
            }else if title == MIEmploymentDetailViewControllerConstant.jobDesignation {
                sectionModel.designationObj = selectedCategoryInfo.first ?? MICategorySelectionInfo()
                masterData[enumName] = selectedCategoryInfo
            }else if title == MIEmploymentDetailViewControllerConstant.offeredDesignation {
                sectionModel.offeredDesignationObj = selectedCategoryInfo.first ?? MICategorySelectionInfo()
                masterData[enumName] = selectedCategoryInfo
            }else {
                sectionModel.newCompanyObj = selectedCategoryInfo.first ?? MICategorySelectionInfo()
                masterData[MIEmploymentDetailViewControllerConstant.newCompanyName] = selectedCategoryInfo
            }
            self.tblView.reloadData()
        }
        selectedIndexPath = nil
        
    }
}

extension MIEmploymentDetailViewController : MIStaticMasterDataSelectionDelegate {
    func staticMasterDataSelected(selectedData: [String], masterType: String) {
        let data =   selectedData.joined(separator: ",").withoutWhiteSpace()
        
        if let index = selectedIndexPath {
            let sectionModel = empDetailArray[(index.section)]
            let title = self.employmentTitle[index.row]
            
            if StaticMasterData.SALARYINTHOUSAND.rawValue == masterType {
                if title == MIEmploymentDetailViewControllerConstant.salary {
                    sectionModel.salaryModal.salaryThousand = data
                }else{
                    sectionModel.offeredSalaryModal.salaryThousand = data
                    sectionModel.offeredSalaryModal.absoluteValue = 0
                    
                }
            }else if StaticMasterData.SALARYINLAKH.rawValue == masterType {
                if title == MIEmploymentDetailViewControllerConstant.salary {
                    sectionModel.salaryModal.salaryInLakh = data
                }else{
                    sectionModel.offeredSalaryModal.salaryInLakh = data
                    sectionModel.offeredSalaryModal.absoluteValue = 0
                    
                }
            }else if StaticMasterData.CURRENCY.rawValue == masterType {
                
                if title == MIEmploymentDetailViewControllerConstant.salary {
                    sectionModel.salaryModal.salaryThousand = ""
                    sectionModel.salaryModal.salaryInLakh = ""
                    sectionModel.salaryModal.salaryCurrency = data
                }else{
                    sectionModel.offeredSalaryModal.salaryInLakh = ""
                    sectionModel.offeredSalaryModal.salaryThousand = ""
                    sectionModel.offeredSalaryModal.absoluteValue = 0
                    sectionModel.offeredSalaryModal.salaryCurrency = data
                    
                    
                }
            }else if StaticMasterData.NOTICEPEROID.rawValue == masterType {
                if sectionModel.noticePeroidDuration != data {
                    sectionModel.lastWorkingDate = nil
                    sectionModel.offeredSalaryModal = SalaryDetail()
                    sectionModel.offeredDesignationObj = MICategorySelectionInfo()
                    sectionModel.newCompanyObj = MICategorySelectionInfo()
                }
                sectionModel.noticePeroidDuration = data
                sectionModel.isServingNotice = false
                
                if sectionModel.noticePeroidDuration == "Serving Notice Period" {
                    sectionModel.isServingNotice = true
                }
                self.manageTitle()
                
            }
        }
        self.tblView.reloadData()
        selectedIndexPath = nil
        
    }
    
}
