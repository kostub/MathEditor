//
//  MTMathSocraticInputAccessoryView.m
//  Pods
//
//  Created by Jakub Dolecki on 8/8/16.
//
//

#import "MTMathSocraticInputAccessoryView.h"

@implementation MTMathSocraticInputAccessoryView {
    
}

+ (instancetype)defaultAccessoryView {
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle bundleForClass:[self class]] URLForResource:@"MTKeyboardResources" withExtension:@"bundle"]];
    NSArray *nib = [bundle loadNibNamed:@"MTMathSocraticInputAccessoryView" owner:nil options:nil];
    
    if (nib.count == 0) {
        return nil;
    }
    
    MTMathSocraticInputAccessoryView *view = nib[0];
    return view;
}

- (IBAction)searchButtonTapped:(id)sender {
    NSLog(@"Search button tapped");
    [self.delegate inputAccessoryViewSearchButtonTapped:self];
}

- (IBAction)deleteButtonTapped:(id)sender {
    NSLog(@"Delete button tapped");
    [self.delegate inputAccessoryViewDeleteButtonTapped:self];
}

- (IBAction)clearButtonTapped:(id)sender {
    NSLog(@"Clear button tapped");
    [self.delegate inputAccessoryViewClearButtonTapped:self];
}

@end
