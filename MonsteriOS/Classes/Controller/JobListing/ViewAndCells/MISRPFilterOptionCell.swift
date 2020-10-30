//
//  MISRPFilterOptionCell.swift
//  MonsteriOS
//
//  Created by Rakesh on 05/08/20.
//  Copyright © 2020 Monster. All rights reserved.
//

import UIKit

class MISRPFilterOptionCell: UITableViewCell {

    @IBOutlet weak var lbl_filterTitle:UILabel?
    @IBOutlet weak var collectionView_FilterItems:UICollectionView?
    var filterItems = [String]()
    var filterOptionSelected :  ((_ itemSelected:String,_ isMoreOption:Bool,_ filterType:FilterType)->Void)?
    var filterType = FilterType.experienceRange
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let layout = CustomHorizontalLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        self.collectionView_FilterItems?.collectionViewLayout = layout
        self.collectionView_FilterItems?.register(UINib.init(nibName: "MICarrerTipCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MICarrerTipCollectionViewCell")
        self.collectionView_FilterItems?.delegate = self
        self.collectionView_FilterItems?.dataSource = self

    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showAttributedFilterTitle(title:String,attString:String,withItesm:[String]) {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = 2
        let attributed = NSMutableAttributedString(string: title + "\n" , attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font: UIFont.customFont(type: .light, size: 14),NSAttributedString.Key.paragraphStyle:paraStyle])
        
         attributed.append(NSAttributedString(string: attString, attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font: UIFont.customFont(type: .Medium, size: 14)]))
        self.lbl_filterTitle?.attributedText = attributed
        self.filterItems = withItesm
        self.collectionView_FilterItems?.reloadData()
        self.collectionView_FilterItems?.setContentOffset(.zero, animated: false)
      //  self.collectionView_FilterItems?.scrollToItem(at: IndexPath(row: 0, section: 0),at: .left,animated: true)
    }
}

extension MISRPFilterOptionCell : UICollectionViewDelegate,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filterItems.count > 5 ? 6 : self.filterItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MICarrerTipCollectionViewCell", for: indexPath) as? MICarrerTipCollectionViewCell {
            cell.showFilterData(name: filterItems[indexPath.item],itemNumber: indexPath.item, filterCategory: filterType)
            cell.carrerTip_Btn.isUserInteractionEnabled = false
           // cell.backgroundColor = .yellow
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionView.collectionViewLayout as! CustomHorizontalLayout
        let maxSize = CGSize(width: collectionView.frame.size.width - layout.sectionInset.left - layout.sectionInset.right, height: layout.itemSize.height)

        var obj = filterItems[indexPath.item]
       // obj.size(withAttributes: nil)
        if filterType == .experienceRange {
            if indexPath.item <= 4 {
                obj = obj.replacingOccurrences(of: "~", with: "-") + " Year"
            }
        }
        let frame = (obj as NSString).boundingRect(with: maxSize, options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: UIFont.customFont(type: .Regular, size: 12)], context: nil)

      //  let size =  obj.size(withAttributes:[NSAttributedString.Key.font : UIFont.customFont(type: .Regular, size: 12)])
       // print("index \(indexPath.row) size \(size)")
        var wdth : CGFloat = frame.size.width + 35
        if indexPath.item > 4 {
            wdth =  frame.size.width + 20
        }
        return CGSize(width: wdth, height: 40)
        
        //CGSize(width: wdth , height: 38)
        //CGSize(width: obj.width(withConstrainedHeight: 62, font: UIFont.customFont(type: .Regular, size: 12)), height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       
        return UIEdgeInsets(top: 12, left: 5, bottom: 12, right: 5)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item > 4 {
            //For more option clicked
            filterOptionSelected?("",true,self.filterType)
        }else{
            //Filter Item clicked
            filterOptionSelected?(filterItems[indexPath.item],false,self.filterType)

        }
    }
}
class CustomHorizontalLayout: UICollectionViewFlowLayout
{
    var _contentSize = CGSize.zero
    var itemAttributes = Array<Any>()
   // var delegate: CustomHorizontalLayoutDelegate!

    override func prepare() {
        super.prepare()
        self.itemAttributes.removeAll()
        // use a value to keep track of left margin
        var upLeftMargin: CGFloat = 8 // self.sectionInset.left
        var downLeftMargin: CGFloat = 8 //self.sectionInset.left

        let numberOfItems = self.collectionView!.numberOfItems(inSection: 0)
        for i in 0..<numberOfItems {

            let indexPath = IndexPath(item: i, section: 0)
            let refAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

            let size = delegate.collectionView?(self.collectionView!, layout: self, sizeForItemAt: indexPath)
            
           // let size = delegate.collectionView(collectionView!, sizeTagAtIndexPath: indexPath)

            if (refAttributes.frame.origin.x != self.sectionInset.left) {
                upLeftMargin = 8 //self.sectionInset.left
                downLeftMargin = 8// self.sectionInset.left
            } else {
                // set position of attributes
                var newLeftAlignedFrame = refAttributes.frame
                newLeftAlignedFrame.origin.x = (indexPath.row % 2 == 0) ? upLeftMargin : downLeftMargin
                newLeftAlignedFrame.origin.y = (indexPath.row % 2 == 0) ? 8 : 56
                newLeftAlignedFrame.size.width = size?.width as! CGFloat
                newLeftAlignedFrame.size.height = size?.height as! CGFloat
                refAttributes.frame = newLeftAlignedFrame
            }
            // calculate new value for current margin
            if(indexPath.row % 2 == 0) {
                upLeftMargin += refAttributes.frame.size.width + 8
            } else {
                downLeftMargin += refAttributes.frame.size.width + 8
            }

            self.itemAttributes.append(refAttributes)

        }

        
        
        _contentSize = CGSize(width: max(upLeftMargin, downLeftMargin), height: 110)
    }

    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.itemAttributes[indexPath.row] as? UICollectionViewLayoutAttributes

    }
//    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
//
//    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let predicate = NSPredicate { (evaluatedObject, bindings) -> Bool in
            let layoutAttribute = evaluatedObject as! UICollectionViewLayoutAttributes
            return rect.intersects(layoutAttribute.frame)
        }
        
        return (itemAttributes.filter {predicate.evaluate(with: $0)} as! [UICollectionViewLayoutAttributes])

    }
    var delegate: UICollectionViewDelegateFlowLayout {
        return self.collectionView!.delegate as! UICollectionViewDelegateFlowLayout
    }
//    override func layoutAttributesForElementsInRect(_ rect: CGRect) -> [UICollectionViewLayoutAttributes]?  {
//
//        let predicate = NSPredicate { (evaluatedObject, bindings) -> Bool in
//            let layoutAttribute = evaluatedObject as! UICollectionViewLayoutAttributes
//            return rect.intersects(layoutAttribute.frame)
//        }
//        return (itemAttibutes.filtered(using: predicate) as! [UICollectionViewLayoutAttributes])
//    }
    override var collectionViewContentSize: CGSize{
           return _contentSize
       }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false

    }
   
}
