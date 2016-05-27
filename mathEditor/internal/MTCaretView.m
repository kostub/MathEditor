//
//  CaretView.m
//
//  Created by Kostub Deshmukh on 9/2/13.
//  Copyright (C) 2013 MathChat
//   
//  This software may be modified and distributed under the terms of the
//  MIT license. See the LICENSE file for details.
//

#import "MTCaretView.h"
#import "MTEditableMathLabel.h"

static const NSTimeInterval InitialBlinkDelay = 0.7;
static const NSTimeInterval BlinkRate = 0.5;
// The settings below make sense for the given font size. They are scaled appropriately when the fontsize changes.
static const CGFloat kCaretFontSize = 30;
static const NSInteger kCaretAscent = 25;  // how much should te caret be above the baseline
static const NSInteger kCaretWidth = 3;
static const NSInteger kCaretDescent = 7;  // how much should the caret be below the baseline
static const NSInteger kCaretHandleWidth = 15;
static const NSInteger kCaretHandleDescent = 8;
static const NSInteger kCaretHandleHeight = 20;
static const NSInteger kCaretHandleHitAreaSize = 44;

static NSInteger getCaretHeight() {
    return kCaretAscent + kCaretDescent;
}

@interface MTCaretHandle : UIView

@property (nonatomic, weak) MTEditableMathLabel* label;

@end

@implementation MTCaretHandle {
    UIBezierPath* _path;
    UIColor* _color;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _path = [self createHandlePath];
    }
    return self;
}

- (UIBezierPath*) createHandlePath
{
    UIBezierPath* path = [UIBezierPath bezierPath];
    CGSize size = self.bounds.size;
    [path moveToPoint:CGPointMake(size.width/2, 0)];
    [path addLineToPoint:CGPointMake(size.width, size.height/4)];
    [path addLineToPoint:CGPointMake(size.width, size.height)];
    [path addLineToPoint:CGPointMake(0, size.height)];
    [path addLineToPoint:CGPointMake(0, size.height/4)];
    [path closePath];
    return path;
}

- (void) layoutSubviews
{
    _path = [self createHandlePath];
}

- (void)drawRect:(CGRect)rect
{
    [_color setFill];
    [_path fill];
}

- (void) setColor:(UIColor*) color
{
    _color = [color colorWithAlphaComponent:0.6];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // From apple documentation
    UITouch *aTouch = [touches anyObject];
    CGPoint loc = [aTouch locationInView:self];
    CGRect frame = self.frame;
    CGPoint caretPoint = CGPointMake(loc.x, loc.y - frame.origin.y);  // puts the point at the top to the top of the current caret
    CGPoint labelPoint = [_label convertPoint:caretPoint fromView:self];
    [_label moveCaretToPoint:labelPoint];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    // Create a hit area around the center.
    CGSize size = self.bounds.size;
    CGRect hitArea = CGRectMake((size.width - kCaretHandleHitAreaSize)/2, (size.height - kCaretHandleHitAreaSize)/2, kCaretHandleHitAreaSize, kCaretHandleHitAreaSize);
    return CGRectContainsPoint(hitArea, point);
}

@end

@interface MTCaretView ()

@property (nonatomic) NSTimer *blinkTimer;

@end


@implementation MTCaretView {
    UIView *_blinker;
    MTCaretHandle *_handle;
    CGFloat _scale;
}

- (id)initWithEditor:(MTEditableMathLabel*)label
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _scale = label.fontSize / kCaretFontSize;
        _blinker = [[UIView alloc] initWithFrame:CGRectZero];
        _blinker.backgroundColor = self.caretColor;
        [self addSubview:_blinker];
        _handle = [[MTCaretHandle alloc] initWithFrame:CGRectMake(0, 0, kCaretHandleWidth * _scale, kCaretHandleHeight *_scale)];
        _handle.backgroundColor = [UIColor clearColor];
        _handle.hidden = YES;
        _handle.label = label;
        [self addSubview:_handle];
    }
    return self;
}


- (void)setPosition:(CGPoint)position
{
    // position is in the parent's coordinate system and it is the bottom left corner of the view.
    self.frame = CGRectMake(position.x, position.y - kCaretAscent * _scale, 0,0);
}

- (void) setFontSize:(CGFloat)fontSize
{
    _scale = fontSize / kCaretFontSize;
    [self setNeedsLayout];
}

- (void) layoutSubviews
{
    _blinker.frame = CGRectMake(0, 0, kCaretWidth * _scale, getCaretHeight() *_scale);
    _handle.frame = CGRectMake(-(kCaretHandleWidth - kCaretWidth) * _scale/2, (getCaretHeight() + kCaretHandleDescent) *_scale, kCaretHandleWidth *_scale, kCaretHandleHeight *_scale);
}

- (void) showHandle:(BOOL) show
{
    _handle.hidden = !show;
}

// Helper method to toggle hidden state of caret view.
- (void)blink
{
    _blinker.hidden = !_blinker.hidden;
}


// UIView didMoveToSuperview override to set up blink timers after caret view created in superview.
- (void)didMoveToSuperview
{
    self.hidden = NO;

    if (self.superview) {
        self.blinkTimer = [NSTimer scheduledTimerWithTimeInterval:BlinkRate target:self selector:@selector(blink) userInfo:nil repeats:YES];
        [self delayBlink];
    }
    else {
        [self.blinkTimer invalidate];
        self.blinkTimer = nil;
    }
}


// Helper method to set an initial blink delay
- (void)delayBlink
{
    self.hidden = NO;
    _blinker.hidden = NO;
    [self.blinkTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:InitialBlinkDelay]];
}


- (void)dealloc
{
    [_blinkTimer invalidate];
}

- (void)setCaretColor:(UIColor *)caretColor
{
    _caretColor = caretColor;
    _handle.color = caretColor;
    _blinker.backgroundColor = self.caretColor;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    if (!_handle.hidden) {
        return [_handle pointInside:[self convertPoint:point toView:_handle] withEvent:event];
    } else {
        return [super pointInside:point withEvent:event];
    }
}


@end

