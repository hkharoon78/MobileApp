//
//  MIRecuiterAndCompanyTopTableViewCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 05/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit


class MIRecuiterAndCompanyTopTableViewCell: UITableViewCell {
       
    @IBOutlet weak var companyIconWidth: NSLayoutConstraint!
    @IBOutlet weak var recuiterImageView: UIImageView!{
        didSet{
            recuiterImageView.applyCircular()
        }
    }
    
    @IBOutlet weak var recuiterNameLabel: UILabel!{
        didSet{
            recuiterNameLabel.font=UIFont.customFont(type: .Medium, size: 16)
            recuiterNameLabel.textColor=AppTheme.textColor
        }
    }
    
    @IBOutlet weak var companyNameLabel: UILabel!{
        didSet{
            companyNameLabel.font=UIFont.customFont(type: .Regular, size: 14)
        }
    }
    
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!{
        didSet{
            followButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom:5, right: 10)
        }
    }
    
    var recuiterOrCompany:RecuiterOrCompany = .recuiter{
        didSet{
            switch recuiterOrCompany {
            case .recuiter:
                companyNameLabel.textColor=AppTheme.defaltBlueColor
                followerLabel.textColor=UIColor.init(hex: "637381")
                companyNameLabel.font=UIFont.customFont(type: .Medium, size: 14)
            case .company:
                companyNameLabel.textColor=UIColor.init(hex: "9b9b9b")
                followerLabel.textColor=UIColor.init(hex: "9b9b9b")
                companyNameLabel.font=UIFont.customFont(type: .Regular, size: 14)
                followerLabel.textColor=UIColor.init(hex: "9b9b9b")
            }
        }
    }
    
    
    var companyDetails:CompanyDetailsModel!{
        didSet{
            self.recuiterNameLabel.text=companyDetails.comapanyTitle
            self.companyNameLabel.text=companyDetails.compLocation
            self.followerLabel.text=companyDetails.comanyFunctional
           
            self.recuiterImageView.setImage(with: companyDetails.comapanyImageURL, placeholder:recuiterOrCompany == .company ? defaultCompanyIcon : defaultRecruiterIcon)
           
            if !companyDetails.isFollow{
                //followButton.showAsUnfollow()
                followButton.roundCorner(1, borderColor: AppTheme.btnCTAGreenColor, rad: 2)
                followButton.backgroundColor = .white
                followButton.setTitleColor(AppTheme.btnCTAGreenColor, for: .normal)
                followButton.titleLabel?.font = UIFont.customFont(type: .Regular, size: CGFloat(14))
                followButton.setTitle(FollowAndMore.follow, for: .normal)
                //followButton.setTitle(FollowAndMore.follow, for: .normal)
            }else{
                followButton.showPrimaryBtn()
                // followButton.showAsFollow()
                followButton.setTitle(FollowAndMore.unfollow, for: .normal)
            }
            
            if recuiterOrCompany == .recuiter {
                let followCount=NSMutableAttributedString(string:companyDetails.comanyFunctional ?? "0", attributes: [NSAttributedString.Key.foregroundColor:UIColor.init(hex: "637381"),NSAttributedString.Key.font:UIFont.customFont(type: .Semibold, size: 14)])
                followCount.append(NSAttributedString(string:" Followers", attributes: [NSAttributedString.Key.foregroundColor:UIColor.init(hex: "637381"),NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 14)]))
                followerLabel.attributedText=followCount
//                if companyDetails.recImageString != nil{
//                    if let thumbnail1Data =  Data(base64Encoded: companyDetails.recImageString!, options: NSData.Base64DecodingOptions()){
//                        self.recuiterImageView.image = UIImage(data: thumbnail1Data as Data)
//                        
//                    }
//                }
            }else if companyDetails.comapanyImageURL == nil || companyDetails.comapanyImageURL?.count==0{
                self.companyIconWidth.constant=0
            }
        }
        
    }
    
    var modelData: RecuiterOrCompanyDetailsTopViewModel!{
        didSet{
            self.recuiterNameLabel.text=modelData.compOrRecuiName
            self.companyNameLabel.text=modelData.locationOrComName
            if self.recuiterOrCompany == .recuiter{
                let followCount=NSMutableAttributedString(string:modelData.noOfFollowOrComp ?? "0", attributes: [NSAttributedString.Key.foregroundColor:UIColor.init(hex: "637381"),NSAttributedString.Key.font:UIFont.customFont(type: .Semibold, size: 14)])
                followCount.append(NSAttributedString(string:"Followers", attributes: [NSAttributedString.Key.foregroundColor:UIColor.init(hex: "637381"),NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 14)]))
                followerLabel.attributedText=followCount
            }else{
                followerLabel.text="Company"
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        followButton.layer.borderColor=AppTheme.btnCTAGreenColor.cgColor
        followButton.layer.borderWidth = 1
        followButton.layer.cornerRadius = 2
        followButton.backgroundColor = .white
        followButton.layer.masksToBounds=false
        followButton.setTitleColor(AppTheme.defaltTheme, for: .normal)
        followButton.setTitle("Follow", for: .normal)
        self.recuiterImageView.image = #imageLiteral(resourceName: "Spark-Hire-Reasons-To-Find-A-New-Recruiter-870x400")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.companyNameLabel.text=nil
        self.recuiterNameLabel.text=nil
        self.followerLabel.attributedText=nil
        self.companyIconWidth.constant=70
        //self.followButton.setTitle(nil, for: .normal)
    }
   
    var followAndUnfollowAction:((Bool)->Void)?
  
    @IBAction func followButtonAction(_ sender: UIButton) {
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            if let action = self.followAndUnfollowAction{
//                   if self.followButton.title(for: .normal) == FollowAndMore.follow{
//                       action(false)
//                   }else{
//                       action(true)
//                   }
//                   
//               }
//        }
      
        if let action = followAndUnfollowAction{
            if self.followButton.title(for: .normal) == FollowAndMore.follow{
                action(false)
            }else{
                action(true)
            }

        }
        
        
    }
    
}


class RecuiterOrCompanyDetailsTopViewModel{
    var compOrRecuiName:String? = ""
    var locationOrComName:String? = ""
    var noOfFollowOrComp:String? = ""
    init(compOrRecuiName:String?,locationOrComName:String?,noOfFollowOrComp:String?) {
        self.compOrRecuiName=compOrRecuiName
        self.locationOrComName=locationOrComName
        self.noOfFollowOrComp=noOfFollowOrComp
    }
}
