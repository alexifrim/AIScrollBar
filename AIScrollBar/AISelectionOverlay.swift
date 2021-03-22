//
//  AISelectionOverlay.swift
//  AIScrollBar
//
//  Created by Ifrim Alexandru on 3/19/21.
//

import UIKit

/// Simple overlay view used to mark selection
@objc class AISelectionOverlay : UIView {
    @objc let border = CALayer()
    
    convenience init() {
        self.init(frame: .zero)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    private func setup() {
        self.isUserInteractionEnabled = false
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.backgroundColor = .clear
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.white.cgColor
        
        border.backgroundColor = UIColor.clear.cgColor
        border.borderWidth = 1
        border.borderColor = UIColor.blue.cgColor
        self.layer.addSublayer(border)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        border.frame = self.layer.bounds.insetBy(dx: 3, dy: 3)
    }
}
