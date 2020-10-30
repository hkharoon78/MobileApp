//
//  MIHomeJobCell.swift
//  MonsteriOS
//
//  Created by Piyush on 29/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIJobStatusInfo:NSObject {
    var savedJobCount    = ""
    var appliedJobCount = ""
    var jobAlertCount   = ""
    var titleSaveJob    = "SAVED JOBS"
    var titleAppliedJob = "APPLIED JOBS"
    var titleJobAlert   = "JOBS ALERT"
    
    init(with ttlSavedJobCount:String,ttlAppliedJobCount:String,ttlJobAlertCont:String,ttlSavedJob:String = "SAVED JOBS",ttlAppliedJob:String = "APPLIED JOBS",ttlJobAlert:String = "JOBS ALERT") {
        savedJobCount = ttlSavedJobCount
        appliedJobCount = ttlAppliedJobCount
        jobAlertCount   = ttlJobAlertCont
        titleSaveJob    = ttlSavedJob
        titleAppliedJob = ttlAppliedJob
        titleJobAlert   = ttlJobAlert
    }
}

protocol MIHomeJobCellDelegate:class {
    func savedJobClicked()
    func appliedJobClicked()
    func jobAlertClicked()
}

class MIHomeJobCell: UITableViewCell {

    @IBOutlet weak var lblSavedJobCount: UILabel!
    @IBOutlet weak var lblSavedJobTitle: UILabel!
    @IBOutlet weak var lblAppliedJobCount: UILabel!
    @IBOutlet weak var lblAppliedJobTitle: UILabel!
    @IBOutlet weak var lblJobAlertCount: UILabel!
    @IBOutlet weak var lblJobAlertTitle: UILabel!
    weak var delegate:MIHomeJobCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func show(info:MIJobStatusInfo) {
        self.lblSavedJobCount.text   = info.savedJobCount
        self.lblAppliedJobCount.text = info.appliedJobCount
        self.lblJobAlertCount.text   = info.jobAlertCount
        self.lblSavedJobTitle.text   = info.titleSaveJob
        self.lblAppliedJobTitle.text = info.titleAppliedJob
        self.lblJobAlertTitle.text   = info.titleJobAlert
    }
    
    @IBAction func savedJobClicked(_ sender: UIButton) {
        self.delegate?.savedJobClicked()
    }
    
    @IBAction func appliedJobClicked(_ sender: UIButton) {
        self.delegate?.appliedJobClicked()
    }
    
    @IBAction func jobAlertClicked(_ sender: UIButton) {
        self.delegate?.jobAlertClicked()
    }
}
