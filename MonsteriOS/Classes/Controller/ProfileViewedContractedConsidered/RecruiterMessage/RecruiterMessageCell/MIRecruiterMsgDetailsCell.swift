//
//  MIRecruiterMsgDetailsCell.swift
//  MonsteriOS
//
//  Created by Anushka on 25/06/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIRecruiterMsgDetailsCell: UITableViewCell {

    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblSkillName: UILabel!
    @IBOutlet weak var lblPostedTime: UILabel!
    @IBOutlet weak var lblSentVia: UILabel!
    
    var modelData: RecuiterActionCellViewModel?{
        didSet{
            self.lblName.text = modelData?.name
            self.lblCompanyName.text = modelData?.companyName
            self.lblSkillName.text = modelData?.skillName
            self.lblPostedTime.text = modelData?.timeViewed
            self.imgProfile.setImage(with: modelData?.avatarUrl, placeholder: defaultRecruiterIcon)
            self.lblPostedTime.text = modelData?.timeViewed
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

