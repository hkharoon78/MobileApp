//
//  MIRecruiterMsgDescriptionCell.swift
//  MonsteriOS
//
//  Created by Anushka on 25/06/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIRecruiterMsgDescriptionCell: UITableViewCell {
    
    @IBOutlet weak var lblDescription: UILabel!
    
    var modelData: RecruiterActionMsgBase?
    {
        didSet {
            if let desc=modelData?.emailText{
            self.lblDescription.attributedText = desc.htmlAttributed(using: UIFont.customFont(type: .Regular, size: 11), color: AppTheme.textColor)
            }
        }
    }

    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.lblDescription.numberOfLines = 0
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}






public class RecruiterActionMsgBase {
    public var id : Int?
    public var created : Int?
    public var emailSubject : String?
    public var emailText : String?
    
    required public init?(dictionary: NSDictionary) {
        
        id = dictionary["id"] as? Int
        created = dictionary["created"] as? Int
        emailSubject = dictionary["emailSubject"] as? String
        emailText = dictionary["emailText"] as? String
    }
    
}

