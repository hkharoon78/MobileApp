//
//  MINonLoginApplyViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 10/05/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MINonLoginApplyViewController: MIBaseViewController {

    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
          titleLabel.font=UIFont.customFont(type: .Semibold, size: 15)
            titleLabel.textColor=AppTheme.textColor
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    var userModal = MIUserModel(userId: "")
    var submitActionSuccess:(([String:Any])->Void)?
    var error: (message: String, index: Int, isPrimaryError: Bool) = ("", -1, false)
    
    let applyTitleArray = [RegisterViewStoryBoardConstant.fullName, RegisterViewStoryBoardConstant.email, RegisterViewStoryBoardConstant.mobileNumber]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text="Enter contact details to apply for this job on company’s website"
        
         self.tableView.register(UINib(nibName:String(describing: MITextFieldTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MITextFieldTableViewCell.self))
        
        tableView.register(UINib(nibName:String(describing: MICreateAlertTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MICreateAlertTableViewCell.self))
        tableView.register(UINib(nibName:String(describing: MIRegisterMobileNumbCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MIRegisterMobileNumbCell.self))
        
        tableView.delegate=self
        tableView.dataSource=self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.separatorStyle = .none
        
        
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(image: #imageLiteral(resourceName: "back_bl"), style: .plain, target:self, action: #selector(MINonLoginApplyViewController.backButtonAction(_:)))
//        let submitButton=UIButton(frame: CGRect(x: 0, y: 0, width:self.tableView.frame.width - 80 , height: 40))
//        submitButton.setTitle("Submit & Apply", for: .normal)
//        submitButton.tag=0
//        submitButton.showPrimaryBtn()
//        submitButton.addTarget(self, action: #selector(MINonLoginApplyViewController.submitButtonAction(_:)), for: .touchUpInside)
        //self.tableView.tableFooterView=submitButton
        
        let submitView = SubmitAndSkipView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 110))
        submitView.submitAndSkipButtonAction = {[weak self] (tag) in
            self?.submitButtonAction(tag: tag)
        }
        self.tableView.tableFooterView=submitView
        let siteValue = self.getSiteCountryISOCode()
        if !siteValue.countryPhoneCode.isEmpty {
            userModal.userCountryCode = "+" + siteValue.countryPhoneCode
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)
    }
    @objc func backButtonAction(_ sender:UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    func showErrorOnTableViewIndex(indexPath: IndexPath, errorMsg:String, isPrimary:Bool ) {
        self.error = (errorMsg, indexPath.row, isPrimary)
        if indexPath.row > -1 {
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(row: indexPath.row, section: 0), at: .top, animated: false)
        }
        
    }
    
    func submitButtonAction(tag:Int){
        self.view.endEditing(true)

        if tag==0{
            if self.userModal.userFullName.count == 0{
                
                if let index = self.applyTitleArray.firstIndex(of: RegisterViewStoryBoardConstant.fullName){
                    let indexPath = IndexPath(row: index, section: 0)
                    self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: ErrorAndValidationMsg.name.rawValue, isPrimary: true)
                }
            }
        else if self.userModal.userEmail.count == 0{
           
                
                if let index = self.applyTitleArray.firstIndex(of: RegisterViewStoryBoardConstant.email){
                    let indexPath = IndexPath(row: index, section: 0)
                    self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: ErrorAndValidationMsg.emailId.rawValue, isPrimary: true)
                }
                
        }else if self.userModal.userEmail.isValidEmail == false{
                if let index = self.applyTitleArray.firstIndex(of: RegisterViewStoryBoardConstant.email){
                    let indexPath = IndexPath(row: index, section: 0)
                    self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: ErrorAndValidationMsg.validEmail.rawValue, isPrimary: true)
                }
         }
        else if self.userModal.userCountryCode.count == 0{
                
                if let index = self.applyTitleArray.firstIndex(of: RegisterViewStoryBoardConstant.mobileNumber){
                    let indexPath = IndexPath(row: index, section: 0)
                    self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: ErrorAndValidationMsg.countryNumberCode.rawValue, isPrimary: false)
                }
                
        }else if self.userModal.userMobileNumber.count == 0{
               
                if let index = self.applyTitleArray.firstIndex(of: RegisterViewStoryBoardConstant.mobileNumber){
                    let indexPath = IndexPath(row: index, section: 0)
                    self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: ErrorAndValidationMsg.mobileNumber.rawValue, isPrimary: true)
                }
                
        }else if !self.userModal.userMobileNumber.validiateMobile(for: self.userModal.userCountryCode).isValidate {
               
                if let index = self.applyTitleArray.firstIndex(of: RegisterViewStoryBoardConstant.mobileNumber){
                    let indexPath = IndexPath(row: index, section: 0)
                    self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: self.userModal.userMobileNumber.validiateMobile(for: self.userModal.userCountryCode).erroMessage, isPrimary: true)
                }
                
       }else{
            if let action=self.submitActionSuccess{
                action(
                    ["name":userModal.userFullName,"email":userModal.userEmail,"mobileNumber":["countryCode":userModal.userCountryCode.replacingOccurrences(of: "+", with: ""),"mobileNumber":userModal.userMobileNumber]])
                self.dismiss(animated: true, completion: nil)
            }
        }
        }else{
            if let action=self.submitActionSuccess{
                action([:])
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    

}

extension MINonLoginApplyViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return applyTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = applyTitleArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withClass: MITextFieldTableViewCell.self, for: indexPath)
        cell.primaryTextField.delegate = self
        cell.primaryTextField.setRightViewForTextField()
        cell.primaryTextField.tag = indexPath.row
        cell.secondryTextField.isHidden = true
        
        cell.primaryTextField.placeholder = title
        cell.titleLabel.text = title
        
        if self.error.index == indexPath.row {
            if error.isPrimaryError {
                cell.showError(with: self.error.message, animated: false)
            }else{
                cell.showErrorOnSecondryTF(with: self.error.message, animated: false)
            }
        } else {
            cell.showError(with: "", animated: false)
            cell.showErrorOnSecondryTF(with:"", animated: false)
        }
        
        switch title {
        case RegisterViewStoryBoardConstant.mobileNumber:
            cell.secondryTextField.isHidden = false
            cell.secondryTextField.placeholder = "ISD"
            
            cell.primaryTextField.text = self.userModal.userMobileNumber
            cell.secondryTextField.text = self.userModal.userCountryCode
            cell.secondryTFWidth?.constant = 70
            
            cell.secondryTextFieldAction = { txtFld in
                let vc = MICountryCodePickerVC()
                vc.countryCodeSeleted = { country in

                    let code = "+" + country.callPrefix.stringValue
                    self.userModal.userCountryCode = txtFld.text!
                    
                    txtFld.text = code
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
                return false
            }
            
        case RegisterViewStoryBoardConstant.fullName:
            cell.primaryTextField.text = self.userModal.userFullName
            
        case RegisterViewStoryBoardConstant.email:
            cell.primaryTextField.text = self.userModal.userEmail
            
        default: break
        }
        
        return cell
    }
    
}


extension MINonLoginApplyViewController:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let title = applyTitleArray[textField.tag]
        
        let searchTxt = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        if title == RegisterViewStoryBoardConstant.mobileNumber {
            return (searchTxt.count <= searchTxt.validiateMobile(for: self.userModal.userCountryCode).thresholdValue)
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            self.setMainViewFrame(originY: 0)
            let movingHeight = textField.movingHeightIn(view : self.view) + 30
            if movingHeight > 0 {
                UIView.animate(withDuration: 0.3) {
                    self.setMainViewFrame(originY: -movingHeight)
                }
            }
        }
        
        
        textField.autocapitalizationType = .none
        textField.returnKeyType = .default
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.keyboardType = .asciiCapable

        let title = applyTitleArray[textField.tag]
        
        if title == RegisterViewStoryBoardConstant.fullName {
            textField.autocapitalizationType = .words
            
        }
        
        if title == RegisterViewStoryBoardConstant.email {
            textField.autocorrectionType = .yes
            textField.keyboardType = .emailAddress

        }

        if title == RegisterViewStoryBoardConstant.mobileNumber {
            textField.addDoneButtonOnKeyboard()
            textField.keyboardType = .numberPad

        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let title = applyTitleArray[textField.tag]
        if title == RegisterViewStoryBoardConstant.fullName {
            self.userModal.userFullName = textField.text?.withoutWhiteSpace() ?? ""
        }
        if title == RegisterViewStoryBoardConstant.mobileNumber {
            self.userModal.userMobileNumber = textField.text?.withoutWhiteSpace() ?? ""
        }
        if title == RegisterViewStoryBoardConstant.email {
            self.userModal.userEmail = textField.text?.withoutWhiteSpace() ?? ""
        }
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.setMainViewFrame(originY: 0)
            }
        }
    }
}
