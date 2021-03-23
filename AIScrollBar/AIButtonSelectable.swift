//
//  AIButtonSelectable.swift
//  AIScrollBar
//
//  Created by Ifrim Alexandru on 3/17/21.
//

import UIKit


/// Button which also changes background color based on the selection state
@objc open class AIButtonSelectable: UIButton {
    // MARK: properties
    @objc open var backgroundColorDefault: UIColor?
    @objc open var backgroundColorSelected: UIColor? {
        didSet {
            if self.isSelected {
                self.refresh(selected: self.isSelected)
            }
        }
    }
    /// Overlay to show over the selection (e.g. in case a white border would need to be displayed, while a button is selected)
    /// In case multiple selectable buttons are grouped together, a shared `selectionOverlay` can be shared between them, if only one of them can be selected at a time
    @objc open var selectionOverlay: UIView? {
        didSet {
            if let _ = self.selectionOverlay, self.isSelected {
                self.refresh(selected: self.isSelected)
            }
        }
    }
    /// Can be used to id the selected buttons  - we don't use `tag` to avoid conflicts
    @objc open var selectionTag: Int = 0
    open override var backgroundColor: UIColor? {
        get {
            return super.backgroundColor
        }
        set(newValue) {
            self.backgroundColorDefault = newValue
            if self.isSelected == false || self.backgroundColorSelected == nil {
                super.backgroundColor = newValue
            }
        }
    }
    open override var isEnabled: Bool {
        didSet {
            self.refresh(selected: self.isSelected)
        }
    }
    open override var isHighlighted: Bool {
        didSet {
            self.refresh(selected: self.isSelected || self.isHighlighted)
        }
    }
    open override var isSelected: Bool {
        didSet {
            if oldValue != self.isSelected {
                self.refresh(selected: self.isSelected)
            }
        }
    }
    
    // MARK: - setup
    @objc public static func createDefaultOverlay() -> UIView {
        return AISelectionOverlay()
    }
    @objc @discardableResult open func setupDefaultOverlay() -> UIView {
        assert(self.selectionOverlay == nil, "Resetting the overlay is not handled specifically, and may cause unexpected behavior")
        
        self.selectionOverlay = Self.createDefaultOverlay()
        return self.selectionOverlay!
    }
    
    // MARK: -
    /// Set the proper background and tint color based on current button state
    internal func refresh(selected: Bool) {
        // background
        if selected {
            if self.backgroundColorDefault == nil {
                self.backgroundColorDefault = self.backgroundColor ?? .clear
            }
            if let selectedColor = self.backgroundColorSelected {
                super.backgroundColor = selectedColor
            }
            if let overlay = self.selectionOverlay, overlay.superview != self {
                overlay.frame = self.bounds
                self.addSubview(overlay)
            }
        }
        else {
            super.backgroundColor = self.backgroundColorDefault
            if let overlay = self.selectionOverlay, overlay.superview == self {
                overlay.removeFromSuperview()
            }
        }
        
        // tint, for tintable images
        if self.isEnabled {
            if selected {
                self.tintColor = self.titleColor(for: .selected)
            }
            else {
                self.tintColor = self.titleColor(for: .normal)
            }
        }
        else {
            self.tintColor = self.titleColor(for: .disabled)
        }
    }
    
    // we override state properties so that buttons that are both selected and disabled show the disabled state
    open override func setTitleColor(_ color: UIColor?, for state: UIControl.State) {
        super.setTitleColor(color, for: state)
        if state == .disabled {
            super.setTitleColor(color, for: [.disabled, .selected])
        }
    }
    open override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        if state == .disabled {
            super.setTitle(title, for: [.disabled, .selected])
        }
    }
    open override func setImage(_ image: UIImage?, for state: UIControl.State) {
        super.setImage(image, for: state)
        if state == .disabled {
            super.setImage(image, for: [.disabled, .selected])
        }
    }
    open override func setBackgroundImage(_ image: UIImage?, for state: UIControl.State) {
        super.setBackgroundImage(image, for: state)
        if state == .disabled {
            super.setBackgroundImage(image, for: [.disabled, .selected])
        }
    }
    open override func setTitleShadowColor(_ color: UIColor?, for state: UIControl.State) {
        super.setTitleShadowColor(color, for: state)
        if state == .disabled {
            super.setTitleShadowColor(color, for: [.disabled, .selected])
        }
    }
}
