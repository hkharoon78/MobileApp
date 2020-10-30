//
//  MIProfileTableHeaderView.swift
//  MonsteriOS
//
//  Created by Piyush on 16/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SDWebImage

protocol MIProfileTableHeaderDelegate:class {
    func settingBtnAction()
    func imageOptionAction()
    func enlargeImgeAction()

    func headerAddEditClicked(headerType: MIProfileEnums)
    
    func emailVerifyClicked()
    func mobileVerifyClicked()
}
extension MIProfileTableHeaderDelegate {
    func settingBtnAction(){}
    func imageOptionAction(){}
    func enlargeImgeAction(){}
    func emailVerifyClicked(){}
    func mobileVerifyClicked(){}
    func headerAddEditClicked(headerType: MIProfileEnums){}
}
class MIProfileTableHeaderView: UIView {
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var btnEmailVerify: UIButton!
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var btnContactVerify: UIButton!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblUpdateAt: UILabel!
    @IBOutlet weak var lblVisaType: UILabel!
    @IBOutlet weak var lblUserNationalityFlag: UILabel!

   // @IBOutlet weak var lblPosition: UILabel!
 //   @IBOutlet weak var lblExperience: UILabel!
    @IBOutlet weak var btnEditProfile: UIButton!
    @IBOutlet weak var profileImgActivityIndicator: UIActivityIndicatorView!

//    @IBOutlet weak var lblSalary: UILabel!
    @IBOutlet weak var lblResumeTitle: UILabel!
    
    weak var delegate:MIProfileTableHeaderDelegate?
    class var header:MIProfileTableHeaderView {
        get {
            return UINib(nibName: "MIProfileTableHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MIProfileTableHeaderView
        }
    }
    
    override func awakeFromNib() {
        self.profileImgView.circular(4, borderColor: UIColor(hex: "ffffff"))
    }
    
    func setUserProfileImage(info:MIProfilePersonalDetailInfo){
        
        if !info.avatar.isEmpty {
            self.profileImgView.isUserInteractionEnabled = true
            self.profileImgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileImgTapped)))
            
            self.profileImgView.cacheImageWithCompletion(urlString: info.avatar) {[weak wSelf = self] (image) -> () in
                wSelf?.profileImgView.removePlaceHolderIcon()
            }
            
        }else{
            self.profileImgView.image = nil
            self.profileImgView.addPlaceHolderIcon(info.fullName, font: UIFont.customFont(type: .Semibold, size: 44))

        }
    }
    
    func getSiteCountryISOCode() -> (isoCode:String,countryPhoneCode:String) {
        let site = AppDelegate.instance.site
        let sourceCountryISOCode = site?.defaultCountryDetails.isoCode ?? ""
        let mobileCountryCode = site?.defaultCountryDetails.callPrefix.stringValue ?? ""
        return (sourceCountryISOCode,mobileCountryCode)
    }
    
    func show(info:MIProfilePersonalDetailInfo) {
        self.profileImgActivityIndicator.isHidden = true
        self.lblName.text = info.fullName
        self.profileImgView.image = nil
        self.profileImgView.addPlaceHolderIcon(info.fullName, font: UIFont.customFont(type: .Semibold, size: 44))
        self.lblUpdateAt.text = (info.updateAt.count > 0) ? "Last Update On: \(info.updateAt)" : ""
//        var contactDetail = ""
        if info.mobileNumber.isEmpty {
//            contactDetail    =  "• +\(info.countryCode) \(info.mobileNumber)"
            self.lblContact.text = ""
            self.btnContactVerify.isHidden = true
        } else {
            let siteValue = self.getSiteCountryISOCode()
            var countryIsoCode = ""
            if info.countryCode.isEmpty {
                if !siteValue.countryPhoneCode.isEmpty {
                    countryIsoCode = "+" + siteValue.countryPhoneCode
                }
            }else{
                countryIsoCode = "+" + info.countryCode
            }
           
            self.lblContact.text = "\(countryIsoCode)\(info.mobileNumber)"
            self.btnContactVerify.isHidden = false
        }
        if !((info.additionPersonalInfo?.workVisaType.name ?? "").withoutWhiteSpace().isEmpty) {
            
            self.lblVisaType.text = info.additionPersonalInfo?.workVisaType.name
        }else{
            self.lblVisaType.text = ""
            info.additionPersonalInfo?.workVisaType = MICategorySelectionInfo()

        }
        if info.primaryEmail.isEmpty {
//            self.lblContact.text = "\(info.primaryEmail) \(contactDetail)"
            self.lblEmail.text  = ""
            self.btnEmailVerify.isHidden = true
        } else {
            self.lblEmail.text  = info.primaryEmail
            self.btnEmailVerify.isHidden = false
        }

        self.profileImgView.isUserInteractionEnabled = false
        self.setUserProfileImage(info: info)
        
        if info.mobileNumberVerifedStatus {
            self.btnContactVerify.setTitle("Verified", for: .normal)
            self.btnContactVerify.setTitleColor(AppTheme.greenColor, for: .normal)
            self.btnContactVerify.isEnabled = false
        } else {
            self.btnContactVerify.setTitle("Verify", for: .normal)
            self.btnContactVerify.setTitleColor(AppTheme.defaltBlueColor, for: .normal)
            self.btnContactVerify.isEnabled = true
        }
        if info.emailVerifedStatus {
            self.btnEmailVerify.setTitle("Verified", for: .normal)
            self.btnEmailVerify.setTitleColor(AppTheme.greenColor, for: .normal)
            self.btnEmailVerify.isEnabled = false
        } else {
            self.btnEmailVerify.setTitle("Verify", for: .normal)
            self.btnEmailVerify.setTitleColor(AppTheme.defaltBlueColor, for: .normal)
            self.btnEmailVerify.isEnabled = true
        }
        
        self.lblResumeTitle.text = info.profileTitle
        if let city = info.additionPersonalInfo?.cityName,!city.withoutWhiteSpace().isEmpty {
            self.lblLocation.text = city
        }else if let location = info.additionPersonalInfo?.currentlocation.name{
            self.lblLocation.text = location
        }
     //   self.lblLocation.text = (info.additionPersonalInfo?.cityName.count == 0) ?  info.additionPersonalInfo?.currentlocation.name : info.additionPersonalInfo?.cityName

        if let parentVC = self.parentViewController as? MIProfileViewController  {
            
            if let countryJsonData = parentVC.loadJson(filename: "NationalityFlagData") {
                let countryFlagData = CountryData.getCountryDataFroISOCode(code: (info.nationality.countryISOCode.withoutWhiteSpace().uppercased()), countryData: countryJsonData)
                self.lblUserNationalityFlag.text = countryFlagData.flagEmoj.isEmpty ? "" : countryFlagData.flagEmoj
            }
            
        }
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    @IBAction func imageChangeOptionClicked(_ sender: UIButton) {
        self.delegate?.imageOptionAction()
    }
    
    @IBAction func settingClicked(_ sender: UIButton) {
        self.delegate?.settingBtnAction()
    }
    
    @objc func profileImgTapped() {
        self.delegate?.enlargeImgeAction()
    }
    
    @IBAction func emailVerifyClicked(_ sender: UIButton) {
        self.delegate?.emailVerifyClicked()
    }
    
    @IBAction func mobileNumberVerifyClicked(_ sender: UIButton) {
        self.delegate?.mobileVerifyClicked()
    }
}


class MIProfileHeaderView: UIView {
    @IBOutlet weak var lblTtl: UILabel!
    @IBOutlet weak var lblSubTtl: UILabel!
    @IBOutlet weak var addEditBtn: UIButton!
    weak var delegate:MIProfileTableHeaderDelegate?
    var profileType = MIProfileEnums.skill
    
    class var header:MIProfileHeaderView {
        let headerView = UINib(nibName: "MIProfileTableHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[1] as! MIProfileHeaderView
        return headerView
        
    }
    
    func show(shouldShowSubTtl:Bool = true) {
        lblTtl.text     = profileType.headerTitle
        if shouldShowSubTtl {
            lblSubTtl.text  = profileType.headerSubTitle
        } else {
            lblSubTtl.text = ""
        }
        lblSubTtl.textColor = AppTheme.lightGrayColor
        if profileType.profileHeaderType == .edit {
            self.addEditBtn.setImage(UIImage(named: "edit"), for: .normal)
        } else if profileType.profileHeaderType == .editDelete {
            self.addEditBtn.setImage(UIImage(named: "edit_menu"), for: .normal)
        } else if profileType.profileHeaderType == .none {
            self.addEditBtn.setImage(UIImage(named: ""), for: .normal)
        }else {
            self.addEditBtn.setImage(UIImage(named: "plus"), for: .normal)
        }
    }
    
    func showAddBtn() {
        self.addEditBtn.isHidden = false
        self.addEditBtn.setImage(UIImage(named: "plus"), for: .normal)
    }
    
    func showEditBtn() {
        self.addEditBtn.isHidden = false
        self.addEditBtn.setImage(UIImage(named: "edit"), for: .normal)
    }
    func showHideAddEditBtn() {
        self.addEditBtn.isHidden = true
    }
    @IBAction func addEditClicked(_ sender: UIButton) {
        self.delegate?.headerAddEditClicked(headerType: profileType)
    }
    
}

protocol MIProfileSeeMoreFooterDelegate: class {
    func footerClicked(modelIndex:Int)
}

class MIProfileSeeMoreFooter: UIView {
    @IBOutlet weak private var titleBtn: UIButton!
    @IBOutlet weak private var emptyView: UIView!
    @IBOutlet weak private var emptyViewHeightConstraint: NSLayoutConstraint!
    
    weak var delegate:MIProfileSeeMoreFooterDelegate?
    
    class var view:MIProfileSeeMoreFooter {
        get {
            return UINib(nibName: "MIProfileTableHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[2] as! MIProfileSeeMoreFooter
        }
    }
    
    func show(ttl:String) {
        self.titleBtn.setTitle(ttl, for: .normal)
    }
    
    func hideEmptyView() {
        emptyViewHeightConstraint.constant = 0
    }
    
    func showSeeMore(shouldShowSeeMore:Bool) {
        self.titleBtn.setTitleColor(AppTheme.defaltBlueColor, for: .normal)
        if shouldShowSeeMore {
            self.titleBtn.setTitle("SEE LESS", for: .normal)
        } else {
            self.titleBtn.setTitle("SEE MORE", for: .normal)
        }
        
    }
    
    @IBAction func seeMoreClicked(_ sender: UIButton) {
        self.delegate?.footerClicked(modelIndex: self.tag)
    }
}
