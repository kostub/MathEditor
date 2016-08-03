//
//  MTViewController.m
//  iosMathEditor
//
//  Created by Kostub Deshmukh on 05/13/2016.
//  Copyright (C) 2016 Kostub Deshmukh
//   
//  This software may be modified and distributed under the terms of the
//  MIT license. See the LICENSE file for details.
//

#import "MTViewController.h"
#import "MTMathKeyboardRootView.h"
#import "MTScrollingMathKeyboardRootView.h"

@interface MTViewController () <MTEditableMathLabelDelegate>

@end

@implementation MTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mathLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.mathLabel.layer.borderWidth = 2;
    self.mathLabel.layer.cornerRadius = 5;
    self.mathLabel.textColor = [UIColor blackColor];
    self.mathLabel.textAlignment = kMTTextAlignmentCenter;
    self.mathLabel.keyboard = [MTScrollingMathKeyboardRootView sharedInstance];
//    self.mathLabel.keyboard = [MTMathKeyboardRootView sharedInstance];
    self.mathLabel.delegate = self;
    [self.mathLabel enableTap:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark MTEditableMathLabelDelegate

- (void)textModified:(MTEditableMathLabel *)label
{
    CGFloat minHeight = 64;
    // Increase the height of the label as the height increases.
    CGSize mathSize = label.mathDisplaySize;
    if (mathSize.height > self.labelHeight.constant - 10) {
        [label layoutIfNeeded];
        // animate
        [UIView animateWithDuration:0.5 animations:^{
            self.labelHeight.constant = mathSize.height + 10;
            [label layoutIfNeeded];
        }];
    } else if (mathSize.height < self.labelHeight.constant - 20) {
        CGFloat newHeight = MAX(mathSize.height + 10, minHeight);
        if (newHeight < self.labelHeight.constant) {
            [label layoutIfNeeded];
            // animate
            [UIView animateWithDuration:0.5 animations:^{
                self.labelHeight.constant = newHeight;
                [label layoutIfNeeded];
            }];
        }
    }

    // Shrink the font as the label gets longer.
    if (mathSize.width > label.frame.size.width - 10) {
        label.fontSize = label.fontSize * 0.9;

    } else if (mathSize.width < label.frame.size.width - 40) {
        CGFloat fontSize = MIN(label.fontSize * 1.1, 30);
        if (fontSize > label.fontSize) {
            label.fontSize = fontSize;
        }
    }
}

- (void)didBeginEditing:(MTEditableMathLabel *)label
{
    self.placeholderLabel.hidden = YES;
}

@end
