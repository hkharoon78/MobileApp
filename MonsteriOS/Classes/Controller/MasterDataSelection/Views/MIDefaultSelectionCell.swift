//
//  MIDefaultSelectionCell.swift
//  MonsteriOS
//
//  Created by Monster on 01/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit


class MIDefaultSelectionInfo: NSObject {
    var title      = ""
    var isSelected = false
    
    init(with ttl:String, isSelected:Bool = false) {
        title = ttl
        self.isSelected = isSelected
    }
}

class MIDefaultSelectionCell: MIBaseCell {

    @IBOutlet weak private var titleLbl: UILabel!
    @IBOutlet weak private var selectionBtn: UIButton!
    @IBOutlet weak private var lbl_leadingConstarint: NSLayoutConstraint!

    @IBOutlet weak var selectionBtnWidthConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
//        self.showUnSelectedBtn()
    }
    
    func show(info:MICategorySelectionInfo,shouldShowSelection:Bool = false) {
        self.titleLbl.text = info.name
        
        if shouldShowSelection {
//            self.selectionBtn.isHidden = false
        } else {
//            self.selectionBtn.isHidden = true
//            selectionBtnWidthConstraint.constant = 0
        }
    }
    func showTitle(title:String,shouldShowSelection:Bool = false) {
        self.titleLbl.text = title
        self.lbl_leadingConstarint.constant = 25

    }
//    private func showUnSelectedBtn() {
//        selectionBtn.roundCorner(1, borderColor: Color.colorClearBtnBorder, rad: 2)
//        selectionBtn.backgroundColor = UIColor.white
//    }
    
    @IBAction func selectionClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
//        if sender.isSelected {
//            selectionBtn.backgroundColor = Color.colorDefault
//            selectionBtn.setImage(UIImage(named: "right_tick_white"), for: .normal)
//        } else {
//            self.showUnSelectedBtn()
//        }
    }
}
