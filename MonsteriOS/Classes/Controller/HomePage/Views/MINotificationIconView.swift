//
//  MINotificationIconView.swift
//  MonsteriOS
//
//  Created by ishteyaque on 31/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

protocol NotificationHomeIconDelegate{
    func notificationIconTapped()
}
extension NotificationHomeIconDelegate{
    func notificationIconTapped(){}
}
class MINotificationIconView: UIView {

    @IBOutlet weak var nitificationCountlabel: UILabel!
    @IBOutlet weak var notificationIcon: UIImageView!
    var delegate:NotificationHomeIconDelegate!
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.nitificationCountlabel.circular(0.0, borderColor: .clear)
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
        self.nitificationCountlabel.backgroundColor=UIColor.orange
        self.nitificationCountlabel.font=UIFont.customFont(type: .Regular, size: 12)
        self.nitificationCountlabel.textColor = .white
        
        let tapGesture=UITapGestureRecognizer(target: self, action: #selector(MINotificationIconView.nitificationIconTap(_:)))
        tapGesture.numberOfTapsRequired=1
        self.addGestureRecognizer(tapGesture)
    }
    @objc func nitificationIconTap(_ sender:UITapGestureRecognizer){
        if let _dele=self.delegate{
            _dele.notificationIconTapped()
        }
    }
}
