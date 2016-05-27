//
//  MTMathList+Editing.h
//
//  Created by Kostub Deshmukh on 9/5/13.
//  Copyright (C) 2013 MathChat
//   
//  This software may be modified and distributed under the terms of the
//  MIT license. See the LICENSE file for details.
//

#import "MTMathList.h"
#import "MTMathListIndex.h"

@interface MTMathList (Editing)

- (void) insertAtom:(MTMathAtom *)atom atListIndex:(MTMathListIndex*) index;

- (void) removeAtomAtListIndex:(MTMathListIndex *)index;

- (void) removeAtomsInListIndexRange:(MTMathListRange*) range;

// Get the atom at the given index. If there is none, or index is invalid returns nil.
- (MTMathAtom*) atomAtListIndex:(MTMathListIndex*) index;


@end
