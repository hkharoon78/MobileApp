//
//  MISwipableCardView.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 27/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MISwipableCardView: UIView {

    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var skillsLabel: UILabel!
    @IBOutlet weak var applyIcon: UIImageView!
    @IBOutlet weak var skipIcon: UIImageView!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var applySkipVIewHeight: NSLayoutConstraint!
    @IBOutlet weak var applySkipView: UIView!
    var applySkipAction:((Bool)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        skipIcon.isHidden=true
        applyIcon.isHidden=true
        applySkipView.isHidden=true
        applySkipVIewHeight.constant=0
        //applyButton.setTitle("Apply", for: .normal)
        skipButton.setTitle("Skip", for: .normal)
        skipButton.setTitleColor(AppTheme.btnCTAGreenColor, for: .normal)
        companyLabel.textColor = AppTheme.defaltBlueColor
        //applyButton.showAsFollow()
        applyButton.showPrimaryBtn()
        self.skipButton.roundCorner(1, borderColor: AppTheme.btnCTAGreenColor, rad: 5)
        self.roundCorner(1, borderColor: UIColor(hex: "dddddd"), rad: 5)
    }
    
    @IBAction func applyButtonAction(_ sender: UIButton) {
        if let action=self.applySkipAction{
            action(true)
        }
    }
    
    @IBAction func skipButtonAction(_ sender: UIButton) {
        if let action=self.applySkipAction{
            action(false)
        }
    }
    
    
    func showData(_ item: JoblistingCellModel) {
        
        self.jobTitleLabel.text   = item.summary
        self.companyLabel.text    = item.companyTitle
        self.locationLabel.text   = item.locationTitle
        self.experienceLabel.text = item.experienceTitle
        self.skillsLabel.text     = item.allSkills.map({$0.name}).joined(separator: ", ")
        if item.isAppliedJob {
           // applyButton.isUserInteractionEnabled = false
            applyButton.setTitle("Applied", for: .normal)
        }else{
          //  applyButton.isUserInteractionEnabled = true
            applyButton.setTitle("Apply", for: .normal)

        }
    }
}
