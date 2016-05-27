//
//  MTMathList+Editing.m
//
//  Created by Kostub Deshmukh on 9/5/13.
//  Copyright (C) 2013 MathChat
//   
//  This software may be modified and distributed under the terms of the
//  MIT license. See the LICENSE file for details.
//

#import "MTMathList+Editing.h"

#pragma mark - MTMathList

@implementation MTMathList (Editing)

- (void)insertAtom:(MTMathAtom *)atom atListIndex:(MTMathListIndex *)index
{
    if (index.atomIndex > self.atoms.count) {
        @throw [NSException exceptionWithName:NSRangeException
                                       reason:[NSString stringWithFormat:@"Index %lu is out of bounds for list of size %lu", (unsigned long)index.atomIndex, (unsigned long)self.atoms.count]
                                     userInfo:nil];
    }
    
    switch (index.subIndexType) {
        case kMTSubIndexTypeNone:
            [self insertAtom:atom atIndex:index.atomIndex];
            break;
            
        case kMTSubIndexTypeNucleus: {
            MTMathAtom* currentAtom = [self.atoms objectAtIndex:index.atomIndex];
            NSAssert(currentAtom.subScript || currentAtom.superScript, @"Nuclear fusion is not supported if there are no subscripts or superscripts.");        
            NSAssert(!atom.subScript && !atom.superScript, @"Cannot fuse with an atom that already has a subscript or a superscript");

            atom.subScript = currentAtom.subScript;
            atom.superScript = currentAtom.superScript;
            currentAtom.subScript = nil;
            currentAtom.superScript = nil;
            [self insertAtom:atom atIndex:index.atomIndex + index.subIndex.atomIndex];
            break;
        }

        case kMTSubIndexTypeDegree:
        case kMTSubIndexTypeRadicand: {
            MTRadical *radical = [self.atoms objectAtIndex:index.atomIndex];
            if (!radical || radical.type != kMTMathAtomRadical) {
                // Not radical, quit
                NSAssert(false, @"No radical found at index %lu", (unsigned long)index.atomIndex);
                return;
            }
            if (index.subIndexType == kMTSubIndexTypeDegree) {
                [radical.degree insertAtom:atom atListIndex:index.subIndex];
            } else {
                [radical.radicand insertAtom:atom atListIndex:index.subIndex];
            }
            break;
        }
            
        case kMTSubIndexTypeDenominator:
        case kMTSubIndexTypeNumerator: {
            MTFraction* frac = [self.atoms objectAtIndex:index.atomIndex];
            if (!frac || frac.type != kMTMathAtomFraction) {
                NSAssert(false, @"No fraction found at index %lu", (unsigned long)index.atomIndex);
                return;
            }
            if (index.subIndexType == kMTSubIndexTypeNumerator) {
                [frac.numerator insertAtom:atom atListIndex:index.subIndex];
            } else {
                [frac.denominator insertAtom:atom atListIndex:index.subIndex];
            }
            break;
        }
            
        case kMTSubIndexTypeSubscript: {
            MTMathAtom* current = [self.atoms objectAtIndex:index.atomIndex];
            NSAssert(current.subScript, @"No subscript for atom at index %lu", (unsigned long)index.atomIndex);
            [current.subScript insertAtom:atom atListIndex:index.subIndex];
            break;
        }
            
        case kMTSubIndexTypeSuperscript: {
            MTMathAtom* current = [self.atoms objectAtIndex:index.atomIndex];
            NSAssert(current.superScript, @"No superscript for atom at index %lu", (unsigned long)index.atomIndex);
            [current.superScript insertAtom:atom atListIndex:index.subIndex];
            break;
        }
    }
}

-(void)removeAtomAtListIndex:(MTMathListIndex *)index
{
    if (index.atomIndex >= self.atoms.count) {
        @throw [NSException exceptionWithName:NSRangeException
                                       reason:[NSString stringWithFormat:@"Index %lu is out of bounds for list of size %lu", (unsigned long)index.atomIndex, (unsigned long)self.atoms.count]
                                     userInfo:nil];
    }
    
    switch (index.subIndexType) {
        case kMTSubIndexTypeNone:
            [self removeAtomAtIndex:index.atomIndex];
            break;
            
        case kMTSubIndexTypeNucleus: {
            MTMathAtom* currentAtom = [self.atoms objectAtIndex:index.atomIndex];
            NSAssert(currentAtom.subScript || currentAtom.superScript, @"Nuclear fission is not supported if there are no subscripts or superscripts.");
            MTMathAtom* previous = nil;
            if (index.atomIndex > 0) {
                previous = [self.atoms objectAtIndex:index.atomIndex - 1];
            }
            if (previous && !previous.subScript && !previous.superScript) {
                previous.superScript = currentAtom.superScript;
                previous.subScript = currentAtom.subScript;
                [self removeAtomAtIndex:index.atomIndex];
            } else {
                // no previous atom or the previous atom sucks (has sub/super scripts)
                currentAtom.nucleus = @"";
            }
            break;
        }

        case kMTSubIndexTypeRadicand:
        case kMTSubIndexTypeDegree: {
            MTRadical *radical = [self.atoms objectAtIndex:index.atomIndex];
            if (!radical || radical.type != kMTMathAtomRadical) {
                // Not radical, quit
                NSAssert(false, @"No radical found at index %lu", (unsigned long)index.atomIndex);
                return;
            }
            if (index.subIndexType == kMTSubIndexTypeDegree) {
                [radical.degree removeAtomAtListIndex:index.subIndex];
            } else {
                [radical.radicand removeAtomAtListIndex:index.subIndex];
            }

            break;
        }

        case kMTSubIndexTypeDenominator:
        case kMTSubIndexTypeNumerator: {
            MTFraction* frac = [self.atoms objectAtIndex:index.atomIndex];
            if (!frac || frac.type != kMTMathAtomFraction) {
                NSAssert(false, @"No fraction found at index %lu", (unsigned long)index.atomIndex);
                return;
            }
            if (index.subIndexType == kMTSubIndexTypeNumerator) {
                [frac.numerator removeAtomAtListIndex:index.subIndex];
            } else {
                [frac.denominator removeAtomAtListIndex:index.subIndex];
            }
            break;
        }
            
        case kMTSubIndexTypeSubscript: {
            MTMathAtom* current = [self.atoms objectAtIndex:index.atomIndex];
            NSAssert(current.subScript, @"No subscript for atom at index %lu", (unsigned long)index.atomIndex);
            [current.subScript removeAtomAtListIndex:index.subIndex];
            break;
        }
            
        case kMTSubIndexTypeSuperscript: {
            MTMathAtom* current = [self.atoms objectAtIndex:index.atomIndex];
            NSAssert(current.superScript, @"No superscript for atom at index %lu", (unsigned long)index.atomIndex);
            [current.superScript removeAtomAtListIndex:index.subIndex];
            break;
        }
    }
}

- (void) removeAtomsInListIndexRange:(MTMathListRange*) range
{
    MTMathListIndex* start = range.start;
    
    switch (start.subIndexType) {
        case kMTSubIndexTypeNone:
            [self removeAtomsInRange:NSMakeRange(start.atomIndex, range.length)];
            break;
            
        case kMTSubIndexTypeNucleus:
            NSAssert(false, @"Nuclear fission is not supported");
            break;

        case kMTSubIndexTypeRadicand:
        case kMTSubIndexTypeDegree: {
            MTRadical *radical = [self.atoms objectAtIndex:start.atomIndex];
            if (!radical || radical.type != kMTMathAtomRadical) {
                // Not radical, quit
                NSAssert(false, @"No radical found at index %lu", (unsigned long)start.atomIndex);
                return;
            }
            if (start.subIndexType == kMTSubIndexTypeDegree) {
                [radical.degree removeAtomsInListIndexRange:range.subIndexRange];
            } else {
                [radical.radicand removeAtomsInListIndexRange:range.subIndexRange];
            }
            break;
        }

        case kMTSubIndexTypeDenominator:
        case kMTSubIndexTypeNumerator: {
            MTFraction* frac = [self.atoms objectAtIndex:start.atomIndex];
            if (!frac || frac.type != kMTMathAtomFraction) {
                NSAssert(false, @"No fraction found at index %lu", (unsigned long)start.atomIndex);
                return;
            }
            if (start.subIndexType == kMTSubIndexTypeNumerator) {
                [frac.numerator removeAtomsInListIndexRange:range.subIndexRange];
            } else {
                [frac.denominator removeAtomsInListIndexRange:range.subIndexRange];
            }
            break;
        }
            
        case kMTSubIndexTypeSubscript: {
            MTMathAtom* current = [self.atoms objectAtIndex:start.atomIndex];
            NSAssert(current.subScript, @"No subscript for atom at index %lu", (unsigned long)start.atomIndex);
            [current.subScript removeAtomsInListIndexRange:range.subIndexRange];
            break;
        }
            
        case kMTSubIndexTypeSuperscript: {
            MTMathAtom* current = [self.atoms objectAtIndex:start.atomIndex];
            NSAssert(current.superScript, @"No superscript for atom at index %lu", (unsigned long)start.atomIndex);
            [current.superScript removeAtomsInListIndexRange:range.subIndexRange];
            break;
        }
    }
}

- (MTMathAtom *)atomAtListIndex:(MTMathListIndex *)index
{
    if (index == nil) {
        return nil;
    }
    
    if (index.atomIndex >= self.atoms.count) {
        return nil;
    }
    
    MTMathAtom* atom = self.atoms[index.atomIndex];
    
    switch (index.subIndexType) {
        case kMTSubIndexTypeNone:
        case kMTSubIndexTypeNucleus:
            return atom;
            
        case kMTSubIndexTypeSubscript:
            return [atom.subScript atomAtListIndex:index.subIndex];
            
        case kMTSubIndexTypeSuperscript:
            return [atom.superScript atomAtListIndex:index.subIndex];

        case kMTSubIndexTypeRadicand:
        case kMTSubIndexTypeDegree: {
            if (atom.type == kMTMathAtomRadical) {
                MTRadical *radical = (MTRadical *) atom;
                if (index.subIndexType == kMTSubIndexTypeDegree) {
                    return [radical.degree atomAtListIndex:index.subIndex];
                } else {
                    return [radical.radicand atomAtListIndex:index.subIndex];
                }
            } else {
                // No radical at this index
                return nil;
            }
        }

        case kMTSubIndexTypeNumerator:
        case kMTSubIndexTypeDenominator:
        {
            if (atom.type == kMTMathAtomFraction) {
                MTFraction* frac = (MTFraction*) atom;
                if (index.subIndexType == kMTSubIndexTypeDenominator) {
                    return [frac.denominator atomAtListIndex:index.subIndex];
                } else {
                    return [frac.numerator atomAtListIndex:index.subIndex];
                }
                
            } else {
                // No fraction at this index.
                return nil;
            }
        }
    }
}

@end
