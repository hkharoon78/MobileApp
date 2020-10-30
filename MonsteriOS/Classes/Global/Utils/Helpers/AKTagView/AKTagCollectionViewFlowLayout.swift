//
//  AKTagCollectionViewFlowLayout.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 04/06/20202.
//  Copyright © 2020 Anupam Katiyar. All rights reserved.
//

import UIKit


class AKTagCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    var itemAttributes = Array<Any>()
    var contentHeight: CGFloat!
    
    override init() {
        super.init()
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    private func setup() {
        self.itemSize = CGSize(width: 100, height: 35)
        self.scrollDirection = UICollectionView.ScrollDirection.horizontal
        self.minimumInteritemSpacing = 10.0
        self.minimumLineSpacing = 10.0
        self.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    override func prepare() {
        self.itemAttributes.removeAll()
        
        self.contentHeight = self.sectionInset.top + self.itemSize.height
        var originX = self.sectionInset.left
        var originY = self.sectionInset.top
        
        let itemCount = self.collectionView!.numberOfItems(inSection: 0)
        
        for i in 0..<itemCount {
            
            let indexPath = IndexPath(item: i, section: 0)
            let itemSize = self.itemSizeForIndexPath(indexPath)
            
            if ((originX + itemSize.width + self.sectionInset.right) > self.collectionView!.frame.size.width) {
                originX = self.sectionInset.left;
                originY += itemSize.height + self.minimumLineSpacing
                
                self.contentHeight = self.contentHeight + (itemSize.height + self.minimumLineSpacing)
            }
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            attributes.frame = CGRect(x: originX, y: originY, width: itemSize.width, height: itemSize.height)
            self.itemAttributes.append(attributes)
            originX += itemSize.width + self.minimumInteritemSpacing
        }
        
        self.contentHeight = self.contentHeight + self.sectionInset.bottom
    }
    
    override var collectionViewContentSize: CGSize{
        return CGSize(width: self.collectionView!.frame.size.width, height: self.contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.itemAttributes as? [UICollectionViewLayoutAttributes]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        let oldBounds = self.collectionView!.bounds
        if (newBounds.size.width != oldBounds.size.width) {
            return true
        }
        return false
    }
    
    var delegate: UICollectionViewDelegateFlowLayout {
        return self.collectionView!.delegate as! UICollectionViewDelegateFlowLayout
    }
    
    
    func itemSizeForIndexPath(_ indexPath: IndexPath) -> CGSize {
        if delegate.responds(to: #selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:sizeForItemAt:))) {
            var size = delegate.collectionView!(collectionView!, layout: self, sizeForItemAt: indexPath)
            let contentWidth = collectionView!.bounds.size.width - sectionInset.left - sectionInset.right
            size.width = size.width > contentWidth ? contentWidth : size.width
            self.itemSize.width = size.width
        }
        return self.itemSize
    }
        
}
