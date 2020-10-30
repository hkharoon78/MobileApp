//
//  MITextFieldWithGuidLineCell.swift
//  MonsteriOS
//
//  Created by Rakesh on 26/06/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class MITextFieldWithGuidLineCell: UITableViewCell {
    var eyeIcon:UIButton! {
        let eyeBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        eyeBtn.setImage(UIImage(named: "hide-password"), for: .normal)
        eyeBtn.setImage(UIImage(named: "showpassword"), for: .selected)
        eyeBtn.addTarget(self, action: #selector(securePassword(_ :)), for: .touchUpInside)
        return eyeBtn
    }
    var hidePasswordCallBack : ((Bool)->Void)?
    @IBOutlet weak var txt_value : JVFloatLabeledTextField!{
        didSet{
            txt_value.font=UIFont.customFont(type: .Regular, size: 16)
            txt_value.placeholderColor = UIColor.lightGray
            txt_value.textColor=AppTheme.textColor
            txt_value.floatingLabelFont=UIFont.customFont(type: .Regular, size: 14)
            
        }
    }
    @IBOutlet weak var lbl_guideLine : UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showDataWithPlaceholder(value:String,placeHolder:String,isFieldSecureEntry:Bool) {
        txt_value.placeholder = placeHolder
        txt_value.text = value
        if isFieldSecureEntry {
            txt_value.isSecureTextEntry = isFieldSecureEntry
        }
    }
    @objc func securePassword(_ sender:UIButton) {
        sender.isSelected = !sender.isSelected
        if let callBack = hidePasswordCallBack {
            callBack(sender.isSelected)
        }
    }
}
