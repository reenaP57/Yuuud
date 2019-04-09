//
//  UIView+AutoLayoutConstraints.m
//
//  Created by Jignesh-mac0007 on 22/07/15.
//  Copyright (c) 2015 mac-0007. All rights reserved.
//

#import "UIView+AutoLayoutConstraints.h"
#import <objc/runtime.h>

#define IOS8_OR_LATER   (((NSUInteger)[[[UIDevice currentDevice] systemVersion] doubleValue]) >= 8)

static char kAspectRatioConstraint;
static char kConflictedConstraints;

@implementation UIView (AutoLayoutConstraints)


#pragma mark -
#pragma mark - Public.

- (void)hideByHeight:(BOOL)hidden
{
    [self hideView:hidden forAttribute:NSLayoutAttributeHeight];
}

- (void)hideByWidth:(BOOL)hidden
{
    [self hideView:hidden forAttribute:NSLayoutAttributeWidth];
}

- (BOOL)setConstraintConstant:(CGFloat)constant toAutoLayoutEdge:(ALEdge)edge toAncestor:(BOOL)ancestor
{
    NSArray *arrConstraints = ancestor?self.superview.constraints:self.constraints;
    NSArray *arrFiltered;
    
    if (arrConstraints.count > 0)
    {
        arrFiltered = [arrConstraints filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(firstItem = %@ && firstAttribute = %d) || (secondItem = %@ && secondAttribute = %d)", self, edge, self, edge]];
    }
    
    if(arrFiltered.count > 0)
    {
        [arrFiltered enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL * _Nonnull stop)
         {
             constraint.constant = constant;
         }];
        
        [self.superview updateConstraintsIfNeeded];
        return YES;
    }
    else
    {
        return NO;
    }
}



#pragma mark -
#pragma mark - Private.

- (void)hideView:(BOOL)hidden forAttribute:(NSLayoutAttribute)layoutAttribute
{
    if (self.hidden != hidden)
    {
        if (hidden)
        {
            NSLayoutConstraint *cConstraint = [self constraintForLayoutAttribute:layoutAttribute];
            
            if (cConstraint)
                self.alpha = cConstraint.constant;
            else
            {
                CGSize size = [self getSize];
                self.alpha = (layoutAttribute == NSLayoutAttributeHeight)?size.height:size.width;
            }
            
            [self saveAndRemoveConflictedConstraintsForLayoutAttribute:layoutAttribute];
            [self setConstraintConstant:0 forLayoutAttribute:layoutAttribute];
            
            self.hidden = YES;
            
        }
        else
        {
            [self setConstraintConstant:self.alpha forLayoutAttribute:layoutAttribute];
            [self assignSavedConflictedConstraintsForLayoutAttribute:layoutAttribute];
            
            self.alpha = 1;
            self.hidden = NO;
        }
    }
}

- (BOOL)setConstraintConstant:(CGFloat)constant forLayoutAttribute:(NSLayoutAttribute)layoutAttribute
{
    NSLayoutConstraint *constraint = [self constraintForLayoutAttribute:layoutAttribute];
    if(constraint)
    {
        [constraint setConstant:constant];
        return YES;
    }
    else
    {
        [self addConstraint: [NSLayoutConstraint constraintWithItem:self attribute:layoutAttribute relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:constant]];
        return NO;
    }
}


- (CGFloat)constantforLayoutAttribute:(NSLayoutAttribute)layoutAttribute
{
    NSLayoutConstraint *constraint = [self constraintForLayoutAttribute:layoutAttribute];
    
    if (constraint)
        return constraint.constant;
    else
        return NAN;
}


- (NSLayoutConstraint *)constraintForLayoutAttribute:(NSLayoutAttribute)layoutAttribute
{
    NSArray *arrFiltered = [self.constraints filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"firstAttribute = %d && firstItem = %@ && secondAttribute = %d && secondItem == %@ && class != %@", layoutAttribute, self, NSLayoutAttributeNotAnAttribute, nil, NSClassFromString(@"NSContentSizeLayoutConstraint")]];
    
    if(arrFiltered.count == 0)
        return nil;
    else
        return arrFiltered.lastObject;
}

- (NSLayoutConstraint *)constraintForAspectRatio
{
    NSArray *arrFiltered = [self.constraints filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"firstItem = %@ && secondItem = %@ && firstAttribute != secondAttribute", self, self]];
    
    if(arrFiltered.count == 0)
        return nil;
    else
        return arrFiltered.lastObject;
}


#pragma mark -
#pragma mark - Save/Remove constraints

- (void)saveAndRemoveConflictedConstraintsForLayoutAttribute:(NSLayoutAttribute)layoutAttribute
{
    // Store consraint with bottom if self will be hide for height ORRR..
    // Store consraint with right/trailing if self will be hide for width
    
    NSArray *arrConstraints;
    
    if (layoutAttribute == NSLayoutAttributeHeight)
    {
        arrConstraints = [self.constraints filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"firstAttribute = %d && secondAttribute = %d", NSLayoutAttributeBottom, NSLayoutAttributeBottom]];
    }
    else
    {
        arrConstraints = [self.constraints filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(firstAttribute = %d || firstAttribute = %d) && (secondAttribute = %d || secondAttribute = %d)", NSLayoutAttributeRight, NSLayoutAttributeTrailing, NSLayoutAttributeRight, NSLayoutAttributeTrailing]];
    }
    
    if (arrConstraints.count > 0)
    {
        [self saveConflictedConstraints:arrConstraints];
        
        if (IOS8_OR_LATER)
            [NSLayoutConstraint deactivateConstraints:arrConstraints];
        else
            [self removeConstraints:arrConstraints];
    }
    
    
    // Check Aspect Ratio Constraint
    NSLayoutConstraint *aspectRatio = [self constraintForAspectRatio];
    
    if (aspectRatio)
    {
        [self saveAspectRatioConstraint:aspectRatio];
        
        if (IOS8_OR_LATER)
            [aspectRatio setActive:NO];
        else
            [self removeConstraint:aspectRatio];
    }
}

- (void)assignSavedConflictedConstraintsForLayoutAttribute:(NSLayoutAttribute)layoutAttribute
{
    NSArray *arrConstraints = [self conflictedConstraints];
    
    if (arrConstraints.count > 0)
    {
        if (IOS8_OR_LATER)
            [NSLayoutConstraint activateConstraints:arrConstraints];
        else
            [self addConstraints:arrConstraints];
        
        [self saveConflictedConstraints:nil];
    }
    
    if ([self aspectRatioConstraint])
    {
        NSLayoutConstraint *attributeConstraint = [self constraintForLayoutAttribute:layoutAttribute];
        if (attributeConstraint)
        {
            if (IOS8_OR_LATER)
                [attributeConstraint setActive:NO];
            else
                [self removeConstraint:attributeConstraint];
        }
        
        if (IOS8_OR_LATER)
            [[self aspectRatioConstraint] setActive:YES];
        else
            [self addConstraint:[self aspectRatioConstraint]];
        
        [self saveAspectRatioConstraint:nil];
    }
    else
    {
        CGSize size = [self fittingSystemLayoutSize];
        CGFloat constant = (layoutAttribute == NSLayoutAttributeHeight)?size.height:size.width;
        [self setConstraintConstant:constant forLayoutAttribute:layoutAttribute];
    }
}

- (void)saveAspectRatioConstraint:(NSLayoutConstraint *)constraint
{
    objc_setAssociatedObject(self, &kAspectRatioConstraint, constraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)aspectRatioConstraint
{
    return objc_getAssociatedObject(self, &kAspectRatioConstraint);
}

- (void)saveConflictedConstraints:(NSArray *)arrConstraints
{
    objc_setAssociatedObject(self, &kConflictedConstraints, arrConstraints, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)conflictedConstraints
{
    return objc_getAssociatedObject(self, &kConflictedConstraints);
}


#pragma mark -
#pragma mark - Update Layout

- (CGSize)getSize
{
    return CGSizeMake(self.bounds.size.width, self.bounds.size.height);
}

- (void)updateLayout
{
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (CGSize)fittingSystemLayoutSize
{
    [self updateLayout];
    
    return [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}




@end
