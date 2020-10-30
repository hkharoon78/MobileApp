//
//  MIPendingActionViewController.swift
//  MonsteriOS
//
//  Created by Rakesh on 24/04/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

enum NoticePeroid:String {
    
    case Serving_Notice_Peroid = "Serving Notice Period"
    case Less_Than_Or_15_Days = "15 Days or Less"
    case Month_1 = "1 Month"
    case Month_2 = "2 Months"
    case Month_3 = "3 Months"
    case More_Than_3_Months = "More Than 3 Months"
    
    var days : Int {
        switch self {
        case .Serving_Notice_Peroid:
            return 0
        case .Less_Than_Or_15_Days:
            return 15
        case .Month_1:
            return 30
        case .Month_2:
            return 60
        case .Month_3:
            return 90
        case .More_Than_3_Months:
            return 91
        }
    }
    
    func getnoitcePeroid(days:Int) -> NoticePeroid {
        switch days {
        case 14,15:
            return .Less_Than_Or_15_Days
        case 0:
            return .Serving_Notice_Peroid
        case 30:
            return .Month_1
        case 60:
            return .Month_2
        case 90:
            return .Month_3
        case 91:
            return .More_Than_3_Months
        default:
            return .Serving_Notice_Peroid
            
        }
        
    }
    
}

class MIPendingActionViewController: MIBaseViewController {
    
    @IBOutlet var tblView:UITableView!
    @IBOutlet var save_Btn:UIButton!
    @IBOutlet var tblFooter:UIView!
    var error: (message: String, index: Int,isPrimaryError:Bool) = ("", -1,false)
    
    var pendingType = PendingActionType.NONE
    var pendingactionSuccess : ((Bool)->Void)?
    var dataValue = [String:Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUpOnLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch pendingType {
        case .PROFILE_TITLE:
            self.title = "Profile Title"
            JobSeekerSingleton.sharedInstance.addScreenName(screenName: "PROFILE_TITLE_PENDING_SCREEN")

            break
            
        case .NOTICE_PERIOD:
            self.title = "Notice Period"
            JobSeekerSingleton.sharedInstance.addScreenName(screenName: "NOTICE_PEROID_PENDING_SCREEN")

            break
            
        case .NATIONALITY:
            self.title = "Nationality"
            JobSeekerSingleton.sharedInstance.addScreenName(screenName: "NATIONALITY_PENDING_SCREEN")

            break
            
        case .ADD_MOBILE_NUMBER:
            self.title = "Add Mobile number"
            JobSeekerSingleton.sharedInstance.addScreenName(screenName: "ADD_MOBILE_NUMBER_PENDING_SCREEN")

            break
            
        default:
            self.title = ""
        }

    }
    func setUpOnLoad() {
        switch pendingType {
        case .PROFILE_TITLE:
            self.tblView.register(UINib(nibName:String(describing: MITextViewTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MITextViewTableViewCell.self))
            break
            
        case .NOTICE_PERIOD:
            tblView.register(UINib(nibName:String(describing: MITextFieldTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MITextFieldTableViewCell.self))
            tblView.register(UINib(nibName:String(describing: MINoticePeroidCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MINoticePeroidCell.self))
            break
            
        case .NATIONALITY:
            tblView.register(UINib(nibName:String(describing: MITextFieldTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MITextFieldTableViewCell.self))
            break
            
        case .ADD_MOBILE_NUMBER:
            tblView.register(UINib(nibName:String(describing: MITextFieldTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MITextFieldTableViewCell.self))
            
            let siteValue = self.getSiteCountryISOCode()
            if !siteValue.countryPhoneCode.isEmpty {
                self.dataValue["countryCode"] = "+" + siteValue.countryPhoneCode
            }else{
                self.dataValue["countryCode"] = "+91"
                
            }
            save_Btn.setTitle("Add", for: .normal)
            break
            
        default:
            self.title = ""
        }
        
        self.save_Btn.showPrimaryBtn()
        self.tblView.tableFooterView = tblFooter
    }
    
    func manageError(message:String,indexRow:Int,isPrimary:Bool) {
        self.error = (message,indexRow,isPrimary)
        if indexRow > -1 {
            self.tblView.reloadData()
            self.tblView.scrollToRow(at: IndexPath(row: indexRow, section: 0), at: .top, animated: false)
        }
    }
    @IBAction func saveBtnAction(_ sender:UIButton) {
        self.view.endEditing(true)
        
        if pendingType == .PROFILE_TITLE {
            if self.dataValue.stringFor(key: "profileTitle").isEmpty {
                self.manageError(message: "Profile title can't be blank.", indexRow:0, isPrimary: true)
            }else{
                self.callAPIForProfileTitleUpdate()
            }
        }else if pendingType == .NOTICE_PERIOD {
            if let noticePeroid = self.dataValue["noticePeroid"] as? NoticePeroid , noticePeroid.rawValue.count > 0 {
                if noticePeroid == .Serving_Notice_Peroid {
                    if (self.dataValue["lastWorkingDate"] as? Date) != nil  {
                        //Call api for notice peroid
                        self.callAPIForNoticePeroidUpdate()
                    }else{
                        self.manageError(message: "Please select your last working date.", indexRow:2, isPrimary: true)
                    }
                }else{
                    self.callAPIForNoticePeroidUpdate()
                }
                
            }else{
                self.manageError(message: "Please select your notice peroid.", indexRow:1, isPrimary: true)
            }
            
        }else if pendingType == .NATIONALITY {
            if let nationality = self.dataValue["nationality"] as? MICategorySelectionInfo , !nationality.name.isEmpty {
                //Call api for nationlaity
                self.callAPIForUpdateUserNationality()
            }else{
                self.manageError(message: "Please select your nationality.", indexRow:0, isPrimary: true)
            }
            
        }else if pendingType == .ADD_MOBILE_NUMBER {
            if self.dataValue.stringFor(key: "mobileNumber").isEmpty {
                self.manageError(message: "Please enter your mobile number.", indexRow:0, isPrimary: true)
            }else{
                //Call api to add mobile number
                let mobileChange = MIOTPViewController()
                mobileChange.openMode = .verifyMobileNumber
                mobileChange.delegate = self
                mobileChange.countryCode = self.dataValue.stringFor(key: "countryCode").replacingOccurrences(of: "+", with: "")
                mobileChange.userName = self.dataValue.stringFor(key: "mobileNumber")
                mobileChange.otpVerifySuccess = { status in
                    JobSeekerSingleton.sharedInstance.fieldLevelDataArray = [CONSTANT_FIELD_LEVEL_NAME.ADD_MOBILE_NUMBER]
                    if let aciton = self.pendingactionSuccess {
                        aciton(true)
                    }
                    self.navigationController?.popViewController(animated: true)
                }
                self.navigationController?.pushViewController(mobileChange, animated: true)
            }
        }
    }
    
    func callAPIForNoticePeroidUpdate() {
        
        var params = [String:Any]()
        if let noticePeroid = self.dataValue["noticePeroid"] as? NoticePeroid {
            if noticePeroid == .Serving_Notice_Peroid {
                params["serving"] = true
                if let date = (self.dataValue["lastWorkingDate"] as? Date)  {
                    params["lastWorkingDay"] = date.getStringWithFormat(format: PersonalTitleConstant.dateFormatePattern)
                    params["days"] = Date().getDaysDifferenceBetweenDatesWithComponents(toDate: date)
                }else{
                    self.showAlert(title: "", message: "Please select your last working day.")
                    return
                }
            }else{
                params["serving"] = false
                params["days"] = noticePeroid.days
            }
            
        }else{
            self.showAlert(title: "", message: "Please select your notice peroid.")
            return
        }
        self.startActivityIndicator()
        
        MIApiManager.callAPIForUpdatePersonalDetail(methodType: .put, path: APIPath.updateNoticePeroidAPIEndpoint, params: ["noticePeriod":params]) { (success, response, error, code) in
            
            DispatchQueue.main.async {
                self.stopActivityIndicator()
                if error == nil && (code >= 200) && (code <= 299) {
                    JobSeekerSingleton.sharedInstance.fieldLevelDataArray = [CONSTANT_FIELD_LEVEL_NAME.NOTICE_PERIOD]
                    if let successCallBack = self.pendingactionSuccess {
                        successCallBack(true)
                        self.navigationController?.popViewController(animated: false)
                    }
                }else{
                    self.handleAPIError(errorParams: response, error: error)
                }
            }
            
        }
    }
    func callAPIForProfileTitleUpdate() {
        
        self.startActivityIndicator()
        MIApiManager.callAPIForUpdateProfileTitle(methodType: .put, path: APIPath.profileTitleApiEndPoint, params: ["title":self.dataValue.stringFor(key: "profileTitle")]) { (success, response, error, code) in
            
            DispatchQueue.main.async {
                self.stopActivityIndicator()
                if error == nil && (code >= 200) && (code <= 299) {
                    JobSeekerSingleton.sharedInstance.fieldLevelDataArray = [CONSTANT_FIELD_LEVEL_NAME.PROFILE_TITLE]

                    if let successCallBack = self.pendingactionSuccess {
                        successCallBack(true)
                        self.navigationController?.popViewController(animated: false)
                    }
                }else{
                    self.handleAPIError(errorParams: response, error: error)
                }
            }
        }
    }
    func callAPIForUpdateUserNationality() {
        
        if let masterObj = self.dataValue["nationality"] as? MICategorySelectionInfo,!masterObj.name.isEmpty {
            self.startActivityIndicator()
            MIApiManager.callAPIForUpdatePersonalDetail(methodType: .put, path:APIPath.updateUserDataAPIEndpoint, params: [APIKeys.nationalityAPIKey : MIUserModel.getParamForIdText(id: (masterObj.uuid ), value: masterObj.name)]) { (success, response, error, code) in
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    shouldRunProfileApi = true
                
                if error == nil && (code >= 200) && (code <= 299) {
                    JobSeekerSingleton.sharedInstance.fieldLevelDataArray = [CONSTANT_FIELD_LEVEL_NAME.NATIONALITY]

                      //  self.showAlert(title: "", message: "Nationality updated successfully.",isErrorOccured:false)
                    
                        if let aciton = self.pendingactionSuccess {
                            aciton(true)
                        }
                    self.showAlert(title: "", message: "Nationality updated successfully.", isErrorOccured: false) {
                        self.navigationController?.popViewController(animated: true)

                    }
                }else{
                    self.handleAPIError(errorParams: response, error: error)
                }
            }
            }
        }
    }
}

extension MIPendingActionViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pendingType == .NOTICE_PERIOD {
            if let noticePeroid = self.dataValue["noticePeroid"] as? NoticePeroid , noticePeroid == .Serving_Notice_Peroid{
                return 3
            }else{
                return 2
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if pendingType == .PROFILE_TITLE {
            let tvCell = tableView.dequeueReusableCell(withClass: MITextViewTableViewCell.self, for: indexPath)
            tvCell.textView.isUserInteractionEnabled = true
            tvCell.textView.keyboardType = .asciiCapable
            tvCell.textView.placeholder = "Profile Title" as NSString
            tvCell.textView.text = self.dataValue.stringFor(key: "profileTitle")
            tvCell.showCounterLabel = true
            tvCell.textView.delegate = self
            // tvCell.textView.isScrollEnabled = true
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
            
        }
        if pendingType == .NOTICE_PERIOD {
            
            if indexPath.row == 0 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "MINoticePeroidCell") as? MINoticePeroidCell {
                    cell.selectionStyle = .none
                    cell.showDataValue()
                    return cell
                }
            }else{
                let cell = tableView.dequeueReusableCell(withClass: MITextFieldTableViewCell.self, for: indexPath)
                cell.secondryTextField.isHidden = true
                cell.primaryTextField.tag = indexPath.row
                cell.primaryTextField.delegate  = self
                cell.primaryTextField.text = ""
                cell.primaryTextField.setRightViewForTextField("darkRightArrow")
                if self.error.index == indexPath.row {
                    if error.isPrimaryError {
                        cell.showError(with: self.error.message,animated: false)
                    }
                } else {
                    cell.showError(with: "",animated: false)
                }
                if indexPath.row == 1 {
                    if let noticePeroid = self.dataValue["noticePeroid"] as? NoticePeroid {
                        cell.primaryTextField.text = noticePeroid.rawValue
                    }
                    cell.titleLabel.text = "Notice Peroid"
                    cell.primaryTextField.placeholder = "Select Notice Peroid"
                    
                }else{
                    cell.primaryTextField.setRightViewForTextField("calendarBlue")
                    cell.titleLabel.text = "Last Working Day"
                    cell.primaryTextField.placeholder = "Select Last Working Day"
                    if let lastWrkgDate = self.dataValue["lastWorkingDate"] as? Date {
                        cell.primaryTextField.text = lastWrkgDate.getStringWithFormat(format: "MMM, yyyy")
                    }
                }
                return cell
            }
        }
        if pendingType == .NATIONALITY {
            let cell = tableView.dequeueReusableCell(withClass: MITextFieldTableViewCell.self, for: indexPath)
            cell.secondryTextField.isHidden = true
            cell.primaryTextField.tag = indexPath.row
            cell.primaryTextField.delegate  = self
            cell.primaryTextField.isUserInteractionEnabled = false
            cell.primaryTextField.setRightViewForTextField("darkRightArrow")
            if self.error.index == indexPath.row {
                if error.isPrimaryError {
                    cell.showError(with: self.error.message,animated: false)
                }
                
            } else {
                cell.showError(with: "",animated: false)
            }
            if let nationality = self.dataValue["nationality"] as? MICategorySelectionInfo {
                cell.primaryTextField.text = nationality.name
            }
            return cell
            
        }
        if pendingType == .ADD_MOBILE_NUMBER{
            let cell = tableView.dequeueReusableCell(withClass: MITextFieldTableViewCell.self, for: indexPath)
            //{
                cell.secondryTextField.adjustsFontSizeToFitWidth = true
                cell.secondryTextField.minimumFontSize = 12
                cell.secondryTextField.text = self.dataValue.stringFor(key: "countryCode")
                cell.primaryTextField.text = self.dataValue.stringFor(key: "mobileNumber")
                cell.secondryTextField.placeholder = "ISD"
                cell.primaryTextField.placeholder = "Your number for employers to reach you"
                cell.secondryTextField.isHidden = false
                if self.error.index == indexPath.row {
                    if error.isPrimaryError {
                        cell.showError(with: self.error.message,animated: false)
                    }
                    
                } else {
                    cell.showError(with: "",animated: false)
                }
                cell.secondryTextFieldAction = { txtFld in
                    let vc = MICountryCodePickerVC()
                    vc.countryCodeSeleted = { country in
                        let code = country.callPrefix.stringValue
                        self.dataValue["countryCode"] = code
                        txtFld.text = code
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                    return false
                }
                return cell
            //}
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.manageError(message: "", indexRow: -1, isPrimary: true)
        if pendingType == .NATIONALITY {
            let vc = MIMasterDataSelectionViewController.newInstance
            vc.title = MIEducationDetailViewControllerConstant.search
            vc.delegate = self
            vc.limitSelectionCount = 1
            vc.masterType = .NATIONALITY
            if let nationality = self.dataValue["nationality"] as? MICategorySelectionInfo,!nationality.name.isEmpty {
                vc.selectDataArray = [nationality]
                vc.selectedInfoArray = [nationality.name]
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension MIPendingActionViewController:UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.keyboardType = .asciiCapable
        self.manageError(message: "", indexRow: -1, isPrimary: true)
        
        if pendingType == .NOTICE_PERIOD {
            if let cell = textField.tableViewCell() as? MITextFieldTableViewCell {
                //For last day working
                if textField.tag == 1 {
                    let staticMasterVC = MIStaticMasterDataViewController.newInstance
                    staticMasterVC.title = "Selection"
                    staticMasterVC.staticMasterType = .NOTICEPEROID
                    staticMasterVC.selectedDataArray = self.dataValue.stringFor(key: "noticePeroid").isEmpty ? [] : [self.dataValue.stringFor(key: "noticePeroid")]
                    staticMasterVC.selectedData = { value in
                        self.dataValue["noticePeroid"] = NoticePeroid(rawValue: value)
                        cell.primaryTextField.text = value
                        self.tblView.reloadData()
                    }
                    self.navigationController?.pushViewController(staticMasterVC, animated: true)
                    
                }else if textField.tag == 2 {
                    MIDatePicker.selectDate(title: "", hideCancel: false, datePickerMode: .date, selectedDate: Date(), minDate: Date(), maxDate: nil) { (date) in
                        self.dataValue["lastWorkingDate"] = date
                        self.tblView.reloadData()
                        cell.primaryTextField.text = date.getStringWithFormat(format: "MMM, yyyy")
                    }
                }
                return false
            }
        }
        
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        if pendingType == .ADD_MOBILE_NUMBER {
            if let stringData = textField.text?.appending(string)  {
                return (stringData.count <= stringData.validiateMobile(for: self.dataValue["countryCode"] as! String).thresholdValue)
            }
        }
        return true
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if pendingType == .ADD_MOBILE_NUMBER {
            self.dataValue["mobileNumber"] = textField.text?.withoutWhiteSpace() ?? ""
            
        }
    }
    
}
extension MIPendingActionViewController:UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if self.pendingType == .PROFILE_TITLE {
            self.tblView.beginUpdates()
            let fixedWidth: CGFloat = textView.frame.size.width
            let txtFldPosition = textView.convert(CGPoint.zero, to: self.tblView)
            if  let indexPath = self.tblView.indexPathForRow(at: txtFldPosition) {
                let cell = self.tblView.cellForRow(at: IndexPath(row: indexPath.row , section:indexPath.section)) as! MITextViewTableViewCell
                let newSize: CGSize = textView.sizeThatFits(CGSize(width:fixedWidth,height:.greatestFiniteMagnitude))
                var frame = cell.textView.frame
                frame.size.height = newSize.height
                cell.textView.frame = frame
                self.tblView.endUpdates()
            }
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.pendingType == .PROFILE_TITLE {
            self.dataValue["profileTitle"] = textView.text.withoutWhiteSpace()
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
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

extension MIPendingActionViewController:MIMasterDataSelectionViewControllerDelegate {
    func masterDataSelected(selectedCategoryInfo: [MICategorySelectionInfo], selectedListInfo: [String], enumName: String) {
        
        if pendingType == .NATIONALITY {
            self.dataValue["nationality"] = selectedCategoryInfo.first ?? MICategorySelectionInfo()
            self.tblView.reloadData()
        }
    }
}

extension MIPendingActionViewController : PendingActionDelegate {
    func verifiedUser(_ id: String,openMode:OpenMode) {
        
        if let aciton = self.pendingactionSuccess {
            aciton(true)
        }
        self.navigationController?.popViewController(animated: true)
    }
}
