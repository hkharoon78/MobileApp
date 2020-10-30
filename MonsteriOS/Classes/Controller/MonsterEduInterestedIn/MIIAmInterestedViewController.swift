//
//  MIIAmInterestedViewController.swift
//  MonsteriOS
//
//  Created by Rakesh on 26/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import DropDown

class MIIAmInterestedViewController: UIViewController {

    @IBOutlet weak var tblView:UITableView!
    @IBOutlet private weak var submit_btn:UIButton! {
        didSet {
            self.submit_btn.showPrimaryBtn()
        }
    }
    
    var interestedDataSource = [MIInterestedModel]()
    let dropDownPicker = DropDown()
    let imgView = UIImageView.init(image: UIImage(named: "bottom_direction_arrow"))

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUpView()
    }
    
    //MARK: - Helper Methods
    func setUpView()  {
        
        self.title = ControllerTitleConstant.iAmInterested
        tblView.register(UINib(nibName:String(describing: MICreateAlertTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MICreateAlertTableViewCell.self))
        
        self.tblView.tableFooterView = UIView(frame: .zero)
        self.interestedDataSource.append(MIInterestedModel(placeHolderTitle: "Name", data: ""))
        self.interestedDataSource.append(MIInterestedModel(placeHolderTitle: "Email Address", data: ""))
        self.interestedDataSource.append(MIInterestedModel(placeHolderTitle: "Mobile Number", data: ""))
        self.interestedDataSource.append(MIInterestedModel(placeHolderTitle: "City", data: ""))
        self.interestedDataSource.append(MIInterestedModel(placeHolderTitle: "Course", data: "Certified SEO Professional VS-1084"))
        self.configureDropDown(dropDown: self.dropDownPicker)
        self.loadDataOnDropDown()

    }
    func loadDataOnDropDown(){
    
        dropDownPicker.dataSource = ["Delhi","Uttrakhand","Punjab","UP","Mumbai"]
        dropDownPicker.selectionAction = {  (index: Int, item: String) in
            let obj = self.interestedDataSource[3]
            obj.value = item
            let cell = self.tblView.cellForRow(at: IndexPath(row: 3, section: 0)) as! MICreateAlertTableViewCell
            cell.floatingTextField.text = item
            // self.tblView.reloadData()
        }
        dropDownPicker.cellConfiguration = {(_, item) in
            return "\(item)"
        }
    }

    func validateField() -> Bool {
        var  isValidate = false
        
        if self.interestedDataSource[0].value.isEmpty {
            self.showAlert(title: "", message: "Please enter your name.")
        }else if self.interestedDataSource[1].value.isEmpty {
            self.showAlert(title: "", message: "Please enter your email id.")

        }else if !self.interestedDataSource[1].value.isValidEmail {
            self.showAlert(title: "", message: "Please enter valid email id.")
            
        }else if self.interestedDataSource[2].value.isEmpty {
            self.showAlert(title: "", message: "Please enter your mobile number.")

        }else if self.interestedDataSource[3].value.isEmpty {
            self.showAlert(title: "", message: "Please select your city.")

        }else {
            isValidate = true
        }
        
        return isValidate
    }
    
    //MARK: - IBActions
    @IBAction func submitBtnClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.validateField() {
            self.showAlert(title: "", message: "Thanks for your interest on certified course. We will shorlty contact you on the mail id.",isErrorOccured: false)
        }
    }
    
}

extension MIIAmInterestedViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.interestedDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MICreateAlertTableViewCell", for: indexPath) as?  MICreateAlertTableViewCell {
            cell.floatingTextField.rightView = nil

            if indexPath.row == 3 {
                imgView.contentMode = .top
                cell.floatingTextField.rightViewMode = .always
                cell.floatingTextField.rightView = imgView
            }
            
            cell.floatingTextField.setPlaceholder(self.interestedDataSource[indexPath.row].title, floatingTitle: self.interestedDataSource[indexPath.row].title)
            cell.floatingTextField.text = self.interestedDataSource[indexPath.row].value
            cell.floatingTextField.isUserInteractionEnabled = true
            cell.floatingTextField.delegate = self
            cell.floatingTextField.tag = indexPath.row + 404
            if indexPath.row == 4 {
                cell.floatingTextField.isUserInteractionEnabled = false
            }
             return cell
        }
        return UITableViewCell()
    }
}

extension MIIAmInterestedViewController:UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 407 {
           // self.view.endEditing(true)
            self.dropDownPicker.anchorView = textField
            self.dropDownPicker.bottomOffset = CGPoint(x: 0, y:((self.dropDownPicker.anchorView?.plainView.bounds.height)!))
            self.dropDownPicker.topOffset = CGPoint(x: 0, y:-((self.dropDownPicker.anchorView?.plainView.bounds.height)!))
            self.dropDownPicker.show()
            return false
        }
        if textField.tag == 406 {
            textField.returnKeyType = .done
            textField.keyboardType = .numberPad
            textField.addDoneButtonOnKeyboard()
        }else if textField.tag == 405 {
            textField.keyboardType = .emailAddress
            textField.returnKeyType = .next
        }else if textField.tag == 404 {
            textField.autocapitalizationType = .words
            textField.returnKeyType = .next
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField.tag {
        case 404:
            self.interestedDataSource[textField.tag-404].value = (textField.text?.withoutWhiteSpace())!
        case 405:
            self.interestedDataSource[textField.tag-404].value = (textField.text?.withoutWhiteSpace())!

        case 406:
            self.interestedDataSource[textField.tag-404].value = (textField.text?.withoutWhiteSpace())!

        default: break
            
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .done {
            self.view.endEditing(true)

        }else if textField.returnKeyType == .next {
            self.view.viewWithTag(textField.tag + 1)?.becomeFirstResponder()
        }
        return true
    }
}
