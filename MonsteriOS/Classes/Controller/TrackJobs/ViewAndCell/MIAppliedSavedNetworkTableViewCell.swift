//
//  MIAppliedSavedNetworkTableViewCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 21/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIAppliedSavedNetworkTableViewCell: UITableViewCell {

    //MARK:Outlets And Variables
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var skillsLabel: UILabel!
    @IBOutlet weak var bottomTitleLabel: UILabel!{
        didSet{
            bottomTitleLabel.font=UIFont.customFont(type: .Regular, size: 13)
        }
    }
    @IBOutlet weak var companyIcon: UIImageView!
    @IBOutlet weak var companyIconWidth: NSLayoutConstraint!
    
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var experienceIcon: UIImageView!
    @IBOutlet weak var skillsIcon: UIImageView!
    @IBOutlet weak var bottomIcon: UIImageView!
    var comapanyDetailsAction:(()->Void)?
    var appliedJobModel:AppliedJobModel!{
        didSet{
            self.jobTitleLabel.text=appliedJobModel.jobTitle
            self.companyLabel.text=appliedJobModel.companyTitle
            self.locationLabel.text=appliedJobModel.locationTitle
            self.bottomTitleLabel.text=appliedJobModel.appliedSuccesTitle
            self.skillsLabel.text="User Interface, User Experience, Design,Sketch, Wireframes, Prototyping,Information Architecture, Visual Design"
            self.experienceLabel.text="2-7 Years"
            self.companyIcon.isHidden=false
            self.companyIcon.image=defaultCompanyIcon
        }
    }
    
    var trackJobType:TrackJobsType = .applied{
        didSet{
            switch self.trackJobType {
            case .applied:
                self.bottomIcon.image=#imageLiteral(resourceName: "upload_resume_icon")
            case .saved:
                self.bottomIcon.image=#imageLiteral(resourceName: "saveoutline")
            case .viewed:
                self.bottomIcon.isHidden=true
                self.bottomIcon.image=#imageLiteral(resourceName: "saveoutline")
            case .jobAlert:
                self.bottomIcon.image=#imageLiteral(resourceName: "saveoutline")
           
            }
        }
    }
    
    //MARK:Life Cycle Method
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUpUI()
        
    }

    func setUpUI(){
        jobTitleLabel.font=UIFont.customFont(type: .Medium, size: 16)
        jobTitleLabel.textColor=AppTheme.textColor//UIColor.init(hex: "212B36")
        companyLabel.font=UIFont.customFont(type: .Medium, size: 14)
        companyLabel.textColor=Color.colorDefault
        locationLabel.font=UIFont.customFont(type: .Regular, size: 14)
        locationLabel.textColor=AppTheme.textColor//UIColor.init(hex: "212B36")
        experienceLabel.font=UIFont.customFont(type: .Regular, size: 14)
        experienceLabel.textColor=AppTheme.textColor//UIColor.init(hex: "212B36")
        skillsLabel.font=UIFont.customFont(type: .Regular, size: 14)
        skillsLabel.textColor=AppTheme.textColor//UIColor.init(hex: "212B36")
        experienceIcon.image=#imageLiteral(resourceName: "jobexp-ico")
        locationIcon.image=#imageLiteral(resourceName: "search_location_icon")
        skillsIcon.image=#imageLiteral(resourceName: "skill-ico")
        companyIcon.isHidden=true
        companyLabel.isUserInteractionEnabled=true
        let tapGesture=UITapGestureRecognizer(target: self, action: #selector(MIAppliedSavedNetworkTableViewCell.companyDetailsAction(_:)))
        tapGesture.numberOfTapsRequired=1
        companyLabel.addGestureRecognizer(tapGesture)
        self.topView.addShadow(opacity: 0.2)
        self.contentView.backgroundColor = AppTheme.viewBackgroundColor//UIColor.init(hex: "f4f6f8")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.jobTitleLabel.text=nil
        self.companyLabel.text=nil
        self.locationLabel.text=nil
        self.experienceLabel.text=nil
        self.skillsLabel.text=nil
        
    }
    @objc func companyDetailsAction(_ sender:UITapGestureRecognizer){
        if let action=comapanyDetailsAction{
            action()
        }
    }
}
