//
//  WSTagsField.swift
//  Whitesmith
//
//  Created by Ricardo Pereira on 12/05/16.
//  Copyright © 2016 Whitesmith. All rights reserved.
//

import UIKit

public enum WSTagAcceptOption {
    case `return`
    case comma
    case space
}

open class WSTagsField: UIScrollView {
    let textField = BackspaceDetectingTextField()
    
    /// Dedicated text field delegate.
    open weak var textDelegate: UITextFieldDelegate?
    
    /// Background color for tag view in normal (non-selected) state.
    open override var tintColor: UIColor! {
        didSet {
            tagViews.forEach { $0.tintColor = self.tintColor }
        }
    }
    
    /// Text color for tag view in normal (non-selected) state.
    open var textColor: UIColor? {
        didSet {
            tagViews.forEach { $0.textColor = self.textColor }
        }
    }
    
    /// Background color for tag view in normal (selected) state.
    open var selectedColor: UIColor? {
        didSet {
            tagViews.forEach { $0.selectedColor = self.selectedColor }
        }
    }
    
    /// Text color for tag view in normal (selected) state.
    open var selectedTextColor: UIColor? {
        didSet {
            tagViews.forEach { $0.selectedTextColor = self.selectedTextColor }
        }
    }
    
    open var delimiter: String = "" {
        didSet {
            tagViews.forEach { $0.displayDelimiter = self.isDelimiterVisible ? self.delimiter : "" }
        }
    }
    
    @available(*, unavailable, message: "Use 'isDelimiterVisible' instead.")
    open var displayDelimiter: Bool = false
    
    open var isDelimiterVisible: Bool = false {
        didSet {
            tagViews.forEach { $0.displayDelimiter = self.isDelimiterVisible ? self.delimiter : "" }
        }
    }
    
    open var maxHeight: CGFloat = CGFloat.infinity {
        didSet {
            tagViews.forEach { $0.displayDelimiter = self.isDelimiterVisible ? self.delimiter : "" }
        }
    }
    
    /// Max number of lines of tags can display in WSTagsField before its contents become scrollable. Default value is 0, which means WSTagsField always resize to fit all tags.
    open var numberOfLines: Int = 0 {
        didSet {
            repositionViews()
        }
    }
    
    /// Whether or not the WSTagsField should become scrollable
    open var enableScrolling: Bool = false
    
    @available(*, unavailable, message: "Use 'cornerRadius' instead.")
    open var tagCornerRadius: CGFloat = 3.0
    
    open var cornerRadius: CGFloat = 15.25 {
        didSet {
            tagViews.forEach { $0.cornerRadius = self.cornerRadius }
        }
    }
    
    open var borderWidth: CGFloat = 0.0 {
        didSet {
            tagViews.forEach { $0.borderWidth = self.borderWidth }
        }
    }
    
    open var borderColor: UIColor? {
        didSet {
            if let borderColor = borderColor { tagViews.forEach { $0.borderColor = borderColor } }
        }
    }
    
    open override var layoutMargins: UIEdgeInsets {
        didSet {
            tagViews.forEach { $0.layoutMargins = self.layoutMargins }
        }
    }
    
    open var fieldTextColor: UIColor? {
        didSet {
            textField.textColor = fieldTextColor
        }
    }
    
    open var placeholder: String = "Tags" {
        didSet {
            updatePlaceholderTextVisibility()
        }
    }
    
    open var placeholderColor: UIColor? {
        didSet {
            updatePlaceholderTextVisibility()
        }
    }
    
    @available(*, unavailable, message: "Use 'placeholderAlwaysVisible' instead.")
    open var placeholderAlwayVisible: Bool = false
    
    open var placeholderAlwaysVisible: Bool = false {
        didSet {
            updatePlaceholderTextVisibility()
        }
    }
    
    open var font: UIFont? {
        didSet {
            textField.font = font
            tagViews.forEach { $0.font = self.font }
        }
    }
    
    open var keyboardAppearance: UIKeyboardAppearance = .default {
        didSet {
            textField.keyboardAppearance = self.keyboardAppearance
            tagViews.forEach { $0.keyboardAppearanceType = self.keyboardAppearance }
        }
    }
    
    open var readOnly: Bool = false {
        didSet {
            unselectAllTagViewsAnimated()
            textField.isEnabled = !readOnly
            repositionViews()
        }
    }
    
    /// By default, the return key is used to create a tag in the field. You can change it, i.e., to use comma or space key instead.
    open var acceptTagOption: WSTagAcceptOption = .return
    
    @available(*, unavailable, message: "Use 'contentInset' instead.")
    open var padding: UIEdgeInsets = UIEdgeInsets.zero
    
    open override var contentInset: UIEdgeInsets  {
        didSet {
            repositionViews()
        }
    }
    
    open var spaceBetweenTags: CGFloat = 8.0 {
        didSet {
            repositionViews()
        }
    }
    
    open var spaceBetweenLines: CGFloat = 20.0 {
        didSet {
            repositionViews()
        }
    }
    
    open override var isFirstResponder: Bool {
        guard super.isFirstResponder == false, textField.isFirstResponder == false else {
            return true
        }
        
        for i in 0..<tagViews.count where tagViews[i].isFirstResponder {
            return true
        }
        
        return false
    }
    
    open fileprivate(set) var tags = [WSTag]()
    internal var tagViews = [WSTagView]()
    
    // MARK: - Events
    
    /// Called when the text field should return.
    open var onShouldAcceptTag: ((WSTagsField) -> Bool)?
    
    /// Called when the text field text has changed. You should update your autocompleting UI based on the text supplied.
    open var onDidChangeText: ((WSTagsField, _ text: String?) -> Void)?
    
    /// Called when a tag has been added. You should use this opportunity to update your local list of selected items.
    open var onDidAddTag: ((WSTagsField, _ tag: WSTag) -> Void)?
    
    /// Called when a tag has been removed. You should use this opportunity to update your local list of selected items.
    open var onDidRemoveTag: ((WSTagsField, _ tag: WSTag) -> Void)?
    
    /// Called when a tag has been selected.
    open var onDidSelectTagView: ((WSTagsField, _ tag: WSTagView) -> Void)?
    
    /// Called when a tag has been unselected.
    open var onDidUnselectTagView: ((WSTagsField, _ tag: WSTagView) -> Void)?
    
    /// Called before a tag is added to the tag list. Here you return false to discard tags you do not want to allow.
    open var onValidateTag: ((WSTag, [WSTag]) -> Bool)?
    
    /**
     * Called when the user attempts to press the Return key with text partially typed.
     * @return A Tag for a match (typically the first item in the matching results),
     * or nil if the text shouldn't be accepted.
     */
    open var onVerifyTag: ((WSTagsField, _ text: String) -> Bool)?
    
    /**
     * Called when the view has updated its own height. If you are
     * not using Autolayout, you should use this method to update the
     * frames to make sure the tag view still fits.
     */
    open var onDidChangeHeightTo: ((WSTagsField, _ height: CGFloat) -> Void)?
    
    // MARK: - Properties
    
    fileprivate var oldIntrinsicContentHeight: CGFloat = 0
    
    fileprivate var estimatedInitialMaxLayoutWidth: CGFloat {
        // Workaround: https://stackoverflow.com/questions/42342402/how-can-i-create-a-view-has-intrinsiccontentsize-just-like-uilabel
        // "So how the system knows the label's width so that it can calculate the height before layoutSubviews"
        // Re: "It calculates it. It asks “around” first by checking the last constraint (if there is one) for width. It asks it subviews (your custom class) for its constrains and then makes the calculations."
        // This is necessary because, while using the WSTagsField in a `UITableViewCell` with a dynamic height, the `intrinsicContentSize` is called first than the `layoutSubviews`, which leads to an unknown view width when AutoLayout is being used.
        if let superview = superview {
            var layoutWidth = superview.frame.width
            for constraint in superview.constraints where constraint.firstItem === self && constraint.secondItem === superview {
                if constraint.firstAttribute == .leading && constraint.secondAttribute == .leading {
                    layoutWidth -= constraint.constant
                }
                if constraint.firstAttribute == .trailing && constraint.secondAttribute == .trailing {
                    layoutWidth += constraint.constant
                }
            }
            return layoutWidth
        }
        else {
            for constraint in constraints where constraint.firstAttribute == .width {
                return constraint.constant
            }
        }
        
        return 200 //default estimation
    }
    
    open var preferredMaxLayoutWidth: CGFloat {
        return bounds.width == 0 ? estimatedInitialMaxLayoutWidth : bounds.width
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: self.frame.size.width,
                      height: min(maxHeight, maxHeightBasedOnNumberOfLines, calculateContentHeight(layoutWidth: preferredMaxLayoutWidth) + contentInset.top + contentInset.bottom))
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return .init(width: size.width, height: calculateContentHeight(layoutWidth: size.width) + contentInset.top + contentInset.bottom)
    }
    
    // MARK: -
    public override init(frame: CGRect) {
        super.init(frame: frame)
        internalInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        internalInit()
    }
    
//    deinit {
//        if let observer = layerBoundsObserver {
//            switch observer.observationInfo{
//            case .some:
//                removeObserver(observer, forKeyPath: "layer.bounds")
//
//            default : break
//            }
//            observer.invalidate()
//        }
//    }
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        tagViews.forEach { $0.setNeedsLayout() }
        repositionViews()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async {
            self.repositionViews()
        }
    }
    
    /// Take the text inside of the field and make it a Tag.
    open func acceptCurrentTextAsTag() {
        if let currentText = tokenizeTextFieldText(),
            (self.textField.text?.isEmpty ?? true) == false {
            self.addTag(currentText)
        }
    }
    
    open var isEditing: Bool {
        return self.textField.isEditing
    }
    
    open func beginEditing() {
        self.textField.becomeFirstResponder()
        self.unselectAllTagViewsAnimated(false)
    }
    
    open func endEditing() {
        // NOTE: We used to check if .isFirstResponder and then resign first responder, but sometimes we noticed
        // that it would be the first responder, but still return isFirstResponder=NO.
        // So always attempt to resign without checking.
        self.textField.resignFirstResponder()
    }
    
    // MARK: - Adding / Removing Tags
    open func addTags(_ tags: [String]) {
        tags.forEach { addTag($0) }
    }
    
    open func addTags(_ tags: [WSTag]) {
        tags.forEach { addTag($0) }
    }
    
    open func addTag(_ tag: String) {
        addTag(WSTag(tag))
    }
    
    open func addTag(_ tag: WSTag) {
        
        if let onValidateTag = onValidateTag, !onValidateTag(tag, self.tags) {
            return
        } else if self.tags.contains(tag) {
            return
        }
        if self.tags.filter({$0.text.uppercased() == tag.text.uppercased()}).count > 0 {
            return
        }
        //        if self.tags.count == 23 {
        //            return
        //        }
        self.tags.append(tag)
        
        let tagView = WSTagView(tag: tag)
        tagView.font = self.font
        tagView.tintColor = self.tintColor
        tagView.textColor = self.textColor
        tagView.selectedColor = self.selectedColor
        tagView.selectedTextColor = self.selectedTextColor
      //  tagView.displayDelimiter = self.isDelimiterVisible ? self.delimiter : ""
        tagView.displayDelimiter = self.isDelimiterVisible ? self.delimiter : "        "
        let imageVw = UIImageView(frame: CGRect(x: tagView.frame.size.width - 25, y: 4, width: 25, height: 25))
        // imageVw.backgroundColor = .red
      //  tagView.layer.cornerRadius = tagView.frame.size.height/2
        imageVw.contentMode = .left
        imageVw.image = UIImage(named: "crossWhite")
        tagView.addSubview(imageVw)

        tagView.cornerRadius = tagView.frame.size.height/2
        self.cornerRadius = tagView.frame.size.height/2
        tagView.borderWidth = self.borderWidth
        tagView.borderColor = self.borderColor
        tagView.keyboardAppearanceType = self.keyboardAppearance
      //  tagView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
      //  self.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.contentInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 10)
      //  tagView.layoutMargins = self.layoutMargins
        tagView.onDidRequestSelection = { [weak self] tagView in
            self?.selectTagView(tagView, animated: true)
        }
        
        tagView.onDidRequestDelete = { [weak self] tagView, replacementText in
            // First, refocus the text field
            guard let wself = self else {return }
            wself.textField.becomeFirstResponder()
            if (replacementText?.isEmpty ?? false) == false {
                wself.textField.text = replacementText
            }
            // Then remove the view from our data
            if let index = self?.tagViews.index(of: tagView) {
                wself.removeTagAtIndex(index)
            }
        }
        
        tagView.onDidInputText = { [weak self] tagView, text in
            if text == "\n" {
                self?.selectNextTag()
            } else {
                self?.textField.becomeFirstResponder()
                self?.textField.text = text
            }
        }
        
        self.tagViews.append(tagView)
        addSubview(tagView)
        
        self.textField.text = ""
        
        onDidAddTag?(self, tag)
        
        // Clearing text programmatically doesn't call this automatically
        onTextFieldDidChange(self.textField)
        
        updatePlaceholderTextVisibility()
        repositionViews()
        //    let point = textField.frame.origin
        // self.setContentOffset(point, animated: false)
    }
    
    open func removeTag(_ tag: String) {
        removeTag(WSTag(tag))
    }
    
    open func removeTag(_ tag: WSTag) {
        if let index = self.tags.index(of: tag) {
            removeTagAtIndex(index)
        }
    }
    
    open func removeTagAtIndex(_ index: Int) {
        if index < 0 || index >= self.tags.count { return }
        
        let tagView = self.tagViews[index]
        tagView.removeFromSuperview()
        self.tagViews.remove(at: index)
        
        let removedTag = self.tags[index]
        self.tags.remove(at: index)
        onDidRemoveTag?(self, removedTag)
        
        updatePlaceholderTextVisibility()
        repositionViews()
    }
    
    open func removeTags() {
        self.tags.enumerated().reversed().forEach { index, _ in removeTagAtIndex(index) }
    }
    
    @discardableResult
    open func tokenizeTextFieldText() -> WSTag? {
        let text = self.textField.text?.trimmingCharacters(in: CharacterSet.whitespaces) ?? ""
        if text.isEmpty == false && (onVerifyTag?(self, text) ?? true) {
            
            let tag = WSTag(text)
            addTag(tag)
            
            self.textField.text = ""
            onTextFieldDidChange(self.textField)
            
            return tag
        }
        return nil
    }
    
    // MARK: - Actions
    
    @objc open func onTextFieldDidChange(_ sender: AnyObject) {
        onDidChangeText?(self, textField.text)
        
    }
    
    // MARK: - Tag selection
    
    open func selectNextTag() {
        guard let selectedIndex = tagViews.index(where: { $0.selected }) else {
            return
        }
        
        let nextIndex = tagViews.index(after: selectedIndex)
        if nextIndex < tagViews.count {
            tagViews[selectedIndex].selected = false
            tagViews[nextIndex].selected = true
        }
    }
    
    open func selectPrevTag() {
        guard let selectedIndex = tagViews.index(where: { $0.selected }) else {
            return
        }
        
        let prevIndex = tagViews.index(before: selectedIndex)
        if prevIndex >= 0 {
            tagViews[selectedIndex].selected = false
            tagViews[prevIndex].selected = true
        }
    }
    
    open func selectTagView(_ tagView: WSTagView, animated: Bool = false) {
        if self.readOnly {
            return
        }
        
        if tagView.selected {
            tagView.onDidRequestDelete?(tagView, nil)
            return
        }
        
        tagView.selected = true
        tagViews.filter { $0 != tagView }.forEach {
            $0.selected = false
            onDidUnselectTagView?(self, $0)
        }
        
        onDidSelectTagView?(self, tagView)
    }
    
    open func unselectAllTagViewsAnimated(_ animated: Bool = false) {
        tagViews.forEach {
            $0.selected = false
            onDidUnselectTagView?(self, $0)
        }
    }
    
    // MARK: internal & private properties or methods
    
    // Reposition tag views when bounds changes.
    fileprivate var layerBoundsObserver: NSKeyValueObservation?
    
}


// MARK: TextField Properties

extension WSTagsField {
    
    public var keyboardType: UIKeyboardType {
        get { return textField.keyboardType }
        set { textField.keyboardType = newValue }
    }
    
    public var returnKeyType: UIReturnKeyType {
        get { return textField.returnKeyType }
        set { textField.returnKeyType = .next }
    }
    
    public var spellCheckingType: UITextSpellCheckingType {
        get { return textField.spellCheckingType }
        set { textField.spellCheckingType = newValue }
    }
    
    public var autocapitalizationType: UITextAutocapitalizationType {
        get { return textField.autocapitalizationType }
        set { textField.autocapitalizationType = newValue }
    }
    
    public var autocorrectionType: UITextAutocorrectionType {
        get { return textField.autocorrectionType }
        set { textField.autocorrectionType = newValue }
    }
    
    public var enablesReturnKeyAutomatically: Bool {
        get { return textField.enablesReturnKeyAutomatically }
        set { textField.enablesReturnKeyAutomatically = false }
    }
    
    public var text: String? {
        get { return textField.text }
        set { textField.text = newValue }
    }
    
    @available(iOS, unavailable)
    override open var inputAccessoryView: UIView? {
        return super.inputAccessoryView
    }
    
    open var inputFieldAccessoryView: UIView? {
        get { return textField.inputAccessoryView }
        set { textField.inputAccessoryView = newValue }
    }
    
}

// MARK: Private functions

extension WSTagsField {
    
    fileprivate func internalInit() {
        self.isScrollEnabled = true
        self.showsHorizontalScrollIndicator = false
        
        textColor = .white
        selectedColor = .gray
        selectedTextColor = .black
        
        clipsToBounds = true
        textField.backgroundColor = .clear
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.autocapitalizationType = UITextAutocapitalizationType.none
        textField.spellCheckingType = .no
        textField.delegate = self
        textField.font = font
        textField.textColor = fieldTextColor
        textField.returnKeyType = .next
        addSubview(textField)
        
//        layerBoundsObserver = self.observe(\.layer.bounds, options: [.old, .new]) { [weak self] sender, change in
//            guard change.oldValue?.size.width != change.newValue?.size.width else {
//                return
//            }
//            self?.repositionViews()
//        }
        
        textField.onDeleteBackwards = { [weak self] in
            if self?.readOnly ?? true { return }
            
            if self?.textField.text?.isEmpty ?? true, let tagView = self?.tagViews.last {
                self?.selectTagView(tagView, animated: true)
                self?.textField.resignFirstResponder()
            }
        }
        
        textField.addTarget(self, action: #selector(onTextFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        repositionViews()
    }
    
    fileprivate func calculateContentHeight(layoutWidth: CGFloat) -> CGFloat {
        var totalRect: CGRect = .null
        enumerateItemRects(layoutWidth: layoutWidth) { (_, tagRect: CGRect?, textFieldRect: CGRect?) in
            if let tagRect = tagRect {
                totalRect = tagRect.union(totalRect)
            }
            else if let textFieldRect = textFieldRect {
                totalRect = textFieldRect.union(totalRect)
            }
        }
        return  totalRect.height
    }
    
    fileprivate func enumerateItemRects(layoutWidth: CGFloat, using closure: (_ tagView: WSTagView?, _ tagRect: CGRect?, _ textFieldRect: CGRect?) -> Void) {
        if layoutWidth == 0 {
            return
        }
        
        let maxWidth: CGFloat = layoutWidth - contentInset.left - contentInset.right
        var curX: CGFloat = 10.0
        var curY: CGFloat = 0.0
        var totalHeight: CGFloat = Constants.STANDARD_ROW_HEIGHT
        
        // Tag views Rects
        var tagRect = CGRect.zero
        for tagView in tagViews {
            tagView.cornerRadius = self.cornerRadius

            tagRect = CGRect(origin: CGPoint.zero, size: tagView.sizeToFit(.init(width: maxWidth, height: 0)))
            if curX + tagRect.width > maxWidth {
                // Need a new line
                curX = 10
                curY += Constants.STANDARD_ROW_HEIGHT + spaceBetweenLines
                totalHeight += Constants.STANDARD_ROW_HEIGHT
            }
            
            tagRect.origin.x = curX
            // Center our tagView vertically within STANDARD_ROW_HEIGHT
            tagRect.origin.y = curY + ((Constants.STANDARD_ROW_HEIGHT - tagRect.height)/2.0)
            
            closure(tagView, tagRect, nil)
            
            curX = tagRect.maxX + self.spaceBetweenTags
        }
        
        // Always indent TextField by a little bit
        curX += max(0, Constants.TEXT_FIELD_HSPACE - self.spaceBetweenTags)
        var availableWidthForTextField: CGFloat = maxWidth - curX
        
        if textField.isEnabled {
            var textFieldRect = CGRect.zero
            textFieldRect.size.height = Constants.STANDARD_ROW_HEIGHT
            
            if availableWidthForTextField < Constants.MINIMUM_TEXTFIELD_WIDTH {
                // If in the future we add more UI elements below the tags,
                // isOnFirstLine will be useful, and this calculation is important.
                // So leaving it set here, and marking the warning to ignore it
                curX = 0 + Constants.TEXT_FIELD_HSPACE
                curY += Constants.STANDARD_ROW_HEIGHT + spaceBetweenLines
                totalHeight += Constants.STANDARD_ROW_HEIGHT
                // Adjust the width
                availableWidthForTextField = maxWidth - curX
            }
            textFieldRect.origin.y = curY
            textFieldRect.origin.x = curX
            textFieldRect.size.width = availableWidthForTextField
            
            closure(nil, nil, textFieldRect)
        }
    }
    
    fileprivate func repositionViews() {
        if self.bounds.width == 0 {
            return
        }
        var contentRect: CGRect = .null
        enumerateItemRects(layoutWidth: self.bounds.width) { (tagView: WSTagView?, tagRect: CGRect?, textFieldRect: CGRect?) in
            if let tagRect = tagRect, let tagView = tagView {
                tagView.frame = tagRect
                tagView.cornerRadius = self.cornerRadius
                tagView.setNeedsLayout()
                tagView.layoutIfNeeded()
                contentRect = tagRect.union(contentRect)
            }
            else if let textFieldRect = textFieldRect {
                textField.frame = textFieldRect
                contentRect = textFieldRect.union(contentRect)
            }
        }
        
        textField.isHidden = !textField.isEnabled
        
        invalidateIntrinsicContentSize()
        let newIntrinsicContentHeight = intrinsicContentSize.height
        
//        if intrinsicContentSize.height > 300 {
//            newIntrinsicContentHeight = 300
//        }
        
        if constraints.isEmpty {
            
            frame.size.height = newIntrinsicContentHeight.rounded()
        }
        
        if oldIntrinsicContentHeight != newIntrinsicContentHeight {
            if let didChangeHeightToEvent = self.onDidChangeHeightTo {
                didChangeHeightToEvent(self, newIntrinsicContentHeight)
            }
            oldIntrinsicContentHeight = newIntrinsicContentHeight
        }
        
        //        if self.enableScrolling {
        //            self.isScrollEnabled = contentRect.height + contentInset.top + contentInset.bottom >= newIntrinsicContentHeight
        //        }
        self.contentSize.width = self.bounds.width - contentInset.left - contentInset.right
       
        self.contentSize.height = contentRect.height


        //frame.origin.y =  frame.origin.y + 50
        //self.scrollRectToVisible(newframe, animated: false)
        // self.contentInset = UIEdgeInsets(top: 220, left: 0, bottom: 0, right: 0 )
        if self.isScrollEnabled {
            // FIXME: this isn't working. Need to think in a workaround.
            //self.scrollRectToVisible(textField.frame, animated: false)
            
        }
    }
    
    fileprivate func updatePlaceholderTextVisibility() {
        textField.attributedPlaceholder = (placeholderAlwaysVisible || tags.count == 0) ? attributedPlaceholder() : nil
    }
    
    private func attributedPlaceholder() -> NSAttributedString {
        var attributes: [NSAttributedString.Key: Any]?
        if let placeholderColor = placeholderColor {
            attributes = [NSAttributedString.Key.foregroundColor: placeholderColor]
        }
        return NSAttributedString(string: placeholder, attributes: attributes)
    }
    
    private var maxHeightBasedOnNumberOfLines: CGFloat {
        guard self.numberOfLines > 0 else {
            return CGFloat.infinity
        }
        let ht = contentInset.top + contentInset.bottom + Constants.STANDARD_ROW_HEIGHT * CGFloat(numberOfLines) + spaceBetweenLines * CGFloat(numberOfLines - 1)
        return  ht
    }
    
}

extension WSTagsField: UITextFieldDelegate {
    
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
      //  textField.returnKeyType = .next
        textDelegate?.textFieldDidBeginEditing?(textField)
        unselectAllTagViewsAnimated(true)
        //  self.scrollRectToVisible(textField.frame, animated: true)
        
    }
    
    //    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    //        textDelegate?.textFieldShouldBeginEditing?(textField)
    //        return true
    //    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textDelegate?.textFieldDidEndEditing?(textField)
    }
    
    public func textFieldShouldReturn(_ textField:   UITextField) -> Bool {
        if acceptTagOption == .return && onShouldAcceptTag?(self) ?? true {
            tokenizeTextFieldText()
            _ = textDelegate?.textFieldShouldReturn?(textField)
            return true
        }
        if let textFieldShouldReturn = textDelegate?.textFieldShouldReturn, textFieldShouldReturn(textField) {
            tokenizeTextFieldText()
            _ = textDelegate?.textFieldShouldReturn?(textField)
            
            return true
        }
        
        return false
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let searchTxt = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        if searchTxt.count > 40 {
            return false
        }
        if searchTxt.isValidSkil {
            return true
        }
        
        if acceptTagOption == .comma && string == "," && onShouldAcceptTag?(self) ?? true {
            tokenizeTextFieldText()
            return false
        }
        if acceptTagOption == .space && string == " " && onShouldAcceptTag?(self) ?? true {
            tokenizeTextFieldText()
            
            return false
        }
        return true
    }
    
}

public func == (lhs: UITextField, rhs: WSTagsField) -> Bool {
    return lhs == rhs.textField
}

#if swift(>=4.2)

// Workaround for bugs.swift.org/browse/SR-7879
extension UIEdgeInsets {
    static let zero = UIEdgeInsets()
}
extension String {
    var isValidSkil: Bool {
        get {
            
            let regex = "[a-zA-Z ]*"
            let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
            return predicate.evaluate(with: self)
            
            //return false
        }
    }
}
#endif

