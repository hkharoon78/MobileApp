//
//  MIUpSkillArticleCell.swift
//  MonsteriOS
//
//  Created by Piyush on 08/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

protocol MIUpSkillArticleCellDelgate:class {
    func showArticleFromSummary(summary:String,url:String)
}

class MIUpSkillArticleCell: UITableViewCell {
    @IBOutlet weak var btnItem: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bulletView: UIView!
    private var url = ""
    private var summary = ""
    weak var delegate:MIUpSkillArticleCellDelgate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.bulletView.circular(0, borderColor: nil)
    }
    
    func show(info:MIHomeArticle,indexId:Int) {
        self.titleLbl.text = info.title
        self.summary       = info.summary
        self.url           = info.href
        self.btnItem.tag =  indexId
    }
    
    @IBAction func articleClicked(_ sender: UIButton) {
        CommonClass.googleEventTrcking("upskill_screen", action: "career_advice_articles", label: "\(sender.tag + 1)")
        self.delegate?.showArticleFromSummary(summary: self.summary, url: self.url)
    }
    
}
