//
//  MIFromTillDateCell.swift
//  MonsteriOS
//
//  Created by Rakesh on 31/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit



class MIFromTillDateCell: UITableViewCell {
    @IBOutlet weak var fromDateBg_View : UIView!
    @IBOutlet weak var tillDateBg_View : UIView!
    @IBOutlet weak var primaryOptionArrow_ImgView : UIImageView!
    @IBOutlet weak var secondaryOptionArrow_ImgView : UIImageView!

    var pickDateCallBack : ((MIFromTillDateCell,Date,String) -> Void)?
    
    @IBOutlet weak var primaryOptionTitle_Lbl : UILabel! {
        didSet {
            self.primaryOptionTitle_Lbl.font = UIFont.customFont(type: .Regular, size: 12)
        }
    }
   
    @IBOutlet weak var secondaryOptionTitle_Lbl : UILabel! {
        didSet {
            self.secondaryOptionTitle_Lbl.font = UIFont.customFont(type: .Regular, size: 12)

        }
    }
    
    @IBOutlet weak var primaryOptionValue_Btn : UIButton! {
        didSet {
            self.primaryOptionValue_Btn.setTitle("Select Date", for: .normal)
            self.primaryOptionValue_Btn.titleLabel?.font = UIFont.customFont(type: .Regular, size: 14)
            self.primaryOptionValue_Btn.setTitleColor(AppTheme.textColor, for: .normal)
        }
    }
    @IBOutlet weak var secondaryOptionValue_Btn : UIButton! {
        didSet {
            self.secondaryOptionValue_Btn.setTitle("Select Date", for: .normal)
            self.secondaryOptionValue_Btn.titleLabel?.font = UIFont.customFont(type: .Regular, size: 14)
            self.secondaryOptionValue_Btn.setTitleColor(AppTheme.textColor, for: .normal)


        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.primaryOptionArrow_ImgView.image = UIImage(named: "calendarBlue")
        self.secondaryOptionArrow_ImgView.image = UIImage(named: "calendarBlue")

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func resetDataForOtherEmployment() {
        self.secondaryOptionValue_Btn.isUserInteractionEnabled = true
        self.secondaryOptionArrow_ImgView.isHidden = false

    }
    func setDataForCurrentEmployment() {
        self.secondaryOptionValue_Btn.isUserInteractionEnabled = false
        self.secondaryOptionValue_Btn.setTitle("Present", for: .normal)
        self.secondaryOptionArrow_ImgView.isHidden = true
    }
    
    func showEmploymentWorkDuration(obj:MIEmploymentDetailInfo) {
       
        self.primaryOptionValue_Btn.setTitle((obj.experinceFrom == nil) ? "Select Date" : obj.experinceFrom?.getStringWithFormat(format: "MMM, yyyy"), for: .normal)
        self.secondaryOptionValue_Btn.setTitle((obj.experinceTill == nil) ? "Select Date" : obj.experinceTill?.getStringWithFormat(format: "MMM, yyyy"), for: .normal)
    }
    @IBAction func fromDateClicked(_ sender : UIButton) {
        
        MIDatePicker.selectDate(title: "", hideCancel: false, datePickerMode: .date, selectedDate: nil, minDate:nil, maxDate: Date()) { (date) in
            if let callBack = self.pickDateCallBack {
                self.primaryOptionValue_Btn.setTitle(date.getStringWithFormat(format: "MMM, yyyy"), for: .normal)
                callBack(self,date, "FROM_DATE")
            }
        }
    }
    @IBAction func tillDateClicked(_ sender : UIButton) {
        MIDatePicker.selectDate(title: "", hideCancel: false, datePickerMode: .date, selectedDate: nil, minDate:nil, maxDate: Date()) { (date) in
            self.secondaryOptionValue_Btn.setTitle(date.getStringWithFormat(format: "MMM, yyyy"), for: .normal)
            if let callBack = self.pickDateCallBack {
                callBack(self,date, "TILL_DATE")
            }
        }
    }
}
