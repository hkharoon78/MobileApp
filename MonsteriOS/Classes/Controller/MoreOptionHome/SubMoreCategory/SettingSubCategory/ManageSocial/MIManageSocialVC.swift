//
//  MIManageSocialVC.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 25/03/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import AuthenticationServices

class MIManageSocialVC: UIViewController {
    
    @IBOutlet weak var fbView: UIView!
    @IBOutlet weak var googleView: UIView!
    @IBOutlet weak var appleView: UIView!
    
    @IBOutlet weak var fbImageView: UIImageView!
    @IBOutlet weak var fbLabel: UILabel!
    @IBOutlet weak var fbSwitch: UISwitch!
    
    @IBOutlet weak var googleImageView: UIImageView!
    @IBOutlet weak var googleLabel: UILabel!
    @IBOutlet weak var googleSwitch: UISwitch!
    
    @IBOutlet weak var appleImageView: UIImageView!
    @IBOutlet weak var appleLabel: UILabel!
    @IBOutlet weak var appleSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Manage Social Accounts"
        
        self.fbSwitch.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        self.googleSwitch.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        self.appleSwitch.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        self.fbView.addShadow(opacity: 0.1)
        self.googleView.addShadow(opacity: 0.1)
        self.appleView.addShadow(opacity: 0.1)
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.clientID = kGmailClientId
        
        self.googleSwitch.onTintColor = AppTheme.defaltBlueColor
        self.fbSwitch.onTintColor = AppTheme.defaltBlueColor
        self.appleSwitch.onTintColor = AppTheme.defaltBlueColor
        
        self.managePreferences()
        
        if #available(iOS 13.0, *) {
            self.appleView.isHidden = false
        } else {
            self.appleView.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)
    }
    
    func managePreferences() {
        self.enableFacebook(AppDelegate.instance.userInfo.socialProviders.contains("facebook"))
        self.enableGoogle(AppDelegate.instance.userInfo.socialProviders.contains("google"))
        self.enableApple(AppDelegate.instance.userInfo.socialProviders.contains("apple"))
        
        self.fbSwitch.isOn     = AppDelegate.instance.userInfo.socialProviders.contains("facebook")
        self.googleSwitch.isOn = AppDelegate.instance.userInfo.socialProviders.contains("google")
        self.appleSwitch.isOn = AppDelegate.instance.userInfo.socialProviders.contains("apple")
    }
    
    @IBAction func facebookSwitchAction(_ sender: UISwitch) {
        self.enableFacebook(sender.isOn)
        
        if sender.isOn {
            FBSDKAccessToken.setCurrent(nil)
            self.authenticateFacebook()
            
            CommonClass.googleEventTrcking("settings_screen", action: "manage_social_accounts", label: "facebook_toggle_on") //GA
            
        } else {
            let param = [
                "id"             : AppDelegate.instance.userInfo.uuid,
                "socialProvider" : "facebook"
            ]
            
            self.unlinkSocial(param)
            
            CommonClass.googleEventTrcking("settings_screen", action: "manage_social_accounts", label: "facebook_toggle_off")//GA
        }
        
    }
    
    
    @IBAction func googleSwitchAction(_ sender: UISwitch) {
        self.enableGoogle(sender.isOn)
        
        if sender.isOn {
            GIDSignIn.sharedInstance()?.signOut()
            GIDSignIn.sharedInstance()?.signIn()
            
            CommonClass.googleEventTrcking("settings_screen", action: "manage_social_accounts", label: "google_toggle_on") //GA
        } else {
            let param = [
                "id"             : AppDelegate.instance.userInfo.uuid,
                "socialProvider" : "google"
            ]
            
            self.unlinkSocial(param)
            
            CommonClass.googleEventTrcking("settings_screen", action: "manage_social_accounts", label: "google_toggle_off") //GA
        }
        
    }
    
    @IBAction func appleSwitchAction(_ sender: UISwitch) {
        self.enableApple(sender.isOn)
        
        if sender.isOn {
            if #available(iOS 13.0, *) {
                self.appleClicked()
            }
            
            CommonClass.googleEventTrcking("settings_screen", action: "manage_social_accounts", label: "apple_toggle_on") //GA
        } else {
            let param = [
                "id"             : AppDelegate.instance.userInfo.uuid,
                "socialProvider" : "apple"
            ]
            
            self.unlinkSocial(param)
            
            CommonClass.googleEventTrcking("settings_screen", action: "manage_social_accounts", label: "apple_toggle_off") //GA
        }
    }
    
    func enableFacebook(_ status: Bool) {
        if status {
            fbImageView.image =  #imageLiteral(resourceName: "facebook-color")
            fbLabel.textColor = UIColor(hex: "212b36")
        } else {
            fbImageView.image =  #imageLiteral(resourceName: "facebook-dull")
            fbLabel.textColor = UIColor(hex: "8894a2")
        }
    }
    
    func enableGoogle(_ status: Bool) {
        if status {
            googleImageView.image =  #imageLiteral(resourceName: "google-color")
            googleLabel.textColor = UIColor(hex: "212b36")
        } else {
            googleImageView.image =  #imageLiteral(resourceName: "google-dull")
            googleLabel.textColor = UIColor(hex: "8894a2")
        }
    }
    
    func enableApple(_ status: Bool) {
        if status {
            appleImageView.image =  #imageLiteral(resourceName: "apple-color")
            appleLabel.textColor = UIColor(hex: "212b36")
        } else {
            // appleImageView.image = #imageLiteral(resourceName: "apple-dull")
            appleLabel.textColor = UIColor(hex: "8894a2")
        }
    }
    
    func unlinkSocial(_ param: JSONDICT) {
        
        MIActivityLoader.showLoader()
        MIApiManager.unlinkSocial(param) { (result, error) in
            defer { MIActivityLoader.hideLoader() }
            guard let res = result else {
                self.managePreferences()
                return
            }
            
            
            self.showAlert(title: nil, message: res.successMessage,isErrorOccured:false)
            
            let socialProvider = param["socialProvider"] as! String
            
            if let index = AppDelegate.instance.userInfo.socialProviders.firstIndex(of: socialProvider) {
                AppDelegate.instance.userInfo.socialProviders.remove(at: index)
            }
            
            FBSDKAccessToken.setCurrent(nil)
            GIDSignIn.sharedInstance()?.signOut()
        }
        
    }
    
    
    func linkSocial(_ param: JSONDICT) {
        
        MIActivityLoader.showLoader()
        MIApiManager.linkSocial(param) { (result, error) in
            defer { MIActivityLoader.hideLoader() }
            guard let res = result else {
                self.managePreferences()
                return
            }
            
            self.showAlert(title: nil, message: res.successMessage,isErrorOccured:false)
            
            AppDelegate.instance.userInfo.socialProviders.append(param["socialProvider"] as! String)
            self.managePreferences()
        }
        
    }
    
}


extension MIManageSocialVC: GIDSignInDelegate, GIDSignInUIDelegate {
    
    func authenticateFacebook() {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
            if let token = FBSDKAccessToken.current()?.tokenString {
                let param = [
                    "socialAccessToken" : token,
                    "socialProvider"    : "facebook"
                ]
                self.linkSocial(param)
            } else {
                self.managePreferences()
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            guard let token = user?.authentication.idToken else { return }
            let param = [
                "socialAccessToken" : token,
                "socialProvider"    : "google"
            ]
            self.linkSocial(param)
            
        } else {
            self.managePreferences()
        }
    }
    
}

@available(iOS 13.0, *)
extension MIManageSocialVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
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
        self.managePreferences()
    }
    
    // ASAuthorizationControllerDelegate function for successful authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard
                let code = appleIDCredential.authorizationCode,
                let token = String(data: code, encoding: .utf8) else {
                    self.managePreferences()
                    return
            }
            
            MIApiManager.appleLoginRefreshTokenAPI(token) { (result, error) in
                guard let data = result else {
                    self.managePreferences()
                    return
                }
                
                let param = [
                    "socialAccessToken" : data.refreshToken,
                    "socialProvider"    : "apple"
                ]
                self.linkSocial(param)
            }
            
            
            //Navigate to other view controller
        } else {
            self.managePreferences()
        }
        
    }
    
}
