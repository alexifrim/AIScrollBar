//
//  ContentView.swift
//  AIScrollBar
//
//  Created by Ifrim Alexandru on 3/17/21.
//

import SwiftUI
import AIScrollBar

struct ContentView: View {
    @State private var showingViewController = false
    
    var body: some View {
        VStack {
            Text("Scroll Bar Sample")
                .padding()
            
            AIScrollBarRep(setup: { (bar) in
                bar.autoCenter = true
                
                let colors: [UIColor] = [.white, .lightGray, .gray, .darkGray, .black, .red, .purple, .yellow, .green, .cyan, .magenta, .blue]
                
                let groupStyle = bar.addButtonGroup { (group) in
                    group.separatorColor = UIColor(red: 0, green: 1, blue: 0.5, alpha: 1)
                    group.backgroundColor = .orange
                    
                    let btbBg = group.addButton()
                    btbBg.setTitle("A_", for: .normal)
                    btbBg.setTitleColor(.white, for: .normal)
                    btbBg.setupDefaultOverlay()
                    
                    let btnFg = group.addButton()
                    btnFg.setTitle("A", for: .normal)
                    btnFg.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: UIFont.buttonFontSize)
                    btnFg.setTitleColor(.white, for: .normal)
                    btnFg.setupDefaultOverlay()
                }
                groupStyle.buttonSelectionHandler = { (sender: AIButtonGroup, index: Int, selection: Bool) in
                    // this implementation allows 1 selection at a time
                    if selection == false {
                        // keep 1 button selected at all times
                        return true
                    }
                    sender.deselectAll()
                    return selection
                }
                groupStyle.setSelection(true, for: 1)
                
                let groupColors = bar.addButtonGroup { (group) in
                    group.separatorColor = UIColor(red: 0.5, green: 1, blue: 0.5, alpha: 1)
                    
                    // setup a custom selection overlay
                    let overlay = AIButtonSelectable.createDefaultOverlay()
                    for color in colors {
                        let button = group.addButton()
                        button.backgroundColor = color
                        button.selectionOverlay = overlay
                    }
                }
                groupColors.buttonSelectionHandler = { (sender: AIButtonGroup, index: Int, selection: Bool) in
                    // this implementation forces 1 selection at a time
                    if selection == false {
                        // disable deselection
                        return true
                    }
                    // remove current selection
                    sender.deselectAll()
                    
                    let color = sender[index].backgroundColor
                    if groupStyle.selectedIndexes.contains(0) {
                        groupStyle[0].backgroundColor = color
                    }
                    if groupStyle.selectedIndexes.contains(1) {
                        groupStyle[1].setTitleColor(color, for: .normal)
                    }
                    
                    return selection
                }
                groupColors.setSelection(true, for: 0)

                bar.backgroundColor = .darkGray
            })
            .previewLayout(.sizeThatFits)
            .frame(maxWidth: .infinity)
            .fixedSize(horizontal: false, vertical: true)
            .background(Color.black)
            
            AIButtonGroupRep(setup: { (group) in
                group.separatorColor = .black
                group.selectionBackgroundColor = .red
                group.backgroundColor = .lightGray
                
                group.addButton().setTitle("Text", for: .normal)
                group.addButton().setTitle("Text3", for: .normal)
                
                let button = group.addButton()
                button.setTitle("T", for: .normal)
                
                group.buttonSelectionHandler = { (sender: AIButtonGroup, index: Int, selection: Bool) in
                    // this implementation allows multiple selections, but won't allow deselecting all buttons
                    if selection == false && sender.selectedIndexes.count == 1 {
                        // keep at least 1 button selected
                        return true
                    }
                    return selection
                }
                
                group.setSelection(true, for: 2)
            })
            .fixedSize()
            
            Button("Present ViewController") {
                self.showingViewController = true
            }
            .padding()
        }
        .sheet(isPresented: $showingViewController) {
            ViewControllerRep()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
