//
//  MTScrollingMathKeyboardRootView.m
//  Pods
//
//  Created by Serdar Karatekin on 8/2/16.
//
//

#import "MTScrollingMathKeyboardRootView.h"

static NSInteger const DEFAULT_KEYBOARD = 0;

@interface MTScrollingMathKeyboardRootView ()

@end

@implementation MTScrollingMathKeyboardRootView {
    
}

// Keyboard should be singleton
+(instancetype)sharedInstance {
    static MTScrollingMathKeyboardRootView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSBundle* bundle = [self getMathKeyboardResourcesBundle];
        instance = [bundle loadNibNamed:@"MTScrollingMathKeyboardRootView" owner:nil options:nil][0];
        
    });
    
    return instance;
}

// Gets the math keyboard resources bundle
+(NSBundle *)getMathKeyboardResourcesBundle
{
    return [NSBundle bundleWithURL:[[NSBundle bundleForClass:[self class]] URLForResource:@"MTKeyboardResources" withExtension:@"bundle"]];
}

-(void)awakeFromNib
{
    for (UIView *columnView in self.scrollView.subviews) {
        columnView.backgroundColor = [UIColor clearColor];
        
        for (UIView *buttonView in columnView.subviews) {
            if ([buttonView isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)buttonView;
                button.layer.cornerRadius = 5;                
            }
        }
    }
    
}

#pragma mark - MTMathKeyboardTraits

- (void)setEqualsAllowed:(BOOL)equalsAllowed
{
//    _equalsAllowed = equalsAllowed;
//    for (MTKeyboard *keyboard in _keyboards) {
//        [keyboard setEqualsState:equalsAllowed];
//    }
}

- (void)setNumbersAllowed:(BOOL)numbersAllowed
{
//    _numbersAllowed = numbersAllowed;
//    for (MTKeyboard *keyboard in _keyboards) {
//        [keyboard setNumbersState:numbersAllowed];
//    }
}

- (void)setOperatorsAllowed:(BOOL)operatorsAllowed
{
//    _operatorsAllowed = operatorsAllowed;
//    for (MTKeyboard *keyboard in _keyboards) {
//        [keyboard setOperatorState:operatorsAllowed];
//    }
}

- (void)setVariablesAllowed:(BOOL)variablesAllowed
{
//    _variablesAllowed = variablesAllowed;
//    for (MTKeyboard *keyboard in _keyboards) {
//        [keyboard setVariablesState:variablesAllowed];
//    }
}

- (void)setExponentHighlighted:(BOOL)exponentHighlighted
{
//    _exponentHighlighted = exponentHighlighted;
//    for (MTKeyboard *keyboard in _keyboards) {
//        [keyboard setExponentState:exponentHighlighted];
//    }
}

- (void)setSquareRootHighlighted:(BOOL)squareRootHighlighted
{
//    _squareRootHighlighted = squareRootHighlighted;
//    for (MTKeyboard *keyboard in _keyboards) {
//        [keyboard setSquareRootState:squareRootHighlighted];
//    }
}

- (void)setRadicalHighlighted:(BOOL)radicalHighlighted
{
//    _radicalHighlighted = radicalHighlighted;
//    for (MTKeyboard *keyboard in _keyboards) {
//        [keyboard setRadicalState:radicalHighlighted];
//    }
}

- (void)startedEditing:(UIView<UIKeyInput> *)label
{
//    for (MTKeyboard *keyboard in _keyboards) {
//        keyboard.textView = label;
//    }
}

- (void)finishedEditing:(UIView<UIKeyInput> *)label
{
//    for (MTKeyboard *keyboard in _keyboards) {
//        keyboard.textView = nil;
//    }
}

#pragma mark - IBActions

- (IBAction)keyPressed:(id)sender {
    
    [self playClickForCustomKeyTap];
    
    UIButton *button = sender;
    NSLog(@"keyPressed: tag %@", button.tag);
//    NSString* str = button.currentTitle;
//    [self.textView insertText:str];

}

#pragma mark - Helpers

- (void) playClickForCustomKeyTap
{
    [[UIDevice currentDevice] playInputClick];
}

@end


