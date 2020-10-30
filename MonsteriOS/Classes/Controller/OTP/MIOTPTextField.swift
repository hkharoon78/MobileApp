//
//  MIOTPTextField.swift
//  MonsteriOS
//
//  Created by ishteyaque on 09/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation
import UIKit.UITextField

class OTPTextField: UITextField {
    //MARK:Variables
    var onDeleteBackwards: (() -> Void)?
    
    //MARK:Intializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    func setUpView(){
        self.keyboardType = .numberPad
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 3
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.masksToBounds=false
        self.textAlignment = .center
        self.font=UIFont.customFont(type: .Regular, size: 24)
    }
    
    //MARK:Delegate method implementation
    override func deleteBackward() {
        onDeleteBackwards?()
        // Call super afterwards. The `text` property will return text prior to the delete.
        super.deleteBackward()
    }
    
}
