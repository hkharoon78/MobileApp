//
//  MICarrerAdviceCell.swift
//  MonsteriOS
//
//  Created by Rakesh on 24/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

protocol ReadMoreAdviceDelegate : class {
    func readMoreContent(model:MICarrerTipsModel)
}

class MICarrerAdviceCell: UITableViewCell {

    var objModel : MICarrerTipsModel!
    var delegate : ReadMoreAdviceDelegate? = nil
    
    @IBOutlet weak var adviceTitle_Lbl : UILabel! {
        didSet {
            self.adviceTitle_Lbl.textColor = AppTheme.textColor
            self.adviceTitle_Lbl.font = UIFont.customFont(type: .Medium, size: 18)

        }
    }
    @IBOutlet weak var adviceDescription_Lbl : UILabel! {
        didSet {
            self.adviceDescription_Lbl.textColor = AppTheme.textColor
            self.adviceDescription_Lbl.font = UIFont.customFont(type: .Regular, size: 15)
        }
    }
    
    @IBOutlet weak var readMore_Btn : UIButton! {
        didSet {
            self.readMore_Btn.setTitleColor(AppTheme.defaltTheme, for: .normal)
            self.readMore_Btn.titleLabel?.font = UIFont.customFont(type: .Semibold, size: 16)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    //MARK: - Helper Methods
    func showContent(obj:MICarrerTipsModel) {
        objModel = obj
        self.adviceTitle_Lbl.text = obj.carrerTipTitle
        self.adviceDescription_Lbl.text = obj.carrerTipDescription
        self.readMore_Btn.isSelected = obj.flag
    }
    
    //MARK: - IBAction Helper Methods
    @IBAction func readMore_Action(_ sender : UIButton) {
        objModel?.flag = !(objModel?.flag)!
        if self.delegate != nil {
            self.delegate?.readMoreContent(model: objModel)
        }
    }
}
