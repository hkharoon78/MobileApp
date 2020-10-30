//
//  MIBaseCell.swift
//  MonsteriOS
//
//  Created by Monster on 30/10/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

enum shape
{
    case topLayerShape,bottomLayerShape,All,none
}

class MIBaseCell: UITableViewCell {

    var shapeType = shape.none
    @IBOutlet weak private var topView: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            switch self.shapeType {
            case .topLayerShape :
                self.topView?.roundCorners([.topLeft,.topRight], radius: 4)

                break
            case .bottomLayerShape:
                self.topView?.roundCorners([.bottomLeft,.bottomRight], radius: 4)

                break
            case .All:
                self.topView?.roundCorners([.topLeft,.topRight,.bottomLeft,.bottomRight], radius: 4)

                break
            case .none:
                self.topView?.roundCorners([], radius: 0)


                break
            }
        }
        self.topView?.layoutIfNeeded()
    }
}
