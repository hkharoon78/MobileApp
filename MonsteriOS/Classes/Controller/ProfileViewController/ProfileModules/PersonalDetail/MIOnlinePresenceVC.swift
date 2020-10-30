//
//  MIOnlinePresenceVC.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 24/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIOnlinePresenceVC: UIViewController {

    let tableView = UITableView()
    var data = MIProfileOnlinePresence(dictionary: [:])
    
    private var placeholderArray = [
        "Profile Name",
        "URL",
        "Description",
        ]
    
    var textFieldDic = [
        "profileName" : "",
        "url"         : "",
        "description" : ""
    ]
    
    override func loadView() {
        super.loadView()
        self.view.addSubview(tableView)
     
        self.tableView.translatesAutoresizingMaskIntoConstraints=false
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: self.view.topAnchor),tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let index = self.placeholderArray.firstIndex(of: "URL"), self.data?.url == "" {
            self.placeholderArray[index] = "e.g. https://www.monsterindia.com"
        }  
        
        self.title = ControllerTitleConstant.onlinePresence
        
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
        self.tableView.keyboardDismissMode = .onDrag
      
        self.textFieldDic["profileName"] = self.data?.title
        self.textFieldDic["url"] = self.data?.url
        self.textFieldDic["description"] = self.data?.ttlDescription
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }
    
}

extension MIOnlinePresenceVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.placeholderArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        switch indexPath.row {
        case self.placeholderArray.count:
            let cell = tableView.dequeueReusableCell(withClass: MICheckboxTableCell.self, for: indexPath)
            
            cell.checkboxButtn.isHidden = true
            cell.saveButton.addTarget(self, action: #selector(btnSaveOnlinePresencePressed(_:)), for: .touchUpInside)
            
            if self.data?.id == "" {
                cell.saveButton.setTitle("Save", for: .normal)
            } else {
                cell.saveButton.setTitle("Update", for: .normal)

            }
            
            return cell
            
        default:
            switch indexPath.row {
            case 0,1:
                let cell = tableView.dequeueReusableCell(withClass: MITextFieldTableViewCell.self, for: indexPath)
                
                cell.primaryTextField.delegate = self
                cell.primaryTextField.placeholder = self.placeholderArray[indexPath.row]
                cell.primaryTextField.tag = indexPath.row
                cell.primaryTextField.setRightViewForTextField()
                cell.titleLabel.text = self.placeholderArray[indexPath.row]
                cell.secondryTextField.isHidden = true
                
                if indexPath.row == 0 {
                    cell.primaryTextField.text = self.textFieldDic["profileName"]
                    cell.primaryTextField.returnKeyType = .next
                } else if indexPath.row == 1 {
                    cell.primaryTextField.text = self.textFieldDic["url"]
                    cell.primaryTextField.returnKeyType = .default
                    cell.titleLabel.text = "URL"
                    cell.primaryTextField.placeholder = "e.g. https://www.monsterindia.com"
                }
                                
                return cell
  
            default:
               
                let cell = tableView.dequeueReusableCell(withClass: MITextViewTableViewCell.self, for: indexPath)
                
                cell.textView.isScrollEnabled = true
                cell.tvContainerViewHtConstraint.constant = 80
                cell.maxCharaterCount = 1000
                
                cell.textView.tag = indexPath.row
                cell.accessoryImageView.isHidden = true
                cell.textView.delegate = self
                cell.titleLabel.text = self.placeholderArray[indexPath.row]
                cell.textView.placeholder = "Description" //self.placeholderArray[indexPath.row] as NSString
                cell.textView.text =  self.textFieldDic["description"]
                cell.selectionStyle = .none
                cell.showCounterLabel = true
            
                return  cell
            }
            
        }
        
    }
    
    @objc func btnSaveOnlinePresencePressed(_ sender: UIButton) {
        self.view.endEditing(true)
       
        if self.validation() {
            self.onlinePresence()
        }
    }
    

    
}

//MARK:- UItextfield delegate
extension MIOnlinePresenceVC: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        
       // let index = textField.tableViewIndexPath(self.tableView)!
        
        switch textField.tag {
        case self.placeholderArray.count:
            break
        case 0:
            self.textFieldDic["profileName"] = textField.text
        case 1:
            self.textFieldDic["url"] = textField.text
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
            if self.validation() { self.onlinePresence() }
        default:
            break
        }
        
        return true
        
    }
    
}


//MARK:- UItextfield delegate
extension MIOnlinePresenceVC: UITextViewDelegate {
    
    //func textviewshould
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
      
        guard let cell = textView.tableViewCell() as? MITextViewTableViewCell else { return false }
        guard cell.textView == textView else { return false }
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        self.textFieldDic["description"] = newText
        
        let numbersOfCharacter = newText.count
                
        return 1000 >= numbersOfCharacter
    }
    
    func textViewDidChange(_ textView: UITextView) {
//        if textView.text.count >= 100 {
//            return
//        }
//        guard let cell = textView.tableViewCell()  else { return }
//        textView.isScrollEnabled = false
//
//        let newHeight = cell.frame.size.height + textView.contentSize.height
//        if textView.contentSize.height < 80 {
//            cell.frame.size.height = newHeight
//            updateTableViewContentOffsetForTextView()
//        } else {
//            textView.isScrollEnabled = true
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
//            textView.isScrollEnabled = true
//        }
//
//        textView.layoutIfNeeded()
//        if textView.frame.size.height >= 80 {
//            return
//        }

    }
//    // Animate cell, the cell frame will follow textView content
//    func updateTableViewContentOffsetForTextView() {
//        let currentOffset = tableView.contentOffset
//        UIView.setAnimationsEnabled(false)
//        tableView.beginUpdates()
//        tableView.endUpdates()
//        UIView.setAnimationsEnabled(true)
//        tableView.setContentOffset(currentOffset, animated: false)
//    }
    
}


//MARK:- API and validations
extension MIOnlinePresenceVC {
    
    func onlinePresence() {
        
        MIActivityLoader.showLoader()
        let method: ServiceMethod = (self.data?.id == "") ? .post : .put
        
        MIApiManager.hitOnLinePresenceAPI(method, id: (self.data?.id)!,  name: self.textFieldDic["profileName"]!, url: self.textFieldDic["url"]!, description: self.textFieldDic["description"]!) { (success, response, error, code) in
          
            DispatchQueue.main.async {
                MIActivityLoader.hideLoader()

                shouldRunProfileApi = true
                if let responseData = response as? JSONDICT {
                    if let successMessage = responseData["successMessage"] as? String {
                        self.navigationController?.popViewController(animated: true)

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
    
    
    func validation() -> Bool {
        self.view.endEditing(true)
        
        if (self.textFieldDic["profileName"]?.isBlank)! {
            let index = IndexPath(row: 0, section: 0)
            let cell = tableView.cellForRow(at: index) as? MITextFieldTableViewCell
            cell?.showError(with: OnlinePresence.profilename)
            //self.toastView(messsage: OnlinePresence.profilename)
            return false
        }
        
        
        let urlLink = self.textFieldDic["url"] ?? ""
        if (self.textFieldDic["url"]?.isBlank)! {
            let index = IndexPath(row: 1, section: 0)
            let cell = tableView.cellForRow(at: index) as? MITextFieldTableViewCell
            cell?.showError(with: OnlinePresence.url)
            //self.toastView(messsage: OnlinePresence.url)
            return false
        }
        
        //let url = (urlLink.hasPrefix("http://") || urlLink.hasPrefix("https://") ) ? urlLink : "http://"+urlLink

        if !urlLink.validateUrl() {
            let index = IndexPath(row: 1, section: 0)
            let cell = tableView.cellForRow(at: index) as? MITextFieldTableViewCell
            cell?.showError(with: OnlinePresence.validurl)
            //self.toastView(messsage: OnlinePresence.validurl)
            return false
        }
        
//        if !url.canOpenURL() {
//            let index = IndexPath(row: 1, section: 0)
//            let cell = tableView.cellForRow(at: index) as? MITextFieldTableViewCell
//            cell?.showError(with: OnlinePresence.validurl)
//            //self.toastView(messsage: OnlinePresence.validurl)
//            return false
//        }
        
        if (self.textFieldDic["description"]?.isBlank)! {
            let index = IndexPath(row: 2, section: 0)
            let cell = tableView.cellForRow(at: index) as? MITextViewTableViewCell
            cell?.showError(with: OnlinePresence.description)
            //self.toastView(messsage: OnlinePresence.description)
            return false
        }
        
        return true
        
    }
    
    
}
