//
//  MIDeactivateAccountViewController.swift
//  MonsteriOS
//
//  Created by Anushka on 09/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIDeactivateAccountViewController: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var lblDeactivateTillLogIn: UILabel!
    @IBOutlet weak var lblONDeactivating: UILabel!
    @IBOutlet weak var lblDeactivatingMyAccount: UILabel!
    @IBOutlet weak var btnDeactivateLogout: UIButton!

    //MARk:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetUp()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

    }
    
    func initialSetUp() {
        self.title = ControllerTitleConstant.deactivate
        
        self.lblDeactivateTillLogIn.text! = DeactivateAccount.deactivateTillLogin
        self.lblONDeactivating.text! = DeactivateAccount.onDeactivating
        self.lblDeactivatingMyAccount.text! = DeactivateAccount.deactivatingMyAccount
        
        self.btnDeactivateLogout.layer.cornerRadius = 4.0
        self.btnDeactivateLogout.layer.masksToBounds = false
        self.btnDeactivateLogout.backgroundColor = AppTheme.defaultGreenColor
    }
    
    //MARK:- IBAction
    @IBAction func btnDeactivateLogoutPressed(_ sender: UIButton){
            self.deactivateApi()
    }

}

//MARK:- API
extension MIDeactivateAccountViewController {
    
    func deactivateApi() {
        MIApiManager.hitDeativateUserAPI { (success, response, error, code) in
            
            DispatchQueue.main.async {
                if let responseData = response as? JSONDICT {
                   
                    if let successMessage = responseData["successMessage"] as? String {
                        self.toastView(messsage: successMessage,isErrorOccured:false)
                        
                      
                        //delete data from user defaults
                        CommonClass.deleteUserLogs()
 
                        self.logoutApi()
                        
                    } else if let errorMessage = responseData["errorMessage"] as? String {
                        self.toastView(messsage: errorMessage)
                    }
                } else {
                    if (!MIReachability.isConnectedToNetwork()){
                        self.toastView(messsage: ExtraResponse.noInternet)
                    }
                }
   
            }
        }
        
    }
    
    
    func logoutApi() {
        
        let _ = MIAPIClient.sharedClient.load(path: APIPath.logout, method: .get, params: [:], completion: { (response, error,code) in
            
            DispatchQueue.main.async {

                
                CommonClass.deleteUserLogs()
                AppUserDefaults.removeValue(forKey: .UserData)
                canCallCardAPI = true
                
                let rootVc = MISplashViewController()
                let nav = MINavigationViewController(rootViewController: rootVc)
                if let landVc=rootVc.landingNavigation.viewControllers.first as? MILandingViewController{
                    landVc.navigationItem.title = ""
                    landVc.applyLoginFlag=true
                }
                AppDelegate.instance.window?.rootViewController = nav
                AppDelegate.instance.window?.makeKeyAndVisible()
                
            }
        })
        
    }
    
    
}

