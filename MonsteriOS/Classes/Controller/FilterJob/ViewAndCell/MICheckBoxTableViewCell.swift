//
//  MICheckBoxTableViewCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 22/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MICheckBoxTableViewCell: UITableViewCell {

    //MARK:Outlets And Variables
    @IBOutlet weak var choiceView: AMChoice!
    @IBOutlet weak var choiceViewHeight: NSLayoutConstraint!
    
    //MARK:Life Cycle methos
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //UIColor.init(named: "212B36")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        choiceView.isRightToLeft=false
        choiceView.arrowImage=nil
        choiceView.delegate=self
        choiceView.font = UIFont.customFont(type: .Regular, size: 14)
        choiceView.textColor = AppTheme.textColor
    }
    
}
//MARK:Choice View Delegate
extension MICheckBoxTableViewCell:AMChoiceDelegate{
    func didSelectRowAt(indexPath: IndexPath) {
    }
}
