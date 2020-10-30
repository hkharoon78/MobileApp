//
//  MIJobListingTableCell.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 22/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SwipeCellKit
let defaultCompanyIcon = #imageLiteral(resourceName: "ic-companyPlaceHolder")//UIImage()
let defaultRecruiterIcon=#imageLiteral(resourceName: "Icon-Deafult_Profile")
class MIJobListingTableCell: SwipeTableViewCell {
    
    @IBOutlet weak var compImageWidth: NSLayoutConstraint!
    
    let selectedIcon=#imageLiteral(resourceName: "check-illustration")
    let unselectedIcon=#imageLiteral(resourceName: "off-2")
    
    @IBOutlet weak var proLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var walkInProLabel: UILabel!
    @IBOutlet weak var selectedImageWidth: NSLayoutConstraint!
    @IBOutlet weak var selectedImageLeading: NSLayoutConstraint!
    @IBOutlet weak var selectedImageIcon: UIImageView!
    @IBOutlet weak var freshOrCrownIcon: UIImageView!
    @IBOutlet weak var companyIcon: UIImageView!
    
    @IBOutlet weak var summaryTitle: UILabel!{
        didSet{
            summaryTitle.font = UIFont.customFont(type: .Medium, size: 16)
            summaryTitle.textColor=AppTheme.textColor
        }
    }
    
    @IBOutlet weak var companyNameTitle: UILabel!{
        didSet{
            companyNameTitle.font = UIFont.customFont(type: .Medium, size: 14)
            companyNameTitle.textColor = AppTheme.defaltBlueColor
        }
    }
    @IBOutlet weak var skillTitle: UILabel!{
        didSet{
            skillTitle.font = UIFont.customFont(type: .Regular, size: 14)
            skillTitle.textColor = AppTheme.textColor
        }
    }
    @IBOutlet weak var locationTitle: UILabel!{
        didSet{
            locationTitle.font = UIFont.customFont(type: .Regular, size: 14)
            locationTitle.textColor = AppTheme.textColor
        }
    }
    @IBOutlet weak var experienceTitle: UILabel!{
        didSet{
            experienceTitle.font = UIFont.customFont(type: .Regular, size: 14)
            experienceTitle.textColor = AppTheme.textColor
        }
    }
    
    @IBOutlet weak var postedDatelabel: UILabel!{
        didSet{
            postedDatelabel.font = UIFont.customFont(type: .Regular, size: 14)
            postedDatelabel.textColor = UIColor.init(hex: "9B9B9B")
        }
    }
    var isSelectionEnable=false{
        didSet{
            if isSelectionEnable{
                self.selectedImageWidth.constant=30
                self.selectedImageLeading.constant=15
                self.selectedImageIcon.isHidden=false
                
            }else{
                self.selectedImageWidth.constant=0
                self.selectedImageLeading.constant=0
                self.selectedImageIcon.isHidden=true
            }
        }
    }
    var modelData:JoblistingCellModel!{
        didSet{
            self.summaryTitle.text = modelData.summary
            self.companyNameTitle.text = modelData.companyTitle
            self.locationTitle.text = modelData.locationTitle
            self.skillTitle.text = modelData.allSkills.map({$0.name}).joined(separator: ", ")
            self.experienceTitle.text = modelData.experienceTitle
            self.postedDatelabel.text = modelData.postedDate
            if modelData.locationMoreString != nil {
             let locationTitle = NSMutableAttributedString(string:modelData.locationTitle ?? "N/A", attributes: [NSAttributedString.Key.foregroundColor:AppTheme.textColor,NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 14)])
                 locationTitle.append(NSAttributedString(string:modelData.locationMoreString!, attributes: [NSAttributedString.Key.foregroundColor:AppTheme.defaltBlueColor,NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 14)]))
                self.locationTitle.attributedText = locationTitle
            }
            self.companyIcon.setImage(with: modelData.companyIconURL, placeholder: defaultCompanyIcon)
            if modelData.companyIconURL == nil{
                compImageWidth.constant=0
            }
            if modelData.isSelected {
                self.selectedImageIcon.image = selectedIcon
            }else {
                self.selectedImageIcon.image = unselectedIcon
            }
            if modelData.isWalkIn {
                self.postedDatelabel.text = modelData.walkInDate
            }
            if modelData.isWalkInPro || modelData.isSJSJob {
                self.walkInProLabel.isHidden = false
                self.proLabelHeight.constant = 30
                if modelData.isSJSJob{
                    self.walkInProLabel.text = "    Sponsored    "
                }else{
                    self.walkInProLabel.text = "    WalkInPro    "
                }
            }else {
                self.walkInProLabel.isHidden = true
                self.proLabelHeight.constant = 0
            }
            if modelData.isSavedJob {
                savedButton.setImage(savedIcon, for: .normal)
            }else{
                savedButton.setImage(unSavedIcon, for: .normal)
            }
            
            if modelData.isAppliedJob{
                self.postedDatelabel.textColor = AppTheme.greenColor
                self.postedDatelabel.text = modelData.postedDate
                //self.enable(on: false)
            }
            if modelData.isViewed{
                self.enable(on: false)
            }
        }
    }
    
    @IBOutlet weak var savedButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectedImageWidth.constant = 0
        self.selectedImageLeading.constant = 0
        self.selectedImageIcon.isHidden = true
        self.selectionStyle = .none
        self.walkInProLabel.backgroundColor = AppTheme.defaltBlueColor
        self.walkInProLabel.layer.cornerRadius = 10
        self.walkInProLabel.layer.masksToBounds = true
        self.selectedImageIcon.image = nil
        let tapGesture=UITapGestureRecognizer(target: self, action:#selector(MIJobListingTableCell.cellSelection(_:)))
        tapGesture.numberOfTapsRequired = 1
        self.selectedImageIcon.isUserInteractionEnabled = true
        self.selectedImageIcon.addGestureRecognizer(tapGesture)
        //   savedButton.setImage(nil, for: .normal)
        savedButton.addTarget(self, action: #selector(MIJobListingTableCell.saveButtonAction(_:)), for: .touchUpInside)
//        self.locationTitle.isUserInteractionEnabled=true
//        let locationTap=UITapGestureRecognizer(target: self, action: #selector(showLocationPopup))
//        locationTap.numberOfTapsRequired=1
//        self.locationTitle.addGestureRecognizer(locationTap)
        
    }
    
    @objc func showLocationPopup(){
        if self.locationTitle.text?.contains(modelData.locationMoreString ?? "more") ?? false{
        let controller = MILocationMoreViewController()
            controller.preferredContentSize = CGSize(width: 300, height: 200)
        showPopup(controller, sourceView: self.locationTitle)
        }
    }
    
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.superview?.parentViewController?.present(controller, animated: true)
    }
    var saveUnSaveAction:((Bool)->Void)?
    @objc func saveButtonAction(_ sender:UIButton){
        if AppDelegate.instance.authInfo.accessToken.isEmpty{
            if let vc=self.superview?.parentViewController{
                self.saveUnSaveAction?(false)
                vc.showLoginAlert(msg: "Please log in to continue.",navaction: .save,jobId:String(modelData.jobId ?? 0))
            }
            //
        }else{
            if sender.image(for: .normal) == savedIcon{
                self.saveUnSaveApiCall(path: APIPath.unsaveJob, sender: sender)
            }else{
                self.saveUnSaveApiCall(path: APIPath.saveJob, sender: sender)
            }
        }
    }
    
    func saveUnSaveApiCall(path:String, sender:UIButton){
        
        
        
        let _ = MIAPIClient.sharedClient.load(path:path, method: path==APIPath.saveJob ? .post : .delete, params: ["jobId":String(self.modelData.jobId ?? 0)]) { (responseData, error,code) in
            if error != nil{
                 if code==401{
                    //self.superview?.parentViewController?.logoutToLogin()

                }
                return
            }else{
                DispatchQueue.main.async {

                    isSavedOrUnsaved=true
                    if path==APIPath.saveJob{
                        //sender.setImage(unSavedIcon, for: .normal)
                        self.saveUnSaveAction?(true)
                         self.savedButton.setImage(savedIcon, for: .normal)
                    }else{
                        self.saveUnSaveAction?(false)
                        self.savedButton.setImage(unSavedIcon, for: .normal)
                    }
                }
            }
        }
    }
    

    
    
    var cellSelectionAction:(()->Void)?
    @objc func cellSelection(_ sender:UITapGestureRecognizer){
        if let action=self.cellSelectionAction{
            action()
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.selectedImageIcon.image = nil
        self.compImageWidth.constant=70
        self.postedDatelabel.textColor = UIColor.init(hex: "9B9B9B")
        // self.savedButton.setImage(nil, for: .normal)
        cellSelectionAction = nil
        saveUnSaveAction = nil
        self.enable(on: true)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}





extension MIJobListingTableCell {
    func enable(on: Bool) {
        //self.isUserInteractionEnabled = on
        for view in contentView.subviews {
            if let imgView=view as? UIImageView{
                if imgView == self.companyIcon{
                    continue
                }
            }
            if  view is UIButton{
                continue
            }
            view.alpha = on ? 1 : 0.5
        }
    }
}

func formatPostedDate(dateValue:Int,titl:String)->String{
    var postedDate=titl
    let appliedDate=Date(timeIntervalSince1970: Double(dateValue/1000))
    
    let components = Calendar.current.dateComponents([.year, .month,.day,.minute], from: Calendar.current.startOfDay(for:appliedDate), to: Calendar.current.startOfDay(for:Date()))
   
    if components.month != nil,components.month! > 0{
        if components.month == 1 && components.day == 0 && components.year == 0{
            postedDate=titl + "\(components.month!)" + SRPListingStoryBoardConstant.monthago
        }else{
           postedDate = titl + "30+" + SRPListingStoryBoardConstant.daysAgo

            // postedDate=titl + "\(components.month!)" + SRPListingStoryBoardConstant.monthsago
        }
    }else if components.day != nil{
        if components.day! == 0 {
            postedDate=titl + SRPListingStoryBoardConstant.today
        }else{
            if components.day == 1{
                postedDate = titl + "\(components.day!)" + SRPListingStoryBoardConstant.dayAgo
            }else{
                postedDate = titl + "\(components.day!)" + SRPListingStoryBoardConstant.daysAgo
            }
        }
    }
    return postedDate
}
