//
//  ViewController.m
//  VerticalIntroScroll
//
//  Created by mac-0009 on 01/03/17.
//  Copyright © 2017 mac-0009. All rights reserved.
//

#import "TutorialScreenViewController.h"
#import "LandingViewController.h"

#define ButtonTag                           100
#define ViewTag                             200
#define ImageViewTag                        300
#define LabelTitleTag                       400

#define AnimationDuration                   0.7
#define AlphaOffset                         0.009

@interface TutorialScreenViewController ()
{
    NSArray *arrIntro;
    CGPoint initialContentOffset;
    
    NSInteger CurrentIndex;
    NSInteger NewIndex;
    
    UIImageView *imgVCurrent;
    UIImageView *imgVNext;
    UIImageView *imgVPrevious;
    
    NSLayoutConstraint *cnCeneterYCurrent;
    NSLayoutConstraint *cnCeneterYNext;
    NSLayoutConstraint *cnCeneterYPrevious;
    
    UILabel *lblTitleCurrent;
    UILabel *lblTitleNext;
    UILabel *lblTitlePrevious;
    
    int MinMaxOffset;
    
    UIPanGestureRecognizer *panGesture;
    UISwipeGestureRecognizer *upSwipeGesture;
    UISwipeGestureRecognizer *downSwipeGesture;
    BOOL isDragging, observingContentOffset;
}
@end

@implementation TutorialScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prefersStatusBarHidden];
    [self preferredStatusBarStyle];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    lblTitle1.text = @"Hold the mic button to record whatever\nyou want for a maximum of 20 seconds";
    lblTitle2.text = @"Like, dislike or set to default by\nclicking on the heart icon";
    
    NSMutableAttributedString *strTitle3 = [[NSMutableAttributedString alloc] initWithString:@"Click on the wave to play a yuuud,\nclick again to stop it\n\nLong press to report if abusive content."];
    [strTitle3 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 34)];
    [strTitle3 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:NSMakeRange(34, strTitle3.length-34)];
    [strTitle3 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(strTitle3.length-40, 40)];
    lblTitle3.attributedText = strTitle3;
    
    lblTitle4.text = @"Swipe up to post your Yuuud after\nrecording, all while being anonymous";
    
    //lblTitle5.text = @"Swipe down to no longer be\nholding down the mic,\nhold and swipe up to unlock";
    
    NSMutableAttributedString *strTitle5 = [[NSMutableAttributedString alloc] initWithString:@"Swipe down to no longer be\nholding down the mic,\nhold and swipe up to unlock"];
    
    [strTitle5 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:NSMakeRange(0, 10)];
    [strTitle5 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(10, 49)];
    [strTitle5 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:NSMakeRange(49, strTitle5.length-72)];
    lblTitle5.attributedText = strTitle5;
    
//  Swipe down to no longer be holding down the mic,
    
    if (Is_iPhone_5)
    {
        imgView1.image = [UIImage imageNamed:@"mike_5s.png"];
        imgView2.image = [UIImage imageNamed:@"like_5s.png"];
    }
    
    if (Is_iPhone_6_PLUS)
    {
        imgView1.image = [UIImage imageNamed:@"mike_6P.png"];
        imgView2.image = [UIImage imageNamed:@"like_6P.png"];
    }
    
    imgView4.image = [UIImage imageNamed:@"send"];
    imgView5.image = [UIImage imageNamed:@"lock"];
    imgView3.image = [UIImage imageNamed:@"music1"];
    imgView6.image = [UIImage imageNamed:@"box"];
    
    MinMaxOffset = imgView1.frame.size.height / 2;
    
    upSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleUpSwipe:)];
    upSwipeGesture.delegate = self;
    upSwipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
    [scrollViewMain addGestureRecognizer:upSwipeGesture];
    
    downSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleDownSwipe:)];
    downSwipeGesture.delegate = self;
    downSwipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [scrollViewMain addGestureRecognizer:downSwipeGesture];
    
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGesture.maximumNumberOfTouches = 1;
    panGesture.delegate = self;
    [scrollViewMain addGestureRecognizer:panGesture];
    
    if (upSwipeGesture)
        [panGesture requireGestureRecognizerToFail:upSwipeGesture];
    if (downSwipeGesture)
        [panGesture requireGestureRecognizerToFail:downSwipeGesture];
    
    [viewButton2 hideByHeight:TRUE];
    [viewButton3 hideByHeight:TRUE];
    [viewButton4 hideByHeight:TRUE];
    [viewButton5 hideByHeight:TRUE];
    [viewButton6 hideByHeight:TRUE];
    
    imgView2.alpha = imgView3.alpha = imgView4.alpha = imgView5.alpha = imgView6.alpha = 0;
    lblTitle2.alpha = lblTitle3.alpha = lblTitle4.alpha = lblTitle5.alpha = lblTitle6.alpha = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!observingContentOffset)
    {
        [scrollViewMain addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        observingContentOffset = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (observingContentOffset)
    {
        [scrollViewMain removeObserver:self forKeyPath:@"contentOffset"];
        observingContentOffset = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark -
#pragma mark - Swipe Gesture Delegate

- (void)handleUpSwipe:(UISwipeGestureRecognizer *)sender
{
//    [sender requireGestureRecognizerToFail:panGesture];
    if (!isDragging)
    {
        if (CurrentIndex != 5)
        {
            [self panGestureBeginWithCoordinate:CGPointZero andCurrentIndex:CurrentIndex++];
            [UIView animateWithDuration:AnimationDuration animations:^{
                
                [scrollViewMain setContentOffset:CGPointMake(0, CurrentIndex * CScreenHeight)];
                [self panGestureEnded];
            }];
        }
        
     //   [self btnNextClicked:nil];
    }
}

- (void)handleDownSwipe:(UISwipeGestureRecognizer *)sender
{
//  [sender requireGestureRecognizerToFail:panGesture];
    
    if (!isDragging)
    {
        if (CurrentIndex != 0)
        {
            [self panGestureBeginWithCoordinate:CGPointZero andCurrentIndex:CurrentIndex--];
            [UIView animateWithDuration:AnimationDuration animations:^{
                
                [scrollViewMain setContentOffset:CGPointMake(0, CurrentIndex * CScreenHeight)];
                [self panGestureEnded];
            }];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
//    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] || [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
//        return NO;
    
//    if ([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]] &&
//        [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
//        return NO;
//    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]] &&
        [otherGestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]])
    {
        isDragging = FALSE;
        return YES;
    }
    isDragging = TRUE;
    return NO;
}


#pragma mark
#pragma mark - Pan Gesture Delegate

- (void)handlePan:(UIPanGestureRecognizer *)sender
{
    switch (sender.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            initialContentOffset = scrollViewMain.contentOffset;
            CurrentIndex = round(scrollViewMain.contentOffset.y  / CScreenHeight);
            [self panGestureBeginWithCoordinate:[sender locationInView:scrollViewMain] andCurrentIndex:CurrentIndex];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            isDragging = TRUE;
            [self panGestureChangeWithCoordinate:[sender translationInView:scrollViewMain]];
            [sender setTranslation:CGPointMake(0, 0) inView:scrollViewMain];
            break;
        }
        default:
        {
            isDragging = NO;
            [self panGestureEnded];
            break;
        }
    }
}

- (void)panGestureBeginWithCoordinate:(CGPoint)coordinate andCurrentIndex:(NSInteger)currentIndex
{
    UIView *viewCurrent = [scrollViewMain viewWithTag:ViewTag + CurrentIndex];
    imgVCurrent = [viewCurrent viewWithTag:ImageViewTag + CurrentIndex];
    lblTitleCurrent = [viewCurrent viewWithTag:LabelTitleTag + CurrentIndex];
    
    if (imgVCurrent)
    {
        NSArray *arrConstraint = [imgVCurrent.superview.constraints filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", @"centerY"]];
        
        if (arrConstraint.count)
            cnCeneterYCurrent = arrConstraint[0];
    }
    
    UIView *viewNext = [scrollViewMain viewWithTag:ViewTag + CurrentIndex + 1];
    imgVNext = [viewNext viewWithTag:ImageViewTag + CurrentIndex + 1];
    lblTitleNext = [viewNext viewWithTag:LabelTitleTag + CurrentIndex + 1];
    
    if (imgVNext)
    {
        NSArray *arrConstraint = [imgVNext.superview.constraints filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", @"centerY"]];
        
        if (arrConstraint.count)
            cnCeneterYNext = arrConstraint[0];
    }
    
    UIView *viewPrevious = [scrollViewMain viewWithTag:ViewTag + CurrentIndex - 1];
    imgVPrevious = [viewPrevious viewWithTag:ImageViewTag + CurrentIndex - 1];
    lblTitlePrevious = [viewPrevious viewWithTag:LabelTitleTag + CurrentIndex - 1];
    
    if (imgVPrevious)
    {
        NSArray *arrConstraint = [imgVPrevious.superview.constraints filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", @"centerY"]];
        
        if (arrConstraint.count)
            cnCeneterYPrevious = arrConstraint[0];
    }
}

- (void)panGestureChangeWithCoordinate:(CGPoint)coordinate
{
    CGPoint newOffset = CGPointMake(scrollViewMain.contentOffset.x, scrollViewMain.contentOffset.y - coordinate.y);
    
    if (newOffset.y > 0 && (newOffset.y < (CScreenHeight*6) - CScreenHeight))
        [scrollViewMain setContentOffset:newOffset];
}

- (void)panGestureEnded
{
    NewIndex = round(scrollViewMain.contentOffset.y  / CScreenHeight);
    
    CGFloat fCurrentAlpha = 1;
    CGFloat fNextAlpha = 0;
    CGFloat fPreviousAlpha = 0;
    
    CGFloat fCurrent = 0;
    CGFloat fNext = MinMaxOffset;
    CGFloat fPrevious = -MinMaxOffset;
    
    if (NewIndex > CurrentIndex)
    {
        fCurrent = -MinMaxOffset;
        fNext = 0;
        fPrevious = -MinMaxOffset;
        
        fCurrentAlpha = 0;
        fNextAlpha = 1;
        fPreviousAlpha = 0;
    }
    else if(NewIndex < CurrentIndex)
    {
        fCurrent = MinMaxOffset;
        fNext = MinMaxOffset;
        fPrevious = 0;
        
        fCurrentAlpha = 0;
        fNextAlpha = 0;
        fPreviousAlpha = 1;
    }
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:AnimationDuration animations:^{
        
        [scrollViewMain setContentOffset:CGPointMake(0, NewIndex * CScreenHeight)];
        
        if (cnCeneterYCurrent)
        {
            cnCeneterYCurrent.constant = fCurrent;
            [imgVCurrent.superview layoutIfNeeded];
        }
        if (cnCeneterYNext)
        {
            cnCeneterYNext.constant = fNext;
            [imgVNext.superview layoutIfNeeded];
        }
        if (cnCeneterYPrevious)
        {
            cnCeneterYPrevious.constant = fPrevious;
            [imgVPrevious.superview layoutIfNeeded];
        }
        
        if (imgVCurrent)
            imgVCurrent.alpha = fCurrentAlpha;
        if (imgVNext)
            imgVNext.alpha = fNextAlpha;
        if (imgVPrevious)
            imgVPrevious.alpha = fPreviousAlpha;
        
        if (lblTitleCurrent)
            lblTitleCurrent.alpha = fCurrentAlpha;
        if (lblTitleNext)
            lblTitleNext.alpha = fNextAlpha;
        if (lblTitlePrevious)
            lblTitlePrevious.alpha = fPreviousAlpha;
        
        btnSkip.hidden = NewIndex == 5;
        if (NewIndex == 5)
        {
            [btnNext setTitle:@"DONE" forState:UIControlStateNormal];
        }
        else
            [btnNext setTitle:@"NEXT" forState:UIControlStateNormal];
        
        [viewButton1 hideByHeight:TRUE];
        [viewButton2 hideByHeight:TRUE];
        [viewButton3 hideByHeight:TRUE];
        [viewButton4 hideByHeight:TRUE];
        [viewButton5 hideByHeight:TRUE];
        [viewButton6 hideByHeight:TRUE];
        
        UIView *viewButton = [self.view viewWithTag:ButtonTag + NewIndex];
        
        [viewButton hideByHeight:NO];
        [viewButton.superview layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        CurrentIndex = NewIndex;
        cnCeneterYCurrent = cnCeneterYNext = cnCeneterYPrevious = nil;
        imgVCurrent = imgVNext = imgVPrevious = nil;
        lblTitleCurrent = lblTitleNext = lblTitlePrevious = nil;
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
    }];
}

#pragma mark -
#pragma mark - Observer for Scroll Content Offset

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        if (initialContentOffset.y < scrollViewMain.contentOffset.y)
        {
            if (imgVCurrent)
                imgVCurrent.alpha = MAX(imgVCurrent.alpha - AlphaOffset, 0);
            if (imgVNext && imgVCurrent.alpha == 0)
                imgVNext.alpha = MIN(imgVNext.alpha + AlphaOffset, 1);
            
            if (lblTitleCurrent)
                lblTitleCurrent.alpha = MAX(lblTitleCurrent.alpha - AlphaOffset, 0);
            if (lblTitleNext && lblTitleCurrent.alpha == 0)
                lblTitleNext.alpha = MIN(lblTitleNext.alpha + AlphaOffset, 1);
            
            if (cnCeneterYCurrent)
            {
                cnCeneterYCurrent.constant = (scrollViewMain.contentOffset.y > initialContentOffset.y) ? cnCeneterYCurrent.constant - 1 : cnCeneterYCurrent.constant + 1;
                cnCeneterYCurrent.constant = MAX(cnCeneterYCurrent.constant, -MinMaxOffset);
            }
            
            if (cnCeneterYNext)
            {
                cnCeneterYNext.constant = (scrollViewMain.contentOffset.y > initialContentOffset.y) ? cnCeneterYNext.constant - 1 : cnCeneterYNext.constant + 1;
                cnCeneterYNext.constant = MIN(cnCeneterYNext.constant, MinMaxOffset);
            }
        }
        else
        {
            if (imgVCurrent)
                imgVCurrent.alpha = MAX(imgVCurrent.alpha - AlphaOffset, 0);
            if (imgVPrevious && imgVCurrent.alpha == 0)
                imgVPrevious.alpha = MIN(imgVPrevious.alpha + AlphaOffset, 1);
            
            if (lblTitleCurrent)
                lblTitleCurrent.alpha = MAX(lblTitleCurrent.alpha - AlphaOffset, 0);
            if (lblTitlePrevious && lblTitleCurrent.alpha == 0)
                lblTitlePrevious.alpha = MIN(lblTitlePrevious.alpha + AlphaOffset, 1);
            
            if (cnCeneterYCurrent)
            {
                cnCeneterYCurrent.constant = (scrollViewMain.contentOffset.y > initialContentOffset.y) ? cnCeneterYCurrent.constant - 1 : cnCeneterYCurrent.constant + 1;
                cnCeneterYCurrent.constant = MAX(cnCeneterYCurrent.constant, -MinMaxOffset);
            }
            
            if (cnCeneterYPrevious)
            {
                cnCeneterYPrevious.constant = (scrollViewMain.contentOffset.y > initialContentOffset.y) ? cnCeneterYPrevious.constant - 1 : cnCeneterYPrevious.constant + 1;
                cnCeneterYPrevious.constant = MIN(cnCeneterYPrevious.constant, MinMaxOffset);
            }
        }
    }
}

#pragma mark
#pragma mark - Action Event

- (IBAction)btnSkipClicked:(UIButton *)sender
{
    if (CurrentIndex != 5)
    {
        CurrentIndex = 5;
        [self panGestureBeginWithCoordinate:CGPointZero andCurrentIndex:CurrentIndex];
        [UIView animateWithDuration:AnimationDuration animations:^{
            [scrollViewMain setContentOffset:CGPointMake(0, CurrentIndex * CScreenHeight)];
            [self panGestureEnded];
        }];
    }
}

- (IBAction)btnNextClicked:(UIButton *)sender
{
    if (CurrentIndex != 5)
    {
        [self panGestureBeginWithCoordinate:CGPointZero andCurrentIndex:CurrentIndex++];
        [UIView animateWithDuration:AnimationDuration animations:^{
            
            [scrollViewMain setContentOffset:CGPointMake(0, CurrentIndex * CScreenHeight)];
            [self panGestureEnded];
        }];
    }
    else
    {
        if(self.isFromSettings)
        {
            [self.navigationController popViewControllerAnimated:NO];
        }
        else
        {
            LandingViewController *objLanding = [LandingViewController initWithXib];
            SuperNavigationController *objSuperLanding = [[SuperNavigationController alloc] initWithRootViewController:objLanding];
            [self presentViewController:objSuperLanding animated:NO completion:nil];
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
    {
//        [panGesture requireGestureRecognizerToFail:upSwipeGesture];
//        [panGesture requireGestureRecognizerToFail:downSwipeGesture];
        
        
        
    }
    else if([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]])
    {
//        [upSwipeGesture requireGestureRecognizerToFail:panGesture];
//        [downSwipeGesture requireGestureRecognizerToFail:panGesture];
    }
    
    return YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

@end
