//
//  MIFeedbackViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 04/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import DropDown

class MIFeedbackViewController: MIBaseViewController {
    
    //MARK:Variables and Outlet
    @IBOutlet weak var tableView: UITableView!
    
    let dropDown = DropDown()
    var error: (message: String, index: Int) = ("", -1)
    var dic = [
        "category"     : "",
        "name"         : "",
        "email"        : "",
        "mobileNumber" : "",
        "details"      : ""
    ]
    
    //MARK:View Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
 
        
        self.configDropDown()
        self.configureDropDown(dropDown: dropDown)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //Register TableView Cell
        self.tableView.register(UINib(nibName:String(describing: MITextFieldTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MITextFieldTableViewCell.self))
        self.tableView.register(UINib(nibName:String(describing: MITextViewTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MITextViewTableViewCell.self))
        self.tableView.register(UINib(nibName:String(describing: MIManageSubsNotificationDesTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MIManageSubsNotificationDesTableViewCell.self))
        self.tableView.register(UINib(nibName:String(describing: MIBlockCompaniesCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MIBlockCompaniesCell.self))
        
        self.dic["name"] = AppDelegate.instance.userInfo.fullName
        self.dic["mobileNumber"] = AppDelegate.instance.userInfo.mobileNumber
        self.dic["email"] = AppDelegate.instance.userInfo.primaryEmail
       
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.separatorStyle = .none
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CommonClass.googleAnalyticsScreen(self) //GA for screen
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

        self.navigationItem.title = MoreOptionViewModelItemType.feedback.value
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }


    //MARK:Configure DropDown Method
    func configDropDown(){
        var dataSource=[String]()
      
        let issueArr = ["Problem with the App", "Request Information", "General Feedback", "Report Abuse", "Report Fake Job Offer"]
        
        for data in issueArr {
            dataSource.append(data)
        }
        
        dropDown.dataSource=dataSource
        dropDown.selectionAction = {  (index: Int, item: String) in
            
            let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MITextFieldTableViewCell
            cell?.primaryTextField.text = item
            self.dic["category"] = item
            self.error = ("", -1)
            self.tableView.reloadData()
            
//            if let dropTextField = cell?.primaryTextField.filter({$0.tag==0}).first {
//                dropTextField.text = item
//                dropTextField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//               // self.lblSelectReport.text = ""
//                self.dic["category"] = item
//            }
        }
        
        dropDown.cellConfiguration = {(_, item) in
            return "\(item)"
        }
    }
    
}

//MARK:- API and Validation
extension MIFeedbackViewController {
    
    func callReportABugAPI() {
        MIActivityLoader.showLoader()
        
        MIApiManager.hitReportBug(dic["category"]!, name: dic["name"]!, email: dic["email"]!, mobileNumber: dic["mobileNumber"]!, details: dic["details"]!) { (success, response, error, code) in
            
            DispatchQueue.main.async {
                MIActivityLoader.hideLoader()
                
                if let responseData = response as? JSONDICT {
                    if let successMessage = responseData["successMessage"] as? String {
                
                        CommonClass.googleEventTrcking("more_screen", action: "feedback", label: "submit") //GA
                        self.toastView(messsage: successMessage, isErrorOccured: false) {
                            self.navigationController?.popViewController(animated: true)

                        }
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

//MARK:TextField Delegate Methods
extension MIFeedbackViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField.returnKeyType {
        case .default:
            self.view.endEditing(true)
        case .next:
            self.view.viewWithTag(textField.tag+1)?.becomeFirstResponder()
        case .done:
            if self.validation() { self.callReportABugAPI() }
        default:
            break
        }
    
        return true
        
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField.tag == 0 {
            self.view.endEditing(true)
            
            textField.rightViewMode = .always
            
            self.dropDown.anchorView = textField
            self.dropDown.bottomOffset = CGPoint(x: 0, y:((self.dropDown.anchorView?.plainView.bounds.height)!))
            self.dropDown.topOffset = CGPoint(x: 0, y:-((self.dropDown.anchorView?.plainView.bounds.height)!))
            
            self.dropDown.show()
            return false
        }
        return true
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        switch textField.tag {
        case 0:
            dic["category"] = textField.text!
        case 1:
            dic["name"] = textField.text!
        case 2:
            dic["mobileNumber"] = textField.text!
        case 3:
            dic["email"] = textField.text!
        default :
            break
        }
        
    }
    
    
}

//MARK:TextView Delegate Methods
extension MIFeedbackViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {

        DispatchQueue.main.async {

            self.setMainViewFrame(originY: 0)
            let movingHeight = textView.movingHeightIn(view : self.view) + 10
            if movingHeight > 0 {
                UIView.animate(withDuration: 0.3) {
                    self.setMainViewFrame(originY: -movingHeight)
                }
            }
        }

        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        textView.spellCheckingType = .no
        textView.keyboardType = .asciiCapable

    }

    func textViewDidEndEditing(_ textView: UITextView) {
        self.dic["details"] = textView.text

        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {
                self.setMainViewFrame(originY: 0)
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let cell = textView.tableViewCell() as? MITextViewTableViewCell else { return false }
        guard cell.textView == textView else { return false }
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        self.dic["details"] = newText
        
        return true
        
    }
    
//    func textViewDidChange(_ textView: UITextView) {
//        guard let cell = textView.tableViewCell()  else { return }
//        textView.isScrollEnabled = false
//        
//        let newHeight = cell.frame.size.height + textView.contentSize.height
//     
//        if textView.contentSize.height < 80 {
//            cell.frame.size.height = newHeight
//            updateTableViewContentOffsetForTextView()
//        } else {
//            textView.isScrollEnabled = true
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            textView.isScrollEnabled = true
//        }
//        
//        textView.layoutIfNeeded()
//        if textView.frame.size.height >= 80 {
//            return
//        }
//        
//    }
//    
//    // Animate cell, the cell frame will follow textView content
//    func updateTableViewContentOffsetForTextView() {
//        let currentOffset = tableView.contentOffset
//        UIView.setAnimationsEnabled(false)
//        tableView.beginUpdates()
//        tableView.endUpdates()
//        UIView.setAnimationsEnabled(true)
//        tableView.setContentOffset(currentOffset, animated: false)
//    }
    
//    func textViewDidChange(_ textView: UITextView) {
//        let fixedWidth = textView.frame.size.width
//        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
//        textView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
//    }

    
}


extension MIFeedbackViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0, 1, 2, 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MITextFieldTableViewCell.self)) as? MITextFieldTableViewCell else {
                return UITableViewCell()
            }
            
            let arr = ["Type of issue", "Name", "Contact No.", "Email"]
            
            cell.primaryTextField.delegate = self
            cell.primaryTextField.placeholder = arr[indexPath.row]
            cell.primaryTextField.tag = indexPath.row
            cell.primaryTextField.setRightViewForTextField()
            cell.titleLabel.text = arr[indexPath.row]
            cell.secondryTextField.isHidden = true
            
            //set prefilled data
            switch indexPath.row {
            case 0:
                cell.primaryTextField.setRightViewForTextField("bottom_direction_arrow")
                cell.primaryTextField.text = self.dic["category"]
            case 1:
                cell.primaryTextField.text = self.dic["name"]
                cell.primaryTextField.keyboardType = .default
                cell.primaryTextField.returnKeyType = .next
            case 2:
                cell.primaryTextField.text = self.dic["mobileNumber"]
                cell.primaryTextField.keyboardType = .phonePad
                cell.primaryTextField.returnKeyType = .next
            case 3:
                cell.primaryTextField.text = self.dic["email"]
                cell.primaryTextField.returnKeyType = .default
                cell.primaryTextField.keyboardType = .emailAddress
            default:
                break
            }
            
            if self.error.index == indexPath.row {
                cell.showError(with: self.error.message, animated: false)
            } else {
                cell.showError(with: "", animated: false)
            }
            
            return cell
        case 4, 6:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MIManageSubsNotificationDesTableViewCell.self)) as? MIManageSubsNotificationDesTableViewCell else {
                return UITableViewCell()
            }
            cell.topConstraint.constant = 0
            cell.lblNotificationDes.textColor = UIColor("8894a2")

            switch indexPath.row {
            case 4:
                cell.lblNotificationDes.text = FeedbackStoryBoardConstant.emailValidationText
            case 6:
                cell.lblNotificationDes.text = FeedbackStoryBoardConstant.detailsLabelText
            default:
                break
            }
            
            return cell
        case 5:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MITextViewTableViewCell.self)) as? MITextViewTableViewCell else {
                return UITableViewCell()
            }
            cell.textView.isScrollEnabled = true
            cell.tvContainerViewHtConstraint.constant = 80
            
            cell.textView.placeholder = "Description of Issue"
            cell.textView.delegate = self
            cell.selectionStyle = .none
            cell.titleLabel.text = "Description of Issue"
            cell.accessoryImageView.isHidden = true
            //cell.textView.isScrollEnabled = false
            //cell.textView.returnKeyType = .done
            
            if self.error.index == indexPath.row {
                cell.showError(with: self.error.message, animated: false)
            } else {
                cell.showError(with: "", animated: false)
            }
            
            return cell
            
        default :
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MIBlockCompaniesCell.self)) as? MIBlockCompaniesCell else {
                return UITableViewCell()
            }
            cell.blockButton.setTitle("Submit", for: .normal)
            
            cell.selectionStyle = .none
            cell.blockButton.addTarget(self, action: #selector(submitBtnPressed(_:)), for: .touchUpInside)
            return cell
        }
        
    }

    
    @objc func submitBtnPressed(_ sender: UIButton){
        if self.validation() { self.callReportABugAPI() }
    }

    
}


extension MIFeedbackViewController {
    
    func showErrorOnTableViewIndex(indexPath: IndexPath, errorMsg:String) {
        self.error = (errorMsg, indexPath.row)
        if indexPath.row > -1 {
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(row: indexPath.row, section: 0), at: .top, animated: false)
        }
        
    }
    
    func validation() -> Bool {
        self.view.endEditing(true)
        self.error = ("", -1)

        if dic["category"]!.isBlank {
             let indexPath = IndexPath(row: 0, section: 0)
             self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: FeedbackSetting.selectIssue)
            return false
        }
        
        if dic["name"]!.count < 3 {
            let indexPath = IndexPath(row: 1, section: 0)
            self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: FeedbackSetting.nameFeedBack)
            return false
        }
        
        if !(dic["name"]!.isValidName) {
            let indexPath = IndexPath(row: 1, section: 0)
            self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: FeedbackSetting.nameValidFeedBack)
            return false
        }
        
        if !((dic["mobileNumber"]?.isNumeric)!) {
            let indexPath = IndexPath(row: 2, section: 0)
            self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: FeedbackSetting.phoneFeedback)
            return false
        }
        
        if (dic["mobileNumber"]?.count)! < 6 || (dic["mobileNumber"]?.count)! > 15 {
            let indexPath = IndexPath(row: 2, section: 0)
            self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: FeedbackSetting.phoneValidFeedback)
            return false
        }
        
        if dic["email"]!.isBlank {
            let indexPath = IndexPath(row: 3, section: 0)
            self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: FeedbackSetting.emailFeedback)
            return false
        }
        
        if !(dic["email"]!.isValidEmail) {
            let indexPath = IndexPath(row: 3, section: 0)
            self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: FeedbackSetting.emailValidFeedback)
            return false
        }
        
        if (dic["details"]!.isBlank) {
            let indexPath = IndexPath(row: 5, section: 0)
            self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: FeedbackSetting.detailsFeedback)
            return false
        }
        
       return true

    }
    
}

