//
//  MIBlockCompaniesFieldCell.swift
//  MonsteriOS
//
//  Created by Anushka on 24/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIBlockCompaniesFieldCell: UITableViewCell {
    
    //MARK:Outlets and Variable
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            self.titleLabel.textColor=AppTheme.textColor
            self.titleLabel.font=UIFont.customFont(type: .Regular, size: 14)
        }
    }
    
    @IBOutlet weak var textView: FLTextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let companyNameAttriburedString = NSMutableAttributedString(string:BlockCompanyContant.placeHolder)
        let asterix = NSAttributedString(string: " *", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        companyNameAttriburedString.append(asterix)
        self.textView.attributedPlaceholder = companyNameAttriburedString
        self.titleLabel.text=BlockCompanyContant.title
        
        textView.textColor=AppTheme.textColor
        textView.font=UIFont.customFont(type: .Regular, size: 14)
        
        self.textView.isScrollEnabled = false
        self.textView.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
