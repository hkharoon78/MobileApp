//
//  MIEduCertifiedCell.swift
//  MonsteriOS
//
//  Created by Rakesh on 21/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIEduCertifiedCell: UITableViewCell {

    @IBOutlet weak var certifiedCourseName_lbl : UILabel! {
        didSet {
            self.certifiedCourseName_lbl.font = UIFont.customFont(type: .Medium, size: 16)
            self.certifiedCourseName_lbl.textColor = AppTheme.textColor
        }
    }
    @IBOutlet weak var courseType_lbl : UILabel! {
        didSet {
            self.courseType_lbl.font = UIFont.customFont(type: .Regular, size: 12)
            self.courseType_lbl.textColor = AppTheme.grayColor

        }
    }
    @IBOutlet weak var courseKeywords_lbl : UILabel! {
        didSet {
            self.courseKeywords_lbl.font = UIFont.customFont(type: .Regular, size: 12)
            self.courseKeywords_lbl.textColor = AppTheme.grayColor

        }
    }
    @IBOutlet weak var courseProivdedBy_lbl : UILabel! {
        didSet {
            self.courseProivdedBy_lbl.font = UIFont.customFont(type: .Regular, size: 12)
            self.courseProivdedBy_lbl.textColor = AppTheme.grayColor

        }
    }
    @IBOutlet weak var courseFee_lbl : UILabel! {
        didSet {
            self.courseFee_lbl.font = UIFont.customFont(type: .Semibold, size: 20)
            self.courseFee_lbl.textColor = AppTheme.defaltTheme

        }
    }
    
    @IBOutlet weak var courseTaxDescription_lbl : UILabel! {
        didSet {
            self.courseTaxDescription_lbl.font = UIFont.customFont(type: .Medium, size: 10)
            self.courseTaxDescription_lbl.textColor = AppTheme.grayColor

        }
    }
    var eduTechnologyCourseData : MIEduTechnologyInfo! {
      
        didSet {
            let courseType = NSMutableAttributedString(string:EduCourseDescription.courseType.rawValue, attributes: [NSAttributedString.Key.foregroundColor:AppTheme.grayColor,NSAttributedString.Key.font:UIFont.customFont(type: .Medium, size: 13)])
            let courseTypeValue = NSAttributedString(string:eduTechnologyCourseData.courseType!, attributes: [NSAttributedString.Key.foregroundColor:AppTheme.grayColor,NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 13)])
            courseType.append(courseTypeValue)
            self.courseType_lbl.attributedText = courseType
            
            let keyword = NSMutableAttributedString(string:EduCourseDescription.keywords.rawValue, attributes: [NSAttributedString.Key.foregroundColor:AppTheme.grayColor,NSAttributedString.Key.font:UIFont.customFont(type: .Medium, size: 13)])
            let keywordValue = NSAttributedString(string:eduTechnologyCourseData.courseKeywords!, attributes: [NSAttributedString.Key.foregroundColor:AppTheme.grayColor,NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 13)])
            keyword.append(keywordValue)
            self.courseKeywords_lbl.attributedText = keyword
            
            let provider = NSMutableAttributedString(string:EduCourseDescription.courseProvidedBy.rawValue, attributes: [NSAttributedString.Key.foregroundColor:AppTheme.grayColor,NSAttributedString.Key.font:UIFont.customFont(type: .Medium, size: 13)])
            let providedBy = NSAttributedString(string:eduTechnologyCourseData.courseProvidedBy!, attributes: [NSAttributedString.Key.foregroundColor:AppTheme.grayColor,NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 13)])
            provider.append(providedBy)
            self.courseProivdedBy_lbl.attributedText = provider
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

extension NSAttributedString {
    
    
}
