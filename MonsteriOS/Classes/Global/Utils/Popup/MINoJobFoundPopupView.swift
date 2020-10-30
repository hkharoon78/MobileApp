//
//  MINoJobFoundPopupView.swift
//  MonsteriOS
//
//  Created by Piyush on 31/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MINoJobFoundPopupView: MIPopupView {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel! {
        didSet{
            self.titleLbl.textColor = AppTheme.defaltBlueColor
        }
    }
    @IBOutlet weak var descLbl: UILabel!
    
    static let shared = MINoJobFoundPopupView.popup()
    class func popup() -> MINoJobFoundPopupView {
        let header = UINib(nibName: "MINoJobFoundPopupView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MINoJobFoundPopupView
        
        return header
    }
    
    func show(ttl:String, desc:String, imgNm:String = "")
    {
        //super.alpha=1
        self.titleLbl.text = ttl
        self.descLbl.text  = desc
        
        if !imgNm.isEmpty {
            self.imgView.image = UIImage(named: imgNm)
        }
    }
    @IBAction func hide(_ sender: UIButton) {
        
    }
}
