//
//  MIAwardsAchievementVC.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 24/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIAwardsAchievementVC: UIViewController {

    let tableView = UITableView()
    
    private var placeholderArray = [
        "Title",
        "Date Awarded",
        "Description",
    ]
    var textFieldDic = [
        "title"       : "",
        "date"        : "",
        "description" : "",
        "month"   : "",
        "year"     : ""
    ]
    var serverDate = ""
    var data = MIProfileAward(dictionary: [:])


    override func loadView() {
        super.loadView()
        self.view.addSubview(tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints=false
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: self.view.topAnchor),tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CommonClass.googleAnalyticsScreen(self) //GA for screen
        
       // self.title = "Awards & Achievement"
        
        // Do any additional setup after loading the view.
        self.tableView.register(nib: MITextFieldTableViewCell.loadNib(), withCellClass: MITextFieldTableViewCell.self)
        self.tableView.register(nib: MITextViewTableViewCell.loadNib(), withCellClass: MITextViewTableViewCell.self)
        self.tableView.register(nib: MICheckboxTableCell.loadNib(), withCellClass: MICheckboxTableCell.self)

        tableView.delegate=self
        tableView.dataSource=self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.tableFooterView=UIView(frame: .zero)
        tableView.tableFooterView?.backgroundColor=UIColor.colorWith(r: 244, g: 246, b: 248, a: 1)
        
        
        self.textFieldDic["title"] = self.data?.title
        self.textFieldDic["description"] = self.data?.ttlDescription
        self.textFieldDic["date"]       = self.data?.date
        
        var month = ""
        var year  = ""
        if let date = self.data?.date.dateWith(PersonalTitleConstant.dateFormatePattern)?.getStringWithFormat(format: "MM yyyy"),date.count > 3 {
            let data = date.components(separatedBy: " ")
            if data.count > 1 {
                month = data.first ?? ""
                year  = data.last  ?? ""
            }
            
        }
        self.textFieldDic["month"] = month
        self.textFieldDic["year"]  = year
        
        
        self.tableView.keyboardDismissMode = .onDrag
        
//       // let edit = (self.data?.id == "") ?
//
//        let cell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? MITextViewTableViewCell
//        if self.data?.id != "" {
//            cell?.frame.size.height = 80
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Awards & Achievement"
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }
    
    
    
}

extension MIAwardsAchievementVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.placeholderArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case self.placeholderArray.count:
            let cell = tableView.dequeueReusableCell(withClass: MICheckboxTableCell.self, for: indexPath)
           
            cell.checkboxButtn.isHidden = true
            cell.saveButton.addTarget(self, action: #selector(btnSavePressed(_:)), for: .touchUpInside)
            
            if self.data?.id == "" {
                cell.saveButton.setTitle("Save", for: .normal)
            } else {
                cell.saveButton.setTitle("Update", for: .normal)
            }
            
            return cell

        default:
             let cell = tableView.dequeueReusableCell(withClass: MITextFieldTableViewCell.self, for: indexPath)
             
             cell.secondryTextField.delegate = self
             cell.primaryTextField.delegate = self
             
             cell.primaryTextField.tag = indexPath.row
             cell.secondryTextField.isHidden = true
            
            switch indexPath.row {
            case 0:
                cell.primaryTextField.text = self.textFieldDic["title"]
                cell.primaryTextField.returnKeyType = .default
                cell.primaryTextField.setRightViewForTextField()
                cell.primaryTextField.placeholder =  "Title"// self.placeholderArray[indexPath.row]
                 cell.titleLabel.text = "Title"
            case 1:
                //
                
                cell.makeEqualTextFields()
                cell.secondryTextField.isHidden = false
               
                cell.secondryTextField.placeholder = "Month"
                cell.primaryTextField.placeholder = "Year"
                
                cell.secondryTextField.text = self.textFieldDic["month"]
                cell.primaryTextField.text = self.textFieldDic["year"]
               
                cell.primaryTextField.setRightViewForTextField("calendarBlue")
                cell.secondryTextField.setRightViewForTextField("calendarBlue")
                
                cell.titleLabel.text = "Date Awarded"
            default:
                let cell = tableView.dequeueReusableCell(withClass: MITextViewTableViewCell.self, for: indexPath)
                cell.textView.isScrollEnabled = true
                cell.textViewHC.constant = 80
                            
                cell.accessoryImageView.isHidden = true 
                cell.textView.delegate = self
                cell.titleLabel.text = "Description"
                cell.textView.placeholder = "Description"
                cell.textView.text =  self.textFieldDic["description"]
                cell.selectionStyle = .none
                
//                if self.data?.id != "" {
//                    cell.frame.size.height = 80
//                }

                return  cell

            }
            
            return cell

        }
    }
    
    @objc func btnSavePressed(_ sender: UIButton){
        self.view.endEditing(true)
        if validation() {
            self.awardAchievement()
        }
    }
    
    
}

//MARK:- uitextfield delegate
extension MIAwardsAchievementVC: UITextFieldDelegate {
   
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    
        if let index = textField.tableViewIndexPath(self.tableView) {
          
            switch index.row {
            case 1:
                
                guard let cell = textField.tableViewCell() as? MITextFieldTableViewCell else { return true }
                
                let staticMasterVC = MIStaticMasterDataViewController.newInstance
                staticMasterVC.title = "Start Date"
                staticMasterVC.selectedDataArray = [textField.text!]
                
                if cell.secondryTextField == textField {
                    staticMasterVC.staticMasterType = .TILL_MONTH
                } else {
                    staticMasterVC.staticMasterType = .TILL_YEAR
                }
                
                staticMasterVC.selectedData = { value in
                    if cell.secondryTextField == textField {
                        cell.secondryTextField.text = value
                        self.textFieldDic["month"] = textField.text
                        
                        if !value.isEmpty {
                            cell.showErrorOnSecondryTF(with: "")
                        }
                    } else {
                        cell.primaryTextField.text = value
                        self.textFieldDic["year"] = textField.text
                        if !value.isEmpty {
                            cell.showError(with: "")
                        }
                    }
                    
                    let year = cell.primaryTextField.text! + "-"
                    let month = cell.secondryTextField.text! + "-01"
                    self.textFieldDic["date"] = year + month
                    
                    //self.projectInfo?.startDate = cell.yearTF.text! + "-" + cell.monthTF.text! + "-01"
                }
                
                self.navigationController?.pushViewController(staticMasterVC, animated: true)
                return false

            default: break
            }
        }
        return true
    }
   
    func textFieldDidBeginEditing(_ textField: UITextField) {}
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       
        guard let index = textField.tableViewIndexPath(self.tableView) else {
            return
        }
        let cell = textField.tableViewCell() as! MITextFieldTableViewCell
        
        switch index.row {
        case 0:
            self.textFieldDic["title"] = textField.text
        case 1:
            if cell.secondryTextField == textField {
                self.textFieldDic["month"] = textField.text
            } else {
                self.textFieldDic["year"] = textField.text
            }
            //self.textFieldDic["date"] = cell?.primaryTextField.text + "-" + cell?.secondryTextField.text + "-01"
            let year = cell.primaryTextField.text! + "-"
            let month = cell.secondryTextField.text! + "-01"
            self.textFieldDic["date"] = year + month
            
        default:
            break
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField.returnKeyType {
        case .default:
            self.view.endEditing(true)
        case .next:
            self.view.viewWithTag(textField.tag+1)?.becomeFirstResponder()
        case .done:
            if self.validation() { self.awardAchievement() }
        default:
            break
        }
        return true
        
    }
    
}

//MARK:- UItextfield delegate
extension MIAwardsAchievementVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let cell = textView.tableViewCell() as? MITextViewTableViewCell else { return false }
        guard cell.textView == textView else { return false }
        
       // guard let cell = textView.tableViewCell() as? MIFloatingTextViewTableViewCell else { return false }
        //guard cell.floatingTextView == textView else { return false }
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        self.textFieldDic["description"] = newText

        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let cell = textView.tableViewCell()  else { return }
        
        textView.isScrollEnabled = false

        let newHeight = cell.frame.size.height + textView.contentSize.height
        
//        if newHeight < 80 {
//            cell.frame.size.height = 80
//            updateTableViewContentOffsetForTextView()
//        } else {
//           textView.isScrollEnabled = true
//        }
        
        if textView.contentSize.height < 80 {
            cell.frame.size.height = newHeight
            updateTableViewContentOffsetForTextView()
        } else {
            textView.isScrollEnabled = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            textView.isScrollEnabled = true
        }
    }
    // Animate cell, the cell frame will follow textView content
    func updateTableViewContentOffsetForTextView() {
        let currentOffset = tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        tableView.setContentOffset(currentOffset, animated: false)
    }
}


//MARk:- API and Validations
extension MIAwardsAchievementVC {

    
    func validation() -> Bool {
        self.view.endEditing(true)
        
        
        if (self.textFieldDic["title"]?.isBlank)! {
            let index = IndexPath(row: 0, section: 0)
            let cell = tableView.cellForRow(at: index) as? MITextFieldTableViewCell
            cell?.showError(with: AwardAchievement.title)
            //self.toastView(messsage: AwardAchievement.title)
            return false
        }
        
        if (self.textFieldDic["month"]?.isBlank)! {
            let index = IndexPath(row: 1, section: 0)
            let cell = tableView.cellForRow(at: index) as? MITextFieldTableViewCell
            cell?.showErrorOnSecondryTF(with: "Please enter month")
            // self.toastView(messsage: AwardAchievement.date)
            return false
        }
        
        if (self.textFieldDic["year"]?.isBlank)! {
            let index = IndexPath(row: 1, section: 0)
            let cell = tableView.cellForRow(at: index) as? MITextFieldTableViewCell
            cell?.showError(with: "Please enter year")
            // self.toastView(messsage: AwardAchievement.date)
            return false
        }


        if (self.textFieldDic["description"]?.isBlank)! {
            let index = IndexPath(row: 2, section: 0)
            let cell = tableView.cellForRow(at: index) as? MITextViewTableViewCell
            cell?.showError(with: AwardAchievement.description)
           // self.toastView(messsage: AwardAchievement.description)
            return false
        }
        
        return true
        
    }
    
    
    func awardAchievement() {
        
        let method: ServiceMethod = (self.data?.id == "") ? .post : .put
        let id = (self.data?.id)!
        
//        if self.serverDate.isEmpty {
//            self.serverDate = self.textFieldDic["date"]
//        } else {
//            self.serverDate = self.textFieldDic["date"]
//        }
        
        MIApiManager.hitAwardAchievementAPI(method, id: id,  title: self.textFieldDic["title"]!, date: self.textFieldDic["date"]!, description: self.textFieldDic["description"]!) { (success, response, error, code) in
            
            DispatchQueue.main.async {
                shouldRunProfileApi = true
                if let responseData = response as? JSONDICT {
                    
                    if let successMessage = responseData["successMessage"] as? String {
                      //  self.toastView(messsage: successMessage,isErrorOccured:false)
                        self.navigationController?.popViewController(animated: true)
//                        self.toastView(messsage: successMessage, isErrorOccured: false) {
//                            self.navigationController?.popViewController(animated: true)
//                        }
                        
                    } else if let errorMessage = responseData["errorMessage"] as? String {
                        self.toastView(messsage: errorMessage)
                    }else{
                        if let err = error {
                            self.handleAPIError(errorParams: response, error: err)
                        }
                    }
                }
                
            }
        }
        
    }
    
}
