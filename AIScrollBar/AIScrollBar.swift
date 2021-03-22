//
//  AIScrollBar.swift
//  AIScrollBar
//
//  Created by Ifrim Alexandru on 3/17/21.
//

import UIKit

class AIScrollBar: UIScrollView {
    internal static let defaultButtonWidth: CGFloat = 38
    internal static let defaultSeparatorWidth: CGFloat = 3
    
    internal var contentHeight: CGFloat
    internal var nextX: CGFloat = 0
    
    /// Set to true to center the contents, while the bar is wider than the content (rather than aligning contents to left)
    @objc var autoCenter: Bool = false
    /// List of groups added with `addButtonGroup(with:)`
    @objc private(set) var buttonGroups: [AIButtonGroup] = Array()
    internal private(set) var separators: [UIView] = Array()
    
    internal var borderTop: UIView?;
    internal var borderBottom: UIView?;
    
    /// Color used for top/bottom border as well as separator between different groups
    @objc var borderColor: UIColor = .gray
    /// Color used as separator between buttons inside a group
    @objc var separatorColor: UIColor = .black
    
    override required init(frame: CGRect) {
        var frame = frame
        if frame.size.height <= 1 {
            frame.size.height = 40
        }
        self.contentHeight = frame.size.height
        
        super.init(frame: frame)
        
        self.buttonGroups.reserveCapacity(15)
        self.separators.reserveCapacity(14)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setup
    @objc func addButtonGroup(with setup: (_ group: AIButtonGroup) -> Void) -> AIButtonGroup {
        if self.buttonGroups.count > 0 {
            self.addSeparator()
        }
        
        let group = AIButtonGroup(frame: .zero)
        group.buttonWidth = Self.defaultButtonWidth
        group.backgroundColor = self.backgroundColor
        group.separatorColor = self.separatorColor
        group.autoresizingMask = [.flexibleBottomMargin, .flexibleRightMargin]
        
        setup(group)
        
        self.layout(group: group)
        self.addSubview(group)
        self.buttonGroups.append(group)
        
        return group
    }
    private func addSeparator() {
        let border = UIView()
        border.autoresizingMask = [.flexibleRightMargin, .flexibleBottomMargin]
        border.backgroundColor = self.borderColor
        self.layout(separator: border)
        self.addSubview(border)
        self.separators.append(border)
    }
    @objc func setupBorders() {
        assert(self.borderTop == nil && self.borderBottom == nil, "Borders are already set")
        if self.borderTop != nil {
            return
        }
        
        self.borderTop = setupBorder()
        self.borderBottom = setupBorder()
    }
    private func setupBorder() -> UIView {
        let border = UIView()
        border.backgroundColor = self.borderColor
        self.addSubview(border)
        return border
    }
    
    
    // MARK: - layout
    func resetLayout() {
        self.nextX = 0
        for (index, group) in self.buttonGroups.enumerated() {
            self.layout(group: group)
            
            if index < self.separators.count {
                let separator = self.separators[index]
                self.layout(separator: separator)
            }
        }
        self.resetContentSize()
    }
    private func resetContentSize() {
        let width = self.buttonGroups.last?.frame.maxX ?? 0
        self.contentSize = CGSize(width: width, height: 1)
    }
    private func layout(group: AIButtonGroup) {
        var frame = group.frame
        frame.origin.x = self.nextX
        frame.origin.y = 1
        frame.size.width = ceil(group.sizeThatFits(CGSize(width: 2000, height: 0)).width);
        frame.size.height = self.bounds.size.height - 2
        group.frame = frame
        
        self.nextX += group.frame.size.width
    }
    private func layout(separator: UIView) {
        var frame = separator.frame
        frame.origin.x = nextX
        frame.origin.y = 0
        frame.size.width = Self.defaultSeparatorWidth
        frame.size.height = self.bounds.size.height
        separator.frame = frame
        nextX += frame.size.width
    }
    private func layoutBorders() {
        guard let borderTop = self.borderTop, let borderBottom = self.borderBottom else {
            return
        }
        var frame = self.bounds
        frame.size.height = 1
        if frame.size.width < self.contentSize.width {
            frame.size.width = self.contentSize.width
        }
        borderTop.frame = frame
        

        frame.origin.y = self.bounds.size.height - frame.size.height
        if #available(iOS 11.0, *) {
            frame.origin.y -= self.safeAreaInsets.bottom
        }
        borderBottom.frame = frame
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.resetContentSize()
        self.resetInsets()
        
        self.layoutBorders()
    }
    @available(iOS 11.0, *)
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        
        self.invalidateIntrinsicContentSize()
        self.resetInsets()
    }
    /// reset insets so that the content is either centered or left aligned
    private func resetInsets() {
        var insets = self.contentInset
        if self.autoCenter {
            // center content in the container
            var contentWidth = self.bounds.size.width
            if #available(iOS 11.0, *) {
                contentWidth = contentWidth - self.safeAreaInsets.left - self.safeAreaInsets.right
            }
            if self.contentSize.width >= contentWidth {
                insets.left = 0
                insets.right = 0
            }
            else {
                insets.left = (self.bounds.size.width - self.contentSize.width) / 2
                insets.right = insets.left
            }
        }
        else {
            // (default) left alignment
            insets.left = 0
            insets.right = 0
        }
        if #available(iOS 11.0, *) {
            if insets.left < self.safeAreaInsets.left {
                insets.left = self.safeAreaInsets.left
            }
            if insets.right < self.safeAreaInsets.right {
                insets.right = self.safeAreaInsets.right
            }
        }
        self.contentInset = insets
    }
    override var intrinsicContentSize: CGSize {
        get {
            var size = super.intrinsicContentSize
            size.height = self.contentHeight
            if #available(iOS 11.0, *) {
                size.height += self.safeAreaInsets.bottom
            }
            return size
        }
    }
}
