//
//  MIVerifyEmailTemplateViewController.swift
//  MonsteriOS
//
//  Created by Rakesh on 22/04/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIVerifyEmailTemplateViewController: UIViewController {

    var userEmail:String?
    var emailSendSuccess : ((Bool)->Void)?

    @IBOutlet var email_lbl:UILabel!
    @IBOutlet var resendBtn:UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        email_lbl.text = userEmail
        email_lbl.textColor = AppTheme.defaltBlueColor
        resendBtn.setTitleColor(AppTheme.defaltBlueColor, for: .normal)

        self.callAPIForSentMail(calledViaResend: false)
        self.title = "Verify"
      //  Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(backToProfile(_:)), userInfo: nil, repeats: false)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

    }
    //IBAction Methods
    @IBAction func resendEmailAction(_ sender : UIButton) {
        self.callAPIForSentMail(calledViaResend: true)
    }

    //APIHelper Methods
    func callAPIForSentMail(calledViaResend:Bool){
            MIApiManager.callAPIForSendMailForVerify { (success, response, error, code) in
                DispatchQueue.main.async {
                    if (code >= 200) && (code <= 299) {
                        if calledViaResend {
                            self.showAlert(title: "", message: "We have sent new verification mail on your email.",isErrorOccured:false)
                        }
                        if let callBack = self.emailSendSuccess {
                            callBack(true)
                            self.navigationController?.popViewController(animated: true)
                        }
                        shouldRunProfileApi = true
                    }else{
                        self.handleAPIError(errorParams: response, error: error)
                    }
                }
                
            
            }
    }
    
    @objc func backToProfile(_ timer:Timer) {
        if let tabbar = self.tabBarController as? MIHomeTabbarViewController {
            tabbar.selectedIndex = 2
            if let profileNav = tabbar.viewControllers?[2] as? UINavigationController {
                profileNav.popToRootViewController(animated: true)
            }
        }
    }
}
