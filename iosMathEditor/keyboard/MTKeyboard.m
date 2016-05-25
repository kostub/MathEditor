//
//  MCKeyboard.m
//
//  Created by Kostub Deshmukh on 8/21/13.
//  Copyright (C) 2013 MathChat
//
//  This software may be modified and distributed under the terms of the
//  MIT license. See the LICENSE file for details.
//

#import "MTKeyboard.h"
#import "MTFontManager.h"
#import "MTMathAtomFactory.h"
#import "EventLogger.h"

@interface MTKeyboard ()

@property BOOL isLowerCase;

@end

@implementation MTKeyboard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Get the font Latin Modern Roman - Bold Italic included in
- (NSString*) registerAndGetFontName
{
    static NSString* fontName = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        
        NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"MathKeyboardResources" withExtension:@"bundle"]];
        NSString* fontPath = [bundle pathForResource:@"lmroman10-bolditalic" ofType:@"otf"];
        CGDataProviderRef fontDataProvider = CGDataProviderCreateWithFilename([fontPath UTF8String]);
        CGFontRef myFont = CGFontCreateWithDataProvider(fontDataProvider);
        CFRelease(fontDataProvider);

        fontName = (__bridge_transfer NSString*) CGFontCopyPostScriptName(myFont);
        CFErrorRef error = NULL;
        CTFontManagerRegisterGraphicsFont(myFont, &error);
        if (error) {
            NSString* errorDescription = (__bridge_transfer NSString*)CFErrorCopyDescription(error);
            InfoLog(@"Error registering font: %@", errorDescription);
            CFRelease(error);
        }
        CGFontRelease(myFont);
        InfoLog(@"Registered fontName: %@", fontName);
    });
    return fontName;
}

- (void)awakeFromNib
{
    // Initialization code
    NSString* fontName = [self registerAndGetFontName];
    for (UIButton* varButton in self.variables) {
        varButton.titleLabel.font = [UIFont fontWithName:fontName size:varButton.titleLabel.font.pointSize];
    }

    self.isLowerCase = true;
}


- (void)keyPressed:(id)sender
{
    [self playClickForCustomKeyTap];
    
    UIButton *button = sender;
    NSString* str = button.currentTitle;
    [self.textView insertText:str];
    [EventLogger logGAEvent:@"KeyPress" label:str];
}

- (void)enterPressed:(id)sender
{
    [self playClickForCustomKeyTap];
    [EventLogger logGAEvent:@"KeyPress" label:@"Enter"];
    [self.textView insertText:@"\n"];
}

- (void)backspacePressed:(id)sender
{
    [self playClickForCustomKeyTap];
    
    [EventLogger logGAEvent:@"KeyPress" label:@"delete"];
    [self.textView deleteBackward];
}

- (void)dismissPressed:(id)sender
{
    [self playClickForCustomKeyTap];
    [EventLogger logGAEvent:@"KeyPress" label:@"Dismiss"];
    [self.textView resignFirstResponder];
}

- (IBAction)absValuePressed:(id)sender
{
    [self.textView insertText:@"||"];
    [EventLogger logGAEvent:@"KeyPress" label:@"Abs"];
}

- (BOOL)enableInputClicksWhenVisible
{
    return YES;
}

- (void) playClickForCustomKeyTap
{
    [[UIDevice currentDevice] playInputClick];
}

- (void)fractionPressed:(id)sender
{
    [self playClickForCustomKeyTap];
    [self.textView insertText:MTSymbolFractionSlash];
    [EventLogger logGAEvent:@"KeyPress" label:@"frac"];
}

- (IBAction)exponentPressed:(id)sender
{
    [self playClickForCustomKeyTap];
    [self.textView insertText:@"^"];
    [EventLogger logGAEvent:@"KeyPress" label:@"exp"];
}

- (IBAction)subscriptPressed:(id)sender
{
    [self playClickForCustomKeyTap];
    [self.textView insertText:@"_"];
    [EventLogger logGAEvent:@"KeyPress" label:@"subsc"];
}

- (IBAction)parensPressed:(id)sender
{
    [self playClickForCustomKeyTap];
    [self.textView insertText:@"()"];
    [EventLogger logGAEvent:@"KeyPress" label:@"paren"];
}

- (IBAction)squareRootPressed:(id)sender
{
    [self playClickForCustomKeyTap];
    [self.textView insertText:MTSymbolSquareRoot];

    [EventLogger logGAEvent:@"KeyPress" label:@"sqrt"];
}

- (IBAction)rootWithPowerPressed:(id)sender {
    [self playClickForCustomKeyTap];
    [self.textView insertText:MTSymbolCubeRoot];
    [EventLogger logGAEvent:@"KeyPress" label:@"rad"];
}

- (IBAction)logWithBasePressed:(id)sender {
    [self playClickForCustomKeyTap];
    [self.textView insertText:@"log"];
    [self.textView insertText:@"_"];
    [EventLogger logGAEvent:@"KeyPress" label:@"log_"];
}

- (IBAction)shiftPressed:(id)sender
{
    // If currently uppercase, shift down
    // else, shift up
    if (_isLowerCase) {
        [self shiftUpKeyboard];
    } else {
        [self shiftDownKeyboard];
    }
    [EventLogger logGAEvent:@"KeyPress" label:@"shift"];
}

#pragma mark - Keyboard Context


- (void) shiftDownKeyboard
{
    // Replace button titles to lowercase
    for (UIButton* button in self.letters) {
        NSString* newTitle = [button.titleLabel.text lowercaseString]; // get lowercase version of button title
        [button setTitle:newTitle forState:UIControlStateNormal];
    }
    
    // Replace greek letters
    [_alphaRho setTitle:@"α" forState:UIControlStateNormal];
    [_deltaOmega setTitle:@"Δ" forState:UIControlStateNormal];
    [_sigmaPhi setTitle:@"σ" forState:UIControlStateNormal];
    [_muNu setTitle:@"μ" forState:UIControlStateNormal];
    [_lambdaBeta setTitle:@"λ" forState:UIControlStateNormal];
    
    _isLowerCase = true;
}

- (void) shiftUpKeyboard
{
    // Replace button titles to uppercase
    for (UIButton* button in self.letters) {
        NSString* newTitle = [button.titleLabel.text uppercaseString]; // get uppercase version of button title
        [button setTitle:newTitle forState:UIControlStateNormal];
    }
    
    // Replace greek letters
    [_alphaRho setTitle:@"ρ" forState:UIControlStateNormal];
    [_deltaOmega setTitle:@"ω" forState:UIControlStateNormal];
    [_sigmaPhi setTitle:@"Φ" forState:UIControlStateNormal];
    [_muNu setTitle:@"ν" forState:UIControlStateNormal];
    [_lambdaBeta setTitle:@"β" forState:UIControlStateNormal];
    
    _isLowerCase = false;
}

- (void)setNumbersState:(BOOL)enabled
{
    for (UIButton* button in self.numbers) {
        button.enabled = enabled;
    }
}

- (void) setOperatorState:(BOOL)enabled
{
    for (UIButton* button in self.operators) {
        button.enabled = enabled;
    }
}

- (void)setVariablesState:(BOOL)enabled
{
    for (UIButton* button in self.variables) {
        button.enabled = enabled;
    }
}

- (void)setFractionState:(BOOL)enabled
{
    self.fractionButton.enabled = enabled;
}

- (void) setEqualsState:(BOOL)enabled
{
    self.equalsButton.enabled = enabled;
}

- (void) setExponentState:(BOOL) highlighted
{
    self.exponentButton.selected = highlighted;
}

- (void) setSquareRootState:(BOOL) highlighted
{
    self.squareRootButton.selected = highlighted;
}

- (void) setRadicalState:(BOOL) highlighted
{
    self.radicalButton.selected = highlighted;
}

- (void)setKeyboardContext:(KeyboardContext *)context
{
    [self setNumbersState:context.numbersAllowed];
    [self setOperatorState:context.operatorsAllowed];
    [self setVariablesState:context.variablesAllowed];
    [self setFractionState:context.fractionsAllowed];
    [self setEqualsState:context.equalsAllowed];
    [self setExponentState:context.exponentHighlighted];
    [self setSquareRootState:context.squareRootHighlighted];
    [self setRadicalState:context.radicalHighlighted];
}

// Prevent touches from being propagated to super view.
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
@end
