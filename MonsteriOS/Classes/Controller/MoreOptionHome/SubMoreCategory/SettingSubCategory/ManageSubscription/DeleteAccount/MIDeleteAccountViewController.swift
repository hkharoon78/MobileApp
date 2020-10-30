//
//  MIDeleteAccountViewController.swift
//  MonsteriOS
//
//  Created by Anushka on 04/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIDeleteAccountViewController: UIViewController {
    
    @IBOutlet weak var tableViewDeleteAccount: UITableView!
    
    var arr = ["I am getting too many phone calls from recruiters.", "I am not receiving relevant jobs.", "I am getting too many emails.", "Found a new job.", "I have a duplicate account.", "Other"]
  
    var selectedIndex: Int?
    var reason = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewDeleteAccount.delegate = self
        self.tableViewDeleteAccount.dataSource = self

        self.title = ControllerTitleConstant.deleteAccount
        
        self.tableViewDeleteAccount.register(UINib(nibName: "MIUserMsgDeleteAccountTableViewCell", bundle: nil), forCellReuseIdentifier: "MIUserMsgDeleteAccountTableViewCell")
        
        self.tableViewDeleteAccount.register(UINib(nibName: "MIDeleteAccountTellUsTableViewCell", bundle: nil), forCellReuseIdentifier: "MIDeleteAccountTellUsTableViewCell")
        
        self.tableViewDeleteAccount.register(UINib(nibName: "MIDeleteAccountTableViewCell", bundle: nil), forCellReuseIdentifier: "MIDeleteAccountTableViewCell")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

    }


}


//MARK:- table view delegate and data source
extension MIDeleteAccountViewController: UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return self.arr.count
        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MIUserMsgDeleteAccountTableViewCell") as! MIUserMsgDeleteAccountTableViewCell
            
            let name = AppDelegate.instance.userInfo.fullName
            if !name.isEmpty {
                cell.lblUserMsgDeleteAccount.text = name + ", sure you want to leave?"
            } else {
                cell.lblUserMsgDeleteAccount.text =  "Are you sure want to leave?"
            }
            
            return cell

        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MIDeleteAccountTellUsTableViewCell") as! MIDeleteAccountTellUsTableViewCell
 
            cell.txtViewOther.delegate = self
            cell.lblTellUs.text! = arr[indexPath.row]
            cell.btnTellUs.isSelected = (self.selectedIndex == indexPath.row)

            if cell.lblTellUs.text! == "Other" && cell.btnTellUs.isSelected {
                cell.txtViewOther.isHidden = false
                cell.viewtxtViewUnderLine.isHidden = false
               cell.txtViewHeightConstraint.constant = 50.0
            } else {
                cell.txtViewOther.isHidden = true
                cell.viewtxtViewUnderLine.isHidden = true
                cell.txtViewHeightConstraint.constant = 0
            }
            
            return cell

        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MIDeleteAccountTableViewCell") as! MIDeleteAccountTableViewCell
            cell.btnDeleteAccount.addTarget(self, action: #selector(btnDeleteAccountPressed(_:)), for: .touchUpInside)
            return cell

        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        guard indexPath.section == 1 else { return }
        
        self.selectedIndex = indexPath.row
        tableView.reloadData()
        
        switch indexPath.section {
        case 1:
            
            let cell = tableView.cellForRow(at: indexPath) as! MIDeleteAccountTellUsTableViewCell
           // self.reason = cell.lblTellUs.text ?? ""
            
            if cell.lblTellUs.text! == "Other" && cell.btnTellUs.isSelected {
                self.reason = cell.txtViewOther.text
            } else {
                self.reason = cell.lblTellUs.text ?? ""
            }
            
        default:
            break
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.reason = textView.text
    }

    @objc func btnDeleteAccountPressed(_ sender: UIButton){
        
        self.view.endEditing(true)

        guard self.reason != "" else { self.toastView(messsage: "Kindly give the reason, Why are you want to delete account?")
            return
        }
       
        //self.deleteUserAccount(self.reason)
        print("call delete account api")
        
    }
    


}


extension MIDeleteAccountViewController {
    
    func deleteUserAccount(_ reason: String) {
        
        MIApiManager.hitDeleteAccountAPI(reason) { (success, response, error, code) in
          
            DispatchQueue.main.async {
                MIActivityLoader.hideLoader()
                
                if let responseData = response as? JSONDICT {
                    
                    if let successMessage = responseData["successMessage"] as? String {
                        self.toastView(messsage: successMessage,isErrorOccured:false)
                        
                        CommonClass.deleteUserLogs()
                        AppUserDefaults.removeValue(forKey: .UserData)
                        canCallCardAPI = true
                        let rootVc = MISplashViewController()
                        let nav = MINavigationViewController(rootViewController: rootVc)
                        AppDelegate.instance.window?.rootViewController = nav
                        AppDelegate.instance.window?.makeKeyAndVisible()

                        
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
    
    
}
