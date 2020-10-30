//
//  MIJobPreferenceViewController.swift
//  MonsteriOS
//
//  Created by Monster on 01/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//  From: Profile

import UIKit

struct MIJobPreferenceViewControllerConstant {
    static let title = "Job Preferences"
    static let profileTitle = "Profile Title"
    static let profileImage = "Profile Image"
    static let preferredIndu = "Preferred Industry"
    static let preferredFunc = "Preferred Function"
    static let preferredRole = "Preferred Role(s)"
    static let preferredLoc   = "Preferred Location(s)"
    static let residentStatus = "Resident Status"
    static let workAuthorization = "Work Authorization"
    static let preferredJobType  = "Preferred Job Type"
    static let preferredEmploymentType = "Preferred Employment Type"
    static let preferredShift = "Preferred Shift"
    static let preferredExpectedSalary = "Preferred Expected Salary"
    static let preferredSixDayWorking = "Are you willing to work 6 days a week?"
    static let preferredStartUpJoin = "Are you open to joining early stage startup?"
    
    //Alert Messages
    static let emptyProfileTitle = "Please enter your profile title."
    static let emptyjobIndustry = "Please select your preferred job industry."
    static let emptyJobFunction = "Please select your preferred job function."
    static let emptyJobRole = "Please select your preferred job role."
    static let emptyJobLocations = "Please select your preferred job locations."
    static let emptyEmploymentType = "Please select your employment type."
    static let emptyJobType = "Please select your job type."
}

class MIJobPreferenceViewController: MIBaseViewController {
    
    @IBOutlet weak private var progressView: UIView!
    @IBOutlet weak private var tblView: UITableView!
    @IBOutlet weak private var nextBtn: UIButton!
    @IBOutlet weak private var segmentHtConstraint: NSLayoutConstraint!
    
    var isFormFreshOrExper:ProfessionalDetailsEnum = .Fresher
    private let cellId             = "MICreateAlertTextViewCell"
    private let tblHeader          = MIProgressView.header
    private var tFooter            = MILoginFooterView.header
    var selectedIndex : IndexPath?
    
    var flowVia : FlowVia = .ViaRegister
    var jobpreferenceSuccessAction : ((Bool)-> Void)?
    var jobpreferenceSuccessPendingAction : ((Bool,MIJobPreferencesModel)-> Void)?
    var jobPreferenceModel =  MIJobPreferencesModel()
    var jobPreferenceModelBefore :  MIJobPreferencesModel?

   // let popup = MIJobPreferencePopup.popup()
    var isPopOnView = false
    var error: (message: String, index: Int,isPrimaryError:Bool) = ("", -1,false)
    var placeHolderValue = [String]()
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CommonClass.googleAnalyticsScreen(self) //GA for Screen
        self.title = MIJobPreferenceViewControllerConstant.title
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

    }
    
    class var newInstance:MIJobPreferenceViewController {
        get {
            return Storyboard.main.instantiateViewController(withIdentifier: "MIJobPreferenceViewController") as! MIJobPreferenceViewController
        }
    }
    
    func setUI() {
        
        
        if flowVia == .ViaPendingAction {
            placeHolderValue = [MIJobPreferenceViewControllerConstant.preferredIndu,MIJobPreferenceViewControllerConstant.preferredFunc,MIJobPreferenceViewControllerConstant.preferredRole,MIJobPreferenceViewControllerConstant.preferredLoc]
        }else{
            placeHolderValue = [MIJobPreferenceViewControllerConstant.preferredIndu,MIJobPreferenceViewControllerConstant.preferredFunc,MIJobPreferenceViewControllerConstant.preferredRole,MIJobPreferenceViewControllerConstant.preferredLoc,MIJobPreferenceViewControllerConstant.preferredJobType,MIJobPreferenceViewControllerConstant.preferredEmploymentType,MIJobPreferenceViewControllerConstant.preferredShift,MIJobPreferenceViewControllerConstant.preferredExpectedSalary,MIJobPreferenceViewControllerConstant.preferredSixDayWorking,MIJobPreferenceViewControllerConstant.preferredStartUpJoin]
            
        }
        
        self.segmentHtConstraint.constant = 0
        progressView.isHidden = true
        nextBtn.setTitle("Save", for: .normal)
        if let site = AppDelegate.instance.site {
            jobPreferenceModel.expectedSalary.salaryCurrency = site.defaultCurrencyDetails.currency?.isoCode ?? ""
        }
        if self.flowVia != .ViaProfileAdd {
            self.callAPIForGetJobPreferences()
        }
        
        
        nextBtn.showPrimaryBtn()
        tblView.register(UINib(nibName:String(describing: MITextViewTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MITextViewTableViewCell.self))
        tblView.register(UINib(nibName:String(describing: MITextFieldTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MITextFieldTableViewCell.self))
        tblView.register(UINib(nibName:String(describing: MI3RadioButtonTableCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MI3RadioButtonTableCell.self))
        tblView.register(UINib(nibName:String(describing: MIEmploymentSalaryTableCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MIEmploymentSalaryTableCell.self))
        
        tblView.keyboardDismissMode = .onDrag
        tblView.estimatedRowHeight = tblView.rowHeight
        tblView.rowHeight = UITableView.automaticDimension
        tblView.estimatedSectionHeaderHeight = tblView.sectionHeaderHeight
        tblView.sectionHeaderHeight = UITableView.automaticDimension
        self.tblView.reloadData()
    }
    //Validate Fields
    func manageError(message:String,indexRow:Int,isPrimary:Bool) {
        self.error = (message,indexRow,isPrimary)
        if indexRow > -1 {
            self.tblView.reloadData()
            self.tblView.scrollToRow(at: IndexPath(row: indexRow, section: 0), at: .top, animated: false)
            
        }
    }
    func validateJobPreferences() -> Bool {
        self.manageError(message: "", indexRow: -1, isPrimary: true)

        if jobPreferenceModel.preferredIndustrys.count == 0 {
            if let index = self.placeHolderValue.firstIndex(of: MIJobPreferenceViewControllerConstant.preferredIndu) {
                self.manageError(message: MIJobPreferenceViewControllerConstant.emptyjobIndustry, indexRow: index, isPrimary: true)
            }
            return false
        }else if jobPreferenceModel.preferredFunctions.count == 0 {
            if let index = self.placeHolderValue.firstIndex(of: MIJobPreferenceViewControllerConstant.preferredFunc) {
                self.manageError(message: MIJobPreferenceViewControllerConstant.emptyJobFunction, indexRow: index, isPrimary: true)
            }
            return false
        }else if jobPreferenceModel.preferredLocationList.count == 0 {
            if let index = self.placeHolderValue.firstIndex(of: MIJobPreferenceViewControllerConstant.preferredLoc) {
                self.manageError(message: MIJobPreferenceViewControllerConstant.emptyJobLocations, indexRow: index, isPrimary: true)
            }
            return false
        }else if jobPreferenceModel.preferredJobType.name.count == 0 && flowVia != .ViaPendingAction  {
            self.showAlert(title: "", message: MIJobPreferenceViewControllerConstant.emptyJobType)
            return false
        }else if jobPreferenceModel.preferredEmploymentType.name.count == 0 && flowVia != .ViaPendingAction {
            self.showAlert(title: "", message: MIJobPreferenceViewControllerConstant.emptyEmploymentType)
            return false
        }
        return true
        
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
    func getIndexPathFromView(view:UIView) -> IndexPath? {
        let buttonPosition:CGPoint = view.convert(CGPoint.zero, to:self.tblView)
        let indexPath = self.tblView.indexPathForRow(at: buttonPosition)
        return indexPath
    }
    //MARK: - Button Clicked Actions
    @IBAction func nextClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if flowVia == .ViaProfileAdd || flowVia == .ViaProfileEdit || flowVia == .ViaPendingAction {
            self.checkValidationAndSubmit()
        }
        
    }
    func checkValidationAndSubmit() {
        if self.validateJobPreferences() {
            self.callApiforJobPreference()
            
        }
    }
    @objc func yesBtnCLicked(_ sender:UIButton){
        if let indexPath = self.getIndexPathFromView(view: sender) {
            
            if placeHolderValue[indexPath.row] == MIJobPreferenceViewControllerConstant.preferredSixDayWorking {
                self.jobPreferenceModel.willingToWorkSixDay = true
            }
            
            if  placeHolderValue[indexPath.row] == MIJobPreferenceViewControllerConstant.preferredStartUpJoin {
                self.jobPreferenceModel.openToWorkWithStartUp = true
            }
        }
        self.tblView.reloadData()
    }
    
    @objc func noBtnCLicked(_ sender:UIButton){
        if let indexPath = self.getIndexPathFromView(view: sender) {
            if placeHolderValue[indexPath.row] == MIJobPreferenceViewControllerConstant.preferredSixDayWorking {
                self.jobPreferenceModel.willingToWorkSixDay = false
            }
            if  placeHolderValue[indexPath.row] == MIJobPreferenceViewControllerConstant.preferredStartUpJoin {
                self.jobPreferenceModel.openToWorkWithStartUp = false
            }
        }
        self.tblView.reloadData()
    }

    
    //MARK: - API Helper Methods
    func callAPIForGetJobPreferences() {
        self.startActivityIndicator()
        
        MIApiManager.callAPIForGetPersonalDetail(methodType: .get, path: APIPath.jobPreferenceGETApiEndpoint) { [weak self] (success, response, error, code) in
            
            DispatchQueue.main.async {
                guard let wself = self else {return}
                wself.stopActivityIndicator()
                
                if error == nil && (code >= 200) && (code <= 299) {
                    if let result = response as? [String:Any] {
                        if let jobPreferenceSection = result[APIKeys.jobPreferenceSectionAPIKey] as? [String:Any] {
                            if let jobPreference = jobPreferenceSection[APIKeys.jobPreferenceAPIKey] as? [String:Any] {
                                wself.jobPreferenceModel = MIJobPreferencesModel.getObjectFromModel(params: jobPreference)
                                if wself.jobPreferenceModel.expectedSalary.salaryCurrency.isEmpty {
                                    if let site = AppDelegate.instance.site {
                                        wself.jobPreferenceModel.expectedSalary.salaryCurrency = site.defaultCurrencyDetails.currency?.isoCode ?? ""
                                    }
                                    
                                }
                                wself.jobPreferenceModelBefore = wself.jobPreferenceModel.copy() as? MIJobPreferencesModel

                                wself.tblView.reloadData()
                            }
                        }
                    }
                }else{
                    wself.handleAPIError(errorParams: response, error: error)
                    
                }
                
            }
        }
    }
    func callApiforJobPreference(){
        
        let params = MIJobPreferencesModel.getParamFromModel(obj: jobPreferenceModel)
        self.startActivityIndicator()
//        var endPoint = APIPath.jobPreferenceApiEndpoint
//        var methodType : ServiceMethod = .post
//        if flowVia == .ViaProfileEdit || flowVia == .ViaPendingAction || flowVia == .ViaProfileAdd {
//            endPoint = APIPath.jobPreferenceEditApiEndpoint
//            methodType = .put
//        }
        MIApiManager.callAPIForJobPreference(path: APIPath.jobPreferenceEditApiEndpoint, method: .put, params: params, headerDict: [:]) { [weak self] (success, response, error, code) in
            DispatchQueue.main.async {
                guard let wself = self else {return}
                wself.stopActivityIndicator()
                if error == nil && (code >= 200) && (code <= 299) {
                    if wself.flowVia == .ViaProfileEdit || wself.flowVia == .ViaProfileAdd || wself.flowVia == .ViaPendingAction {
                        wself.checkFieldLevelUpdated()
                        if let action = wself.jobpreferenceSuccessPendingAction {
                            action(true,wself.jobPreferenceModel)
                        }
                        if let tabbar = wself.tabBarController as? MIHomeTabbarViewController {
                            tabbar.jobPreferenceInfo = wself.jobPreferenceModel
                        }
                        shouldRunProfileApi = true
                        wself.navigationController?.popViewController(animated: false)
                    }
                }else{
                    wself.handleAPIError(errorParams: response, error: error)
                }
            }
        }
    }
    
    func checkFieldLevelUpdated() {
         var fieldChanged = [String]()
         var fieldValue = [String]()
         var fieldValueBefore = [String]()
        
        fieldValue = self.jobPreferenceModel.preferredIndustrys.map({ $0.name.lowercased() })
        fieldValueBefore = self.jobPreferenceModelBefore?.preferredIndustrys.map({ $0.name.lowercased() }) ?? [String]()
        if !(fieldValue.containsSameElements(as: fieldValueBefore)) {
            fieldChanged.append(CONSTANT_FIELD_LEVEL_NAME.PREF_INDUSTRY)
        }
        fieldValue.removeAll()
        fieldValueBefore.removeAll()
        fieldValue = self.jobPreferenceModel.preferredFunctions.map({ $0.name.lowercased() })
        fieldValueBefore = self.jobPreferenceModelBefore?.preferredFunctions.map({ $0.name.lowercased() }) ?? [String]()
        if !(fieldValue.containsSameElements(as: fieldValueBefore)) {
            fieldChanged.append(CONSTANT_FIELD_LEVEL_NAME.PREF_FUNCTION)
        }
        fieldValue.removeAll()
        fieldValueBefore.removeAll()
        fieldValue = self.jobPreferenceModel.preferredRoles.map({ $0.name.lowercased() })
        fieldValueBefore = self.jobPreferenceModelBefore?.preferredRoles.map({ $0.name.lowercased() }) ?? [String]()
        if !(fieldValue.containsSameElements(as: fieldValueBefore)) {
            fieldChanged.append(CONSTANT_FIELD_LEVEL_NAME.PREF_ROLE)
        }
        fieldValue.removeAll()
        fieldValueBefore.removeAll()
        fieldValue = self.jobPreferenceModel.preferredLocationList.map({ $0.name.lowercased() })
        fieldValueBefore = self.jobPreferenceModelBefore?.preferredLocationList.map({ $0.name.lowercased() }) ?? [String]()
        if !(fieldValue.containsSameElements(as: fieldValueBefore)) {
            fieldChanged.append(CONSTANT_FIELD_LEVEL_NAME.PREF_LOCATION)
        }
        
        if flowVia != .ViaPendingAction {
            if jobPreferenceModelBefore?.expectedSalary.salaryCurrency != self.jobPreferenceModel.expectedSalary.salaryCurrency {
                if (jobPreferenceModelBefore?.expectedSalary.salaryInLakh != self.jobPreferenceModel.expectedSalary.salaryInLakh) || (jobPreferenceModelBefore?.expectedSalary.salaryThousand != self.jobPreferenceModel.expectedSalary.salaryThousand) {
                    fieldChanged.append(CONSTANT_FIELD_LEVEL_NAME.EXP_SALARY)
                }
              //  fieldChanged.append(CONSTANT_FIELD_LEVEL_NAME.EXP_SALARY)
            }else{
                if (jobPreferenceModelBefore?.expectedSalary.salaryInLakh != self.jobPreferenceModel.expectedSalary.salaryInLakh) || (jobPreferenceModelBefore?.expectedSalary.salaryThousand != self.jobPreferenceModel.expectedSalary.salaryThousand) {
                    fieldChanged.append(CONSTANT_FIELD_LEVEL_NAME.EXP_SALARY)
                }
            }
            
            if jobPreferenceModelBefore?.preferredJobType.name.lowercased() != self.jobPreferenceModel.preferredJobType.name.lowercased() {
                fieldChanged.append(CONSTANT_FIELD_LEVEL_NAME.PREF_JOB_TYPE)
            }
        }
        
      

        JobSeekerSingleton.sharedInstance.fieldLevelDataArray = fieldChanged
    }
}

extension MIJobPreferenceViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeHolderValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = placeHolderValue[indexPath.row]
        if title == MIJobPreferenceViewControllerConstant.preferredExpectedSalary {
            let currentSalryCell = tableView.dequeueReusableCell(withClass: MIEmploymentSalaryTableCell.self, for: indexPath)
            currentSalryCell.salaryTxtField.delegate = self
            currentSalryCell.salaryTxtField.tag = indexPath.row
            currentSalryCell.cellType = .Offered
            currentSalryCell.showCalulatedSalary = false
            //currentSalryCell.stackViewForSalryMode.isHidden = true
            if self.error.index == indexPath.row {
                if error.isPrimaryError {
                    self.showAlert(title: "", message: self.error.message)
//                    currentSalryCell.calculatedSalaryLabel.textColor = Color.errorColor
//                    currentSalryCell.calculatedSalaryLabel.isHidden = false
//                    currentSalryCell.calculatedSalaryLabel.text = self.error.message
//                    currentSalryCell.calculatedSalaryLabel.font = UIFont.customFont(type: .Regular, size: 12)
                }
            } else {
//                currentSalryCell.calculatedSalaryLabel.isHidden = true
//                currentSalryCell.calculatedSalaryLabel.text = ""
            }
            currentSalryCell.showCalulatedSalary = true
   //         currentSalryCell.calculatedSalaryLabel.isHidden = false
            currentSalryCell.title_Lbl.text = MIJobPreferenceViewControllerConstant.preferredExpectedSalary
            currentSalryCell.showDataForSalar(salaryIakh: jobPreferenceModel.expectedSalary.salaryInLakh, salaryInThousand: jobPreferenceModel.expectedSalary.salaryThousand, salaryCurrency: jobPreferenceModel.expectedSalary.salaryCurrency, salaryMode: jobPreferenceModel.expectedSalary.salaryModeAnually)
            currentSalryCell.currencyCallBack = {[weak self] (cell,type) in
                guard let wSelf = self else {return}
                wSelf.view.endEditing(true)
                if type == "CURRENCY" {
                    var dataList = [String]()
                    
                    if !(wSelf.jobPreferenceModel.expectedSalary.salaryCurrency.isEmpty)  {
                        dataList.append(wSelf.jobPreferenceModel.expectedSalary.salaryCurrency)
                    }
                    
                    if dataList.count == 0{
                        let currName = AppDelegate.instance.splashModel.currencies?.map({ $0.name }) ?? []
                        dataList = currName
                    }
                    wSelf.pushStaticMasterController(type: .CURRENCY, data: dataList)
                    
                }else if type == "LAKH" {
                    var dataList = [String]()
                    if !(wSelf.jobPreferenceModel.expectedSalary.salaryInLakh.isEmpty) {
                        dataList.append((wSelf.jobPreferenceModel.expectedSalary.salaryCurrency))
                    }
                    
                    wSelf.pushStaticMasterController(type: .SALARYINLAKH, data: dataList)
                }else if type == "THOUSAND" {
                    var dataList = [String]()
                    if !(wSelf.jobPreferenceModel.expectedSalary.salaryThousand.isEmpty) {
                        dataList.append(wSelf.jobPreferenceModel.expectedSalary.salaryThousand)
                    }
                    
                    wSelf.pushStaticMasterController(type: .SALARYINTHOUSAND, data: dataList)
                    
                }else if type == "OFFERED_AN" { //Annual Mode
                    wSelf.jobPreferenceModel.expectedSalary.salaryMode = MICategorySelectionInfo(dictionary: ["name":"Annually","uuid":kannuallyModeSalaryUUID]) ?? MICategorySelectionInfo()
                    wSelf.jobPreferenceModel.expectedSalary.salaryModeAnually = true
                    wSelf.tblView.reloadData()

                }else if type == "OFFERED_MO" { //Monthly Mode
                    wSelf.jobPreferenceModel.expectedSalary.salaryMode = MICategorySelectionInfo(dictionary: ["name":"Monthly","uuid":kmonthlyModeSalaryUUID]) ?? MICategorySelectionInfo()
                    wSelf.jobPreferenceModel.expectedSalary.salaryModeAnually = false
                    wSelf.tblView.reloadData()
                    
                }
            }
            return currentSalryCell
        }else{
            let tvCell = tableView.dequeueReusableCell(withClass: MITextViewTableViewCell.self, for: indexPath)
            tvCell.textView.isUserInteractionEnabled = false
            tvCell.textView.placeholder = "Profile Title" as NSString
            tvCell.textView.tag = indexPath.row
            tvCell.accessoryImageView.isHidden = false
            tvCell.titleLabel.text = title
            if self.error.index == indexPath.row {
                if error.isPrimaryError {
                    tvCell.showError(with: self.error.message,animated: false)
                }
                
            } else {
                tvCell.showError(with: "",animated: false)
            }
            if title == MIJobPreferenceViewControllerConstant.preferredLoc {
                tvCell.textView.placeholder = "Please select one or more preferred location(s)" as NSString
                tvCell.textView.text = (jobPreferenceModel.preferredLocationList.map { $0.name }).joined(separator: ",")
                return tvCell
                
            }else if title == MIJobPreferenceViewControllerConstant.preferredIndu {
                tvCell.textView.placeholder = "Maximum 2 industrys can be selected" as NSString
                tvCell.textView.text = (jobPreferenceModel.preferredIndustrys.map { $0.name }).joined(separator: ",")
                return tvCell
                
            }else if title == MIJobPreferenceViewControllerConstant.preferredFunc {
                tvCell.textView.placeholder = "Maximum 2 functions can be selected" as NSString
                tvCell.textView.text = (jobPreferenceModel.preferredFunctions.map { $0.name }).joined(separator: ",")
                return tvCell
                
            }else if title == MIJobPreferenceViewControllerConstant.preferredRole {
                tvCell.textView.placeholder = "Maximum 2 roles can be selected" as NSString
                tvCell.textView.text = (jobPreferenceModel.preferredRoles.map { $0.name }).joined(separator: ",")
                return tvCell
                
            }else if title == MIJobPreferenceViewControllerConstant.preferredShift {
                tvCell.textView.placeholder = "Select" as NSString
                tvCell.textView.text = jobPreferenceModel.preferredShift.name
                return tvCell
                
            }else if title == MIJobPreferenceViewControllerConstant.preferredJobType || title == MIJobPreferenceViewControllerConstant.preferredEmploymentType || title == MIJobPreferenceViewControllerConstant.preferredSixDayWorking || title == MIJobPreferenceViewControllerConstant.preferredStartUpJoin {
                let cell = tableView.dequeueReusableCell(withClass: MI3RadioButtonTableCell.self, for: indexPath)
                cell.radioButtons[2].isHidden = false
                if title == MIJobPreferenceViewControllerConstant.preferredJobType {
                    cell.setButtons("Permanent", button2: "Temporary/Contract", button3: "Both")
                    cell.titleLabel.text = title
                    
                    switch jobPreferenceModel.preferredJobType.name.lowercased() {
                        case "Permanent".lowercased():
                            cell.selectRadioButton(at: 0)
                        case "Temporary/Contract".lowercased():
                            cell.selectRadioButton(at: 1)
                        case "Both".lowercased():
                            cell.selectRadioButton(at: 2)
                        default: break
                    }
                }else if title == MIJobPreferenceViewControllerConstant.preferredEmploymentType{
                    cell.setButtons("Full time", button2: "Part time", button3: "Both")
                    cell.titleLabel.text = title
                    switch jobPreferenceModel.preferredEmploymentType.name.lowercased() {
                    case "Full time".lowercased():
                        cell.selectRadioButton(at: 0)
                    case "Part time".lowercased():
                        cell.selectRadioButton(at: 1)
                    case "Both".lowercased():
                        cell.selectRadioButton(at: 2)
                    default: break
                    }
                }else if title == MIJobPreferenceViewControllerConstant.preferredSixDayWorking{
                    cell.setButtons("Yes", button2: "No", button3: "")
                    cell.titleLabel.text = "Are you willing to work 6 days a week?"
                    cell.radioButtons[2].isHidden = true
                    if let value =  self.jobPreferenceModel.willingToWorkSixDay {
                        cell.selectRadioButton(at: value ? 0 : 1)
                        
                    }
                }else if title == MIJobPreferenceViewControllerConstant.preferredStartUpJoin{
                    cell.setButtons("Yes", button2: "No", button3: "")
                    cell.titleLabel.text = "Are you open to joining early stage startup?"
                    cell.radioButtons[2].isHidden = true
                    if let value =  self.jobPreferenceModel.openToWorkWithStartUp {
                        cell.selectRadioButton(at: value ? 0 : 1)
                        
                    }
                    
                }
                
                cell.radioBtnSelection = {[weak self] index, fieldtitle in
                   
                    guard let wself = self else {return}
                    wself.view.endEditing(true)
                    switch index {
                    case 0: //Full Time
                        if (title == MIJobPreferenceViewControllerConstant.preferredJobType) {
                            wself.jobPreferenceModel.preferredJobType = MICategorySelectionInfo(dictionary: ["name":fieldtitle,"uuid":"a93cd4f6-fc6a-11e8-92d8-000c290b6677"]) ?? MICategorySelectionInfo()
                        }else if (title == MIJobPreferenceViewControllerConstant.preferredEmploymentType) {
                            wself.jobPreferenceModel.preferredEmploymentType = MICategorySelectionInfo(dictionary: ["name":fieldtitle,"uuid":"52dfd5af-fc6b-11e8-92d8-000c290b6677"]) ?? MICategorySelectionInfo()
                        }else if (title == MIJobPreferenceViewControllerConstant.preferredSixDayWorking){
                            wself.jobPreferenceModel.willingToWorkSixDay = true
                        }else if (title == MIJobPreferenceViewControllerConstant.preferredStartUpJoin) {
                            wself.jobPreferenceModel.openToWorkWithStartUp = true
                        }
                        
                    case 1: //Part Time
                        if (title == MIJobPreferenceViewControllerConstant.preferredJobType) {
                            wself.jobPreferenceModel.preferredJobType = MICategorySelectionInfo(dictionary: ["name":fieldtitle,"uuid":"c252778a-fc6a-11e8-92d8-000c290b6677"]) ?? MICategorySelectionInfo()
                        }else if (title == MIJobPreferenceViewControllerConstant.preferredEmploymentType) {
                            wself.jobPreferenceModel.preferredEmploymentType = MICategorySelectionInfo(dictionary: ["name":fieldtitle,"uuid":"63fbf98a-fc6b-11e8-92d8-000c290b6677"]) ?? MICategorySelectionInfo()
                        }else if (title == MIJobPreferenceViewControllerConstant.preferredSixDayWorking){
                            wself.jobPreferenceModel.willingToWorkSixDay = false
                        }else if (title == MIJobPreferenceViewControllerConstant.preferredStartUpJoin) {
                            wself.jobPreferenceModel.openToWorkWithStartUp = false
                        }
                        
                    default: //Correspondence
                        (title == MIJobPreferenceViewControllerConstant.preferredJobType) ?
                            (wself.jobPreferenceModel.preferredJobType = MICategorySelectionInfo(dictionary: ["name":fieldtitle,"uuid":"be8605a7-22e8-11e9-9330-1418775c7275"]) ?? MICategorySelectionInfo()) :  (wself.jobPreferenceModel.preferredEmploymentType = MICategorySelectionInfo(dictionary: ["name":fieldtitle,"uuid":"dab10028-22e8-11e9-9330-1418775c7275"]) ?? MICategorySelectionInfo())
                    }
                }
                
                return cell
            }
        }
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if  self.flowVia == .ViaPendingAction {
            let headerView = MIIconTitleHeaderView.headerView
            headerView.backgroundColor = UIColor.clear
            headerView.showDataWithImg(icon: UIImage(named: "jobPreference")!, title: "It will help us get you the ideal job faster.")
            return headerView
        }else{
            return UIView()
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if  self.flowVia == .ViaPendingAction {
            return 55
        }else{
            return 10
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        self.manageError(message: "", indexRow: -1, isPrimary: true)
        if placeHolderValue[indexPath.row] == MIJobPreferenceViewControllerConstant.preferredSixDayWorking || placeHolderValue[indexPath.row] == MIJobPreferenceViewControllerConstant.preferredStartUpJoin || placeHolderValue[indexPath.row] == MIJobPreferenceViewControllerConstant.preferredExpectedSalary || placeHolderValue[indexPath.row] == MIJobPreferenceViewControllerConstant.preferredJobType || placeHolderValue[indexPath.row] == MIJobPreferenceViewControllerConstant.preferredEmploymentType {
            return
        }
        let vc = MIMasterDataSelectionViewController.newInstance
        vc.title = "Search"
        vc.delegate = self
        vc.limitSelectionCount = 5
        
        if placeHolderValue[indexPath.row] == MIJobPreferenceViewControllerConstant.preferredIndu {
            vc.limitSelectionCount=2
            vc.masterType = MasterDataType.INDUSTRY
            if jobPreferenceModel.preferredIndustrys.count > 0 {
                let tuples = self.getSelectedMasterDataFor(dataSource: jobPreferenceModel.preferredIndustrys)
                vc.selectedInfoArray = tuples.masterDataNames
                vc.selectDataArray = tuples.masterDataObject
            }
        }else if placeHolderValue[indexPath.row] == MIJobPreferenceViewControllerConstant.preferredFunc {
            vc.limitSelectionCount=2
            vc.masterType = MasterDataType.FUNCTION
            if jobPreferenceModel.preferredFunctions.count > 0 {
                let tuples = self.getSelectedMasterDataFor(dataSource: jobPreferenceModel.preferredFunctions)
                vc.selectedInfoArray = tuples.masterDataNames
                vc.selectDataArray = tuples.masterDataObject
            }
        }else if placeHolderValue[indexPath.row] == MIJobPreferenceViewControllerConstant.preferredRole{
            if jobPreferenceModel.preferredFunctions.count > 0 {
                vc.limitSelectionCount=2
                vc.masterType = MasterDataType.ROLE
                if jobPreferenceModel.preferredRoles.count > 0 {
                    let tuples = self.getSelectedMasterDataFor(dataSource: jobPreferenceModel.preferredRoles)
                    vc.selectedInfoArray = tuples.masterDataNames
                    vc.selectDataArray = tuples.masterDataObject
                }
                vc.parentId = MICategorySelectionInfo.getParentUUIDs(modalDataSource: jobPreferenceModel.preferredFunctions) //self.getParentUUIDs()
                
            }else{
                self.showAlert(title: "", message: "You have to select function first.")
                return
            }
        }else if placeHolderValue[indexPath.row] == MIJobPreferenceViewControllerConstant.preferredLoc{
            vc.masterType = MasterDataType.LOCATION
            if jobPreferenceModel.preferredLocationList.count > 0 {
                let tuples = self.getSelectedMasterDataFor(dataSource: jobPreferenceModel.preferredLocationList)
                vc.selectedInfoArray = tuples.masterDataNames
                vc.selectDataArray = tuples.masterDataObject
            }
        }else if placeHolderValue[indexPath.row] == MIJobPreferenceViewControllerConstant.preferredJobType{
            vc.masterType = MasterDataType.JOB_TYPE
            vc.limitSelectionCount=1
            if jobPreferenceModel.preferredJobType.name.count > 0 {
                let tuples = self.getSelectedMasterDataFor(dataSource: [jobPreferenceModel.preferredJobType])
                vc.selectedInfoArray = tuples.masterDataNames
                vc.selectDataArray = tuples.masterDataObject
            }
        }else if placeHolderValue[indexPath.row] == MIJobPreferenceViewControllerConstant.preferredShift{
            vc.masterType = MasterDataType.EMPLOYMENT_SHIFT
            vc.limitSelectionCount=1
            if jobPreferenceModel.preferredShift.name.count > 0 {
                let tuples = self.getSelectedMasterDataFor(dataSource: [jobPreferenceModel.preferredShift])
                vc.selectedInfoArray = tuples.masterDataNames
                vc.selectDataArray = tuples.masterDataObject
            }
        }else if placeHolderValue[indexPath.row] == MIJobPreferenceViewControllerConstant.preferredEmploymentType{
            vc.masterType = MasterDataType.EMPLOYMENT_TYPE
            vc.limitSelectionCount=1
            if jobPreferenceModel.preferredEmploymentType.name.count > 0 {
                let tuples = self.getSelectedMasterDataFor(dataSource: [jobPreferenceModel.preferredEmploymentType])
                vc.selectedInfoArray = tuples.masterDataNames
                vc.selectDataArray = tuples.masterDataObject
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getMasterDataName(list:[MICategorySelectionInfo]) -> String {
        if list.count > 0 {
            let names = (list.map { $0.name }).joined(separator: ",")
            return names
        }else{
            return ""
        }
    }
    func pushStaticMasterController(type:StaticMasterData,data:[String]) {
        let staticMasterVC = MIStaticMasterDataViewController.newInstance
        staticMasterVC.title = "Selection"
        staticMasterVC.staticMasterType = type
        staticMasterVC.selectedDataArray = data
        staticMasterVC.selectedData = { value in
            
            if type == .CURRENCY {
                self.jobPreferenceModel.expectedSalary.salaryCurrency = value
                self.jobPreferenceModel.expectedSalary.salaryInLakh = ""
                self.jobPreferenceModel.expectedSalary.salaryThousand = ""

            }else if type == .SALARYINLAKH {
                self.jobPreferenceModel.expectedSalary.salaryInLakh = value
                self.jobPreferenceModel.expectedSalary.absoluteValue = 0
            }else if type == .SALARYINTHOUSAND {
                self.jobPreferenceModel.expectedSalary.salaryThousand = value
                self.jobPreferenceModel.expectedSalary.absoluteValue = 0

            }
            self.tblView.reloadData()
            
        }
        self.navigationController?.pushViewController(staticMasterVC, animated: true)
    }
    func removeChildModel(parentModels:[MICategorySelectionInfo],childs:[MICategorySelectionInfo]) {
        
        if parentModels.count == 0 {
            jobPreferenceModel.preferredRoles = [MICategorySelectionInfo]()
            return
        }
        
        jobPreferenceModel.preferredRoles = childs.filter({(mod:MICategorySelectionInfo) -> Bool in
            return  parentModels.contains(where: {mod.parentUuid.contains($0.uuid)})
        })
        
    }
}

extension MIJobPreferenceViewController : MIMasterDataSelectionViewControllerDelegate {
    func masterDataSelected(selectedCategoryInfo: [MICategorySelectionInfo], selectedListInfo: [String], enumName: String) {
        
        if MasterDataType.INDUSTRY.rawValue == enumName {
            jobPreferenceModel.preferredIndustrys = selectedCategoryInfo
        }else if MasterDataType.FUNCTION.rawValue == enumName {
            jobPreferenceModel.preferredFunctions = selectedCategoryInfo
            if jobPreferenceModel.preferredRoles.count > 0  {
                self.removeChildModel(parentModels: jobPreferenceModel.preferredFunctions, childs: jobPreferenceModel.preferredRoles)
            }
        }else if MasterDataType.ROLE.rawValue == enumName {
            jobPreferenceModel.preferredRoles = selectedCategoryInfo
        }else if MasterDataType.JOB_TYPE.rawValue == enumName {
            jobPreferenceModel.preferredJobType = selectedCategoryInfo.first ?? MICategorySelectionInfo()
        }else if MasterDataType.EMPLOYMENT_SHIFT.rawValue == enumName {
            jobPreferenceModel.preferredShift = selectedCategoryInfo.first  ?? MICategorySelectionInfo()
            
        }else if MasterDataType.EMPLOYMENT_TYPE.rawValue == enumName {
            jobPreferenceModel.preferredEmploymentType = selectedCategoryInfo.first  ?? MICategorySelectionInfo()
            
        }else {
            jobPreferenceModel.preferredLocationList = selectedCategoryInfo
        }
        
        self.tblView.reloadData()
    }
    
}
extension MIJobPreferenceViewController:UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if MIJobPreferenceViewControllerConstant.preferredExpectedSalary == placeHolderValue[textField.tag] {
            if self.jobPreferenceModel.expectedSalary.salaryCurrency != "INR" {
                if let cell = self.tblView.cellForRow(at: IndexPath(row: placeHolderValue.firstIndex(of: MIJobPreferenceViewControllerConstant.preferredExpectedSalary) ?? 0, section: 0)) as? MIEmploymentSalaryTableCell {
                    if  cell.salaryTxtField == textField  {
                        self.jobPreferenceModel.expectedSalary.salaryInLakh = textField.text?.withoutWhiteSpace() ?? ""
                    }
                    self.tblView.reloadData()
                }
            }else{
                
            }
        }
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.setMainViewFrame(originY: 0)
            }
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.manageError(message: "", indexRow: -1, isPrimary: true)
        if MIJobPreferenceViewControllerConstant.preferredExpectedSalary == placeHolderValue[textField.tag]  {
            DispatchQueue.main.async {
                self.setMainViewFrame(originY: 0)
                let movingHeight = textField.movingHeightIn(view : self.view) + 35
                if movingHeight > 0 {
                    UIView.animate(withDuration: 0.3) {
                        self.setMainViewFrame(originY: -movingHeight)
                    }
                }
            }
            return true
        }
        return false
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       if string == "" {
           return true
       }
        let title = placeHolderValue[textField.tag]
        if string.count == 0 {
            return true
        }
        if let stringData = textField.text?.appending(string)  {
            
            if title == MIJobPreferenceViewControllerConstant.preferredExpectedSalary {
                if (stringData.count) > 11 {
                    return false
                }
            }
        }
        
        return true
        
    }
}

