//
//  ScrollBarComponents.swift
//  AIScrollBar
//
//  Created by Ifrim Alexandru on 3/20/21.
//


import SwiftUI
import AIScrollBar

/// Basic implementation to allow usage in SwiftUI
/// For actual apps that use SwiftUI, this would need to be updated
struct AIButtonGroupRep: UIViewRepresentable {
    var setup = { (group: AIButtonGroup) in }
    
    init(setup: (@escaping (_ group: AIButtonGroup) -> Void)) {
        self.setup = setup
    }
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> AIButtonGroup {
        let group = AIButtonGroup(frame: .zero)
        
        group.translatesAutoresizingMaskIntoConstraints = false
        group.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        group.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        setup(group)
        return group
    }
    
    func updateUIView(_ uiView: AIButtonGroup, context: UIViewRepresentableContext<Self>) {
        
    }
}

/// Basic implementation to allow usage in SwiftUI
/// For actual apps that use SwiftUI, this would need to be updated
struct AIScrollBarRep: UIViewRepresentable {
    var setup = { (group: AIScrollBar) in }
    
    init(setup: (@escaping (_ view: AIScrollBar) -> Void)) {
        self.setup = setup
    }
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> AIScrollBar {
        let view = AIScrollBar(frame: .zero)
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self.setup(view)
        return view
    }
    
    func updateUIView(_ view: AIScrollBar, context: UIViewRepresentableContext<Self>) {
        
    }
}
