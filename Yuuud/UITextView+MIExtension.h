//
//  UITextView+MIExtension.h
//  MI API Examples
//
//  Created by mac-0001 on 7/30/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (MIExtension)

- (void)setPlaceholder:(NSString *)placeholder;
- (void)setPlaceholderColor:(UIColor *)placeholderColor;



- (void)textViewDidBeginEditing:(UITextView *)textView;
- (void)textViewDidEndEditing:(UITextView *)textView;
- (void)textViewDidChange:(UITextView *)textView;


@end


/*      /// # MI-UITextView+MIExtension
 
 [txtView setPlaceholder:@"Placeholder..."];
 [txtView setPlaceholderColor:[UIColor redColor]];

*/

// To-Do Check Logic for other uitexview delegates
// To-Do Add other delegate methods