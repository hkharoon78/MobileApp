//
//  MIRecentSearchCell.swift
//  MonsteriOS
//
//  Created by Piyush on 06/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MISearchInfo:NSObject {
    var title = ""
    var jobsCount = ""
    init(with ttl:String, jobCount:String) {
        title     = ttl
        jobsCount = jobCount
    }
    init(dict:[String:Any]) {
        title = dict.stringFor(key: "label")
       // title = dict.stringFor(key: "label")

    }
}

protocol MIRecentSearchCellDelegate:class {
    func recentSearchDelete(data:String,cellTag:Int)
}

class MIRecentSearchCell: UITableViewCell {

    @IBOutlet weak private var titleLbl:UILabel!
    @IBOutlet weak private var jobCountLbl: UILabel!
    @IBOutlet weak private var crossBtn: UIButton!
    weak var delegate:MIRecentSearchCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.titleLbl.text  = ""
    }
    
    @IBAction func deleteClicked(_ sender: UIButton) {
        self.delegate?.recentSearchDelete(data: self.titleLbl.text ?? "", cellTag: self.tag)
    }
    
    func show(info:MISearchInfo,cellTag:Int) {
        titleLbl.text    = info.title
        jobCountLbl.text = info.jobsCount
        self.crossBtn.isHidden = false
        self.tag = cellTag
    }
    
}
