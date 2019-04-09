//
//  SuperViewController.m
//  ChamRDV
//
//  Created by mac-0005 on 12/21/13.
//  Copyright (c) 2013 MIND INVENTORY. All rights reserved.
//

#import "SuperViewController.h"


@interface SuperViewController ()
{
    BOOL pullToRefresh, shouldUpdate, shouldPlaySound, isUpdating, dragging;
    CGFloat lastScrollOffset;
    NSOperationQueue *queue;
    float offset;
}
@end

@implementation SuperViewController

//@synthesize pickerDataSource,dicPickerDataSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self prefersStatusBarHidden];
    [self preferredStatusBarStyle];
    
    dragging = NO;
//    pullToRefresh = NO;
    
//    [self.navigationController.navigationBar.topItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
    
//    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, -5, 0); // or (0, 0, -10.0, 0)
//    UIImage *alignedImage = [[UIImage imageNamed:@"ic_Btnback"] imageWithAlignmentRectInsets:insets];
//    [alignedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [self.navigationController.navigationBar setBackIndicatorImage:alignedImage];

    if (pullToRefresh)
        [self initializePullToRefresh];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Pull To Refresh

-(void)initializePullToRefresh
{
    //////// pull to refresh
    
    updateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -40, 320, 20)];
	updateLabel.textAlignment = NSTextAlignmentCenter;
	updateLabel.text = @"Pull down to refresh...";
	updateLabel.textColor = [UIColor darkGrayColor];
	updateLabel.backgroundColor = [UIColor clearColor];
	
	lastUpdateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -20, 320, 20)];
	lastUpdateLabel.textAlignment = NSTextAlignmentCenter;
	lastUpdateLabel.textColor = [UIColor darkGrayColor];
	lastUpdateLabel.backgroundColor = [UIColor clearColor];
	lastUpdateLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
    
    NSString *documentsFolderPath = [CCachesDirectory stringByAppendingPathComponent:fileStorageName];
    
	lastUpdateLabel.text = [NSString stringWithContentsOfFile:documentsFolderPath encoding:NSStringEncodingConversionAllowLossy error:nil];
	
    if (superTable)
    {
        [superTable addSubview:updateImageView];
        [superTable addSubview:updateImageViewPng];
    }
    else
    {
        [superCollectionview addSubview:updateImageView];
        [superCollectionview addSubview:updateImageViewPng];
    }
    
    updateImageView.hidden = YES;
    updateImageViewPng.hidden = NO;
    
	shouldUpdate = NO;
	shouldPlaySound = NO;
	isUpdating = NO;

    
}

- (void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(CGPoint *)ltargetContentOffset
{
    dragging = NO;
    
	if (shouldUpdate)
    {
		queue = [NSOperationQueue new];
		NSInvocationOperation *updateOperation = [[NSInvocationOperation alloc] initWithTarget:self  selector:@selector(updateMethod)  object:nil];
		[queue addOperation:updateOperation];
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		superTable.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
		superCollectionview.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
		[UIView commitAnimations];
	}
    
    if (ltargetContentOffset->y>=scrollView.contentSize.height-240-scrollView.frame.size.height && ltargetContentOffset->y<scrollView.contentOffset.y)
        [self loadMoreData];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (sender.contentOffset.y>0)
        spinner.hidden = YES;
    else
        spinner.hidden = NO;
    
    if (sender.isDragging && sender.contentOffset.y>=sender.contentSize.height-240-sender.frame.size.height && lastScrollOffset<sender.contentOffset.y && !dragging)
    {
        dragging = YES;
        [self loadMoreData];
    }
    
    lastScrollOffset = sender.contentOffset.y;
    
    if (pullToRefresh)
    {
        if (superTable)
            offset = superTable.contentOffset.y;
        else
            offset = superCollectionview.contentOffset.y;
        
        offset *= -1;
    
        if (offset > 0 && offset < 60)
        {
            if(!isUpdating)
                updateLabel.text = @"Pull to Reload";
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.2];
            updateImageViewPng.transform = CGAffineTransformMakeRotation(0);
            [UIView commitAnimations];
            shouldUpdate = NO;
        }
        
        if (offset >= 60)
        {
            if(!isUpdating)
                updateLabel.text = @"Release to Reload";
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.2];
            updateImageViewPng.transform = CGAffineTransformMakeRotation(3.14159265);
            [UIView commitAnimations];
            shouldUpdate = YES;
            shouldPlaySound = YES;
        }
        
        if (isUpdating)
            shouldUpdate = NO;
    }
}

- (void) setUpdateDate
{
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    NSDate *now = [[NSDate alloc] init];
	NSString *dateString = [dateFormat stringFromDate:now];
	NSString *objectString = [[NSString alloc] initWithFormat:@"%@ %@",@"Last updated on",dateString];
	lastUpdateLabel.text = objectString;
	NSString *documentsFolderPath = [CCachesDirectory stringByAppendingPathComponent:fileStorageName];
	[objectString writeToFile:documentsFolderPath atomically:YES encoding:NSStringEncodingConversionAllowLossy error:nil];
}

- (void) stopSpinner
{
	[spinner removeFromSuperview];
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.2];
    
    if (superTable)
        superTable.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    else
        superCollectionview.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
	[UIView commitAnimations];
    
	isUpdating = NO;
    updateImageViewPng.hidden = NO;
    updateImageView.hidden = YES;
}

- (void) startSpinner
{
	spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	spinner.color = [UIColor lightGrayColor];
    
    if (superTable)
        spinner.frame = CGRectMake(40, superTable.frame.origin.y+15, 40, 40);
    else
        spinner.frame = CGRectMake(40, superCollectionview.frame.origin.y+15, 40, 40);
    
    updateImageViewPng.hidden = YES;
    updateImageView.hidden = NO;
	[spinner startAnimating];
    
	updateLabel.text = @"Updating...";
	isUpdating = YES;
}

- (void)refreshData
{
    
}

- (void)loadMoreData
{
    
}

- (void)updateMethod
{
    [self refreshData];
	[self performSelectorOnMainThread:@selector(startSpinner) withObject:nil waitUntilDone:NO];
}

- (void)stopUpdating
{
	[self performSelectorOnMainThread:@selector(stopSpinner) withObject:nil waitUntilDone:NO];
    [self setUpdateDate];
}

- (void) playAudioWithAudioFileName:(NSString *) filePath
{
}





@end
