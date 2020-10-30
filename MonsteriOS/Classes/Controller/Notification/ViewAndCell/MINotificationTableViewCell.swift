//
//  MINotificationTableViewCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 10/07/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MINotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var notifTItleLabel: UILabel!{
        didSet{
            notifTItleLabel.textColor = UIColor.init(hex: "212b36")
            notifTItleLabel.font = UIFont.customFont(type: .Medium, size: 16)
        }
    }
    
    @IBOutlet weak var dateLabel: UILabel!{
        didSet{
            dateLabel.textColor = UIColor.init(hex: "b2b0b0")
            dateLabel.font = UIFont.customFont(type: .Medium, size: 14)
        }
    }
    
    @IBOutlet weak var notifiSubtitleLabel: UILabel!{
        didSet{
            notifiSubtitleLabel.textColor = UIColor.init(hex: "637381")
            notifiSubtitleLabel.font = UIFont.customFont(type: .Regular, size: 14)
        }
    }
    
    var viewModel:NotificationViewModel!{
        didSet{
            self.notifTItleLabel.text=viewModel.title
            self.notifiSubtitleLabel.text=viewModel.subTitle
            self.dateLabel.text=viewModel.modifiedAt
            if !viewModel.actionTaken{
                self.backgroundColor = UIColor.init(hex: "f3f2f9")
            }else{
                self.backgroundColor = .white
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.notifTItleLabel.text=nil
        self.notifiSubtitleLabel.text=nil
        self.dateLabel.text=nil
        self.selectionStyle = .none
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.notifTItleLabel.text=nil
        self.notifiSubtitleLabel.text=nil
        self.dateLabel.text=nil
        self.backgroundColor = .white
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
