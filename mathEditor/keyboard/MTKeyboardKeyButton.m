//
//  MTKeyboardKeyButton.m
//  Pods
//
//  Created by Jakub Dolecki on 8/8/16.
//
//

#import "MTKeyboardKeyButton.h"

// Grayish color for when button is highlighted
static UIColor *const kMTKeyboardKeyButtonHighlightedColor = [UIColor colorWithRed:80.f green:80.f blue:80.f alpha:1.f];
static UIColor *const kMTKeyboardKeyButtonDefaultColor = [UIColor whiteColor];

@implementation MTKeyboardKeyButton

-(void) setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted == YES) {
        [self setBackgroundColor:kMTKeyboardKeyButtonHighlightedColor];
    } else {
        [self setBackgroundColor:kMTKeyboardKeyButtonDefaultColor];
    }
}

@end
