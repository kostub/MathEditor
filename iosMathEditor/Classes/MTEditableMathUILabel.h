//
//  EditableMathUILabel.h
//
//  Created by Kostub Deshmukh on 9/2/13.
//  Copyright (C) 2013 MathChat
//   
//  This software may be modified and distributed under the terms of the
//  MIT license. See the LICENSE file for details.
//

#import <UIKit/UIKit.h>
#import "MTMathList.h"
#import "MTKeyboardContext.h"

@class MTEditableMathUILabel;
@class MTMathListIndex;

@protocol MTEditableMathUILabelDelegate <NSObject>

// Called when the return key is pressed
- (void) returnPressed:(MTEditableMathUILabel*) label;
// called when any text is modified
- (void) textModified:(MTEditableMathUILabel*) label;

- (void) didBeginEditing:(MTEditableMathUILabel*) label;
- (void) didEndEditing:(MTEditableMathUILabel*) label;

@end

@interface MTEditableMathUILabel : UIView<UIKeyInput>

@property (nonatomic) MTMathList* mathList;
@property (nonatomic) UIColor* highlightColor;

@property (nonatomic) UIImageView* cancelImage;
@property (nonatomic, weak) IBOutlet id<MTEditableMathUILabelDelegate> delegate;
@property (nonatomic) MTKeyboardContext* keyboardContext;
@property (nonatomic) CGFloat fontSize;
@property (nonatomic) CGFloat paddingBottom;
@property (nonatomic) CGFloat paddingTop;

- (void) clear;

- (void) highlightCharacterAtIndex:(MTMathListIndex*) index;
- (void) clearHighlights;
- (void) moveCaretToPoint:(CGPoint) point;
- (void) startEditing;
- (void) enableTap:(BOOL) enable;

// Insert a list at a given point.
- (void) insertMathList:(MTMathList*) list atPoint:(CGPoint) point;

- (CGSize) mathDisplaySize;

@end
