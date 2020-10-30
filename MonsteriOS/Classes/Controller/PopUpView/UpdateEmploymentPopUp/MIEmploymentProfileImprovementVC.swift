//
//  MIEmploymentProfileImprovementVC.swift
//  MonsteriOS
//
//  Created by Rakesh on 16/09/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIEmploymentProfileImprovementVC: UIViewController {
    
    
    @IBOutlet weak var empTblView: UITableView!
    var headerView = MIProfileImprovementHeader.header
    //let footer = MISingleButtonView.singleBtnView
    let footer = MIDoubleButtonView.doubleBtnView
    var fieldSource = [String]() {
        didSet {
            self.manageTableViewToCenter()
        }
    }
    var model = MIEmploymentDetailInfo()
    var oldEmployment : MIEmploymentDetailInfo?
    var card: Card?
    var viewLoadDate:Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.empTblView.delegate = self
        self.empTblView.dataSource = self
        empTblView.register(UINib(nibName:String(describing: MITextFieldTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MITextFieldTableViewCell.self))
        
        if let cardData = card?.data as? [[String:Any]] {
            let oldData = MIEmploymentDetailInfo.getModelFromDataSource(employmentDataList: cardData)
            if  let firstemp = oldData.first {
                oldEmployment = firstemp
            }
        }
        viewLoadDate = Date()
        self.setUpViewOnLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.manageNavigationOnAppearDisappear(isShow: true)
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.manageNavigationOnAppearDisappear(isShow: false)
    }
    func manageNavigationOnAppearDisappear(isShow:Bool){
        self.title = ""
        self.navigationItem.hidesBackButton = isShow
        self.navigationController?.isNavigationBarHidden = isShow

    }
    func setUpViewOnLoad(){
        
        headerView.setHeaderViewWithTitle(title: "Update Current Employment", imgName: "card")
        self.showAttributtedForResume()
        empTblView.tableHeaderView = headerView
      
        footer.backgroundColor = .white
        footer.btn_next.setTitle("UPDATE", for: .normal)
        footer.btn_addAnother.setTitle("NO CHANGE REQUIRED", for: .normal)
        footer.btn_next.showSecondaryBtnLayout()
        footer.btn_addAnother.showSecondaryBtnLayout(fontSize: 16, bgColor: UIColor(hex: "727272"))
        footer.btnSecondryHtConstraint.constant = 44
        footer.btn_leadingConstraint.constant = 15
        footer.btn_trailingConstairnt.constant = 15
        footer.btnAddAnother_leadingConstraint.constant = 13
        footer.btnAddAnother_trailingConstairnt.constant = 13
        self.footer.nxtBtnTopConsttaint.constant = 16

        empTblView.tableFooterView = footer
      
        if let old = oldEmployment {
            model.designationObj = old.designationObj
            model.companyObj = old.companyObj
            model.noticePeroidDuration = old.noticePeroidDuration
            if model.noticePeroidDuration == NoticePeroid.Serving_Notice_Peroid.rawValue {
                model.isServingNotice = true
            }
            model.lastWorkingDate = old.lastWorkingDate
            model.sinceYear = old.sinceYear
            if old.sinceMonth.count > 0 {
                model.sinceMonth = old.sinceMonth.getMonthNameFromNumber()
            }
        }
        footer.addAnotherCallBack = {[weak self] in
            if let wSelf  = self {
                wSelf.callAPIForAddUpdateEmployment(isNoChange: true)
            }
        }
        footer.nextBtnCallBack = { [weak self] in
            if let wSelf  = self {
                if wSelf.validateEmployementData() {
                    wSelf.callAPIForAddUpdateEmployment(isNoChange: false)
                }
            }
        }
        fieldSource = ["I am currently working as"]
    }
    func showAttributtedForResume(){
        let percentage = "68% "
        let resume = NSMutableAttributedString(string:"Surveys indicate that ", attributes: [NSAttributedString.Key.foregroundColor:UIColor(hex: "505050"),NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 13)])
        let mostImp = NSAttributedString(string:percentage, attributes: [NSAttributedString.Key.foregroundColor:UIColor(hex: "505050"),NSAttributedString.Key.font:UIFont.customFont(type: .Semibold, size: 13)])
        let document = NSMutableAttributedString(string:"of recruiters search candidates based on role/designation", attributes: [NSAttributedString.Key.foregroundColor:UIColor(hex: "505050"),NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 13)])
        
        resume.append(mostImp)
        resume.append(document)
        headerView.lbl_description.attributedText = resume
        
    }
    func manageFieldData() {
        if model.isServingNotice{
            fieldSource = ["I am currently working as","at","since","having notice peroid of","my last day is"]
        }else{
            fieldSource = ["I am currently working as","at","since","having notice peroid of"]
        }
    }
  
    func manageTableViewToCenter() {
        
        if !kIsiPhone5s {
            let viewHeight: CGFloat = view.frame.size.height
            let tableViewContentHeight: CGFloat = empTblView.contentSize.height
            let marginHeight: CGFloat = (viewHeight - tableViewContentHeight) / 4.0
            
            self.empTblView.contentInset = (fieldSource.count < 2) ? UIEdgeInsets(top: marginHeight, left: 0, bottom:  -marginHeight, right: 0) : UIEdgeInsets(top: 0, left: 0, bottom:0, right: 0)

        }
    }
    
    var error: (message: String, index: Int,isPrimaryError:Bool) = ("", -1,false)
   
    func showErrorOnTableViewIndex(indexPath:IndexPath,errorMsg:String,isPrimary:Bool) {
        self.error = (errorMsg, indexPath.row,isPrimary)
        self.empTblView.reloadData()
    }
    
    func validateEmployementData() -> Bool{
        self.error = ("", -1,false)
        if model.designationObj.name.isEmpty {
            if let index = self.fieldSource.firstIndex(of: "I am currently working as") {
                let indexPath = IndexPath(row: index, section: 0)
                self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: MIEmploymentDetailViewControllerConstant.emptyMostRecentDesignation, isPrimary: true)
            }
            
            return false
        }
        if self.fieldSource.count == 1 {
            return true
        }
        //Check Company Name
        if model.companyObj.name.isEmpty {
            if let index = self.fieldSource.firstIndex(of: "at") {
                let indexPath = IndexPath(row: index, section: 0)
                self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: MIEmploymentDetailViewControllerConstant.emptyMostRecentCompanyName, isPrimary: true)
            }
            return false
        }
        
        //Check From to till date
        if model.sinceYear.count == 0  {
            if let index = self.fieldSource.firstIndex(of: "since") {
                let indexPath = IndexPath(row: index, section: 0)
                self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: "Please select the year.", isPrimary: false)
            }
            return false
        }
        if  model.sinceMonth.count == 0 {
            if let index = self.fieldSource.firstIndex(of: "since") {
                let indexPath = IndexPath(row: index, section: 0)
                self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: "Please select the month.", isPrimary: true)
            }
            return false
        }
        
        if model.noticePeroidDuration.isEmpty {
            if let index = self.fieldSource.firstIndex(of: "having notice peroid of") {
                let indexPath = IndexPath(row: index, section: 0)
                self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg:MIEmploymentDetailViewControllerConstant.emptyNoticePeroid, isPrimary: true )
            }
            return false
        }
        //Check Is serving notice
        if model.isServingNotice {
            if model.lastWorkingDate == nil {
                if let index = self.fieldSource.firstIndex(of: "my last day is") {
                    let indexPath = IndexPath(row: index, section: 0)
                    self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg:MIEmploymentDetailViewControllerConstant.emptyLastWorking, isPrimary: true )
                }
                return false
            }
        }
        return true
    }
    @IBAction func remindMeLater(_ sender:UIButton) {
        self.callAPIForSkip()
    }
}
extension MIEmploymentProfileImprovementVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: MITextFieldTableViewCell.self, for: indexPath)
        cell.secondryTextField.isHidden = true
        cell.titleLabel.text = fieldSource[indexPath.row]
        cell.primaryTextField.delegate = self
        
        if self.error.index == indexPath.row {
            if error.isPrimaryError {
                cell.showError(with: self.error.message)
            }else{
                cell.showErrorOnSecondryTF(with: self.error.message)
            }
        
        } else {
            cell.showError(with: "")
            cell.showErrorOnSecondryTF(with:"")
        }
        
        if fieldSource[indexPath.row] == "I am currently working as" {
            cell.primaryTextField.text = model.designationObj.name
            cell.primaryTextField.placeholder = "Current Designation"

        }else if fieldSource[indexPath.row] == "at" {
            cell.primaryTextField.text = model.companyObj.name
            cell.primaryTextField.placeholder = "Current Company"

        }else if fieldSource[indexPath.row] == "since" {
            cell.secondryTextField.isHidden = false
            cell.secondryTextField.placeholder = "Since Year"
            cell.primaryTextField.placeholder = "Since Month"
            cell.secondryTextField.text = model.sinceYear
            cell.primaryTextField.text = model.sinceMonth

            cell.secondryTextFieldAction = { [weak self,weak cell]  txtFld in
                guard let wself = self,let wcell = cell  else  {return false}
                AKMultiPicker.openPickerIn(wcell.secondryTextField, firstComponentArray: sinceYear) {   (fValue, sValue, fIndex, sIndex) in
                    wself.model.sinceYear = fValue
                    wcell.secondryTextField.text = fValue
                    if Date().getCurrentYear() == Int(wself.model.sinceYear) {
                        if wself.model.sinceMonth.count > 0 {
                            if wself.model.sinceMonth.getMonthNumberFromName() >  Int(Date().getCurrentMonthNumber()) ?? 0  {
                                wself.model.sinceMonth = ""
                                wcell.primaryTextField.text = ""
                            }
                        }
                    }
                }
                return true
            }
            cell.makeEqualTextFields()

        }else if fieldSource[indexPath.row] == "having notice peroid of" {
            cell.primaryTextField.text = model.noticePeroidDuration
            cell.primaryTextField.placeholder = "Notice Peroid"
        }else if fieldSource[indexPath.row] == "my last day is" {
            cell.primaryTextField.text = model.lastWorkingDate?.getStringWithFormat(format: "dd MMM, yyyy")
            cell.primaryTextField.placeholder = "Last Working Day"
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fieldSource.count
    }
}
extension MIEmploymentProfileImprovementVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool  {
        
        guard let indexPath = textField.tableViewIndexPath(self.empTblView) else { return true }
        let title = fieldSource[indexPath.row]
        if title == "I am currently working as" {
            self.pushToMasterDataSelection(fieldName: title, selectionLimit: 1, model:model )
        }else if title == "at" {
            self.pushToMasterDataSelection(fieldName: title, selectionLimit: 1, model:model )
        }else if title == "since" {
            guard let cell = self.empTblView.cellForRow(at: indexPath) as? MITextFieldTableViewCell else{
                return false
            }
            if cell.primaryTextField == textField {
                if self.model.sinceYear.isEmpty {
                    error = ("Please select since year first.",indexPath.row,false)
                    self.empTblView.reloadData()
                    return false
                }
                let yearMonth = ["January","February","March","April","May","June","July","August","September","October","November","December"]
                AKMultiPicker.openPickerIn(cell.primaryTextField, firstComponentArray: yearMonth) { [weak self]  (fValue, sValue, fIndex, sIndex) in
                    
                    guard let wself = self  else  {return}
                    wself.error = ("",-1,false)
                    wself.model.sinceMonth = ""
                    if Date().getCurrentYear() == Int(wself.model.sinceYear) {
                        let index = ((fIndex ?? 0) + 1)
                        let month = Int(Date().getCurrentMonthNumber()) ?? 0
                        if index <=  month  {
                            wself.model.sinceMonth = fValue
                        }else{
                            wself.error = ("Month should be less than current month",indexPath.row,true)
                        }
                    }else{
                        wself.model.sinceMonth = fValue
                    }
                    wself.empTblView.reloadData()
                }
            }
            return true

        }else if title == "having notice peroid of" {
            self.pushStaticMasterController(type: .NOTICEPEROID, data: model.noticePeroidDuration.count > 0 ? [model.noticePeroidDuration] : [])
        }else if title == "my last day is" {
            //For last day working
            MIDatePicker.selectDate(title: "", hideCancel: false, datePickerMode: .date, selectedDate: Date(), minDate: Date(), maxDate: Date().plus(years: 1)) {[weak self] (date) in
                guard let wself = self  else  {return}
                wself.model.lastWorkingDate  = date
                wself.error = ("",-1,false)
                wself.empTblView.reloadData()
            }
        }
        return false
    }
    func pushStaticMasterController(type:StaticMasterData,data:[String]) {
        let staticMasterVC = MIStaticMasterDataViewController.newInstance
        staticMasterVC.title = "Selection"
        staticMasterVC.staticMasterType = type
        staticMasterVC.selectedDataArray = data
        staticMasterVC.selectedData = { [weak self] value in
            if let wSelf = self {
                    wSelf.error = ("",-1,false)
                
                    if let index = wSelf.fieldSource.firstIndex(of: "having notice peroid of") {
                        let indexPath = IndexPath(row: index, section: 0)
                        wSelf.error = (value.count == 0) ? (MIEmploymentDetailViewControllerConstant.emptyNoticePeroid,indexPath.row,true) :  ("",-1,false)
                    }
                    wSelf.model.noticePeroidDuration = value
                    wSelf.model.isServingNotice = false
                    if value == NoticePeroid.Serving_Notice_Peroid.rawValue {
                        wSelf.model.isServingNotice = true
                    }
                    wSelf.model.lastWorkingDate = nil
                    wSelf.manageFieldData()
                    wSelf.empTblView.reloadData()
            }
        }
        self.navigationController?.pushViewController(staticMasterVC, animated: true)
    }
    func pushToMasterDataSelection(fieldName:String,selectionLimit:Int,model:MIEmploymentDetailInfo) {
        let vc = MIMasterDataSelectionViewController.newInstance
        vc.delegate = self
        vc.limitSelectionCount = selectionLimit
        if fieldName == "I am currently working as" {
            vc.masterType = .DESIGNATION
            if !model.designationObj.name.isEmpty {
                vc.selectDataArray  = [model.designationObj]
                vc.selectedInfoArray = [model.designationObj.name]
            }
        }
        if fieldName == "at" {
            vc.masterType = .COMPANY
            if !model.companyObj.name.isEmpty {
                vc.selectDataArray  = [model.companyObj]
                vc.selectedInfoArray = [model.companyObj.name]
            }
        }
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func callAPIForAddUpdateEmployment(isNoChange:Bool){
        var params = [[String:Any]]()
        var serviceType : ServiceMethod = .put
        
        var modelData = MIEmploymentDetailInfo()
        if let old = oldEmployment{
            modelData = old
        }
        
        if !isNoChange {
            serviceType = .post
            self.model.employmentId = ""
            
            if (model.designationObj.uuid == oldEmployment?.designationObj.uuid) && model.companyObj.uuid == oldEmployment?.companyObj.uuid {
                serviceType = .put
                if let old = oldEmployment {
                    self.model.employmentId = old.employmentId
                }
            }
            modelData = self.model
        }
        modelData.isCurrentEmplyement = true
        let data = MIEmploymentDetailInfo.getEmploymentJSONForProfileImprovment(modal:modelData)
        params.append(data)
        let headerDict = [
            "x-rule-applied": card?.ruleApplied ?? "",
            "x-rule-version": card?.ruleVersion ?? ""
        ]
       // MIActivityLoader.showLoader()
        let added = self.addTaskToDispatchGroup()
        MIApiManager.callAPIForUpdateEmploymentEducation(methodType: serviceType, path: APIPath.updateEmploymentDetailApiEndpoint, params: params,customHeaderParams: headerDict ) { (success, response, error, code) in
            DispatchQueue.main.async {
                defer { self.leaveDispatchGroup(added) }

                if error == nil && (code >= 200) && (code <= 299) {
                    self.checkFieldUpdate(newValue: modelData)

                    if let tabbar = self.tabbarController {
                        tabbar.handlePopFinalState(isErrorHappen: false)
                    }
                    
                }else{
                    if let tabbar = self.tabbarController {
                        tabbar.isErrorOccuredOnProfileEngagement = true
                    }
                }

            }
        }
        self.callAPIForEventTracking(updated: 1, remindMeLater: 0, isCallViaNoUpdateRequired: isNoChange)
        self.skipProfileEngagementPopup()

    }
    
    func checkFieldUpdate(newValue:MIEmploymentDetailInfo) {
      
        var fieldChanged = [String]()
        if oldEmployment?.designationObj.name.lowercased() != newValue.designationObj.name.lowercased(){
            fieldChanged.append(CONSTANT_FIELD_LEVEL_NAME.CUR_DESIGNATION)
        }
        if oldEmployment?.noticePeroidDuration.lowercased() != newValue.noticePeroidDuration.lowercased(){
            fieldChanged.append(CONSTANT_FIELD_LEVEL_NAME.NOTICE_PERIOD)
        }
        if ((oldEmployment?.companyObj.name.lowercased() != newValue.companyObj.name.lowercased()) || (oldEmployment?.experinceFrom?.compareWithDate(date: newValue.experinceFrom ?? Date()) != .orderedSame ) ){
            fieldChanged.append(CONSTANT_FIELD_LEVEL_NAME.WORK_HISTORY)
        }
      
        JobSeekerSingleton.sharedInstance.fieldLevelDataArray = fieldChanged
    }
    
    func callAPIForSkip(){
        if let card = self.card {

            let headerDict = [
                "x-rule-applied": card.ruleApplied ?? "",
                "x-rule-version": card.ruleVersion ?? ""
            ]
            MIApiManager.hitRemindMeLaterApi(card.type, userActions: card.text, headerDict: headerDict) { (success, response, error, code) in
//                DispatchQueue.main.async {
//                //    MIActivityLoader.hideLoader()
//                   
//                    if error == nil && (code >= 200) && (code <= 299) {
//                    }else{
//                        //self.handleAPIError(errorParams: response, error: error)
//                    }
//
//                }
            }
            self.callAPIForEventTracking(updated: 0, remindMeLater: 1, isCallViaNoUpdateRequired: false)
            self.skipProfileEngagementPopup()

        }
        
    }
    
    func callAPIForEventTracking(updated: Int, remindMeLater: Int, isCallViaNoUpdateRequired:Bool) {
        
        var oldData = [String:Any]()
        var newData = [String:Any]()
        oldData["curEmployment"] = [String:Any]()
        newData["curEmployment"] = [String:Any]()

        if !isCallViaNoUpdateRequired {
            if updated == 1 {
                if let old = oldEmployment {
                 //   oldData =  MIEmploymentDetailInfo.getEmploymentJSONForProfileImprovment(modal:old)
                   
                    oldData["curEmployment"] = ["designation":old.designationObj.name,"company":old.companyObj.name,"year":old.sinceYear.isNumeric ? Int(old.sinceYear) as Any  : nil,"month":old.sinceMonth.getMonthNumberFromName(),"noticePeriod":NoticePeroid(rawValue: old.noticePeroidDuration)?.days as Any ]
                    
                }
                newData["curEmployment"] = ["designation":model.designationObj.name,"company":model.companyObj.name,"year":model.sinceYear.isNumeric ? Int(model.sinceYear) as Any  : nil ,"month":model.sinceMonth.getMonthNumberFromName(),"noticePeriod":NoticePeroid(rawValue: model.noticePeroidDuration)?.days as Any ]
            }
        }
       
        MIApiManager.hitTrackingEventsApi("DESIGNATION", updated: updated, remindMeLater: remindMeLater, oldValue: oldData, newValue: newData, timeSpent: viewLoadDate.getSecondDifferenceBetweenDates(), cardRule: card) { (success, response, error, code) in
            
        }
    }
}

extension MIEmploymentProfileImprovementVC :MIMasterDataSelectionViewControllerDelegate {
    
    func masterDataSelected(selectedCategoryInfo: [MICategorySelectionInfo], selectedListInfo: [String], enumName: String) {

        if enumName == MasterDataType.DESIGNATION.rawValue {
            model.designationObj = selectedCategoryInfo.first ?? MICategorySelectionInfo()
            if model.designationObj.name.count > 0 {
                error = ("",-1,false)
                self.manageFieldData()
            }

        }
        if enumName == MasterDataType.COMPANY.rawValue {
            model.companyObj = selectedCategoryInfo.first ?? MICategorySelectionInfo()
            if model.companyObj.name.count > 0 {
                error = ("",-1,false)
            }
        }
        self.empTblView.reloadData()
    }
}
