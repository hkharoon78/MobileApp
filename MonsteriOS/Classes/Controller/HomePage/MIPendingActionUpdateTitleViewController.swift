//
//  MIPendingActionUpdateTitleViewController.swift
//  MonsteriOS
//
//  Created by Piyush on 25/04/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIPendingActionUpdateTitleViewController: MIBaseViewController,UITextFieldDelegate {

    @IBOutlet weak private var txtField: UITextField!
    @IBOutlet weak private var addBtn: UIButton!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }

    func setUI() {
        self.addBtn.showPrimaryBtn()
    }
    
    // MARK: Action
    @IBAction func addClicked(_ sender: UIButton) {
        self.callUpdateProfileTitleApi()
    }
    
    func callUpdateProfileTitleApi() {
        let profileTitle = txtField.text
        if !(profileTitle?.isEmpty)! {
            self.startActivityIndicator()
            MIApiManager.updateProfileTitleAPI(profileTitle: "Testing") { (isSuccess, response, error, code) in
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    if isSuccess {
                        print("updated Successfully")
                        shouldRunProfileApi = true
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } else {
            self.showAlert(title: "", message: "Please enter title")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
