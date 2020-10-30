//
//  MIChangePasswordView.swift
//  MonsteriOS
//
//  Created by ishteyaque on 27/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit


class MIChangePasswordView: UIView {
    
    //MARK:Outlets and Variables
    @IBOutlet weak var tableView: UITableView!
    

    //MARK:Initializer
    var viewController: UIViewController?
    var error: (message: String, index: Int) = ("", -1)
    var hidePassword = true
    
     var rightBtn: UIButton {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        btn.setImage(UIImage(named: "hide-password"), for: .normal)
        btn.setImage(UIImage(named: "showpassword"), for: .selected)
        btn.addTarget(self, action: #selector(passwdShowHide(_:)), for: .touchUpInside)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -7, bottom: 0, right: 7)
        return btn
    }
    
    var tfValue = [
        "old"     : "",
        "new"     : "",
        "confirm" : ""
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        configure()
    }
    
    func configure(){
        CommonClass.googleAnalyticsScreen(self) //GA for Screen
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = true

        //Register TableView Cell
        self.tableView.register(UINib(nibName:String(describing: MIManageSubsNotificationDesTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MIManageSubsNotificationDesTableViewCell.self))
        self.tableView.register(UINib(nibName:String(describing: MITextFieldTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MITextFieldTableViewCell.self))
        self.tableView.register(UINib(nibName: "MIBlockCompaniesCell", bundle: nil), forCellReuseIdentifier: "MIBlockCompaniesCell")
        
         //self.tableView.register(UINib(nibName:String(describing: MICovid19TableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MICovid19TableViewCell.self))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.endEditing(true)
    }
    
    
    //MARK:Submit Button Action
    @IBAction func submitButtonAction(_ sender: UIButton) {
        self.changePasswd()
    }
    
    @objc func passwdShowHide(_ sender: UIButton) {
        
        if let index = sender.tableViewIndexPath(self.tableView) {
            let cell = tableView.cellForRow(at: IndexPath(row: index.row, section: 0)) as! MITextFieldTableViewCell
            
            switch index.row {
            case 1:
                cell.primaryTextField!.isSecureTextEntry = !cell.primaryTextField!.isSecureTextEntry
            case 2:
                cell.primaryTextField!.isSecureTextEntry = !cell.primaryTextField!.isSecureTextEntry
            case 3:
                cell.primaryTextField!.isSecureTextEntry = !cell.primaryTextField!.isSecureTextEntry
            default:
                break
            }
            
        }
        sender.isSelected = !sender.isSelected
    }
    
  
}

//MARK:- Tableview delegate and data source
extension MIChangePasswordView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tfValue.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MIManageSubsNotificationDesTableViewCell.self)) as? MIManageSubsNotificationDesTableViewCell else {return UITableViewCell()}
            
            cell.lblNotificationDes.textColor = AppTheme.textColor
            cell.lblNotificationDes.font = UIFont.customFont(type: .Regular, size: 14)
            cell.lblNotificationDes.text = "For registrations via socials set password using forgot password on login page."
            
            
            return cell
            
        case 1, 2, 3:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MITextFieldTableViewCell.self)) as? MITextFieldTableViewCell else {return UITableViewCell()}
            
            cell.primaryTextField.delegate = self
            cell.primaryTextField.tag = indexPath.row
            cell.primaryTextField.isUserInteractionEnabled = true
            cell.primaryTextField.isSecureTextEntry =  true
            
            //set placeholder
            let placeholderArr = ["", "Old Password", "New Password", "Confirm Password"]
            cell.primaryTextField.placeholder = placeholderArr[indexPath.row]
           
            cell.titleLabel.text = placeholderArr[indexPath.row]
            cell.secondryTextField.isHidden = true
            
            
            if self.error.index == indexPath.row {
                 cell.showError(with: self.error.message)
            } else {
                cell.showError(with: "")
            }
            
            //cell.primaryTextField.setRightViewForTextField()
           // cell.primaryTextField.rightViewMode = .always
           // cell.primaryTextField.rightView  = rightBtn
            
            cell.primaryTextField.rightViewMode = .always
            cell.primaryTextField.rightView = cell.eyeIcon
            
            switch indexPath.row {
            case 1:
               cell.primaryTextField.returnKeyType = .next
            case 2:
               cell.primaryTextField.returnKeyType = .next
            case 3:
              cell.primaryTextField.returnKeyType = .done
            default:
                break
            }
            
//            switch indexPath.row {
//            case 1:
//                cell.primaryTextField.returnKeyType = .next
//                if self.tfValue["old"]?.count == 0  {
//                    cell.primaryTextField.rightView  = nil
//                } else {
//                    cell.primaryTextField.rightView  = rightBtn
//                }
//            case 2:
//                cell.primaryTextField.returnKeyType = .next
//                if self.tfValue["new"]?.count == 0  {
//                    cell.primaryTextField.rightView  = nil
//                } else {
//                    cell.primaryTextField.rightView  = rightBtn
//                }
//            case 3:
//                cell.primaryTextField.returnKeyType = .done
//                if self.tfValue["confirm"]?.count == 0  {
//                    cell.primaryTextField.rightView  = nil
//                } else {
//                    cell.primaryTextField.rightView  = rightBtn
//                }
//            default:
//                break
//            }
            
            cell.primaryTextField.isSecureTextEntry = self.hidePassword
            cell.eyeIcon?.isSelected = !hidePassword
            
            cell.hidePasswordCallBack = { show in
                self.hidePassword = !show
                cell.primaryTextField.isSecureTextEntry = !show
            }

            return cell
            
        default:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MIBlockCompaniesCell.self)) as? MIBlockCompaniesCell else {return UITableViewCell()}

            cell.selectionStyle = .none
            cell.blockButton.addTarget(self, action: #selector(submitBtnPressed(_:)), for: .touchUpInside)
            cell.blockButton.setTitle("Submit", for: .normal)

            return cell
            
            
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MICovid19TableViewCell.self)) as? MICovid19TableViewCell else {return UITableViewCell()}
//            return cell
            
        }
        

    }
    
    @objc func submitBtnPressed(_ sender: UIButton){
        self.changePasswd()
    }
    
}

//MARK:- API and validation
extension MIChangePasswordView {
    
    func showErrorOnTableViewIndex(indexPath:IndexPath, errorMsg:String) {
        self.error = (errorMsg, indexPath.row)
        self.tableView.reloadRows(at: [indexPath], with: .none)
        //self.tableView.reloadData()
    }
    
    @discardableResult func validation() -> Bool {
        self.endEditing(true)
        
        let oldIndex = IndexPath(row: 1, section: 0)
        let newIndex = IndexPath(row: 2, section: 0)
        let confirmIndex = IndexPath(row: 3, section: 0)
        
        if self.tfValue["old"]!.count == 0 {
            self.showErrorOnTableViewIndex(indexPath: oldIndex, errorMsg: ChangePassword.oldPasswd)
            return false
        }
        if self.tfValue["old"]!.count < 6 {
            self.showErrorOnTableViewIndex(indexPath: oldIndex, errorMsg: ChangePassword.minPasswd)
            return false
        }
        if self.tfValue["new"]!.count == 0 {
            self.showErrorOnTableViewIndex(indexPath: newIndex, errorMsg: ChangePassword.newPasswd)
            return false
        }
        if self.tfValue["new"]!.count < 6 {
            self.showErrorOnTableViewIndex(indexPath: newIndex, errorMsg: ChangePassword.minPasswd)
            return false
        }
        if self.tfValue["confirm"]!.count == 0 {
            self.showErrorOnTableViewIndex(indexPath: confirmIndex, errorMsg: ChangePassword.confirmPasswd)
            return false
        }
        if self.tfValue["new"] != self.tfValue["confirm"] {
            self.showErrorOnTableViewIndex(indexPath: confirmIndex, errorMsg: ChangePassword.samePasswd)
            return false
        }

        return true
        
    }
    
    func changePasswd() {
        self.endEditing(true)

        if self.validation() {
            MIActivityLoader.showLoader()
            
            MIApiManager.hitChangePassword(self.tfValue["old"] ?? "", newPasswd: self.tfValue["new"] ?? "", confirmPasswd: self.tfValue["confirm"] ?? "") { (success, response, error, code) in
                
                DispatchQueue.main.async {
                    MIActivityLoader.hideLoader()
                    
                    if let responseData = response as? JSONDICT {
                       
                        if let errorMessage = responseData["errorMessage"] as? String {
                             //self.viewController?.toastView(messsage: errorMessage)
                            
                            if errorMessage == "Current password is incorrect." {
                                let index = IndexPath(row: 1, section: 0)
                                let cell = self.tableView.cellForRow(at: index) as? MITextFieldTableViewCell
                                cell?.showError(with: errorMessage)
                            }
                            
                        } else {
                            //update token 
                            if let token = responseData["token"] as? String {
                                AppDelegate.instance.authInfo.accessToken = token
                                AppDelegate.instance.authInfo.commit()
                            }
                            
                            let successMessage = responseData["successMessage"] as? String ?? ""
                            
                            self.viewController?.showAlert(title: "", message: successMessage, isErrorOccured: false, successComplitionHandler: {
                                self.viewController?.navigationController?.popViewController(animated: true)

                            })
                           

//                            AKAlertController.alert("", message: successMessage, acceptMessage: "OK", acceptBlock: {
//                                self.viewController?.navigationController?.popViewController(animated: true)
//                            })
                            
                            CommonClass.googleEventTrcking("settings_screen", action: "change_password", label: "submit") //GA

                        }
                        
                    } else {
                        if (!MIReachability.isConnectedToNetwork()){
                            self.viewController?.toastView(messsage: ExtraResponse.noInternet)
                        }
                    }
                }
            }
        }
    }
    
}

//MARK:TextField Delegate Method
extension MIChangePasswordView: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let index = textField.tableViewIndexPath(self.tableView) {
            
            switch index.row {
            case 1:
                self.tfValue["old"] = textField.text
            case 2:
                self.tfValue["new"] = textField.text
            case 3:
                self.tfValue["confirm"] = textField.text
            default:
                break
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
//        let oldIndex = IndexPath(row: 1, section: 0)
//        let oldCell = tableView.cellForRow(at: oldIndex) as? MITextFieldTableViewCell
        
        let newIndex = IndexPath(row: 2, section: 0)
        let newCell = tableView.cellForRow(at: newIndex) as? MITextFieldTableViewCell
        
        let confirmIndex = IndexPath(row: 3, section: 0)
        let confirmCell = tableView.cellForRow(at: confirmIndex) as? MITextFieldTableViewCell
        
        if textField.tag == 1  {
            newCell?.primaryTextField.becomeFirstResponder()
        }
        if textField.tag == 2 {
            confirmCell?.primaryTextField.becomeFirstResponder()
        }
        if textField.tag == 3 {
            self.changePasswd()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldIndex = IndexPath(row: 1, section: 0)
        let oldCell = tableView.cellForRow(at: oldIndex) as? MITextFieldTableViewCell
        
        let newIndex = IndexPath(row: 2, section: 0)
        let newCell = tableView.cellForRow(at: newIndex) as? MITextFieldTableViewCell
        
        let confirmIndex = IndexPath(row: 3, section: 0)
        let confirmCell = tableView.cellForRow(at: confirmIndex) as? MITextFieldTableViewCell
        
         oldCell?.showError(with: "", animated: false)
         newCell?.showError(with: "", animated: false)
         confirmCell?.showError(with: "", animated: false)
        
        if string == "" { return true }
        
        let str = NSString(string: textField.text!).replacingCharacters(in: range, with: string)

         switch textField {
//        case oldCell?.primaryTextField:
            
//            if str.count > 0 {
//               oldCell?.primaryTextField.rightView = self.rightBtn
//            } else {
//               oldCell?.primaryTextField.rightView = nil
//            }
            
//            if !str.isEmpty{
//                oldCell?.primaryTextField.rightView = self.rightBtn
//            } else {
//                oldCell?.primaryTextField.rightView = nil
//            }
//

        case newCell?.primaryTextField:

//
//            if str.count > 0 {
//                newCell?.primaryTextField.rightView = self.rightBtn
//            } else {
//                newCell?.primaryTextField.rightView = nil
//            }
            
            if str.count > 20 {
                self.showErrorOnTableViewIndex(indexPath: newIndex, errorMsg: "Password can not be more then 20 characters")
                return false
            }
            return true
            
        case confirmCell?.primaryTextField:
         
//            if str.count > 0 {
//                confirmCell?.primaryTextField.rightView = self.rightBtn
//            } else {
//                confirmCell?.primaryTextField.rightView = nil
//            }
            
            if str.count > 20 {
                self.showErrorOnTableViewIndex(indexPath: newIndex, errorMsg: "Password can not be more then 20 characters")
                return false
            }
            return true
            
        default:
            break
        }
        

//        if textField.textInputMode?.primaryLanguage == nil || textField.textInputMode?.primaryLanguage == "emoji" {
//            return false
//        }
        
        
        return true
    }

    
    
}


class CustomTextField: UITextField {
     func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        
        if action == #selector(UIResponderStandardEditActions.paste(_:)),
            action == #selector(UIResponderStandardEditActions.copy(_:))
        {
            return false
        }

        return super.canPerformAction(action, withSender: sender)
    }
}
