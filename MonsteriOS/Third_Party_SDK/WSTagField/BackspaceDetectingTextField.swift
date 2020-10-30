//
//  BackspaceDetectingTextField.swift
//  WSTagsField
//
//  Created by Ilya Seliverstov on 11/07/2017.
//  Copyright © 2017 Whitesmith. All rights reserved.
//

import UIKit

protocol BackspaceDetectingTextFieldDelegate: UITextFieldDelegate {
    /// Notify whenever the backspace key is pressed
    func textFieldDidDeleteBackwards(_ textField: UITextField)
}

class BackspaceDetectingTextField: UITextField {

    var onDeleteBackwards: (() -> Void)?

    init() {
        super.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func deleteBackward() {
        onDeleteBackwards?()
        // Call super afterwards. The `text` property will return text prior to the delete.
        super.deleteBackward()
    }

}


internal struct Constants {
    internal static let TEXT_FIELD_HSPACE: CGFloat = 6.0
    internal static let MINIMUM_TEXTFIELD_WIDTH: CGFloat = 56.0
    internal static let STANDARD_ROW_HEIGHT: CGFloat = 25.0
}
