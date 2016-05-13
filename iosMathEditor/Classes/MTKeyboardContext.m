//
//  KeyboardContext.m
//
//  Created by Kostub Deshmukh on 10/9/13.
//  Copyright (C) 2013 MathChat
//   
//  This software may be modified and distributed under the terms of the
//  MIT license. See the LICENSE file for details.
//

#import "MTKeyboardContext.h"

@implementation MTKeyboardContext

- (id)init
{
    self = [super init];
    if (self) {
        // everything is true by default
        _operatorsAllowed = true;
        _equalsAllowed = true;
        _numbersAllowed = true;
        _variablesAllowed = true;
        _fractionsAllowed = true;
        _exponentHighlighted = false;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    MTKeyboardContext* new = [[[self class] allocWithZone:zone] init];
    new.operatorsAllowed = self.operatorsAllowed;
    new.equalsAllowed = self.equalsAllowed;
    new.variablesAllowed = self.variablesAllowed;
    new.fractionsAllowed = self.fractionsAllowed;
    new.numbersAllowed = self.numbersAllowed;
    new.exponentHighlighted = self.exponentHighlighted;
    return new;
}

@end
