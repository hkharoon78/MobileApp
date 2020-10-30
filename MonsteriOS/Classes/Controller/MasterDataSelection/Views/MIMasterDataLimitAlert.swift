//
//  MIMasterDataLimitAlert.swift
//  MonsteriOS
//
//  Created by Piyush on 04/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIMasterDataLimitAlert: UIView {

    @IBOutlet weak var titleLbl: UILabel!
    
    class var view:MIMasterDataLimitAlert {
        return UINib(nibName: "MIMasterDataLimitAlert", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MIMasterDataLimitAlert
    }
    
    func showlimit(limit:Int) {
        self.roundCorner(0, borderColor: nil, rad: 8)
        self.titleLbl.text = "You can select max \(limit) items."
    }
    
    func removeMe() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.0
        })
    }
}
