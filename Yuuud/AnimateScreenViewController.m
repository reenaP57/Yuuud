//
//  AnimateScreenViewController.m
//  MY_Audio_Demo
//
//  Created by mac-00015 on 2/21/17.
//  Copyright © 2017 mac-00012. All rights reserved.
//

#import "AnimateScreenViewController.h"
#import "RecordViewController.h"
#import "SettingViewController.h"
#import "CommentsViewController.h"
#import "HomeCell.h"
#import "LoadingCell.h"

@interface AnimateScreenViewController ()
{
    NSMutableArray *arrData;
    UIView *statusBarView;
    BOOL isScrollUp, isApiStarted, isBackground;
    UIRefreshControl *refreshControl;
    NSIndexPath *selectedIndexPath;
    NSInteger iLimit, iOffset;
    NSURLSessionDataTask *loadYuuudlistTask, *likeYuuudTask;
    CGPoint lastContentOffset;
    CGPoint tableViewScrollPosition;
    MIAudioWaveform *objTempWaveForm;
}
@end

@implementation AnimateScreenViewController

- (void)viewDidLoad
{
    superTable = tblRecordings;
    
    [super viewDidLoad];
    
    lbNoYuuud.textColor = CNavigationBarColor;
    
    //self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setHidesBackButton:YES];
    
    shimmeringView.shimmering = YES;
    shimmeringView.shimmeringBeginFadeDuration = 0.3;
    shimmeringView.shimmeringOpacity = 0.3;
    shimmeringView.contentView = tblShimmer;
    
    tblRecordings.multipleTouchEnabled = NO;
    arrData = [[NSMutableArray alloc] init];
   
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = CNavigationBarColor;
    [refreshControl addTarget:self action:@selector(refreshYuuuds:) forControlEvents:UIControlEventValueChanged];
    [tblRecordings addSubview:refreshControl];
    
    //TODO: Google AdMob
    
    if (![CUserDefaults boolForKey:CInAppPurchase])
    {
        vwAdBanner.adUnitID = CAdMobUnitID;
        vwAdBanner.rootViewController = self;
        GADRequest *request = [GADRequest request];
        request.testDevices = @[ kGADSimulatorID ];
        [vwAdBanner loadRequest:request];
    }
    
    btnRecord.layer.shadowColor = [[UIColor blackColor] CGColor];
    btnRecord.layer.shadowOffset = CGSizeMake(0,10.0);
    btnRecord.layer.shadowOpacity = 0.2f;
    btnRecord.layer.shadowRadius = 7.0f;
    btnRecord.layer.masksToBounds = NO;
    
    statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CScreenWidth, 22)];
    statusBarView.backgroundColor = CScreenBackgroundColor;
    statusBarView.hidden = YES;
    [appDelegate.window addSubview:statusBarView];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_NavLogo"]];
    
    [tblRecordings registerNib:[UINib nibWithNibName:@"HomeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HomeCell"];
    [tblShimmer registerNib:[UINib nibWithNibName:@"LoadingCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LoadingCell"];
    
    [tblRecordings setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tblRecordings.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [tblRecordings setContentInset:UIEdgeInsetsMake(44, 0, 0, 0)];
    
    [self prefersStatusBarHidden];
    [self preferredStatusBarStyle];
    
    self.transitionAnimator = [[ARTransitionAnimator alloc] init];
    self.transitionAnimator.transitionDuration = 0.1;
    self.transitionAnimator.transitionStyle = ARTransitionStyleMaterial|ARTransitionStyleBottomToTop;
    
    appDelegate.configureChangeScreen = ^(UILongPressGestureRecognizer *sender)
    {
        if ([[UIApplication topMostController] isKindOfClass:[UIAlertController class]])
            return;
        
        if ([(UIViewController *)[(SuperNavigationController *)[UIApplication topMostController] topViewController] isKindOfClass:[RecordViewController class]])
            return;
        
        if([self cameBackFromSleep])
        {
            [[PPAlerts sharedAlerts] showAlertWithType:3 withMessage:@"Unable to access microphone when another app is using it."];
            return;
        }
        
        RecordViewController *objRecord = [RecordViewController initWithXib];
        self.navigationController.delegate = self.transitionAnimator;
        [self.navigationController pushViewController:objRecord animated:YES];
    };
    
//TODO: Setting click
    
    UIBarButtonItem *btnSetting = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_Setting"] style:UIBarButtonItemStylePlain target:self action:nil];
    
    self.navigationItem.rightBarButtonItem = btnSetting;
    
    [btnSetting clicked:^{
        SettingViewController *objSetting = [SettingViewController initWithXib];
        self.navigationController.delegate = nil;
        [self.navigationController pushViewController:objSetting animated:YES];
    }];

    iOffset = 0;
    iLimit = 200;
    
    appDelegate.dLat = [CUserDefaults doubleForKey:CCurrentLatitude];
    appDelegate.dLong = [CUserDefaults doubleForKey:CCurrentLongitude];
    [self getYuuudsFromServer:NO isLoadMore:NO];
    
    [UIApplication applicationWillEnterForeground:^{
        
        if ([(UIViewController *)[(SuperNavigationController *)[UIApplication topMostController] topViewController] isKindOfClass:[RecordViewController class]])
        {
            for (UIViewController *objViewController in self.navigationController.viewControllers)
            {
                if([objViewController isKindOfClass:[AnimateScreenViewController class]])
                {
                    [self.navigationController popToViewController:objViewController animated:NO];
                    break;
                }
            }
        }
        
        if (selectedIndexPath)
        {
            HomeCell *cellSelected = [tblRecordings cellForRowAtIndexPath:selectedIndexPath];
            [cellSelected.waveForm destroyStreamer];
        }
        
        iOffset = 0;
        isBackground = YES;
        
        appDelegate.dLat = [CUserDefaults doubleForKey:CCurrentLatitude];
        appDelegate.dLong = [CUserDefaults doubleForKey:CCurrentLongitude];

        [self getYuuudsFromServer:YES isLoadMore:NO];
    }];
    
    [UIApplication applicationDidEnterBackground:^{
        //isBackground = NO;
        
        if (selectedIndexPath)
        {
            HomeCell *cellSelected = [tblRecordings cellForRowAtIndexPath:selectedIndexPath];
            [cellSelected.waveForm destroyStreamer];
        }
    }];
    
    appDelegate.configureRefreshYuuuds = ^
    {
        iOffset = 0;
        appDelegate.dLat = [CUserDefaults doubleForKey:CCurrentLatitude];
        appDelegate.dLong = [CUserDefaults doubleForKey:CCurrentLongitude];
        [self getYuuudsFromServer:NO isLoadMore:NO];
    };
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
    [btnRecord addGestureRecognizer:appDelegate.longPress];
    appDelegate.longPress.minimumPressDuration = 0.3;
    btnRecord.exclusiveTouch = YES;
    
    //[tblRecordings setContentOffset:tableViewScrollPosition];
   
//    if(tableViewScrollPosition.y > 0)
//    {
//        cnBtnRecordBottomSpace.constant = -CViewHeight(btnRecord);
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//        statusBarView.hidden = NO;
//    }
//    else
//    {
//        cnBtnRecordBottomSpace.constant = 86;
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//        statusBarView.hidden = YES;
//    }
    
    selectedIndexPath = nil;
    [tblRecordings reloadData];
    
    if([CUserDefaults boolForKey:CInAppPurchase])
        [vwAdBanner hideByHeight:YES];
    
    cnBtnRecordBottomSpace.constant = 86;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if (selectedIndexPath)
    {
        HomeCell *cellSelected = [tblRecordings cellForRowAtIndexPath:selectedIndexPath];
        [cellSelected.waveForm destroyStreamer];
    }
    
    [refreshControl endRefreshing];
    
    lastContentOffset = tblRecordings.contentOffset;
    
    selectedIndexPath = nil;
    //[tblRecordings reloadData];
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

#pragma mark - Click events
#pragma mark -

-(IBAction)btnRecordClick:(UIButton*)sender
{
    return;
}

#pragma mark - Click events
#pragma mark -


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:tblShimmer])
    {
        static NSString *simpleTableIdentifier = @"LoadingCell";
        
        LoadingCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil)
            cell = [[LoadingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];

        return cell;
    }
    
    
    static NSString *simpleTableIdentifier = @"HomeCell";
    
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
        cell = [[HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    
    NSMutableDictionary *dicData = [[NSMutableDictionary alloc] initWithDictionary:arrData[indexPath.row]];
    
    cell.viewWaveContainer.backgroundColor = [UIColor colorWithHexString:[dicData stringValueForJSON:@"color"]];
    cell.lbTitle.text = [dicData stringValueForJSON:@"yuuud_name"];
    cell.lbUsername.text = [dicData stringValueForJSON:@"username"];
    
    for (UILongPressGestureRecognizer *objLong in cell.btnLoadWave.gestureRecognizers) {
        [cell.btnLoadWave removeGestureRecognizer:objLong];
    }
    
    UILongPressGestureRecognizer *objGesture = [[UILongPressGestureRecognizer alloc] init];
    objGesture.numberOfTouchesRequired = 1;
    
    [objGesture addTargetBlock:^{
        
        if (objGesture.state == UIGestureRecognizerStateBegan)
        {
            UIAlertView *objAlert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to report this audio?" delegate:nil cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
            
            [objAlert show:^(NSInteger buttonIndex) {
                
                if (buttonIndex == 0)
                {
                    [self openMailComposer:@"Report an audio" recepients:@[@"akshshr9@gmail.com"] body:[NSString stringWithFormat:@"Hello There,\n\nI found this Audio offensive and I feel it should be removed from the app.\n\nAudio: %@", [dicData stringValueForJSON:@"yuuud_audio"]]  isHTML:NO];
                }
            }];
        }
    }];
    
    [cell.btnLoadWave addGestureRecognizer:objGesture];
    
    if ([dicData objectForKey:@"latitude"] && [dicData objectForKey:@"longitude"] && [CUserDefaults objectForKey:CCurrentLatitude] && [CUserDefaults objectForKey:CCurrentLongitude])
    {
        CLLocation *location1 = [[CLLocation alloc] initWithLatitude:[[dicData stringValueForJSON:@"latitude"] doubleValue] longitude:[[dicData stringValueForJSON:@"longitude"] doubleValue]];

        CLLocation *location2 = [[CLLocation alloc] initWithLatitude:[CUserDefaults doubleForKey:CCurrentLatitude] longitude:[CUserDefaults doubleForKey:CCurrentLongitude]];

        double distance = [location1 distanceFromLocation:location2];
        
        if(distance > 1000)
            cell.lbLocation.text = [dicData stringValueForJSON:@"location_name"];
        else
            cell.lbLocation.text = @"Very close";
    }
    
    cell.lbCommentCount.text = [appDelegate convertLikeCountInShortForm:[dicData numberForJson:@"comment_count"]];
    cell.lbLikeCount.text = [appDelegate convertLikeCountInShortForm:[dicData numberForJson:@"like_count"]];
    
    [cell generateWaveform:dicData runningAudio:[selectedIndexPath isEqual:indexPath] ? objTempWaveForm : nil];
    
    [cell.btnComment touchUpInsideClicked:^{
        
        CommentsViewController *objComments = [CommentsViewController initWithXib];
        self.navigationController.delegate = nil;
        objComments.clrBackground = cell.viewWaveContainer.backgroundColor;
        objComments.dictData = [[NSMutableDictionary alloc] initWithDictionary:[arrData objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:objComments animated:YES];
        
    }];
    
    //NSInteger status;
    
    [cell.btnLikeAction touchUpInsideClicked:^{
        [cell.btnLike sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
    
    if([dicData numberForJson:@"liked"].integerValue == 1) // Like
    {
        [cell.btnLike setImage:[UIImage imageNamed:@"ic_Like"] forState:UIControlStateSelected];
        [cell.btnLike setImage:[UIImage imageNamed:@"ic_HeartBroken"] forState:UIControlStateNormal];
        cell.btnLike.selected = YES;
    }
    else if ([dicData numberForJson:@"liked"].integerValue == 0) // Dislike
    {
        [cell.btnLike setImage:[UIImage imageNamed:@"ic_HeartBroken"] forState:UIControlStateSelected];
        [cell.btnLike setImage:[UIImage imageNamed:@"ic_Like"] forState:UIControlStateNormal];
        cell.btnLike.selected = YES;
    }
    else // None
    {
        [cell.btnLike setImage:[UIImage imageNamed:@"ic_Dislike"] forState:UIControlStateNormal];
        [cell.btnLike setImage:[UIImage imageNamed:@"ic_HeartBroken"] forState:UIControlStateSelected];
        cell.btnLike.selected = NO;
    }
    
    __block NSInteger status = [dicData stringValueForJSON:@"liked"].integerValue;
    __block NSInteger likeCount = [dicData stringValueForJSON:@"like_count"].intValue;
    
    [cell.btnLike touchUpInsideClicked:^{
        
        if(status == 1)
        {
//Dislike code
            [cell.btnLike setImage:[UIImage imageNamed:@"ic_HeartBroken"] forState:UIControlStateSelected];
            [cell.btnLike setImage:[UIImage imageNamed:@"ic_Like"] forState:UIControlStateNormal];
            cell.btnLike.selected = YES;
            
            status = 0;
            
            likeCount = likeCount - 2;
        }
        else if(status == 0)
        {
//None code
            [cell.btnLike setImage:[UIImage imageNamed:@"ic_Dislike"] forState:UIControlStateNormal];
            [cell.btnLike setImage:[UIImage imageNamed:@"ic_HeartBroken"] forState:UIControlStateSelected];
            cell.btnLike.selected = NO;
            
            status = 2;
            
            likeCount = likeCount + 1;
        }
        else
        {
//like code
            [cell.btnLike setImage:[UIImage imageNamed:@"ic_Like"] forState:UIControlStateSelected];
            [cell.btnLike setImage:[UIImage imageNamed:@"ic_HeartBroken"] forState:UIControlStateNormal];
            cell.btnLike.selected = YES;
            
            status = 1;
            
            likeCount = likeCount + 1;
        }
        
        cell.lbLikeCount.text = [NSString stringWithFormat:@"%ld", (long)likeCount];
        
        [dicData setObject:cell.lbLikeCount.text forKey:@"like_count"];
        [dicData setObject:[NSString stringWithFormat:@"%ld", (long)status] forKey:@"liked"];
        [arrData replaceObjectAtIndex:indexPath.row withObject:dicData];
        
        if (likeYuuudTask && likeYuuudTask.state == NSURLSessionTaskStateRunning)
            [likeYuuudTask cancel];
        
        likeYuuudTask = [[APIRequest request] likeYuuudWithYuuudID:[dicData stringValueForJSON:@"yuuud_id"] andLikeStatus:status completion:^(id responseObject, NSError *error)
                         {
                             NSLog(@"Finally response got... .. .. .. .");
                             [dicData setObject:cell.lbLikeCount.text forKey:@"like_count"];
                             [dicData setObject:[NSString stringWithFormat:@"%ld", (long)status] forKey:@"liked"];
                             [arrData replaceObjectAtIndex:indexPath.row withObject:dicData];
                         }];
    }];
    
    
    cell.waveForm.configureDonePlaying = ^{
        selectedIndexPath = nil;
        objTempWaveForm = nil;
    };
    
    
    [cell.btnLoadWave touchUpInsideClicked:^{

        if ([dicData floatForKey:@"yuuud_duration"] < 1)
            return;
        
        [UIView animateWithDuration:.1 animations:^{
            cell.viewWaveContainer.alpha = 0.7;
        } completion:^(BOOL finished) {
            cell.viewWaveContainer.alpha = 1;
        }];
        
        if ([selectedIndexPath isEqual:indexPath])
        {
            HomeCell *cellSelected = [tableView cellForRowAtIndexPath:selectedIndexPath];
            [cellSelected.waveForm destroyStreamer];
            selectedIndexPath = nil;
            return;
        }
        
        if (selectedIndexPath)
        {
            HomeCell *cellSelected = [tableView cellForRowAtIndexPath:selectedIndexPath];
            [cellSelected.waveForm destroyStreamer];
        }
        
        if (objTempWaveForm)
            [objTempWaveForm destroyStreamer];
        
        cell.waveForm.progressImage = [cell.waveForm recolorizeImage:cell.waveForm.tempImage withColor:cell.waveForm.progressColor];
        
        [cell PlayAudioFile:[dicData stringValueForJSON:@"yuuud_audio"]];
        
        selectedIndexPath = indexPath;
        
        objTempWaveForm = cell.waveForm;
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //if(shimmeringView.shimmering)
    if([tableView isEqual:tblShimmer])
        return 10;
    
    return arrData.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CommentsViewController *objComments = [CommentsViewController initWithXib];
//    [self.navigationController pushViewController:objComments animated:YES];
//    HomeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
//    if ([cell isKindOfClass:[HomeCell class]])
//    {
//        HomeCell *objHomeCell = (HomeCell *)cell;
//        
//        if (![objHomeCell.waveForm isEqual:objTempWaveForm])
//        {
//            [objHomeCell.waveForm removeFromSuperview];
//            objHomeCell.waveForm = nil;
//        }
//    }
}

#pragma mark - Scrollview delegate methods
#pragma mark -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //if(shimmeringView.shimmering)
    
    if([scrollView isEqual:tblShimmer])
        return;
    
//    if (isBackground)
//        return;
    
    [super scrollViewDidScroll:scrollView];
    
    tableViewScrollPosition = scrollView.contentOffset;
    
    if([scrollView.panGestureRecognizer translationInView:self.view].y < 0)
    {
        cnBtnRecordBottomSpace.constant = -CViewHeight(btnRecord);
        
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.view layoutIfNeeded];
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            
        } completion:^(BOOL finished) {
            
              statusBarView.hidden = NO;
        }];
    }
    else if([scrollView.panGestureRecognizer translationInView:self.view].y > 0)
    {
        cnBtnRecordBottomSpace.constant = 86;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.view layoutIfNeeded];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            
        } completion:^(BOOL finished) {
            statusBarView.hidden = YES;
        }];
    }
}

#pragma mark - Functions
#pragma mark -

- (void)loadMoreData
{
    if (isApiStarted)
        return;
    
    if (iOffset == 0)
        return;
    
    [self getYuuudsFromServer:NO isLoadMore:YES];
}

- (void)refreshYuuuds:(UIRefreshControl *)refreshControl1
{
    //call refresh api over here and end refresh on success response
    
    appDelegate.didFindLocation = NO;
    appDelegate.shouldRefresh = YES;
    [appDelegate.locationManager startUpdatingLocation];
    
    if (selectedIndexPath)
    {
        HomeCell *cellSelected = [tblRecordings cellForRowAtIndexPath:selectedIndexPath];
        [cellSelected.waveForm destroyStreamer];
    }

    iOffset = 0;
    appDelegate.dLat = [CUserDefaults doubleForKey:CCurrentLatitude];
    appDelegate.dLong = [CUserDefaults doubleForKey:CCurrentLongitude];
    [self getYuuudsFromServer:NO isLoadMore:NO];
}

- (void)getYuuudsFromServer:(BOOL)isFromBackground isLoadMore:(BOOL)isLoadMore
{
//  call api to get all the yuuuds from the server with limit and offset
    
    if(arrData.count == 0)
    {
        shimmeringView.shimmering = YES;
        tblRecordings.hidden = YES;
    }
    else
    {
        shimmeringView.shimmering = NO;
        tblRecordings.hidden = NO;
    }
    
    tblShimmer.hidden = !tblRecordings.hidden;
    
    if (likeYuuudTask && likeYuuudTask.state == NSURLSessionTaskStateRunning)
    {
        [refreshControl endRefreshing];
        return;
    }
    
    if (loadYuuudlistTask && loadYuuudlistTask.state == NSURLSessionTaskStateRunning)
        [loadYuuudlistTask cancel];
    
    isApiStarted = YES;
    
    loadYuuudlistTask = [[APIRequest request] getYuuudList:iLimit offset:iOffset refreshControl:refreshControl completion:^(id responseObject, NSError *error)
    {
        //tblRecordings.scrollEnabled = YES;
        tblRecordings.hidden = NO;
        tblShimmer.hidden = YES;
        shimmeringView.shimmering = NO;
        
        [refreshControl endRefreshing];
        
        loadYuuudlistTask = nil;
        isApiStarted = NO;
        
        if(iOffset == 0)
        {
            [arrData removeAllObjects];
            [tblRecordings reloadData];
            tblRecordings.hidden = YES;
            lbNoYuuud.hidden = NO;
        }
        
        if ([responseObject objectForKey:CJsonData] && [[responseObject objectForKey:CJsonData] isKindOfClass:[NSArray class]])
        {
            NSArray *arrResponse = [responseObject objectForKey:CJsonData];
            
            if(arrResponse.count > 0)
            {
                lbNoYuuud.hidden = YES;
                [arrData addObjectsFromArray:arrResponse];
                tblRecordings.hidden = NO;
                [tblRecordings reloadData];
                NSLog(@"arrData is: %@", arrData);
            }
        }
        else
            [refreshControl endRefreshing];
        
        if (!isLoadMore)
        {
            if(objTempWaveForm)
            {
                [objTempWaveForm destroyStreamer];
                objTempWaveForm = nil;
                selectedIndexPath = nil;
            }
        }
        
        if ([responseObject valueForKey:@"offset"])
            iOffset = [responseObject numberForJson:@"offset"].intValue;
        
        if(isFromBackground)
        {
            cnBtnRecordBottomSpace.constant = 86;
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            statusBarView.hidden = YES;
        }
    }];
}


- (BOOL)cameBackFromSleep
{
    CTCallCenter *callCenter1 = [[CTCallCenter alloc] init];
    
    for (CTCall *objCall in callCenter1.currentCalls)
    {
        if (objCall.callState == CTCallStateConnected || objCall.callState == CTCallStateDialing || objCall.callState == CTCallStateIncoming)
        {
            NSLog(@"On call....");
            return YES;
        }
    }
    
    return NO;
}


@end
