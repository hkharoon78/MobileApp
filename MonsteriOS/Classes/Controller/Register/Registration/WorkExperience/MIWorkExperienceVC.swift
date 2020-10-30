//
//  MIWorkExperienceVC.swift
//  MonsteriOS
//
//  Created by Anushka on 22/07/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIWorkExperienceVC: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var imgView_FresherTick: UIImageView!
    @IBOutlet weak var imgView_ExperienceDropDown: UIImageView!
    @IBOutlet weak var tblView_Year: UITableView!
    @IBOutlet weak var tblView_Month: UITableView!    
    @IBOutlet weak var view_Seprator: UIView!
    @IBOutlet weak var lbl_Fresher: UILabel!
    @IBOutlet weak var lbl_Experience: UILabel!
    @IBOutlet weak var yearsLabel: UILabel!
    @IBOutlet weak var monthsLabel: UILabel!
    
    var experienceInYear : String?
    var experienceInMonth : String?
    var professionalType: UserProfessionalCategory = .None
    var workExperienceSelected : ((_ workProfessional:UserProfessionalCategory,_ yearOfExp:String?,_ monthOfExp:String?)->Void)?
    var isProExpand = false
  
    var rightBarButton : UIBarButtonItem {
        return UIBarButtonItem(title: NavigationBarButtonTitle.done, style: .plain, target: self, action: #selector(MIWorkExperienceVC.doneBtnClicked(_:)))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()
    }
    
    func initialSetup() {
        
        self.tblView_Year.delegate = self
        self.tblView_Year.dataSource = self
        self.tblView_Month.delegate = self
        self.tblView_Month.dataSource = self
        self.yearsLabel.font=UIFont.customFont(type: .Semibold, size: 14)
        self.monthsLabel.font=UIFont.customFont(type: .Semibold, size: 14)
        self.yearsLabel.text="\tYears"
        self.monthsLabel.text="\tMonths"
        self.tblView_Month.register(UINib(nibName: "MIDefaultSelectionCell", bundle: nil), forCellReuseIdentifier: "defaultCell")
        self.tblView_Year.register(UINib(nibName: "MIDefaultSelectionCell", bundle: nil), forCellReuseIdentifier: "defaultCell")
      
        self.tblView_Year.isHidden = true
        self.tblView_Month.isHidden = true
        self.view_Seprator.isHidden = true
        self.yearsLabel.isHidden=true
        self.monthsLabel.isHidden=true
        self.getAttributedString(normalString: "I am a ", normalFont: UIFont.customFont(type: .Regular, size: 16), normalTextColor: UIColor(hex: "212b36"), stringToAttributed: "Fresher", attributedFont: UIFont.customFont(type: .Medium, size: 16), attributedTextColor: UIColor(hex: "212b36"), forExpLabel: false)
        self.getAttributedString(normalString: "I am ", normalFont: UIFont.customFont(type: .Regular, size: 16), normalTextColor: UIColor(hex: "212b36"), stringToAttributed: "Experienced", attributedFont: UIFont.customFont(type: .Medium, size: 16), attributedTextColor: UIColor(hex: "212b36"), forExpLabel: true)
      //  let skipButton=UIBarButtonItem(title: NavigationBarButtonTitle.done, style: .plain, target: self, action: #selector(MIWorkExperienceVC.doneBtnClicked(_:)))


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Work Experience"
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)
       
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if professionalType != .None {
            if professionalType == .Experienced {
                isProExpand = true
                if self.navigationItem.rightBarButtonItem == nil {
                    self.navigationItem.rightBarButtonItem = rightBarButton
                }
            }
            self.manageTableViewDataBasedOnProfessionalType(type: self.professionalType)
        }
    }
    
    @IBAction func btnFresherAction(_ sender:UIButton) {
        if let callBack = self.workExperienceSelected {
            callBack(.Fresher,nil,nil)
        }
        self.navigationController?.popViewController(animated: true)
        //self.manageTableViewDataBasedOnProfessionalType(type: .Fresher)
    }
    @IBAction func btnExperienceAction(_ sender:UIButton) {
        isProExpand =  !isProExpand
        self.manageTableViewDataBasedOnProfessionalType(type: .Experienced)
    }
    @objc func doneBtnClicked(_ sender:UIBarButtonItem){
        if professionalType == .None {
            self.showAlert(title: "", message: "Please select your work experience.")
        }else{
            if let callBack = self.workExperienceSelected {
                callBack(self.professionalType,experienceInYear,experienceInMonth)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    func manageTableViewDataBasedOnProfessionalType(type:UserProfessionalCategory) {

        professionalType = type
        if professionalType == .Experienced {
            if isProExpand {
                self.tblView_Year.isHidden  =  false
                self.tblView_Month.isHidden =  false
                self.view_Seprator.isHidden =  false
                self.yearsLabel.isHidden=false
                self.monthsLabel.isHidden=false

            }else{
                self.hideTableWithAnimation()
            }
            self.imgView_ExperienceDropDown.rotateView(angle: isProExpand ? CGFloat(Double.pi/2) : CGFloat(-(Double.pi/2)) , duration: 0.25)
            self.tblView_Year.reloadSections(IndexSet(integer:0), with: .fade)
            self.tblView_Month.reloadSections(IndexSet(integer:0), with:.fade)

        }else{
           // self.hideTableWithAnimation()
        }
    }
    func hideTableWithAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.tblView_Year.isHidden = true
            self.tblView_Month.isHidden = true
            self.view_Seprator.isHidden = true
            self.yearsLabel.isHidden=true
            self.monthsLabel.isHidden=true
        })
    }
    func getAttributedString(normalString:String,normalFont:UIFont,normalTextColor:UIColor,stringToAttributed:String,attributedFont:UIFont,attributedTextColor:UIColor,forExpLabel:Bool) {

        let titleString = NSMutableAttributedString(string:normalString, attributes: [NSAttributedString.Key.foregroundColor:normalTextColor,NSAttributedString.Key.font:normalFont])
        let attrbuted = NSAttributedString(string:stringToAttributed, attributes: [NSAttributedString.Key.foregroundColor:attributedTextColor,NSAttributedString.Key.font:attributedFont])
        titleString.append(attrbuted)

        if forExpLabel {
            self.lbl_Experience.attributedText = titleString
        }else{
            self.lbl_Fresher.attributedText = titleString
        }
    }
}

extension MIWorkExperienceVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell") as? MIDefaultSelectionCell {
       //  var subtitle="Years"
            cell.accessoryType = .none
            cell.tintColor = AppTheme.defaltBlueColor

            if tableView == tblView_Year {
//                if indexPath.row == 0 || indexPath.row == 1{
//                    subtitle = "Year"
//                }
                
                if let selectedYear = self.experienceInYear {
                    if selectedYear == "\(indexPath.row)" {
                        cell.accessoryType = .checkmark
                    }
                }
            } else {
//                if indexPath.row == 0 || indexPath.row == 1{
//                    subtitle = "Month"
//                }else{
//                    subtitle = "Months"
//                }
                if let selectedMonth = self.experienceInMonth {
                    if selectedMonth == "\(indexPath.row)" {
                        cell.accessoryType = .checkmark
                    }
                }
            }
            cell.showTitle(title: "\(indexPath.row)")
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isProExpand {
            if tableView == self.tblView_Year {
                return 51
            }else{
                return 12
            }
        }else{
            return 0
        }
        //        if professionalType == .Fresher || professionalType == .None {
//            return 0
//        }else{
//
//        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tblView_Year {
            experienceInYear = "\(indexPath.row)"
            self.tblView_Year.reloadData()
        }else{
            experienceInMonth = "\(indexPath.row)"
            self.tblView_Month.reloadData()
        }
        if self.navigationItem.rightBarButtonItem == nil {
            self.navigationItem.rightBarButtonItem = rightBarButton
        }
    }
}
