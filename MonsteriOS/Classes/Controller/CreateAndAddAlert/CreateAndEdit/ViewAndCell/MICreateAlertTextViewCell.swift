//
//  MICreateAlertTextViewCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 26/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField.JVFloatLabeledTextView

class MICreateAlertTextViewCell: UITableViewCell {

    @IBOutlet weak var keySkillTextView: JVFloatLabeledTextView!{
        didSet{
            keySkillTextView.font = UIFont.customFont(type: .Regular, size: 16)
            keySkillTextView.placeholderTextColor = UIColor.lightGray
            keySkillTextView.textColor = AppTheme.textColor
            keySkillTextView.floatingLabelFont = UIFont.customFont(type: .Regular, size: 14)
            keySkillTextView.isScrollEnabled = false
            self.resize(textView: keySkillTextView)
        }
    }
    
    @IBOutlet weak var textViewTrailingConstraint:NSLayoutConstraint!
    @IBOutlet weak var btn_questionMark:UIButton!
    @IBOutlet weak var lbl_infoData:UILabel!
    @IBOutlet weak var view_seprator:UIView!
    var showPopUpCallBack : (()->Void)?
    fileprivate func resize(textView: UITextView) {
        var newFrame = textView.frame
        let width = newFrame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: width,
                                                   height: CGFloat.greatestFiniteMagnitude))
        newFrame.size = CGSize(width: width, height: newSize.height)
        textView.frame = newFrame
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func showDataForAdvanceSearch(title:String,advanceSearch:MIAdvanceSearchlDetail) {

        var infoData = ""
        var value = ""
        keySkillTextView.placeholder = title
        btn_questionMark.isHidden = true
        lbl_infoData.isHidden = false
        view_seprator.isHidden = false
        textViewTrailingConstraint.constant = 15
        keySkillTextView.textContainer.maximumNumberOfLines = 0
     
        switch title {
            case PersonalTitleConstant.jobKeyword:
                    value = (advanceSearch.skill.map { $0 }).joined(separator: ",")
            case PersonalTitleConstant.location:
                    value = (advanceSearch.location.map { $0.name }).joined(separator: ",")
                    infoData = "You can add max 5 locations"
            case PersonalTitleConstant.year:
                    if advanceSearch.workExperience.count > 0 {
                        value = advanceSearch.workExperience + " year"
                    }
                //        case PersonalTitleConstant.salary:
            //            textField.text = searchInfo.currentSalary.salaryCurrency
            case PersonalTitleConstant.industry:
                    value = (advanceSearch.industry.map { $0.name }).joined(separator: ",")
                    infoData = "You can add max 2 industries"
            case PersonalTitleConstant.function:
                    value = (advanceSearch.function.map { $0.name }).joined(separator: ",")
                    infoData = "You can add max 2 function"
            default:
                 infoData = ""
                 value = ""

        }
       
        lbl_infoData.text = infoData
        keySkillTextView.text = value

    }
    func showJobPreferenceInfoData(title:String,jobPreferences:MIJobPreferencesModel) {
        var infoData = ""
        var value = ""
        keySkillTextView.placeholder = title
        btn_questionMark.isHidden = false
        lbl_infoData.isHidden = false
        view_seprator.isHidden = false
        textViewTrailingConstraint.constant = 45
        keySkillTextView.textContainer.maximumNumberOfLines = 0
        
        if title == MIJobPreferenceViewControllerConstant.preferredIndu {
            infoData = "Maximum 2 industries can be selected."
            value = (jobPreferences.preferredIndustrys.map { $0.name }).joined(separator: ",")

        }else if title == MIJobPreferenceViewControllerConstant.preferredFunc {
            infoData = "Maximum 2 functions can be selected."
            value = (jobPreferences.preferredFunctions.map { $0.name }).joined(separator: ",")

        }else if title == MIJobPreferenceViewControllerConstant.preferredLoc {
            value = (jobPreferences.preferredLocationList.map { $0.name }).joined(separator: ",")
            textViewTrailingConstraint.constant = 15
            btn_questionMark.isHidden = true

        }else if title == MIJobPreferenceViewControllerConstant.preferredRole {
            value = (jobPreferences.preferredRoles.map { $0.name }).joined(separator: ",")
            textViewTrailingConstraint.constant = 15
            btn_questionMark.isHidden = true

        }else if title == MIJobPreferenceViewControllerConstant.preferredJobType {
            value = jobPreferences.preferredJobType.name
            textViewTrailingConstraint.constant = 15
            btn_questionMark.isHidden = true
        }
        lbl_infoData.text = infoData
        keySkillTextView.text = value
        
    }
    func showSkills(skillData:[MIUserSkills],title:String) {
        keySkillTextView.text = (skillData.map { $0.skillName }).joined(separator: ",")
        keySkillTextView.placeholder = title
        btn_questionMark.isHidden = true
        lbl_infoData.isHidden = true
        view_seprator.isHidden = false
        textViewTrailingConstraint.constant = 15
        keySkillTextView.textContainer.maximumNumberOfLines = 2
     //   keySkillTextView.textContainer.lineBreakMode = .byTruncatingTail
    }
    
    func manageTextFont(){
        keySkillTextView.floatingLabelFont = UIFont.customFont(type: .Regular, size: 12 )
        keySkillTextView.font = UIFont.customFont(type: .Regular, size: 13)

    }
    
    func showInfoPopup(infoMsg:String) {
        let controller = MIInfoPopOverController()
        controller.message = infoMsg
        controller.preferredContentSize = CGSize(width: self.bounds.size.width, height: 110)
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = self.btn_questionMark
        presentationController.sourceRect = self.btn_questionMark.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.superview?.parentViewController?.present(controller, animated: true)
    }
    
    @IBAction func questionMarkAction(_ sender : UIButton) {
        showPopUpCallBack?()
        //        let controller = MIInfoPopOverController()
//        controller.preferredContentSize = CGSize(width: self.bounds.size.width, height: 110)
//        showPopup(controller, sourceView: self.btn_questionMark)
    }
}
