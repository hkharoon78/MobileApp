//
//  MIInfoPopOverController.swift
//  MonsteriOS
//
//  Created by Rakesh on 25/07/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

protocol DismissPopOverControllerDelegate {
  func dismissInfoPopOverController()
}

class MIInfoPopOverController: UIViewController {

    @IBOutlet weak var lbl_title:UILabel!
    @IBOutlet weak var btn_gotIt:UIButton!
    
    var btnGotItCallBack : (()->Void)?

    var message = ""
    
    var delegate: DismissPopOverControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lbl_title.text =  message
        self.btn_gotIt.setTitleColor(AppTheme.defaltBlueColor, for: .normal)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.delegate?.dismissInfoPopOverController()
       
    }
    
    @IBAction func gotItClicked(_ sender:UIButton) {
        //self.btnGotItCallBack?()
        //self.delegate?.dismissInfoPopOverController()
        self.dismiss(animated: true, completion: nil)
    }

}
