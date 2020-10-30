//
//  SubmitAndSkipView.swift
//  MonsteriOS
//
//  Created by ishteyaque on 28/05/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class SubmitAndSkipView: UIView {

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    var submitAndSkipButtonAction:((Int)->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        configure()
    }
    func configure(){
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "Skip & Apply")
     //   attributeString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        attributeString.addAttribute(.foregroundColor, value: AppTheme.defaltBlueColor, range: NSMakeRange(0, attributeString.length))
        skipButton.tag=1
       // skipButton.setTitleColor(AppTheme.defaltTheme, for: .normal)
        skipButton.setAttributedTitle(attributeString, for: .normal)
        submitButton.setTitle("Submit & Apply", for: .normal)
        submitButton.tag=0
        submitButton.showPrimaryBtn()
    }
    
    @IBAction func submitAndApplyButton(_ sender: UIButton) {
        if let action=submitAndSkipButtonAction{
            action(sender.tag)
        }
    }
    

}
