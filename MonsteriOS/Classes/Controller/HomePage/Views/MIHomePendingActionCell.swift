//
//  MIHomePendingActionCell.swift
//  MonsteriOS
//
//  Created by Piyush on 16/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIHomePendingActionCell: UITableViewCell,UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var qrCurrIndex = 0
    let count = 4
    
    var pendingType : PendingActionType = PendingActionType.NONE
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
        pageControl.pageIndicatorTintColor = UIColor.colorWith(r: 43, g: 56, b: 87, a: 0.2)
        pageControl.currentPageIndicatorTintColor = AppTheme.defaltBlueColor
    }
    
    
    func removeAllViewsFromScrollView() {
        for vv in self.scrollView.subviews {
            vv.removeFromSuperview()
        }
        self.layoutIfNeeded()
        self.setNeedsLayout()
    }
    
    func addPendingView(pendingItemList: [MIPendingItemModel]) {
        
        self.removeAllViewsFromScrollView()
        self.backgroundColor = UIColor(hex: "f4f6f8")

        let pendingModelVisible = pendingItemList.filter() { $0.pendingItemStateVisible == true }
        self.pageControl.numberOfPages = pendingModelVisible.count
        
        for index in 0..<pendingModelVisible.count {
            
            let uploadView = MIHomeUploadResumeView.view
            
            let viewWidth = kScreenSize.width
//            var frame = CGRect()
//            if index != 0 {
//                frame = CGRect(x: viewWidth*CGFloat(index) -  35*CGFloat(index), y: 1, width: viewWidth, height:  uploadView.frame.size.height)
//            } else {
//                frame = CGRect(x: viewWidth*CGFloat(index) , y: 1, width: viewWidth, height:  uploadView.frame.size.height)
//            }
//            uploadView.frame = frame
            uploadView.frame = CGRect(x: viewWidth*CGFloat(index) , y: 1, width: viewWidth, height:  uploadView.frame.size.height)
            uploadView.showData(pendingItem: pendingModelVisible[index])
           
            uploadView.tag = 10 + index
            scrollView.addSubview(uploadView)
            scrollView.contentSize = CGSize(width: uploadView.frame.maxX, height: 0)
            self.scrollHeightConstraint.constant = uploadView.frame.size.height + 3
            
        }
        
        self.scrollView.isPagingEnabled = true
        self.layoutIfNeeded()
        self.setNeedsLayout()
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentTab = scrollView.contentOffset.x / (kScreenSize.width)
        pageControl.currentPage = Int(currentTab)
        
//        let currentTab = scrollView.contentOffset.x / (kScreenSize.width - 35)
//        pageControl.currentPage = Int(currentTab)
//        let curr_index = Int((scrollView.contentOffset.x)/(kScreenSize.width - 35))
//        let tagValue = 10 + curr_index
//
//        if let qrView = scrollView.viewWithTag(tagValue-1) as? MIHomeUploadResumeView {
//            if curr_index != (count-1) {
//                let frame = CGRect(x: (CGFloat(curr_index - 1) * kScreenSize.width) + 35,
//                                   y: scrollView.bounds.origin.y,
//                                   width: kScreenSize.width,
//                                   height: scrollView.bounds.size.height)
//                qrView.frame = frame
//            } else {
//                let frame = CGRect(x: (CGFloat(curr_index - 1) * kScreenSize.width) - CGFloat(35*(curr_index-1)),
//                                   y: scrollView.bounds.origin.y,
//                                   width: kScreenSize.width,
//                                   height: scrollView.bounds.size.height)
//                qrView.frame = frame
//            }
//
//        }
//
//        if let qrView = scrollView.viewWithTag(tagValue) as? MIHomeUploadResumeView {
//            var lastOffset = 0
//            if curr_index == (count-1) {
//                lastOffset = 35*(curr_index)
//            }
//            let frame = CGRect(x: ((CGFloat(curr_index) * kScreenSize.width)) - CGFloat(lastOffset),
//                               y: scrollView.bounds.origin.y,
//                               width: kScreenSize.width,
//                               height: scrollView.bounds.size.height)
//            qrView.frame = frame
//        }
//        if let qrView = scrollView.viewWithTag(tagValue+1) as? MIHomeUploadResumeView {
//            let frame = CGRect(x: (CGFloat(curr_index+1) * kScreenSize.width)-35,
//                               y: scrollView.bounds.origin.y,
//                               width: kScreenSize.width,
//                               height: scrollView.bounds.size.height)
//            qrView.frame = frame
//        }
        
        
    }
}
