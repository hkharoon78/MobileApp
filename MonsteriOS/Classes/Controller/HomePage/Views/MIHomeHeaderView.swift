//
//  MIHomeHeaderView.swift
//  MonsteriOS
//
//  Created by Piyush on 28/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIHomeHeaderView: UIView {
    @IBOutlet weak var btnHeaderNumber: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnViewAll: UIButton!
    var viewAll: ((Bool)->Void)?

    @IBOutlet weak var lblTitleLeadingConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        self.btnHeaderNumber.roundCorner(0, borderColor: nil, rad: 10)
    }
    
    class var header:MIHomeHeaderView {
        get {
            let header = UINib(nibName: "MIHomeHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MIHomeHeaderView
            return header
        }
    }
    
    func show(ttlNo:String, ttl:String,shouldShowViewAll:Bool = false) {
        btnHeaderNumber.setTitle(ttlNo, for: .normal)
        lblTitle.text = ttl
        btnViewAll.isHidden = !shouldShowViewAll
        if ttlNo.isEmpty {
            self.hideTitleNO()
        } else {
            self.showTitleNo()
        }
    }

    func hideTitleNO() {
        btnHeaderNumber.isHidden = true
        lblTitleLeadingConstraint.constant = 12
    }
    
    func showTitleNo() {
        btnHeaderNumber.isHidden = true
        lblTitleLeadingConstraint.constant = 12
    }
    
    @IBAction func viewAllClicked(_ sender: UIButton) {
        viewAll?(true)
    }
    
}

protocol MIHomeBeSafeHeaderViewDelegate:class {
    func reportAnAbuseClicked()
    func mailIDClicked()
}

class MIHomeBeSafeHeaderView: UIView {
    @IBOutlet weak var lblDesc: ActiveLabel!
    var mailID = "spam@monsterindia.com"
    private let report = "Report an Abuse"
    
    weak var delegate:MIHomeBeSafeHeaderViewDelegate?
//    @IBOutlet weak var lblHomeDesc: ActiveLabel!
    class var header:MIHomeBeSafeHeaderView {
        get {
            let header = UINib(nibName: "MIHomeHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[1] as! MIHomeBeSafeHeaderView
            header.setUI()
            return header
        }
    }
    
    func setUI() {
//        self.lblDesc.showMultiAttributedTxtColor(multiStr: [mailID,"Report an Abuse."], with: UIColor(hex: "ea1313"))
        
        self.lblDesc.addLink(linkColor: UIColor(hex: "ea1313"), linkTxt:[report,mailID],completion:{ (subS) -> Void in
            if subS == self.mailID {
                CommonClass.googleEventTrcking("dashboard_screen", action: "be_safe", label: "email")
                self.delegate?.mailIDClicked()
            }
            if subS == self.report {
                CommonClass.googleEventTrcking("dashboard_screen", action: "be_safe", label: "report_abuse")
                self.delegate?.reportAnAbuseClicked()
            }
        })
    }
    
    func updateUI(_ mailId:String = "spam@monsterindia.com") {
        let site = AppDelegate.instance.site
        let SpamEnum = MISpamMail(rawValue: site?.defaultCountryDetails.isoCode.uppercased() ?? "IN")
        let spamMail = SpamEnum?.spamMail
        self.mailID = spamMail ?? mailID
        
        self.lblDesc.text = "Dear User,  Monster DOES NOT seek fees/Cash deposit towards any JOB OFFER/ INTERVIEW, please report such call/email to \(self.mailID) or Report an Abuse.  "
        self.setUI()
    }
}
