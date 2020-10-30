//
//  MITitleValueCell.swift
//  MonsteriOS
//
//  Created by Rakesh on 03/04/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MITitleValueCell: UITableViewCell {

    @IBOutlet weak var lbl_title:UILabel! {
        didSet {
            lbl_title.font = UIFont.customFont(type: .Medium, size: 14)
            lbl_title.textColor = UIColor(hex: "505050")
        }
    }
    @IBOutlet weak var btn_valueYes:UIButton! {
        didSet {
            btn_valueYes.titleLabel?.font = UIFont.customFont(type: .Regular, size: 14)
            btn_valueYes.setTitleColor(UIColor(hex: "505050"), for: .normal)

        }
    }
    @IBOutlet weak var btn_valueNo:UIButton! {
        didSet {
            btn_valueNo.titleLabel?.font = UIFont.customFont(type: .Regular, size: 14)
            btn_valueNo.setTitleColor(UIColor(hex: "505050"), for: .normal)
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTitleForTheOption(title:String){
        lbl_title.text = title
    }
}
