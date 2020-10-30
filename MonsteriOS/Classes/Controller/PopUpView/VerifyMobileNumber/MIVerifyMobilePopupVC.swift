//
//  MIVerifyMobilePopupVC.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 18/09/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIVerifyMobilePopupVC: MIBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    let footer = MISingleButtonView.singleBtnView

    
    private var rowCount = 1
    
    private var countryCode = AppDelegate.instance.userInfo.countryCode
    private var mobileNumber = AppDelegate.instance.userInfo.mobileNumber
    private var countryNameCode = ""
    var viewLoadDate:Date!

    private var otpID = ""
    private var otpMessage = ""

    var card: Card!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = card.data as? JSONDICT, let countryCode = data["countryCode"] as? String {
            self.countryCode = countryCode
        }
        if self.countryCode.count == 0 {
            let siteValue = self.getSiteCountryISOCode()
            if !siteValue.countryPhoneCode.isEmpty {
                self.countryCode = siteValue.countryPhoneCode
            }

        }
        if let data = card.data as? JSONDICT, let mobileNumber = data["mobileNumber"] as? String {
            self.mobileNumber = mobileNumber
        }

        if let country = AppDelegate.instance.splashModel.countries?.filter({ $0.callPrefix.stringValue == countryCode }).first {
            countryNameCode = country.isoCode
        }
        viewLoadDate = Date()
        tableView.dataSource = self
        tableView.delegate   = self
        
        tableView.register(UINib(nibName:String(describing: MITextFieldTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MITextFieldTableViewCell.self))
        tableView.register(UINib(nibName:String(describing: MIOTPTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MIOTPTableViewCell.self))
        footer.btn_delete.setTitle("VERIFY", for: .normal)
        footer.btn_delete.showSecondaryBtnLayout()
        footer.btn_leadingConstraint.constant = 15
        footer.btn_trailingConstairnt.constant = 15
        tableView.tableFooterView = footer
        
        footer.btnActionCallBack = { sectionCount in
            self.view.endEditing(true)
            let indexPath0 = IndexPath(row: 0, section: 0)
            let indexPath1 = IndexPath(row: 1, section: 0)

            if self.rowCount == 1 {
                let cell = self.tableView.cellForRow(at: indexPath0) as? MITextFieldTableViewCell

                if self.mobileNumber.count == 0 {
                    cell?.showError(with: "Please enter mobile number")
                    return
                }
                
                self.rowCount = 2
                self.tableView.insertRows(at: [indexPath1], with: .fade)
                self.sendOTP(in: self.tableView.cellForRow(at: indexPath1) as? MIOTPTableViewCell)
                self.tableView.beginUpdates()
                cell?.titleLabel.text = "OTP sent on your mobile number"
                self.tableView.endUpdates()
                if let otpCell = self.tableView.cellForRow(at: indexPath1) as? MIOTPTableViewCell {
                    otpCell.optTextField[0].becomeFirstResponder()
                }
                self.manageTableViewToCenter(isSetCenter: false)

            } else {
                self.verifyMobile(indexPath1)
            }
        }
        let headerView = MIProfileImprovementHeader.header
        headerView.setHeaderViewWithTitle(title: "Verify Mobile Number", imgName: "smartphone")
        headerView.lbl_description.textColor = AppTheme.appGreyColor
        headerView.lbl_description.text = "Stay connected. Get hired"
        tableView.tableHeaderView = headerView
        self.manageTableViewToCenter(isSetCenter: true)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func manageTableViewToCenter(isSetCenter:Bool) {
        let viewHeight: CGFloat = view.frame.size.height
        let tableViewContentHeight: CGFloat = tableView.contentSize.height
        let marginHeight: CGFloat = (viewHeight - tableViewContentHeight) / 4.0
        
        self.tableView.contentInset = isSetCenter ? UIEdgeInsets(top: marginHeight, left: 0, bottom:  -marginHeight, right: 0) : UIEdgeInsets(top: 0, left: 0, bottom:0, right: 0)
        
    }
    
    @IBAction func skipButtonAction(_ sender: Any) {        
        let headerDict = [
            "x-rule-applied": card.ruleApplied ?? "",
            "x-rule-version": card.ruleVersion ?? ""
        ]

        self.eventTrackingApi("MOB", updated: 0, remindMeLater: 1, oldValue: [:], newValue: [:], headerDict: headerDict)
        
        MIApiManager.hitRemindMeLaterApi(self.card.type, userActions: self.card.text, headerDict: headerDict) { (success, response, error, code) in
//            DispatchQueue.main.async {
//                //MIActivityLoader.hideLoader()
//
//                if error == nil && (code >= 200) && (code <= 299) {
//                }else{
//                   // self.handleAPIError(errorParams: response, error: error)
//                }
//            }
        }
        self.skipProfileEngagementPopup()

    }
    
    func sendOTP(in cell: MIOTPTableViewCell?) {
        let params = [
            "countryCode" : countryCode.replacingOccurrences(of: "+", with: ""),
            "mobileNumber": mobileNumber
        ]
        
        let headerDict = [
            "x-rule-applied": card.ruleApplied ?? "",
            "x-rule-version": card.ruleVersion ?? ""
        ]

        cell?.startTimer()
        MIApiManager.callAPIForSendOTP(methodType: .post, path: APIPath.sendOTPMobileEndPoint, params: params, headerDict: headerDict) { (success, response, error, code) in
            
            DispatchQueue.main.async {
                //MIActivityLoader.hideLoader()
                self.otpMessage = ""
                
                if error == nil && (code >= 200) && (code <= 299) {
                    self.otpMessage = "OTP sent on your mobile number"
                    if let result = response as? [String:Any] {
                        self.otpID = result["id"] as! String
                    } else {
                        self.handleAPIError(errorParams: response, error: error)
                    }
                }else{
                    self.handleAPIError(errorParams: response, error: error)
                }
                self.tableView.reloadData()

            }
            
        }

    }
    
    func verifyMobile(_ indexPath: IndexPath) {
        guard let cell = self.tableView.cellForRow(at: indexPath) as? MIOTPTableViewCell else { return }
       
        let otp = cell.optTextField.map({ $0.text! }).joined(separator: "")
        guard otp.count == 6 else {
            self.showAlert(title: nil, message: "Please enter valid OTP")
            self.otpMessage = ""
            self.tableView.reloadData()
            return
        }
        
        let mobile = [
            "countryCode" : countryCode.replacingOccurrences(of: "+", with: ""),
            "mobileNumber": self.mobileNumber
        ]
        
        let param = [
            "mobileNumber" : mobile,
            "otp"          : otp,
            "otpId"        : self.otpID
            ] as [String : Any]
        
        let headerDict = [
            "x-rule-applied": card.ruleApplied ?? "",
            "x-rule-version": card.ruleVersion ?? ""
        ]
        
        let added = self.addTaskToDispatchGroup()
        
        MIApiManager.callAPIForValidateOTP(methodType: .post, path: APIPath.validateMobileEndPoint, params: param, headerDict: headerDict) { (success, response, error, code) in
            DispatchQueue.main.async {
                defer { self.leaveDispatchGroup(added) }

                if error == nil  && (code >= 200) && (code <= 299) {
                    var fieldData = [String]()

                    if let data = self.card.data as? JSONDICT, let mobileNumber = data["mobileNumber"] as? String {
                        
                        if mobileNumber.isEmpty {
                            fieldData.append(CONSTANT_FIELD_LEVEL_NAME.ADD_MOBILE_NUMBER)
                            fieldData.append(CONSTANT_FIELD_LEVEL_NAME.VERIFY_MOBILE)
                        }else{
                            if let data = self.card.data as? JSONDICT, let countryCode = data["countryCode"] as? String {
                                if mobileNumber == self.mobileNumber && countryCode.replacingOccurrences(of: "+", with: "") == self.countryCode.replacingOccurrences(of: "+", with: "") {
                                    fieldData.append(CONSTANT_FIELD_LEVEL_NAME.VERIFY_MOBILE)
                                }else{
                                    fieldData.append(CONSTANT_FIELD_LEVEL_NAME.VERIFY_MOBILE)
                                    fieldData.append(CONSTANT_FIELD_LEVEL_NAME.MOBILE_NUMBER_CHANGED)
                                }
                            }
                        }
                        
                    }else{
                        fieldData.append(CONSTANT_FIELD_LEVEL_NAME.ADD_MOBILE_NUMBER)
                        fieldData.append(CONSTANT_FIELD_LEVEL_NAME.VERIFY_MOBILE)
                    }

                    JobSeekerSingleton.sharedInstance.fieldLevelDataArray = fieldData
                    if let tabbar = self.tabbarController {
                        tabbar.handlePopFinalState(isErrorHappen: false)
                    }

                    shouldRunProfileApi = true
                    
                }else{
                    if let tabbar = self.tabbarController {
                        tabbar.isErrorOccuredOnProfileEngagement = true
                    }
                    //self.handleAPIError(errorParams: response, error: error)
                }

            }

        }
        var mobile1: JSONDICT = [:]
        if let data = self.card.data as? JSONDICT, let countryCode = data["countryCode"] as? String {
            mobile1["isd"] = countryCode
        }
        if let data = self.card.data as? JSONDICT, let mobileNumber = data["mobileNumber"] as? String {
            mobile1["phoneNo"] = mobileNumber
        }
        
        let oldValue = [ "mobileNumber": mobile]
        
        let newValue = [
            "mobileNumber" : [
                "isd"       : self.countryCode,
                "phoneNo"   : self.mobileNumber
            ]
        ]
        
        self.eventTrackingApi("MOB", updated: 1, remindMeLater: 0, oldValue: oldValue, newValue: newValue, headerDict: headerDict)

        self.skipProfileEngagementPopup()

    }

    
    func eventTrackingApi(_ attribute: String, updated: Int, remindMeLater: Int, oldValue: JSONDICT, newValue: JSONDICT, headerDict: [String: String]?) {
        
        let timeSpent = self.viewLoadDate.getSecondDifferenceBetweenDates()
        
        MIApiManager.hitTrackingEventsApi(attribute, updated: updated, remindMeLater: remindMeLater, oldValue: oldValue, newValue: newValue, timeSpent: timeSpent, headerDict: headerDict, cardRule: card) { (success, response, error, code) in

        }
    }

}

extension MIVerifyMobilePopupVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withClass: MITextFieldTableViewCell.self, for: indexPath)
            
            cell.titleLabel.textColor = UIColor(hex: 0x519905)
            cell.titleLabel.text = (rowCount == 2) ? otpMessage : ""
            cell.secondryTextField.text = self.countryNameCode + "  +" + self.countryCode
            cell.primaryTextField.text = self.mobileNumber
            cell.primaryTextField.placeholder = "Enter Mobile number"
            cell.primaryTextField.keyboardType = .numberPad
            cell.primaryTextField.setRightViewForTextField()
            cell.primaryTextField.delegate = self
            
            cell.secondryTextFieldAction = { txtFld in
                let vc = MICountryCodePickerVC()
                vc.countryCodeSeleted = { country in
                    self.countryCode = country.callPrefix.stringValue
                    let code = "+" + self.countryCode
                    self.countryNameCode = country.isoCode
                    
                    txtFld.text = country.isoCode + "  " + code                    
                }
                
                self.navigationController?.pushViewController(vc, animated: true)
                
                return false
            }
            
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withClass: MIOTPTableViewCell.self, for: indexPath)
            
            cell.resendButtonCallBack = {
                self.sendOTP(in: cell)
            }
            return cell

        default:
            return UITableViewCell()
        }
    }
}


extension MIVerifyMobilePopupVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.mobileNumber = textField.text ?? ""
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let searchTxt = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        return (searchTxt.count <= searchTxt.validiateMobile(for: self.countryCode).thresholdValue)

    }
}
