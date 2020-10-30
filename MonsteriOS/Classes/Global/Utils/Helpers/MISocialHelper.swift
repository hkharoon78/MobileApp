//
//  MISocialHelper.swift
//  MonsteriOS
//
//  Created by Rakesh on 15/07/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn

class MISocialHelper: NSObject {

    static var socialShareInstance = MISocialHelper()
    var token  = ""
    var userAccountType = AccountTypeVia.Manual
    var socialCallBack : ([String:Any]?,Error?) -> () = { result,error  in }
    
    private override init() {
        super.init()
//        GIDSignIn.sharedInstance()?.delegate = self
//        GIDSignIn.sharedInstance()?.clientID = kGmailClientId
        func callBack(_:[String:Any]?,_:Error?) {}
        self.socialCallBack = callBack

    }
    
    class func getFacebookUserProfile(vc:UIViewController) {
        if((FBSDKAccessToken.current()) != nil){

            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, link, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    //   print(result ?? "")
                    if var data = result as? [String:Any] {
                        guard let token = FBSDKAccessToken.current()?.tokenString  else { return }
                        
                        data["token"] = token
                        
                        self.socialShareInstance.socialCallBack(data,nil)
                    }
                }else{
                    self.socialShareInstance.socialCallBack(nil,error)

                }
            })
        } else {
            
            MIActivityLoader.showLoader()
            let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
         //   fbLoginManager.logIn(withReadPermissions: <#T##[Any]!#>, from: <#T##UIViewController!#>, handler: <#T##FBSDKLoginManagerRequestTokenHandler!##FBSDKLoginManagerRequestTokenHandler!##(FBSDKLoginManagerLoginResult?, Error?) -> Void#>)
            fbLoginManager.logIn(withReadPermissions: ["email"], from: vc) { (result, error) -> Void in
                MIActivityLoader.hideLoader()
                
                if (error == nil){
                    let fbloginresult : FBSDKLoginManagerLoginResult = result!
                    // if user cancel the login
                    if (result?.isCancelled)!{
                        return
                    }
                    if(fbloginresult.grantedPermissions.contains("email")) {
                        self.getFacebookUserProfile(vc: vc)
                    }
                }
            }
        }
    }
    class func getGooglePlusUserProfile() {
        GIDSignIn.sharedInstance()?.signIn()

    }
    
    
}

extension MISocialHelper : GIDSignInDelegate,GIDSignInUIDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        MISocialHelper.socialShareInstance.userAccountType = .Google
        guard let token = user?.authentication.idToken else { return }
        var userName = ""
        
        if let firstName = user.profile.givenName {
            userName = firstName.capitalizedFirstLetter()
        }
        if let lastName = user.profile.familyName {
            userName = userName + " " + lastName.capitalizedFirstLetter()
        }

        self.socialCallBack(["name"  : userName,
                             "email" : user.profile.email,"token":token
            ], error)
    }
    
}
