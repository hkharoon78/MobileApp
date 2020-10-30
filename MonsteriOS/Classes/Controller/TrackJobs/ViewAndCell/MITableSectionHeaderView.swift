//
//  MITableSectionHeaderView.swift
//  MonsteriOS
//
//  Created by ishteyaque on 14/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MITableSectionHeaderView: UITableViewHeaderFooterView {

    //MARK:Variables And Outletss
    @IBOutlet weak var topView1: UIView!
    @IBOutlet weak var sectionTitlelabel: UILabel!{
        didSet{
            sectionTitlelabel.font=UIFont.customFont(type:.Semibold, size: 16)
        }
    }
    @IBOutlet weak var viewAllButton: UIButton!
    var viewAllAction:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewAllButton.titleLabel?.font=UIFont.customFont(type: .Semibold, size: 14)
    }
    //MARK:View All Button Action
    @IBAction func viewAllButtonAction(_ sender: UIButton) {
        if let action=viewAllAction{
            action()
        }
    }
    
}
