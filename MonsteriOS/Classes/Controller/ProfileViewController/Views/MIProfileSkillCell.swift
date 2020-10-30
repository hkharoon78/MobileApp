//
//  MIProfileSkillCell.swift
//  MonsteriOS
//
//  Created by Piyush on 17/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

protocol MIProfileSkillCellDelegate:class {
    func skillRemoved(skillName:String)
}

class MIProfileSkillCell: UITableViewCell, MIProfileSuggestionViewDelegate {
    
    weak var delegate: MIProfileSkillCellDelegate?
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!

    var topSpace = 10
    var bottomSpace = 10
    var itemSpacing = 10
    var leftMargin  = 10
    var rightMargin  = 5
    var totalHeight = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }
    
    func removeDataFromScrollView() {
        for view in scrollView.subviews {
            view.removeFromSuperview()
        }
    }
    
    func addSuggestionList(list:[MIUserSkills]) {
        
        var mlist = list
        mlist = mlist.filter({$0.skillName != ""})
        self.removeDataFromScrollView()
        let totalWidth = kScreenSize.width - CGFloat(rightMargin)
        var yMargin  = 0
        var lastXMargin = leftMargin
        if list.count == 0 {
            self.scrollViewHeightConstraint.constant = 0
        }
        
        for index in 0..<mlist.count {
            let info = mlist[index]
            let sugView = MISuggestionView.suggestionView
            sugView.backgroundColor = AppTheme.defaltBlueColor
          
            let ttl     = info.skillName
            sugView.show(ttl: ttl)
            sugView.delegate = self
            sugView.frame.size.width = sugView.titleLbl.frame.size.width + 40
            
            if Int(totalWidth) < (lastXMargin + Int(sugView.frame.size.width)) {
                lastXMargin = leftMargin
                yMargin = yMargin + Int(sugView.frame.size.height) + topSpace
            }
            
            sugView.frame = CGRect(x: CGFloat(lastXMargin), y: CGFloat(yMargin), width: sugView.frame.size.width, height: sugView.frame.size.height)
            lastXMargin = itemSpacing + Int(sugView.frame.maxX)
            self.scrollView.addSubview(sugView)
            self.scrollViewHeightConstraint.constant = CGFloat(yMargin) + sugView.frame.size.height
        }
        
        self.layoutIfNeeded()
        self.setNeedsLayout()
    }
    
    
    func addSuggestionListString(list:[String]) {
        self.removeDataFromScrollView()
        let totalWidth = kScreenSize.width - CGFloat(rightMargin)
        var yMargin  = 0
        var lastXMargin = leftMargin
        if list.count == 0 {
            self.scrollViewHeightConstraint.constant = 0
        }
        for index in 0..<list.count {
            let info = list[index]
           
            let sugView = MISuggestionView.suggestionView
            sugView.backgroundColor = AppTheme.defaltBlueColor
            sugView.show(ttl: info)
            sugView.delegate = self
            sugView.frame.size.width = sugView.titleLbl.frame.size.width + 40
            
            if Int(totalWidth) < (lastXMargin + Int(sugView.frame.size.width)) {
                lastXMargin = leftMargin
                yMargin = yMargin + Int(sugView.frame.size.height) + topSpace
            }
            
            sugView.frame = CGRect(x: CGFloat(lastXMargin), y: CGFloat(yMargin), width: sugView.frame.size.width, height: sugView.frame.size.height)
            lastXMargin = itemSpacing + Int(sugView.frame.maxX)
            self.scrollView.addSubview(sugView)
            self.scrollViewHeightConstraint.constant = CGFloat(yMargin) + sugView.frame.size.height
        }
        
    }
//    func removeObject(ttl: String) {
//        if self.list.contains(ttl) {
//            self.removeSelectedObject(value: ttl)
//            self.addSuggestionList()
//        }
//    }
//
//
    
    func removeObject(ttl: String) {
        self.delegate?.skillRemoved(skillName: ttl)
    }
}
