//
//  MIEditProfileDetailsCell.swift
//  MonsteriOS
//
//  Created by Anushka on 01/02/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIEditProfileDetailsCell: UITableViewCell {
    
    @IBOutlet weak var txtFieldCountryCode: UITextField!
    @IBOutlet weak var txtFieldMobileNo: UITextField!
    @IBOutlet weak var changeBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var countryFieldLeadingConstrint: NSLayoutConstraint!
    @IBOutlet weak var txtFieldTrailingConstraint: NSLayoutConstraint!
    var changeActionCallBack : ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func manageDesignWithDataForCell(title:String,model:MIProfilePersonalDetailInfo){
        self.titleLbl.text = title
//        self.txtFieldMobileNo.isEnabled = false
//        self.txtFieldCountryCode.isEnabled = false
        if title == RegisterViewStoryBoardConstant.mobileNumber {
            self.countryFieldLeadingConstrint.constant = 13
            self.txtFieldMobileNo.text = model.mobileNumber
            let countryCode = model.countryCode.isEmpty ? "" : (model.countryCode.hasPrefix("+") ? model.countryCode : ("+" + model.countryCode))
            self.txtFieldCountryCode.text = countryCode
            self.changeBtn.setTitle(model.mobileNumberVerifedStatus ? "Verified" : "Verify", for: .normal)
            self.changeBtn.setTitleColor(model.mobileNumberVerifedStatus ? AppTheme.greenColor : AppTheme.defaltTheme, for: .normal)
        }else{
            self.txtFieldCountryCode.text = ""
            self.txtFieldMobileNo.text = model.primaryEmail
            self.countryFieldLeadingConstrint.constant = -28
            self.changeBtn.setTitle(model.emailVerifedStatus ? "Verified" : "Verify", for: .normal)
            self.changeBtn.setTitleColor(model.emailVerifedStatus ? AppTheme.greenColor : AppTheme.defaltTheme, for: .normal)



        }
    }
    
    @IBAction func changeBtnAction(_ sender:UIButton) {
        
        if let action = changeActionCallBack {
            action(self.titleLbl.text!)
        }
    }
}
