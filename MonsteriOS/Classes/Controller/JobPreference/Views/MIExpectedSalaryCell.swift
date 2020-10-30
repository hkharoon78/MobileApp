//
//  MIExpectedSalaryCell.swift
//  MonsteriOS
//
//  Created by Rakesh on 17/04/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class MIExpectedSalaryCell: UITableViewCell {

    var objData:MIJobPreferencesModel?
    
    @IBOutlet weak var txtFld_currency : JVFloatLabeledTextField! {
        didSet {
            txtFld_currency.font = UIFont.customFont(type: .Regular, size: 16)
           // txtFld_currency.floatingLabelTextColor = Color.colorLightDefault
            txtFld_currency.textColor = AppTheme.textColor
            txtFld_currency.floatingLabelFont = UIFont.customFont(type: .Regular, size: 14)

        }
    }
    @IBOutlet weak var txtFld_salary : JVFloatLabeledTextField! {
        didSet {
            txtFld_salary.font = UIFont.customFont(type: .Regular, size: 16)
           // txtFld_salary.floatingLabelTextColor = Color.colorLightDefault
            txtFld_salary.textColor = AppTheme.textColor
            txtFld_salary.floatingLabelFont = UIFont.customFont(type: .Regular, size: 14)

        }
    }
    @IBOutlet weak var img_ForwrdArrow : UIImageView!

    var salaryCallBack : (()->Void)?
    var currencyCallBack : (()->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.txtFld_salary.delegate = self
        self.txtFld_currency.delegate = self
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    Mark:- TextFiel Delegate
//
//    @IBAction func currencyAction(_ sender:UIButton){
//
//        if let currency  = self.currencyCallBack {
//            currency()
//        }
//    }
//    @IBAction func salaryAction(_ sender:UIButton){
//        if let salary  = self.salaryCallBack {
//            salary()
//        }
//    }
    func dataPopulate(model:MIJobPreferencesModel){
        objData = model
        self.img_ForwrdArrow.isHidden = true
        
        self.txtFld_salary.text = model.expectedSalary.salaryInLakh.isEmpty ? "" : (model.expectedSalary.salaryInLakh)

        if objData?.expectedSalary.salaryCurrency == "INR" {
            self.img_ForwrdArrow.isHidden = false
            self.txtFld_salary.text = model.expectedSalary.salaryInLakh.isEmpty ? "" : (model.expectedSalary.salaryInLakh + " Lac")

        }
        self.txtFld_currency.text = model.expectedSalary.salaryCurrency

    }
    
}

extension MIExpectedSalaryCell : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtFld_salary {
            if objData?.expectedSalary.salaryCurrency != "INR" {
                if let parentController = textField.parentViewController as? MIJobPreferenceViewController {
                    parentController.setMainViewFrame(originY: 0)
                    let movingHeight = textField.movingHeightIn(view : parentController.view)
                    if movingHeight > 0 {
                        UIView.animate(withDuration: 0.3) {
                            parentController.setMainViewFrame(originY: -(movingHeight+50))
                        }
                    }
                }
            }
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
        if textField == self.txtFld_currency {
           
            if let currency  = self.currencyCallBack {
               currency()
            }
            return
        }
        
        if textField == self.txtFld_salary {
            if objData?.expectedSalary.salaryCurrency == "INR" {
                if let salary  = self.salaryCallBack {
                    salary()
                }
                return
            }
            textField.keyboardType = .numberPad
            textField.inputAccessoryView = self.showInputAccessoryView()
           
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == self.txtFld_salary {
            if let parentController = textField.parentViewController as? MIJobPreferenceViewController {
                parentController.setMainViewFrame(originY: 0)

            }
            self.objData?.expectedSalary.salaryInLakh = (textField.text?.isEmpty ?? false) ? "0" : textField.text?.withoutWhiteSpace() ?? "0"
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        let searchTxt = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)

        if (searchTxt.count) >= 11 {
            return false
        }

        if searchTxt.count <= 10 || string.isEmpty {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }

        return true
    }
    func showInputAccessoryView() -> UIToolbar {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: kScreenSize.width, height: 50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction))
        
        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        
        return doneToolbar
    }
    @objc func doneButtonAction()
    {
        self.txtFld_salary.resignFirstResponder()
    }
}
