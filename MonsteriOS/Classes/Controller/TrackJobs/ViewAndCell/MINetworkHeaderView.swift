//
//  MINetworkHeaderView.swift
//  MonsteriOS
//
//  Created by ishteyaque on 09/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MINetworkHeaderView: UIView {
    @IBOutlet weak var companyCountLabel: UILabel!{
        didSet{
            companyCountLabel.textColor=AppTheme.defaltTheme
            companyCountLabel.font=UIFont.customFont(type: .light, size: 34)
        }
    }
    @IBOutlet weak var companySubtitle: UILabel!{
        didSet{
            companySubtitle.textColor=UIColor.init(hex: "54698d")
            companySubtitle.font=UIFont.customFont(type: .Regular, size: 12)
        }
    }
    @IBOutlet weak var recuiterSubtitleLabel: UILabel!{
        didSet{
            recuiterSubtitleLabel.textColor=UIColor.init(hex: "54698d")
            recuiterSubtitleLabel.font=UIFont.customFont(type: .Regular, size: 12)
        }
    }
    @IBOutlet weak var recuiterCountLabel: UILabel!{
        didSet{
            recuiterCountLabel.textColor=AppTheme.defaltTheme
            recuiterCountLabel.font=UIFont.customFont(type: .light, size: 34)
        }
    }
    @IBOutlet weak var companyView: UIView!
    @IBOutlet weak var recuiterView: UIView!
    var companyTapAction:(()->Void)?
    var recuiterTapAction:(()->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        configure()
    }
    
    
    func configure(){
        //self.backgroundColor = AppTheme.viewBackgroundColor
        self.companyCountLabel.text="0"
        self.companySubtitle.text = "COMPANIES"
        self.recuiterCountLabel.text="0"
        self.recuiterSubtitleLabel.text="RECRUITERS"
        self.companyCountLabel.textColor = AppTheme.defaltBlueColor
        self.recuiterCountLabel.textColor = AppTheme.defaltBlueColor

        let compaTap=UITapGestureRecognizer(target: self, action: #selector(MINetworkHeaderView.companyViewTap(_:)))
        compaTap.numberOfTapsRequired=1
        self.companyView.addGestureRecognizer(compaTap)
        let recuiTap=UITapGestureRecognizer(target: self, action: #selector(MINetworkHeaderView.recuiterViewTap(_:)))
        recuiTap.numberOfTapsRequired=1
        self.recuiterView.addGestureRecognizer(recuiTap)
    }
    @objc func companyViewTap(_ sender:UITapGestureRecognizer){
        if let action=companyTapAction{
            action()
        }
    }
    @objc func recuiterViewTap(_ sender:UITapGestureRecognizer){
        if let action=recuiterTapAction{
            action()
        }
    }
}
