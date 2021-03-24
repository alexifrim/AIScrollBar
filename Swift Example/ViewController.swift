//
//  ViewController.swift
//  AIScrollBar
//
//  Created by Ifrim Alexandru on 3/23/21.
//

import UIKit
import AIScrollBar

class ViewController: UIViewController {
    var bar: AIScrollBar!
    var label: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapDone))
        
        self.setupSelectionPreview()
        self.setupScrollBar()
    }
    
    func setupSelectionPreview() {
        let label = UITextField(frame: .zero)
        label.isEnabled = false
        label.placeholder = "No selection."
        label.backgroundColor = .white
        label.textColor = .black
        label.textAlignment = .center
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        
        self.label = label
        self.view.addSubview(label)
    }
    
    func setupScrollBar() {
        let bar = AIScrollBar(frame: .zero)
        bar.backgroundColor = UIColor(red: 0.7, green: 0.4, blue: 0.3, alpha: 1)
        bar.separatorColor = .red
        bar.borderColor = .orange
        
        let group = bar.addButtonGroup(with: { (group) in
            group.selectionBackgroundColor = UIColor(red: 0.3, green: 0.4, blue: 0.7, alpha: 1)
            
            // add buttons with the alphabet
            for char in UnicodeScalar("a").value...UnicodeScalar("z").value {
                let string = String(UnicodeScalar(char)!)
                
                let button = group.addButton()
                button.setTitle(string, for: .normal)
                button.setTitleColor(.white, for: .normal)
                button.setupDefaultOverlay()
            }
        })
        
        group.buttonSelectionHandler = { (sender: AIButtonGroup, index: Int, selection: Bool) in
            return selection
        }
        
        group.addAction(UIAction(handler: { [weak self] (action) in
            var selection = ""
            for index in group.selectedIndexes {
                let button = group[index]
                selection += button.title(for: .normal)!
            }
            self?.label.text = selection
        }), for: .valueChanged)
    
        
        self.view.addSubview(bar)
        self.bar = bar
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var frame = CGRect(x: 0, y: 100, width: self.view.bounds.size.width, height: 32)
        label.frame = frame
        
        frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 40)
        let bottom = self.view.bounds.size.height - self.view.safeAreaInsets.bottom
        frame.origin.y = bottom - frame.size.height
        bar.frame = frame
    }
    
    @objc func tapDone() {
        self.navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}


import SwiftUI

struct ViewControllerRep: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let viewController = ViewController()
        
        let nav = UINavigationController(rootViewController: viewController)
        return nav
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        
    }
}
