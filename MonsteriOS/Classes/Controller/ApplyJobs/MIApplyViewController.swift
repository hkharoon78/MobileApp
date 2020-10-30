//
//  MIApplyViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 29/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIApplyViewController: UIViewController {
    
    @IBOutlet weak var darkView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    var pendingItemModel : MIPendingItemModel?
    var pendinActionSuccess:((Bool)->Void)?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let tapGes=UITapGestureRecognizer(target: self, action: #selector(MIApplyViewController.dismissController(_:)))
        tapGes.numberOfTapsRequired=1
        darkView.addGestureRecognizer(tapGes)
        self.titleLabel.text = pendingItemModel?.pendingActionType.title
        self.subTitleLabel.text = pendingItemModel?.pendingActionType.applydescription
        self.uploadButton?.setTitle(pendingItemModel?.pendingActionType.actionBtnTitle, for: .normal)
        self.uploadButton.setTitleColor(AppTheme.defaltBlueColor, for: .normal)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title=""
        //self.tabBarController?.tabBar.isHidden=true
        self.navigationController?.navigationBar.isHidden=true
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title=""
       // self.tabBarController?.tabBar.isHidden=false
        self.navigationController?.navigationBar.isHidden=false
    }
    
    @IBAction func notNowButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadButtonAction(_ sender: UIButton) {
        switch pendingItemModel?.pendingActionType {
        case .PROFILE_SUMMARY?:
            break
        case .RESUME?:
            if let uploadResum = pendingItemModel?.pendingActionType.viewControler as? MIUploadResumeViewController {
                uploadResum.flowVia = .ViaPendingResume
                uploadResum.resumeUploadedAction = {(status,name,result) in
                    self.successUpdate()
                }
                
                self.navigationController?.pushViewController(uploadResum, animated: false)
            }
        case .EDUCATION?:
            if let addEducationVc = pendingItemModel?.pendingActionType.viewControler as? MIEducationDetailViewController {
                addEducationVc.educationFlow = .ViaProfileAdd
                
                addEducationVc.educationAddedSuccess = {success in
                    
                    self.successUpdate()
                }
                self.navigationController?.pushViewController(addEducationVc, animated: false)
            }
            break
        case .PERSONAL?:
            if let personalVC = pendingItemModel?.pendingActionType.viewControler as? MIPersonalDetailVC {
                personalVC.personalDetailUpdateSuccessCallBack = {status in
                   self.successUpdate()
                }
                self.navigationController?.pushViewController(personalVC, animated: false)
            }
            break
            
        case .VERIFY_EMAIL_ID?:
            if let emailverifyVC = pendingItemModel?.pendingActionType.viewControler as? MIForgotPasswordViewController {
                self.navigationController?.pushViewController(emailverifyVC, animated: false)
            }
            break
            
        case .VERIFY_MOBILE_NUMBER?:
            if let emailverifyVC = pendingItemModel?.pendingActionType.viewControler as? MIForgotPasswordViewController {
                self.navigationController?.pushViewController(emailverifyVC, animated: false)
            }
            break
            
        case .EMPLOYMENT?:
            if let employmentVC = pendingItemModel?.pendingActionType.viewControler as? MIEmploymentDetailViewController {
                
                employmentVC.employementFlow = .ViaProfileAdd
                employmentVC.employementAddedSuccess = {status in
                    self.successUpdate()
                }
                self.navigationController?.pushViewController(employmentVC, animated: false)
            }
            break
            
        case .PROJECTS?:
            if let projectVC = pendingItemModel?.pendingActionType.viewControler as? MIProjectDetailVC {
                self.navigationController?.pushViewController(projectVC, animated: false)
            }
            break
            
        default:
            break
            
        }
        
    }
    
    @objc func dismissController(_ sender:UITapGestureRecognizer){
        if sender.state == .ended {
            let touchLocation: CGPoint = sender.location(in: sender.view)
            if !self.innerView.frame.contains(touchLocation){
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    func successUpdate(){
        if let action=self.pendinActionSuccess{
            action(true)
        }
        self.dismiss(animated: false, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
