//
//  MIRecuiterActionTableViewCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 03/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIRecuiterActionTableViewCell: UITableViewCell {

    @IBOutlet weak var recuiterName: UILabel!{
        didSet{
            recuiterName.font=UIFont.customFont(type: .Medium, size: 16)
            recuiterName.textColor=AppTheme.textColor
            
        }
    }
    
    @IBOutlet weak var dateLabel: UILabel!{
        didSet{
            dateLabel.font=UIFont.customFont(type: .Medium, size: 14)
            dateLabel.textColor=UIColor.init(hex: "b2b0b0")
        }
    }
    
    @IBOutlet weak var companyName: UILabel!{
        didSet{
            companyName.font=UIFont.customFont(type: .Regular, size: 14)
            
        }
    }
    @IBOutlet weak var locationName: UILabel!{
        didSet{
            locationName.font=UIFont.customFont(type: .Regular, size: 14)
            locationName.textColor=UIColor.init(hex: "54698d")
        }
    }
    @IBOutlet weak var locationIcon: UIImageView!
    
    @IBOutlet weak var locationIconHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var locationHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var locationNameTopConstraint: NSLayoutConstraint!
    
    var locationViewHide=false{
        didSet{
            if locationViewHide{
                locationIcon.isHidden=true
                locationName.isHidden=true
                locationHeightConstraint.constant=0
                locationNameTopConstraint.constant=0
                locationIconHeightConstraint.constant=0
            }
        }
    }
    var recuiterData:RecuiterActionViewModel!{
        didSet{
            self.companyName.text=self.recuiterData.companyName
            self.dateLabel.text=self.recuiterData.date
            self.locationName.text=self.recuiterData.locationName
            self.recuiterName.text=self.recuiterData.recuiterName
            companyName.textColor = locationViewHide ? UIColor.init(hex: "637381") :  AppTheme.defaltTheme
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.locationIcon.image=#imageLiteral(resourceName: "location")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.companyName.text=nil
        self.dateLabel.text=nil
        self.locationName.text=nil
        self.recuiterName.text=nil
    }
    
}

class RecuiterActionViewModel{
    var recuiterName:String?
    var companyName:String?
    var locationName:String?
    var date:String?
    init(recuiterName:String?,companyName:String?,locationName:String?,date:String?) {
        self.recuiterName=recuiterName
        self.companyName=companyName
        self.locationName=locationName
        self.date=date
    }
}
