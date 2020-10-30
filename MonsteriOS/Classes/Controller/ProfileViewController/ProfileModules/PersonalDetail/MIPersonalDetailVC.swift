//
//  MIPersonalDetailVC.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 23/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit



class MIPersonalDetailVC: MIBaseViewController {
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var save_btn : UIButton!
    
    private var dataSource = [String]()
    var personalDict : [String:Any]?
    var personalModel = MIPersonalDetail()
    var personalDetailUpdateSuccessCallBack : ((Bool)-> Void)?
    var error: (message: String, index: Int,isPrimaryError:Bool) = ("", -1,false)
    
    class var newInstance:MIPersonalDetailVC {
        get {
            return Storyboard.main.instantiateViewController(withIdentifier: "MIPersonalDetailVC") as! MIPersonalDetailVC
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.tableView.register(nib: MISeparateCheckTickCell.loadNib(), withCellClass: MISeparateCheckTickCell.self)
        tableView.register(UINib(nibName:String(describing: MITextViewTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MITextViewTableViewCell.self))
        self.tableView.register(UINib(nibName:String(describing: MI3RadioButtonTableCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MI3RadioButtonTableCell.self))
        
        tableView.register(UINib(nibName:String(describing: MITextFieldTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MITextFieldTableViewCell.self))
        
        self.manageDataFieldForSpeciallyAbled(isSpeciallyAbled: false)
        tableView.delegate=self
        tableView.dataSource=self
        tableView.estimatedRowHeight = 44.0 //tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        self.callAPIForGetUserPersonalDetail()
        save_btn.setTitle("Update", for: .normal)
        save_btn.showPrimaryBtn()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)
        self.tableView.layoutSubviews()
        self.tableView.reloadData()
        self.navigationItem.title = "Personal Details"
        self.view.setNeedsLayout()
        
    }
    
    func manageDataFieldForSpeciallyAbled(isSpeciallyAbled:Bool) {
        
        let sourceCountry = AppDelegate.instance.site?.defaultCountryDetails.isoCode ?? ""
        
        if isSpeciallyAbled {
            if sourceCountry.lowercased() == "in" {
                if personalModel.disabilityObj.type.uuid == kSpeciallyAbleTypeIsPhysicalUUID {
                    dataSource = [PersonalTitleConstant.DOB,PersonalTitleConstant.Gender,PersonalTitleConstant.MaritalStatus,PersonalTitleConstant.homeTown,PersonalTitleConstant.PermanentAddress,PersonalTitleConstant.PinCode,PersonalTitleConstant.Category,PersonalTitleConstant.Nationality,PersonalTitleConstant.PassportNumber,MIJobPreferenceViewControllerConstant.residentStatus,PersonalTitleConstant.USAPermit,PersonalTitleConstant.CountryPermit,PersonalTitleConstant.SpeciallAbled,PersonalTitleConstant.disabilityType,PersonalTitleConstant.disabilitySubtype,PersonalTitleConstant.disabilityDetails,PersonalTitleConstant.disabilityDescription,PersonalTitleConstant.disabilityCertificationNo,PersonalTitleConstant.disabilityIssueBy]
                    
                }else{
                    dataSource = [PersonalTitleConstant.DOB,PersonalTitleConstant.Gender,PersonalTitleConstant.MaritalStatus,PersonalTitleConstant.homeTown,PersonalTitleConstant.PermanentAddress,PersonalTitleConstant.PinCode,PersonalTitleConstant.Category,PersonalTitleConstant.Nationality,PersonalTitleConstant.PassportNumber,MIJobPreferenceViewControllerConstant.residentStatus,PersonalTitleConstant.USAPermit,PersonalTitleConstant.CountryPermit,PersonalTitleConstant.SpeciallAbled,PersonalTitleConstant.disabilityType,PersonalTitleConstant.disabilitySubtype,PersonalTitleConstant.disabilityDescription,PersonalTitleConstant.disabilityCertificationNo,PersonalTitleConstant.disabilityIssueBy]
                    
                }
                
            }else{
                if personalModel.disabilityObj.type.uuid == kSpeciallyAbleTypeIsPhysicalUUID {
                    dataSource = [PersonalTitleConstant.DOB,PersonalTitleConstant.Gender,PersonalTitleConstant.MaritalStatus,PersonalTitleConstant.homeTown,PersonalTitleConstant.PermanentAddress,PersonalTitleConstant.PinCode,PersonalTitleConstant.Nationality,PersonalTitleConstant.PassportNumber,MIJobPreferenceViewControllerConstant.residentStatus,PersonalTitleConstant.USAPermit,PersonalTitleConstant.CountryPermit,PersonalTitleConstant.SpeciallAbled,PersonalTitleConstant.disabilityType,PersonalTitleConstant.disabilitySubtype,PersonalTitleConstant.disabilityDetails,PersonalTitleConstant.disabilityDescription,PersonalTitleConstant.disabilityCertificationNo,PersonalTitleConstant.disabilityIssueBy]
                    
                }else{
                    dataSource = [PersonalTitleConstant.DOB,PersonalTitleConstant.Gender,PersonalTitleConstant.MaritalStatus,PersonalTitleConstant.homeTown,PersonalTitleConstant.PermanentAddress,PersonalTitleConstant.PinCode,PersonalTitleConstant.Nationality,PersonalTitleConstant.PassportNumber,MIJobPreferenceViewControllerConstant.residentStatus,PersonalTitleConstant.USAPermit,PersonalTitleConstant.CountryPermit,PersonalTitleConstant.SpeciallAbled,PersonalTitleConstant.disabilityType,PersonalTitleConstant.disabilitySubtype,PersonalTitleConstant.disabilityDescription,PersonalTitleConstant.disabilityCertificationNo,PersonalTitleConstant.disabilityIssueBy]
                    
                }
                
            }
        }else{
            
            if sourceCountry.lowercased() == "in" {
                dataSource = [PersonalTitleConstant.DOB,PersonalTitleConstant.Gender,PersonalTitleConstant.MaritalStatus,PersonalTitleConstant.homeTown,PersonalTitleConstant.PermanentAddress,PersonalTitleConstant.PinCode,PersonalTitleConstant.Category,PersonalTitleConstant.Nationality,PersonalTitleConstant.PassportNumber,MIJobPreferenceViewControllerConstant.residentStatus,PersonalTitleConstant.USAPermit,PersonalTitleConstant.CountryPermit,PersonalTitleConstant.SpeciallAbled]
                
            }else{
                dataSource = [PersonalTitleConstant.DOB,PersonalTitleConstant.Gender,PersonalTitleConstant.MaritalStatus,PersonalTitleConstant.homeTown,PersonalTitleConstant.PermanentAddress,PersonalTitleConstant.PinCode,PersonalTitleConstant.Nationality,PersonalTitleConstant.PassportNumber,MIJobPreferenceViewControllerConstant.residentStatus,PersonalTitleConstant.USAPermit,PersonalTitleConstant.CountryPermit,PersonalTitleConstant.SpeciallAbled]
            }
        }
        self.tableView.reloadData()
        self.tableView.setNeedsLayout()
        
    }
    func manageError(message:String,indexRow:Int,isPrimary:Bool) {
        self.error = (message,indexRow,isPrimary)
        if indexRow > -1 {
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(row: indexRow, section: 0), at: .top, animated: false)
            
        }
    }
    func validateFields()-> Bool {
        var isFieldVerified = true
        if personalModel.nationality.name.isEmpty {
            if let index = dataSource.firstIndex(of: PersonalTitleConstant.Nationality) {
                self.manageError(message: PersonalTitleConstant.NationalityEmpty, indexRow: index, isPrimary: true)
            }
            isFieldVerified = false
        }
        return isFieldVerified
    }
}

extension MIPersonalDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = self.dataSource[indexPath.row]
        if title == PersonalTitleConstant.SpeciallAbled {
            let cell = tableView.dequeueReusableCell(withClass: MISeparateCheckTickCell.self, for: indexPath)
            cell.checkboxButtn.isSelected = personalModel.speciallAbled
            cell.checkBoxSelectionAction = { (selectedState,cell) in
                self.manageError(message: "", indexRow: -1, isPrimary: true)
                self.personalModel.speciallAbled  = selectedState
                self.manageDataFieldForSpeciallyAbled(isSpeciallyAbled: selectedState)
            }
            return cell
        } else if title == PersonalTitleConstant.CountryPermit || title == MIJobPreferenceViewControllerConstant.residentStatus{
            let tvCell = tableView.dequeueReusableCell(withClass: MITextViewTableViewCell.self, for: indexPath)
            tvCell.textView.isUserInteractionEnabled = true
            tvCell.titleLabel.text = self.dataSource[indexPath.row]
            tvCell.textView.placeholder = self.dataSource[indexPath.row] as NSString
            var names = [String]()

            if title == PersonalTitleConstant.CountryPermit {
                names = (self.personalModel.workPermits.map({ $0.name}))
            } else {
                names = (self.personalModel.residentStatus.map({ $0.name}))
            }
            tvCell.textView.text = names.joined(separator: ", ")
            tvCell.textView.delegate = self
            tvCell.textView.tag = indexPath.row+505
            tvCell.accessoryImageView.isHidden = false
            return tvCell
        }
        else {
            let cell = tableView.dequeueReusableCell(withClass: MITextFieldTableViewCell.self, for: indexPath)
            cell.secondryTextField.isHidden = true
            cell.primaryTextField.delegate = self
            cell.primaryTextField.placeholder = self.dataSource[indexPath.row]
            cell.titleLabel.text = self.dataSource[indexPath.row]
            cell.primaryTextField.setRightViewForTextField("darkRightArrow")
            let errorText = (self.error.index == indexPath.row && error.isPrimaryError) ? self.error.message : ""
            cell.showError(with:errorText, animated: false)
            switch title {
                case PersonalTitleConstant.homeTown:
                    cell.primaryTextField.text = self.personalModel.homeTown.name
                case PersonalTitleConstant.PermanentAddress:
                    cell.primaryTextField.text = self.personalModel.permentantAddress
                    cell.primaryTextField.setRightViewForTextField()
                case PersonalTitleConstant.DOB:
                    cell.primaryTextField.setRightViewForTextField("calendarBlue")
                    cell.primaryTextField.text = self.personalModel.dob?.getStringWithFormat(format: "dd MMM, yyyy")
                case PersonalTitleConstant.PinCode:
                    cell.primaryTextField.setRightViewForTextField()
                    cell.primaryTextField.text = self.personalModel.pincode
                case PersonalTitleConstant.MaritalStatus:
                    cell.primaryTextField.text = self.personalModel.maretialStatus.name
                case PersonalTitleConstant.Category:
                    cell.primaryTextField.text = self.personalModel.category.name
                case PersonalTitleConstant.PassportNumber:
                    cell.primaryTextField.setRightViewForTextField()
                    cell.primaryTextField.text = self.personalModel.passportNumber
                case PersonalTitleConstant.Nationality:
                    cell.primaryTextField.text = self.personalModel.nationality.name
                case PersonalTitleConstant.USAPermit:
                    cell.primaryTextField.text = self.personalModel.workPermitUSA.name
                case PersonalTitleConstant.disabilityType:
                    cell.primaryTextField.text = self.personalModel.disabilityObj.type.name
                case PersonalTitleConstant.disabilitySubtype:
                    cell.primaryTextField.text = self.personalModel.disabilityObj.subtype.name
                case PersonalTitleConstant.disabilityDetails:
                    cell.primaryTextField.text = self.personalModel.disabilityObj.detail.name
                case PersonalTitleConstant.disabilityDescription:
                    cell.primaryTextField.setRightViewForTextField()
                    cell.primaryTextField.text = self.personalModel.disabilityObj.disabilityDescription
                case PersonalTitleConstant.disabilityCertificationNo:
                    cell.primaryTextField.text = self.personalModel.disabilityObj.disabilityCertificate
                    cell.primaryTextField.setRightViewForTextField()
                case PersonalTitleConstant.disabilityIssueBy:
                    cell.primaryTextField.text = self.personalModel.disabilityObj.disabilityIssuer
                    cell.primaryTextField.setRightViewForTextField()
                case PersonalTitleConstant.Gender:
                    let cell = tableView.dequeueReusableCell(withClass: MI3RadioButtonTableCell.self, for: indexPath)
                    cell.titleLabel.text = title
                    cell.setButtons("Male", button2: "Female", button3: "Perfer not to specify")
                    
                    switch self.personalModel.gender.uuid.lowercased() {
                    case kGenderMaleUUID.lowercased():
                        cell.selectRadioButton(at: 0)
                    case kGenderFemaleUUID.lowercased():
                        cell.selectRadioButton(at: 1)
                    case kGenderOtherUUID.lowercased():
                        cell.selectRadioButton(at: 2)
                    default:
                        break
                    }
                    cell.radioBtnSelection = { index, title in
                        switch index {
                        case 0: //Full Time
                            self.personalModel.gender = MICategorySelectionInfo(dictionary: ["name":title,"uuid":"bd5a224c-fc69-11e8-92d8-000c290b6677"]) ?? MICategorySelectionInfo()
                            
                        case 1: //Part Time
                            self.personalModel.gender = MICategorySelectionInfo(dictionary: ["name":title,"uuid":"ccc7faa0-fc69-11e8-92d8-000c290b6677"]) ?? MICategorySelectionInfo()
                            
                        default: //Correspondence
                            self.personalModel.gender = MICategorySelectionInfo(dictionary: ["name":title,"uuid":"c7f21630-2480-11e9-aabd-70106fbef856"]) ?? MICategorySelectionInfo()
                        }
                    }
                    return cell
                default:
                    cell.primaryTextField.text = ""
            }
            cell.primaryTextField.tag = indexPath.row + 505
            return cell
        }
    }
    
}
extension MIPersonalDetailVC : UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        let dataModel = self.dataSource[textView.tag-505]
        if dataModel == PersonalTitleConstant.CountryPermit  {
            self.showMasterdataController(masterType: .COUNTRY, valueObj: personalModel.workPermits, limitCount: 10,filed: dataModel)
            return false
        }
        if dataModel == MIJobPreferenceViewControllerConstant.residentStatus {
            self.showMasterdataController(masterType: .COUNTRY, valueObj: personalModel.residentStatus, limitCount: 10,filed: dataModel)
            return false
        }
        return true
    }
}
extension MIPersonalDetailVC : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let dataModel = self.dataSource[textField.tag-505]
        switch dataModel {
        case PersonalTitleConstant.PermanentAddress:
            personalModel.permentantAddress = (textField.text?.withoutWhiteSpace()) ?? ""
        case PersonalTitleConstant.PinCode:
            personalModel.pincode = (textField.text?.withoutWhiteSpace()) ?? ""
        case PersonalTitleConstant.PassportNumber:
            personalModel.passportNumber = (textField.text?.withoutWhiteSpace()) ?? ""
        case PersonalTitleConstant.disabilityCertificationNo:
            personalModel.disabilityObj.disabilityCertificate = (textField.text?.withoutWhiteSpace()) ?? ""
        case PersonalTitleConstant.disabilityIssueBy:
            personalModel.disabilityObj.disabilityIssuer = (textField.text?.withoutWhiteSpace()) ?? ""
        case PersonalTitleConstant.disabilityDescription:
            personalModel.disabilityObj.disabilityDescription = (textField.text?.withoutWhiteSpace()) ?? ""
        default:
            break
        }
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.setMainViewFrame(originY: 0)
            }
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
       
        let dataModel = self.dataSource[textField.tag-505]
        textField.autocorrectionType = .no
        if dataModel == PersonalTitleConstant.DOB {
            self.view.endEditing(true)
            self.manageError(message: "", indexRow: -1, isPrimary: true)
            let date = Calendar.current.date(byAdding: .year, value: -15, to: Date())
            MIDatePicker.selectDate(title: "", hideCancel: false, datePickerMode: .date, selectedDate: date, minDate: nil, maxDate: date) { (dateSelected) in
                self.personalModel.dob = dateSelected
                textField.text =  dateSelected.getStringWithFormat(format: "dd MMM, yyyy")
                
            }
            return false
        }
        if dataModel == PersonalTitleConstant.Category {
            self.showMasterdataController(masterType: .RESERVATION_CATEGORY, valueObj: [personalModel.category], limitCount: 1)
            return false
        }
        
        if dataModel == PersonalTitleConstant.MaritalStatus {
            self.showMasterdataController(masterType: .MARITIAL_STATUS, valueObj:[personalModel.maretialStatus], limitCount: 1 )
            return false
        }
        if dataModel == PersonalTitleConstant.USAPermit {
            self.showMasterdataController(masterType: .VISA_TYPE, valueObj: [personalModel.workPermitUSA], limitCount: 1)
            return false
        }
        if dataModel == PersonalTitleConstant.Nationality {
            self.showMasterdataController(masterType: .NATIONALITY, valueObj: [personalModel.nationality], limitCount: 1)
            return false
        }
        if dataModel == PersonalTitleConstant.homeTown {
            self.showMasterdataController(masterType: .LOCATION, valueObj: [personalModel.homeTown], limitCount: 1)
            return false
        }
        if dataModel == PersonalTitleConstant.disabilityType {
            self.showMasterdataController(masterType: .DISABILITY, valueObj: [personalModel.disabilityObj.type], limitCount: 1)
            return false
        }
        if dataModel == PersonalTitleConstant.disabilitySubtype {
            if !personalModel.disabilityObj.type.name.isEmpty {
                self.showMasterdataController(masterType: .DISABILITY_SUBTYPE, valueObj: [personalModel.disabilityObj.subtype], limitCount: 1)
            }else{
                self.showAlert(title: "", message: "Please select disability type first.")
            }
            return false
        }
        if dataModel == PersonalTitleConstant.disabilityDetails {
            if personalModel.disabilityObj.type.name.count > 0 && personalModel.disabilityObj.subtype.name.count > 0    {
                self.showMasterdataController(masterType: .DISABILITY_DETAIL, valueObj: [personalModel.disabilityObj.detail], limitCount: 1)
            }else{
                if personalModel.disabilityObj.type.name.isEmpty  {
                    self.showAlert(title: "", message: "Please select disability type first.")
                }else{
                    self.showAlert(title: "", message: "Please select disability sub type first.")
                }
            }
            return false
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let dataModel = self.dataSource[textField.tag-505]
        DispatchQueue.main.async {
            self.setMainViewFrame(originY: 0)
            let movingHeight = textField.movingHeightIn(view : self.view)
            if movingHeight > 0 {
                UIView.animate(withDuration: 0.3) {
                    self.setMainViewFrame(originY: -movingHeight)
                }
            }
        }
        textField.keyboardType = .asciiCapable
        textField.returnKeyType = .next
        textField.inputAccessoryView = nil
        if dataModel == PersonalTitleConstant.PinCode {
            textField.keyboardType = .numberPad
            textField.addDoneButtonOnKeyboard()
        }
        if dataModel == PersonalTitleConstant.disabilityIssueBy || dataModel == PersonalTitleConstant.PermanentAddress || dataModel == PersonalTitleConstant.PassportNumber {
            textField.returnKeyType = .done
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        let inputText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        let dataModel = self.dataSource[textField.tag-505]
        if dataModel == PersonalTitleConstant.PinCode {
            if inputText.count >= 7 {
                return false
            }
        }
        if dataModel == PersonalTitleConstant.PassportNumber {
            if inputText.count >= 11 {
                return false
            }
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .done {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3) {
                    self.setMainViewFrame(originY: 0)
                }
            }
            self.view.endEditing(true)
        }else{
            if let textFld = self.view.viewWithTag(textField.tag+1) as? UITextField {
                textFld.becomeFirstResponder()
            }
        }
        return true
    }
    func getSelectedMasterDataFor(dataSource:[MICategorySelectionInfo]) -> (masterDataNames:[String],masterDataObject:[MICategorySelectionInfo]) {
        var selectedInfoArray = [String]()
        var selectDataArray = [MICategorySelectionInfo]()
        if (dataSource.count) > 0 {
            let dataNames = dataSource.filter{$0.name.isEmpty == false}
            if dataNames.count > 0 {
                selectedInfoArray = (dataSource.map({ $0.name}))
                selectDataArray = dataSource
            }
        }
        return (selectedInfoArray,selectDataArray)
        
    }
    func showMasterdataController(masterType:MasterDataType,valueObj:[MICategorySelectionInfo],limitCount:Int,filed:String? = nil) {
        self.manageError(message: "", indexRow: -1, isPrimary: true)
        let vc = MIMasterDataSelectionViewController.newInstance
        vc.title = MIEducationDetailViewControllerConstant.search
        vc.limitSelectionCount = limitCount
        vc.masterType = masterType
        self.view.endEditing(true)
        if masterType == .VISA_TYPE {
            vc.isoCountryCode = "US"
        }
        if  masterType == .DISABILITY_SUBTYPE {
            vc.parentId = MICategorySelectionInfo.getParentUUIDs(modalDataSource: [personalModel.disabilityObj.type])
        }
        if  masterType == .DISABILITY_DETAIL {
            vc.parentId = MICategorySelectionInfo.getParentUUIDs(modalDataSource: [personalModel.disabilityObj.subtype])
        }
        if filed == MIJobPreferenceViewControllerConstant.residentStatus {
            vc.selectionHandler = {  data in
                self.personalModel.residentStatus = data
                self.tableView.reloadData()
            }
        }else{
            vc.delegate = self

        }
        let tuples = self.getSelectedMasterDataFor(dataSource: valueObj)
        vc.selectDataArray = tuples.masterDataObject
        vc.selectedInfoArray = tuples.masterDataNames
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - IBAction Methods
    @IBAction func savePersonalDteailAction(sender:UIButton) {
        self.saveUserProfile()
    }
    
    func saveUserProfile() {
        self.view.endEditing(true)
        if self.validateFields() {
            self.callAPIForUpdateUserPersonalDetail()
        }
    }
    
    //MARK: - API Helper Methods
    func callAPIForGetUserPersonalDetail() {
        
        if  let personalDetailSection  = personalDict![APIKeys.personalDetailSectionAPIKey] as? [String:Any],let personalDetails =  personalDetailSection[APIKeys.personalDetailsAPIKey] as? [String:Any] {
            DispatchQueue.main.async {
                self.personalModel = MIPersonalDetail.getModelFromDict(params: personalDetails)
                self.manageDataFieldForSpeciallyAbled(isSpeciallyAbled: self.personalModel.speciallAbled)
                self.tableView.reloadData()

                
            }
        }else{
            self.startActivityIndicator()
            MIApiManager.callAPIForGetPersonalDetail(methodType: .get, path: APIPath.personalDetailGETAPIEndpoint) { (success, response, error, code) in
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    shouldRunProfileApi = true
                    if error == nil && (code >= 200) && (code <= 299) {
                        if let data = response as? [String:Any] {
                            if  let personalDetailSection  = data[APIKeys.personalDetailSectionAPIKey] as? [String:Any],let personalDetails =  personalDetailSection[APIKeys.personalDetailsAPIKey] as? [String:Any] {
                                    self.personalModel = MIPersonalDetail.getModelFromDict(params: personalDetails)
                                    self.manageDataFieldForSpeciallyAbled(isSpeciallyAbled: self.personalModel.speciallAbled)
                                    self.tableView.reloadData()
                            }
                        }
                    }else{
                        self.handleAPIError(errorParams: response, error: error)
                    }
                }
            }
        }
    }
    func callAPIForUpdateUserPersonalDetail() {
        
        let parms = MIPersonalDetail.getDictFromPersonalDetailList(personalData: personalModel)
        self.startActivityIndicator()
        
        MIApiManager.callAPIForUpdatePersonalDetail(methodType: .put, path:APIPath.personalDetailPUTAPIEndpoint, params: parms) {[weak self] (success, response, error, code) in
            DispatchQueue.main.async {
                
                guard let `self` = self else { return }

                self.stopActivityIndicator()
                shouldRunProfileApi = true
                if error == nil && (code >= 200) && (code <= 299) {
                    if  let personalDetailSection  = self.personalDict![APIKeys.personalDetailSectionAPIKey] as? [String:Any],let personalDetails =  personalDetailSection[APIKeys.personalDetailsAPIKey] as? [String:Any] {

                        if let nationality = personalDetails[APIKeys.nationalityAPIKey] as? [String:Any] {
                            if (nationality["name"] as? String)?.lowercased() != self.personalModel.nationality.name {
                                JobSeekerSingleton.sharedInstance.fieldLevelDataArray = [CONSTANT_FIELD_LEVEL_NAME.NATIONALITY]
                            }
                        }
                    }
                    
                   // self.showAlert(title: "", message: "Personal detail updated successfully.",isErrorOccured: false)
                    if let aciton = self.personalDetailUpdateSuccessCallBack {
                                           aciton(true)
                                       }
                    self.showAlert(title: "", message: "Personal detail updated successfully.", isErrorOccured: false) {
                        self.navigationController?.popViewController(animated: true)

                    }
                   
                }else{
                    self.handleAPIError(errorParams: response, error: error)
                }
            }
        }
    }
}

extension MIPersonalDetailVC : MIMasterDataSelectionViewControllerDelegate {
    
    func masterDataSelected(selectedCategoryInfo: [MICategorySelectionInfo], selectedListInfo: [String], enumName: String) {
        
        if enumName == MasterDataType.NATIONALITY.rawValue {
            personalModel.nationality = selectedCategoryInfo.first ?? MICategorySelectionInfo()
            self.manageDataFieldForSpeciallyAbled(isSpeciallyAbled: personalModel.speciallAbled)
        }
        if enumName == MasterDataType.MARITIAL_STATUS.rawValue {
            personalModel.maretialStatus = selectedCategoryInfo.first ?? MICategorySelectionInfo()
        }
        if enumName == MasterDataType.RESERVATION_CATEGORY.rawValue {
            personalModel.category = selectedCategoryInfo.first ?? MICategorySelectionInfo()
        }
        if enumName == MasterDataType.VISA_TYPE.rawValue {
            personalModel.workPermitUSA = selectedCategoryInfo.first ?? MICategorySelectionInfo()
        }
        if enumName == MasterDataType.COUNTRY.rawValue {
            personalModel.workPermits = selectedCategoryInfo
        }
        
        if enumName == MasterDataType.LOCATION.rawValue {
            personalModel.homeTown = selectedCategoryInfo.first ?? MICategorySelectionInfo()
        }
        if enumName == MasterDataType.DISABILITY.rawValue {
            if personalModel.disabilityObj.type.uuid != selectedCategoryInfo.first?.uuid {
                personalModel.disabilityObj.subtype = MICategorySelectionInfo()
                personalModel.disabilityObj.detail = MICategorySelectionInfo()
            }
            personalModel.disabilityObj.type = selectedCategoryInfo.first ?? MICategorySelectionInfo()
            self.manageDataFieldForSpeciallyAbled(isSpeciallyAbled: personalModel.speciallAbled)
        }
        if enumName == MasterDataType.DISABILITY_SUBTYPE.rawValue {
            if personalModel.disabilityObj.subtype.uuid != selectedCategoryInfo.first?.uuid {
                personalModel.disabilityObj.detail = MICategorySelectionInfo()
            }
            personalModel.disabilityObj.subtype = selectedCategoryInfo.first ?? MICategorySelectionInfo()
        }
        if enumName == MasterDataType.DISABILITY_DETAIL.rawValue {
            personalModel.disabilityObj.detail = selectedCategoryInfo.first ?? MICategorySelectionInfo()
        }
        if enumName == MasterDataType.GENDER.rawValue {
            personalModel.gender = selectedCategoryInfo.first ?? MICategorySelectionInfo()
        }
        self.tableView.reloadData()
    }
}

