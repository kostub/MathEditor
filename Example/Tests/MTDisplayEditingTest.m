//
//  MTDisplayEditingTest.m
//
//  Created by Kostub Deshmukh on 6/13/14.
//  Copyright (C) 2014 MathChat
//   
//  This software may be modified and distributed under the terms of the
//  MIT license. See the LICENSE file for details.
//

#import <XCTest/XCTest.h>

@import CoreText;

#import "MTMathListDisplay.h"
#import "MTDisplay+Editing.h"
#import "MTMathListBuilder.h"

@interface MTDisplayEditingTest : XCTestCase

@property (nonatomic) CTFontRef font;
@end


@implementation MTDisplayEditingTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    CGFloat fontSize = 20;
    //_font = [[MTFontManager fontManager] createCTFontFromDefaultFont:fontSize];
    // CFRetain(_font);
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    if (_font) {
        CFRelease(_font);
    }
}

static NSValue* point(CGFloat x, CGFloat y) {
    return [NSValue valueWithCGPoint:CGPointMake(x, y)];
}

- (void)testClosestPointForExpression:(NSString*) expr data:(NSDictionary*) testData
{
    MTMathList* ml = [MTMathListBuilder buildFromString:expr];
    MTDisplay* displayList = [MTTypesetter createLineForMathList:ml font:_font style:kMTLineStyleDisplay];
    
    for (NSValue* point in testData) {
        CGPoint cgPoint = [point CGPointValue];
        MTMathListIndex* expectedIndex = testData[point];
        MTMathListIndex* index = [displayList closestIndexToPoint:cgPoint];
        XCTAssertEqualObjects(index, expectedIndex, @"Index %@ does not match %@ for point (%f, %f)", index, expectedIndex, cgPoint.x, cgPoint.y);
    }
}

static NSDictionary* getFractionTestData() {
    return @{ point(-10, 8) : [MTMathListIndex level0Index:0],
              point(-10, 0) : [MTMathListIndex level0Index:0],
              point(-10, 40) : [MTMathListIndex level0Index:0],
              point(-10, -20) : [MTMathListIndex level0Index:0],
              point(-2.5, 8) : [MTMathListIndex level0Index:0],
              point(-2.5, 0) : [MTMathListIndex level0Index:0],
              point(-2.5, 40) : [MTMathListIndex level0Index:0],
              point(-2.5, -20) : [MTMathListIndex level0Index:0],
              point(-1, 0) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:0] type:kMTSubIndexTypeDenominator],
              point(-1, 8) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:0]  type:kMTSubIndexTypeNumerator],
              point(-1, 40) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:0]  type:kMTSubIndexTypeNumerator],
              point(-1, -20) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:0]  type:kMTSubIndexTypeDenominator],
              point(3, 0) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:0] type:kMTSubIndexTypeDenominator],
              point(3, 8) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:0]  type:kMTSubIndexTypeNumerator],
              point(3, 40) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:0]  type:kMTSubIndexTypeNumerator],
              point(3, -20) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:0]  type:kMTSubIndexTypeDenominator],
              point(7, 0) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:1] type:kMTSubIndexTypeDenominator],
              point(7, 8) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:1]  type:kMTSubIndexTypeNumerator],
              point(7, 40) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:1]  type:kMTSubIndexTypeNumerator],
              point(7, -20) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:1]  type:kMTSubIndexTypeDenominator],
              point(11, 0) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:1] type:kMTSubIndexTypeDenominator],
              point(11, 8) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:1]  type:kMTSubIndexTypeNumerator],
              point(11, 40) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:1]  type:kMTSubIndexTypeNumerator],
              point(11, -20) : [MTMathListIndex level0Index:1],  // because it is below the height of the fraction
              point(12.5, 8) : [MTMathListIndex level0Index:1],
              point(12.5, 0) : [MTMathListIndex level0Index:1],
              point(12.5, 40) : [MTMathListIndex level0Index:1],
              point(12.5, -20) : [MTMathListIndex level0Index:1],
              point(20, 8) : [MTMathListIndex level0Index:1],
              point(20, 0) : [MTMathListIndex level0Index:1],
              point(20, 40) : [MTMathListIndex level0Index:1],
              point(20, -20) : [MTMathListIndex level0Index:1] };
}

- (void)testClosestPointFraction
{
    [self testClosestPointForExpression:@"\\frac{3}{2}" data:getFractionTestData()];
}

static NSDictionary* getRegularTestData() {
    return @{ point(-10, 8) : [MTMathListIndex level0Index:0],
              point(-10, 0) : [MTMathListIndex level0Index:0],
              point(-10, 40) : [MTMathListIndex level0Index:0],
              point(-10, -20) : [MTMathListIndex level0Index:0],
              point(0, 0) : [MTMathListIndex level0Index:0],
              point(0, 8) : [MTMathListIndex level0Index:0],
              point(0, 40) : [MTMathListIndex level0Index:0],
              point(0, -20) : [MTMathListIndex level0Index:0],
              point(10, 0) : [MTMathListIndex level0Index:1],
              point(10, 8) : [MTMathListIndex level0Index:1],
              point(10, 40) : [MTMathListIndex level0Index:1],
              point(10, -20) : [MTMathListIndex level0Index:1],
              point(15, 0) : [MTMathListIndex level0Index:1],
              point(15, 8) : [MTMathListIndex level0Index:1],
              point(15, 40) : [MTMathListIndex level0Index:1],
              point(15, -20) : [MTMathListIndex level0Index:1],
              point(25, 0) : [MTMathListIndex level0Index:2],
              point(25, 8) : [MTMathListIndex level0Index:2],
              point(25, 40) : [MTMathListIndex level0Index:2],
              point(25, -20) : [MTMathListIndex level0Index:2],
              point(35, 0) : [MTMathListIndex level0Index:2],
              point(35, 8) : [MTMathListIndex level0Index:2],
              point(35, 40) : [MTMathListIndex level0Index:2],
              point(35, -20) : [MTMathListIndex level0Index:2],
              point(45, 0) : [MTMathListIndex level0Index:3],
              point(45, 8) : [MTMathListIndex level0Index:3],
              point(45, 40) : [MTMathListIndex level0Index:3],
              point(45, -20) : [MTMathListIndex level0Index:3],
              point(55, 0) : [MTMathListIndex level0Index:3],
              point(55, 8) : [MTMathListIndex level0Index:3],
              point(55, 40) : [MTMathListIndex level0Index:3],
              point(55, -20) : [MTMathListIndex level0Index:3], };
}

- (void) testClosestPointRegular
{
    [self testClosestPointForExpression:@"4+2" data:getRegularTestData()];
}

static NSDictionary* getRegularPlusFractionTestData() {
    return @{ point(30, 0) : [MTMathListIndex level0Index:2],
              point(30, 8) : [MTMathListIndex level0Index:2],
              point(30, 40) : [MTMathListIndex level0Index:2],
              point(30, -20) : [MTMathListIndex level0Index:2],
              point(32, 0) : [MTMathListIndex level0Index:2],
              point(32, 8) : [MTMathListIndex level0Index:2],
              point(32, 40) : [MTMathListIndex level0Index:2],
              point(32, -20) : [MTMathListIndex level0Index:2],
              point(33, 0) : [MTMathListIndex indexAtLocation:2 withSubIndex:[MTMathListIndex level0Index:0] type:kMTSubIndexTypeDenominator],
              point(33, 8) : [MTMathListIndex indexAtLocation:2 withSubIndex:[MTMathListIndex level0Index:0]  type:kMTSubIndexTypeNumerator],
              point(33, 40) : [MTMathListIndex indexAtLocation:2 withSubIndex:[MTMathListIndex level0Index:0]  type:kMTSubIndexTypeNumerator],
              point(33, -20) : [MTMathListIndex indexAtLocation:2 withSubIndex:[MTMathListIndex level0Index:0]  type:kMTSubIndexTypeDenominator],
              point(35, 0) : [MTMathListIndex indexAtLocation:2 withSubIndex:[MTMathListIndex level0Index:0] type:kMTSubIndexTypeDenominator],
              point(35, 8) : [MTMathListIndex indexAtLocation:2 withSubIndex:[MTMathListIndex level0Index:0]  type:kMTSubIndexTypeNumerator],
              point(35, 40) : [MTMathListIndex indexAtLocation:2 withSubIndex:[MTMathListIndex level0Index:0]  type:kMTSubIndexTypeNumerator],
              point(35, -20) : [MTMathListIndex indexAtLocation:2 withSubIndex:[MTMathListIndex level0Index:0]  type:kMTSubIndexTypeDenominator]};
    
}

- (void)testClosestPointRegularPlusFraction
{
    [self testClosestPointForExpression:@"1+\\frac{3}{2}" data:getRegularPlusFractionTestData()];
}

static NSDictionary* getFractionPlusRegularTestData() {
    return @{ point(15, 0) : [MTMathListIndex level0Index:1],
              point(15, 8) : [MTMathListIndex level0Index:1],
              point(15, 40) : [MTMathListIndex level0Index:1],
              point(15, -20) : [MTMathListIndex level0Index:1],
              point(13, 0) : [MTMathListIndex level0Index:1],
              point(13, 8) : [MTMathListIndex level0Index:1],
              point(13, 40) : [MTMathListIndex level0Index:1],
              point(13, -20) : [MTMathListIndex level0Index:1],
              point(11, 0) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:1] type:kMTSubIndexTypeDenominator],
              point(11, 8) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:1]  type:kMTSubIndexTypeNumerator],
              point(11, 40) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:1]  type:kMTSubIndexTypeNumerator],
              point(11, -20) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:1]  type:kMTSubIndexTypeDenominator],
              point(9, 0) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:1] type:kMTSubIndexTypeDenominator],
              point(9, 8) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:1]  type:kMTSubIndexTypeNumerator],
              point(9, 40) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:1]  type:kMTSubIndexTypeNumerator],
              point(9, -20) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:1]  type:kMTSubIndexTypeDenominator]};
    
}

- (void)testClosestPointFractionPlusRegular
{
    [self testClosestPointForExpression:@"\\frac{3}{2}+1" data:getFractionPlusRegularTestData()];
}

static NSDictionary* getExponentTestData() {
    return @{ point(-10, 8) : [MTMathListIndex level0Index:0],
              point(-10, 0) : [MTMathListIndex level0Index:0],
              point(-10, 40) : [MTMathListIndex level0Index:0],
              point(-10, -20) : [MTMathListIndex level0Index:0],
              point(0, 0) : [MTMathListIndex level0Index:0],
              point(0, 8) : [MTMathListIndex level0Index:0],
              point(0, 40) : [MTMathListIndex level0Index:0],
              point(0, -20) : [MTMathListIndex level0Index:0],
              point(9, 0) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:1] type:kMTSubIndexTypeNucleus],
              point(9, 8) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:1] type:kMTSubIndexTypeNucleus],
              // The superscript is closer than the nucleus (and the touch boundaries overlap)
              point(9, 40) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:0] type:kMTSubIndexTypeSuperscript],
              point(9, -20) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:1] type:kMTSubIndexTypeNucleus],
              point(10, 0) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:1] type:kMTSubIndexTypeNucleus],
              // The nucleus is closer and the touch boundaries overlap
              point(10, 8) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:1] type:kMTSubIndexTypeNucleus],
              point(10, 40) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:0] type:kMTSubIndexTypeSuperscript],
              point(10, -20) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:1] type:kMTSubIndexTypeNucleus],
              point(11, 0) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:1] type:kMTSubIndexTypeNucleus],
              point(11, 8) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:0] type:kMTSubIndexTypeSuperscript],
              point(11, 40) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:0] type:kMTSubIndexTypeSuperscript],
              point(11, -20) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:1] type:kMTSubIndexTypeNucleus],
              point(17, 0) : [MTMathListIndex level0Index:1],
              point(17, 8) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:1] type:kMTSubIndexTypeSuperscript],
              point(17, 40) : [MTMathListIndex indexAtLocation:0 withSubIndex:[MTMathListIndex level0Index:1] type:kMTSubIndexTypeSuperscript],
              point(17, -20) : [MTMathListIndex level0Index:1],
              point(30, 0) : [MTMathListIndex level0Index:1],
              point(30, 8) : [MTMathListIndex level0Index:1],
              point(30, 40) : [MTMathListIndex level0Index:1],
              point(30, -20) : [MTMathListIndex level0Index:1],
              };
    
}


- (void) testClosestPointExponent
{
    [self testClosestPointForExpression:@"2^3" data:getExponentTestData()];
}
@end
