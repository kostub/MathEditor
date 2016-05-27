//
//  MTDisplay+Editing.h
//
//  Created by Kostub Deshmukh on 9/6/13.
//  Copyright (C) 2013 MathChat
//   
//  This software may be modified and distributed under the terms of the
//  MIT license. See the LICENSE file for details.
//

#import "MTMathListDisplay.h"
#import "MTMathListIndex.h"

@interface MTDisplay (Editing)

// Find the index in the mathlist before which a new character should be inserted. Returns nil if it cannot find the index.
- (MTMathListIndex*) closestIndexToPoint:(CGPoint) point;

// The bounds of the display indicated by the given index
- (CGPoint) caretPositionForIndex:(MTMathListIndex*) index;

// Highlight the character(s) at the given index.
- (void) highlightCharacterAtIndex:(MTMathListIndex*) index color:(UIColor*) color;

// Highlight the entire display with the given color
- (void) highlightWithColor:(UIColor*) color;

@end

