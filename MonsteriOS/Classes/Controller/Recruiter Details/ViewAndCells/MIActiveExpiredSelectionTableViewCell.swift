//
//  MIActiveExpiredSelectionTableViewCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 06/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIActiveExpiredSelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var expiredJobsButton: UIButton!
    @IBOutlet weak var activeJobsButton: UIButton!
    var jobButtonAction:((Int)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        expiredJobsButton.titleLabel?.font=UIFont.customFont(type: .Medium, size: 14)
        expiredJobsButton.setTitleColor(AppTheme.defaltTheme, for: .selected)
        expiredJobsButton.setTitleColor(UIColor.init(hex: "637381"), for: .normal)
        activeJobsButton.titleLabel?.font=UIFont.customFont(type: .Medium, size: 14)
        activeJobsButton.setTitleColor(AppTheme.defaltTheme, for: .selected)
        activeJobsButton.setTitleColor(UIColor.init(hex: "637381"), for: .normal)
        
       self.expiredJobsButton.setTitle("Expired Jobs (12)", for: .normal)
        self.activeJobsButton.setTitle("Active Jobs (2)", for: .normal)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        activeJobsButton.isSelected=true
        activeJobsButton.addBottomBorderWithColor(color: AppTheme.defaltTheme, width: 1)
    }
    
    
    @IBAction func jobButtonAction(_ sender: UIButton) {
        sender.isSelected=true
        if sender.tag==0{
            self.expiredJobsButton.removeButtonBorderLayer()
            self.expiredJobsButton.isSelected=false
        }else{
            self.activeJobsButton.removeButtonBorderLayer()
            self.activeJobsButton.isSelected=false
        }
        sender.addBottomBorderWithColor(color: AppTheme.defaltTheme, width: 1)
        if let action=self.jobButtonAction{
            action(sender.tag)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


