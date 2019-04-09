//
//  Copyright © 2012 BeauxApps, LLC
//

#import "UIViewController+ADVOverlay.h"

#import "NSObject+NewProperty.h"


static NSString *const ADVOverlayViewControllerKey = @"ADVOverlayViewControllerKey";

static const NSTimeInterval AnimationDuration = 0.3;

@implementation UIViewController (ADVOverlay)

- (void) presentOverlayViewController:(UIViewController *)controller
                             animated:(BOOL)animated
                           completion:(MIVoidBlock)completion
{
    UIViewController *overlayViewController = [self objectForKey:ADVOverlayViewControllerKey];
    if (overlayViewController) [self dismissOverlayViewControllerAnimated:NO completion:nil];

    
    [self setObject:controller forKey:ADVOverlayViewControllerKey];
    
    [self addChildViewController:controller];
    controller.view.frame = self.view.bounds;
    
    [self viewWillDisappear:animated];
    [controller viewWillAppear:animated];
    
    [UIView transitionWithView:self.view duration:animated ? AnimationDuration : 0 options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self.view addSubview:controller.view];
    } completion:^(BOOL finished) {
        
        [controller didMoveToParentViewController:self];
        
        [self viewDidDisappear:animated];
        [controller viewDidAppear:animated];
        
        if (completion) completion();
    }];
}

- (void) dismissOverlayViewControllerAnimated:(BOOL)animated completion:(MIVoidBlock)completion
{
    UIViewController *controller = [self objectForKey:ADVOverlayViewControllerKey];
    if (controller)
    {
        UIViewController *parentViewController = controller.parentViewController;
        
        [controller willMoveToParentViewController:nil];

        [controller viewWillDisappear:animated];
        [parentViewController viewWillAppear:animated];
        
        [UIView transitionWithView:self.view duration:animated ? AnimationDuration : 0 options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [controller.view removeFromSuperview];
        } completion:^(BOOL finished) {
            [controller removeFromParentViewController];
            [self setObject:nil forKey:ADVOverlayViewControllerKey];
            
            [controller viewDidDisappear:animated];
            [parentViewController viewDidAppear:animated];
            
            if (completion) completion();
        }];
    }
}

-(PopUpViewController *)presentViewWithOutsideClickedDisable:(UIView *)view
{
    return [self presentViewOnPopUpViewController:view shouldClickOutside:NO dismissed:nil];
}

-(PopUpViewController *)presentView:(UIView *)view
{
    return [self presentViewOnPopUpViewController:view shouldClickOutside:YES dismissed:nil];
}

-(PopUpViewController *)presentView:(UIView *)view shouldHideOnOutsideClick:(BOOL)shouldHideOnOutsideClick
{
    return [self presentViewOnPopUpViewController:view shouldClickOutside:shouldHideOnOutsideClick dismissed:nil];
}

-(PopUpViewController *)presentView:(UIView *)view dismissed:(MIVoidBlock)completion
{
   return [self presentViewOnPopUpViewController:view shouldClickOutside:YES dismissed:completion];
}

-(PopUpViewController *)presentViewOnPopUpViewController:(UIView *)view shouldClickOutside:(BOOL)click dismissed:(MIVoidBlock)completion
{
    PopUpViewController *objPopUp = [[PopUpViewController alloc] init];
    objPopUp.shouldHideOnOutsideClick = click;
    [objPopUp.view addSubview:view];
    [self presentOverlayViewController:objPopUp animated:YES completion:nil];
    
    [objPopUp setCloseHandler:^(BOOL animated)
     {
         [self dismissOverlayViewControllerAnimated:YES completion:completion];
     }];
    
    return objPopUp;
}

@end
