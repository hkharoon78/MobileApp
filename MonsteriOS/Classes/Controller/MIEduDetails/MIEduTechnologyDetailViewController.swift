//
//  MIEduTechnologyDetailViewController.swift
//  MonsteriOS
//
//  Created by Rakesh on 21/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

struct MIEduTechnologyInfo {
    var certificationName :String?
    var courseType :String?
    var courseKeywords :String?
    var courseProvidedBy :String?
    var courseFee :String?
    var courseTaxDescription :String?
    var courseIntro :String?

}

class MIEduTechnologyDetailViewController: UIViewController {

    @IBOutlet weak var tblView:UITableView!
    var courseData : MIEduTechnologyInfo!
    
    var readMoreSelected = false {
        didSet {
            self.tblView.reloadData()
        }
    }
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title = ControllerTitleConstant.technology
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.title = ""
    }
    //MARK: - Helper Methods
    func setUpView() {

        let rightBarItem = UIBarButtonItem(image: UIImage(named: "search_grey"), style: .done, target: self, action:#selector(MIEduTechnologyDetailViewController.searchBtnClicked(_:)))
        self.navigationItem.rightBarButtonItem = rightBarItem

        self.tblView.register(UINib.init(nibName: "MIEduCertifiedCell", bundle: nil), forCellReuseIdentifier: String(describing:MIEduCertifiedCell.self))
        self.tblView.register(UINib.init(nibName: "MICourseDetailCell", bundle: nil), forCellReuseIdentifier: String(describing:MICourseDetailCell.self))
        
        self.tblView.rowHeight = UITableView.automaticDimension
        self.tblView.estimatedRowHeight = 176
        
        //Dummuy Data
        courseData = MIEduTechnologyInfo(certificationName: "Certified SEO Professional VS-1084", courseType: "Certification", courseKeywords: "Certificate in SEO | SEO Professional | SEO Courses", courseProvidedBy: "VSkills - Govt. Certification", courseFee: "INR 4999.00", courseTaxDescription: "(Excluding taxes)", courseIntro: "Vskills certification for SEO Professional assesses the candidate as per the company's need for web site promotion and optimization on search engine. The certification tests the candidates on various areas in search engine optimization which includes the knowledge of SEO and SEM concepts, on-page and off-page optimization, analytics and social media marketing.\n\nVskills certification for SEO Professional assesses the candidate as per the company's need for web site promotion and optimization on search engine. The certification tests the candidates on various areas in search engine optimization which includes the knowledge of SEO and SEM concepts, on-page and off-page optimization, analytics and social media marketing.")
    }
    func pushToNextVC(vc:UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - IBAction Methods
    @objc func searchBtnClicked(_ sender:UIBarButtonItem) {

    }
    // Mark: - ReadOptionSelectedDelegate Methods
    func readMore() {
        self.readMoreSelected = !self.readMoreSelected
    }
}

extension MIEduTechnologyDetailViewController : UITableViewDelegate,UITableViewDataSource,ReadOptionSelectedDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0  {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MIEduCertifiedCell", for: indexPath) as? MIEduCertifiedCell {
                cell.eduTechnologyCourseData = courseData
                return cell
            }
            
        }else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MICourseDetailCell", for: indexPath) as? MICourseDetailCell {
                cell.introductionContent_lbl.text = courseData.courseIntro
                cell.delegate = self
                return cell
            }
        }
       
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let sectionFooter = MIEduFooterView.footerView
        sectionFooter.delegate  = self
        return sectionFooter
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return UITableView.automaticDimension
        }else {
            return self.readMoreSelected ? UITableView.automaticDimension : 406
        }
    }
}

extension MIEduTechnologyDetailViewController : CertifiedCourseTechnologyDelegate {
    func requestInfoOnCourse() {
        
    }
    
    func buyNowCourse() {
        self.pushToNextVC(vc: MIIAmInterestedViewController())
    }
    
    
    
}
