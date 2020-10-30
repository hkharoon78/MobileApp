//
//  MICarrerTipCollectionViewCell.swift
//  MonsteriOS
//
//  Created by Rakesh on 24/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
protocol TipOptionSelectionDelegate {
    func tipOptionClicked(selectedObj:MICarrerTipsModel)
}

class MICarrerTipCollectionViewCell: UICollectionViewCell {

    var tipObj : MICarrerTipsModel?
    var delegate : TipOptionSelectionDelegate?
    @IBOutlet weak var carrerTip_Btn : UIButton! 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    //MARK: - Helper Mehthods
    func showData(obj:MICarrerTipsModel) {
        self.tipObj = obj
        self.carrerTip_Btn.setTitle(obj.carrerTipTitle, for: .normal)
        self.carrerTip_Btn.isSelected = obj.flag
        self.carrerTip_Btn.backgroundColor = obj.flag ? AppTheme.defaltTheme : UIColor.white
        self.carrerTip_Btn.roundCorner(1, borderColor: AppTheme.defaltTheme, rad: 5)
        self.carrerTip_Btn.titleLabel?.font = UIFont.customFont(type: .light, size: 14)
    }

    func showFilterData(name:String,itemNumber:Int,filterCategory:FilterType) {
       
        if itemNumber > 4{
            self.carrerTip_Btn.backgroundColor = .clear
            self.carrerTip_Btn.setTitleColor(AppTheme.defaltBlueColor, for: .normal)
            self.carrerTip_Btn.contentHorizontalAlignment = .left
            self.carrerTip_Btn.roundCorner(1, borderColor: .clear, rad: 5)

        }else{
            self.carrerTip_Btn.backgroundColor = .white
            self.carrerTip_Btn.roundCorner(1, borderColor: .white, rad: 5)
            self.carrerTip_Btn.setTitleColor(.black, for: .normal)
           // self.carrerTip_Btn.contentMode = .center
            self.carrerTip_Btn.contentHorizontalAlignment = .center

        }
        if filterCategory == .experienceRange {
            self.carrerTip_Btn.setTitle((itemNumber > 4) ?  name :  name.replacingOccurrences(of: "~", with: "-") + " Year", for: .normal)
        }else{
            self.carrerTip_Btn.setTitle(name, for: .normal)
        }
    }
    //MARK: IBAction Methods
    @IBAction func tipsOptionClicked(_ sender: UIButton) {
      //  self.tipObj?.flag = !(self.tipObj?.flag)!
        
        if self.delegate != nil {
            self.delegate!.tipOptionClicked(selectedObj: self.tipObj!)
        }
    }
}
