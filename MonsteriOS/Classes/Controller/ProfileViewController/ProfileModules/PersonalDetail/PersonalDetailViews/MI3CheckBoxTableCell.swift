//
//  MI3CheckBoxTableCell.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 24/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

protocol MILanguageCheckBoxClickedDelegate:class {
    func checkBoxClicked(info:MIProfileLanguageInfo?);
}

class MI3CheckBoxTableCell: UITableViewCell {

    @IBOutlet weak var btnRead: UIButton!
    @IBOutlet weak var btnWrite: UIButton!
    @IBOutlet weak var btnSpeak: UIButton!
    weak var delegate:MILanguageCheckBoxClickedDelegate?
    var languageInfo   = MIProfileLanguageInfo(dictionary: [:])
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }
    
    func show() {
        self.btnRead.isSelected = self.languageInfo?.read ?? false
        self.btnWrite.isSelected = self.languageInfo?.write ?? false
        self.btnSpeak.isSelected = self.languageInfo?.speak ?? false
    }
    
    @IBAction func checkBoxBtnClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender == self.btnRead {
            self.languageInfo?.read = sender.isSelected
        }
        else if sender == self.btnWrite {
            self.languageInfo?.write = sender.isSelected
        }
        else if sender == self.btnSpeak {
            self.languageInfo?.speak = sender.isSelected
        }
        self.delegate?.checkBoxClicked(info: self.languageInfo)
    }
}
