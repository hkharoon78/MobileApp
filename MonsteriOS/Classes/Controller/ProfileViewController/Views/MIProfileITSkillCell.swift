//
//  MIProfileITSkillCell.swift
//  MonsteriOS
//
//  Created by Piyush on 11/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

protocol MIProifleITSkillCellDelegate:class {
    func itSkillClicked(info:MIProfileITSkills, sender:UIView)
}

class MIProfileITSkillCell: MIProfileTableCell {

    @IBOutlet weak var lblTtl: UILabel!
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var lblLastUsed: UILabel!
    @IBOutlet weak var lblExp: UILabel!
    var info = MIProfileITSkills(dictionary: [:])
    weak var delgate:MIProifleITSkillCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func show(info:MIProfileITSkills) {
        self.lblTtl.text    = info.skill?.name
        if info.version.withoutWhiteSpace().count > 0 {
            self.lblVersion.text = "Version : \(info.version)"
        } else {
            self.lblVersion.text = ""
        }
        if let date = info.lastUsed.dateWith(PersonalTitleConstant.dateFormatePattern)?.getStringWithFormat(format: "yyyy") {
            self.lblLastUsed.text = "Last Used : \(date)"
        } else {
            self.lblLastUsed.text = ""
        }
        var month = ""
        var year  = ""
        if !info.expMonth.isEmpty {
            month = "\(info.expMonth) months"
        }
        if !info.expYear.isEmpty {
            year = "\(info.expYear) years"
        }
        if info.expYear.isEmpty && info.expMonth.isEmpty {
            self.lblExp.text      = ""
        } else {
            self.lblExp.text      = "Experience : \(year) \(month)"
        }
        self.info = info
    }
    func showITSkill(info:MIProfileITSkills) {
        self.lblTtl.text    = info.skill?.name
        var versionLastUsed = ""
        if info.version.withoutWhiteSpace().count > 0 {
            versionLastUsed = "Version: \(info.version)"
        } else {
            versionLastUsed = ""
        }
        
        if let date = info.lastUsed.dateWith(PersonalTitleConstant.dateFormatePattern)?.getStringWithFormat(format: "yyyy") {
            versionLastUsed = (versionLastUsed.count > 0) ?  versionLastUsed + " | " + "Last Used :  \(date)" :  "Last Used :  \(date)"
        } else {
            versionLastUsed = versionLastUsed + ""
        }
        self.lblVersion.text = versionLastUsed
        var month = ""
        var year  = ""
        if !info.expMonth.isEmpty {
            month = "\(info.expMonth) months"
        }
        if !info.expYear.isEmpty {
            year = "\(info.expYear) years"
        }
        if info.expYear.isEmpty && info.expMonth.isEmpty {
            self.lblExp.text      = ""
        } else {
            self.lblExp.text      = "Experience : \(year) \(month)"
        }
        self.info = info
    }
    
    @IBAction func ITSkillEditClicked(_ sender: Any) {
        if let modelInfo = self.info {
            self.delgate?.itSkillClicked(info: modelInfo, sender: sender as! UIView)
        }
    }
}
