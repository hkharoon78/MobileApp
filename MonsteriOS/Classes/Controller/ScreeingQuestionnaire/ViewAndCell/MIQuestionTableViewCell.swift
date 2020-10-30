//
//  MIQuestionTableViewCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 22/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIQuestionTableViewCell: UITableViewCell {

    //MARK: Outlets and Variables
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var choiceView: AMChoice!
    @IBOutlet weak var choiceViewHeight: NSLayoutConstraint!
    
    var quesTitle: String = ""
    var questDesc=""{
        didSet{
            let titleString=NSMutableAttributedString(string: quesTitle, attributes: [NSAttributedString.Key.foregroundColor:UIColor.black ,NSAttributedString.Key.font:UIFont.customFont(type: .Semibold, size: 14)])
            let quesString=NSAttributedString(string:self.questDesc, attributes: [NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 14)])
            titleString.append(quesString)
            self.questionLabel.attributedText = titleString
        }
    }
    
    //MARK:Life Cycle Method
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        choiceView.isRightToLeft=false
        choiceView.arrowImage=nil
        choiceView.delegate=self
        choiceView.font = UIFont.customFont(type: .Regular, size: 14)
        choiceView.textColor = AppTheme.textColor
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.questionLabel.text=nil
        self.choiceViewHeight.constant = 60
    }
}


//MARK:Choice View Delegate Method
extension MIQuestionTableViewCell:AMChoiceDelegate{
        func didSelectRowAt(indexPath: IndexPath) {
           // self.choiceView.textColor=UIColor.init(hex: "212b36")
        }
    }


