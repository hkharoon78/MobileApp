//
//  MIResumeInitiateViewController.swift
//  MonsteriOS
//
//  Created by Monster on 26/10/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIResumeInitiateViewController: MIBaseViewController {
    
    @IBOutlet weak private var tblView: UITableView!
    private var cellId = "resume_initiate_cell"
    
    private var resumeInitiateArray = [MIResumeInitiateInfo]()
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "How do you want to start?"
        MIUserModel.resetUserResumeData()

    }
    
    class var newInstance:MIResumeInitiateViewController {
        get {
            return Storyboard.main.instantiateViewController(withIdentifier: "MIResumeInitiateViewController") as!  MIResumeInitiateViewController
        }
    }
    
    //MARK :- Private Methods
    func showUI() {
        
        self.tblView.register(UINib(nibName: "MIResumeInitiateCell", bundle: nil), forCellReuseIdentifier: cellId)
        var info = MIResumeInitiateInfo.init(with: "create_resume_icon", ttl: "Create a new resume", ttlInfo: "Takes 5 minutes to complete", titleDt: "We will help you create a resume step-by-step")
        self.resumeInitiateArray.append(info)
        info = MIResumeInitiateInfo.init(with: "upload_resume_icon", ttl: "I already have a resume", ttlInfo: "Takes 2 minutes to complete", titleDt: "We will fill in the information so you don’t have to.")
        self.resumeInitiateArray.append(info)
        
        tblView.separatorColor = UIColor.clear
        self.tblView.reloadData()
    }
}

extension MIResumeInitiateViewController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resumeInitiateArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tblView.dequeueReusableCell(withIdentifier: cellId) as? MIResumeInitiateCell {
            cell.showUI(info: resumeInitiateArray[indexPath.row])
            if indexPath.row == 1 {
                cell.titleBtn.showPrimaryBtn(fontSize: 14)
            }
            return cell
        }
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if MIUserModel.userSharedInstance.userProfessionalType == .Fresher {
                let vc = MIEducationDetailViewController()
                self.navigationController?.pushViewController(vc, animated: true)

            }else{
                let vc = MIEmploymentDetailViewController.newInstance
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            self.navigationController?.pushViewController(MIUploadResumeViewController(), animated: true)
        }
    }
}
