//
//  MIOTPViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 09/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

 protocol PendingActionDelegate {
    func verifiedUser(_ id: String,openMode:OpenMode)
    func otpDetailData(otp:String,otpId:String)

}

extension PendingActionDelegate {
    func verifiedUser(_ id: String,openMode:OpenMode){}
    func otpDetailData(otp:String,otpId:String){}

}

class MIOTPViewController: MIBaseViewController {
    
    //MARK:Outlets And Variables
    @IBOutlet weak var change_Mobile_Label: UILabel!
    @IBOutlet weak var otpView: UIView!
    @IBOutlet var optTextField: [OTPTextField]!
    @IBOutlet weak var otpRecievedLabel: UILabel!
    @IBOutlet weak var resendToSMSButton: UIButton!
    @IBOutlet weak var resendToEmailButton: UIButton!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var titleHeightConstraint: NSLayoutConstraint!
    
    var otpID = ""
    var userName = ""
    var countryCode = ""
    var otpVerifySuccess : ((Bool) -> Void)?
    var openMode: OpenMode = .forgotPassword
    var delegate: PendingActionDelegate?
    
    private struct StoryBoardConstant{
        static let resendSMS = "Resend OTP via SMS"
        static let resendEmail = "Get your OTP via call"
     //   static let haveRecievedTitle = userName.isNumeric ? "We have sent an OTP to your phone number :" : "We have sent an OTP to your email :"
        static let change = "      Change"
        static let or = "OR"
    }
    
    
    //MARK:Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        CommonClass.googleAnalyticsScreen(self) //GA for Screen
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

        self.title=ControllerTitleConstant.otp
        self.navigationItem.title=ControllerTitleConstant.otp
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        change_Mobile_Label.sizeToFit()
        self.titleHeightConstraint.constant = change_Mobile_Label.frame.height + 10
    }
    
    func setUpView(){
        self.resendToSMSButton.setTitle(StoryBoardConstant.resendSMS, for: .normal)
        self.resendToEmailButton.setTitle(StoryBoardConstant.resendEmail, for: .normal)
        self.orLabel.text=StoryBoardConstant.or
        let titleString=NSMutableAttributedString(string:userName.isNumeric ? "We have sent an OTP to your phone number :" : "We have sent an OTP to your email :", attributes: [NSAttributedString.Key.foregroundColor:AppTheme.textColor,NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 16)])
        let phoneNumberString=NSAttributedString(string: userName.isNumeric ? ("+\(self.countryCode)" + userName) : userName , attributes: [NSAttributedString.Key.foregroundColor:AppTheme.textColor,NSAttributedString.Key.font:UIFont.customFont(type: .Medium, size: 16)])
        let changeString=NSAttributedString(string:StoryBoardConstant.change, attributes: [NSAttributedString.Key.foregroundColor:AppTheme.defaltBlueColor,NSAttributedString.Key.font:UIFont.customFont(type: .Medium, size: 16)])
        titleString.append(phoneNumberString)
        if openMode != .verifyEmail &&  openMode != .verifyMobileNumber  &&  openMode != .register &&  openMode != .viaRegisterClaim {
            titleString.append(changeString)

        }else{
            self.callAPIForResendOTPMobileEmail()
        }
        self.change_Mobile_Label.attributedText=titleString
        self.change_Mobile_Label.isUserInteractionEnabled=true
        let tapGest=UITapGestureRecognizer(target: self, action: #selector(MIOTPViewController.changePhoneAction(_:)))
        tapGest.numberOfTapsRequired=1
        self.change_Mobile_Label.addGestureRecognizer(tapGest)
        self.resendButton.setTitleColor(AppTheme.defaltBlueColor, for: .normal)
        self.otpRecievedLabel.text = "Didn’t receive your OTP? (30)"
        self.startTimer()
        
        if self.openMode == .register {
            // Delay 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                let skipButton=UIBarButtonItem(title: NavigationBarButtonTitle.skip, style: .plain, target: self, action: #selector(MIOTPViewController.skipButtonTap))
                self.navigationItem.rightBarButtonItem=skipButton
            }
            
        }
        
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
    
    //Mark:- Web service helper methods
    func callAPIForResendOTPMobileEmail() {
        var params = [String:Any]()
        var endPoint = ""
        if openMode == .verifyMobileNumber || openMode == .register {
            endPoint = APIPath.sendOTPMobileEndPoint
            params["countryCode"] = countryCode.replacingOccurrences(of: "+", with: "")
            params["mobileNumber"] = userName

        }else if openMode == .viaRegisterClaim {
            endPoint = APIPath.anonyymousClaimOnRegister
            params["countryCode"] = countryCode.replacingOccurrences(of: "+", with: "")
            params["mobileNumber"] = userName

        }else {
            endPoint = APIPath.sendOTPEmailEndPoint
            params["email"] = userName

        }
        
        MIActivityLoader.showLoader()

        MIApiManager.callAPIForSendOTP(methodType: .post, path: endPoint, params: params) { (success, response, error, code) in

            DispatchQueue.main.async {
                MIActivityLoader.hideLoader()

                if error == nil && (code >= 200) && (code <= 299) {
                    
                    if let result = response as? [String:Any] {
                        self.showAlert(title: "", message: "OTP sent to your registered mobile number/email-id.",isErrorOccured:false)

                        self.otpID = result["id"] as! String
                    } else {
                        self.handleAPIError(errorParams: response, error: error)
                    }
                }else{
                    self.handleAPIError(errorParams: response, error: error)
                }
            }
            
        }
    }
    func callAPIForVerifyMobileEmail() {
        
        var params = [String:Any]()
        var endPoint = ""

        if openMode == .verifyMobileNumber || openMode == .register {
            endPoint = APIPath.validateMobileEndPoint
            var mobile = [String:Any]()

            mobile["countryCode"] = countryCode.replacingOccurrences(of: "+", with: "")
            mobile["mobileNumber"] = userName
            
            params["mobileNumber"] = mobile
            
        }else{
            var email = [String:Any]()

            endPoint = APIPath.validateEmailEndPoint
            email["email"] = userName
            params["email"] = email

            
        }
        let otp = self.optTextField.map({ $0.text! }).joined(separator: "")
        guard !otp.isEmpty else { return }

        params["otp"] = otp
        params["otpId"] = self.otpID
        if self.otpID.isEmpty {
            return
        }
        
        MIApiManager.callAPIForValidateOTP(methodType: .post, path: endPoint, params: params) { (success, response, error, code) in
            DispatchQueue.main.async {

            if error == nil  && (code >= 200) && (code <= 299) {
              
                    if self.delegate != nil {
                        self.delegate?.verifiedUser(self.userName, openMode: self.openMode)
                        
                    }
                    if self.openMode == .register {
                        self.skipButtonTap()

                    }else{
                        shouldRunProfileApi = true
                        if self.openMode == .verifyEmail {
//                            let properties = [
//                                "screen_name" : "VerifyOTP",
//                                "email_id" : self.userName,
//                                "email_verification":"YES"
//                            ]
//
//                            if let lastUpdated = UserDefaults.standard.value(forKey: "profile_last_updated") as? String {
//                                let userProperties = [ "profile_last_updated": lastUpdated, "email_verification" : "YES" ]
//                                CommonClass.userProperties(userProperties)
//                            }
                            
                        }else if self.openMode == .verifyMobileNumber {
                            JobSeekerSingleton.sharedInstance.fieldLevelDataArray = [CONSTANT_FIELD_LEVEL_NAME.VERIFY_MOBILE]
                        }
                        
                        self.showAlert(title: "", message: "Successfully updated.", isErrorOccured: false) { 
                            if let success = self.otpVerifySuccess {
                                success(true)
                            }
                            self.navigationController?.popViewController(animated: true)
                        }
//                        self.showPopUpView(title: "", message: "Successfully updated.", primaryBtnTitle: "OK") { (_) in
//                            if let success = self.otpVerifySuccess {
//                                                           success(true)
//                                                       }
//                                                       self.navigationController?.popViewController(animated: true)
//                        }
                        
//                        AKAlertController.alert("", message: "Successfully updated.", acceptMessage: "Ok", acceptBlock: {
//                            if let success = self.otpVerifySuccess {
//                                success(true)
//                            }
//                            self.navigationController?.popViewController(animated: true)
//
//                        })
                    }
             //   }
 
            }else{
                self.handleAPIError(errorParams: response, error: error)
            }
        }
        }
        
    }
    
   
    //MARK:Change Phone Number Action
    @objc func changePhoneAction(_ sender:UITapGestureRecognizer){
        guard let range = self.change_Mobile_Label.text?.range(of:StoryBoardConstant.change)?.nsRange else {
            return
        }
        if sender.didTapAttributedTextInLabel(label: self.change_Mobile_Label, inRange: range) {
            // Substring tapped
            self.navigationController?.popViewController(animated: true)
           // print("tapped on change")
        }
    }
    
    //Mark:Skip Button Action
    @objc func skipButtonTap(){
        CommonClass.googleEventTrcking("registration_screen", action: "enter_otp", label: "skip")

        if MIUserModel.userSharedInstance.userProfessionalType == .Experienced {
            let vc = MIEmployementForUserVC()
            vc.isFreshOrExper = .Experienced
            self.navigationController?.pushViewController(vc, animated: true)

        }else{
            let vc = MIEducationByUserVC()
            vc.isFreshOrExper = .Fresher
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func navigateToNewController() {
        
        let otp = self.optTextField.map({ $0.text! }).joined(separator: "")
        guard !otp.isEmpty else { return }
        
        
        var param = [
            "username" : self.userName,
            "otp"      : otp,
            "otp_id"   : self.otpID,
        ]
        
        MIApiManager.loginAPI(&param) {[unowned self] (result, error) in
            guard let data = result else {
                self.showAlert(title:"Error", message:error?.localizedDescription)
                return
            }

            switch self.openMode {
            case .forgotPassword:
                break;
            case .login:
                CommonClass.predefinedLogIn("OTP")
                AppDelegate.instance.authInfo = data
                AppDelegate.instance.authInfo.commit()

                let home = MIHomeTabbarViewController()
                home.modalPresentationStyle = .fullScreen
                self.present(home, animated: true, completion: nil)

            case .pendingVerification:
                self.delegate?.verifiedUser(self.userName, openMode: self.openMode)
                DispatchQueue.main.async {
                    self.showAlert(title: "", message: "Successfully updated.", isErrorOccured: false) {
                        self.navigationController?.popToRootViewController(animated: true)

                    }
//                    self.showPopUpView(message: "Successfully updated.", primaryBtnTitle: "OK") { (_) in
//                        self.navigationController?.popToRootViewController(animated: true)
//
//                    }
//                    AKAlertController.alert("", message: "Successfully updated.", acceptMessage: "OK", acceptBlock: {
//                        self.navigationController?.popToRootViewController(animated: true)
//                    })
                }
               
            default:
                break
            }
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

        if openMode == .verifyEmail || openMode == .verifyMobileNumber || openMode == .register || openMode == .viaRegisterClaim {
            if openMode == .register {
                CommonClass.googleEventTrcking("registration_screen", action: "enter_otp", label: "resend_otp")
            }
            self.startTimer()
            self.callAPIForResendOTPMobileEmail()
            return
        }

        MIActivityLoader.showLoader()
        MIApiManager.sendOTP(self.userName) { (result, error) in
            MIActivityLoader.hideLoader()
            guard let data = result else { return }
            
            self.otpID = data.id
            self.startTimer()
        }
    }
    
    //MARK:Resend Otp Via SMS Action
    @IBAction func resendOtpViaSMSAction(_ sender: UIButton) {
        
    }
    
    //MARk:Resend OTP via call
    @IBAction func resendOTPViaCallAction(_ sender: UIButton) {
        
    }
    
}

//MARK: Text Field Delegate method
extension MIOTPViewController:UITextFieldDelegate{
    
 
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = AppTheme.defaltBlueColor.cgColor
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.lightGray.cgColor
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
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

                    if self.openMode == .verifyEmail || self.openMode == .verifyMobileNumber || self.openMode == .register  {
                        self.callAPIForVerifyMobileEmail()
                    }else if self.openMode == .viaRegisterClaim {
                        if let deletgate = self.delegate {
                            let otp = self.optTextField.map({ $0.text! }).joined(separator: "")
                            guard !otp.isEmpty else { return }

                            deletgate.otpDetailData(otp: otp, otpId: self.otpID)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }else {
                        self.navigateToNewController()

                    }
                }
            }
        }
        return newString.length <= maxLength && allowedCharacters.isSuperset(of: characterSet)
    }
    
}



