//
//  MIMoreOptionTableViewCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 26/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIMoreOptionTableViewCell: UITableViewCell {

    //MARK:Outlets And Variable
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            titleLabel.font=UIFont.customFont(type: .Regular, size: 16)
        }
    }
    @IBOutlet weak var subTitlelabel: UILabel!{
        didSet{
            subTitlelabel.font=UIFont.customFont(type: .Regular, size: 16)
            subTitlelabel.textColor=AppTheme.defaltBlueColor
        }
    }
    
    //MARK:Life Cycle Method
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.contentView.backgroundColor=UIColor.init(hex: "eaeff2")
        self.subTitlelabel.text=nil
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
       
        self.titleLabel.text=nil
        self.subTitlelabel.text=nil

    }
    
}
