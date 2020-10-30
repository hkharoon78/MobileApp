//
//  MIMultiprofileApplyViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 19/03/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIMultiprofileApplyViewController: UIViewController {

    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var darkView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var existingProfileModels = [MIExistingProfileInfo]()
    var applyActionSuccess:((Bool,Int)->Void)?
    
    @IBOutlet weak var activeTitleLabel: UILabel!{
        didSet{
            activeTitleLabel.font=UIFont.customFont(type: .Regular, size: 10)
            activeTitleLabel.textColor=AppTheme.textColor
        }
    }
    
    @IBOutlet weak var alwaysTitleLabel: UILabel!{
        didSet{
            alwaysTitleLabel.font=UIFont.customFont(type: .Regular, size: 14)
            alwaysTitleLabel.textColor=UIColor.black
        }
    }
  //  @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden=true
        // Do any additional setup after loading the view.
       
        applyButton.showPrimaryBtn()
        self.applyButton.setTitle("Apply", for: .normal)
        checkImageView.isUserInteractionEnabled = true
        self.checkImageView.image = UIImage(named:"checkbox_default")
        
        let checkBxTap=UITapGestureRecognizer(target: self, action: #selector(MIMultiprofileApplyViewController.checkBoxAction(_:)))
        checkBxTap.numberOfTapsRequired=1
        self.checkImageView.addGestureRecognizer(checkBxTap)
        innerView.backgroundColor=AppTheme.viewBackgroundColor
       
        tableView.register(UINib(nibName:String(describing: MIApplyMultipleTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIApplyMultipleTableViewCell.self))
        
        tableView.delegate=self
        tableView.dataSource=self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView=UIView(frame: .zero)
        tableView.bounces=true
        tableView.separatorStyle = .none
        tableView.backgroundColor = AppTheme.viewBackgroundColor
        
        alwaysTitleLabel.text="Don't show me this message again"
       // activeTitleLabel.text="Please note your active profile will be used for all future applications.You can manage your profile under my profile section."
        activeTitleLabel.text=""
        
        let tapGes=UITapGestureRecognizer(target: self, action: #selector(MIMultiprofileApplyViewController.dismissController(_:)))
        tapGes.numberOfTapsRequired=1
        darkView.addGestureRecognizer(tapGes)
        alwaysTitleLabel.isHidden=true
        self.checkImageView.isHidden=true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

    }
    
    @objc func dismissController(_ sender:UITapGestureRecognizer){
        if sender.state == .ended {
            let touchLocation: CGPoint = sender.location(in: sender.view)
            if !self.innerView.frame.contains(touchLocation){
                self.dismiss(animated: true, completion: nil)
            }else{
                let touchTablePoint=sender.location(in: self.tableView)
                if let section=self.tableView.indexPathForRow(at: touchTablePoint){
                    let _ = self.existingProfileModels.map({$0.active=false})
                    self.existingProfileModels[section.section].active=true
                    shouldRunProfileApi=true
                    self.tableView.reloadData()
                }
               
            }
        }
        
    }

    @objc func checkBoxAction(_ sender:UITapGestureRecognizer){
        if checkImageView.image == UIImage(named:"checkbox_default") // #imageLiteral(resourceName: "checkbox_default")
        {
            checkImageView.image = UIImage(named:"checkbox_clicked") //#imageLiteral(resourceName: "checkbox_clicked")
        }else{
            checkImageView.image = UIImage(named:"checkbox_default")// #imageLiteral(resourceName: "checkbox_default")
        }
    }
    
    @IBAction func applyButtonAction(_ sender: UIButton) {
        let profilefilter=self.existingProfileModels.filter({$0.active==true})
        if profilefilter.count > 0{
            if let action=self.applyActionSuccess{
                action(true,profilefilter[0].id)
                UserDefaults.standard.set(profilefilter[0].id, forKey: "profileId")
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension MIMultiprofileApplyViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.existingProfileModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell=tableView.dequeueReusableCell(withIdentifier: String(describing: MIApplyMultipleTableViewCell.self), for: indexPath) as? MIApplyMultipleTableViewCell else{
            return UITableViewCell()
        }
        cell.tintColor = AppTheme.defaltBlueColor

        let row = self.existingProfileModels[indexPath.section]
        if row.title.isEmpty {
            cell.profileTitleLabel.text = "Profile title not available"
        } else {
            cell.profileTitleLabel.text = row.title
        }
        if row.active{
        cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let _ = self.existingProfileModels.map({$0.active=false})
        self.existingProfileModels[indexPath.section].active=true
        shouldRunProfileApi=true
        self.tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "f4f6f8")
        return v
    }
}
