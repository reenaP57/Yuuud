//
//  UIView+MIExtension.m
//  VLB
//
//  Created by mac-0001 on 7/10/14.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import "UIView+MIExtension.h"

#import "NSObject+NewProperty.h"

@implementation UIView (MIExtension)

+(id)loadOrInitializeView
{
    id view = [self viewFromXib];
    
    if(!view)
        view = [[[self class] alloc] init];

    return view;
}

+(id)viewFromXib
{
    return [self viewWithNibName:NSStringFromClass(self)];
}

+(id)viewWithNibName:(NSString*)nibName
{
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    if ([bundle count])
    {
        UIView *view = [bundle objectAtIndex:0];
        if ([view isKindOfClass:self])
        {
            return view;
        }
        NSLog(@"The object in the nib %@ is a %@, not a %@", nibName, [view class], self);
    }
    return nil;
}

- (UIViewController*)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController*)nextResponder;
        }
    }
    
    return nil;
}


-(void)removeAllSubviews
{
    for (UIView *temp in self.subviews)
    {
        [temp removeAllSubviews];
        
        [temp removeFromSuperview];
    }
}

-(void)removeAllSubviewsOfClass:(NSString *)class
{
    for (UIView *temp in self.subviews)
    {
        [temp removeAllSubviewsOfClass:class];
        
        if (class && [temp isKindOfClass:NSClassFromString(@"UIButton")])
            [temp removeFromSuperview];
    }
}

-(void)removeAllSubviewsOfTag:(NSInteger)tag
{
    for (UIView *temp in self.subviews)
    {
        [temp removeAllSubviewsOfTag:tag];
        
        
        if (tag && temp.tag == tag)
            [temp removeFromSuperview];
    }
}


-(void)addBorder:(UIPosition)position color:(UIColor *)color width:(CGFloat)width
{
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;

    switch (position)
    {
        case 0:
            border.frame = CGRectMake(0, 0, self.frame.size.width, width);
            break;
        case 1:
            border.frame = CGRectMake(0, self.frame.size.height - width, self.frame.size.width, width);
            break;
        case 2:
            border.frame = CGRectMake(0, 0, width, self.frame.size.height);
            break;
        case 3:
            border.frame = CGRectMake(self.frame.size.width-width, 0, width, self.frame.size.height);
            break;
        default:
            border.frame = CGRectMake(self.frame.size.width - width, 0, width, self.frame.size.height);
            break;
    }
    
    [self.layer addSublayer:border];
}


- (void)addBlurViewWithStyle:(NSInteger)blurStyle
{
    UIView *blurView = nil;
    
    if(NSClassFromString(@"UIBlurEffect"))
    { // iOS 8
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:blurStyle];
        blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurView.frame = self.frame;
    }
    else
    { // workaround for iOS 7
        blurView = [[UIToolbar alloc] initWithFrame:self.bounds];
    }
    
    [blurView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addSubview:blurView];
    
    [self setObject:blurView forKey:@"blurView"];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[blurView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(blurView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[blurView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(blurView)]];
}

- (void)removeBlurView
{
    UIView *blurView = [self objectForKey:@"blurView"];
    
    if (blurView)
        [blurView removeFromSuperview];
}

@end
