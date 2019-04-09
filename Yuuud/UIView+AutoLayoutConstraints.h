//
//  UIView+AutoLayoutConstraints.h
//
//  Created by Jignesh-mac0007 on 22/07/15.
//  Copyright (c) 2015 mac-0007. All rights reserved.
//

#import <UIKit/UIKit.h>

/** Constants that represent edges of a view. */
typedef NS_ENUM(NSInteger, ALEdge)
{
    /** The left edge of the view. */
    ALEdgeLeft = NSLayoutAttributeLeft ,
    
    /** The right edge of the view. */
    ALEdgeRight = NSLayoutAttributeRight,
    
    /** The top edge of the view. */
    ALEdgeTop = NSLayoutAttributeTop,
    
    /** The bottom edge of the view. */
    ALEdgeBottom = NSLayoutAttributeBottom,
    
    /** The leading edge of the view. */
    ALEdgeLeading = NSLayoutAttributeLeading,
    
    /** The trailing edge of the view. */
    ALEdgeTrailing = NSLayoutAttributeTrailing
};

@interface UIView (AutoLayoutConstraints)

/*!
 @abstract Hide view by height.
 */
- (void)hideByHeight:(BOOL)hidden;


/*!
 @abstract Hide view by width.
 */
- (void)hideByWidth:(BOOL)hidden;


/*!
 @abstract Set constant to specific view edge constraint.
 @param constant Constraint contant value.
 @param edge Edge for which you want to set constant (e.g., ALEdgeLeft, ALEdgeTop).
 @param ancestor If constraint is paired with view and it's subview then ancestor = NO or else constraint is paired with view and it's superview or sibling view then ancestor = YES.
 */
- (BOOL)setConstraintConstant:(CGFloat)constant toAutoLayoutEdge:(ALEdge)edge toAncestor:(BOOL)ancestor;
@end
