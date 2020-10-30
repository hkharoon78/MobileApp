//
//  MIQuestionWithTextTableViewCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 23/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIQuestionWithTextTableViewCell: UITableViewCell {

    //MARK:Variables and Outlets
    @IBOutlet weak var floatLebelTextView: RSKPlaceholderTextView!
    @IBOutlet weak var questionTitle: UILabel!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    //@IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textField: UITextField!
    var quesTitle:String=""
    var questDesc=""{
        didSet{
            let titleString=NSMutableAttributedString(string:quesTitle, attributes: [NSAttributedString.Key.foregroundColor:UIColor.black ,NSAttributedString.Key.font:UIFont.customFont(type: .Semibold, size: 14)])
            let quesString=NSAttributedString(string:self.questDesc, attributes: [NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 14)])
            titleString.append(quesString)
            self.questionTitle.attributedText = titleString
        }
    }
     //MARK:Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
       // textView.font=UIFont.customFont(type: .Regular, size: 15)
       // textView.textColor=AppTheme.textColor
       // textView.frame.size.height=60
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.questionTitle.attributedText=nil
    }
    
}
