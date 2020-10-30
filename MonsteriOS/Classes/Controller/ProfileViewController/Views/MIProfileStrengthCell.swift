//
//  MIProfileStrengthCell.swift
//  MonsteriOS
//
//  Created by Piyush on 21/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIProfileTableCell:UITableViewCell {
    override func awakeFromNib() {
        self.selectionStyle = .none
    }
}
class MIProfileStrengthCell: MIProfileTableCell {
    
    @IBOutlet weak private var lblProfileStrength: UILabel!
    @IBOutlet weak private var viewProfileProgressTop: UIView!
    @IBOutlet weak private var viewProfileProgress: UIView!
    @IBOutlet weak private var viewProfileProgressWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak private var lblFullProfileStrength: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewProfileProgressTop.backgroundColor = AppTheme.dimlightGrayColor
        self.viewProfileProgress.backgroundColor = AppTheme.defaltBlueColor
        self.viewProfileProgressTop.roundCorner(0, borderColor: nil, rad: CornerRadius.viewCornerRadius)
        self.lblFullProfileStrength.textColor = AppTheme.defaltBlueColor
    }
    
    func showProgress(percent:Int) {
        let totalWidth = kScreenSize.width - 70
        let percentWidth  = (totalWidth/100) * CGFloat(percent)
        viewProfileProgressWidthConstraint.constant = percentWidth
        self.lblProfileStrength.text = "Profile Strength: \(percent)% complete"
        self.lblProfileStrength.showAttributedTxt(boldString: "\(percent)% complete")
    }
}
