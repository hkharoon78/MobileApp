//
//  MISkillAddTableViewCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 06/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
//import WSTagsField

class MISkillAddTableViewCell: UITableViewCell {
    
    var tagsField = WSTagsField()
    var doneActionClicked : ((Bool)-> Void)?
    @IBOutlet weak var skillLabel: UILabel!
    @IBOutlet weak var skillLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var seprator_View: UIView!

    @IBOutlet weak var skillLabelTop: NSLayoutConstraint!
    @IBOutlet weak var topView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tagsField.spaceBetweenLines = 20
        tagsField.spaceBetweenTags = 8
        self.addDoneButtonOnKeyboard()
        tagsField.delimiter = "        "
        tagsField.backgroundColor = .red
        tagsField.translatesAutoresizingMaskIntoConstraints = false
         topView.addSubview(tagsField)
        NSLayoutConstraint.activate([
            tagsField.topAnchor.constraint(equalTo: skillLabel.bottomAnchor,constant: 0),
            tagsField.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 16),
            tagsField.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -16),
            tagsField.bottomAnchor.constraint(equalTo: topView.bottomAnchor,constant:-4),
            tagsField.heightAnchor.constraint(lessThanOrEqualToConstant: 180)
            ])
  
    }
    
    func addDoneButtonOnKeyboard() {
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: kScreenSize.width, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        doneToolbar.barTintColor = AppTheme.viewBackgroundColor
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction(_:)))
        done.tintColor = AppTheme.defaltBlueColor
        
        let items : [UIBarButtonItem] = [flexSpace,done]
   //     items.append(flexSpace)
    //    items.append(done)
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        tagsField.inputFieldAccessoryView = doneToolbar
      //  tagsField.returnKeyType = .next
    }
    
    @objc func doneButtonAction(_ sender: UIBarButtonItem) {
        self.superview?.endEditing(true)
        self.endEditing(true)
        if let action = doneActionClicked {
            action(true)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.topView.addShadow(opacity: 1)
    }
    
    func configureView(config:ConfigureTagView){
      // topView.layer.cornerRadius=config.topViewRadius ?? 0
        skillLabel.text=config.titleLabelText
        if config.titleLabelText==nil{
            skillLabelHeight.constant=0
            skillLabelTop.constant=0
            skillLabel.isHidden=true
        }
        tagsField.cornerRadius = config.cornerRadius ?? 3.0
        tagsField.contentInset = config.contentInset ?? UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 10)
        tagsField.placeholder = config.placeholder ?? ""
        tagsField.placeholderColor = config.placeholderColor
        tagsField.placeholderAlwaysVisible = config.placeholderAlwaysVisible ?? false
        tagsField.textColor = config.textColor
        tagsField.tintColor = config.tintColor
        tagsField.fieldTextColor =  config.fieldTextColor
        tagsField.selectedColor = config.selectedColor
        tagsField.font=config.font
        tagsField.backgroundColor = config.backgroundColor
        tagsField.borderColor = config.borderColor
        tagsField.borderWidth = config.borderWidth ?? 0.0
        tagsField.isDelimiterVisible=config.isDelimiterVisible ?? false
    }
    func manageLayoutForPopUp(){
        tagsField.roundCorner(1, borderColor: .lightGray, rad: 8)
        tagsField.showsVerticalScrollIndicator = false
        tagsField.showsHorizontalScrollIndicator = false
        skillLabelHeight.constant=0
        skillLabelTop.constant=0
        skillLabel.isHidden=true

        seprator_View.isHidden = true
        NSLayoutConstraint.activate([
            tagsField.topAnchor.constraint(equalTo: skillLabel.bottomAnchor,constant: 0),
            tagsField.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 16),
            tagsField.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -16),
            tagsField.bottomAnchor.constraint(equalTo: topView.bottomAnchor,constant:-4),
            tagsField.heightAnchor.constraint(lessThanOrEqualToConstant: 150)
            ])
    }
    
}

class ConfigureTagView{
    var topViewRadius:CGFloat?
    var titleLabelText:String?
    var cornerRadius:CGFloat?
    var contentInset:UIEdgeInsets?
    var placeholder:String?
    var placeholderColor:UIColor?
    var placeholderAlwaysVisible:Bool?
    var textColor:UIColor?
    var tintColor:UIColor?
    var fieldTextColor:UIColor?
    var selectedColor:UIColor?
    var backgroundColor:UIColor?
    var font:UIFont?
    var borderColor:UIColor?
    var borderWidth:CGFloat?
    var isDelimiterVisible:Bool?
    init(topViewRadius:CGFloat?,titleLabelText:String?,cornerRadius:CGFloat?,contentInset:UIEdgeInsets?,placeholder:String?,placeholderColor:UIColor?,placeholderAlwaysVisible:Bool?,textColor:UIColor?,tintColor:UIColor?,fieldTextColor:UIColor?,selectedColor:UIColor?,font:UIFont?,backgroundColor:UIColor?,borderColor:UIColor?,borderWidth:CGFloat?,isDelimiterVisible:Bool?) {
        self.topViewRadius=topViewRadius
        self.titleLabelText=titleLabelText
        self.cornerRadius=cornerRadius
        self.contentInset=contentInset
        self.placeholder=placeholder
        self.placeholderColor=placeholderColor
        self.placeholderAlwaysVisible=placeholderAlwaysVisible
        self.textColor=textColor
        self.tintColor=tintColor
        self.fieldTextColor=fieldTextColor
        self.selectedColor=selectedColor
        self.font=font
        self.backgroundColor=backgroundColor
        self.borderWidth=borderWidth
        self.borderColor=borderColor
        self.isDelimiterVisible=isDelimiterVisible
    }
    
}
