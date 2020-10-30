//
//  MIUploadResumeCell.swift
//  MonsteriOS
//
//  Created by Rakesh on 04/07/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import QuartzCore

class MIUploadResumeCell: UITableViewCell {

    @IBOutlet weak var view_Background:UIView!
    @IBOutlet weak var btn_Edit:UIButton!
    @IBOutlet weak var uploadResumeButton: UIButton!
    @IBOutlet weak var lbl_ResumeName:UILabel!

    var uploadEditCallBack : ((Bool) -> Void)?
    
    var userModel: MIUserModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setUpDotLayers()
    }
    
    func setUpDotLayers(){
        for layer in view_Background.layer.sublayers ?? [] {
            if layer is DotShapeLayer {
                layer.removeFromSuperlayer()
            }
        }
        
        let dotLayer = DotShapeLayer()
        if let resumePath = userModel?.userResume.resumePath, !resumePath.isEmpty { //Green
            dotLayer.strokeColor = UIColor.init(hex: "1b998b").cgColor
            view_Background.backgroundColor = UIColor(red: 204, green: 230, blue: 227, alpha: 0.57)
        } else { //Purple
            dotLayer.strokeColor = UIColor.init(hex: "7b65de").cgColor
            view_Background.backgroundColor = UIColor(red: 227, green: 230, blue: 255, alpha: 0.57)
        }
        dotLayer.lineDashPattern = [2, 2]
        dotLayer.frame = view_Background.bounds
        dotLayer.fillColor = nil
        dotLayer.path = UIBezierPath(roundedRect: view_Background.bounds, cornerRadius: 15).cgPath
        view_Background.layer.addSublayer(dotLayer)
        view_Background.layer.cornerRadius = 8
    }

    func showResumeName(modal:MIUserModel) {
        self.userModel = modal

        btn_Edit.isHidden = modal.userResume.resumePath.isEmpty
        if modal.userResume.resumePath.isEmpty {
            //lbl_ResumeName.text = "Upload Resume"
            self.uploadResumeButton.setTitle("Upload Resume", for: .normal)
            self.uploadResumeButton.contentHorizontalAlignment = .center
        }else{
            self.uploadResumeButton.contentHorizontalAlignment = .left
            if modal.userResume.resumeViaImages {
                modal.userResume.resumeName = (modal.userFullName.isEmpty ? "Resume.pdf" : "Resume_\(modal.userFullName).pdf")
                //lbl_ResumeName.text = modal.userResume.resumeName
                self.uploadResumeButton.setTitle(modal.userResume.resumeName, for: .normal)
            }else{
                self.uploadResumeButton.setTitle(modal.userResume.resumeName, for: .normal)
                //lbl_ResumeName.text = modal.userResume.resumeName

            }
        }
        
        self.setUpDotLayers()
    }
    @IBAction func uploadEditResumeClicked(_ sender : UIButton){
        if let callBack = self.uploadEditCallBack {
            callBack(true)
        }
    }
}


class DotShapeLayer: CAShapeLayer {
}
