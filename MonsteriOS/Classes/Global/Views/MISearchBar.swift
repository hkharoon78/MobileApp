//
//  MISearchBar.swift
//  MonsteriOS
//
//  Created by ishteyaque on 31/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

@objc protocol MISearchBarDelegate: UISearchBarDelegate {
    
    @available(iOS 10.0, *)
    @objc optional func voiceButtonAction(_ btn: UIButton)
}

extension UISearchBar {
    var textField: UITextField? {
        return value (forKey: "searchField") as? UITextField
    }
}

class MISearchBar: UISearchBar {
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    private var voiceButton = UIButton()
    
    weak var miDelegate: MISearchBarDelegate?
    var showVoiceSearch: Bool = false {
        didSet {
            self.voiceButton.isHidden = !showVoiceSearch
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        NotificationCenter.default.addObserver(self, selector: #selector(manageVoiceButton), name: .CountryChanged, object: nil)
        
        
        if let textField = self.textField {
            textField.backgroundColor = AppTheme.viewBackgroundColor
            textField.font = UIFont.customFont(type: .Regular, size: 14)
            textField.textColor = AppTheme.textColor
            textField.clearButtonMode = .always
            textField.rightViewMode =  .always
            textField.layer.borderWidth = 1
            textField.layer.cornerRadius = 10
            textField.layer.borderColor = UIColor.init(hex: "f1f1f1").cgColor
            textField.layer.masksToBounds = false
            
            self.voiceButton.setImage(#imageLiteral(resourceName: "mic"), for: .normal)
            self.voiceButton.addTarget(self, action: #selector(searchButtonAction), for: .touchUpInside)
            
            self.manageVoiceButton()
            
            self.voiceButton.isHidden = !showVoiceSearch
        }
        
        self.showsCancelButton = false
        if let d = miDelegate {
            self.delegate = d
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let textField = self.textField {
            
            self.voiceButton.frame = CGRect(x: textField.x + textField.width-textField.height, y: textField.y, width: textField.height, height: textField.height)
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                self.voiceButton.frame = CGRect(x: textField.x + textField.width-textField.height, y: textField.y, width: textField.height, height: textField.height)
            }
        }
    }
    
    @objc private func searchButtonAction() {
        if #available(iOS 10.0, *) {
            self.miDelegate?.voiceButtonAction?(self.voiceButton)
        }
    }
    
    @objc func manageVoiceButton() {
        if CommonClass.enableVoiceSearch {
            if !self.subviews.contains(self.voiceButton) {
                self.addSubview(self.voiceButton)
            }
        } else {
            self.voiceButton.removeFromSuperview()
        }
    }
}
