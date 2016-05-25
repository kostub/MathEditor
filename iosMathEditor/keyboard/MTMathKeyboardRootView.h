//
//  MCMathKeyboardRootView.h
//  MathChat
//
//  Created by MARIO ANDHIKA on 7/16/15.
//  Copyright (c) 2015 MathChat, Inc.
//
//  This software may be modified and distributed under the terms of the
//  MIT license. See the LICENSE file for details.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MTKeyboard.h"
#import "MTEditableMathLabel.h"

@interface MTMathKeyboardRootView : UIView

- (IBAction)switchTabs:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *numbersTab;
@property (weak, nonatomic) IBOutlet UIButton *lettersTab;
@property (weak, nonatomic) IBOutlet UIButton *functionsTab;
@property (weak, nonatomic) IBOutlet UIButton *operationsTab;

- (void)switchToDefaultTab;
//- (void) setKeyboardContext:(KeyboardContext*) context;
- (void) setEditableMathLabel:(MTEditableMathLabel*) textView;

+(MTMathKeyboardRootView *)sharedInstance;


@end
