//
//  MIFilterJobTableViewCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 21/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIFilterJobTableViewCell: UITableViewCell {

    //MARK:Outlets And Variables
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var filterTitleLabel: UILabel!
    var addAndRemoveBorder=false{
        didSet{
            if addAndRemoveBorder{
                topView.layer.borderWidth=0.3
                topView.layer.borderColor=AppTheme.textColor.cgColor
                topView.layer.masksToBounds=false
                topView.backgroundColor=AppTheme.viewBackgroundColor
                contentView.backgroundColor=AppTheme.viewBackgroundColor
                filterTitleLabel.textColor=AppTheme.textColor
            }else{
                topView.layer.borderWidth=0
                topView.layer.borderColor=UIColor.white.cgColor
                topView.layer.masksToBounds=false
                topView.backgroundColor=UIColor.white
                contentView.backgroundColor=UIColor.white
                filterTitleLabel.textColor=AppTheme.defaltBlueColor
            }
        }
    }
    @IBOutlet weak var countLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var filterCountLabel: UILabel!{
        didSet{
            filterCountLabel.backgroundColor = AppTheme.defaltBlueColor
            filterCountLabel.applyCircular()
            filterCountLabel.font=UIFont.customFont(type: .Regular, size: 12)
            filterCountLabel.textColor = .white
            filterCountLabel.textAlignment = .center
        }
    }
    var modelData:FilterJobModelData!{
        didSet{
            self.filterTitleLabel.text=modelData.filterTitle
            if modelData.filterCount==0{
                self.filterCountLabel.isHidden=true
                self.countLabelWidth.constant=0
            }else{
                self.filterCountLabel.isHidden=false
                self.countLabelWidth.constant=25
                self.filterCountLabel.text = String(modelData.filterCount ?? 0)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        filterTitleLabel.font=UIFont.customFont(type: .Medium, size: 12)
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
       // topView.backgroundColor = .white
       // topView.layer.borderColor=UIColor.white.cgColor
        //topView.layer.masksToBounds=false
    }
    
}

class FilterJobModelData{
    var filterTitle:String?
    var filterCount:Int?
    init(title:String,filterCount:[FilterModel]) {
        self.filterTitle=title
        self.filterCount=filterCount.filter({$0.isSelected}).count
        //self.filterCount=filter.count
    }
}
