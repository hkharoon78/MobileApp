//
//  MIWalkinInfoTableViewCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 20/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIWalkinInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var walkInInfoLabel: UILabel!{
        didSet{
            walkInInfoLabel.textColor=UIColor.init(hex: "505050")
            walkInInfoLabel.numberOfLines = 0
            walkInInfoLabel.font=UIFont.customFont(type: .Regular, size: 14)
        }
    }
    
    var modelData:WalkinInfoCellModel!{
        didSet{
           self.walkInInfoLabel.text = modelData.info
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

class WalkinInfoCellModel{
    var info:String?
    init(model:WalkInVenue?,isApplied:Bool=true) {
        var walkInfo = ""
        if model?.addresses != nil{
            walkInfo += "Address: "
            if isApplied{
                walkInfo += model!.addresses!.joined(separator: ",")
            }else{
               walkInfo += " Shall be available on successful application"
            }
        }
        
        if model?.city != nil{
            walkInfo += "\nCity : " + model!.city!
        }
        if model?.startDate != nil{
        walkInfo += "\nDate : " + model!.startDate!
        }
        if model?.endDate != nil{
           walkInfo += " to " + model!.endDate!
        }
        if model?.startTime != nil{
           walkInfo += "\nTime: " + model!.startTime!
        }
        if model?.endTime != nil{
            walkInfo += " to " + model!.endTime!
        }
        
       info=walkInfo
    }
}
