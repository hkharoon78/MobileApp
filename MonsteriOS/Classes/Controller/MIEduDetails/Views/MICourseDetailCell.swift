//
//  MICourseDetailCell.swift
//  MonsteriOS
//
//  Created by Rakesh on 21/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

protocol ReadOptionSelectedDelegate : class {
    func readMore()
}

class MICourseDetailCell: UITableViewCell {

    weak var delegate : ReadOptionSelectedDelegate?
    
    @IBOutlet weak var title_lbl:UILabel! {
        didSet {
            self.title_lbl.font = UIFont.customFont(type: .Medium, size: 16)
            self.title_lbl.textColor = AppTheme.textColor

        }
    }
    @IBOutlet weak var subTitle_lbl:UILabel! {
        didSet {
            self.subTitle_lbl.font = UIFont.customFont(type: .Medium, size: 16)
            self.subTitle_lbl.textColor = AppTheme.textColor
        }
    }
    @IBOutlet weak var introductionContent_lbl:UILabel! {
        didSet {
            self.introductionContent_lbl.font = UIFont.customFont(type: .Regular, size: 16)
            self.introductionContent_lbl.textColor = AppTheme.grayColor
        }
    }
    @IBOutlet weak var readMore_Btn:UIButton! {
        didSet {
            self.readMore_Btn.titleLabel?.font = UIFont.customFont(type: .Medium, size: 16)
            self.readMore_Btn.setTitleColor(AppTheme.defaltTheme, for: .normal)
            self.readMore_Btn.setTitle("Read More", for: .normal)
            self.readMore_Btn.setTitle("Read Less", for: .selected)

        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // Mark: - IBAction Methods
    @IBAction func readMoreBtnClicked(_ sender : UIButton) {
        if self.delegate != nil {
            self.readMore_Btn.isSelected = !self.readMore_Btn.isSelected
            self.delegate?.readMore()
        }
    }
    
}
