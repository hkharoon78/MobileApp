//
//  MITagViewCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 09/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import TagListView
class MITagViewCell: UITableViewCell {

    @IBOutlet weak var tagView: TagListView!
    @IBOutlet weak var bgView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        tagView.paddingX = 10
        tagView.paddingY = 10
        tagView.marginY  = 8
        tagView.marginX = 10
        tagView.delegate=self
        tagView.tagBackgroundColor = .white
        
        // Initialization code
    }

    override func setNeedsLayout() {
       // super.setNeedsLayout()
        if self.tagView != nil {
            _ = self.tagView.tagViews.map({$0.cornerRadius = $0.frame.size.height/2})

        }

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureView(config:ConfigureTagView){
        
        tagView.cornerRadius = config.cornerRadius ?? 3.0
        tagView.textColor = config.textColor ?? AppTheme.appGreyColor
        tagView.tintColor = config.tintColor
        tagView.textFont  = config.font ?? UIFont.customFont(type: .Regular, size: 12)
        tagView.borderColor = config.borderColor //UIColor.init(hex: "d9d9d9")
        tagView.borderWidth = config.borderWidth ?? 0.0
        tagView.backgroundColor  = .clear
        
        tagView.tagBackgroundColor = config.backgroundColor ?? AppTheme.defaltLightBlueColor

     //   self.contentView.backgroundColor = config.backgroundColor ?? .white
    }
    func addTags(_ tags:[String]){
       self.tagView.removeAllTags()
       self.tagView.addTags(tags)
    }
    var tagTapAction:((String,TagView)->Void)?
    
}
extension MITagViewCell:TagListViewDelegate{
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        //self.tagView.removeTag(title)
//        if tagView.tagBackgroundColor == Color.colorLightDefault {
//            tagView.tagBackgroundColor = UIColor.white
//            tagView.textColor          = UIColor.black
//        } else {
//            tagView.tagBackgroundColor = Color.colorLightDefault
//            tagView.textColor          = UIColor.white
//        }
        
        if let action=tagTapAction{
            action(title,tagView)
            
        }
    }
}
