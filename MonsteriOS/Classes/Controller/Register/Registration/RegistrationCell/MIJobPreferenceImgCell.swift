//
//  MIJobPreferenceImgCell.swift
//  MonsteriOS
//
//  Created by Anushka on 04/07/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIJobPreferenceImgCell: UITableViewCell,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var imgJobPreference: UIImageView!
    @IBOutlet weak var btnUploadImg: UIButton!
    @IBOutlet weak var lblImgSize: UILabel!
    @IBOutlet weak var profileImgActivityIndicator: UIActivityIndicatorView!

    var imageUploadCallBack : (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.imgJobPreference.applyCircular()
        self.imgJobPreference.circular(4, borderColor: UIColor(hex: "ffffff"))

       // self.btnUploadImg.showPrimaryBtn()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func uploadImageAction(_ sender:UIButton) {
       // self.showActionSheetForUserSelection()
        self.imageUploadCallBack?()

    }
   
}
