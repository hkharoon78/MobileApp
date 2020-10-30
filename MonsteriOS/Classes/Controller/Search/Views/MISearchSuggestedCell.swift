//
//  MISearchSuggestedCell.swift
//  MonsteriOS
//
//  Created by Piyush on 10/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

protocol MISearchSuggestedCellDelegate:class {
    func searchSuggestionCellClicked(ttl:String)
}

class MISearchSuggestedCell: UITableViewCell,MISearchAutoSuggestionDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    weak var delegate:MISearchSuggestedCellDelegate?
    
    var topSpace    = 10
    var bottomSpace = 10
    var itemSpacing = 10
    var leftMargin  = 10
    var rightMargin = 5
    var totalHeight = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func addSuggestionList(list:[MIAutoSuggestInfo], selectedList:[String]) {
        for view in self.scrollView.subviews {
            view.removeFromSuperview()
        }
        let totalWidth = kScreenSize.width //- CGFloat(rightMargin)
        var yMargin  = 0
        var lastXMargin = leftMargin
        for index in 0..<list.count {
            let sugView = MISearchAutoSuggestionView.suggestionView
            sugView.show(ttl: list[index].name)
            if selectedList.contains(list[index].name) {
                sugView.showSelectedView()
            }
            sugView.delegate = self
            sugView.frame.size.width = sugView.titleLbl.frame.size.width + 20
            
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
    
    func suggestionClicked(name: String) {
        self.delegate?.searchSuggestionCellClicked(ttl: name)
    }
}
