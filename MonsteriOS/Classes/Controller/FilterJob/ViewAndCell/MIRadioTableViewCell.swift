//
//  MIRadioTableViewCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 22/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIRadioTableViewCell: UITableViewCell {
    //MARk:Outlets And Variables
    @IBOutlet weak var imgRadio: UIImageView!
    var selectImage: UIImage?
    var unselectedImage:UIImage?
    @IBOutlet weak var lblTitle: UILabel!{
        didSet{
            lblTitle.font=UIFont.customFont(type: .Regular, size: 14)
            lblTitle.textColor=AppTheme.textColor
        }
    }
    var modelData:FilterModel!{
        didSet{
            lblTitle.text=modelData.title.replacingOccurrences(of: "~", with: " - ")
            imgRadio.image=modelData.isSelected ? selectImage : unselectedImage
        }
    }
    //MARK:Life Cycle Method
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgRadio.image=nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.lblTitle.text=nil
    }
    
}
