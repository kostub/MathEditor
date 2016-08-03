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
            [self.textView insertText:@"÷"];
            break;
        case 17:
            [self.textView insertText:@"×"];
            break;
        case 18:
            [self.textView insertText:@"+"];
            break;
        case 19:
            [self.textView insertText:@"-"];
            break;
        case 20:
            [self.textView insertText:@"("];
            break;
        case 21:
            [self.textView insertText:@"^"];
            break;
        case 22:
            [self.textView insertText:MTSymbolFractionSlash];
            break;
        case 23:
            [self.textView insertText:MTSymbolSquareRoot];
            break;
        case 24:
            [self.textView insertText:@")"];
            break;
        case 25:
            [self.textView insertText:@"_"];
            break;
        case 26:
            [self.textView insertText:@"||"];
            break;
        case 27:
            [self.textView insertText:MTSymbolCubeRoot];
            break;
        case 28:
            [self.textView insertText:@"["];
            break;
        case 29:
            [self.textView insertText:@"{"];
            break;
        case 30:
            [self.textView insertText:@">"];
            break;
        case 31:
            [self.textView insertText:@"≥"];
            break;
        case 32:
            [self.textView insertText:@"]"];
            break;
        case 33:
            [self.textView insertText:@"}"];
            break;
        case 34:
            [self.textView insertText:@"<"];
            break;
        case 35:
            [self.textView insertText:@"≤"];
            break;
        case 36:
            [self.textView insertText:@"sin"];
            break;
        case 37:
            [self.textView insertText:@"csc"];
            break;
        case 38:
            [self.textView insertText:@"π"];
            break;
        case 39:
            [self.textView insertText:@"°"];
            break;
        case 40:
            [self.textView insertText:@"cos"];
            break;
        case 41:
            [self.textView insertText:@"sec"];
            break;
        case 42:
            [self.textView insertText:@"θ"];
            break;
        case 43:
            [self.textView insertText:@"∠"];
            break;
        case 44:
            [self.textView insertText:@"tan"];
            break;
        case 45:
            [self.textView insertText:@"cot"];
            break;
        case 46:
            //
            break;
        case 47:
            //
            break;
        case 48:
            [self.textView insertText:@"e"];
            break;
        case 49:
            [self.textView insertText:@"log"];
            break;
        case 50:
            //
            break;
        case 51:
            //
            break;
        case 52:
            [self.textView insertText:@"ln"];
            break;
        case 53:
            [self.textView insertText:@"log"];
            [self.textView insertText:@"_"];
            break;
        case 54:
            //
            break;
        case 55:
            //
            break;
        default:
            NSLog(@"Unsupport button tag click");
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


