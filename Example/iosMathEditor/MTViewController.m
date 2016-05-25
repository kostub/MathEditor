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

@interface MTViewController () <MTEditableMathLabelDelegate>

@end

@implementation MTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mathLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.mathLabel.layer.borderWidth = 2;
    self.mathLabel.layer.cornerRadius = 5;
    self.mathLabel.keyboard = [MTMathKeyboardRootView sharedInstance];
    self.mathLabel.delegate = self;
    [self.mathLabel enableTap:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark MTEditableMathLabelDelegate

@end
