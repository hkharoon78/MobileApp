//
//  MIImageCollectionViewCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 13/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import Photos
class MIImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tickImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    var phAsset:PHAsset?{
        didSet{
            
            getImageFromPhasset(asset: phAsset!, size: CGSize(width: 200, height: 200)) { (image) in
                self.imageView.image = image
            }
            
//            phAsset!.requestContentEditingInput(with: PHContentEditingInputRequestOptions()) { (eidtingInput, info) in
//                if let input = eidtingInput, let imgURL = input.fullSizeImageURL {
//                    self.imageURL=imgURL
//                }
//            }
        }
    }
    var imageURL:URL?
    override var isSelected: Bool{
        didSet{
            if isSelected{
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.contentView.backgroundColor = UIColor.red
                self.tickImageView.isHidden = false
            }else{
                self.transform = CGAffineTransform.identity
                self.contentView.backgroundColor = UIColor.gray
                self.tickImageView.isHidden = true
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.tickImageView.isHidden=true
        self.tickImageView.image=UIImage(color: AppTheme.defaltBlueColor)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.tickImageView.layer.borderWidth=1.0
        self.tickImageView.layer.masksToBounds = false
        self.tickImageView.layer.borderColor = UIColor.white.cgColor
        self.tickImageView.layer.cornerRadius = self.tickImageView.frame.size.height/2
        self.tickImageView.clipsToBounds = true
    }
}

public extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}


func getImageFromPhasset(asset:PHAsset,size:CGSize, completion: @escaping ((UIImage?)->Void) ) {
    let manager = PHImageManager.default()
    let options = PHImageRequestOptions()
    options.isSynchronous = true
    options.deliveryMode = .highQualityFormat
    options.resizeMode = .fast

    manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: options, resultHandler: {(result, info)->Void in
           // returnImage = result

        completion(result)
    })
}

func getImageURLFromPhasset(mPhasset:PHAsset)->URL?{
    let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
    options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
        return true
    }
    var returnURL:URL?
    mPhasset.requestContentEditingInput(with: options, completionHandler: { (contentEditingInput, info) in
        returnURL=contentEditingInput!.fullSizeImageURL
    })
    return returnURL
}
