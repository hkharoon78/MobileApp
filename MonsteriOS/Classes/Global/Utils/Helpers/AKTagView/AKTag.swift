//
//  AKTag.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 04/06/20202.
//  Copyright © 2020 Anupam Katiyar. All rights reserved.
//

import Foundation

let kXAxisPadding: CGFloat = 20

class AKTagCell: UICollectionViewCell {
    
    var titleLabel: UILabel!
    var typeView: UIButton!
    var closeButton: UIButton!
    
    var tagleftRightPadding: CGFloat = 40
    
     var showLeftView: Bool = true
     var showRightView: Bool = true

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1.0
        
        titleLabel = UILabel()
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        
        typeView = UIButton()
        closeButton = UIButton()
        
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.typeView)
        self.contentView.addSubview(self.closeButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
                
        var padding: CGFloat = 0
        if self.showLeftView {
            padding = padding + tagleftRightPadding
        } else {
            padding = padding + kXAxisPadding
        }
        if self.showRightView {
            padding += tagleftRightPadding
        } else {
            padding = padding + kXAxisPadding
        }
        
        var labelFrame = self.bounds
        labelFrame.origin.x = self.showLeftView ? self.tagleftRightPadding : kXAxisPadding
        labelFrame.size.width -= padding
        self.titleLabel.frame = labelFrame

        if self.showLeftView {
            let typeFrame = CGRect(x: 0, y: 0, width: tagleftRightPadding, height: self.bounds.size.height)
            self.typeView.frame = typeFrame
        } else {
            self.typeView.frame = .zero
        }

        if self.showRightView {
            let closeFrame = CGRect(x: self.bounds.size.width - tagleftRightPadding, y: 0, width: tagleftRightPadding, height: self.bounds.size.height)
            self.closeButton.frame = closeFrame
        } else {
            self.closeButton.frame = .zero
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.titleLabel.text = ""
    }
    
    func setupData(_ data: AKTag) {
        
        self.titleLabel.text = data.name
        self.typeView.setImage(data.tagTypeImage, for: .normal)
        self.closeButton.setImage(data.closeIcon, for: .normal)
        
        self.typeView.isUserInteractionEnabled = (data.tagTypeImage != nil)
        self.closeButton.isUserInteractionEnabled = (data.closeIcon != nil)
    }
}





class AKTag: Equatable {
    
    var id: String
    var name: String
    var closeIcon: UIImage?
    var tagTypeImage: UIImage?
    
    init(id: String, name: String, closeIcon: UIImage? = nil, typeImage: UIImage? = nil) {
        self.id = id
        self.name = name
        self.closeIcon = closeIcon
        self.tagTypeImage = typeImage
    }
    
    static func == (lhs: AKTag, rhs: AKTag) -> Bool {
        return lhs.name == rhs.name && lhs.id == rhs.id
    }

}
