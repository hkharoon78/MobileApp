//
//  MIProfileResumeDetailCell.swift
//  MonsteriOS
//
//  Created by Piyush on 21/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIProfileResumeDetailCell: MIProfileTableCell {
    
    @IBOutlet weak var resumeTitleLabel: UILabel!
    @IBOutlet weak var uploadView: UIView!
    @IBOutlet weak private var updateBtn: UIButton!
    @IBOutlet weak var uploadViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var uploadLbl: UILabel!
    @IBOutlet weak var btnManageProfile: UIButton!
    @IBOutlet weak private var downloadBtn: UIButton!

    var delegate: UIViewController?
    var uploadResumeAction : ((Bool)-> Void)?
    var resumeinfo:MIProfileResumeInfo?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.updateBtn.roundCorner(0, borderColor: nil, rad: CornerRadius.btnCornerRadius)
        self.downloadBtn.roundCorner(0, borderColor: nil, rad: CornerRadius.btnCornerRadius)

    }
    
    @IBAction func manageProfileClicked(_ sender: UIButton) {
    }
    
    @IBAction func updateClicked(_ sender: UIButton) {
        uploadResumeAction?(true)
    }
    
    @IBAction func downloadClicked(_ sender: UIButton) {
        let name = AppDelegate.instance.userInfo.fullName
        let timestmp = "\(Int(Date().timeIntervalSince1970))"
        let fileName = name + "_" + timestmp

        MIActivityLoader.showLoader()
        MIApiManager.downloadResume{ [weak self] (isSuccess, file, error, code) in
            DispatchQueue.main.async {
                
            MIActivityLoader.hideLoader()
                if !(code >= 200) && (code <= 299) {
                    self?.delegate?.showAlert(title: "", message: "An error occurred while downloading file.",isErrorOccured:true)

                   // AKAlertController.alert("Error", message: "An error occurred while downloading file.")
                }else{
                    if let data = file, data.count > 0 {
                        
                        do {
                            let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
                            let documentDirectoryPath:String = path[0]
                            
                            let destinationURLForFile = URL(fileURLWithPath: documentDirectoryPath
                                .appendingFormat("/\(fileName).\(data.mimeType())")
                            )
                            
                            
                            try data.write(to: destinationURLForFile)
                            DispatchQueue.main.async {
                               
                                                      
                                let activityViewController = UIActivityViewController(activityItems: [destinationURLForFile], applicationActivities: nil)
                                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ) {
                                    if let popOver = activityViewController.popoverPresentationController {
                                        popOver.sourceView =  self?.contentView
                                        popOver.sourceRect =  sender.frame

                                    }
                                }
                                self?.delegate?.present(activityViewController, animated: true, completion: nil)
                            }
                            
                        } catch let error {
                                print(error.localizedDescription)
                                self?.delegate?.showAlert(title: "", message: "An error occurred while downloading file.",isErrorOccured:true)

                               // AKAlertController.alert("Error", message: "An error occurred while downloading file.")
                          //  }
                        }
                        
                    }else{
                       // DispatchQueue.main.async {
                        self?.delegate?.showAlert(title: "", message: "An error occurred while downloading file.",isErrorOccured:true)

                          //  AKAlertController.alert("Error", message: "An error occurred while downloading file.")
                      //  }
                    }

                }

            }
        }

    }
    
    func show(info:MIProfileResumeInfo) {
        
//        var fileExt = info.fileName.components(separatedBy: ".")
//        fileExt = fileExt.filter({$0 != ""})
        resumeinfo = info
        if info.fileName.count > 0 && !info.filePath.isEmpty {
            self.uploadLbl.text = info.fileName
            self.uploadView.isHidden = false
            self.uploadViewHeightConstraint.constant = 60
            self.resumeTitleLabel.text = "Resume"

        } else {
           self.showWhenResumeNotAvailabel()
        }
    }
    
    func showWhenResumeNotAvailabel() {
        self.uploadLbl.text = ""
        self.uploadView.isHidden = true
        self.uploadViewHeightConstraint.constant = 15
        self.resumeTitleLabel.text = "Please upload your resume"
    }
}
