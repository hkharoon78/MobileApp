//
//  MIEmploymentSalaryTableCell.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 11/10/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import DropDown

enum SalaryOptionPicked : Int {
    case Currency
    case Lakh
    case Thousand
}

enum SalaryCellType {
    case Current
    case Offered
}
//
//protocol SalaryOptionSelectionDelegate {
//    func optionSelectedWith(value:String,sender:UIButton,type: SalaryOptionPicked)
//}

class MIEmploymentSalaryTableCell: UITableViewCell {
    
    let dropDownOptions = DropDown()
  //  var delegate: SalaryOptionSelectionDelegate? = nil
    var shapeType = shape.none
    var cellType: SalaryCellType = .Current
    var showCalulatedSalary = true

    var employementModel : MIEmploymentDetailInfo?
    var currencyCallBack : ((MIEmploymentSalaryTableCell, String) -> Void)?
    
    @IBOutlet weak var bgViewFor_Txf  : UIView!
    @IBOutlet weak var bgViewFor_SalryMode  : UIView!
    @IBOutlet weak var stackViewForSalryMode  : UIStackView!
    @IBOutlet weak var calculatedSalaryLabel: UILabel!
    @IBOutlet weak var btn_salaryHideFromEmployer  : UIButton!

    @IBOutlet weak var title_Lbl : UILabel! {
        didSet {
            self.title_Lbl.font = UIFont.customFont(type: .Medium, size:  13)
            self.title_Lbl.textColor = AppTheme.appGreyColor
        }
    }
    
    @IBOutlet weak var currency_Btn : UIButton! {
        didSet {
            self.currency_Btn.titleLabel?.font = UIFont.customFont(type: .Regular, size:  14)
            self.currency_Btn.setTitleColor(AppTheme.textColor, for: .normal)
            
        }
    }
    
    @IBOutlet weak var salaryTxtField: UITextField!
    @IBOutlet weak var lakhs_Btn : UIButton! {
        didSet {
            self.lakhs_Btn.titleLabel?.font = UIFont.customFont(type: .Regular, size:  14)
            self.lakhs_Btn.setTitleColor(AppTheme.placeholderColor, for: .normal)
            self.lakhs_Btn.setTitleColor(AppTheme.textColor, for: .selected)
            
        }
    }
    @IBOutlet weak var thousand_Btn : UIButton! {
        didSet {
            self.thousand_Btn.titleLabel?.font = UIFont.customFont(type: .Regular, size:  14)
            self.thousand_Btn.setTitleColor(AppTheme.placeholderColor, for: .normal)
            self.thousand_Btn.setTitleColor(AppTheme.textColor, for: .selected)
            
        }
    }
    
    @IBOutlet weak var annual_Btn : UIButton! {
        didSet {
            self.annual_Btn.titleLabel?.font = UIFont.customFont(type: .Regular, size:  14)
            self.annual_Btn.setTitleColor(AppTheme.placeholderColor, for: .normal)
            
            
        }
    }
    @IBOutlet weak var monthly_Btn : UIButton! {
        didSet {
            self.monthly_Btn.titleLabel?.font = UIFont.customFont(type: .Regular, size:  14)
            self.monthly_Btn.setTitleColor(AppTheme.placeholderColor, for: .normal)
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.title_Lbl.textColor = AppTheme.appGreyColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @objc func doneButtonAction() {
        self.salaryTxtField.resignFirstResponder()
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
    
    func showDataForSalary(additionalData : MIAdditionalPersonalInfo) {
        let site = AppDelegate.instance.site
        
        if additionalData.salaryModal.salaryCurrency.isEmpty {
            additionalData.salaryModal.salaryCurrency = (site?.defaultCurrencyDetails.currency?.isoCode) ?? ""
        }
        self.monthly_Btn.isSelected = false
        self.annual_Btn.isSelected = false
        if additionalData.salaryModal.salaryModeAnually {
            self.annual_Btn.isSelected = true
            //self.title_Lbl.text = "Salary (Annually)"
        }else{
            self.monthly_Btn.isSelected = true
           // self.title_Lbl.text = "Salary (Monthly)"
        }
       let cuurency = additionalData.salaryModal.salaryCurrency.isEmpty ? site?.defaultCurrencyDetails.currency?.isoCode : additionalData.salaryModal.salaryCurrency
        self.currency_Btn.setTitle(cuurency, for: .normal)
        
        if cuurency == "INR" {
            self.lakhs_Btn.setTitle(additionalData.salaryModal.salaryInLakh.isEmpty ? "Lacs" : additionalData.salaryModal.salaryInLakh.isNumeric ? Int(additionalData.salaryModal.salaryInLakh)?.formattedWithSeparator : additionalData.salaryModal.salaryInLakh, for: .normal)
            self.thousand_Btn.setTitle(additionalData.salaryModal.salaryThousand.isEmpty ? "Thousand" : additionalData.salaryModal.salaryThousand.isNumeric ? Int(additionalData.salaryModal.salaryThousand)?.formattedWithSeparator : additionalData.salaryModal.salaryThousand, for: .normal)
        }else{
                  self.lakhs_Btn.setTitle(additionalData.salaryModal.salaryInLakh.isEmpty ? "Lacs" : additionalData.salaryModal.salaryInLakh, for: .normal)
                  self.thousand_Btn.setTitle(additionalData.salaryModal.salaryThousand.isEmpty ? "Thousand" : additionalData.salaryModal.salaryThousand, for: .normal)
        }
        
        
        self.lakhs_Btn.isSelected = (additionalData.salaryModal.salaryInLakh.count > 0) ? true : false
        self.thousand_Btn.isSelected = (additionalData.salaryModal.salaryThousand.count > 0) ? true : false
        
        
        if additionalData.salaryModal.salaryCurrency.uppercased() == "INR" || additionalData.salaryModal.salaryCurrency.isEmpty {
            self.bgViewFor_Txf.isHidden = true
            self.salaryTxtField.text = ""
        } else {
            self.bgViewFor_Txf.isHidden = false
            self.salaryTxtField.text = additionalData.salaryModal.salaryInLakh
        }
        let title = (additionalData.salaryModal.salaryCurrency.isEmpty ? site?.defaultCurrencyDetails.currency?.isoCode : additionalData.salaryModal.salaryCurrency) ?? ""
        
        self.showCalculateSalaryBasedOnMode(salaryIakh: additionalData.salaryModal.salaryInLakh, salaryInThousand: additionalData.salaryModal.salaryThousand, salaryCurrency: additionalData.salaryModal.salaryCurrency, salaryMode: additionalData.salaryModal.salaryModeAnually, currencyTitle:title )
        
    }
    
    func showDataForOfferedSalary(object:MIEmploymentDetailInfo) {
        self.cellType = .Offered
        
        self.title_Lbl.text = "New Offered Salary (optional)"
        self.employementModel = object
        
        if object.offeredSalaryModal.salaryCurrency.isEmpty {
            let site = AppDelegate.instance.site
            object.offeredSalaryModal.salaryCurrency = (site?.defaultCurrencyDetails.currency?.isoCode ?? "")
        }
        
        self.showDataForSalar(salaryIakh: object.offeredSalaryModal.salaryInLakh, salaryInThousand: object.offeredSalaryModal.salaryThousand, salaryCurrency: object.offeredSalaryModal.salaryCurrency, salaryMode: object.offeredSalaryModal.salaryModeAnually)

    }
    
    func showDataForCurrentSalary(object:MIEmploymentDetailInfo) {
        self.cellType = .Current
        
        self.employementModel = object
        if object.salaryModal.salaryCurrency.isEmpty {
            let site = AppDelegate.instance.site
            object.salaryModal.salaryCurrency = (site?.defaultCurrencyDetails.currency?.isoCode) ?? ""
        }
        self.btn_salaryHideFromEmployer.isSelected = object.salaryModal.isConfidential
        
        self.showDataForSalar(salaryIakh: object.salaryModal.salaryInLakh, salaryInThousand: object.salaryModal.salaryThousand, salaryCurrency: object.salaryModal.salaryCurrency, salaryMode: object.salaryModal.salaryModeAnually)
    }
    
    func showDataForSalar(salaryIakh: String, salaryInThousand: String, salaryCurrency: String, salaryMode: Bool) {
      
        self.monthly_Btn.isSelected = false
        self.annual_Btn.isSelected = false
        if salaryMode {
            self.annual_Btn.isSelected = true
        }else{
            self.monthly_Btn.isSelected = true
        }
        
        self.salaryTxtField.inputAccessoryView = self.showInputAccessoryView()
        
        if salaryCurrency.uppercased() == "INR" || salaryCurrency.isEmpty {
            self.bgViewFor_Txf.isHidden = true
            self.salaryTxtField.text = ""
            self.salaryTxtField.isUserInteractionEnabled = false
        } else {
            self.bgViewFor_Txf.isHidden = false
            //   self.currencyTxtField.isHidden = false
            self.salaryTxtField.placeholder =  "Salary"
            self.salaryTxtField.text = salaryIakh
            self.salaryTxtField.isUserInteractionEnabled = true
        }
        
        let site = AppDelegate.instance.site
        
        let currencyTitle = (salaryCurrency.isEmpty ? site?.defaultCurrencyDetails.currency?.isoCode : salaryCurrency) ?? ""
        self.currency_Btn.setTitle(currencyTitle, for: .normal)
        if currencyTitle == "INR" {
            self.lakhs_Btn.setTitle(salaryIakh.isEmpty ? "Lacs" : salaryIakh.isNumeric ? Int(salaryIakh)?.formattedWithSeparator : salaryIakh, for: .normal)
            self.thousand_Btn.setTitle(salaryInThousand.isEmpty ? "Thousand" : salaryInThousand.isNumeric ? Int(salaryInThousand)?.formattedWithSeparator : salaryInThousand , for: .normal)
        }else{
            self.lakhs_Btn.setTitle(salaryIakh.isEmpty ? "Lacs" : salaryIakh, for: .normal)
            self.thousand_Btn.setTitle(salaryInThousand.isEmpty ? "Thousand" : salaryInThousand, for: .normal)
        }
       
        self.lakhs_Btn.isSelected = (salaryIakh.count > 0) ? true : false
        self.thousand_Btn.isSelected = (salaryInThousand.count > 0) ? true : false
        
        self.showCalculateSalaryBasedOnMode(salaryIakh: salaryIakh, salaryInThousand: salaryInThousand,salaryCurrency: salaryCurrency,salaryMode: salaryMode,currencyTitle: currencyTitle)

        
    }
    func showCalculateSalaryBasedOnMode(salaryIakh:String,salaryInThousand:String,salaryCurrency:String,salaryMode:Bool,currencyTitle:String) {
     
        if !stackViewForSalryMode.isHidden {
            var totalSalary = Int(salaryIakh) ?? 0
            if salaryCurrency.uppercased() == "INR" {
                let lakhSalary = ((Int(salaryIakh) ?? 0) * 100000)
                let thousand = (Int(salaryInThousand) ?? 0)
                totalSalary = lakhSalary + thousand
            }
            var calculatedText = ""
            if salaryMode { //Annual
                totalSalary = totalSalary / 12
                calculatedText = "Calculated monthly salary is"
            } else {
                totalSalary = totalSalary * 12
                calculatedText = "Calculated annual salary is"
            }
         //   if cellType != .Offered {
                if showCalulatedSalary {
                    self.calculatedSalaryLabel.isHidden = (totalSalary < 1)
                    self.calculatedSalaryLabel.attributedText = self.makeAttributtedText(calculatedText, currencyTitle, totalSalary.formattedWithSeparator)

                }
          //  }
           
        }
    }
    func makeAttributtedText(_ text1: String, _ text2: String, _ text3: String) -> NSMutableAttributedString {
        let initial = NSMutableAttributedString(string: text1, attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: 0x999999), NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 13)])
        let mid = NSAttributedString(string: " \(text2) ", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: 0x999999), NSAttributedString.Key.font:UIFont.customFont(type: .Semibold, size: 13)])
        let last = NSMutableAttributedString(string: text3, attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: 0x999999), NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 13)])
        
        initial.append(mid)
        initial.append(last)
        
        return initial
    }

    
    //MARK: - IBAction Methods
    @IBAction func monthAnnualSelectionClicked(_ sender : UIButton) {
        self.monthly_Btn.isSelected = false
        self.annual_Btn.isSelected = false

        if cellType == .Current {
            if sender.tag == 330 {
                self.currencyCallBack?(self, "CURRENT_AN")
                self.annual_Btn.isSelected = true
            }else{
                self.currencyCallBack?(self, "CURRENT_MO")
                self.monthly_Btn.isSelected = true
            }
        }else{
            if sender.tag == 330 {
                self.currencyCallBack?(self, "OFFERED_AN")
                self.annual_Btn.isSelected = true
            }else{
                self.currencyCallBack?(self, "OFFERED_MO")
                self.monthly_Btn.isSelected = true
            }
        }
        self.salaryTxtField.placeholder = "Salary"

        if let emp = employementModel {
            if cellType == .Current {
                self.employementModel?.salaryModal.salaryModeAnually = (self.annual_Btn.isSelected) ? true : false
                self.showDataForCurrentSalary(object: emp)
            } else {
                self.employementModel?.offeredSalaryModal.salaryModeAnually = (self.annual_Btn.isSelected) ? true : false
                self.showDataForOfferedSalary(object: emp)
            }
        }
    }
    
    @IBAction func currencyBtnAction(_ sender:UIButton) {
        self.currencyCallBack?(self, "CURRENCY")
    }
    @IBAction func lakhBtnAction(_ sender:UIButton) {
        self.currencyCallBack?(self, "LAKH")
    }
    @IBAction func thousandBtnAction(_ sender:UIButton) {
        self.currencyCallBack?(self, "THOUSAND")
    }
    @IBAction func hideSalary(_ sender:UIButton) {
        if let emp = employementModel {
            emp.salaryModal.isConfidential = !emp.salaryModal.isConfidential
            sender.isSelected = emp.salaryModal.isConfidential
        }
    }
}

