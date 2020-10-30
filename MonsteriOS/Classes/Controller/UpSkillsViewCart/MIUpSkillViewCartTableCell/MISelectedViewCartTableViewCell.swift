//
//  MISelectedViewCartTableViewCell.swift
//  MonsteriOS
//
//  Created by Anushka on 02/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MISelectedViewCartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblResume: UILabel!
    @IBOutlet weak var lblResumeValue: UILabel!
    @IBOutlet weak var btnDeleteResume: UIButton!
    @IBOutlet weak var lblResumeFresher: UILabel!
    @IBOutlet weak var lblResumeFresherValue: UILabel!
    @IBOutlet weak var btnDeleteResumeFresher: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- IBAction
    @IBAction func btnDeleteResumePressed(_ sender: UIButton) {
    }
    
    @IBAction func btnDeleteResumeFresherPressed(_ sender: UIButton){
        
    }
    
}
