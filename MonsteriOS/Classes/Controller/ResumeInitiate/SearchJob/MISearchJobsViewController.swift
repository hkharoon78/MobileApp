//
//  MISearchJobsViewController.swift
//  MonsteriOS
//
//  Created by Monster on 16/10/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MISearchJobsViewController: MIBaseViewController {

    @IBOutlet weak private var searchBtn: UIButton!
    class var newInstance:MISearchJobsViewController {
        let vc = Storyboard.main.instantiateViewController(withIdentifier: "MISearchJobsViewController") as! MISearchJobsViewController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBtn.showPrimaryBtn()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title="Search Job"
    }

    @IBAction func searchBtnClicked(_ sender: UIButton) {
        
    }
    
}
