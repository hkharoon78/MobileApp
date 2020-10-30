//
//  MIProjectImagesTableCell.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 22/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIProjectImagesTableCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        self.collectionView.register(nib: MIAttachmentCollectionCell.loadNib(), forCellWithClass: MIAttachmentCollectionCell.self)
        
        collectionView.dataSource = self
        collectionView.delegate   = self        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension MIProjectImagesTableCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.width-20)/3 - 10, height: (UIScreen.width-20)/3 - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: MIAttachmentCollectionCell.self, for: indexPath)
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonAction(_:)), for: .touchUpInside)
        
        cell.attachmentImageView.image = #imageLiteral(resourceName: "test1")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    @objc func deleteButtonAction(_ sender: UIButton) {
        
    }
}
