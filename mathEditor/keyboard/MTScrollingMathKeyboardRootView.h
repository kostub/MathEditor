//
//  MTScrollingMathKeyboardRootView.h
//  Pods
//
//  Created by Serdar Karatekin on 8/2/16.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MTKeyboard.h"
#import "MTEditableMathLabel.h"

@interface MTScrollingMathKeyboardRootView : UIView<MTMathKeyboard>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)switchTabs:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *numbersTab;
@property (weak, nonatomic) IBOutlet UIButton *lettersTab;
@property (weak, nonatomic) IBOutlet UIButton *functionsTab;
@property (weak, nonatomic) IBOutlet UIButton *operationsTab;

- (void) switchToDefaultTab;

+ (MTScrollingMathKeyboardRootView *)sharedInstance;

/// The keyboard resources bundle.
+ (NSBundle *)getMathKeyboardResourcesBundle;

#pragma mark - MTMathKeyboardTraits

@property (nonatomic) BOOL equalsAllowed;
@property (nonatomic) BOOL fractionsAllowed;
@property (nonatomic) BOOL variablesAllowed;
@property (nonatomic) BOOL numbersAllowed;
@property (nonatomic) BOOL operatorsAllowed;
@property (nonatomic) BOOL exponentHighlighted;
@property (nonatomic) BOOL squareRootHighlighted;
@property (nonatomic) BOOL radicalHighlighted;

@end
