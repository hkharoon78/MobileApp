//
//  MIEditProfileVC.swift
//  MonsteriOS
//
//  Created by Anushka on 01/02/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIEditProfileVC: MIBaseViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var tableViewEditProfile: UITableView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var tblFooterView: UIView!
    
    var basicProfileInfo = MIProfilePersonalDetailInfo(dictionary: [:])
    var beforeUpdateInfo = MIProfilePersonalDetailInfo(dictionary: [:])
    var dataFieldsList = [String]()
    var oldNumber = ""
    var editProfileSuccess : ((Bool) -> Void)?
    var error: (message: String, index: Int,isPrimaryError:Bool) = ("", -1,false)
    let hPopup = MIJobPreferencePopup.popup(horizontalButtons: false)
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewEditProfile.delegate = self
        self.tableViewEditProfile.dataSource = self
        self.tableViewEditProfile.keyboardDismissMode = .onDrag
        self.tableViewEditProfile.estimatedRowHeight = self.tableViewEditProfile.rowHeight
        self.tableViewEditProfile.rowHeight = UITableView.automaticDimension
        self.tableViewEditProfile.tableFooterView = self.tblFooterView
        self.tableViewEditProfile.separatorStyle = .none
        self.btnSave.showPrimaryBtn()
        
        tableViewEditProfile.register(UINib(nibName:String(describing: MITextFieldTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MITextFieldTableViewCell.self))
        tableViewEditProfile.register(UINib(nibName:String(describing: MITextViewTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MITextViewTableViewCell.self))
        tableViewEditProfile.register(UINib(nibName:String(describing: MIEmploymentSalaryTableCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MIEmploymentSalaryTableCell.self))
        let cgrect : CGRect = CGRect(x: 0, y: 0, width: kScreenSize.width, height: 15)
        self.tableViewEditProfile.tableHeaderView = UIView(frame: cgrect)
        
        self.tableViewEditProfile.separatorColor = .lightGray
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        oldNumber = self.basicProfileInfo.mobileNumber
        
        if self.basicProfileInfo.countryCode.isEmpty {
            let siteValue = self.getSiteCountryISOCode()
            if !siteValue.countryPhoneCode.isEmpty {
                self.basicProfileInfo.countryCode = siteValue.countryPhoneCode
            }
        }
        if let site = AppDelegate.instance.site {
            if (basicProfileInfo.additionPersonalInfo?.salaryModal.salaryCurrency.isEmpty ?? true) || basicProfileInfo.additionPersonalInfo?.salaryModal.salaryCurrency == nil {
                basicProfileInfo.additionPersonalInfo?.salaryModal.salaryCurrency = site.defaultCurrencyDetails.currency?.isoCode ?? ""
            }
        }
        
        beforeUpdateInfo = basicProfileInfo.copy() as! MIProfilePersonalDetailInfo
        self.manageDataFields()
    }
    
    deinit {
        print("Edit Profile denint")
    }
    
    func manageDataFields() {
        var fieldNameToRemove = [String]()
        if basicProfileInfo.expereienceLevel.uppercased() == "Experienced".uppercased() {
            // dataFieldsList = [RegisterViewStoryBoardConstant.fullName,RegisterViewStoryBoardConstant.currentLocation                ,RegisterViewStoryBoardConstant.nationality,RegisterViewStoryBoardConstant.email,RegisterViewStoryBoardConstant.mobileNumber,RegisterViewStoryBoardConstant.profileTitle,RegisterViewStoryBoardConstant.workExperience,RegisterViewStoryBoardConstant.salary]
            fieldNameToRemove.append(RegisterViewStoryBoardConstant.experienceLevel)
        }else{
            // dataFieldsList = [RegisterViewStoryBoardConstant.fullName,RegisterViewStoryBoardConstant.currentLocation                ,RegisterViewStoryBoardConstant.nationality,RegisterViewStoryBoardConstant.email,RegisterViewStoryBoardConstant.mobileNumber,RegisterViewStoryBoardConstant.profileTitle,RegisterViewStoryBoardConstant.experienceLevel]
            fieldNameToRemove.append(contentsOf: [RegisterViewStoryBoardConstant.workExperience,RegisterViewStoryBoardConstant.salary])
        }
        if self.checkUserNationalityAndCurrentLocationFromSameCountry() != VisaOptionOpen.VisaTypeSelect {
            fieldNameToRemove.append(RegisterViewStoryBoardConstant.visaTypeField)
        }
        if !(basicProfileInfo.additionPersonalInfo?.currentlocation.name.lowercased().contains("other") ?? false ){
            fieldNameToRemove.append(RegisterViewStoryBoardConstant.cityName)
            //  dataFieldsList.insert(RegisterViewStoryBoardConstant.cityName, at: 2)
        }
        
        dataFieldsList = [RegisterViewStoryBoardConstant.fullName,RegisterViewStoryBoardConstant.currentLocation,RegisterViewStoryBoardConstant.cityName
            ,RegisterViewStoryBoardConstant.nationality,RegisterViewStoryBoardConstant.visaTypeField,RegisterViewStoryBoardConstant.email,RegisterViewStoryBoardConstant.mobileNumber,RegisterViewStoryBoardConstant.profileTitle,RegisterViewStoryBoardConstant.experienceLevel,RegisterViewStoryBoardConstant.workExperience,RegisterViewStoryBoardConstant.salary]
        
        let dataAfterFilter = dataFieldsList.filter({!fieldNameToRemove.contains($0)})
        
        dataFieldsList = dataAfterFilter
        
    }
    func checkUserNationalityAndCurrentLocationFromSameCountry() -> VisaOptionOpen {
        
        if basicProfileInfo.additionPersonalInfo?.currentlocation.countryUUID.isEmpty ?? true || basicProfileInfo.nationality.countryUUID.isEmpty {
            return VisaOptionOpen.None
        }else{
            if basicProfileInfo.additionPersonalInfo?.currentlocation.countryUUID.withoutWhiteSpace().lowercased() ==  basicProfileInfo.nationality.countryUUID.withoutWhiteSpace().lowercased() {
                return VisaOptionOpen.None
            }else{
                return VisaOptionOpen.VisaTypeSelect
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.setMainViewFrame(originY: 0)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CommonClass.googleAnalyticsScreen(self) //GA for Screen
        self.navigationItem.title = "Update Profile"
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)
        
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationItem.title = ""
        
    }
    func manageError(message:String,indexRow:Int,isPrimary:Bool) {
        self.error = (message,indexRow,isPrimary)
        if indexRow > -1 {
            self.tableViewEditProfile.reloadData()
            self.tableViewEditProfile.scrollToRow(at: IndexPath(row: indexRow, section: 0), at: .top, animated: false)
        }
    }
    //MARK:- IBAction
    @IBAction func BtnSavePressed(_ sender: UIButton) {
        
        self.view.endEditing(true)
        if basicProfileInfo.fullName.isEmpty {
            if let index = self.dataFieldsList.firstIndex(of: RegisterViewStoryBoardConstant.fullName) {
                self.manageError(message: ErrorAndValidationMsg.name.rawValue, indexRow: index, isPrimary: true)
            }
        }else if (basicProfileInfo.additionPersonalInfo?.currentlocation.name.isEmpty ?? false) {
            if let index = self.dataFieldsList.firstIndex(of: RegisterViewStoryBoardConstant.currentLocation) {
                self.manageError(message: ErrorAndValidationMsg.CurrentLocationError.rawValue, indexRow: index, isPrimary: true)
            }
        }else if basicProfileInfo.additionPersonalInfo?.currentlocation.name.lowercased().contains("other") ?? false && basicProfileInfo.additionPersonalInfo?.cityName.isEmpty ?? false {
            if let index = self.dataFieldsList.firstIndex(of: RegisterViewStoryBoardConstant.cityName) {
                // let indexPath = IndexPath(row: index, section: 0)
                self.manageError(message: ErrorAndValidationMsg.CurrentCityError.rawValue, indexRow: index, isPrimary: true)
            }
            
        }else if (basicProfileInfo.nationality.name.isEmpty) {
            if let index = self.dataFieldsList.firstIndex(of: RegisterViewStoryBoardConstant.nationality) {
                self.manageError(message: PersonalTitleConstant.NationalityEmpty, indexRow: index, isPrimary: true)
            }
        }else if self.checkUserNationalityAndCurrentLocationFromSameCountry() == .VisaTypeSelect &&  (basicProfileInfo.additionPersonalInfo?.workVisaType.name ?? "").isEmpty{
            if let index = self.dataFieldsList.firstIndex(of: RegisterViewStoryBoardConstant.visaTypeField) {
                self.manageError(message: ErrorAndValidationMsg.visaTypeEmpty.rawValue, indexRow: index, isPrimary: true)
            }
        }else if (basicProfileInfo.countryCode.isEmpty) {
            if let index = self.dataFieldsList.firstIndex(of: RegisterViewStoryBoardConstant.countryCode) {
                self.manageError(message: ErrorAndValidationMsg.countryNumberCode.rawValue, indexRow: index, isPrimary: false)
            }
        }else if (basicProfileInfo.mobileNumber.isEmpty) {
            if let index = self.dataFieldsList.firstIndex(of: RegisterViewStoryBoardConstant.mobileNumber) {
                self.manageError(message: ErrorAndValidationMsg.mobileNumber.rawValue, indexRow: index, isPrimary: true)
            }
        }else if !self.basicProfileInfo.mobileNumber.validiateMobile(for: self.basicProfileInfo.countryCode).isValidate {
            if let index = self.dataFieldsList.firstIndex(of: RegisterViewStoryBoardConstant.mobileNumber) {
                self.manageError(message: self.basicProfileInfo.mobileNumber.validiateMobile(for: self.basicProfileInfo.countryCode).erroMessage, indexRow: index, isPrimary: true)
            }
        }else {
            if basicProfileInfo.expereienceLevel.uppercased() == "Experienced".uppercased() {
                if (basicProfileInfo.additionPersonalInfo?.workExperienceYear == "0" && basicProfileInfo.additionPersonalInfo?.workExperienceMonth == "0" ) {
                    if let index = self.dataFieldsList.firstIndex(of: RegisterViewStoryBoardConstant.workExperience) {
                        self.manageError(message: MIEmploymentDetailViewControllerConstant.emptyWorkOfExpereience, indexRow: index, isPrimary: false)
                    }
                }
                else if (basicProfileInfo.profileTitle.isEmpty) {
                    if let index = self.dataFieldsList.firstIndex(of: RegisterViewStoryBoardConstant.profileTitle) {
                        self.manageError(message: "Please enter your profile title.", indexRow: index, isPrimary: true)
                    }
                }
                else if (basicProfileInfo.additionPersonalInfo?.salaryModal.salaryCurrency.isEmpty ?? "".isEmpty) {
                    if let index = self.dataFieldsList.firstIndex(of: RegisterViewStoryBoardConstant.salary) {
                        self.manageError(message: MIEmploymentDetailViewControllerConstant.emptyCurrentSalaryCurrency, indexRow: index, isPrimary: true)
                    }
                }
                else if (basicProfileInfo.additionPersonalInfo?.salaryModal.salaryThousand.isEmpty ?? false && basicProfileInfo.additionPersonalInfo?.salaryModal.salaryInLakh.isEmpty ??  false) {
                    if let index = self.dataFieldsList.firstIndex(of: RegisterViewStoryBoardConstant.salary) {
                        self.manageError(message: MIEmploymentDetailViewControllerConstant.emptyCurrentSalary, indexRow: index, isPrimary: true)
                    }
                }
                    
                else{
                    self.manageError(message: "", indexRow: -1, isPrimary: true)
                    self.callAPIForUpdateUserPersonalDetail()
                }
            }else{
                if basicProfileInfo.expereienceLevel.isEmpty {
                    if let index = self.dataFieldsList.firstIndex(of: RegisterViewStoryBoardConstant.experienceLevel) {
                        self.manageError(message: "Please select your expereience level.", indexRow: index, isPrimary: true)
                    }
                }else if ((basicProfileInfo.profileTitle.isEmpty)) {
                    if let index = self.dataFieldsList.firstIndex(of: RegisterViewStoryBoardConstant.profileTitle) {
                        self.manageError(message: "Please enter your profile title.", indexRow: index, isPrimary: true)
                    }
                }else{
                    self.manageError(message: "", indexRow: -1, isPrimary: true)
                    self.callAPIForUpdateUserPersonalDetail()
                }
            }
        }
    }
    
    func callAPIForUpdateUserPersonalDetail() {
        var params = [String:Any]()
        
        params[APIKeys.fullNameAPIKey] = basicProfileInfo.fullName
        var mobileNumber = [String:Any]()
        mobileNumber[APIKeys.countryCodeAPIKey] = basicProfileInfo.countryCode.replacingOccurrences(of: "+", with: "")
        mobileNumber[APIKeys.mobileNumberAPIKey] = basicProfileInfo.mobileNumber
        params[APIKeys.experienceLevelAPIKey] = basicProfileInfo.expereienceLevel.uppercased()
        params[APIKeys.nationalityAPIKey] = MIUserModel.getParamForIdText(id: (basicProfileInfo.nationality.uuid), value: (basicProfileInfo.nationality.name))
        var additionalPersonalDetail = [String:Any]()
        additionalPersonalDetail[APIKeys.profileAPIKey] = basicProfileInfo.profileTitle
        additionalPersonalDetail[APIKeys.mobileNumberAPIKey] = mobileNumber
        if basicProfileInfo.additionPersonalInfo?.cityName.isEmpty ?? false {
            additionalPersonalDetail[APIKeys.currentLocationAPIKey] = MIUserModel.getParamForIdText(id: (basicProfileInfo.additionPersonalInfo?.currentlocation.uuid ?? ""), value: (basicProfileInfo.additionPersonalInfo?.currentlocation.name ?? ""))
            
        }else{
            var locationParam = MIUserModel.getParamForIdText(id: (basicProfileInfo.additionPersonalInfo?.currentlocation.uuid ?? ""), value: (basicProfileInfo.additionPersonalInfo?.currentlocation.name ?? ""))
            locationParam[APIKeys.otherTextAPIKey] = basicProfileInfo.additionPersonalInfo?.cityName
            additionalPersonalDetail[APIKeys.currentLocationAPIKey] = locationParam
        }
        if basicProfileInfo.expereienceLevel.uppercased() == "Experienced".uppercased() {
            
            additionalPersonalDetail[APIKeys.currentSalaryAPIKey] = SalaryDetail.getSalaryParam(salary: basicProfileInfo.additionPersonalInfo?.salaryModal ?? SalaryDetail(), withConfidential: false)
            var expereince = [String:Any]()            
            expereince[APIKeys.yearAPIKey] = basicProfileInfo.additionPersonalInfo?.workExperienceYear
            expereince[APIKeys.monthAPIKey] = basicProfileInfo.additionPersonalInfo?.workExperienceMonth
            additionalPersonalDetail[APIKeys.experienceAPIKey] = expereince
        }
        additionalPersonalDetail[APIKeys.workVisaTypeUpdated] = true
        
        if self.checkUserNationalityAndCurrentLocationFromSameCountry() == VisaOptionOpen.VisaTypeSelect {
            if let visa = basicProfileInfo.additionPersonalInfo?.workVisaType {
                if visa.name == kDONT_HAVE_WORK_AUTHORIZATION || visa.name.withoutWhiteSpace().isEmpty {
                    additionalPersonalDetail[APIKeys.workVisaType] = nil
                }else{
                    
                    additionalPersonalDetail[APIKeys.workVisaType] = MIUserModel.getParamForIdText(id: visa.uuid , value: visa.name)
                }
            }
        }else{
            additionalPersonalDetail[APIKeys.workVisaType] = nil
        }
        params[APIKeys.additionalPersonalDetailAPIKey] = additionalPersonalDetail
        self.startActivityIndicator()
        MIApiManager.callAPIForUpdatePersonalDetail(methodType: .put, path:APIPath.personalDetailPUTAPIEndpoint, params: params) {[weak self] (success, response, error, code) in
            DispatchQueue.main.async {
                guard let wself = self else {return}
                wself.stopActivityIndicator()
                if error == nil && (code >= 200) && (code <= 299) {
                    UserDefaults.standard.setValue("\(Date())", forKey: "profile_last_updated")
                    UserDefaults.standard.synchronize()
                    wself.fieldLevelUpdateCheck()
                    if let callBack = wself.editProfileSuccess {
                        callBack(true)
                        wself.navigationController?.popViewController(animated: true)
                    }else{
                        wself.oldNumber = wself.basicProfileInfo.mobileNumber
                      //  wself.showAlert(title: "", message: "Personal detail updated successfully.",isErrorOccured:false)
                        wself.showAlert(title: "", message: "Personal detail updated successfully.", isErrorOccured: false) {
                            wself.navigationController?.popViewController(animated: true)

                        }
                        
                        shouldRunProfileApi = true
                    }
                    
                }else{
                    if let responseData = response as? [String:Any] {
                        if let errorCode = responseData[APIKeys.errorCodeAPIKey] as? String {
                            if errorCode == kMOBILE_NUMBER_EXISTS {
                                wself.existingMobilePopup()
                            }else{
                                wself.handleAPIError(errorParams: response, error: error)
                            }
                        }
                    }else{
                        wself.handleAPIError(errorParams: response, error: error)
                    }
                }
            }
        }
    }
    func existingMobilePopup() {
        self.view.endEditing(true)
        
        self.hPopup.setViewWithTitle(title: "", viewDescriptionText: "\(self.basicProfileInfo.countryCode)\(self.basicProfileInfo.mobileNumber) is already associated with other account. Is this your number? Verify to claim it now.", primaryBtnTitle: "Verify", secondaryBtnTitle: "Cancel")
        self.hPopup.delegate = self
        self.hPopup.addMe(onView: self.view, onCompletion: nil)
    }
    func fieldLevelUpdateCheck()  {
        var updatedFields = [String]()
        
        if beforeUpdateInfo.mobileNumber.isEmpty {
            updatedFields.append(CONSTANT_FIELD_LEVEL_NAME.ADD_MOBILE_NUMBER)
        }else{
            if beforeUpdateInfo.mobileNumber != basicProfileInfo.mobileNumber || beforeUpdateInfo.countryCode != basicProfileInfo.countryCode {
                updatedFields.append(CONSTANT_FIELD_LEVEL_NAME.MOBILE_NUMBER_CHANGED)
            }
        }
        
        if beforeUpdateInfo.additionPersonalInfo?.currentlocation.name.lowercased() != basicProfileInfo.additionPersonalInfo?.currentlocation.name.lowercased() {
            updatedFields.append(CONSTANT_FIELD_LEVEL_NAME.CUR_LOCATION)
        }
        if beforeUpdateInfo.profileTitle.lowercased() != basicProfileInfo.profileTitle.lowercased() {
            updatedFields.append(CONSTANT_FIELD_LEVEL_NAME.PROFILE_TITLE)
        }
        if (beforeUpdateInfo.additionPersonalInfo?.workExperienceYear != basicProfileInfo.additionPersonalInfo?.workExperienceYear) || (beforeUpdateInfo.additionPersonalInfo?.workExperienceMonth != basicProfileInfo.additionPersonalInfo?.workExperienceMonth) {
            updatedFields.append(CONSTANT_FIELD_LEVEL_NAME.TOTAL_WORK_EXP)
            
        }
        if beforeUpdateInfo.additionPersonalInfo?.salaryModal.salaryCurrency !=  basicProfileInfo.additionPersonalInfo?.salaryModal.salaryCurrency {
            updatedFields.append(CONSTANT_FIELD_LEVEL_NAME.CUR_SALARY)
        }else{
            if (beforeUpdateInfo.additionPersonalInfo?.salaryModal.salaryInLakh !=  basicProfileInfo.additionPersonalInfo?.salaryModal.salaryInLakh) ||  (beforeUpdateInfo.additionPersonalInfo?.salaryModal.salaryThousand !=  basicProfileInfo.additionPersonalInfo?.salaryModal.salaryThousand) {
                updatedFields.append(CONSTANT_FIELD_LEVEL_NAME.CUR_SALARY)
                
            }
        }
        
        JobSeekerSingleton.sharedInstance.fieldLevelDataArray = updatedFields
    }
    
}

//MARK:- table view delegate and data source
extension MIEditProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataFieldsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = dataFieldsList[indexPath.row]
        if title == RegisterViewStoryBoardConstant.profileTitle {
            let tvCell = tableView.dequeueReusableCell(withClass: MITextViewTableViewCell.self, for: indexPath)
            tvCell.textView.isUserInteractionEnabled = true
            tvCell.textView.placeholder = "Profile Title" as NSString
            tvCell.textView.text = basicProfileInfo.profileTitle
            tvCell.showCounterLabel = true
            tvCell.textView.delegate = self
            tvCell.textView.keyboardType = .asciiCapable
            tvCell.textView.tag = indexPath.row
            tvCell.accessoryImageView.isHidden = true
            if self.error.index == indexPath.row {
                if error.isPrimaryError {
                    tvCell.showError(with: self.error.message,animated: false)
                }
            } else {
                tvCell.showError(with: "",animated: false)
            }
            return tvCell
        }else if title == RegisterViewStoryBoardConstant.salary {
            let currentSalryCell = tableView.dequeueReusableCell(withClass: MIEmploymentSalaryTableCell.self, for: indexPath)
            currentSalryCell.salaryTxtField.delegate = self
            currentSalryCell.salaryTxtField.tag = indexPath.row
            if self.error.index == indexPath.row {
                if error.isPrimaryError {
                    self.showAlert(title: nil, message: self.error.message)
                    //                    currentSalryCell.calculatedSalaryLabel.textColor = Color.errorColor
                    //                    currentSalryCell.calculatedSalaryLabel.isHidden = false
                    //                    currentSalryCell.calculatedSalaryLabel.text = self.error.message
                    //                    currentSalryCell.calculatedSalaryLabel.font = UIFont.customFont(type: .Regular, size: 12)
                }
            }
            //            else {
            //                currentSalryCell.calculatedSalaryLabel.isHidden = true
            //               // currentSalryCell.calculatedSalaryLabel.text = ""
            //            }
            //    currentSalryCell.calculatedSalaryLabel.isHidden = false
            currentSalryCell.showCalulatedSalary = true
            currentSalryCell.showDataForSalary(additionalData:basicProfileInfo.additionPersonalInfo! )
            currentSalryCell.title_Lbl.text = "Current Salary"
            //            if basicProfileInfo.additionPersonalInfo!.salaryModeName == "Annually" {
            //                currentSalryCell.title_Lbl.text = "Current Salary (Annually)"
            //            }else{
            //                currentSalryCell.title_Lbl.text = "Current Salary (Monthly)"
            //            }
            currentSalryCell.currencyCallBack = {[weak self] (cell,type) in
                
                guard let wself = self else {return}
                
                wself.view.endEditing(true)
                if type == "CURRENCY" {
                    var dataList = [String]()
                    
                    if !(wself.basicProfileInfo.additionPersonalInfo?.salaryModal.salaryCurrency.isEmpty ?? true)  {
                        dataList.append((wself.basicProfileInfo.additionPersonalInfo?.salaryModal.salaryCurrency ?? "INR"))
                    }
                    
                    if dataList.count == 0{
                        let currName = AppDelegate.instance.splashModel.currencies?.map({ $0.name }) ?? []
                        dataList = currName
                    }
                    wself.pushStaticMasterController(type: .CURRENCY, data: dataList)
                    
                }else if type == "LAKH" {
                    var dataList = [String]()
                    if !(wself.basicProfileInfo.additionPersonalInfo?.salaryModal.salaryInLakh.isEmpty)! {
                        dataList.append((wself.basicProfileInfo.additionPersonalInfo?.salaryModal.salaryInLakh)!)
                    }
                    
                    wself.pushStaticMasterController(type: .SALARYINLAKH, data: dataList)
                }else if type == "THOUSAND" {
                    var dataList = [String]()
                    if !(wself.basicProfileInfo.additionPersonalInfo?.salaryModal.salaryThousand.isEmpty ?? true) {
                        dataList.append((wself.basicProfileInfo.additionPersonalInfo?.salaryModal.salaryThousand)!)
                    }
                    
                    wself.pushStaticMasterController(type: .SALARYINTHOUSAND, data: dataList)
                    
                }else if type == "CURRENT_AN" { //Annual Mode
                    var mode = [String:Any]()
                    mode["name"] = "Annually"
                    mode["uuid"] = kannuallyModeSalaryUUID
                    
                    wself.basicProfileInfo.additionPersonalInfo?.salaryModal.salaryMode = MICategorySelectionInfo(dictionary: mode) ?? MICategorySelectionInfo()
                    wself.basicProfileInfo.additionPersonalInfo?.salaryModal.salaryModeAnually = true
                    currentSalryCell.showDataForSalary(additionalData:wself.basicProfileInfo.additionPersonalInfo! )
                    
                }else if type == "CURRENT_MO" { //Monthly Mode
                    var mode = [String:Any]()
                    mode["name"] = "Monthly"
                    mode["uuid"] = kmonthlyModeSalaryUUID
                    
                    wself.basicProfileInfo.additionPersonalInfo?.salaryModal.salaryMode = MICategorySelectionInfo(dictionary: mode) ?? MICategorySelectionInfo()
                    wself.basicProfileInfo.additionPersonalInfo?.salaryModal.salaryModeAnually = false
                    currentSalryCell.showDataForSalary(additionalData:wself.basicProfileInfo.additionPersonalInfo! )
                    
                    
                }
            }
            return currentSalryCell
        }else{
            let cell = tableView.dequeueReusableCell(withClass: MITextFieldTableViewCell.self, for: indexPath)
            
            cell.primaryTextField.tag = indexPath.row
            cell.primaryTextField.isUserInteractionEnabled = true
            cell.primaryTextField.delegate = self
            cell.secondryTextField.isHidden = true
            cell.titleLabel.text = title
            cell.primaryTextField.placeholder = title
            cell.verifyBtn.isHidden = true
            cell.secondryTextField.setRightViewForTextField("darkRightArrow")
            cell.primaryTextField.setRightViewForTextField("darkRightArrow")
            cell.verfiedTextManaged(model: basicProfileInfo, title: title)
            
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
            if title == RegisterViewStoryBoardConstant.fullName {
                cell.primaryTextField.setRightViewForTextField()
                cell.primaryTextField.text = basicProfileInfo.fullName
            }else if title == RegisterViewStoryBoardConstant.currentLocation {
                cell.primaryTextField.isUserInteractionEnabled = false
                cell.primaryTextField.text = basicProfileInfo.additionPersonalInfo?.currentlocation.name
            }else if title == RegisterViewStoryBoardConstant.nationality {
                cell.primaryTextField.isUserInteractionEnabled = false
                cell.primaryTextField.text = basicProfileInfo.nationality.name
            }else if title == RegisterViewStoryBoardConstant.visaTypeField {
                cell.primaryTextField.isUserInteractionEnabled = false
                cell.primaryTextField.text = basicProfileInfo.additionPersonalInfo?.workVisaType.name
                cell.primaryTextField.placeholder = "Select Visa Type"
                cell.titleLabel.text = "Work authorization for  \(basicProfileInfo.additionPersonalInfo?.currentlocation.countryName ?? "Work authorization")"
            }else if title == RegisterViewStoryBoardConstant.email {
                cell.verifyBtn.isHidden = false
                cell.primaryTextField.isUserInteractionEnabled = false
                cell.primaryTextField.text = basicProfileInfo.primaryEmail
                cell.primaryTextField.setRightViewForTextField()
                cell.showPopUpCallBack = { [weak self] in
                    guard let wSelf = self else {return}
                    if !wSelf.basicProfileInfo.emailVerifedStatus  {
                        let emailVC = MIVerifyEmailTemplateViewController()
                        emailVC.userEmail = wSelf.basicProfileInfo.primaryEmail
                        wSelf.navigationController?.pushViewController(emailVC, animated: true)
                    }
                }
                cell.revertTextFields()
            }else if title == RegisterViewStoryBoardConstant.cityName {
                cell.primaryTextField.text = basicProfileInfo.additionPersonalInfo?.cityName
                cell.primaryTextField.setRightViewForTextField()
            }else if title == RegisterViewStoryBoardConstant.mobileNumber {
                cell.verifyBtn.isHidden = false
                cell.primaryTextField.setRightViewForTextField()
                cell.primaryTextField.placeholder = "Your number for employers to reach you"
                cell.primaryTextField.text = basicProfileInfo.mobileNumber
                cell.showPopUpCallBack = {[weak self] in
                    guard let wSelf = self else {return}
                    
                    wSelf.view.endEditing(true)
                    if !wSelf.basicProfileInfo.mobileNumberVerifedStatus  {
                        let mobileChange = MIOTPViewController()
                        mobileChange.openMode = .verifyMobileNumber
                        mobileChange.delegate = wSelf
                        mobileChange.countryCode = wSelf.basicProfileInfo.countryCode.replacingOccurrences(of: "+", with: "")
                        mobileChange.userName = wSelf.basicProfileInfo.mobileNumber
                        wSelf.navigationController?.pushViewController(mobileChange, animated: true)
                    }
                }
                
                var countryNameCode = ""
                if let country = AppDelegate.instance.splashModel.countries?.filter({ $0.callPrefix.stringValue == basicProfileInfo.countryCode }).first {
                    countryNameCode = country.isoCode
                }
                cell.secondryTextField.text = countryNameCode + " +" + basicProfileInfo.countryCode
                
                cell.secondryTextField.placeholder = "ISD"
                cell.secondryTextField.isHidden = false
                cell.revertTextFields()
                cell.secondryTextFieldAction = { [weak self]  txtFld in
                    guard let wself = self else { return false }
                    
                    let vc = MICountryCodePickerVC()
                    vc.countryCodeSeleted = { [weak self]country in
                        guard let wself = self else {return}
                        let code = "+" + country.callPrefix.stringValue
                        wself.basicProfileInfo.countryCode = code
                        wself.basicProfileInfo.countryCodeName = country.isoCode
                        txtFld.text = country.isoCode + "  " + code
                    }
                    wself.navigationController?.pushViewController(vc, animated: true)
                    
                    return false
                }
            }else if title == RegisterViewStoryBoardConstant.workExperience {
                cell.secondryTextField.isHidden = false
                cell.secondryTextField.placeholder = "Select Year"
                cell.primaryTextField.placeholder = "Select Month"
                let year = (basicProfileInfo.additionPersonalInfo?.workExperienceYear.isNumeric ?? false ? Int(basicProfileInfo.additionPersonalInfo?.workExperienceYear ?? "0") : 0) ?? 0
                cell.secondryTextField.text = (year == 1) ? "\(year) Year" : "\(year) Years"
                let mnth = (basicProfileInfo.additionPersonalInfo?.workExperienceMonth.isNumeric ?? false ? Int(basicProfileInfo.additionPersonalInfo?.workExperienceMonth ?? "0") : 0) ?? 0
                
                cell.primaryTextField.text = (mnth == 1) ? "\(mnth) Month" : "\(mnth) Months"
                
                
                cell.secondryTextFieldAction = { [weak self,weak cell]  txtFld in
                    guard let wself = self,let wcell = cell  else  {return false}
                    let staticMasterVC = MIStaticMasterDataViewController.newInstance
                    staticMasterVC.title = "Selection"
                    staticMasterVC.staticMasterType = .EXPEREINCEINYEAR
                    if !(wself.basicProfileInfo.additionPersonalInfo?.workExperienceYear.isEmpty ?? true) {
                        staticMasterVC.selectedDataArray = [wself.basicProfileInfo.additionPersonalInfo?.workExperienceYear] as! [String]
                    }
                    
                    staticMasterVC.selectedData = { value in
                        
                        if txtFld == wcell.secondryTextField {
                            wself.basicProfileInfo.additionPersonalInfo?.workExperienceYear = txtFld.text!
                        }else{
                            wself.basicProfileInfo.additionPersonalInfo?.workExperienceMonth = txtFld.text!
                        }
                        wself.tableViewEditProfile.reloadData()
                        
                    }
                    staticMasterVC.delagate = self
                    wself.navigationController?.pushViewController(staticMasterVC, animated: true)
                    
                    return false
                }
                cell.makeEqualTextFields()
            }else if title == RegisterViewStoryBoardConstant.experienceLevel {
                cell.primaryTextField.placeholder = title
                cell.primaryTextField.isUserInteractionEnabled = false
                cell.primaryTextField.text = basicProfileInfo.expereienceLevel
            }
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // let title = dataFieldsList[indexPath.row]
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.manageError(message: "", indexRow: -1, isPrimary: true)
        let title = dataFieldsList[indexPath.row]
        if title == RegisterViewStoryBoardConstant.currentLocation || title == RegisterViewStoryBoardConstant.nationality || title == RegisterViewStoryBoardConstant.visaTypeField{
            let vc = MIMasterDataSelectionViewController.newInstance
            vc.title = "Search"
            vc.delegate = self
            vc.limitSelectionCount = 1
            if title == RegisterViewStoryBoardConstant.currentLocation {
                vc.masterType = MasterDataType.LOCATION
                if !(basicProfileInfo.additionPersonalInfo?.currentlocation.name.isEmpty)! {
                    //     let tuples = self.getSelectedMasterDataFor(dataSource: [secObj.companyObj])
                    vc.selectedInfoArray = [basicProfileInfo.additionPersonalInfo?.currentlocation.name] as! [String]
                    vc.selectDataArray = [basicProfileInfo.additionPersonalInfo?.currentlocation] as! [MICategorySelectionInfo]
                }
            }else if title == RegisterViewStoryBoardConstant.nationality{
                vc.masterType = MasterDataType.NATIONALITY
                if !(basicProfileInfo.nationality.name.isEmpty) {
                    //     let tuples = self.getSelectedMasterDataFor(dataSource: [secObj.companyObj])
                    vc.selectedInfoArray = [basicProfileInfo.nationality.name]
                    vc.selectDataArray = [basicProfileInfo.nationality]
                }
            }else if title == RegisterViewStoryBoardConstant.visaTypeField{
                vc.masterType = MasterDataType.VISA_TYPE
                vc.isoCountryCode = basicProfileInfo.additionPersonalInfo?.currentlocation.countryISOCode.withoutWhiteSpace().uppercased()
                if let visa = basicProfileInfo.additionPersonalInfo?.workVisaType , !visa.name.withoutWhiteSpace().isEmpty{
                    vc.selectedInfoArray = [visa.name]
                    vc.selectDataArray = [visa]
                }
                
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
        }else if title == RegisterViewStoryBoardConstant.experienceLevel {
            let vc = MIProfessionalDetailViewController()
            vc.experienceLevelData = {[weak self] value in
                guard let wself = self else {return}
                wself.basicProfileInfo.expereienceLevel = value
                wself.manageDataFields()
                wself.tableViewEditProfile.reloadData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
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
    
}


extension MIEditProfileVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.manageError(message: "", indexRow: -1, isPrimary: true)
        if dataFieldsList[textField.tag] == RegisterViewStoryBoardConstant.workExperience {
            if let cell = self.tableViewEditProfile.cellForRow(at: IndexPath(row: textField.tag, section: 0)) as? MITextFieldTableViewCell {
                let staticMasterVC = MIStaticMasterDataViewController.newInstance
                staticMasterVC.title = "Selection"
                if textField == cell.primaryTextField {
                    staticMasterVC.staticMasterType = .EXPEREINCEINMONTH
                    if !(textField.text?.isEmpty)! {
                        staticMasterVC.selectedDataArray = [basicProfileInfo.additionPersonalInfo?.workExperienceMonth] as! [String]
                    }
                }
                staticMasterVC.selectedData = { [weak self,weak cell] value in
                    guard let wSelf = self , let wCell = cell else {return}
                    if textField == wCell.primaryTextField {
                        wSelf.basicProfileInfo.additionPersonalInfo?.workExperienceMonth = textField.text!
                    }
                    wSelf.tableViewEditProfile.reloadData()
                }
                staticMasterVC.delagate = self
                self.navigationController?.pushViewController(staticMasterVC, animated: true)
                return false
            }
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        let title = dataFieldsList[textField.tag]
        if string.count == 0 {
            return true
        }
        if let stringData = textField.text?.appending(string)  {
            if title == RegisterViewStoryBoardConstant.salary {
                if (stringData.count) > 11 {
                    return false
                }
            }
            if title == RegisterViewStoryBoardConstant.fullName {
                let letters = NSCharacterSet.letters
                let range = string.rangeOfCharacter(from: letters)
                if string == " " {
                    return true
                }
                // range will be nil if no letters is found
                if range == nil {
                    return false
                }
            }
            if title == RegisterViewStoryBoardConstant.mobileNumber {
                return (stringData.count <= stringData.validiateMobile(for: self.basicProfileInfo.countryCode).thresholdValue)
            }
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let title = dataFieldsList[textField.tag]
        if title == RegisterViewStoryBoardConstant.fullName {
            basicProfileInfo.fullName = (textField.text?.withoutWhiteSpace())!
        }else if title == RegisterViewStoryBoardConstant.mobileNumber {
            basicProfileInfo.mobileNumber = (textField.text?.withoutWhiteSpace())!
        }else if title == RegisterViewStoryBoardConstant.cityName {
            basicProfileInfo.additionPersonalInfo?.cityName = (textField.text?.withoutWhiteSpace())!
        }else if title == RegisterViewStoryBoardConstant.salary {
            basicProfileInfo.additionPersonalInfo?.salaryModal.salaryInLakh     = (textField.text?.isEmpty ?? true) ? "0" : textField.text ?? "0"
            basicProfileInfo.additionPersonalInfo?.salaryModal.salaryThousand = "0"
            self.tableViewEditProfile.reloadData()
        }
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.setMainViewFrame(originY: 0)
            }
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let title = dataFieldsList[textField.tag]
        textField.keyboardType = .asciiCapable
        textField.inputAccessoryView = nil
        DispatchQueue.main.async {
            
            self.setMainViewFrame(originY: 0)
            let movingHeight = textField.movingHeightIn(view : self.view) + 35
            if movingHeight > 0 {
                UIView.animate(withDuration: 0.3) {
                    
                    self.setMainViewFrame(originY: -movingHeight)
                }
            }
        }
        if title == RegisterViewStoryBoardConstant.fullName {
            textField.returnKeyType = .done
        }
        if title == RegisterViewStoryBoardConstant.mobileNumber {
            textField.keyboardType = .numberPad
            textField.addDoneButtonOnKeyboard()
        }
        if title == RegisterViewStoryBoardConstant.salary {
            textField.keyboardType = .numberPad
            textField.addDoneButtonOnKeyboard()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

extension MIEditProfileVC :  MIMasterDataSelectionViewControllerDelegate {
    
    func masterDataSelected(selectedCategoryInfo: [MICategorySelectionInfo], selectedListInfo: [String], enumName: String) {
        self.manageError(message: "", indexRow: -1, isPrimary: true)
        if enumName == MasterDataType.LOCATION.rawValue {
            basicProfileInfo.additionPersonalInfo?.currentlocation = selectedCategoryInfo.last ?? MICategorySelectionInfo()
            basicProfileInfo.additionPersonalInfo?.cityName = ""
            basicProfileInfo.additionPersonalInfo?.workVisaType = MICategorySelectionInfo()
            self.manageDataFields()
            
        }else if enumName == MasterDataType.NATIONALITY.rawValue {
            basicProfileInfo.nationality = selectedCategoryInfo.last ?? MICategorySelectionInfo()
            basicProfileInfo.additionPersonalInfo?.workVisaType = MICategorySelectionInfo()
            self.manageDataFields()
            
        }else if enumName == MasterDataType.VISA_TYPE.rawValue {
            basicProfileInfo.additionPersonalInfo?.workVisaType = selectedCategoryInfo.last ?? MICategorySelectionInfo()
            CommonClass.googleEventTrcking("profile_screen", action: "work_visa", label: basicProfileInfo.additionPersonalInfo?.workVisaType.name ?? "")
        }
        self.tableViewEditProfile.reloadData()
        
    }
}

extension MIEditProfileVC : PendingActionDelegate {
    func verifiedUser(_ id: String, openMode: OpenMode) {
        shouldRunProfileApi = true
        if openMode == .verifyMobileNumber {
            JobSeekerSingleton.sharedInstance.fieldLevelDataArray = [CONSTANT_FIELD_LEVEL_NAME.VERIFY_MOBILE]
            basicProfileInfo.mobileNumberVerifedStatus = true
        }else if openMode == .verifyEmail {
            // JobSeekerSingleton.sharedInstance.fieldLevelDataArray = [CONSTANT_FIELD_LEVEL_NAME.VERIFY_EMAIL]
            
            basicProfileInfo.emailVerifedStatus = true
        }
        self.tableViewEditProfile.reloadData()
    }
}
extension MIEditProfileVC:UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count >= 250 {
            return
        }
        UIView.setAnimationsEnabled(false)
        self.tableViewEditProfile.beginUpdates()
        
        let fixedWidth: CGFloat = textView.frame.size.width
        if self.dataFieldsList[textView.tag] == RegisterViewStoryBoardConstant.profileTitle {
            if let cell = self.tableViewEditProfile.cellForRow(at: IndexPath(row: textView.tag, section: 0)) as? MITextViewTableViewCell {
                let newSize: CGSize = textView.sizeThatFits(CGSize(width:fixedWidth,height:.greatestFiniteMagnitude))
                var frame = cell.textView.frame
                frame.size.height = newSize.height
                cell.textView.frame = frame
                //cell.textView.frame.size = newSize
                self.tableViewEditProfile.endUpdates()
                UIView.setAnimationsEnabled(true)
            }
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        DispatchQueue.main.async {
            
            self.setMainViewFrame(originY: 0)
            let movingHeight = textView.movingHeightIn(view : self.view) + 40
            if movingHeight > 0 {
                UIView.animate(withDuration: 0.3) {
                    self.setMainViewFrame(originY: -movingHeight)
                }
            }
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        basicProfileInfo.profileTitle = textView.text.withoutWhiteSpace()
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                
                self.setMainViewFrame(originY: 0)
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "" {
            return true
        }
        let profileTitle = textView.text.appending(text)
        if profileTitle.count > 250 {
            return false
        }
        if ((textView.textInputMode?.primaryLanguage == "emoji") || ((textView.textInputMode?.primaryLanguage) == nil)) {
            return false
        }
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
extension MIEditProfileVC : MIStaticMasterDataSelectionDelegate {
    func staticMasterDataSelected(selectedData: [String], masterType: String) {
        self.manageError(message: "", indexRow: -1, isPrimary: true)
        if masterType == StaticMasterData.EXPEREINCEINMONTH.rawValue {
            basicProfileInfo.additionPersonalInfo?.workExperienceMonth = selectedData.first ?? ""
        }
        if masterType == StaticMasterData.EXPEREINCEINYEAR.rawValue {
            basicProfileInfo.additionPersonalInfo?.workExperienceYear = selectedData.first ?? ""
        }
        if masterType == StaticMasterData.CURRENCY.rawValue {
            basicProfileInfo.additionPersonalInfo?.salaryModal.salaryCurrency = selectedData.first ?? ""
            basicProfileInfo.additionPersonalInfo?.salaryModal.salaryInLakh = "0"
            basicProfileInfo.additionPersonalInfo?.salaryModal.salaryThousand = "0"
        }
        if masterType == StaticMasterData.SALARYINLAKH.rawValue {
            basicProfileInfo.additionPersonalInfo?.salaryModal.salaryInLakh = selectedData.first ?? "0"
        }
        if masterType == StaticMasterData.SALARYINTHOUSAND.rawValue {
            basicProfileInfo.additionPersonalInfo?.salaryModal.salaryThousand = selectedData.first ?? "0"
        }
        UIView.performWithoutAnimation {
            self.tableViewEditProfile.reloadData()
        }
    }
}
extension MIEditProfileVC : JobPreferencePopUpDelegate {
    
    func optionCompleteIgnoredSelected(popSelection: PopUpOptionSelection, popup: MIPopupView) {
        
        if popup == self.hPopup {
            if popSelection == .Completed {
                //Scroll To Mobile Number
                let mobileChange = MIOTPViewController()
                mobileChange.openMode = .verifyMobileNumber
                mobileChange.delegate = self
                mobileChange.countryCode = self.basicProfileInfo.countryCode.replacingOccurrences(of: "+", with: "")
                mobileChange.userName = self.basicProfileInfo.mobileNumber
                mobileChange.otpVerifySuccess = { [weak self] status in
                    guard let wself = self else {return}
                    if status {
                        JobSeekerSingleton.sharedInstance.fieldLevelDataArray = [CONSTANT_FIELD_LEVEL_NAME.VERIFY_MOBILE]
                        wself.callAPIForUpdateUserPersonalDetail()
                    }
                }
                self.navigationController?.pushViewController(mobileChange, animated: true)
                
            }else{
                
            }
        }
    }
    
}

