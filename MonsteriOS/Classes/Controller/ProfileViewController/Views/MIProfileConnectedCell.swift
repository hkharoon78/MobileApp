//
//  MIProfileConnectedCell.swift
//  MonsteriOS
//
//  Created by Piyush on 14/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import DropDown

protocol MIProfileConnectedCellDelegate:class {
    func connectedCellEditClicked(type:MIProfileEnums, modelInfo:[Any], sender: UIView)
}

class MIProfileConnectedCell: MIProfileTableCell {
    @IBOutlet weak var viewLineTop : UIView!
    @IBOutlet weak var viewCircular: UIView!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var lblTtl: UILabel!
    @IBOutlet weak var lblTtlInfo: UILabel!
    @IBOutlet weak var lblSubTtl: UILabel!
    @IBOutlet weak var lblTtlStatus: UILabel!
    @IBOutlet weak var editBtn: UIButton!
   
    var type = MIProfileEnums.project
    var modelsInfo = [Any]()
    weak var delegate:MIProfileConnectedCellDelegate?
    let dropDown = DropDown()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewCircular.circular(2, borderColor: AppTheme.defaltBlueColor)
        viewLine.backgroundColor = AppTheme.defaltBlueColor
        viewLineTop.backgroundColor = AppTheme.defaltBlueColor

//        contentView.addShadow(opacity: 0.4)
        self.selectionStyle = .none
//        dropDown.direction = .any
//        dropDown.dismissMode = .onTap
//        dropDown.cellHeight = 40
//        dropDown.selectionBackgroundColor = .white
//        dropDown.separatorColor = .lightGray
//        dropDown.textFont=UIFont.customFont(type: .Regular, size: 14)
//        dropDown.backgroundColor = .white
//        dropDown.textColor=AppTheme.textColor
//        dropDown.dataSource = ["Edit","Delete"]
//        self.setUpDropDown()
    }
    
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        self.dropDown.anchorView = editBtn
//        self.dropDown.width      = 400
//        self.dropDown.bottomOffset = CGPoint(x: -80, y:(self.dropDown.anchorView?.plainView.bounds.height)!)
//        self.dropDown.topOffset = CGPoint(x:-80, y:-(self.dropDown.anchorView?.plainView.bounds.height)!)
//    }
    
//    var editOrDeleteAction:((Bool)->Void)?
//    func setUpDropDown(){
//        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//            if index == 0{
//                if let action=self.editOrDeleteAction{
//                    action(true)
//                }
//            }else{
//                if let action=self.editOrDeleteAction{
//                    action(false)
//                }
//            }
//        }
//        dropDown.cellConfiguration = {(_, item) in
//            return "\(item)"
//        }
//    }
    
    func show(info:MIProfileInfo) {
        lblTtl.text     = info.title
        lblTtlInfo.text = info.subTitle
        lblSubTtl.text  = info.titleStatus
        lblTtlStatus.text = info.titleStatusDetail
        self.viewLine.backgroundColor = AppTheme.defaltBlueColor
        self.viewLineTop.backgroundColor = AppTheme.defaltBlueColor
    }
    
    func showAward(info:MIProfileAward) {
        lblTtl.text     = info.title
        lblTtlInfo.text = ""
        if let awardDate = info.date.dateWith(PersonalTitleConstant.dateFormatePattern)?.getStringWithFormat(format: "MMM yyyy") {
            lblSubTtl.text = "Date : \(awardDate)"
        } else {
            lblSubTtl.text =  ""
        }
        lblTtlStatus.text  =  ""//info.ttlDescription
        
        self.viewLine.backgroundColor = AppTheme.defaltBlueColor
        self.viewLineTop.backgroundColor = AppTheme.defaltBlueColor
        type = MIProfileEnums.awards
        modelsInfo = [info]
    }
    
    func showCourses(info:MIProfileCoursesInfo) {
        lblTtl.text     = info.name
        lblTtlInfo.text = ""
        if !info.issuer.isEmpty {
            lblSubTtl.text  = "Issued By: \(info.issuer)"
        } else {
            lblSubTtl.text  = ""
        }
        
        if let date = info.expiryDate.dateWith(PersonalTitleConstant.dateFormatePattern)?.getStringWithFormat(format: "MMM yyyy") {
            self.lblTtlStatus.text = "Validity : \(date)"
        } else {
            self.lblTtlStatus.text = ""
        }
        
//        lblTtlStatus.text = info.
        self.viewLine.backgroundColor = AppTheme.defaltBlueColor
        self.viewLineTop.backgroundColor = AppTheme.defaltBlueColor
        type = MIProfileEnums.courses
        modelsInfo = [info]
    }
    
    func showProjects(info:MIProfileProjectInfo) {
        var clientName = ""
        if !info.client.isEmpty {
            clientName = " - \(info.client)"
        }
        lblTtl.text       = info.title + clientName
        lblTtlInfo.text   = ""
        lblTtlStatus.text = ""
        var data = ""
        if !info.projLocation.isEmpty {
            data = info.projLocation + " - "
        }
        if let startDate = info.startDate.dateWith(PersonalTitleConstant.dateFormatePattern)?.getStringWithFormat(format: "MMM yyyy") {
            data = data + startDate
        }
        if let endDate = info.endDate.dateWith(PersonalTitleConstant.dateFormatePattern)?.getStringWithFormat(format: "MMM yyyy") {
            data = data + " to \(endDate)"
        }
        lblSubTtl.text    = data
//        lblTtlStatus.text = info.endDate
        self.viewLine.backgroundColor = AppTheme.defaltBlueColor
        self.viewLineTop.backgroundColor = AppTheme.defaltBlueColor
        type = MIProfileEnums.project
        modelsInfo = [info]
    }
    
    func showEmployment(info:MIEmploymentDetailInfo) {
        lblTtl.text       = info.designationObj.name
        lblTtlInfo.text   = info.companyObj.name
        var data = ""
        if let startDate = info.experinceFrom?.getStringWithFormat(format: "MMM yyyy") {
            data = startDate
        }
        if let endDate = info.experinceTill?.getStringWithFormat(format: "MMM yyyy") {
            data = data + " to \(endDate)"
        } else {
            data = data + " till Present"
        }
        lblSubTtl.text    = data
        if info.isCurrentEmplyement, !info.noticePeroidDuration.isEmpty {
            lblTtlStatus.text = info.isServingNotice ? info.noticePeroidDuration : "Notice Period : \(info.noticePeroidDuration)"
        } else {
            lblTtlStatus.text = ""
        }
        
        self.viewLine.backgroundColor = AppTheme.defaltBlueColor
        self.viewLineTop.backgroundColor = AppTheme.defaltBlueColor
        type = MIProfileEnums.workExperience
        modelsInfo = [info]
    }
    
    func showEducation(info:MIEducationInfo) {
        lblTtl.text       = info.highestQualificationObj.name
//        if info.specialisationObj.name.isEmpty {
//            lblTtlInfo.text   = info.boardObj.name
//        }else{
//            lblTtlInfo.text   = info.specialisationObj.name
//        }
        lblTtlInfo.text = ""
        
        if info.specialisationObj.name.isEmpty {
            lblSubTtl.text    = info.boardObj.name
        } else {
            lblSubTtl.text    = info.collegeObj.name
        }    
        lblTtlStatus.text    = "\(info.year)" + (info.educationTypeObj.name.isEmpty ? "" : " (\(info.educationTypeObj.name))")
    
        self.viewLine.backgroundColor = AppTheme.defaltBlueColor
        self.viewLineTop.backgroundColor = AppTheme.defaltBlueColor
        type = MIProfileEnums.eduExperience
        modelsInfo = [info]
    }
    
    func hideLine() {
        self.viewLine.backgroundColor = UIColor.clear
    }
    
    func hideTopLine() {
        self.viewLineTop.backgroundColor = UIColor.clear
    }
    
    @IBAction func editClicked(_ sender: UIButton) {
        self.delegate?.connectedCellEditClicked(type: type, modelInfo: modelsInfo, sender: sender)
    }
    
}
