//
//  MTKeyboardKeyButton.m
//  Pods
//
//  Created by Jakub Dolecki on 8/8/16.
//
//

#import "MTKeyboardKeyButton.h"

@implementation MTKeyboardKeyButton

-(void) setHighlighted:(BOOL)highlighted {
    
    // Grayish color for when button is highlighted
    UIColor *kMTKeyboardKeyButtonHighlightedColor = [UIColor colorWithRed:80.f green:80.f blue:80.f alpha:1.f];
    UIColor *kMTKeyboardKeyButtonDefaultColor = [UIColor whiteColor];
    
    [super setHighlighted:highlighted];
    
    if (highlighted == YES) {
        [self setBackgroundColor:kMTKeyboardKeyButtonHighlightedColor];
    } else {
        [self setBackgroundColor:kMTKeyboardKeyButtonDefaultColor];
    }
}

@end
