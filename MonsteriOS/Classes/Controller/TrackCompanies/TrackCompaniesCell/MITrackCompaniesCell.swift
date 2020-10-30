//
//  MITrackCompaniesCell.swift
//  MonsteriOS
//
//  Created by Anushka on 22/02/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MITrackCompaniesCell: UITableViewCell {
    
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var btnFollowCompnay: UIButton!
   
    var modelData:FollowedComRecModel!{
        didSet{
         lblCompanyName.text = modelData.name
            if modelData.isFollowed{
               self.btnFollowCompnay.setTitle("Following", for: .normal)
            }else{
                self.btnFollowCompnay.setTitle("Follow", for: .normal)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.btnFollowCompnay.setTitleColor(AppTheme.btnCTAGreenColor, for: .normal)
        self.btnFollowCompnay.roundCorner(1, borderColor: AppTheme.btnCTAGreenColor, rad: 5)
        self.btnFollowCompnay.backgroundColor = UIColor.clear
       // self.btnFollowCompnay.setTitleColor(AppTheme.defaltTheme, for: .selected)
        self.btnFollowCompnay.tintColor = UIColor.clear
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
