//
//  MTScrollingMathKeyboardRootView.m
//  Pods
//
//  Created by Serdar Karatekin on 8/2/16.
//
//

#import "MTScrollingMathKeyboardRootView.h"
#import "MTFontManager.h"
#import "MTMathAtomFactory.h"

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
    self.textView = label;
}

- (void)finishedEditing:(UIView<UIKeyInput> *)label
{
    self.textView = nil;
}

#pragma mark - IBActions

- (IBAction)keyPressed:(id)sender {
    
    [self playClickForCustomKeyTap];
    
    UIButton *button = sender;
    NSLog(@"keyPressed: tag %tu", button.tag);
    
    int buttonTag = button.tag - 100;
    [self handleButtonClick:buttonTag];

//    NSString* str = button.currentTitle;
//    [self.textView insertText:str];

}

- (void)handleButtonClick:(int )tag {
    
    switch (tag) {
        case 0:
            [self.textView insertText:@"x"];
            break;
        case 1:
            [self.textView insertText:@"y"];
            break;
        case 2:
            [self.textView insertText:@"z"];
            break;
        case 3:
            [self.textView insertText:@","];
            break;
        case 4:
            [self.textView insertText:@"7"];
            break;
        case 5:
            [self.textView insertText:@"4"];
            break;
        case 6:
            [self.textView insertText:@"1"];
            break;
        case 7:
            [self.textView insertText:@"."];
            break;
        case 8:
            [self.textView insertText:@"8"];
            break;
        case 9:
            [self.textView insertText:@"5"];
            break;
        case 10:
            [self.textView insertText:@"2"];
            break;
        case 11:
            [self.textView insertText:@"0"];
            break;
        case 12:
            [self.textView insertText:@"9"];
            break;
        case 13:
            [self.textView insertText:@"6"];
            break;
        case 14:
            [self.textView insertText:@"3"];
            break;
        case 15:
            [self.textView insertText:@"="];
            break;
        case 16:
            [self.textView insertText:@"("];
            break;
        case 17:
            [self.textView insertText:@"^"];
            break;
        case 18:
            [self.textView insertText:MTSymbolFractionSlash];
            break;
        case 19:
            //
            break;
        case 20:
            //
            break;
        case 21:
            //
            break;
        case 22:
            //
            break;
        case 23:
            //
            break;
        case 24:
            //
            break;
        case 25:
            //
            break;
        case 26:
            //
            break;
        case 27:
            //
            break;
        case 28:
            //
            break;
        case 29:
            //
            break;
        case 30:
            //
            break;
        case 31:
            //
            break;
        case 32:
            //
            break;
        case 33:
            //
            break;
        case 34:
            //
            break;
        case 35:
            //
            break;
        case 36:
            //
            break;
        case 37:
            //
            break;
        case 38:
            //
            break;
        case 39:
            //
            break;
        case 40:
            //
            break;
        case 41:
            //
            break;
        case 42:
            //
            break;
        case 43:
            //
            break;
        case 44:
            //
            break;
        case 45:
            //
            break;
        case 46:
            //
            break;
        case 47:
            //
            break;
        case 48:
            //
            break;
        case 49:
            //
            break;
        case 50:
            //
            break;
        case 51:
            //
            break;
        case 52:
            //
            break;
        case 53:
            //
            break;
        case 54:
            //
            break;
        case 55:
            //
            break;
        case 56:
            //
            break;
        default:
            NSLog(@"Unhandled button click");
            break;
    }
}

- (IBAction)searchButtonTapped:(id)sender {
    NSLog(@"Search button tapped");
    [self.textView insertText:@"\n"];
}

- (IBAction)deleteButtonTapped:(id)sender {
    NSLog(@"Delete button tapped");
    [self.textView deleteBackward];
}

- (IBAction)clearButtonTapped:(id)sender {
    NSLog(@"Clear button tapped");
    // TODO: Add clear label functionality
}

#pragma mark - Helpers

- (void) playClickForCustomKeyTap
{
    [[UIDevice currentDevice] playInputClick];
}

@end


