//
//  UITextView+MIExtension.m
//  MI API Examples
//
//  Created by mac-0001 on 7/30/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import "UITextView+MIExtension.h"

#import "Master.h"
#import "NSObject+NewProperty.h"

//#import "DelegateObserver.h"


static NSString *const PLACEHOLDERSTRING = @"PlaceholderString";
static NSString *const PLACEHOLDERCOLOR = @"PlaceholderColor";
static NSString *const PLACEHOLDERINTERNALSTRING = @"PlaceholderInternalString";


@implementation UITextView (MIExtension)

- (void)setPlaceholder:(NSString *)placeholder
{
    [self setObject:placeholder forKey:PLACEHOLDERSTRING];
    [self addDelegate:[DelegateObserver sharedInstance]];
    [self addObserver];
    [self updatePlaceHolderLabel:YES];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    [self setObject:placeholderColor forKey:PLACEHOLDERCOLOR];
    [self addDelegate:[DelegateObserver sharedInstance]];
    [self addObserver];
    [self updatePlaceHolderLabel:YES];
}

#pragma mark - UITextView Delegates

-(void)addObserver
{
    [self removeObserver];
    [self addObserver:self forKeyPath:@"text" options:NSKeyValueChangeSetting context:nil];
}

-(void)removeObserver
{
    @try{

        [self removeObserver:self forKeyPath:@"text"];
        
    }@catch(id anException){
    }
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (!newSuperview)
    {
        [self removeObserver];
    }
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
 
    if (![self objectForKey:PLACEHOLDERCOLOR] && ![self objectForKey:PLACEHOLDERSTRING])
        return;
        
    UIColor *placeHolderColor = [self objectForKey:PLACEHOLDERCOLOR];
    
    if (!placeHolderColor)
        placeHolderColor = [self textColor];
    
    if (!placeHolderColor)
        placeHolderColor = [UIColor grayColor];
    
    if ([self objectForKey:PLACEHOLDERINTERNALSTRING] && ((NSString *)[self objectForKey:PLACEHOLDERINTERNALSTRING]).length>0)
    {
        if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)])
        {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.alignment = self.textAlignment;
            [[self objectForKey:PLACEHOLDERINTERNALSTRING] drawInRect:CGRectMake(5, 8 + self.contentInset.top, self.frame.size.width-self.contentInset.left, self.frame.size.height- self.contentInset.top) withAttributes:@{NSFontAttributeName:self.font, NSForegroundColorAttributeName:placeHolderColor, NSParagraphStyleAttributeName:paragraphStyle}];
        }
        else {      // deprecated in ios_7
            [placeHolderColor set];
            [[self objectForKey:PLACEHOLDERINTERNALSTRING] drawInRect:CGRectMake(8.0f, 8.0f, self.frame.size.width - 16.0f, self.frame.size.height - 16.0f) withFont:self.font];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object==self)
    {
        UITextView *textView = object;
        
        if (self==textView)
        {
            [self updatePlaceHolderLabel:YES];
        }
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self updatePlaceHolderLabel:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self updatePlaceHolderLabel:YES];
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self updatePlaceHolderLabel:YES];
}

-(void)updatePlaceHolderLabel:(BOOL)flag
{
    if (self.text.length==0 && flag)
        [self setObject:[self objectForKey:PLACEHOLDERSTRING] forKey:PLACEHOLDERINTERNALSTRING];
    else
        [self setObject:@"" forKey:PLACEHOLDERINTERNALSTRING];

	[self setNeedsDisplay];
}

@end
