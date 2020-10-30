//
//  MIVerifyMailViewController.swift
//  MonsteriOS
//
//  Created by Piyush on 24/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIVerifyMailViewController: MIBaseViewController {
    @IBOutlet weak private var imgView: UIImageView!
    @IBOutlet weak private var titleLbl: UILabel!
    @IBOutlet weak private var msgStatusLbl: UILabel!
    @IBOutlet weak private var mailIdLbl: UILabel!
    @IBOutlet weak private var resendVerificationBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Verify"
    }
    
    @IBAction func resendVerificationClicked(_ sender: UIButton) {
    }
}
