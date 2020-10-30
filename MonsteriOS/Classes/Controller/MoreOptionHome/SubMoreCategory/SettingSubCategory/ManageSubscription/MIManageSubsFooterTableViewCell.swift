//
//  MIManageSubsFooterTableViewCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 27/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIManageSubsFooterTableViewCell: UITableViewCell {

    //MARK:Outlets And Variable
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            self.titleLabel.font=UIFont.customFont(type: .Medium, size: 16)
            self.titleLabel.textColor=AppTheme.textColor//UIColor.init(hex: "212b36")
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel!{
        didSet{
            self.descriptionLabel.font=UIFont.customFont(type: .Regular, size: 14)
            self.descriptionLabel.textColor=AppTheme.textColor//UIColor.init(hex: "152935")
        }
    }
    @IBOutlet weak var deactivationLabel: UILabel!{
        didSet{
            self.deactivationLabel.font=UIFont.customFont(type: .Medium, size: 14)
            
        }
    }
    @IBOutlet weak var dropDownTextField: UITextField!
    @IBOutlet weak var btnMore: UIButton!
    
    //MARK:Life Cycle Method
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.titleLabel.text=ManageSubsCellConstant.footerCellTitle
        self.descriptionLabel.text=ManageSubsCellConstant.footerCellDesc
        self.btnMore.setTitleColor(AppTheme.defaltBlueColor, for: .normal)

//        self.deactivationLabel.text=ManageSubsCellConstant.footerCellDeact
//        dropDownTextField.font=UIFont.customFont(type: .Regular, size: 14)
//        dropDownTextField.textColor=AppTheme.textColor//UIColor.init(hex: "212b36")
//      let imageView=UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
//        imageView.image=#imageLiteral(resourceName: "bottom_direction_arrow")
//        imageView.contentMode = .center
//        dropDownTextField.rightViewMode = .always
//        dropDownTextField.rightView=imageView
//        self.dropDownTextField.placeholder=ManageSubsCellConstant.footerDropPlaceholder
        
    }

    
}
