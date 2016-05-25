//
//  MTViewController.h
//  iosMathEditor
//
//  Created by Kostub Deshmukh on 05/13/2016.
//  Copyright (C) 2016 Kostub Deshmukh
//   
//  This software may be modified and distributed under the terms of the
//  MIT license. See the LICENSE file for details.
//

@import UIKit;

#import "MTEditableMathLabel.h"

@interface MTViewController : UIViewController

@property (weak, nonatomic) IBOutlet MTEditableMathLabel *mathLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeight;

@end
