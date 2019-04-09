/*
 * This file is part of the JTTargetActionBlock package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIControl+JTTargetActionBlock.h"
#import <objc/runtime.h>

#import "NSObject+NewProperty.h"

@interface UIControlEventWrapper : NSObject
@property (nonatomic, assign) UIControlEvents controlEvent;
@property (nonatomic, copy)   UIControlEventHandler handler;
@end

@implementation UIControlEventWrapper
@synthesize controlEvent, handler;
- (void)sender:(id)sender forEvent:(UIEvent *)event {
    if (self.handler) {
        self.handler(sender, event);
    }
}
@end

@implementation UIControl (JTTargetActionBlock)

//static char *eventWrapperKey;
//
//- (NSMutableDictionary *)eventWrappers {
//    NSMutableDictionary *wrappers = objc_getAssociatedObject(self, &eventWrapperKey);
//    if ( ! wrappers) {
//        wrappers = [NSMutableDictionary dictionary];
//        objc_setAssociatedObject(self, &eventWrapperKey, wrappers, OBJC_ASSOCIATION_RETAIN);
//    }
//    return wrappers;
//}

- (void)addEventHandler:(UIControlEventHandler)handler forControlEvent:(UIControlEvents)controlEvent {

    UIControlEventWrapper *wrapper = [self objectForKey:[NSString stringWithFormat:@"UIControlEvents%lu",(unsigned long)controlEvent]];
    
    if (!wrapper)
    {
        wrapper = [[UIControlEventWrapper alloc] init];
        [self addTarget:wrapper action:@selector(sender:forEvent:) forControlEvents:controlEvent];
        [self setObject:wrapper forKey:[NSString stringWithFormat:@"UIControlEvents%lu",(unsigned long)controlEvent]];
        wrapper.controlEvent = controlEvent;
    }
    
    wrapper.handler = handler;
}

//- (void)removeEventHandlersForControlEvent:(UIControlEvents)controlEvent {
//    __block __weak UIControl *weakSelf = self;
//    [[[self eventWrappers] allKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
//        UIControlEventWrapper *wrapper = [[self eventWrappers] objectForKey:key];
//        if (wrapper.controlEvent == controlEvent) {
//            [weakSelf removeTarget:wrapper action:NULL forControlEvents:controlEvent];
//        }
//        
//        [[self eventWrappers] removeObjectForKey:key];
//    }];
//}

@end
