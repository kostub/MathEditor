//
//  MTDisplay+Editing.m
//
//  Created by Kostub Deshmukh on 9/6/13.
//  Copyright (C) 2013 MathChat
//   
//  This software may be modified and distributed under the terms of the
//  MIT license. See the LICENSE file for details.
//

#import <CoreText/CoreText.h>

#import "MTDisplay+Editing.h"
#import "MTMathList+Editing.h"

static CGPoint kInvalidPosition = { -1, -1};
// Number of pixels outside the bound to allow a point to be considered as part of the bounds.
static CGFloat kPixelDelta = 2;

#pragma mark Unicode functions

NSUInteger numCodePointsInRange(NSString* str, NSRange range) {
    if (range.length > 0) {
        // doesn't work correctly if range is 0
        NSRange grown = [str rangeOfComposedCharacterSequencesForRange:range];
        
        unichar buffer[grown.length];
        [str getCharacters:buffer range:grown];
        int count = 0;
        for (int i = 0; i < grown.length; i++) {
            count++;
            // we check both high and low due to work for both endianess
            if (CFStringIsSurrogateHighCharacter(buffer[i]) || CFStringIsSurrogateLowCharacter(buffer[i])) {
                // skip the next character
                i++;
            }
        }
        return count;
    }
    return 0;
}

static NSUInteger codePointIndexToStringIndex(NSString* str, const NSUInteger codePointIndex) {
    unichar buffer[str.length];
    [str getCharacters:buffer range:NSMakeRange(0, str.length)];
    int codePointCount = 0;
    for (int i = 0; i < str.length; i++, codePointCount++) {
        if (codePointCount == codePointIndex) {
            return i;  // this is the string index
        }
        // we check both high and low due to work for both endianess
        if (CFStringIsSurrogateHighCharacter(buffer[i]) || CFStringIsSurrogateLowCharacter(buffer[i])) {
            // skip the next character
            i++;
        }
    }
    
    // the index is out of range
    return NSNotFound;
}

#pragma mark - Distance utilities
// Calculates the manhattan distance from a point to the nearest boundary of the rectangle
static CGFloat distanceFromPointToRect(CGPoint point, CGRect rect) {
    CGFloat distance = 0;
    if (point.x < rect.origin.x) {
        distance += (rect.origin.x - point.x);
    } else if (point.x > CGRectGetMaxX(rect)) {
        distance += point.x - CGRectGetMaxX(rect);
    }
    
    if (point.y < rect.origin.y) {
        distance += (rect.origin.y - point.y);
    } else if (point.y > CGRectGetMaxY(rect)) {
        distance += point.y - CGRectGetMaxY(rect);
    }
    return distance;
}

# pragma mark - MTDisplay

@implementation MTDisplay (Editing)

// Empty implementations for the base class

- (MTMathListIndex *)closestIndexToPoint:(CGPoint)point
{
    return nil;
}

- (CGPoint)caretPositionForIndex:(MTMathListIndex *)index
{
    return kInvalidPosition;
}

- (void) highlightCharacterAtIndex:(MTMathListIndex*) index color:(UIColor*) color
{
}

- (void)highlightWithColor:(UIColor *)color
{
}
@end

# pragma mark - MTCTLineDisplay

@interface MTCTLineDisplay (Editing)

// Find the index in the mathlist before which a new character should be inserted. Returns nil if it cannot find the index.
- (MTMathListIndex*) closestIndexToPoint:(CGPoint) point;

// The bounds of the display indicated by the given index
- (CGPoint) caretPositionForIndex:(MTMathListIndex*) index;

// Highlight the character(s) at the given index.
- (void) highlightCharacterAtIndex:(MTMathListIndex*) index color:(UIColor*) color;

- (void)highlightWithColor:(UIColor *)color;

@end

@implementation MTCTLineDisplay (Editing)

- (MTMathListIndex *)closestIndexToPoint:(CGPoint)point
{
    // Convert the point to the reference of the CTLine
    CGPoint relativePoint = CGPointMake(point.x - self.position.x, point.y - self.position.y);
    CFIndex index = CTLineGetStringIndexForPosition(self.line, relativePoint);
    if (index == kCFNotFound) {
        return nil;
    }
    // The index returned is in UTF-16, translate to codepoint index.
    // NSUInteger codePointIndex = stringIndexToCodePointIndex(self.attributedString.string, index);
    // Convert the code point index to an index into the mathlist
    NSUInteger mlIndex = [self convertToMathListIndex:index];
    // index will be between 0 and _range.length inclusive
    NSAssert(mlIndex >= 0 && mlIndex <= self.range.length, @"Returned index out of range: %ld, range (%@, %@)", index, @(self.range.location), @(self.range.length));
    // translate to the current index
    MTMathListIndex* listIndex = [MTMathListIndex level0Index:self.range.location + mlIndex];
    return listIndex;
}

- (CGPoint)caretPositionForIndex:(MTMathListIndex *)index
{
    CGFloat offset;
    NSAssert(index.subIndexType == kMTSubIndexTypeNone, @"Index in a CTLineDisplay cannot have sub indexes.");
    if (index.atomIndex == NSMaxRange(self.range)) {
        offset = self.width;
    } else {
        NSAssert(NSLocationInRange(index.atomIndex, self.range), @"Index %@ not in range %@", index, NSStringFromRange(self.range));
        NSUInteger strIndex = [self mathListIndexToStringIndex:index.atomIndex - self.range.location];
        //CFIndex charIndex = codePointIndexToStringIndex(self.attributedString.string, strIndex);
        offset = CTLineGetOffsetForStringIndex(self.line, strIndex, NULL);
    }
    return CGPointMake(self.position.x + offset, self.position.y);
}


- (void)highlightCharacterAtIndex:(MTMathListIndex *)index color:(UIColor *)color
{
    assert(NSLocationInRange(index.atomIndex, self.range));
    assert(index.subIndexType == kMTSubIndexTypeNone || index.subIndexType == kMTSubIndexTypeNucleus);
    if (index.subIndexType == kMTSubIndexTypeNucleus) {
        NSAssert(false, @"Nucleus highlighting not supported yet");
    }
    // index is in unicode code points, while attrString is not
    CFIndex charIndex = codePointIndexToStringIndex(self.attributedString.string, index.atomIndex - self.range.location);
    assert(charIndex != NSNotFound);
    
    NSMutableAttributedString* attrStr = self.attributedString.mutableCopy;
    [attrStr addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[color CGColor]
                    range:[attrStr.string rangeOfComposedCharacterSequenceAtIndex:charIndex]];
    self.attributedString = attrStr;
}

- (void)highlightWithColor:(UIColor *)color
{
    NSMutableAttributedString* attrStr = self.attributedString.mutableCopy;
    [attrStr addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[color CGColor]
                    range:NSMakeRange(0, attrStr.length)];
    self.attributedString = attrStr;
}

// Convert the index into the current string to an index into the mathlist. These may not be the same since a single
// math atom may have multiple characters.
- (NSUInteger) convertToMathListIndex:(NSUInteger) strIndex
{
    NSUInteger strLenCovered = 0;
    for (NSUInteger mlIndex = 0; mlIndex < self.atoms.count; mlIndex++) {
        if (strLenCovered >= strIndex) {
            return mlIndex;
        }
        MTMathAtom* atom = self.atoms[mlIndex];
        strLenCovered += atom.nucleus.length;
    }
    // By the time we come to the end of the string, we should have covered all the characters.
    NSAssert(strLenCovered >= strIndex, @"StrIndex should not be more than the len covered");
    return self.atoms.count;
}

- (NSUInteger) mathListIndexToStringIndex:(NSUInteger) mlIndex
{
    NSAssert(mlIndex < self.atoms.count, @"Index %@ not in range %@", @(mlIndex), @(self.atoms.count));
    NSUInteger strIndex = 0;
    for (NSUInteger i = 0; i < mlIndex; i++) {
        MTMathAtom* atom = self.atoms[i];
        strIndex += atom.nucleus.length;
    }
    return strIndex;
}
         
@end

#pragma mark - MTFractionDisplay

@interface MTFractionDisplay (Editing)

// Find the index in the mathlist before which a new character should be inserted. Returns nil if it cannot find the index.
- (MTMathListIndex*) closestIndexToPoint:(CGPoint) point;

// The bounds of the display indicated by the given index
- (CGPoint) caretPositionForIndex:(MTMathListIndex*) index;

// Highlight the character(s) at the given index.
- (void) highlightCharacterAtIndex:(MTMathListIndex*) index color:(UIColor*) color;

- (void)highlightWithColor:(UIColor *)color;

- (MTMathListDisplay*) subAtomForIndexType:(MTMathListSubIndexType) type;

@end

@implementation MTFractionDisplay (Editing)

- (MTMathListIndex *)closestIndexToPoint:(CGPoint)point
{
    // We can be before the fraction or after the fraction
    if (point.x < self.position.x - kPixelDelta) {
        // we are before the fraction, so
        return [MTMathListIndex level0Index:self.range.location];
    } else if (point.x > self.position.x + self.width + kPixelDelta) {
        // we are after the fraction
        return [MTMathListIndex level0Index:NSMaxRange(self.range)];
    } else {
        // we can be either near the numerator or the denominator
        CGFloat numeratorDistance = distanceFromPointToRect(point, self.numerator.displayBounds);
        CGFloat denominatorDistance = distanceFromPointToRect(point, self.denominator.displayBounds);
        if (numeratorDistance < denominatorDistance) {
            return [MTMathListIndex indexAtLocation:self.range.location withSubIndex:[self.numerator closestIndexToPoint:point] type:kMTSubIndexTypeNumerator];
        } else {
            return [MTMathListIndex indexAtLocation:self.range.location withSubIndex:[self.denominator closestIndexToPoint:point] type:kMTSubIndexTypeDenominator];
        }
    }
}

// Seems never used
- (CGPoint)caretPositionForIndex:(MTMathListIndex *)index
{
    assert(index.subIndexType == kMTSubIndexTypeNone);
    // draw a caret before the fraction
    return CGPointMake(self.position.x, self.position.y);
}

- (void)highlightCharacterAtIndex:(MTMathListIndex *)index color:(UIColor *)color
{
    assert(index.subIndexType == kMTSubIndexTypeNone);
    [self highlightWithColor:color];
}

- (void)highlightWithColor:(UIColor *)color
{
    [self.numerator highlightWithColor:color];
    [self.denominator highlightWithColor:color];
}

- (MTMathListDisplay*) subAtomForIndexType:(MTMathListSubIndexType) type
{
    switch (type) {
        case kMTSubIndexTypeNumerator:
            return self.numerator;
            
        case kMTSubIndexTypeDenominator:
            return self.denominator;

        case kMTSubIndexTypeDegree:
        case kMTSubIndexTypeRadicand:
        case kMTSubIndexTypeNucleus:
        case kMTSubIndexTypeSubscript:
        case kMTSubIndexTypeSuperscript:
        case kMTSubIndexTypeNone:
            NSAssert(false, @"Not a fraction subtype %d", type);
            return nil;
    }
}

@end

#pragma mark - MTRadicalDisplay

@interface MTRadicalDisplay (Editing)

// Find the index in the mathlist before which a new character should be inserted. Returns nil if it cannot find the index.
- (MTMathListIndex*) closestIndexToPoint:(CGPoint) point;

// The bounds of the display indicated by the given index
- (CGPoint) caretPositionForIndex:(MTMathListIndex*) index;

// Highlight the character(s) at the given index.
- (void) highlightCharacterAtIndex:(MTMathListIndex*) index color:(UIColor*) color;

- (void)highlightWithColor:(UIColor *)color;

- (MTMathListDisplay*) subAtomForIndexType:(MTMathListSubIndexType) type;

@end

@implementation MTRadicalDisplay (Editing)


- (MTMathListIndex *)closestIndexToPoint:(CGPoint)point
{
    // We can be before the radical or after the radical
    if (point.x < self.position.x - kPixelDelta) {
        // we are before the radical, so
        return [MTMathListIndex level0Index:self.range.location];
    } else if (point.x > self.position.x + self.width + kPixelDelta) {
        // we are after the radical
        return [MTMathListIndex level0Index:NSMaxRange(self.range)];
    } else {
        // we are in the radical
        CGFloat degreeDistance = distanceFromPointToRect(point, self.degree.displayBounds);
        CGFloat radicandDistance = distanceFromPointToRect(point, self.radicand.displayBounds);

        if (degreeDistance < radicandDistance) {
            return [MTMathListIndex indexAtLocation:self.range.location withSubIndex:[self.degree closestIndexToPoint:point] type:kMTSubIndexTypeDegree];
        } else {
            return [MTMathListIndex indexAtLocation:self.range.location withSubIndex:[self.radicand closestIndexToPoint:point] type:kMTSubIndexTypeRadicand];
        }

    }
}

// TODO seems unused
- (CGPoint)caretPositionForIndex:(MTMathListIndex *)index
{
    assert(index.subIndexType == kMTSubIndexTypeNone);
    // draw a caret
    return CGPointMake(self.position.x, self.position.y);
}

- (void)highlightCharacterAtIndex:(MTMathListIndex *)index color:(UIColor *)color
{
    assert(index.subIndexType == kMTSubIndexTypeNone);
    [self highlightWithColor:color];
}

- (void)highlightWithColor:(UIColor *)color
{
    [self.radicand highlightWithColor:color];
}

- (MTMathListDisplay*) subAtomForIndexType:(MTMathListSubIndexType) type
{
    switch (type) {

        case kMTSubIndexTypeRadicand:
            return self.radicand;
        case kMTSubIndexTypeDegree:
            return self.degree;
        case kMTSubIndexTypeNumerator:

        case kMTSubIndexTypeDenominator:

        case kMTSubIndexTypeNucleus:
        case kMTSubIndexTypeSubscript:
        case kMTSubIndexTypeSuperscript:
        case kMTSubIndexTypeNone:
            NSAssert(false, @"Not a radical subtype %d", type);
            return nil;
    }
}

@end

#pragma mark - MTMathListDisplay

@interface MTMathListDisplay (Editing)

// Find the index in the mathlist before which a new character should be inserted. Returns nil if it cannot find the index.
- (MTMathListIndex*) closestIndexToPoint:(CGPoint) point;

// The bounds of the display indicated by the given index
- (CGPoint) caretPositionForIndex:(MTMathListIndex*) index;

// Highlight the character(s) at the given index.
- (void) highlightCharacterAtIndex:(MTMathListIndex*) index color:(UIColor*) color;

- (void)highlightWithColor:(UIColor *)color;

@end

@implementation MTMathListDisplay (Editing)


- (MTMathListIndex *)closestIndexToPoint:(CGPoint)point
{    
    // the origin of for the subelements of a MTMathList is the current position, so translate the current point to our origin.
    CGPoint translatedPoint = CGPointMake(point.x - self.position.x, point.y - self.position.y);
    
    MTDisplay* closest = nil;
    NSMutableArray* xbounds = [NSMutableArray array];
    CGFloat minDistance = CGFLOAT_MAX;
    for (MTDisplay* atom in self.subDisplays) {
        CGRect bounds = atom.displayBounds;
        CGFloat maxBoundsX = CGRectGetMaxX(bounds);
        
        if (bounds.origin.x - kPixelDelta <= translatedPoint.x && translatedPoint.x <= maxBoundsX + kPixelDelta) {
            [xbounds addObject:atom];
        }
        
        CGFloat distance = distanceFromPointToRect(translatedPoint, bounds);
        if (distance < minDistance) {
            closest = atom;
            minDistance = distance;
        }
    }
    MTDisplay* atomWithPoint = nil;
    if (xbounds.count == 0) {
        if (translatedPoint.x <= -kPixelDelta) {
            // all the way to the left
            return [MTMathListIndex level0Index:self.range.location];
        } else if (translatedPoint.x >= self.width + kPixelDelta) {
            // all the way to the right
            return [MTMathListIndex level0Index:NSMaxRange(self.range)];
        } else {
            // It is within the mathlist but not within the x bounds of any sublist. Use the closest in that case.
            atomWithPoint = closest;
        }
    } else if (xbounds.count == 1) {
        atomWithPoint = xbounds[0];
        if (translatedPoint.x >= self.width - kPixelDelta) {
            // The point is close to the end. Only use the selected x bounds if the y is within range.
            if (translatedPoint.y <= CGRectGetMinY(atomWithPoint.displayBounds) - kPixelDelta) {
                // The point is less than the y including the delta. Move the cursor to the end rather than in this atom.
                return [MTMathListIndex level0Index:NSMaxRange(self.range)];
            }
        }
    } else {
        // Use the closest since there are more than 2 sublists which have this x position.
        atomWithPoint = closest;
    }
    
    if (!atomWithPoint) {
        return nil;
    }
    
    MTMathListIndex* index = [atomWithPoint closestIndexToPoint:(CGPoint)translatedPoint];
    if ([atomWithPoint isKindOfClass:[MTMathListDisplay class]]) {
        MTMathListDisplay* closestLine = (MTMathListDisplay*) atomWithPoint;
        NSAssert(closestLine.type == kMTLinePositionSubscript || closestLine.type == kMTLinePositionSuperscript, @"MTLine type regular inside an MTLine - shouldn't happen");
        // This is a subscript or a superscript, return the right type of subindex
        MTMathListSubIndexType type = (closestLine.type == kMTLinePositionSubscript) ? kMTSubIndexTypeSubscript : kMTSubIndexTypeSuperscript;
        // The index of the atom this denotes.
        NSAssert(closestLine.index != NSNotFound, @"Index is not set for a subscript/superscript");
        return [MTMathListIndex indexAtLocation:closestLine.index withSubIndex:index type:type];
    } else if (atomWithPoint.hasScript) {
        // The display list has a subscript or a superscript. If the index is at the end of the atom, then we need to put it before the sub/super script rather than after.
        if (index.atomIndex == NSMaxRange(atomWithPoint.range)) {
            return [MTMathListIndex indexAtLocation:index.atomIndex - 1 withSubIndex:[MTMathListIndex level0Index:1] type:kMTSubIndexTypeNucleus];
        }
    }
    return index;
}

- (MTDisplay*) subAtomForIndex:(MTMathListIndex*) index
{
    // Inside the range
    if (index.subIndexType == kMTSubIndexTypeSuperscript || index.subIndexType == kMTSubIndexTypeSubscript) {
        for (MTDisplay* atom in self.subDisplays) {
            if ([atom isKindOfClass:[MTMathListDisplay class]]) {
                MTMathListDisplay* lineAtom = (MTMathListDisplay*) atom;
                if (index.atomIndex == lineAtom.index) {
                    // this is the right character for the sub/superscript
                    // Check that it's type matches the index
                    if ((lineAtom.type == kMTLinePositionSubscript && index.subIndexType == kMTSubIndexTypeSubscript)
                        || (lineAtom.type == kMTLinePositionSuperscript && index.subIndexType == kMTSubIndexTypeSuperscript)) {
                        return lineAtom;
                    }
                }
            }
        }
    } else {
        for (MTDisplay* atom in self.subDisplays) {
            if (![atom isKindOfClass:[MTMathListDisplay class]] && NSLocationInRange(index.atomIndex, atom.range)) {
                // not a subscript/superscript and
                // jackpot, the index is in the range of this atom.
                switch (index.subIndexType) {
                    case kMTSubIndexTypeNone:
                    case kMTSubIndexTypeNucleus:
                        return atom;

                    case kMTSubIndexTypeDegree:
                    case kMTSubIndexTypeRadicand:
                        if ([atom isKindOfClass:[MTRadicalDisplay class]]) {
                            MTRadicalDisplay *radical = (MTRadicalDisplay *) atom;
                            return [radical subAtomForIndexType:index.subIndexType];
                        } else {
                            NSLog(@"No radical at index: %lu", (unsigned long)index.atomIndex);
                            return nil;
                        }

                    case kMTSubIndexTypeNumerator:
                    case kMTSubIndexTypeDenominator:
                        if ([atom isKindOfClass:[MTFractionDisplay class]]) {
                            MTFractionDisplay* frac = (MTFractionDisplay*) atom;
                            return [frac subAtomForIndexType:index.subIndexType];
                        } else {
                            NSLog(@"No fraction at index: %lu", (unsigned long)index.atomIndex);
                            return nil;
                        }
                        
                    case kMTSubIndexTypeSubscript:
                    case kMTSubIndexTypeSuperscript:
                        assert(false);  // Can't happen
                        break;
                }
                // We found the right subatom
                break;
            }
        }
    }
    return nil;
}

- (CGPoint)caretPositionForIndex:(MTMathListIndex *)index
{
    CGPoint position = kInvalidPosition;
    if (!index) {
        return kInvalidPosition;
    }
    
    if (index.atomIndex == NSMaxRange(self.range)) {
        // Special case the edge of the range
        position = CGPointMake(self.width, 0);
    } else if (NSLocationInRange(index.atomIndex, self.range)) {
        MTDisplay* atom = [self subAtomForIndex:index];
        if (index.subIndexType == kMTSubIndexTypeNucleus) {
            NSUInteger nucleusPosition = index.atomIndex + index.subIndex.atomIndex;
            position = [atom caretPositionForIndex:[MTMathListIndex level0Index:nucleusPosition]];
        } else if (index.subIndexType == kMTSubIndexTypeNone) {
            position = [atom caretPositionForIndex:index];
        } else {
            // recurse
            position = [atom caretPositionForIndex:index.subIndex];
        }
    } else {
        // outside the range
        return kInvalidPosition;
    }
    
    if (CGPointEqualToPoint(position, kInvalidPosition)) {
        // we didn't find the position
        return position;
    }
    
    // convert bounds from our coordinate system before returning
    position.x += self.position.x;
    position.y += self.position.y;
    return position;
}


- (void)highlightCharacterAtIndex:(MTMathListIndex *)index color:(UIColor *)color
{
    if (!index) {
        return;
    }
    if (NSLocationInRange(index.atomIndex, self.range)) {
        MTDisplay* atom = [self subAtomForIndex:index];
        if (index.subIndexType == kMTSubIndexTypeNucleus || index.subIndexType == kMTSubIndexTypeNone) {
            [atom highlightCharacterAtIndex:index color:color];
        } else {
            // recurse
            [atom highlightCharacterAtIndex:index.subIndex color:color];
        }
    }
}

- (void)highlightWithColor:(UIColor *)color
{
    for (MTDisplay* atom in self.subDisplays) {
        [atom highlightWithColor:color];
    }
}

@end
