//
//  MIVisaTypeCell.swift
//  MonsteriOS
//
//  Created by Rakesh on 09/07/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class MIVisaTypeCell: UITableViewCell {

    @IBOutlet weak var txt_SelectVisa : RightViewTextField!
    @IBOutlet weak var visaDiscription : UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var visaYesNo_Segment : UISegmentedControl!
    @IBOutlet weak var visaTitle : UILabel!
//    var segmentSelected : ((Int)->Void)?
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.visaYesNo_Segment.tintColor = AppTheme.defaltBlueColor
        self.errorLabel.textColor = Color.errorColor
        
        //No Use as per new requirement of Visa type
        self.visaYesNo_Segment.isHidden = true
            
        self.txt_SelectVisa.setRightViewForTextField("darkRightArrow", width: 15)
        txt_SelectVisa.layer.borderColor  = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        txt_SelectVisa.layer.borderWidth = 1
        txt_SelectVisa.layer.cornerRadius = 5
        
        txt_SelectVisa.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
        txt_SelectVisa.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        txt_SelectVisa.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .valueChanged)
        txt_SelectVisa.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .allTouchEvents)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func show(info: MIUserModel) {
        // self.visaYesNo_Segment.selectedSegmentIndex = visaSegmentSel
        // let site = AppDelegate.instance.site
        // let sourceCountryName = site?.defaultCountryDetails.langOne?.first?.name ?? ""
        self.visaTitle.text = "Do you have a work authorization for \(info.userlocationModal.countryName) ?"
        self.visaDiscription.text  = ""
        //"Since you have selected your Nationality as \(info.nationalityModal.name) and Job Market as \(sourceCountryName). We wanted to confirm if you have work authorization for \(sourceCountryName) Job Market."
        if info.visaType.name.isEmpty {
            self.txt_SelectVisa.text = "Select Visa Type"
        } else {
            self.txt_SelectVisa.text = info.visaType.name
        }
    }

    @IBAction func visaSegmentValueChanged(_ sender:UISegmentedControl) {
//        if let segmentSelectedCallBack = self.segmentSelected {
//            segmentSelectedCallBack(sender.selectedSegmentIndex)
//        }
    }
}



extension MIVisaTypeCell {
    
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        self.selectTF(textField)
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        self.deselectTF(textField)
    }
    
    func showError(with message: String, animated: Bool = true) {
        
        txt_SelectVisa.layer.borderColor = Color.errorColor.cgColor
        errorLabel.textColor = Color.errorColor
        
        if animated { (self.superview as? UITableView)?.beginUpdates() }
        errorLabel.text = message
        if animated { (self.superview as? UITableView)?.endUpdates()  }
        if message.count == 0 {
            self.deselectTF(self.txt_SelectVisa)
        }
    }

    func selectTF(_ textField: UITextField) {
        textField.layer.borderColor = AppTheme.defaltBlueColor.cgColor
        
        (self.superview as? UITableView)?.beginUpdates()
        errorLabel.text = ""
        (self.superview as? UITableView)?.endUpdates()
    }
    
    func deselectTF(_ textField: UITextField) {
        textField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        errorLabel.text = ""
    }
}
