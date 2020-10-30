//
//  MIAboutCompanyTableViewCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 16/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

enum CompanyOrRec{
    case company
    case recruiter
}

class MIAboutCompanyTableViewCell: UITableViewCell {

    //MARK:Outlets and Variables
    @IBOutlet weak var companyiconWidth: NSLayoutConstraint!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var companyIcon: UIImageView!
    @IBOutlet weak var recruiterActionBtn: UIButton!
    @IBOutlet weak var companyTitleLabel: UILabel!{
        didSet{
            companyTitleLabel.font=UIFont.customFont(type: .Medium, size: 16)
            companyTitleLabel.textColor=AppTheme.textColor
        }
    }
    
    @IBOutlet weak var functionalLabel: UILabel!{
        didSet{
            functionalLabel.font=UIFont.customFont(type: .Regular, size: 14)
            functionalLabel.textColor=UIColor.init(hex: "9b9b9b")
        }
    }
    @IBOutlet weak var moreJobsButton: UIButton!
    var companyDetails:CompanyDetailsModel!{
        didSet{
            self.companyTitleLabel.text=companyDetails.comapanyTitle
            self.functionalLabel.text=companyDetails.comanyFunctional
                self.companyIcon.setImage(with: companyDetails.comapanyImageURL, placeholder:compOrRec == .company ? defaultCompanyIcon : defaultRecruiterIcon)
            if compOrRec == .recruiter{
//                if companyDetails.recImageString != nil{
//                    if let thumbnail1Data =  Data(base64Encoded: companyDetails.recImageString!, options: NSData.Base64DecodingOptions()){
//                        self.companyIcon.image = UIImage(data: thumbnail1Data as Data)
//
//                        }
//                }
            }else if companyDetails.comapanyImageURL == nil || companyDetails.comapanyImageURL?.count == 0{
                self.companyiconWidth.constant=0
            }
            if !companyDetails.isFollow{
                //followButton.showAsUnfollow()
                followButton.roundCorner(1, borderColor: AppTheme.btnCTAGreenColor, rad: 2)
                followButton.backgroundColor = .white
                followButton.setTitleColor(AppTheme.btnCTAGreenColor, for: .normal)
                followButton.titleLabel?.font = UIFont.customFont(type: .Regular, size: CGFloat(14))
                followButton.setTitle(FollowAndMore.follow, for: .normal)
            }else{
                followButton.showPrimaryBtn()
                followButton.titleLabel?.font = UIFont.customFont(type: .Regular, size: CGFloat(14))
                followButton.setTitle(FollowAndMore.unfollow, for: .normal)
            }
            if !companyDetails.isFollowShow{
                self.followButton.isHidden=true
            }else{
              self.followButton.isHidden=false
            }
        }
    }
    
    var compOrRec:CompanyOrRec! = .company{
        didSet{
            moreJobsButton.setTitleColor(AppTheme.btnCTAGreenColor, for: .normal)

            switch self.compOrRec {
            case .company?:
                moreJobsButton.setTitle(FollowAndMore.moreJobs, for: .normal)
            case .recruiter?:
            //followButton.setTitle(FollowAndMore.follow, for: .normal)
            moreJobsButton.setTitle(FollowAndMore.postedJob, for: .normal)
            case .none:
                break
            }
        }
    }
    
    var comapanyDetailsAction:(()->Void)?
    var recruiterDetailsAction:(()->Void)?
    
    //MARK:Life Cycle Method
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
        self.companyIcon.applyCircular()
        self.companyIcon.image=nil
        moreJobsButton.layer.borderColor = AppTheme.btnCTAGreenColor.cgColor
        moreJobsButton.layer.borderWidth=1
        moreJobsButton.layer.cornerRadius=2
        moreJobsButton.layer.masksToBounds=false
        followButton.roundCorner(1, borderColor: AppTheme.btnCTAGreenColor, rad: 2)
        followButton.backgroundColor = .white
        followButton.setTitleColor(AppTheme.btnCTAGreenColor, for: .normal)
        followButton.titleLabel?.font = UIFont.customFont(type: .Regular, size: CGFloat(14))
        
        moreJobsButton.titleLabel?.font=UIFont.customFont(type: .Medium, size: 14)
        moreJobsButton.contentEdgeInsets=UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        followButton.titleLabel?.font=UIFont.customFont(type: .Medium, size: 14)
        followButton.contentEdgeInsets=UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        companyTitleLabel.isUserInteractionEnabled = true
        functionalLabel.isUserInteractionEnabled=true
        companyIcon.isUserInteractionEnabled=true
      
        let tapGesture=UITapGestureRecognizer(target: self, action: #selector(MIAboutCompanyTableViewCell.companyDetailsAction(_:)))
        tapGesture.numberOfTapsRequired=1
        let tapGesture1=UITapGestureRecognizer(target: self, action: #selector(MIAboutCompanyTableViewCell.companyDetailsAction(_:)))
        tapGesture1.numberOfTapsRequired=1
        let tapGesture2=UITapGestureRecognizer(target: self, action: #selector(MIAboutCompanyTableViewCell.companyDetailsAction(_:)))
        tapGesture2.numberOfTapsRequired=1
        
        companyTitleLabel.addGestureRecognizer(tapGesture)
        companyIcon.addGestureRecognizer(tapGesture1)
        functionalLabel.addGestureRecognizer(tapGesture2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        followAndUnfollowAction = nil
        moreJobsAction = nil
        followButton.roundCorner(1, borderColor: AppTheme.btnCTAGreenColor, rad: 2)
        followButton.backgroundColor = .white
        followButton.setTitleColor(AppTheme.btnCTAGreenColor, for: .normal)
        followButton.titleLabel?.font = UIFont.customFont(type: .Regular, size: CGFloat(14))

        // followButton.showAsUnfollow()
        self.companyiconWidth.constant=65
        comapanyDetailsAction  = nil
        recruiterDetailsAction = nil
        self.followButton.isHidden=false
    }
    
    var followAndUnfollowAction:((Bool)->Void)?
    var moreJobsAction:(()->Void)?
    
    @IBAction func moreJobsButtonAction(_ sender: UIButton) {
        if let action = moreJobsAction{
            action()
        }
    }
    
    @IBAction func followButtonAction(_ sender: UIButton) {
        if let action = followAndUnfollowAction{
            if self.followButton.title(for: .normal) == FollowAndMore.follow{
                action(false)
            }else{
                action(true)
            }
            
        }
    }
    
    @objc func companyDetailsAction(_ sender:UITapGestureRecognizer){
        if let action=self.comapanyDetailsAction{
            action()
        }
        
    }
    @IBAction func recruiterDetailClicked(_ sender: UIButton) {
        if let action = self.recruiterDetailsAction {
            action()
        } else if let action=self.comapanyDetailsAction{
            action()
        }
        
    }
    
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        moreJobsButton.layer.borderColor = AppTheme.btnCTAGreenColor.cgColor
//        moreJobsButton.layer.borderWidth=1
//        moreJobsButton.layer.cornerRadius=2
//        moreJobsButton.layer.masksToBounds=false
//        followButton.roundCorner(1, borderColor: AppTheme.btnCTAGreenColor, rad: 2)
//        followButton.backgroundColor = .white
//        followButton.setTitleColor(AppTheme.btnCTAGreenColor, for: .normal)
//        followButton.titleLabel?.font = UIFont.customFont(type: .Regular, size: CGFloat(14))
//
//       //followButton.showAsUnfollow()
//    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
