//
//  MINoticePeroidCell.swift
//  MonsteriOS
//
//  Created by Rakesh on 24/04/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MINoticePeroidCell: UITableViewCell {

    @IBOutlet weak var userdescription_lbl:UILabel!

    var btnClickedCallBack : ((Bool)->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func noticePeroidClicked(_ sender:UIButton){
        if let callBack = self.btnClickedCallBack {
            callBack(true)
        }
    }
    
    func showDataValue(){
//        self.noticePeriod_Btn.setTitle(value.isEmpty ? "Select your notice period details" : value, for: .normal)
//        self.noticePeriod_Btn.setTitleColor(value.isEmpty ? AppTheme.lightGrayColor : .black, for: .normal)
        self.userdescription_lbl.text = "Hi \(AppDelegate.instance.userInfo.fullName), Add the following information for a better response from recruiter."
    }
}
