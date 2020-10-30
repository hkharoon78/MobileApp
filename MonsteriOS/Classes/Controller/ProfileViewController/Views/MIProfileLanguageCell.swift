//
//  MIProfileLanguageCell.swift
//  MonsteriOS
//
//  Created by Piyush on 09/05/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

protocol MIProfileLanguageCellDelegate:class {
    func languageEditClicked(modelInfo:Any, sender: UIView)
}

class MIProfileLanguageCell: MIProfileTableCell {

    @IBOutlet weak var viewLineTop : UIView!
    @IBOutlet weak var viewCircular: UIView!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak private var lblTtl: UILabel!
    @IBOutlet weak private var lblSubTtl: UILabel!
    @IBOutlet weak var lblExpertise: UILabel!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!

    weak var delegate:MIProfileLanguageCellDelegate?
    var info:MIProfileLanguageInfo?
    override func awakeFromNib() {
        super.awakeFromNib()
        viewCircular.circular(2, borderColor: AppTheme.defaltBlueColor)
        viewLine.backgroundColor = AppTheme.defaltBlueColor
        viewLineTop.backgroundColor = AppTheme.defaltBlueColor
    }
    
    func hideLine() {
        self.viewLine.backgroundColor = UIColor.clear
    }
    
    func hideTopLine() {
        self.viewLineTop.backgroundColor = UIColor.clear
    }
    
    func show(info:MIProfileLanguageInfo) {
        self.info = info
        lblTtl.text = info.language?.name
        lblSubTtl.text = info.proficiency?.name
        var expertise = ""
        var i = 0
        if info.read {
            expertise = "Read"
            i = i+1
        }
        
        if info.write {
            if i==1 {
                expertise = expertise + ", Write"
            } else {
                expertise = "Write"
            }
            
            i = i+1
        }
        
        if info.speak {
            if i>=1 {
                expertise = expertise + ", Speak"
            } else {
                expertise = "Speak"
            }
        }
        
        self.lblExpertise.text = expertise
        self.viewLine.backgroundColor = AppTheme.defaltBlueColor
        self.viewLineTop.backgroundColor = AppTheme.defaltBlueColor
    }
    func showLanguageData(info:MIProfileLanguageInfo) {
        self.info = info
        lblTtl.text = info.language?.name
        lblSubTtl.text = info.proficiency?.name
        var expertise = ""
        //var i = 0
        if info.read {
            expertise = "Read"
           // i = i+1
        }
        
        if info.write {
            expertise = expertise.isEmpty ? "Write" : (expertise + " | " + "Write")
        }
        
        if info.speak {
            expertise = expertise.isEmpty ? "Speak":  expertise + " | " + "Speak"

        }
        
        self.lblExpertise.text = expertise
        self.viewLine.isHidden = true
        self.viewCircular.isHidden = true
        self.viewLineTop.isHidden = true
        self.viewLine.backgroundColor = AppTheme.defaltBlueColor
        self.viewLineTop.backgroundColor = AppTheme.defaltBlueColor
    }
    
    @IBAction func editClicked(_ sender: UIButton) {
        self.delegate?.languageEditClicked(modelInfo: self.info as Any, sender: sender)
    }
}
