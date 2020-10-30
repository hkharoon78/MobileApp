//
//  MICreateAlertTableViewCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 24/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class MICreateAlertTableViewCell: UITableViewCell {
    var shapeType = shape.none

    @IBOutlet weak var floatingTextField: JVFloatLabeledTextField!{
        didSet{
            floatingTextField.font=UIFont.customFont(type: .Regular, size: 16)
            floatingTextField.placeholderColor = UIColor.lightGray
            floatingTextField.textColor=AppTheme.textColor
            floatingTextField.floatingLabelFont=UIFont.customFont(type: .Regular, size: 14)

        }
    }
    
    @IBOutlet weak var seprator_View : UIView!
    @IBOutlet weak var infoQuestion_Btn : UIButton!

    @IBOutlet weak var trailingConstraint : NSLayoutConstraint! 
    @objc func textFieldTapAction(_ sender: UITapGestureRecognizer) {
    }
    
    var infoPopCallBack : (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showData(obj:MIUserModel, title:String, registerVia: RegisterVia) {
        self.floatingTextField.isUserInteractionEnabled = true
        self.floatingTextField.isEnabled = true
        self.floatingTextField.alpha = 1.0
       // self.contentView.alpha = 1.0
        self.accessoryType = .none
       
        switch title {
        case RegisterViewStoryBoardConstant.fullName:
            self.floatingTextField.text = obj.userFullName
            
        case RegisterViewStoryBoardConstant.currentLocation:
            self.floatingTextField.text = obj.userlocationModal.name
            self.accessoryType = .disclosureIndicator
            self.floatingTextField.isUserInteractionEnabled = false
            
        case RegisterViewStoryBoardConstant.password:
            self.floatingTextField.text = obj.userPassword
            
        case RegisterViewStoryBoardConstant.email:
            if (registerVia == .Facebook || registerVia == .Google) && !obj.userEmail.isEmpty {
                self.floatingTextField.isUserInteractionEnabled = false
                self.floatingTextField.isEnabled = false
                self.floatingTextField.alpha = 0.5
            }
            self.floatingTextField.text = obj.userEmail
            
        case RegisterViewStoryBoardConstant.experienceLevel:
            self.accessoryType = .disclosureIndicator
            self.floatingTextField.text = (obj.userProfessionalType == .None) ? "" :  obj.userProfessionalType.rawValue
            self.floatingTextField.isUserInteractionEnabled = false
            
        case RegisterViewStoryBoardConstant.nationality:
            self.accessoryType = .disclosureIndicator
            self.floatingTextField.text = obj.nationalityModal.name
            self.floatingTextField.isUserInteractionEnabled = false
            
        default:
            self.floatingTextField.text = ""
        }
    }
    
    func populateRegisterUserData(registerUser:MIUserModel,fieldTitle:String,registerVia:RegisterVia){
        self.floatingTextField.placeholder = fieldTitle
        self.floatingTextField.isUserInteractionEnabled = true
        self.floatingTextField.isEnabled = true
        self.floatingTextField.alpha = 1.0

        switch fieldTitle {
            case RegisterViewStoryBoardConstant.fullName:
                self.floatingTextField.text = registerUser.userFullName
           case RegisterViewStoryBoardConstant.cityName:
                self.floatingTextField.text = registerUser.cityName
            case RegisterViewStoryBoardConstant.email:
                self.floatingTextField.text = registerUser.userEmail
                if registerVia != .None && registerUser.userEmail.count != 0 {
                    self.floatingTextField.isEnabled = false
                    self.floatingTextField.alpha =  0.5
                    self.floatingTextField.isUserInteractionEnabled = false
                }
            case RegisterViewStoryBoardConstant.totalExperience: 
                if registerUser.userProfessionalType == .Fresher {
                    self.floatingTextField.text = registerUser.userProfessionalType.rawValue
                }else if registerUser.userProfessionalType == .Experienced {
                    self.floatingTextField.text = self.getExperienceInYearMonth(user: registerUser)
                }else{
                    self.floatingTextField.text = ""

                }
                self.floatingTextField.isUserInteractionEnabled = false
            case RegisterViewStoryBoardConstant.nationality:
                self.floatingTextField.text = registerUser.nationalityModal.name
            default:
                self.floatingTextField.text = ""
        }
    }
    func getExperienceInYearMonth(user:MIUserModel) -> String {
        var workExp = ""
        
        if user.userExperienceInYear == "0" || user.userExperienceInYear == "1"  {
            workExp = user.userExperienceInYear + " " + "Year"
        }else{
            workExp = user.userExperienceInYear + " " + "Years"

        }
        if user.userExperienceInMonth == "0" || user.userExperienceInMonth == "1"  {
            workExp = workExp + " " + user.userExperienceInMonth + " " + "Month"
        }else{
            workExp = workExp + " " + user.userExperienceInMonth + " " + "Months"

            
        }
        return workExp
    }
    func manageFont(){
        self.floatingTextField.floatingLabelFont = UIFont.customFont(type: .Regular, size: 12 )
        self.floatingTextField.font = UIFont.customFont(type: .Regular, size: 13)
    }
    
    func showEducationData(obj:MIEducationInfo ,title:String,sectionIndex:Int){
      
        self.floatingTextField.placeholder = title
        
        if title == MIEducationDetailViewControllerConstant.highestQualification  {
            self.floatingTextField.text =  obj.highestQualificationObj.name
            self.floatingTextField.placeholder = (sectionIndex == 0) ? "Highest Qualification" : "Other Qualification"
        }else if title == MIEducationDetailViewControllerConstant.specialisation {
            self.floatingTextField.text = obj.specialisationObj.name
            
        }else  if title == MIEducationDetailViewControllerConstant.instituteName {
            self.floatingTextField.text = obj.collegeObj.name
            
        }else if title == MIEducationDetailViewControllerConstant.passignYear {
            self.floatingTextField.text = obj.year
            
        }else if title == MIEducationDetailViewControllerConstant.educationType {
            self.floatingTextField.text = obj.educationTypeObj.name
            
        }else if title == MIEducationDetailViewControllerConstant.board {
        //    self.floatingTextField.placeholder = MIEducationDetailViewControllerConstant.board
            self.floatingTextField.text = obj.boardObj.name
            
        }else if title == MIEducationDetailViewControllerConstant.percentage {
         //   self.floatingTextField.placeholder = MIEducationDetailViewControllerConstant.percentage
            self.floatingTextField.text = obj.percentage
        }else if title == MIEducationDetailViewControllerConstant.medium {
            self.floatingTextField.text = obj.mediumObj.name
        }
    }
    
    func showEmploymentForUser(model:MIEmploymentDetailInfo,title:String,sectionIndex:Int) {
        self.floatingTextField.placeholder = title
        self.floatingTextField.isUserInteractionEnabled = false
        switch title {
            case MIEmploymentDetailViewControllerConstant.jobDesignation:
                self.floatingTextField.text = model.designationObj.name
                self.floatingTextField.placeholder = (sectionIndex == 0) ? "Most Recent Designation" : "Other Designation"
            case MIEmploymentDetailViewControllerConstant.companyName:
                self.floatingTextField.text = model.companyObj.name
                self.floatingTextField.placeholder = (sectionIndex == 0) ? "Most Recent Company" : "Other Company"
            case MIEmploymentDetailViewControllerConstant.servingNoticePeroid:
                self.floatingTextField.text = model.noticePeroidDuration
            case MIEmploymentDetailViewControllerConstant.lastWorkingDay:
                self.floatingTextField.text = model.lastWorkingDate?.getStringWithFormat(format: "dd MMM, yyyy")
            case MIEmploymentDetailViewControllerConstant.offeredDesignation:
                self.floatingTextField.text = model.offeredDesignationObj.name
            case MIEmploymentDetailViewControllerConstant.newCompanyName:
                self.floatingTextField.text = model.newCompanyObj.name
            case MIEmploymentDetailViewControllerConstant.noticePeroid:
                self.floatingTextField.text = model.noticePeroidDuration
            
            default:
                self.floatingTextField.text = ""
        }
    }
    
    @IBAction func infoBtnAction(_ sender:UIButton) {
        self.infoPopCallBack?()
    }
    func showInfoPopup(infoMsg:String) {
        let controller = MIInfoPopOverController()
        controller.message = infoMsg
        controller.preferredContentSize = CGSize(width: self.bounds.size.width, height: 110)
        
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = self.infoQuestion_Btn
        presentationController.sourceRect = self.infoQuestion_Btn.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.superview?.parentViewController?.present(controller, animated: true)
    }
}
