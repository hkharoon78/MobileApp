//
//  MIJobAppliedCompanyDetailsCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 07/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import MessageUI
class MIJobAppliedCompanyDetailsCell: UITableViewCell,MFMailComposeViewControllerDelegate {


    @IBOutlet weak var recNumHeight: NSLayoutConstraint!
    @IBOutlet weak var recEmailHeight: NSLayoutConstraint!
    @IBOutlet weak var recNameHeight: NSLayoutConstraint!
    @IBOutlet weak var recSubTitleHeight: NSLayoutConstraint!
    @IBOutlet weak var recFollowBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var recImgHeight: NSLayoutConstraint!
    @IBOutlet weak var comTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var followTitleLabel: UILabel!{
        didSet{
            followTitleLabel.numberOfLines=3
            followTitleLabel.font=UIFont.customFont(type: .Regular, size: 16)
            followTitleLabel.textColor = .black
        }
    }
    @IBOutlet weak var recuiterImageView: UIImageView!{
        didSet{
            //recuiterImageView.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet weak var recuiteNameLabel: UILabel!{
        didSet{
            recuiteNameLabel.font=UIFont.customFont(type: .Medium, size: 16)
            recuiteNameLabel.textColor=AppTheme.textColor
        }
    }
    
    @IBOutlet weak var companySubtitlelabel: UILabel!{
        didSet{
            companySubtitlelabel.font=UIFont.customFont(type: .Regular, size: 14)
            companySubtitlelabel.textColor=AppTheme.textColor
        }
    }
    @IBOutlet weak var companyNamelabel: UILabel!{
        didSet{
            companyNamelabel.font=UIFont.customFont(type: .Medium, size: 16)
            companyNamelabel.textColor=AppTheme.textColor
        }
    }
    @IBOutlet weak var companyImageView: UIImageView!{
        didSet{
           // companyImageView.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet weak var recuiterSubtitleLabel: UILabel!{
        didSet{
            recuiterSubtitleLabel.font=UIFont.customFont(type: .Regular, size: 14)
            recuiterSubtitleLabel.textColor=AppTheme.textColor
        }
    }
    
    @IBOutlet weak var recuiterNumberLabel: UILabel!{
        didSet{
            recuiterNumberLabel.font=UIFont.customFont(type: .Regular, size: 14)
            recuiterNumberLabel.textColor=AppTheme.defaltBlueColor
        }
    }
    
    @IBOutlet weak var recuiterEmailLabel: UILabel!{
        didSet{
            recuiterEmailLabel.font=UIFont.customFont(type: .Regular, size: 14)
            recuiterEmailLabel.textColor=AppTheme.defaltBlueColor
        }
    }
    
    @IBOutlet weak var recuiterFollowButton: UIButton!{
        didSet{
            recuiterFollowButton.titleLabel?.font=UIFont.customFont(type: .Regular, size: 14)
            recuiterFollowButton.contentEdgeInsets=UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
           
        }
    }
    
    @IBOutlet weak var lblUnderLine: UILabel!
    
    @IBOutlet weak var companyFollowButton: UIButton!{
        didSet{
            companyFollowButton.titleLabel?.font=UIFont.customFont(type: .Regular, size: 14)
            companyFollowButton.contentEdgeInsets=UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        }
    }
    
    var modelData:JobAppliedCompAndRecuiDetails!{
        didSet{
            
            if modelData.showCompanyAndRecruiter == 1 {
                
                self.recuiteNameLabel.text=modelData.recuiterName
                self.recuiterSubtitleLabel.text=modelData.recuiterSubtitle ?? "Recruiter"
                self.recuiterNumberLabel.text=modelData.recuiterPhone
                 self.recuiterEmailLabel.text=modelData.recuiterEmail
                if modelData.recuiterPhone == nil || modelData.recuiterPhone?.count == 0{
                    self.recNumHeight.constant=0
                }
                if modelData.recuiterEmail == nil || modelData.recuiterEmail?.count == 0{
                    self.recEmailHeight.constant=0
                }
                if modelData.recuiterIsFollow{
                    recuiterFollowButton.setTitle(FollowAndMore.unfollow, for: .normal)
                    recuiterFollowButton.showPrimaryBtn()

                    //recuiterFollowButton.showAsFollow()
                }else{
                    recuiterFollowButton.setTitle(FollowAndMore.follow,for: .normal)
                   // recuiterFollowButton.showAsUnfollow()
                    recuiterFollowButton.roundCorner(1, borderColor: AppTheme.btnCTAGreenColor, rad: 2)
                    recuiterFollowButton.backgroundColor = .white
                    recuiterFollowButton.setTitleColor(AppTheme.btnCTAGreenColor, for: .normal)
                    recuiterFollowButton.titleLabel?.font = UIFont.customFont(type: .Regular, size: CGFloat(14))
                    recuiterFollowButton.setTitle(FollowAndMore.follow, for: .normal)
                }
                
                self.recuiterImageView.setImage(with: self.modelData.recuiterImageURl, placeholder:defaultRecruiterIcon)
                 if modelData.recImageString != nil{
                     if let thumbnail1Data =  Data(base64Encoded: modelData.recImageString!, options: NSData.Base64DecodingOptions()){
                         self.recuiterImageView.image = UIImage(data: thumbnail1Data as Data)
                         
                     }
                 }
                
            } else {
                self.recuiteNameLabel.isHidden = true
                self.recuiterSubtitleLabel.isHidden = true
                self.recuiterNumberLabel.isHidden = true
                self.recuiterEmailLabel.isHidden = true
                self.recuiterFollowButton.isHidden = true
                self.recuiterImageView.isHidden = true
                self.lblUnderLine.isHidden = true
                
                self.recNumHeight.constant = 0
                self.recEmailHeight.constant = 0
                self.recNameHeight.constant = 0
                self.recSubTitleHeight.constant = 0
                self.recFollowBtnHeight.constant = 0
                self.recImgHeight.constant = 0
                self.comTopConstraint.constant = -20
                
            }
            
            //commpany
            self.companyNamelabel.text=modelData.companyName
            self.companySubtitlelabel.text=modelData.companySubtitle ?? ""
            if self.modelData.companyIsFollow{
                companyFollowButton.setTitle(FollowAndMore.unfollow, for: .normal)
                companyFollowButton.showPrimaryBtn()

                // companyFollowButton.showAsFollow()
            }else{
                companyFollowButton.setTitle(FollowAndMore.follow, for: .normal)
                companyFollowButton.roundCorner(1, borderColor: AppTheme.btnCTAGreenColor, rad: 2)
                companyFollowButton.backgroundColor = .white
                companyFollowButton.setTitleColor(AppTheme.btnCTAGreenColor, for: .normal)
                companyFollowButton.titleLabel?.font = UIFont.customFont(type: .Regular, size: CGFloat(14))
                // companyFollowButton.showAsUnfollow()
            }
            if modelData.companyName == companyConfidential{
                companyFollowButton.isHidden=true
            }
            
            self.companyImageView.setImage(with: modelData.companyImageUrl, placeholder: defaultCompanyIcon)
            
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        let tapOnPhone=UITapGestureRecognizer(target: self, action: #selector(MIJobAppliedCompanyDetailsCell.phoneNumberTapped(_:)))
        tapOnPhone.numberOfTapsRequired=1
        self.recuiterNumberLabel.isUserInteractionEnabled=true
        self.recuiterNumberLabel.addGestureRecognizer(tapOnPhone)
        
        let tapOneEmail=UITapGestureRecognizer(target: self, action: #selector(MIJobAppliedCompanyDetailsCell.emailTapped(_:)))
        tapOneEmail.numberOfTapsRequired=1
        self.recuiterEmailLabel.isUserInteractionEnabled=true
        self.recuiterEmailLabel.addGestureRecognizer(tapOneEmail)
       
    }
    
    @objc func phoneNumberTapped(_ sender:UITapGestureRecognizer){
        if self.recuiterNumberLabel.text?.count ?? 0 > 6{
            if let url = URL(string: "tel://\(self.recuiterNumberLabel.text!.withoutWhiteSpace())"),
                UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler:nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    @objc func emailTapped(_ sender:UITapGestureRecognizer){
        if self.recuiterEmailLabel.text?.isValidEmail ?? false == true{
                if MFMailComposeViewController.canSendMail() {
                    let mail = MFMailComposeViewController()
                    mail.mailComposeDelegate = self
                    mail.setToRecipients([self.recuiterEmailLabel.text!])
                    mail.setMessageBody("", isHTML: true)
                    self.parentViewController?.present(mail, animated: true)
                } else {
                    self.parentViewController?.showAlert(title: "", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", isErrorOccured: true)
                    //AKAlertController.alert("Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.")
                }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        recNumHeight.constant = 18
        recEmailHeight.constant = 18
        companyFollowButton.isHidden=false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
     var followAndUnfollowRecAction:((Bool)->Void)?
    var followAndUnfollowCompAction:((Bool)->Void)?
    @IBAction func recuiterFollowAction(_ sender: UIButton) {
        if let action = followAndUnfollowRecAction{
            if self.recuiterFollowButton.title(for: .normal) == FollowAndMore.follow{
                action(false)
            }else{
                action(true)
            }
            
        }
    }
    @IBAction func companyFollowAction(_ sender: UIButton) {
        if let action = followAndUnfollowCompAction{
            if self.companyFollowButton.title(for: .normal) == FollowAndMore.follow{
                action(false)
            }else{
                action(true)
            }
            
        }
    }
    
}


class JobAppliedCompAndRecuiDetails{
    var recuiterName:String?
    var recuiterSubtitle:String?
    var recuiterEmail:String?
    var recuiterPhone:String?
    var recuiterIsFollow:Bool=false
    var recuiterImageURl:String?
    var companyName:String?
    var companySubtitle:String?
    var companyImageUrl:String?
    var companyIsFollow:Bool=false
    var recImageString:String?
    var showCompanyAndRecruiter:Int? = 0
    
    init(model:JoblistingData) {
        self.recuiterName=model.recruiter?.name ?? model.recruiterName
        self.recuiterEmail=model.showContactDetails == 1 ? model.recruiter?.email : ""
        self.recuiterPhone=model.showContactDetails == 1 ? model.recruiterContactNumber : ""
        self.recuiterIsFollow=model.isRecruiterFollow ?? false
        self.recuiterSubtitle=model.recruiter?.designations
        self.recuiterImageURl=model.recruiter?.avatarUrl
        self.companyName=model.company?.name
        self.companySubtitle=model.company?.industries?.joined(separator: ", ")
        self.companyImageUrl=model.isSearchLogo==1 ? model.company?.logo : nil
        self.companyIsFollow=model.isCompanyFollow ?? false
        self.recImageString=model.recruiter?.imageData?.imageData        
        
        if model.hideCompanyName == 0 {
            self.showCompanyAndRecruiter = 0
            if model.recruiter?.kiwiSocialId != nil {
                 self.showCompanyAndRecruiter = 1
            }
        }
    }
    
    init(recuiterName:String?,recuiterSubtitle:String?,recuiterPhone:String?,recuiterEmail:String?,recuiterIsFollow:Bool,companyName:String?,companySubtitle:String?,companyIsFollow:Bool) {
        self.recuiterName=recuiterName
        self.recuiterSubtitle=recuiterSubtitle
        self.recuiterPhone=recuiterPhone
        self.recuiterEmail=recuiterEmail
        self.recuiterIsFollow=recuiterIsFollow
        self.companyName=companyName
        
        self.companySubtitle=companySubtitle
        self.companyIsFollow=companyIsFollow
    }
}
