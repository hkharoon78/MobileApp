//
//  MIFloatingTextFieldTableCell.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 23/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class MIFloatingTextFieldTableCell: UITableViewCell {

    @IBOutlet weak var textField: JVFloatLabeledTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func showData(type:String,searchInfo:MIAdvanceSearchlDetail) {
        
        switch type {
        case PersonalTitleConstant.jobKeyword:
            textField.text = searchInfo.skill.joined(separator: ", ")
        case PersonalTitleConstant.location:
            let location = (searchInfo.location.map({ $0.name}))
            textField.text = location.joined(separator: ", ")
        case PersonalTitleConstant.year:
            if searchInfo.workExperience.count > 0 {
                textField.text = searchInfo.workExperience + " year"
            }
//        case PersonalTitleConstant.salary:
//            textField.text = searchInfo.currentSalary.salaryCurrency
        case PersonalTitleConstant.industry:
            let industry = (searchInfo.industry.map({ $0.name}))
            textField.text = industry.joined(separator: ", ")
        case PersonalTitleConstant.function:
            let function = (searchInfo.function.map({ $0.name}))
            textField.text = function.joined(separator: ", ")
        default:
            textField.text = ""
        }
    }
    func showData(type:String,personalInfo:MIPersonalDetail) {
        
        switch type {
        case PersonalTitleConstant.homeTown:
            textField.text = personalInfo.homeTown.name
        case PersonalTitleConstant.PermanentAddress:
            textField.text = personalInfo.permentantAddress

        case PersonalTitleConstant.DOB:
            textField.text = personalInfo.dob?.getStringWithFormat(format: "dd MMM, yyyy")

        case PersonalTitleConstant.PinCode:
            textField.text = personalInfo.pincode

        case PersonalTitleConstant.MaritalStatus:
            textField.text = personalInfo.maretialStatus.name

        case PersonalTitleConstant.Category:
            textField.text = personalInfo.category.name

        case PersonalTitleConstant.PassportNumber:
            textField.text = personalInfo.passportNumber

        case PersonalTitleConstant.CountryPermit:
            let names = (personalInfo.workPermits.map({ $0.name}))
            textField.text = names.joined(separator: ", ")

        case PersonalTitleConstant.Nationality:
            textField.text = personalInfo.nationality.name
        case PersonalTitleConstant.USAPermit:
            textField.text = personalInfo.workPermitUSA.name

        case PersonalTitleConstant.disabilityType:
            textField.text = personalInfo.disabilityObj.type.name
            
        case PersonalTitleConstant.disabilitySubtype:
            textField.text = personalInfo.disabilityObj.subtype.name

        case PersonalTitleConstant.disabilityDetails:
            textField.text = personalInfo.disabilityObj.detail.name

        case PersonalTitleConstant.disabilityDescription:
            textField.text = personalInfo.disabilityObj.disabilityDescription

        case PersonalTitleConstant.disabilityCertificationNo:
            textField.text = personalInfo.disabilityObj.disabilityCertificate
            
        case PersonalTitleConstant.disabilityIssueBy:
            textField.text = personalInfo.disabilityObj.disabilityIssuer
        case PersonalTitleConstant.Gender:
            textField.text = personalInfo.gender.name

        default:
            textField.text = ""
        }
    }
    
}
