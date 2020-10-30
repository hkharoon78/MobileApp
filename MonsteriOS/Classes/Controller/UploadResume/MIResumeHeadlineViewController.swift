//
//  MIResumeHeadlineViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 14/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIResumeHeadlineViewController: MIBaseViewController {

    enum ResumeSelection{
        case fromDocument
        case fromGallery
    }
    @IBOutlet weak var resumeView: UIView!
    @IBOutlet weak var resumeViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var resumeImage: UIImageView!
    @IBOutlet weak var resumeTitle: UILabel!
    @IBOutlet weak var resumeNameEditView: UIView!
    @IBOutlet weak var resumeNameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    var resumeSelection:ResumeSelection! = .fromDocument
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title=ControllerTitleConstant.resumeHeadLine
    }

    func setUpUI(){
        self.nextButton.showPrimaryBtn()
        resumeView.addShadow(opacity: 0.5)
        resumeNameEditView.addShadow(opacity: 0.5)
        resumeNameTextField.delegate=self
        if resumeSelection == .fromGallery{
            resumeView.isHidden=true
            resumeViewHeightConstraint.constant=0
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.init(hex: "dfe3e8").cgColor
        border.frame = CGRect(x: 0, y: resumeNameTextField.frame.size.height - width, width: resumeNameTextField.frame.size.width, height: resumeNameTextField.frame.size.height)
        
        border.borderWidth = width
        resumeNameTextField.layer.addSublayer(border)
        resumeNameTextField.layer.masksToBounds = true
    }

    @IBAction func nextButtonAction(_ sender: UIButton) {
        let vc=MIProfessionalDetailViewController.newInstance
        self.navigationController?.pushViewController(vc, animated: true)
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
extension MIResumeHeadlineViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
