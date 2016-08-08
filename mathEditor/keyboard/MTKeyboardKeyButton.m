//
//  MTKeyboardKeyButton.m
//  Pods
//
//  Created by Jakub Dolecki on 8/8/16.
//
//

#import "MTKeyboardKeyButton.h"

@implementation MTKeyboardKeyButton

/** Overwrites UIButton's setHighlighted to add a highlight color when user highlights the button
 */
-(void) setHighlighted:(BOOL)highlighted {
    
    // Grayish color for when button is highlighted
    UIColor *kMTKeyboardKeyButtonHighlightedColor = [UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1.f];
    UIColor *kMTKeyboardKeyButtonDefaultColor = [UIColor whiteColor];
    
    [super setHighlighted:highlighted];
    
    if (highlighted == YES) {
        [self setBackgroundColor:kMTKeyboardKeyButtonHighlightedColor];
    } else {
        [self setBackgroundColor:kMTKeyboardKeyButtonDefaultColor];
    }
}

@end
