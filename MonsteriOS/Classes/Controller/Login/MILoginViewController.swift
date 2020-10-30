//
//  MILoginViewController.swift
//  MonsterIndia
//
//  Created by Monster on 12/10/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import AuthenticationServices

class MILoginViewController: MIBaseViewController {
    
    @IBOutlet weak private var tblView: UITableView!
    @IBOutlet weak private var registerBtn: UIButton!
    
    private let socialHeader        = MILoginHeaderView.header
    private let loginHeader         = MILoginFooterView.header
    private let orViewHeader        = MILoginORView.header
    private var tableCellData       = [[String:Any]]()
    private var loginArray          = [MILoginModel]()
    private var rememberMeArray     = [MILoginModel]()
    
    private let kTitleKey           = "title"
    private let kTableRowHasData    = "TableContainData"
    private let kLoginSection       = "Login"
    private let kRememberMeSection  = "RememberMe"
    private let kORSection          = "OR"
    
    private let DataRowsName        = ["Email","Password"]
    var hidePassword = true
    
    var userName = ""
    
    //MARK :- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.topView?.addShadow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CommonClass.googleAnalyticsScreen(self) //GA for Screen
        MIUserModel.resetUserResumeData()
        self.title = "Login"
        self.navigationItem.title = "Login"
        
        if JobSeekerSingleton.sharedInstance.dataArray?.last != self.screenName {
            JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)
          
            MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.LOGIN, data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.LANDING], destination: CONSTANT_SCREEN_NAME.LOGIN) { (success, response, error, code) in
            }
        }
    }
    
    class var newInstance:MILoginViewController {
        let vc = Storyboard.main.instantiateViewController(withIdentifier: "MILoginViewController") as! MILoginViewController
        return vc
    }
    
    // MARK:- Action
    @IBAction func registerClicked(_ sender: UIButton) {
        
        CommonClass.googleEventTrcking("log_in_screen", action: "register", label: "")

        let vc = MIBasicRegisterVC()
        vc.registerViaType = .None
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK:- Private Methods
    func setUI() {
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.clientID = kGmailClientId
        
        tblView.register(UINib(nibName: "MITextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "MITextFieldTableViewCell")
        tblView.register(UINib(nibName: "MILoginEmailCell", bundle: nil), forCellReuseIdentifier: "emailCell")
        tblView.register(UINib(nibName: "MILoginRememberMeCell", bundle: nil), forCellReuseIdentifier: "rememberMeCell")
        tblView.separatorColor  = UIColor.clear
        tblView.tableFooterView = socialHeader
        socialHeader.show(topTtl: "Login via OTP", bottom: "We won’t post anything on your profile.", topColor: AppTheme.defaltBlueColor,btColor: Color.colorTextLight)
        socialHeader.delegate = self
        tblView.isScrollEnabled = false
        self.populateDataSource()
        
        
        socialHeader.btnGoogle.isHidden = !CommonClass.showSocialLogin
        socialHeader.btnFacebook.isHidden = !CommonClass.showSocialLogin
        socialHeader.btnApple.isHidden = !CommonClass.showSocialLogin
        socialHeader.bottomLbl.isHidden = !CommonClass.showSocialLogin

        if #available(iOS 13.0, *), CommonClass.showSocialLogin {
            socialHeader.btnApple.isHidden = false
        } else {
            socialHeader.btnApple.isHidden = true
        }
        registerBtn.showSecondaryBtn(ttl: "Register",borderColor:AppTheme.btnCTAGreenColor,titileColor: AppTheme.btnCTAGreenColor )
        
        self.socialHeader.topLbl.addTapGestureRecognizer { _ in
            self.view.endEditing(true)
            CommonClass.googleEventTrcking("log_in_screen", action: "login_via_otp", label: "")
            
            MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.LOGIN_WITH_OTP, data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK], destination: CONSTANT_SCREEN_NAME.LOGIN) { (success, response, error, code) in
            }
            
            let vc = MIForgotPasswordViewController.newInstance
            vc.openMode = .login
            vc.userName = self.loginArray[0].data
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func configureUI() {
        let site = AppDelegate.instance.site
        
        loginArray.removeAll()
        rememberMeArray.removeAll()
        var model = MILoginModel.init(with: "Email", leftImgName: "")
        model.data = userName//"anupam.katiyar@monsterindia.com"
        model.adtionalData = "+" + (site?.defaultCountryDetails.callPrefix.stringValue ?? "")
        loginArray.append(model)
        
        model = MILoginModel.init(with: "Password", leftImgName: "", rightImgName: "")
        //        model.data = "123456"
        loginArray.append(model)
        
        model = MILoginModel.init(with: "", leftImgName: "")
        rememberMeArray.append(model)
        
    }
    
    func populateDataSource() {
        self.configureUI()
        tableCellData.removeAll()
        
        var dataDictOfSec = [kTitleKey:kLoginSection,kTableRowHasData:"\(loginArray.count)"]
        tableCellData.append(dataDictOfSec)
        
        dataDictOfSec = [kTitleKey:kRememberMeSection,kTableRowHasData:"\(rememberMeArray.count)"]
        tableCellData.append(dataDictOfSec)
        
        dataDictOfSec = [kTitleKey:kORSection,kTableRowHasData:"0"]
        tableCellData.append(dataDictOfSec)
        
        self.tblView.reloadData()
    }
    
    func getIndexPath(for str:String) -> NSIndexPath? {
        for section in 0..<tableCellData.count {
            let dataDict = self.tableCellData[section]
            if let infoArray = dataDict[kTableRowHasData] as? [MILoginModel] {
                for index in 0..<infoArray.count {
                    let info = infoArray[index]
                    if info.title == str {
                        return NSIndexPath(row: index, section: section)
                    }
                }
            }
        }
        return nil
    }
    
    
}

extension MILoginViewController: MILoginHeaderViewDelegate, MILoginFooterViewDelegate, GIDSignInDelegate, GIDSignInUIDelegate {
    
    func footerBtnClicked(_ sender: AKLoadingButton) {
        self.view.endEditing(true)
        CommonClass.googleEventTrcking("log_in_screen", action: "login_cta", label: "")
        
        var validationMessage = [[String: Any]]()
        defer {
            let eventData = [
                "eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK_SUBMIT,
                "validationErrorMessages" : validationMessage
                ] as [String : Any]
            MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.LOGIN, data: eventData, destination: CONSTANT_SCREEN_NAME.LOGIN) { (success, response, error, code) in
           
            }
        }
        
        let userName = self.loginArray[0].data.withoutWhiteSpace()
        let password = self.loginArray[1].data
        
        let cell0 = self.tblView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MITextFieldTableViewCell
        let cell1 = self.tblView.cellForRow(at: IndexPath(row: 1, section: 0)) as? MITextFieldTableViewCell

        if userName.isEmpty {
            let msg = "Email/Mobile can't be empty."
            cell0?.showError(with: msg)
            validationMessage.append(["field":"Email/Phone Number", "message" : msg])
            return
        }
        if userName.isNumeric {
            if !userName.validiateMobile(for: self.loginArray[0].adtionalData).isValidate {
                let msg = userName.validiateMobile(for: self.loginArray[0].adtionalData).erroMessage
                cell0?.showError(with: msg)
                validationMessage.append(["field":"Email/Phone Number", "message" : msg])
                return
            }
        }
        if !userName.isNumeric && !userName.isValidEmail {
            let msg = ErrorAndValidationMsg.validEmail.rawValue
            cell0?.showError(with: msg)
            validationMessage.append(["field":"Email/Phone Number", "message" : msg])
            return
        }
        if password.isEmpty {
            let msg = ErrorAndValidationMsg.password.rawValue
            cell1?.showError(with: msg)
            validationMessage.append(["field":"Password", "message" : msg])
            return
        }
        
        var param = [
            "username" : userName.isNumeric ? self.loginArray[0].adtionalData + userName : userName,
            "password" : password
        ]
        MIActivityLoader.showLoader()
        
        MIApiManager.loginAPI(&param) { (result, error) in
            MIActivityLoader.hideLoader()
            guard let data = result else {
                self.showAlert(title:"Error", message:error?.localizedDescription)
                return
            }
            
            CommonClass.predefinedLogIn("login_cta")
            
            AppDelegate.instance.authInfo = data
            AppDelegate.instance.authInfo.commit()
            
            let home = MIHomeTabbarViewController()
            home.modalPresentationStyle = .fullScreen
            self.present(home, animated: true, completion: nil)
        }
        
    }
    
    func socialLoginUser(_ param: inout [String: String], appleData: JSONDICT?=nil) {
        var socialPlatformName =  ""
        var registerViaType: RegisterVia = .None
        switch param["social_provider"] {
        case "facebook":
            socialPlatformName = "FaceBook"
            registerViaType = .Facebook
        case "google":
            socialPlatformName = "Google"
            registerViaType = .Google
        case "apple":
            socialPlatformName = "Apple"
            registerViaType = .Apple
        default: break
        }
        
        MIActivityLoader.showLoader()
        MIApiManager.socialLoginAPI(&param) { (result, error) in
            MIActivityLoader.hideLoader()
            guard let data = result else {
                
                if (error?.code ?? 0) != 400 {
                    let vc = MIBasicRegisterVC()
                    vc.registerViaType = registerViaType
                    vc.appleData = appleData
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else{
                    self.showAlert(title:"Error", message:error?.localizedDescription)
                }
                
                return
            }
           
            
            CommonClass.predefinedLogIn(socialPlatformName)
            
            AppDelegate.instance.authInfo = data
            AppDelegate.instance.authInfo.commit()
            
            let home = MIHomeTabbarViewController()
            home.modalPresentationStyle = .fullScreen
            self.present(home, animated: true, completion: nil)
        }
    }
    
    func socialClickEvent(_ socialPlatformName: String) {
        let eventData = [
            "eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK,
            "socialPlatformName" : socialPlatformName
        ]
        
        MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.SOCIAL_LOGIN, data: eventData, destination: CONSTANT_SCREEN_NAME.LOGIN) { (success, response, error, code) in
        }
    }
    
    func fbClicked() {
        CommonClass.googleEventTrcking("log_in_screen", action: "social", label: "facebook")
        self.socialClickEvent("FaceBook")
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
            
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email")) {
                    self.getFBUserData()
                    
                }
            }
        }
        
    }
    
    func gmailClicked() {
        CommonClass.googleEventTrcking("log_in_screen", action: "social", label: "google")
        self.socialClickEvent("Google")

        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func getFBUserData(){
        guard let token = FBSDKAccessToken.current()?.tokenString  else { return }
        var param = [
            "username"        : token,
            "social_provider" : "facebook",
            "grant_type"      : "password",
            "scope"           : "all"
        ]
        self.socialLoginUser(&param)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            // ...
            guard let token = user?.authentication.idToken else { return }
            var param = [
                "username"        : token,
                "social_provider" : "google",
            ]
            self.socialLoginUser(&param)
        } else {
            // print("\(error.localizedDescription)")
        }
    }
    
}

@available(iOS 13.0, *)
extension MILoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func appleClicked() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [ .fullName, .email ]
            
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //Handle error here
        //self.showAlert(title:"Error", message:error.localizedDescription)
    }
    
    // ASAuthorizationControllerDelegate function for successful authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Create an account in your system.
//            let userIdentifier = appleIDCredential.user
//            let authorizationCode = appleIDCredential.authorizationCode
            let userFirstName = appleIDCredential.fullName?.givenName ?? ""
            let userLastName = appleIDCredential.fullName?.familyName ?? ""
            let userEmail = appleIDCredential.email
            
            guard
                let code = appleIDCredential.authorizationCode,
                let token = String(data: code, encoding: .utf8)
                else { return }
            
            MIActivityLoader.showLoader()
            MIApiManager.appleLoginRefreshTokenAPI(token) { (result, error) in
                guard let data = result else {
                    MIActivityLoader.hideLoader()
                    return
                }
                
                var param = [
                    "username"        : data.refreshToken,
                    "social_provider" : "apple",
                    "grant_type"      : "password",
                    "scope"           : "all"
                ]
                
                let nameEmail = [
                    "name"  : userFirstName + " " + userLastName,
                    "email" : userEmail as Any,
                    "code" : data.refreshToken
                ]
                
                self.socialLoginUser(&param, appleData: nameEmail)
            }
        } else {
        
        }
    }

}

extension MILoginViewController: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableCellData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataDict = self.tableCellData[section]
        var numberOfRows = 0
        if dataDict[kTableRowHasData] != nil {
            if let row = dataDict[kTableRowHasData] as? String{
                numberOfRows = Int(row)!
            }
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataDict = self.tableCellData[indexPath.section]
        let sectionTitle = dataDict[kTitleKey] as? String
        
        if kLoginSection == sectionTitle {
            let info = loginArray[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withClass: MITextFieldTableViewCell.self, for: indexPath)
            cell.secondryTFWidth?.constant = 70
            cell.primaryTextField.delegate = self
            cell.primaryTextField.rightViewMode = .never
            cell.secondryTextField.isHidden = true
            cell.primaryTextField.isSecureTextEntry = false
            
            if let name = AppDelegate.instance.site?.defaultCountryDetails.langOne?.first?.name,
                name == "India",
                info.title == "Email" {
                cell.primaryTextField.placeholder = "Email / Phone Number"
                cell.titleLabel.text = "Email / Phone Number"
            } else {
                cell.primaryTextField.placeholder = info.title
                cell.titleLabel.text = info.title
            }
            
            cell.primaryTextField.text = info.data
            cell.secondryTextField.text = info.adtionalData
            
            
            switch indexPath.row {
            case 0:
                cell.primaryTextField.returnKeyType = .next
                cell.secondryTextField.isHidden = !(info.data.isNumeric && info.data.count > 3)
                
                cell.secondryTextFieldAction = { tf in
                    let vc = MICountryCodePickerVC()
                    vc.countryCodeSeleted = { country in
                        tf.text = "+" + country.callPrefix.stringValue
                        info.adtionalData = tf.text!
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                    return false
                }
            case 1:
                cell.primaryTextField.returnKeyType = .go
                cell.primaryTextField.rightViewMode = .always
                cell.primaryTextField.rightView = cell.eyeIcon
                cell.primaryTextField.isSecureTextEntry = hidePassword
                cell.eyeIcon?.isSelected = !hidePassword
                
                cell.hidePasswordCallBack = { show in
                    self.hidePassword = !show
                    if show {
                        CommonClass.googleEventTrcking("log_in_screen", action: "show_password", label: "")
                    }
                    cell.primaryTextField.isSecureTextEntry = !show
                }
                
            default: break
            }
            
            
            return cell
        }
        else if kRememberMeSection == sectionTitle {
            let cell = tableView.dequeueReusableCell(withIdentifier: "rememberMeCell") as? MILoginRememberMeCell
            cell?.forPasswordClicked = {
                self.view.endEditing(true)
                CommonClass.googleEventTrcking("log_in_screen", action: "forgot_password", label: "")
                
                MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.FORGOT_PASSWORD, data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK], destination: CONSTANT_SCREEN_NAME.LOGIN) { (success, response, error, code) in
                }
                
                let vc = MIForgotPasswordViewController.newInstance
                vc.openMode = .forgotPassword
                vc.userName = self.loginArray[0].data
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            return cell!
        }
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "default")
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dataDict = self.tableCellData[section]
        let sectionTitle = dataDict[kTitleKey] as? String
        if sectionTitle == kORSection {
            loginHeader.show(ttl: "Login")
            loginHeader.delegate = self
            return loginHeader
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.tableView(self.tblView, viewForHeaderInSection: section) != nil {
            return UITableView.automaticDimension
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let dataDict = self.tableCellData[section]
        let sectionTitle = dataDict[kTitleKey] as? String
        if sectionTitle == kORSection {
            orViewHeader.backgroundColor = .white
            return orViewHeader
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.tableView(self.tblView, viewForFooterInSection: section) != nil {
            return UITableView.automaticDimension
        }
        return 0
    }
    
    
}


extension MILoginViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let indexPath = textField.tableViewIndexPath(self.tblView), indexPath.row == 0 else { return true }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) { [unowned self] in
            self.manageCountryCodeView(textField)
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let indexPath = textField.tableViewIndexPath(self.tblView) else { return }

        self.loginArray[indexPath.row].data = textField.text!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.returnKeyType {
        case .next:
            if let index = self.loginArray.firstIndex(where: { $0.title == "Password" }) {
                let cell = self.tblView.cellForRow(at: IndexPath(row: index, section: 0)) as? MITextFieldTableViewCell
                cell?.primaryTextField.becomeFirstResponder()
            }
        case .go:
            self.view.endEditing(true)
            self.footerBtnClicked(AKLoadingButton())
        default: break
        }
        return true
    }
    
    private func manageCountryCodeView(_ textField: UITextField) {
        guard let cell = textField.tableViewCell() as? MITextFieldTableViewCell else { return }
        let show = textField.text!.isNumeric && textField.text!.count > 3
        
        if show {
            cell.secondryTextField.showAnimated(in: cell.stackView)
        } else {
            cell.secondryTextField.hideAnimated(in: cell.stackView)
        }
        cell.stackView.layoutIfNeeded()
    }
    
}
