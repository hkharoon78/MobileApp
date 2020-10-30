//
//  MIGleacBenchmarkVC.swift
//  MonsteriOS
//
//  Created by Anushka on 17/06/20.
//  Copyright © 2020 Monster. All rights reserved.
//

import UIKit

class MIGleacBenchmarkVC: MIBaseViewController {
   
    //MARK:- IBOutlet
   // @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imgSkill: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var location: UILabel!

    @IBOutlet weak var viewStep1: UIView!
    @IBOutlet weak var viewStep2: UIView!

    @IBOutlet weak var skillTest: UILabel!
    @IBOutlet weak var btnLater: UIButton!
    @IBOutlet weak var btnStart: UIButton!
    
        
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Benchmark Yourself"
        
        self.imgSkill.applyCircular()
        self.viewStep1.applyCircular()
        self.viewStep1.applyCircular()

        self.btnStart.layer.cornerRadius = 4.0
        self.btnStart.layer.masksToBounds = false

        self.name.text = AppDelegate.instance.userInfo.fullName
        self.email.text = AppDelegate.instance.userInfo.primaryEmail
        self.location.text = AppDelegate.instance.userInfo.country


        self.imgSkill.addPlaceHolderIcon(AppDelegate.instance.userInfo.fullName, font: UIFont.customFont(type: .Semibold, size: 25))
        self.imgSkill.isUserInteractionEnabled = false

        if !AppDelegate.instance.userInfo.avatar.isEmpty {
            self.imgSkill.isUserInteractionEnabled = true
            self.imgSkill.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileImgTapped(_:))))
            self.imgSkill.removePlaceHolderIcon()
            self.imgSkill.cacheImage(urlString: AppDelegate.instance.userInfo.avatar)

        }
        
    }
    
    //MARK:- IBAction
    @IBAction func btnLaterPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnStartPressed(_ sender: UIButton) {
        
    }

    
    
    @objc func profileImgTapped(_ gesture: UITapGestureRecognizer) {
        guard let image = (gesture.view as? UIImageView)?.image else { return }
        
        let enlargeVC = MIImageEnlargeViewController()
        enlargeVC.modalPresentationStyle = .overCurrentContext
        enlargeVC.img = image
        self.present(enlargeVC, animated: false, completion: nil)
        
    }




}
