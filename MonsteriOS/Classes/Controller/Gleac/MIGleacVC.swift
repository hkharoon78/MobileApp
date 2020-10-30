//
//  MIGleacVC.swift
//  MonsteriOS
//
//  Created by Anushka on 16/06/20.
//  Copyright © 2020 Monster. All rights reserved.
//

import UIKit

class MIGleacVC: MIBaseViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var imgSkill: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var viewSkill: UIView!
    @IBOutlet weak var viewWork: UIView!
    @IBOutlet weak var viewStep1: UIView!
    @IBOutlet weak var viewStep2: UIView!
    
    @IBOutlet weak var step1SkillTest: UILabel!
    @IBOutlet weak var step2Skill: UILabel!
    @IBOutlet weak var btnLater: UIButton!
    @IBOutlet weak var btnStart: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
   // var candidateID = ""
    var gleacReportUpdateCallBack: ((Bool)-> Void)?
    
    
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.title = "Benchmark Yourself"
                
        self.imgSkill.applyCircular()
        self.viewStep1.applyCircular()
        self.viewStep2.applyCircular()

        self.btnStart.layer.cornerRadius = 4.0
        self.btnStart.layer.masksToBounds = false
        self.viewSkill.layer.cornerRadius = 7.0
        self.viewSkill.layer.masksToBounds = false
        self.viewWork.layer.cornerRadius = 7.0
        self.viewWork.layer.masksToBounds = false
        
        self.name.text = AppDelegate.instance.userInfo.fullName
        self.email.text = AppDelegate.instance.userInfo.primaryEmail
        
        if let city = AppDelegate.instance.userInfo.additionPersonalInfo?.cityName, !city.withoutWhiteSpace().isEmpty {
            self.location.text = city
        } else if let location = AppDelegate.instance.userInfo.additionPersonalInfo?.currentlocation.name {
            self.location.text = location
        } else {
            self.location.text = ""
        }
        
        self.imgSkill.addPlaceHolderIcon(AppDelegate.instance.userInfo.fullName, font: UIFont.customFont(type: .Semibold, size: 25))
        self.imgSkill.isUserInteractionEnabled = false

        if !AppDelegate.instance.userInfo.avatar.isEmpty {
            self.imgSkill.isUserInteractionEnabled = true
            self.imgSkill.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileImgTapped(_:))))
            self.imgSkill.removePlaceHolderIcon()
            self.imgSkill.cacheImage(urlString: AppDelegate.instance.userInfo.avatar)
        }
        
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(image: #imageLiteral(resourceName: "back_bl"), style: .done, target: self, action:#selector(backAction(_:)))
        
        self.boldTextSkill() //step1 skill text bold
        
       // self.getCandidateID()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)
       
        self.navigationController?.navigationBar.barTintColor = UIColor(hex: "E4E8EB")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor(hex: "424343")
        
        self.scrollView.fitSizeOfContent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)

        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.tintColor = AppTheme.defaltBlueColor
    }
    
    
    //MARK:- IBAction
    @IBAction func btnLaterPressed(_ sender: UIButton) {
        CommonClass.googleEventTrcking("gleac_softskills_screen", action: "later", label: "")
        let dic = ["later" : true]
        self.gleacReportMapEvents(dic, pagetype: CONSTANT_JOB_SEEKER_TYPE.GLEAC_PAGE, destination: self.screenName)

        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnStartPressed(_ sender: UIButton) {
        CommonClass.googleEventTrcking("gleac_softskills_screen", action: "start", label: "")
        
         let dic = ["start" : true]
        self.gleacReportMapEvents(dic, pagetype: CONSTANT_JOB_SEEKER_TYPE.GLEAC_PAGE, destination: self.screenName)
        
        self.getCandidateID()
        
//        if !self.candidateID.isEmpty {
//             self.hitGleacInstruction(self.candidateID)
//        } else {
//            self.getCandidateID()
//        }
        
    }
    
    @objc func backAction(_ sender: Any) {
        CommonClass.googleEventTrcking("gleac_softskills_screen", action: "back_button", label: "")
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func profileImgTapped(_ gesture: UITapGestureRecognizer) {
//        guard let image = (gesture.view as? UIImageView)?.image else { return }
//        
//        let enlargeVC = MIImageEnlargeViewController()
//        enlargeVC.modalPresentationStyle = .overCurrentContext
//        enlargeVC.img = image
//        self.present(enlargeVC, animated: false, completion: nil)
    }
    
    
    func boldTextSkill() {
        
         let attributed = NSMutableAttributedString(string: "Only top skills from the " , attributes: [NSAttributedString.Key.foregroundColor : UIColor(hex: "797979"), NSAttributedString.Key.font: UIFont.customFont(type: .Regular, size: 14)])
        
         attributed.append(NSAttributedString(string: "1 min test", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "797979"), NSAttributedString.Key.font: UIFont.customFont(type: .Bold, size: 14)]))
        
        attributed.append(NSAttributedString(string: " will be added to Monster’s Soft Skills Index", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "797979"), NSAttributedString.Key.font: UIFont.customFont(type: .Regular, size: 14)]))
        
        self.step1SkillTest.attributedText = attributed
        
        self.step2Skill.font = UIFont.customFont(type: .Regular, size: 14)
        self.step2Skill.textColor = UIColor(hexString: "797979")
        
    }
    
}

extension MIGleacVC {
    
    func getCandidateID() {
        
        MIActivityLoader.showLoader()
        MIApiManager.hitGleacCandidateAPI { (success, response, error, code) in
                        
             DispatchQueue.main.async {
                MIActivityLoader.hideLoader()
                
                if let responseData = response as? JSONDICT {
                    if let result = responseData["result"] as? JSONDICT {
                        
                        if let candID = result["candidateId"] as? String {
                            self.hitGleacInstruction(candID)
                        }
                       
                         //self.candidateID = candID ?? ""
                    }
                } else {
                    if (!MIReachability.isConnectedToNetwork()){
                        self.toastView(messsage: ExtraResponse.noInternet)
                    }
                }
             }
            
        }
          
    }
    
    func hitGleacInstruction(_ id: String) {
        
        MIActivityLoader.showLoader()
        MIApiManager.hitGleacInstructionAPI(id) { (success, response, error, code) in
                
            DispatchQueue.main.async {
                MIActivityLoader.hideLoader()
                
                    if let responseData = response as? JSONDICT {
                        if let result = responseData["result"] as? JSONDICT {
                          
                            if let url = result["url"] as? String {
                                let vc=Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
                                 vc.url = url
                                 vc.ttl = "Benchmark Yourself"
                                 vc.openWebVC = .fromGleac
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    } else {
                        if (!MIReachability.isConnectedToNetwork()){
                            self.toastView(messsage: ExtraResponse.noInternet)
                        }
                    }
             }
         }
        
     }
    
    func gleacReportMapEvents(_ dic: [String: Any], pagetype: String, destination: String) {
        
        MIApiManager.hitGleacSkillMapEventsAPI(pagetype, accessedUrl: destination, data: dic) { (success, response, error, code) in
        }
        
    }
    
    
}





