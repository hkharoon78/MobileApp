//
//  MIProjectTitleTableCell.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 21/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIProjectTitleTableCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension MIProjectTitleTableCell {
    
    func showData(for type: ProjectDetailEum, data: MIProfileProjectInfo?) {
        switch type {
        case .title:
            self.textField.text = data?.title
        case .client:
            self.textField.text = data?.client
        case .projectLoc:
            self.textField.text = data?.projLocation
        case .link:
            self.textField.text = data?.url
        default:
            break
        }
    }
}
