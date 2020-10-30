//
//  MISearchAutoSuggestionView.swift
//  MonsteriOS
//
//  Created by Piyush on 10/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

protocol MISearchAutoSuggestionDelegate:class {
    func suggestionClicked(name:String)
}

class MISearchAutoSuggestionView: UIView {

    @IBOutlet weak var titleLbl: UILabel!
    weak var delegate:MISearchAutoSuggestionDelegate?
    
    class var suggestionView:MISearchAutoSuggestionView {
        get {
            return UINib(nibName: "MISearchAutoSuggestionView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MISearchAutoSuggestionView
        }
    }
    
    func show(ttl:String) {
        titleLbl.text = ttl
        self.backgroundColor = UIColor.white
        self.roundCorner(1, borderColor: UIColor(hex: "d9d9d9"), rad: 3)
        self.titleLbl.textColor = UIColor(hex: "1f1f1f")
        titleLbl.setNeedsLayout()
        self.layer.cornerRadius = 4
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func showSelectedView() {
        self.titleLbl.textColor = UIColor.white
        self.backgroundColor    = AppTheme.defaltBlueColor//UIColor(hex: "5c4aae")
    }
    
    @IBAction func suggestionClicked(_ sender: UIButton) {
        self.delegate?.suggestionClicked(name: self.titleLbl.text ?? "")
    }
}
