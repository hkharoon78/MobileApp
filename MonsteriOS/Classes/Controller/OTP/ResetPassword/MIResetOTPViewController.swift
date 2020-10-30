//
//  MIResetOTPViewController.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 09/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIResetOTPViewController: MIBaseViewController {
    
    //MARK:Outlets And Variables
    @IBOutlet weak var change_Mobile_Label: UILabel!
    @IBOutlet weak var otpView: UIView!
    @IBOutlet var optTextField: [OTPTextField]!
    @IBOutlet weak var otpRecievedLabel: UILabel!
    @IBOutlet weak var resendButton: UIButton!
    
    @IBOutlet weak var titleHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var errorLabel1: UILabel!
    @IBOutlet weak var errorLabel2: UILabel!

    @IBOutlet weak var resetPasswordButton: AKLoadingButton!
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    @IBOutlet weak var btnNewPasswd: UIButton!
    @IBOutlet weak var btnConfirmPasswd: UIButton!
    
    var otpID = ""
    var userName = ""
    
    private struct StoryBoardConstant{
        static let haveRecievedTitleForPhone="We have sent an OTP to your phone number:"
        static let haveRecievedTitleForEmail="We have sent an OTP to your email:"

        static let change="      Change"
    }
    
    //MARK:Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resendButton.setTitleColor(AppTheme.defaltBlueColor, for: .normal)
        self.resetPasswordButton.showPrimaryBtn()
        
        self.newPasswordTF.delegate = self
        self.confirmPasswordTF.delegate = self
        self.optTextField[0].becomeFirstResponder()
        //otpView.apply(shadowOffset: CGSize(width: 1.0, height: 1.0), shadowColor: .lightGray)
        for textField in optTextField {
            textField.delegate=self
            textField.addTarget(self, action: #selector(MIOTPViewController.textFieldTap(_:)), for: .editingChanged)
            textField.onDeleteBackwards = {
           
                switch textField.tag{
                case 5:
                    self.optTextField[4].becomeFirstResponder()
                case 4:
                    self.optTextField[3].becomeFirstResponder()
                case 3:
                    self.optTextField[2].becomeFirstResponder()
                case 2:
                    self.optTextField[1].becomeFirstResponder()
                case 1:
                    self.optTextField[0].becomeFirstResponder()
                default:
                    break
                }
            }
        }
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title=ControllerTitleConstant.otp
        self.navigationItem.title=ControllerTitleConstant.otp
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        change_Mobile_Label.sizeToFit()
        self.titleHeightConstraint.constant = change_Mobile_Label.frame.height + 10
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }
    
    
    @discardableResult
    func startTimer() -> Timer? {
        guard self.time <= 0 else {
            return nil
        }
        self.time = 30
        self.resendButton.isHidden = true
        return Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerStarted(_:)), userInfo: nil, repeats: true)
    }
    
    var time = 0
    @objc func timerStarted(_ timer: Timer) {
        if time > 0 {
            self.otpRecievedLabel.text = "Didn’t receive your OTP? (" + time.stringValue + ")"
        } else {
            self.otpRecievedLabel.text = "Didn’t receive your OTP?"
            self.resendButton.isHidden = false
            timer.invalidate()
        }
        time -= 1
    }
    

    
    func setUpView(){
        let titleString=NSMutableAttributedString(string:userName.isNumeric ? StoryBoardConstant.haveRecievedTitleForPhone : StoryBoardConstant.haveRecievedTitleForEmail, attributes: [NSAttributedString.Key.foregroundColor:AppTheme.textColor,NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 16)])
        let phoneNumberString=NSAttributedString(string: userName, attributes: [NSAttributedString.Key.foregroundColor:AppTheme.textColor,NSAttributedString.Key.font:UIFont.customFont(type: .Medium, size: 16)])
        let changeString=NSAttributedString(string:StoryBoardConstant.change, attributes: [NSAttributedString.Key.foregroundColor:AppTheme.defaltBlueColor,NSAttributedString.Key.font:UIFont.customFont(type: .Medium, size: 16)])
        titleString.append(phoneNumberString)
        titleString.append(changeString)
        self.change_Mobile_Label.attributedText=titleString
        self.change_Mobile_Label.isUserInteractionEnabled=true
        let tapGest=UITapGestureRecognizer(target: self, action: #selector(MIOTPViewController.changePhoneAction(_:)))
        tapGest.numberOfTapsRequired=1
        self.change_Mobile_Label.addGestureRecognizer(tapGest)
        
        self.startTimer()
        self.otpRecievedLabel.text="Didn’t receive your OTP? (30)"
    }
    
    //MARK:Change Phone Number Action
    
    @IBAction func showHidePasswd(_ sender: UIButton){
        
        switch  sender.tag {
        case 0:
            self.newPasswordTF.isSecureTextEntry = !self.newPasswordTF.isSecureTextEntry
            if self.newPasswordTF.isSecureTextEntry {
                CommonClass.googleEventTrcking("enter_otp_screen", action: "show_password", label: "")
            }
        case 1:
            self.confirmPasswordTF.isSecureTextEntry = !self.confirmPasswordTF.isSecureTextEntry
            if self.confirmPasswordTF.isSecureTextEntry {
                CommonClass.googleEventTrcking("enter_otp_screen", action: "show_password", label: "")
            }
        default:
            break
        }
        sender.isSelected = !sender.isSelected
        
    }
    
    
    @objc func changePhoneAction(_ sender:UITapGestureRecognizer){
        guard let range = self.change_Mobile_Label.text?.range(of:StoryBoardConstant.change)?.nsRange else {
            return
        }
        if sender.didTapAttributedTextInLabel(label: self.change_Mobile_Label, inRange: range) {
            CommonClass.googleEventTrcking("enter_otp_screen", action: "change", label: "")
            // Substring tapped
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func resetMyPasswordAction(_ sender: AKLoadingButton) {
        self.view.endEditing(true)
        CommonClass.googleEventTrcking("enter_otp_screen", action: "reset_my_password", label: "")

        let otp = self.optTextField.map({ $0.text! }).joined(separator: "")
        guard !otp.isEmpty || !(otp.count < 6) else {
            self.showAlert(title: "", message: "Please enter OTP", isErrorOccured: true)
//            self.showPopUpView(title: "Alert", message: "Please enter OTP", primaryBtnTitle: "OK") { (isPrimaryCliecked) in
//
//            }
            
            //  AKAlertController.alert("Alert", message: "Please enter OTP")
            return
        }
        guard !self.newPasswordTF.text!.isEmpty else {
            self.showError(on: self.newPasswordTF, label: self.errorLabel1, message: "Please enter password")
            return
        }
        guard !self.confirmPasswordTF.text!.isEmpty else {
            self.showError(on: self.confirmPasswordTF, label: self.errorLabel2, message: "Please enter password")
            return
        }
        guard self.newPasswordTF.text == self.confirmPasswordTF.text else {
            self.showError(on: self.confirmPasswordTF, label: self.errorLabel2, message: "Password doesn't match")
            return
        }
        
        
        var param = [
            "username" : self.userName,
            "otp"      : otp,
            "otp_id"   : self.otpID,
            "new_password" : self.newPasswordTF.text!
        ]
        
        MIApiManager.loginAPI(&param) { (result, error) in
            guard let data = result else {
                self.showAlert(title:"Error", message:error?.localizedDescription)
                return
            }
            AppDelegate.instance.authInfo = data
            AppDelegate.instance.authInfo.commit()
            let home = MIHomeTabbarViewController()
            home.modalPresentationStyle = .fullScreen
            self.present(home, animated: true, completion: nil)
        }
    }
    
    //MARK:Text Field Touch Action
    @objc func textFieldTap(_ sender:UITextField){
        let textCount = sender.text?.count ?? 0
        
        if textCount == 1 {
            switch sender.tag{
            case 0:
                optTextField[1].becomeFirstResponder()
            case 1:
                optTextField[2].becomeFirstResponder()
            case 2:
                optTextField[3].becomeFirstResponder()
            case 3:
                optTextField[4].becomeFirstResponder()
            case 4:
                optTextField[5].becomeFirstResponder()
            default:
                break
            }
        }
    }
    
    
    @IBAction func resendOTPAction(_ sender: UIButton) {
        CommonClass.googleEventTrcking("enter_otp_screen", action: "resend_otp", label: "")

        MIActivityLoader.showLoader()
        MIApiManager.sendOTP(self.userName) { (result, error) in
            MIActivityLoader.hideLoader()
            guard let data = result else { return }
            
            self.otpID = data.id
            self.startTimer()
        }
    }
    
    func showError(on textField: UITextField, label: UILabel, message: String) {
        
        textField.layer.borderColor = Color.errorColor.cgColor
        label.textColor = Color.errorColor
        label.text = message
        if message.count == 0 {
            self.deselectTF(textField, label: label)
        }
    }
    
    func deselectTF(_ textField: UITextField, label: UILabel) {
        textField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        label.text = ""
    }
}

//MARK: Text Field Delegate method
extension MIResetOTPViewController:UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
        switch textField {
        case newPasswordTF:
            self.errorLabel1.text=""
        case confirmPasswordTF:
            self.errorLabel2.text=""
        default:
            break
        }
        textField.layer.borderColor = AppTheme.defaltBlueColor.cgColor

        self.setMainViewFrame(originY: 0)
        let movingHeight = textField.movingHeightIn(view : self.view)
        if movingHeight > 0 {
            UIView.animate(withDuration: 0.3) {
                self.setMainViewFrame(originY: -movingHeight)
            }
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.lightGray.cgColor

        UIView.animate(withDuration: 0.3) {
            self.setMainViewFrame(originY: 0)
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard textField != self.newPasswordTF && textField != self.confirmPasswordTF else {
            return true
        }

        switch textField.tag {
        case 1:
            if optTextField[0].text?.count ?? 0 > 0{
                return true
            }else{
                return false
            }
        case 2:
            if optTextField[1].text?.count ?? 0 > 0{
                return true
            }else{
                return false
            }
        case 3:
            if optTextField[2].text?.count ?? 0 > 0{
                return true
            }else{
                return false
            }
        case 4:
            if optTextField[3].text?.count ?? 0 > 0{
                return true
            }else{
                return false
            }
        case 5:
            if optTextField[4].text?.count ?? 0 > 0{
                return true
            }else{
                return false
            }
        default:
            return true
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField != self.newPasswordTF && textField != self.confirmPasswordTF else {
            return true
        }
        let maxLength = 1
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        if textField.tag==5{
            if newString.length==maxLength{
                DispatchQueue.main.async {
                    textField.resignFirstResponder()
                    //Last Field
                }
            }
        }
        return newString.length <= maxLength && allowedCharacters.isSuperset(of: characterSet)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.newPasswordTF:
            self.confirmPasswordTF.becomeFirstResponder()
            
        case self.confirmPasswordTF:
            self.confirmPasswordTF.resignFirstResponder()
            self.resetMyPasswordAction(resetPasswordButton)
        default:
            break
        }

        return true
    }
    
}



