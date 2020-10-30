//
//  MICurrentJobCell.swift
//  MonsteriOS
//
//  Created by Monster on 02/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

protocol CurrentJobSelectionDelegate : class {
    
    func currentJobSelection(isCurrentJob:Bool,sender:UIButton)
}

class MICurrentJobCell: UITableViewCell {

    @IBOutlet weak var selectionBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    
    weak var delegate : CurrentJobSelectionDelegate! = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
       // self.showUnSelectedBtn()
    }
    
    func show(info:MIEducationInfo,isCurrentJobSelected:Bool) {
        self.titleLbl.text = info.titleDetail
        self.selectionBtn.isSelected = isCurrentJobSelected
    }
    
    private func showUnSelectedBtn() {
        selectionBtn.roundCorner(1, borderColor: Color.colorClearBtnBorder, rad: 2)
        selectionBtn.backgroundColor = UIColor.white
    }
    
    @IBAction func selectionClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        guard let delegate = self.delegate else {return}
        delegate.currentJobSelection(isCurrentJob: sender.isSelected, sender: sender)
        
    }
}
