//
//  MISuggestionView.swift
//  MonsteriOS
//
//  Created by Monster on 17/10/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

protocol MIProfileSuggestionViewDelegate:class {
    func removeObject(ttl:String) 
}

class MISuggestionView: UIView {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var cross_Btn: UIButton!

    weak var delegate:MIProfileSuggestionViewDelegate?
    class var suggestionView:MISuggestionView {
        get {
            return UINib(nibName: "MISuggestionView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MISuggestionView
        }
    }
    func show(ttl:String) {
        titleLbl.text = ttl
//        self.frame.size.width = CGSize(width: self.UILayoutFittingCompressedSize.width, height: 20)
        titleLbl.setNeedsLayout()
//        self.frame.size.width = systemLayoutSizeFitting(<#T##targetSize: CGSize##CGSize#>)
        
        self.layer.cornerRadius = 4
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    @IBAction func crossClicked(_ sender: UIButton) {
        self.delegate?.removeObject(ttl: self.titleLbl.text ?? "")
    }
}
