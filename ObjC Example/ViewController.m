//
//  ViewController.m
//  ObjcExample
//
//  Created by Ifrim Alexandru on 3/20/21.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize labelPosition = _labelPosition;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.darkGrayColor;
    
    _labelPosition = kFieldLabelPositionTop;
    
    [self setupPreview];
    [self setupScrollBar];
}

#pragma mark - setup
- (void)setupPreview {
    _preview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
    _preview.backgroundColor = UIColor.blackColor;
    
    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    _label.backgroundColor = _preview.backgroundColor;
    _label.textColor = UIColor.lightGrayColor;
    _label.text = @"Sample text";
    [_preview addSubview:_label];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectZero];
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.backgroundColor = UIColor.whiteColor;
    _textField.textColor = UIColor.blackColor;
    _textField.text = @"Sample text input";
    [_preview addSubview:_textField];
    
    [self.view addSubview:_preview];
}
- (void)setupScrollBar {
    AIScrollBar *bar = [[AIScrollBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    bar.autoCenter = YES;
    bar.backgroundColor = [UIColor colorWithRed:0.7 green:0.4 blue:0.3 alpha:1];
    bar.borderColor = [UIColor colorWithRed:0.3 green:0.7 blue:0.5 alpha:1];
    bar.separatorColor = UIColor.orangeColor;
    
    AIButtonGroup *groupLabelPosition __weak
    = [bar addButtonGroupWith:^(AIButtonGroup *group) {
        group.backgroundColor = bar.backgroundColor;
        group.selectionBackgroundColor = UIColor.redColor;
        
        AIButtonSelectable *button;
        
        button = [group addButton];
        [self formatButton:button];
        [button setImage:[UIImage imageNamed:@"icon-2_alignment-top"] forState:UIControlStateNormal];
        
        button = [group addButton];
        [self formatButton:button];
        [button setImage:[UIImage imageNamed:@"icon-2_alignment-left"] forState:UIControlStateNormal];
        
        button = [group addButton];
        [self formatButton:button];
        [button setImage:[UIImage imageNamed:@"icon-2_alignment-bottom"] forState:UIControlStateNormal];
    }];
    [self labelPositionRefresh:groupLabelPosition];
    
    __weak typeof(self) wself = self;
    [groupLabelPosition setButtonSelectionHandler:^BOOL(AIButtonGroup *sender, NSInteger index, BOOL selected)
     {
        // this implementation allows selecting none or 1 button at a time
        if (selected) {
            wself.labelPosition = index;
        }
        else {
            wself.labelPosition = kFieldLabelPositionHidden;
        }
        
        [wself layoutPreview];
        
        [sender deselectAll];
        return selected;
    }];
    
    
    AIButtonGroup *groupTextAlignment __weak
    = [bar addButtonGroupWith:^(AIButtonGroup *group) {
        AIButtonSelectable *button;
        
        button = [group addButton];
        [self formatButton:button];
        [button setImage:[UIImage imageNamed:@"icon-text_align-left"] forState:UIControlStateNormal];
        
        button = [group addButton];
        [self formatButton:button];
        [button setImage:[UIImage imageNamed:@"icon-text_align-center"] forState:UIControlStateNormal];
        
        button = [group addButton];
        [self formatButton:button];
        [button setImage:[UIImage imageNamed:@"icon-text_align-right"] forState:UIControlStateNormal];
        
        // note that this doesn't work as expected on MacOS, since center and right alignments are switched
        // we'll ignore this since it goes beyond the purpose of this example
        [group setSelection:YES for:self.textAlignment];
    }];
    [self labelAlignmentRefresh:groupTextAlignment];
    
    [groupTextAlignment setButtonSelectionHandler:^BOOL(AIButtonGroup *sender, NSInteger index, BOOL selected)
     {
        // this implementation forces 1 selection at a time
        if (!selected) {
            // keep at least 1 button selected
            return YES;
        }
        
        wself.textAlignment = index;
        
        [sender deselectAll];
        return selected;
    }];
    
    [bar setupBorders];
    
    _scrollBar = bar;
    [self.view addSubview:_scrollBar];
}
- (void)formatButton:(AIButtonSelectable *)button {
    button.imageView.contentMode = UIViewContentModeCenter;
    button.adjustsImageWhenDisabled = NO;
    UIColor *color = [button currentTitleColor];
    if (!color) {
        color = UIColor.blueColor;
    }
    button.tintColor = color;
    button.backgroundColorSelected = [UIColor colorWithRed:0.5 green:0.7 blue:0.6 alpha:1];
    [button setTitleColor:UIColor.lightGrayColor forState:UIControlStateDisabled];
}


#pragma mark - state
- (void)labelPositionRefresh:(AIButtonGroup *)group {
    if (!group) {
        AIScrollBar *bar = _scrollBar;
        group = bar.buttonGroups[0];
    }
    [group deselectAll];
    if (_labelPosition != kFieldLabelPositionHidden) {
        [group setSelection:YES for:_labelPosition];
    }
    
    [group setEnabled:false forIndex:1]; // disable left position
}
- (void)labelAlignmentRefresh:(AIButtonGroup *)group {
    group.enabled = (_labelPosition != kFieldLabelPositionHidden);
}
- (NSTextAlignment)textAlignment {
    return _textField.textAlignment;
}
- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textField.textAlignment = textAlignment;
}


#pragma mark - layout
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect frame = _preview.frame;
    frame.size.width = self.view.bounds.size.width;
    frame.origin.y = 10;
    _preview.frame = frame;
    
    int nextY = CGRectGetMaxY(frame) + 20;
    frame = _scrollBar.frame;
    frame.size.width = self.view.bounds.size.width;
    frame.origin.y = nextY;
    _scrollBar.frame = frame;
    
    [self layoutPreview];
}
- (void)layoutPreview {
    _label.hidden = (_labelPosition == kFieldLabelPositionHidden);
    
    int textFieldHeight = 40;
    int sideMargin = 20;
    if (@available(iOS 11.0, *)) {
        sideMargin = MAX(MAX(self.view.safeAreaInsets.left, self.view.safeAreaInsets.right), sideMargin);
    }
    
    CGRect frame = CGRectZero;
    frame.origin.x = sideMargin;
    frame.size.width = self.view.bounds.size.width - sideMargin * 2;
    frame.size.height = 30;
    frame.origin.y = (_labelPosition == kFieldLabelPositionTop) ? 10 : textFieldHeight + 20;
    _label.frame = frame;
    
    frame.size.height = textFieldHeight;
    frame.origin.y = (_labelPosition == kFieldLabelPositionTop) ? (_label.frame.size.height + 10) : 10;
    _textField.frame = frame;
}
@end
