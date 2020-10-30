//
//  MIOptionSelectionCell.swift
//  MonsteriOS
//
//  Created by Rakesh on 18/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
protocol OptionSelectionDelegate :class {
    func optionSelectedIndex(indexValue:IndexPath,forTitle:Bool)
}

class MIOptionSelectionCell: UITableViewCell {
    
    @IBOutlet private weak var title_btn : UIButton!
    @IBOutlet private weak var subTitle_btn : UIButton!
    weak var delegate:OptionSelectionDelegate?
    
    var cellIndexPath : IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func displayContent(obj:MISalaryModel,selctionData:[String:Any],contentIndex:IndexPath,forMinData:Bool = false){
       
        self.cellIndexPath = contentIndex
        
        self.title_btn.setTitle(obj.titleValue, for: .normal)
        self.subTitle_btn.setTitle(obj.subTitleValue, for: .normal)
        if forMinData {
            if let selectedInfo = selctionData["minOptionSelection"] as? Dictionary<String,Int>  {
                if contentIndex.row == selectedInfo["titleSelectedIndex"] {
                    self.title_btn.isSelected = true
                }else {
                    self.title_btn.isSelected = false
                }
                
                if contentIndex.row == selectedInfo["subTitleSelectedIndex"] {
                    self.subTitle_btn.isSelected = true
                }else {
                    self.subTitle_btn.isSelected = false
                }
            }
        }else {
            if let selectedInfo = selctionData["maxOptionSelection"] as? Dictionary<String,Int>  {
                if contentIndex.row == selectedInfo["titleSelectedIndex"] {
                    self.title_btn.isSelected = true
                }else {
                    self.title_btn.isSelected = false
                }
                
                if contentIndex.row == selectedInfo["subTitleSelectedIndex"] {
                    self.subTitle_btn.isSelected = true
                }else {
                    self.subTitle_btn.isSelected = false
                }
            }
        }
 
    }
    
    // MARK : - IBAction helper Methods
    @IBAction func titleBtnAction(_ sender:UIButton){
     
        self.delegate?.optionSelectedIndex(indexValue: self.cellIndexPath, forTitle: true)
    }
    @IBAction func subTitleBtnAction(_ sender:UIButton){
        
        self.delegate?.optionSelectedIndex(indexValue: self.cellIndexPath, forTitle: false)
    }
    
}
