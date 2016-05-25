//
//  MCKeyboard.h
//
//  Created by Kostub Deshmukh on 8/21/13.
//  Copyright (C) 2013 MathChat
//
//  This software may be modified and distributed under the terms of the
//  MIT license. See the LICENSE file for details.
//

#import <UIKit/UIKit.h>
#import "MTEditableMathLabel.h"

@interface MTKeyboard : UIView <UIInputViewAudioFeedback>


@property (weak, nonatomic) IBOutlet UIButton *fractionButton;
@property (nonatomic, weak) IBOutlet UIButton *multiplyButton;
@property (nonatomic, weak) IBOutlet UIButton *equalsButton;
@property (nonatomic, weak) IBOutlet UIButton *divisionButton;
@property (weak, nonatomic) IBOutlet UIButton *exponentButton;
@property (weak, nonatomic) IBOutlet UIButton *lessEqualsButton;
@property (weak, nonatomic) IBOutlet UIButton *greaterEqualsButton;
@property (weak, nonatomic) IBOutlet UIButton *shiftButton;
@property (weak, nonatomic) IBOutlet UIButton *squareRootButton;
@property (weak, nonatomic) IBOutlet UIButton *radicalButton;

@property (nonatomic, weak) MTEditableMathLabel *textView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *numbers;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *variables;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *operators;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *relations;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *letters;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *greekLetters;

@property (weak, nonatomic) IBOutlet UIButton *alphaRho;
@property (weak, nonatomic) IBOutlet UIButton *deltaOmega;
@property (weak, nonatomic) IBOutlet UIButton *sigmaPhi;
@property (weak, nonatomic) IBOutlet UIButton *muNu;
@property (weak, nonatomic) IBOutlet UIButton *lambdaBeta;

- (IBAction) keyPressed:(id)sender;
- (IBAction) backspacePressed:(id)sender;
- (IBAction) enterPressed:(id)sender;
- (IBAction) dismissPressed:(id)sender;
- (IBAction) fractionPressed:(id)sender;
- (IBAction) exponentPressed:(id)sender;
- (IBAction) parensPressed:(id)sender;
- (IBAction) subscriptPressed:(id)sender;
- (IBAction)absValuePressed:(id)sender;
- (IBAction)shiftPressed:(id)sender;
- (IBAction)squareRootPressed:(id)sender;
- (IBAction)logWithBasePressed:(id)sender;


@end
