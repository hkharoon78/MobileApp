//
//  MIFrequencyTableViewCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 18/09/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIFrequencyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var button1: UIButton!
    //        {
    //        didSet {
    //            button1.titleLabel?.font = UIFont.customFont(type: .Regular, size: 12)
    //            button1.setTitleColor(UIColor(hex: "505050"), for: .normal)
    //        }
    //    }
    @IBOutlet weak var yesButton: UIButton!
    //        {
    //        didSet {
    //            yesButton.titleLabel?.font = UIFont.customFont(type: .Regular, size: 12)
    //            yesButton.setTitleColor(UIColor(hex: "505050"), for: .normal)
    //        }
    //    }
    @IBOutlet weak var noButton: UIButton!
    //        {
    //        didSet {
    //            noButton.titleLabel?.font = UIFont.customFont(type: .Regular, size: 12)
    //            noButton.setTitleColor(UIColor(hex: "505050"), for: .normal)
    //        }
    //    }
    var viewModel:FrequencyModel!{
        didSet{
            if viewModel.title?.caseInsensitiveCompare("Weekly") == .orderedSame{
                yesButton.isSelected = true
                // yesButton.setImage(#imageLiteral(resourceName: "off-1"), for: .normal)
            } else if viewModel.title?.caseInsensitiveCompare("Monthly") == .orderedSame{
                noButton.isSelected = true
                // noButton.setImage(#imageLiteral(resourceName: "off-1"), for: .normal)
            } else if viewModel.title?.caseInsensitiveCompare("Daily") == .orderedSame{
                button1.isSelected = true
                // button1.setImage(#imageLiteral(resourceName: "off-1"), for: .normal)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        button1.setImage(#imageLiteral(resourceName: "off-2"), for: .normal)
        yesButton.setImage(#imageLiteral(resourceName: "off-2"), for: .normal)
        noButton.setImage(#imageLiteral(resourceName: "off-2"), for: .normal)
        
//        button1.setTitle(" Daily", for: .normal)
//        yesButton.setTitle(" Weekly", for: .normal)
//        noButton.setTitle(" Monthly", for: .normal)
        
        if AppDelegate.instance.site?.defaultCountryDetails.isoCode.oneOf("SA", "SG") ?? false {
            self.button1.isHidden = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        yesButton.isSelected = false
        noButton.isSelected = false
        button1.isSelected = false

//        yesButton.setImage(#imageLiteral(resourceName: "off-2"), for: .normal)
//        noButton.setImage(#imageLiteral(resourceName: "off-2"), for: .normal)
//        button1.setImage(#imageLiteral(resourceName: "off-2"), for: .normal)
    }
    @IBAction func yesButtonAction(_ sender: UIButton) {
        self.buttonSelection(sender)
        //button1.setImage(#imageLiteral(resourceName: "off-2"), for: .normal)
        //noButton.setImage(#imageLiteral(resourceName: "off-2"), for: .normal)
        //yesButton.setImage(#imageLiteral(resourceName: "off-1"), for: .normal)
        viewModel.title="Weekly"
        viewModel.id="500730bf-fc6f-11e8-92d8-000c290b6677"
    }
    
    @IBAction func noButtonAction(_ sender: UIButton) {
        self.buttonSelection(sender)
        //button1.setImage(#imageLiteral(resourceName: "off-2"), for: .normal)
        //yesButton.setImage(#imageLiteral(resourceName: "off-2"), for: .normal)
        //noButton.setImage(#imageLiteral(resourceName: "off-1"), for: .normal)
        //// viewModel.answer="No"
        viewModel.title="Monthly"
        viewModel.id="40e5635d-fc6f-11e8-92d8-000c290b6677"
    }
    
    @IBAction func button1Action(_ sender: UIButton) {
        self.buttonSelection(sender)
        //noButton.setImage(#imageLiteral(resourceName: "off-2"), for: .normal)
        //yesButton.setImage(#imageLiteral(resourceName: "off-2"), for: .normal)
        //button1.setImage(#imageLiteral(resourceName: "off-1"), for: .normal)
        viewModel.title="Daily"
        viewModel.id="3651c8e0-fc6f-11e8-92d8-000c290b6677"
        
    }
    
    func buttonSelection(_ sender: UIButton) {
        yesButton.isSelected = false
        noButton.isSelected = false
        button1.isSelected = false
        
        sender.isSelected = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


class FrequencyModel{
    public var title:String? = ""
    public var id:String? = ""
    init(title:String?,id:String?) {
        self.title=title
        self.id=id
    }
}
