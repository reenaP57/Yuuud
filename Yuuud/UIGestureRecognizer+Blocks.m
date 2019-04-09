//
//  UIGestureRecognizer+Blocks.m
//  
//
//  Created by Mehul Rajput on 06/08/15.
//
//

#import "UIGestureRecognizer+Blocks.h"

#import "NSObject+NewProperty.h"

static NSString *const GESTUREEVENTHANDLER = @"gestureEventHandler";


@implementation UIGestureRecognizer (Blocks)

-(void)addTargetBlock:(MIVoidBlock)block
{
    [self setObject:block forKey:GESTUREEVENTHANDLER];
    [self addTarget:self action:@selector(gesturerecognizerFired:)];
}

-(void)gesturerecognizerFired:(UIGestureRecognizer*)recognizer
{
    MIVoidBlock block = [self objectForKey:GESTUREEVENTHANDLER];
    block();
}


@end
