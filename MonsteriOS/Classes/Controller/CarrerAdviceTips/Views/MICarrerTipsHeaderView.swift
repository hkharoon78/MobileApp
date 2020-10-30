//
//  MICarrerTipsHeaderView.swift
//  MonsteriOS
//
//  Created by Rakesh on 24/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MICarrerTipsHeaderView: UIView {

    @IBOutlet weak var collectionView : UICollectionView!
    var tipsData = [MICarrerTipsModel]()
    
    class var headerView : MICarrerTipsHeaderView {
        return UINib.init(nibName: "MICarrerTipsHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MICarrerTipsHeaderView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = AppTheme.viewBackgroundColor
        self.setUpView()
    }
    
    //MARK: -  Helper Methods
    func setUpView() {
        self.collectionView.register(UINib.init(nibName: "MICarrerTipCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MICarrerTipCollectionViewCell")
    }
}

extension MICarrerTipsHeaderView : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,TipOptionSelectionDelegate {
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tipsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MICarrerTipCollectionViewCell", for: indexPath) as? MICarrerTipCollectionViewCell {
            cell.showData(obj: self.tipsData[indexPath.item])
            cell.delegate = self
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let obj = self.tipsData[indexPath.item]
        return CGSize(width: obj.contentSizeWidth+40, height: 60)
    }
    
    //MARK: - TipOptionSelectionDelegate Methods
    func tipOptionClicked(selectedObj: MICarrerTipsModel) {
       _ =  self.tipsData.map { $0.flag = false }
        selectedObj.flag = !selectedObj.flag
        self.collectionView.reloadData()

    }
    
    
}
