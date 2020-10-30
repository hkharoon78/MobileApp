//
//  MIImageEnlargeViewController.swift
//  MonsteriOS
//
//  Created by Rakesh on 13/02/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIImageEnlargeViewController: UIViewController {

    @IBOutlet weak var scrollView:UIScrollView?
    @IBOutlet weak var doneBtn:UIButton?

    var img : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneBtn?.showPrimaryBtn()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let image = img else {return}
        let view = UIView(frame:self.view.frame)
                  let imgView = UIImageView(image: image)
                  imgView.center = self.view.center
                  imgView.size = CGSize(width: image.size.width, height: image.size.height)
                  view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
                  view.addSubview(imgView)
        self.view.addSubview(view)
//        self.doneBtn?.bringSubviewToFront(self.view)
        self.view.bringSubviewToFront(self.doneBtn!)
                  //view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedEnlargeProfileImage)))
    }
   
    @objc func dismissController(_ sender:UITapGestureRecognizer){
        self.dismissWithAnimation()

        

        //        if sender.state == .ended {
//            let touchLocation: CGPoint = sender.location(in: sender.view)
//            if !self.imgView.frame.contains(touchLocation){
//                self.dismiss(animated: true, completion: nil)
//            }
//        }
        
    }
   
    @IBAction func btnDonePressed(_ sender:UIButton) {
        self.dismissWithAnimation()
        //self.dismiss(animated: false, completion: nil)
    }
    func dismissWithAnimation(){
        UIView.animate(withDuration: 1, animations: {
            self.view.alpha -= 0.2
        }) { (status) in
            self.view.alpha = 0
            self.dismiss(animated: true, completion: nil)

        }

    }
}

extension MIImageEnlargeViewController : UIScrollViewDelegate {
    
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return self.imgView
//    }
}
