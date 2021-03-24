# AIScrollBar

Horizontal scrollable bar with grouped buttons, suitable to replace toolbars where more content is needed.
Other controls can be used separately, such as `AISelectableButton` (button with different background color or overlay when selected), and `AIButtonGroup` (similar behavior to `UISegmentedControl`)


## Requirements

`AIScrollBar` works on iOS 9.0+.


## Adding AIScrollBar to your project

### CocoaPods

[CocoaPods](http://cocoapods.org) is the recommended way to add *AIScrollBar* to your project.

1. Add a pod entry for AIScrollBar to your Podfile `pod 'AIScrollBar'`
2. Install the pod(s) by running `pod install`.
3. Import the module: `import AIScrollBar` (or `@import AIScrollBar;` in *Objective-C*)
4. [for Objective-C] Make sure `CLANG_ENABLE_MODULES` is set to `YES` in your target build settings. You may also need to add an empty switf file to your project so that swift libraries are linked

### Source files

Alternatively you can directly add the `.swift` from inside the *AIScrollBar* folder to your project, and threat them as any other .swift files.


## Usage

Detailed examples of usage can be found in the repository.

A typical bar can be set as follows:

```swift
let bar = AIScrollBar(frame: .zero)
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
    }
})
// add more groups as needed
```

The selection behavior is set per group, through the `buttonSelectionHandler`. This may change in a future version so that standard behaviors can be set through an enum.

If a single button must be selected at a time, the implementation would look similar to this:

```swift
group.buttonSelectionHandler = { (sender: AIButtonGroup, index: Int, selection: Bool) in
    if selection == false {
        // disable deselection - must have at least 1 item selected
        return true
    }
    // remove current selection
    sender.deselectAll()

    // confirm the new selection
    return selection
}
```
`AIButtonGroup` reports selection changes through `Event.valueChanged`. This is the recommended way to handle selection changes, rather than handling them inside the `buttonSelectionHandler`. 

## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE).


## Privacy

AIScrollBar does not collect any data.
