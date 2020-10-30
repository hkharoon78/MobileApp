//
//  MIJobDetailsTableViewCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 16/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit


class MIJobDetailsTableViewCell: UITableViewCell {

    //MARK:Outlets And Variables
    @IBOutlet weak var functionLabel: UILabel!
    @IBOutlet weak var industryLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var experienceLabel: UILabel!
    @IBOutlet weak var experienceLabelBottom: NSLayoutConstraint!
    @IBOutlet weak var expeLevelHeight: NSLayoutConstraint!
    var experLevelIsHidden=false{
        didSet{
            if experLevelIsHidden{
                experienceLabel.isHidden=true
                experienceLabelBottom.constant=0
                expeLevelHeight.constant=0
            }
        }
    }
    var jobDetails:JobDetailsModel!{
        didSet{
            let industrString=NSMutableAttributedString(string:JobDetailsTitleDescription.industry.value, attributes: [NSAttributedString.Key.foregroundColor:AppTheme.textColor,NSAttributedString.Key.font:UIFont.customFont(type: .Medium, size: 14)])
            let industryTitleString=NSAttributedString(string:jobDetails.industryTitle, attributes: [NSAttributedString.Key.foregroundColor:AppTheme.textColor,NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 14)])
            industrString.append(industryTitleString)
            
            let funcString=NSMutableAttributedString(string:JobDetailsTitleDescription.function.value, attributes: [NSAttributedString.Key.foregroundColor:AppTheme.textColor,NSAttributedString.Key.font:UIFont.customFont(type: .Medium, size: 14)])
            let funcTitleString=NSAttributedString(string:jobDetails.functionalTitle, attributes: [NSAttributedString.Key.foregroundColor:AppTheme.textColor,NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 14)])
            funcString.append(funcTitleString)
            let roleString=NSMutableAttributedString(string:JobDetailsTitleDescription.role.value, attributes: [NSAttributedString.Key.foregroundColor:AppTheme.textColor,NSAttributedString.Key.font:UIFont.customFont(type: .Medium, size: 14)])
            let roleTitleString=NSAttributedString(string:jobDetails.roleTitle, attributes: [NSAttributedString.Key.foregroundColor:AppTheme.textColor,NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 14)])
            roleString.append(roleTitleString)
            self.industryLabel.attributedText=industrString
            self.functionLabel.attributedText=funcString
            self.roleLabel.attributedText=roleString
             let exprString=NSMutableAttributedString(string:JobDetailsTitleDescription.expLabel.value, attributes: [NSAttributedString.Key.foregroundColor:AppTheme.textColor,NSAttributedString.Key.font:UIFont.customFont(type: .Medium, size: 14)])
                exprString.append(NSAttributedString(string:jobDetails.expLevel!, attributes: [NSAttributedString.Key.foregroundColor:AppTheme.textColor,NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 14)]))
                self.experienceLabel.attributedText=exprString
            
        }
    }
    
    
}


