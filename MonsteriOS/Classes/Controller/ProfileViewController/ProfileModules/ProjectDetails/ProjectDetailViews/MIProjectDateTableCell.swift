//
//  MIProjectDateTableCell.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 21/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIProjectDateTableCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var monthTF: UITextField!
    @IBOutlet weak var yearTF: UITextField!
    @IBOutlet weak var stackViewLeadingConstarint: NSLayoutConstraint!
    @IBOutlet weak var titleLeadingConstrint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func showData(_ dateStr: String) {
        guard let date = dateStr.dateWith(PersonalTitleConstant.dateFormatePattern) else { return }
        
        self.monthTF.text = date.getStringWithFormat(format: "MM")
        self.yearTF.text = date.getStringWithFormat(format: "yyyy")
    }
    
    func showWorkExpereince(year:String,month:String) {
        titleLabel.font = UIFont.customFont(type: .Regular, size: 12)
        
        self.yearTF.text = month.isEmpty ? "Select Month" : month + " Months"
        self.monthTF.text = year.isEmpty ? "Select Year" : year + " Years"
        self.titleLabel.text = "Work Experience"
        self.titleLabel.textColor = AppTheme.defaltTheme
        self.stackViewLeadingConstarint.constant = 3
        self.titleLeadingConstrint.constant = 15

    }
}
