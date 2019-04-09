//
//  Copyright © 2012 BeauxApps, LLC
//

#import <UIKit/UIKit.h>

#import "Master.h"

@interface UIViewController (ADVOverlay)

- (void) presentOverlayViewController:(UIViewController *)controller
                             animated:(BOOL)animated
                           completion:(MIVoidBlock)completion;

- (void) dismissOverlayViewControllerAnimated:(BOOL)animated
                                   completion:(MIVoidBlock)completion;



-(PopUpViewController *)presentView:(UIView *)view;
-(PopUpViewController *)presentView:(UIView *)view shouldHideOnOutsideClick:(BOOL)shouldHideOnOutsideClick;
-(PopUpViewController *)presentView:(UIView *)view dismissed:(MIVoidBlock)completion;
-(PopUpViewController *)presentViewWithOutsideClickedDisable:(UIView *)view;
-(PopUpViewController *)presentViewOnPopUpViewController:(UIView *)view shouldClickOutside:(BOOL)click dismissed:(MIVoidBlock)completion;


@end


