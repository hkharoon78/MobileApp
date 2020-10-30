//
//  MIQuestRadioTableViewCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 08/04/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIQuestRadioTableViewCell: UITableViewCell {

    @IBOutlet weak var quesTitlelabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!{
        didSet {
            yesButton.titleLabel?.font = UIFont.customFont(type: .Regular, size: 15)
            yesButton.setTitleColor(UIColor(hex: "505050"), for: .normal)
        }
    }
    
    @IBOutlet weak var noButton: UIButton!{
        didSet {
            noButton.titleLabel?.font = UIFont.customFont(type: .Regular, size: 15)
            noButton.setTitleColor(UIColor(hex: "505050"), for: .normal)
        }
    }
    
    var viewModel:Questions!{
        didSet{
            let titleString=NSMutableAttributedString(string:"Ques\(viewModel.indexpath)", attributes: [NSAttributedString.Key.foregroundColor:UIColor.black ,NSAttributedString.Key.font:UIFont.customFont(type: .Semibold, size: 14)])
            let quesString=NSAttributedString(string: ": "+(viewModel.question ?? ""), attributes: [NSAttributedString.Key.foregroundColor:UIColor.black,NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 14)])
            titleString.append(quesString)
            self.quesTitlelabel.attributedText = titleString
            if viewModel.answer?.caseInsensitiveCompare("Yes") == .orderedSame {
                 yesButton.setImage(UIImage(named: "off-1"), for: .normal)
            }else if viewModel.answer?.caseInsensitiveCompare("No") == .orderedSame{
                noButton.setImage(UIImage(named: "off-1"), for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        yesButton.setImage(UIImage(named: "off-2"), for: .normal)
        noButton.setImage(UIImage(named: "off-2"), for: .normal)
        yesButton.setTitle(" Yes", for: .normal)
        noButton.setTitle(" No", for: .normal)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        yesButton.setImage(UIImage(named: "off-2"), for: .normal)
        noButton.setImage(UIImage(named: "off-2"), for: .normal)
    }
    @IBAction func yesButtonAction(_ sender: UIButton) {
        noButton.setImage(UIImage(named: "off-2"), for: .normal)
        yesButton.setImage(UIImage(named: "off-1"), for: .normal)
        viewModel.answer="Yes"
    }
    
    @IBAction func noButtonAction(_ sender: UIButton) {
       yesButton.setImage(UIImage(named: "off-2"), for: .normal)
        noButton.setImage(UIImage(named: "off-1"), for: .normal)
        viewModel.answer="No"
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
