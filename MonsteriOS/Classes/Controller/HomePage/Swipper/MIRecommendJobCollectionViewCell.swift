//
//  MIRecommendJobCollectionViewCell.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 28/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
var noMoreData="OH NO!!"
var noMoreSubTitle="Feels sad when things don’t match?\nDon’t worry, your jobs will definitely match if you edit your job preferences"
var noMorebuttonTitle="Edit Preference"
class MIRecommendJobCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    var contentItem: MISwipableCardView!
    var noMoreContent:NoMoreJobsSwiperView!
    var isNoMore=false{
        didSet{
            if !isNoMore{
                contentItem = Bundle.main.loadNibNamed("MISwipableCardView", owner: self, options: nil)![0] as? MISwipableCardView
                self.containerView.addSubview(contentItem)
                
                NSLayoutConstraint.activate([
                    contentItem.topAnchor.constraint(equalTo: containerView.topAnchor),
                    contentItem.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                    contentItem.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                    contentItem.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
                    ])
                
                self.contentItem.translatesAutoresizingMaskIntoConstraints = false
            }else{
                noMoreContent = NoMoreJobsSwiperView()
                self.containerView.addSubview(noMoreContent)
                self.noMoreContent.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    noMoreContent.topAnchor.constraint(equalTo: containerView.topAnchor),
                    noMoreContent.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                    noMoreContent.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                    noMoreContent.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
                    ])
                //noMoreContent.noMoreTitle.text=noMoreData
               // noMoreContent.subTitleLabel.text=noMoreSubTitle
                
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
   }
    
    func showData(_ item: JoblistingCellModel) {
       // if isNoMore{
        contentItem.showData(item)
      //  }
    }

}
