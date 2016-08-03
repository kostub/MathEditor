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

@property (nonatomic) MTKeyboard *currentKeyboard;
@property (nonatomic) MTKeyboard *tab1Keyboard;
@property (nonatomic) MTKeyboard *tab2Keyboard;
@property (nonatomic) MTKeyboard *tab3Keyboard;
@property (nonatomic) MTKeyboard *tab4Keyboard;
@property (nonatomic) NSInteger currentTab;
@property (nonatomic) NSArray<MTKeyboard*> *keyboards;

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
                button.backgroundColor = [UIColor whiteColor];
            }
        }
    }
    
    [self switchKeyboard:DEFAULT_KEYBOARD];
}

// To allow resetting of keyboard to the default tab when changing problems
-(void)switchToDefaultTab
{
    [self switchKeyboard:DEFAULT_KEYBOARD];
}

- (IBAction)switchTabs:(UIButton *)sender
{
    [self switchKeyboard:sender.tag];
}

-(void)greyTabButtons
{
    [_numbersTab setSelected:false];
    [_operationsTab setSelected:false];
    [_functionsTab setSelected:false];
    [_lettersTab setSelected:false];
}

-(void)switchKeyboard:(NSInteger)tabNumber
{
    [self greyTabButtons];
    
    switch (tabNumber) {
        case 0:
            [_numbersTab setSelected:true];
            break;
        case 1:
            [_operationsTab setSelected:true];
            break;
        case 2:
            [_functionsTab setSelected:true];
            break;
        case 3:
            [_lettersTab setSelected:true];
            break;
            
        default:
            break;
    }
    
    // check currently active keyboard by tabNumber, skip creation if tabNumber is already the active tab
    if (_currentTab != tabNumber) {
        _currentTab = tabNumber;
        // animate and hold reference to the correct keyboard depending on tabNumber
        [self assignAndAnimateKeyboard:tabNumber];
    }
}

-(void)assignAndAnimateKeyboard:(NSInteger)keyboardNumber
{
    MTKeyboard* newKeyboard = _keyboards[keyboardNumber];
    
    // animate creation
    // animate destruction
    newKeyboard.alpha = 0.5;
    _currentKeyboard.alpha = 1.0;
    [UIView animateWithDuration:0.1 animations:^{
        newKeyboard.alpha = 1.0;
        _currentKeyboard.alpha = 0.5;
    }];
    
    [_contentView bringSubviewToFront:newKeyboard];
    
    // Hold reference to this keyboard so it can be removed from superview
    _currentKeyboard = newKeyboard;
}

- (void)addFullSizeView:(UIView *)view to:(UIView*) parent
{
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(view);
    [parent addSubview:view];
    [parent addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:views]];
    [parent addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:views]];
}

#pragma mark - MTMathKeyboardTraits

- (void)setEqualsAllowed:(BOOL)equalsAllowed
{
    _equalsAllowed = equalsAllowed;
    for (MTKeyboard *keyboard in _keyboards) {
        [keyboard setEqualsState:equalsAllowed];
    }
}

- (void)setNumbersAllowed:(BOOL)numbersAllowed
{
    _numbersAllowed = numbersAllowed;
    for (MTKeyboard *keyboard in _keyboards) {
        [keyboard setNumbersState:numbersAllowed];
    }
}

- (void)setOperatorsAllowed:(BOOL)operatorsAllowed
{
    _operatorsAllowed = operatorsAllowed;
    for (MTKeyboard *keyboard in _keyboards) {
        [keyboard setOperatorState:operatorsAllowed];
    }
}

- (void)setVariablesAllowed:(BOOL)variablesAllowed
{
    _variablesAllowed = variablesAllowed;
    for (MTKeyboard *keyboard in _keyboards) {
        [keyboard setVariablesState:variablesAllowed];
    }
}

- (void)setExponentHighlighted:(BOOL)exponentHighlighted
{
    _exponentHighlighted = exponentHighlighted;
    for (MTKeyboard *keyboard in _keyboards) {
        [keyboard setExponentState:exponentHighlighted];
    }
}

- (void)setSquareRootHighlighted:(BOOL)squareRootHighlighted
{
    _squareRootHighlighted = squareRootHighlighted;
    for (MTKeyboard *keyboard in _keyboards) {
        [keyboard setSquareRootState:squareRootHighlighted];
    }
}

- (void)setRadicalHighlighted:(BOOL)radicalHighlighted
{
    _radicalHighlighted = radicalHighlighted;
    for (MTKeyboard *keyboard in _keyboards) {
        [keyboard setRadicalState:radicalHighlighted];
    }
}

- (void)startedEditing:(UIView<UIKeyInput> *)label
{
    for (MTKeyboard *keyboard in _keyboards) {
        keyboard.textView = label;
    }
}

- (void)finishedEditing:(UIView<UIKeyInput> *)label
{
    for (MTKeyboard *keyboard in _keyboards) {
        keyboard.textView = nil;
    }
}

@end


