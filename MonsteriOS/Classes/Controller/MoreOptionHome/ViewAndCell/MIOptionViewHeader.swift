//
//  MIOptionViewHeader.swift
//  MonsteriOS
//
//  Created by ishteyaque on 26/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate: class {
    func toggleSection(header: MIOptionViewHeader, section: Int)
}


class MIOptionViewHeader: UITableViewHeaderFooterView {

    //MARK:Outlets and Life Cycle Method
    @IBOutlet weak var sectionTitle: UILabel!{
        didSet{
            self.sectionTitle.font=UIFont.customFont(type: .Regular, size: 16)
            self.sectionTitle.textColor=UIColor.init(hex: "060606")
        }
    }
    @IBOutlet weak var sectionIconView: UIImageView!
    var item: MoreOptionViewModelItem? {
        didSet {
            guard let item = item else {
                return
            }
            
            sectionTitle?.text = item.sectionTitle
            if !item.isCollapsible{
                self.sectionIconView.image=nil
            }else{
            setCollapsed(collapsed: item.isCollapsed)
            }
        }
    }
   
    
    var section: Int = 0
    
    weak var delegate: HeaderViewDelegate?
    
    //MARK:Life Cycle Method
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
    }
    //MARK:Tap Gesture Recogniser Method and delegate implementation
    @objc private func didTapHeader() {
        delegate?.toggleSection(header: self, section: section)
    }
    
    func setCollapsed(collapsed: Bool) {
        sectionIconView.image=collapsed ? #imageLiteral(resourceName: "plus") : #imageLiteral(resourceName: "minus-ico")
        
    }

}
