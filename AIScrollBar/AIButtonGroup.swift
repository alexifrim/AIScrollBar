//
//  AIButtonGroup.swift
//  AIScrollBar
//
//  Created by Ifrim Alexandru on 3/17/21.
//

import UIKit

/// Group of buttons that can act as a segmented control that allows multiple selections
@objc class AIButtonGroup: UIControl {
    internal private(set) var buttons: [AIButtonSelectable] = Array()
    internal private(set) var separators: [UIView] = Array()
    @objc let selectedIndexes: NSMutableIndexSet = NSMutableIndexSet()
    @objc var separatorColor: UIColor = .black {
        didSet {
            for separator in self.separators {
                separator.backgroundColor = self.separatorColor
            }
        }
    }
    /// if set, this will be applied to all the buttons part of this group
    @objc var selectionBackgroundColor: UIColor? {
        didSet {
            if let color = self.selectionBackgroundColor {
                for button in self.buttons {
                    button.backgroundColorSelected = color
                }
            }
        }
    }
    @objc var buttonPadding = 24
    @objc var buttonSelectionHandler: ((_ sender: AIButtonGroup, _ index: Int, _ select: Bool) -> Bool)?
    @objc var buttonWidth: CGFloat = 0
    
    @objc func setEnabled(_ enabled: Bool, forIndex index: Int) {
        assert(index >= 0 && index < self.buttons.count, "out of bounds")
        
        let button = self.buttons[index]
        button.isEnabled = enabled
    }
    override var isEnabled: Bool {
        didSet {
            if oldValue == self.isEnabled {
                return
            }
            for index in 0 ..< self.buttons.count {
                self.setEnabled(isEnabled, forIndex: index)
            }
        }
    }
    
    // MARK: - setup
    @objc func addButton() -> AIButtonSelectable {
        let button = AIButtonSelectable(frame: .zero)
        button.selectionTag = self.buttons.count
        button.backgroundColorDefault = self.backgroundColor
        button.backgroundColorSelected = self.selectionBackgroundColor
        button.addTarget(self, action: #selector(onTouch(_:)), for: .touchUpInside)
        self.buttons.append(button)
        self.addSubview(button)
        
        if self.buttons.count > 1 {
            self.addSeparator()
        }
        self.setNeedsLayout()
        
        return button
    }
    @discardableResult private func addSeparator() -> UIView {
        let separator = UIView(frame: .zero)
        separator.backgroundColor = self.separatorColor
        self.separators.append(separator)
        self.addSubview(separator)
        return separator
    }
    
    // MARK: - layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var frame = CGRect(x: 0, y: 0,
                           width: 0,
                           height: self.bounds.size.height)
        var frameSeparator: CGRect = .zero
        frameSeparator.origin.y = 7
        frameSeparator.size.height = self.bounds.size.height - frameSeparator.origin.y * 2
        frameSeparator.size.width = 1
        
        for (index, button) in self.buttons.enumerated() {
            // position button
            if self.buttonWidth > 0 {
                frame.size.width = self.buttonWidth
            }
            else {
                // size to fit
                frame.size.width = CGFloat(Swift.max(Int(ceil(button.titleLabel?.sizeThatFits(CGSize(width: 100, height: 0)).width ?? 0)) + self.buttonPadding,
                                               38))
            }
            button.frame = frame
            frame.origin.x += frame.size.width
            
            // position separator
            if index < self.separators.count {
                let separator = self.separators[index]
                frameSeparator.origin.x = frame.origin.x - 0.5
                separator.frame = frameSeparator
            }
        }
    }
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        // !!!: there are some issues (at least on the simulator) where layoutSubviews is not called, even if content was never layed out prior to this (even if `setNeedsLayout` is called anywhere prior to this)
        self.layoutIfNeeded()
        var fitSize = size
        if let button = buttons.last {
            fitSize.width = button.frame.maxX
        }
        else {
            fitSize.width = 0
        }
        return fitSize
    }
    override var intrinsicContentSize: CGSize {
        get {
            return self.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude, height: 32))
        }
    }
    
    
    // MARK: - interaction
    @objc private func onTouch(_ sender: AIButtonSelectable) {
        // toggle selection
        let index = sender.selectionTag
        let selection = !sender.isSelected
        var toggle = false
        if let handler = self.buttonSelectionHandler {
            // call selection handler, and check if the new selection state should be kept
            toggle = handler(self, index, selection) == selection
        }
        if toggle {
            self.setSelection(selection, for: index)
            self.sendActions(for: .valueChanged)
        }
        
    }

    @objc func setSelection(_ selected: Bool, for index: Int) {
        assert(index >= 0 && index < self.buttons.count)
        
        let button = self.buttons[index]
        if button.isSelected == selected {
            return
        }
        button.isSelected = selected
        if selected {
            self.selectedIndexes.add(index)
        }
        else {
            self.selectedIndexes.remove(index)
        }
        
        // change separator color with neighbour buttons
        if index > 0 {
            let other = self.buttons[index - 1]
            if other.isSelected {
                let separator = self.separators[index - 1]
                separator.backgroundColor = (button.isSelected == true) ? self.backgroundColor : self.separatorColor
            }
        }
        if index < self.buttons.count - 1 {
            let other = self.buttons[index + 1]
            if other.isSelected {
                let separator = self.separators[index]
                separator.backgroundColor = (button.isSelected == true) ? self.backgroundColor : self.separatorColor
            }
        }
    }
    @objc func deselectAll() {
        while self.selectedIndexes.firstIndex != NSNotFound {
            self.setSelection(false, for: self.selectedIndexes.firstIndex)
        }
    }
    @objc func selectAll() {
        for index in 0 ..< self.buttons.count {
            self.setSelection(true, for: index)
        }
    }
    
    
    // MARK: - buttons access
    @objc func button(at index: Index) -> UIButton {
        assert(index >= 0 && index < self.buttons.count, "Out of bounds")
        return self.buttons[index]
    }
    @objc func buttonCount() -> Int {
        return self.buttons.count
    }
}

extension AIButtonGroup: Collection {
    typealias Index = Int
    typealias Button = UIButton
    var startIndex: Int {
        return 0
    }
    var endIndex: Int {
        return self.count - 1
    }
    subscript(position: Int) -> Button {
        assert(position >= 0 && position < self.buttons.count)
        return self.buttons[position]
    }
    func index(after i: Int) -> Int {
        return i + 1
    }
    var count: Int {
        return self.buttons.count
    }
}
