//
//  ViewController.h
//  ObjcExample
//
//  Created by Ifrim Alexandru on 3/20/21.
//

#import <UIKit/UIKit.h>
@import AIScrollBar;

typedef NS_ENUM(NSUInteger, kFieldLabelPosition) {
    kFieldLabelPositionTop = 0,
    kFieldLabelPositionLeft = 1,
    kFieldLabelPositionBottom = 2,
    kFieldLabelPositionHidden = 3
};

@interface ViewController : UIViewController {
    UILabel                     *_label;
    UITextField                 *_textField;
    UIView                      *_preview;
    
    AIScrollBar                 *_scrollBar;
    kFieldLabelPosition         _labelPosition;
}

@property(nonatomic, assign)    kFieldLabelPosition             labelPosition;
@property(nonatomic, assign)    NSTextAlignment                 textAlignment;
@end

