//
//  MIResumeSelectionViewController.swift
//  MonsteriOS
//
//  Created by Rakesh on 29/04/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIResumeSelectionViewController: UIViewController {

    @IBOutlet weak var resumeOptionFirst_ImgSelection : UIImageView!
    @IBOutlet weak var resumeOptionSnd_ImgSelection : UIImageView!
    @IBOutlet weak var confirmSelection_Btn : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        resumeOptionFirst_ImgSelection.isHidden = true
        resumeOptionSnd_ImgSelection.isHidden = true
        confirmSelection_Btn.showPrimaryBtn()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Resume"

        
    }
    @IBAction func resumeSelectionAction(_ sender: UIButton) {
        resumeOptionFirst_ImgSelection.isHidden = true
        resumeOptionSnd_ImgSelection.isHidden = true

        if sender.tag == 101 {
            resumeOptionFirst_ImgSelection.isHidden = false

        }else{
            resumeOptionSnd_ImgSelection.isHidden = false

        }
        
    }
    @IBAction func selectionConfirmatioAction(_ sender:UIButton){
        
        
    }

}
