//
//  MIManageSubsTopTableViewCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 27/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit


class MIManageSubsTopTableViewCell: UITableViewCell {

    //MARK:Outlets And Variables
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            self.titleLabel.font=UIFont.customFont(type: .Medium, size: 16)
            self.titleLabel.textColor=AppTheme.textColor//UIColor.init(hex: "212b36")
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel!{
        didSet{
            self.descriptionLabel.font=UIFont.customFont(type: .Regular, size: 14)
            self.descriptionLabel.textColor=AppTheme.textColor//UIColor.init(hex: "212b36")
        }
    }
    //MARK:Life Cycle Method
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.titleLabel.text=ManageSubsCellConstant.title
        self.descriptionLabel.text=ManageSubsCellConstant.description
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        //self.titleLabel.text=nil
        //self.descriptionLabel.text=nil
    }
   
}
