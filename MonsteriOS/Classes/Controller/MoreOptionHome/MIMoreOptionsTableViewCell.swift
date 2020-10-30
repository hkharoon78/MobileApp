//
//  MIMoreOptionsTableViewCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 04/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIMoreOptionsTableViewCell: UITableViewCell {

    @IBOutlet weak var moreIconView: UIImageView!
    @IBOutlet weak var moreTitleLabel: UILabel!{
        didSet{
            moreTitleLabel.font=UIFont.customFont(type: .Regular, size: 16)
            moreTitleLabel.textColor=UIColor.init(hex: "060606")
        }
    }
    var modelData:MoreOptionModel!{
        didSet{
            moreIconView.contentMode = .center
            moreTitleLabel.text=modelData.title
            moreIconView.image=modelData.image
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

}

class MoreOptionModel{
    var image:UIImage?
    var title:String?
    init(image:UIImage?,title:String) {
        self.image=image
        self.title=title
    }
}
