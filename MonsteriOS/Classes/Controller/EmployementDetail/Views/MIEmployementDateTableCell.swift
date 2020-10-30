//
//  MIEmployementDateTableCell.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 10/10/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIEmployementDateTableCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var secondTitleLabel: UILabel!
    @IBOutlet weak var fromDateTextField: RightViewTextField!
    @IBOutlet weak var tillDateTextField: RightViewTextField!
    @IBOutlet weak var presentButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var secondryErrorLabel: UILabel!
    
    @IBOutlet private weak var stackView: UIStackView!
    
    var primaryTextFieldAction: ((UITextField)->())?
    var secondryTextFieldAction: ((UITextField)->())?
    
    var pickDateCallBack : ((MIEmployementDateTableCell, Date, String) -> Void)?
    
    var checkBoxSelectionAction : ((Bool, MIEmployementDateTableCell)->Void)?

    var info: MIEmploymentDetailInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        
        self.tillDateTextField.setRightViewForTextField("calendarBlue")
        self.fromDateTextField.setRightViewForTextField("calendarBlue")
        
        tillDateTextField.layer.borderColor  = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        fromDateTextField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        tillDateTextField.layer.borderWidth = 1
        fromDateTextField.layer.borderWidth = 1
        
        tillDateTextField.layer.cornerRadius = 5
        fromDateTextField.layer.cornerRadius = 5
        
        
//        tillDateTextField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
//        tillDateTextField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        tillDateTextField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .valueChanged)
        tillDateTextField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .allTouchEvents)
//
//        fromDateTextField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
//        fromDateTextField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        fromDateTextField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .valueChanged)
        fromDateTextField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .allTouchEvents)
        
        fromDateTextField.delegate = self
        tillDateTextField.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func presentButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.checkBoxSelectionAction?(sender.isSelected, self)
    }
    
    
    func showError(with message: String, animated: Bool = true) {
        
        fromDateTextField.layer.borderColor = Color.errorColor.cgColor
        errorLabel.textColor = Color.errorColor
        
        if animated { (self.superview as? UITableView)?.beginUpdates() }
        errorLabel.text = message
        if animated { (self.superview as? UITableView)?.endUpdates() }
        if message.count == 0 {
            self.deselectTF(self.fromDateTextField)
        }
    }
    
    func showErrorOnSecondryTF(with message: String, animated: Bool = true) {
        
        tillDateTextField.layer.borderColor = Color.errorColor.cgColor
        secondryErrorLabel.textColor = Color.errorColor
        
        if animated { (self.superview as? UITableView)?.beginUpdates() }
        secondryErrorLabel.text = message
        if animated { (self.superview as? UITableView)?.endUpdates() }
        if message.count == 0 {
            self.deselectTF(self.tillDateTextField)
        }
    }
    
    func selectTF(_ textField: UITextField) {
        textField.layer.borderColor = AppTheme.defaltBlueColor.cgColor
        
        (self.superview as? UITableView)?.beginUpdates()
        errorLabel.text = ""
        secondryErrorLabel.text = ""
        (self.superview as? UITableView)?.endUpdates()
    }
    
    func deselectTF(_ textField: UITextField) {
        textField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        errorLabel.text = ""
        secondryErrorLabel.text = ""
    }
    
}

extension MIEmployementDateTableCell: UITextFieldDelegate {
    
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        self.selectTF(textField)
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        self.deselectTF(textField)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case self.fromDateTextField:
            self.primaryTextFieldAction?(textField)
            self.fromDateClicked(self.fromDateTextField)
        case self.tillDateTextField:
            self.secondryTextFieldAction?(textField)
            self.tillDateClicked(self.tillDateTextField)
        default:
            break
        }
        return true
    }
}

extension MIEmployementDateTableCell {
    
    func showEmploymentWorkDuration(obj: MIEmploymentDetailInfo) {
        self.info = obj
        
        self.fromDateTextField.text = obj.experinceFrom?.getStringWithFormat(format: "MMM, yyyy")
        self.tillDateTextField.text = obj.experinceTill?.getStringWithFormat(format: "MMM, yyyy")
        
        self.presentButton.isSelected = obj.isCurrentEmplyement
        self.tillDateTextField.isHidden = obj.isCurrentEmplyement
    }
    
    
    @IBAction func fromDateClicked(_ sender : UITextField) {
        self.superview?.endEditing(true)
        
        let maximumDate = self.info?.experinceTill ?? Date()
        
        AKDatePicker.openPicker(in: sender, currentDate: sender.text?.dateWith("MMM, yyyy"), minimumDate: Date().minus(years: 50), maximumDate: maximumDate, pickerMode: .date) { (date) in
            self.fromDateTextField.text = date.getStringWithFormat(format: "MMM, yyyy")
            self.pickDateCallBack?(self,date, "FROM_DATE")
        }
    }
    @IBAction func tillDateClicked(_ sender : UITextField) {
        self.superview?.endEditing(true)
        
        let minimumDate = self.info?.experinceFrom ?? Date().minus(years: 50)
        
        AKDatePicker.openPicker(in: sender, currentDate: sender.text?.dateWith("MMM, yyyy"), minimumDate: minimumDate, maximumDate: Date(), pickerMode: .date) { (date) in
            self.tillDateTextField.text = date.getStringWithFormat(format: "MMM, yyyy")
            self.pickDateCallBack?(self,date, "TILL_DATE")
        }
    }
}
