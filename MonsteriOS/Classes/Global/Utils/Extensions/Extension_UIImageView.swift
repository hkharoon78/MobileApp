//
//  Extension_UIImageView.swift
//  MonsteriOS
//
//  Created by ishteyaque on 20/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import SDWebImage

let imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView{
    
    func cacheImageWithCompletion(urlString: String, completionHandler: ((_ image: UIImage) -> ())? = nil){
        
        let url = URL(string: urlString.encodedUrl())
        image = nil
        
        //        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
        //            self.image = imageFromCache
        //            return
        //        }
        URLSession.shared.dataTask(with: url!) {
            data, response, error in
            DispatchQueue.main.async {
                if data != nil,let imageToCache = UIImage(data: data!) {
                    //  imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                    self.image = imageToCache
                    completionHandler!((imageToCache))
                } 
            }
            }.resume()
    }
    
    func cacheImage(urlString: String){
        let url = URL(string: urlString.encodedUrl())
        image = nil
        
//        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
//            self.image = imageFromCache
//            return
//        }
        URLSession.shared.dataTask(with: url!) {
            data, response, error in
            if data != nil {
                DispatchQueue.main.async {
                    if let imageToCache = UIImage(data: data!){
                      //  imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                        self.image = imageToCache
                    }
                }
            }
            }.resume()
    }
    
    
    func setImage(with url: String?, placeholder: UIImage? = nil) {
        
        guard let url = url, let imageURL = URL(string: url) else {
            self.image = placeholder
            return
        }
        
        let complated: SDExternalCompletionBlock = { (image, error, cacheType, imageURL) -> Void in
        }
        self.sd_setImage(with: imageURL, placeholderImage: placeholder, completed: complated)
    }
    func rotateView(angle:CGFloat, duration: Double = 1.0) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            self.transform = self.transform.rotated(by: angle)
        }) { finished in

        }
    }
    
    
}

extension UIView{
    func applyCircular(){
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
}


extension UIImage {
    
    func resizeImage(_ newWidth: CGFloat = 900) -> UIImage {
        
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}
