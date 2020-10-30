//
//  NoMoreJobsSwiperView.swift
//  MonsteriOS
//
//  Created by ishteyaque on 30/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class NoMoreJobsSwiperView: UIView {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var noMoreTitle: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var setPrefButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var editPrefAction:(()->Void)?
    var reloadViewFlag=false{
        didSet{
            self.noMoreTitle.textColor = AppTheme.defaltBlueColor
            if reloadViewFlag{
                activityIndicator.startAnimating()
                miActivityIndicator.startAnimating()
                noMoreTitle.text="Please Wait...."
                subTitleLabel.text="Getting New Jobs....."
                setPrefButton.isHidden=true
                iconView.isHidden=true
            }else{
                miActivityIndicator.stopAnimating()
                activityIndicator.stopAnimating()
                self.subTitleLabel.text=noMoreSubTitle
                self.noMoreTitle.text=noMoreData
                
                setPrefButton.isHidden=false
                iconView.isHidden=false
            }
        }
    }
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
        self.noMoreTitle.font=UIFont.customFont(type: .Regular, size: 14)
        self.noMoreTitle.textColor = AppTheme.defaltTheme
        self.subTitleLabel.font=UIFont.customFont(type: .Regular, size: 13)
        self.subTitleLabel.textColor=AppTheme.textColor
        self.subTitleLabel.text=noMoreSubTitle
        self.noMoreTitle.text=noMoreData
        //self.setPrefButton.showAsFollow()
        setPrefButton.showPrimaryBtn()
        self.setPrefButton.setTitle(noMorebuttonTitle, for: .normal)
        self.roundCorner(1, borderColor: UIColor(hex: "dddddd"), rad: 5)
        self.iconView.image = #imageLiteral(resourceName: "nojobfound")
    }
    
    lazy var miActivityIndicator: MIActivityIndicator = {
        let activity = MIActivityIndicator(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        activity.center = self.iconView.center
        self.addSubview(activity)
//        activity.layer.zPosition
        return activity
    }()
    
    @IBAction func editButtonAction(_ sender: UIButton) {
        if let action=self.editPrefAction{
            action()
        }
    }
    
}
