//
//  MIForgotPasswordViewController.swift
//  MonsteriOS
//
//  Created by Piyush on 08/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

enum OpenMode {
    case login, forgotPassword, register, pendingVerification, verifyEmail,verifyMobileNumber,viaRegisterClaim
}

class MIForgotPasswordViewController: MIBaseViewController {

    @IBOutlet weak private var forgotView: UIView!
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak private var nextBtn: UIButton!
    @IBOutlet weak private var emailPhoneTxtFid: UITextField!
    @IBOutlet weak var countryCodeTF: RightViewTextField!
    @IBOutlet weak var countryCodeView: UIView!
    @IBOutlet weak var emailLeading: NSLayoutConstraint!
    
    var userName = ""
    
    var openMode: OpenMode = .forgotPassword
    var delegate: PendingActionDelegate?

    override func initUI() {
        self.forgotView.layer.cornerRadius = 4
        self.forgotView.addShadow(opacity: 0.1)
        nextBtn.showPrimaryBtn()
        
        countryCodeTF.setRightViewForTextField("darkRightArrow", width: 15)
        
        emailPhoneTxtFid.delegate = self
        countryCodeTF.delegate = self
        
        emailPhoneTxtFid.layer.borderColor  = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        countryCodeTF.layer.borderColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        
        emailPhoneTxtFid.layer.borderWidth = 1
        countryCodeTF.layer.borderWidth = 1
        
        emailPhoneTxtFid.layer.cornerRadius = 5
        countryCodeTF.layer.cornerRadius = 5

        
        //let predicate = NSPredicate(format: "selected == %@", NSNumber(value: true))
        let site = AppDelegate.instance.site
        
        self.countryCodeTF.text =  "+" + (site?.defaultCountryDetails.callPrefix.stringValue ?? "")
        if userName.isEmpty {
            self.descLabel.text = "Enter the email ID/phone number linked to your account. We’ll send OTP to your email ID/phone number."
        }else{
            self.descLabel.text = self.userName.isNumeric ? "We will send an OTP to your phone." : "We will send an OTP to your email ID."
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                self.manageCountryCodeView(self.userName)
            }
        }
        self.emailPhoneTxtFid.text = self.userName
        self.manageCountryCodeView(self.userName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CommonClass.googleAnalyticsScreen(self) //GA for Screen

        switch openMode {
            case .forgotPassword:
                self.navigationItem.title = "Forgot your password?"
                JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.FORGOT_PASSWORD)

            case .login:
                self.navigationItem.title = "Login via OTP"
                JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.LOGIN_VIA_OTP)

            default: break
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    class var newInstance: MIForgotPasswordViewController {
        let vc = Storyboard.main.instantiateViewController(withIdentifier: "MIForgotPasswordViewController") as! MIForgotPasswordViewController
        return vc
    }
    
    @IBAction func nextClicked(_ sender: UIButton) {
        CommonClass.googleEventTrcking("forgot_Password_screen", action: "next", label: "")
        var userName = emailPhoneTxtFid.text!
        
        var validationMessage = [[String: Any]]()
        defer {
            let eventData = [
                "eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK_SUBMIT,
                "validationErrorMessages" : validationMessage
                ] as [String : Any]
            
            let eventType = (openMode == .forgotPassword) ? CONSTANT_JOB_SEEKER_TYPE.FORGOT_PASSWORD : CONSTANT_JOB_SEEKER_TYPE.LOGIN_WITH_OTP
            let destination = (openMode == .forgotPassword) ? CONSTANT_SCREEN_NAME.FORGOT_PASSWORD : CONSTANT_SCREEN_NAME.LOGIN_VIA_OTP
            MIApiManager.hitSeekerJourneyMapEvents(eventType, data: eventData, destination: destination) { (success, response, error, code) in
            }
        }
        
        if userName.isEmpty {
            let msg = "Please enter Email/Mobile."
            self.showError(with: msg)
            validationMessage.append(["field":"Email/Phone Number", "message" : msg])
            return
        }
        if !userName.isNumeric && !userName.isValidEmail {
            let msg = ErrorAndValidationMsg.validEmail.rawValue
            self.showError(with: msg)
            validationMessage.append(["field":"Email/Phone Number", "message" : msg])
            return
        }
        if userName.isNumeric {
            if !userName.validiateMobile(for: self.countryCodeTF.text ?? "+91").isValidate {
                let msg = userName.validiateMobile(for: self.countryCodeTF.text ?? "91").erroMessage
                self.showError(with: msg)
                validationMessage.append(["field":"Email/Phone Number", "message" : msg])
                return
            }
            userName = self.countryCodeTF.text! + userName
        }
        
        MIActivityLoader.showLoader()
        MIApiManager.sendOTP(userName) { (result, error) in
            MIActivityLoader.hideLoader()
            guard let data = result else { return }
     
            switch self.openMode {
            case .forgotPassword:
                let vc = MIResetOTPViewController(nibName: String(describing: MIResetOTPViewController.self), bundle: Bundle.main)
                vc.userName = userName
                vc.otpID = data.id
                self.navigationController?.pushViewController(vc, animated: true)

            case .login, .pendingVerification:
                
                let vc = MIOTPViewController(nibName: String(describing: MIOTPViewController.self), bundle: Bundle.main)
                vc.userName = userName
                if userName.isNumeric {
                    vc.countryCode = self.countryCodeTF.text!
                }
                vc.otpID = data.id
                vc.openMode = self.openMode
                vc.delegate = self.delegate
                self.navigationController?.pushViewController(vc, animated: true)

            default: break
                
            }
        }
    }
    
}

extension MIForgotPasswordViewController: UITextFieldDelegate {
    
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        self.selectTF(textField)
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        self.deselectTF(textField)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == self.emailPhoneTxtFid else { return true }
        
        self.selectTF(self.emailPhoneTxtFid)
        if textField.text?.count == 1 && string.isEmpty {
            self.descLabel.text = "Enter the email ID/phone number linked to your account. We’ll send OTP to your email ID/phone."
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.manageCountryCodeView(textField.text!)
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case countryCodeTF:
            let vc = MICountryCodePickerVC()
            vc.countryCodeSeleted = { country in
                self.countryCodeTF.text = "+" + country.callPrefix.stringValue
            }
            self.navigationController?.pushViewController(vc, animated: true)

            return false
        default:
            break
        }
        return true
    }
    
    private func manageCountryCodeView(_ text: String) {
        
        let show = text.isNumeric && text.count > 3
        UIView.animate(withDuration: 0.3) {
            if show {
                self.emailLeading.constant = 92
                self.countryCodeView.isHidden = false
            } else {
                self.emailLeading.constant = 12
                self.countryCodeView.isHidden = true
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func selectTF(_ textField: UITextField) {
        textField.layer.borderColor = AppTheme.defaltBlueColor.cgColor
        
        //(self.superview as? UITableView)?.beginUpdates()
        errorLabel.text = ""
        //(self.superview as? UITableView)?.endUpdates()
    }
    
    func deselectTF(_ textField: UITextField) {
        textField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        errorLabel.text = ""
    }
    
    func showError(with message: String) {
        
        emailPhoneTxtFid.layer.borderColor = Color.errorColor.cgColor
        errorLabel.textColor = Color.errorColor
        errorLabel.text = message
        if message.count == 0 {
            self.deselectTF(self.emailPhoneTxtFid)
        }
    }
}
