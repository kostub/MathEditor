//
//  MTMathSocraticInputAccessoryView.h
//  Pods
//
//  Created by Jakub Dolecki on 8/8/16.
//
//

#import <UIKit/UIKit.h>

@protocol MTMathSocraticInputAccessoryViewDelegate

-(void)inputAccessoryViewSearchButtonTapped:(MTMathSocraticInputAccessoryView *)inputAccessoryView;
-(void)inputAccessoryViewDeleteButtonTapped:(MTMathSocraticInputAccessoryView *)inputAccessoryView;
-(void)inputAccessoryViewClearButtonTapped:(MTMathSocraticInputAccessoryView *)inputAccessoryView;

@end

@interface MTMathSocraticInputAccessoryView : UIView

@property (nonatomic, weak) id<MTMathSocraticInputAccessoryViewDelegate> delegate;

@end
