//
//  MIHomeVideoCollectionCell.swift
//  MonsteriOS
//
//  Created by Anushka on 21/09/20.
//  Copyright © 2020 Monster. All rights reserved.
//

import UIKit

class MIHomeVideoCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var backView: UIView?
    @IBOutlet weak var btnVideoIcon: UIButton!
    
    var videoCallBack: (()->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    self.backView?.roundCorner(1, borderColor: UIColor.colorWith(r: 238, g: 229, b: 229, a: 1.0), rad: CornerRadius.viewCornerRadius)
    self.backgroundColor = UIColor.white

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func showVideo(info: MIHomeVideos) {
        imgView.cacheImage(urlString: info.image)
        lblTitle.text = info.name
        // self.videoUrl = info.video_url
        btnVideoIcon.isHidden = false
    }
    
    @IBAction func videoBtnPressed(_ sender: UIButton){
        self.videoCallBack?()
    }

}
