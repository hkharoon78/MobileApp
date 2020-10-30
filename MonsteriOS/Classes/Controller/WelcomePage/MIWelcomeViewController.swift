//
//  MIWelecomeViewController.swift
//  MonsteriOS
//
//  Created by Monster on 15/10/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIWelcomeViewController: UIViewController, UIScrollViewDelegate {
  
    
    let pagingTotalCount = 3
    private var nojobPopup  = MINoJobFoundPopupView.popup()
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.setUI()
        
        if (!MIReachability.isConnectedToNetwork()){
            self.nojobPopup.show(ttl: ErrorAndValidationMsg.opps.rawValue, desc:ErrorAndValidationMsg.somethingWrong.rawValue,imgNm: "plugbase")
            self.nojobPopup.addFromTop(onView: self.view, topHeight: 180, onCompletion: nil)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden=true
        self.title = ""

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden=false
    }
 
}
