//
//  MIProfessionalDetailViewController.swift
//  MonsteriOS
//
//  Created by Monster on 26/10/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

enum ProfessionalDetailsEnum{
    case None
    case Fresher
    case Experienced
}
class MIProfessionalDetailViewController: MIBaseViewController {
    
    @IBOutlet weak private var professionalView:UIView!
    var experienceLevelData: ((String)->Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Professional Details"
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

        
    }
    
    func setUI() {
        self.professionalView.addShadow(opacity: 0.2)
        self.professionalView.layer.cornerRadius = CornerRadius.viewCornerRadius
    }
    
    class var newInstance:MIProfessionalDetailViewController {
        get {
            return MIProfessionalDetailViewController()//Storyboard.main.instantiateViewController(withIdentifier: "MIProfessionalDetailViewController") as! MIProfessionalDetailViewController
        }
    }
    
    @IBAction func experienceClicked(_ sender: UIButton) {
        experienceLevelData?("EXPERIENCED")
        self.navigationController?.popViewController(animated: true)

//        let vc = MIEmploymentDetailViewController.newInstance
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func fresherClicked(_ sender: UIButton) {
      
        experienceLevelData?("FRESHER")
        self.navigationController?.popViewController(animated: true)
//        let vc = MIEducationDetailViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}
