//
//  AKTagListView.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 04/06/20202.
//  Copyright © 2020 Anupam Katiyar. All rights reserved.
//  Refrence: JCTag

import UIKit

internal typealias AKTagListViewBlock = (Int) -> ()
internal typealias AKTagDeleteBlock = (Int, AKTag) -> ()


@IBDesignable
class AKTagListView: UIView {
    
    @IBInspectable var tagStrokeColor: UIColor = .lightGray
    @IBInspectable var tagSelectedStrokeColor: UIColor = .lightGray
    @IBInspectable var tagTextColor: UIColor = .darkGray
    @IBInspectable var tagSelectedTextColor: UIColor = .darkGray
    @IBInspectable var tagBackgroundColor: UIColor = .clear
    @IBInspectable var tagSelectedBackgroundColor: UIColor = UIColor(red: 217, green: 217, blue: 217)
    
    @IBInspectable var canSelectTags: Bool = false
    @IBInspectable var tagCornerRadius: CGFloat = 0
    @IBInspectable var tagCircularRadius: Bool = false
    @IBInspectable var tagTextFont: UIFont = UIFont.systemFont(ofSize: 14)
    @IBInspectable var tagleftRightPadding: CGFloat = 40
    @IBInspectable var showLeftView: Bool = true
    @IBInspectable var showRightView: Bool = true

    private var tags = [AKTag]()
    private var selectedTags = [AKTag]()
    
    private var deleteBlock: AKTagDeleteBlock?
    private var selectedBlock: AKTagListViewBlock?
    private var collectionView: UICollectionView!
    private let reuseIdentifier = "tagListViewItemId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.collectionView.frame = self.bounds
    }

    private func setup() {
        
        let layout = AKTagCollectionViewFlowLayout()
        
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        // collectionView.scrollEnabled = false;
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(AKTagCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.addSubview(self.collectionView)
    }
    
    func selectedTagAtIndex(_ block: @escaping AKTagListViewBlock) {
        self.selectedBlock = block
    }
    func tagDeletedAtIndex(_ block: @escaping AKTagDeleteBlock) {
        self.deleteBlock = block
    }
    
    func selectTags(_ tags: [AKTag]) {
        self.selectedTags.append(contentsOf: tags)
        
        self.collectionView.reloadData()
    }
    
//    func makeSelfSizingView() {
//        self.collectionView.isScrollEnabled = false
//        self.collectionView.sizeToFit()
//        
//        self.height = self.getContentHeight()
//    }
}

//MARK:- UICollectionViewDelegate | UICollectionViewDataSource
extension AKTagListView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let layout = collectionView.collectionViewLayout as! AKTagCollectionViewFlowLayout
        let maxSize = CGSize(width: collectionView.frame.size.width - layout.sectionInset.left - layout.sectionInset.right, height: layout.itemSize.height)
        
        let frame = (self.tags[indexPath.item].name as NSString).boundingRect(with: maxSize, options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: tagTextFont], context: nil)
        
        var padding: CGFloat = 0
        if self.showLeftView {
            padding = padding + tagleftRightPadding
        } else {
            padding = padding + kXAxisPadding
        }
        if self.showRightView {
            padding += tagleftRightPadding
        } else {
            padding = padding + kXAxisPadding
        }
        return CGSize(width: frame.size.width + padding, height: frame.size.height + 20.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AKTagCell
        cell.closeButton.addTarget(self, action: #selector(deleteTagAction(_:)), for: .touchUpInside)
        cell.closeButton.tag = indexPath.item
        cell.tagleftRightPadding = tagleftRightPadding
        
        let tag = self.tags[indexPath.row]
        cell.setupData(tag)
        
        cell.showLeftView = self.showLeftView
        cell.showRightView = self.showRightView

        cell.backgroundColor = self.tagBackgroundColor
        cell.layer.borderColor = self.tagStrokeColor.cgColor
        if tagCircularRadius {
            cell.layer.cornerRadius = cell.frame.size.height/2
        } else {
            cell.layer.cornerRadius = self.tagCornerRadius
        }

        cell.titleLabel.textColor = self.tagTextColor
        cell.titleLabel.font = self.tagTextFont
        
        if self.selectedTags.contains(where: { $0 == tag }) {
            cell.backgroundColor = self.tagSelectedBackgroundColor
            cell.layer.borderColor = self.tagSelectedStrokeColor.cgColor
            cell.titleLabel.textColor = self.tagSelectedTextColor
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.canSelectTags {
            let cell = collectionView.cellForItem(at: indexPath) as! AKTagCell
            
            if let index =  self.selectedTags.firstIndex(where: { $0 == self.tags[indexPath.item] }) {
                cell.backgroundColor = self.tagBackgroundColor
                cell.layer.borderColor = self.tagStrokeColor.cgColor
                cell.titleLabel.textColor = self.tagTextColor
                self.selectedTags.remove(at: index)
            } else {
                cell.backgroundColor = self.tagSelectedBackgroundColor;
                cell.layer.borderColor = self.tagSelectedStrokeColor.cgColor
                cell.titleLabel.textColor = self.tagSelectedTextColor;
                self.selectedTags.append(self.tags[indexPath.item])
            }
        }
        self.selectedBlock?(indexPath.item)
    }
    
    @objc private func deleteTagAction(_ sender: UIButton) {
        let item = self.tags.remove(at: sender.tag)
        self.collectionView.reloadData()
        self.deleteBlock?(sender.tag, item)
    }
}

extension AKTagListView {
    
    func removeTag(_ tag: AKTag) {
        guard let index = self.allTags.firstIndex(where: { $0 == tag }) else { return }
        let item = self.tags.remove(at: index)
        self.collectionView.reloadData()
        self.deleteBlock?(index, item)
    }
    
    func removeAllTags() {
        self.tags.removeAll()
        self.selectedTags.removeAll()
        self.collectionView.reloadData()
    }
    
    func removeSelectedTags() {
        self.selectedTags.removeAll()
        self.collectionView.reloadData()
    }
    
    func addTag(_ name: String) {
        let tag = AKTag(id: "", name: name)
        self.tags.append(tag)
        self.collectionView.reloadData()
        self.scrollToBottom(true)
    }
    
    func addTag(_ tagArray: [String]) {
        let tagsArr = tagArray.map { (text) -> AKTag in
            return AKTag(id: "", name: text)
        }
        self.tags.append(contentsOf: tagsArr)
        self.collectionView.reloadData()
        self.scrollToBottom(true)
    }
    
    func addTag(_ tag: AKTag) {
        self.tags.append(tag)
        self.collectionView.reloadData()
        self.scrollToBottom(true)
    }
    
    func addTag(_ tagArray: [AKTag]) {
        self.tags.append(contentsOf: tagArray)
        self.collectionView.reloadData()
        self.scrollToBottom(true)
    }
    
    var allTags: [AKTag] {
        return self.tags
    }
    
    var allSelectedTags: [AKTag] {
        return self.selectedTags
    }
    
    func getContentHeight() -> CGFloat {
        //let layout = self.collectionView.collectionViewLayout as! AKTagCollectionViewFlowLayout
        //layout.calculateContentHeight(tags: self.tags)
        return self.collectionView.contentSize.height
    }

    private func scrollToBottom(_ animated: Bool) {
        //self.collectionView.scrollToItem(at: IndexPath(item: self.collectionView.numberOfItems-1, section: 0), at: .bottom, animated: animated)
    }
    
    
    func calculateContentHeight() -> CGFloat {
        
        let layout = self.collectionView.collectionViewLayout as! AKTagCollectionViewFlowLayout

        var contentHeight = layout.sectionInset.top + layout.itemSize.height
        
        var originX = layout.sectionInset.left
        var originY = layout.sectionInset.top
        
        for i in 0..<allTags.count {
            
            let maxSize = CGSize(width: self.collectionView.width - layout.sectionInset.left - layout.sectionInset.right, height: layout.itemSize.height)
            
            let frame = (tags[i].name as NSString).boundingRect(with: maxSize, options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0)], context: nil)
            
            var padding: CGFloat = 0
            if self.showLeftView {
                padding = padding + tagleftRightPadding
            } else {
                padding = padding + kXAxisPadding
            }
            if self.showRightView {
                padding += tagleftRightPadding
            } else {
                padding = padding + kXAxisPadding
            }
            let itemSize = CGSize(width: frame.size.width + padding, height: layout.itemSize.height)
            
            if ((originX + itemSize.width + layout.sectionInset.right) > self.collectionView.width) {
                originX = layout.sectionInset.left
                originY += itemSize.height + layout.minimumLineSpacing
                contentHeight += itemSize.height + layout.minimumLineSpacing
            }
            originX += itemSize.width + layout.minimumInteritemSpacing
            
        }
        contentHeight += layout.sectionInset.bottom;
        
        return contentHeight
    }

}
