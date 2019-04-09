//
//  CommentsViewController.m
//  Yuuud
//
//  Created by mac-00015 on 2/24/17.
//  Copyright © 2017 MindInventory. All rights reserved.
//

#import "CommentsViewController.h"
#import "CommentCell.h"
#import "MIAudioWaveform.h"


@interface CommentsViewController ()
{
    int likeStatus;
    NSMutableArray *arrList;
    BOOL isApiStarted;
    //UIRefreshControl *refreshControl;
    NSInteger iLimit, iOffset, iCommentCount;
    NSURLSessionDataTask *loadCommentList, *likeYuuudTask, *likeCommentTask;
    NSString *yuuud_id;
    
    NSInteger likeSt, likeCnt;
    
    MIAudioWaveform *waveForm;
    
    CGFloat tblHeight;
}

@end

@implementation CommentsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"COMMENTS";
    
    superTable = tblComments;
    arrList = [NSMutableArray new];
    tblComments.transform = CGAffineTransformMakeRotation(-M_PI);
    
//    refreshControl = [[UIRefreshControl alloc] init];
//    refreshControl.tintColor = CNavigationBarColor;
//    [refreshControl addTarget:self action:@selector(refreshCommentList:) forControlEvents:UIControlEventValueChanged];
//    [tblComments addSubview:refreshControl];
    
    [tblComments registerNib:[UINib nibWithNibName:@"CommentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CommentCell"];
    [tblComments setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //...Load yuuud detail
    if(self.dicRemote)
        yuuud_id = [self.dicRemote stringValueForJSON:@"object_id"];
    else
    {
        [self setYuuudDetail];
        yuuud_id = [self.dictData stringValueForJSON:@"yuuud_id"];
    }
    
    [self getYuuudDetailWithID:yuuud_id];
    
    txtComment.placeholder = @"Write comment here...";
    [txtComment setPlaceholderColor:[UIColor whiteColor]];
    txtComment.font = CFontNotoSans(15);
    txtComment.textColor = [UIColor whiteColor];
    txtComment.maxNumberOfLines = 4;
    txtComment.minNumberOfLines = 1;
    txtComment.animateHeightChange = YES;
    txtComment.delegate = self;
    //[txtComment setContentInset:UIEdgeInsetsMake(10, 0, 10, 0)];
    txtComment.tintColor = [UIColor whiteColor];
    txtComment.backgroundColor = CRGB(255, 88, 61);
    [btnSend setBackgroundColor:CRGB(255, 88, 61)];
    
    vwTop.layer.borderColor = CRGB(234, 234, 234).CGColor;
    [vwTop.layer setMasksToBounds:NO];
    vwTop.layer.shadowOffset = CGSizeMake(0, 2);
    vwTop.layer.shadowOpacity = 0.1;
    vwTop.layer.shadowRadius = 1.5;
    
    [activityInd startAnimating];
    
    //  likeStatus = 0;
    //  [btnLike setImage:[UIImage imageNamed:@"ic_Dislike"] forState:UIControlStateNormal];
    //   [btnLike setImage:[UIImage imageNamed:@"ic_Like"] forState:UIControlStateSelected];
    //   btnLike.selected = NO;
    
    iOffset = 0;
    iLimit = 20;
    [self getCommentListWithYuuudID:yuuud_id];
    
    [tblComments layoutIfNeeded];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:nil action:nil];
    [tap addTargetBlock:^{
        [txtComment resignFirstResponder];
    }];
    [self.view addGestureRecognizer:tap];
    
    
    [UIApplication applicationDidBecomeActive:^{
        [waveForm destroyStreamer];
    }];
    
    
    [UIApplication applicationDidEnterBackground:^{
        [waveForm destroyStreamer];
    }];
    
    
    appDelegate.configureRrefreshComments = ^{
        iOffset = 0;
        [arrList removeAllObjects];
        [self getCommentListWithYuuudID:yuuud_id];
    };
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    appDelegate.isCommentScreen = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    tblHeight = tblComments.bounds.size.height;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    if (waveForm)
        //[waveForm forceStopPlayer];
        [waveForm destroyStreamer];
    
    appDelegate.isCommentScreen = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView Delegate Methods
#pragma mark -

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"CommentCell";
    
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    
    NSMutableDictionary *dicData = [[NSMutableDictionary alloc] initWithDictionary:arrList[indexPath.row]];
    
    cell.lbMainTitle.attributedText = [self setAttributedString:[dicData stringValueForJSON:@"comment"]];
    cell.lbMainUsername.text = [dicData stringValueForJSON:@"username"];
    cell.lbTime.text = [self setTimeFormat:[dicData stringValueForJSON:@"createdAt"]];
    cell.lbLikeCount.text = [appDelegate convertLikeCountInShortForm:[dicData numberForJson:@"like_count"]];
    
    [cell.btnLikeAction touchUpInsideClicked:^{
        [cell.btnLike sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
    
    if([dicData numberForJson:@"liked"].integerValue == 1)
    {
        // Like
        [cell.btnLike setImage:[UIImage imageNamed:@"ic_Heart_Red_Round"] forState:UIControlStateSelected];
        [cell.btnLike setImage:[UIImage imageNamed:@"ic_Heart_Red_Broken_Round"] forState:UIControlStateNormal];
        cell.btnLike.selected = YES;
    }
    else if ([dicData numberForJson:@"liked"].integerValue == 0)
    {
        // Dislike
        [cell.btnLike setImage:[UIImage imageNamed:@"ic_Heart_Red_Broken_Round"] forState:UIControlStateSelected];
        [cell.btnLike setImage:[UIImage imageNamed:@"ic_Heart_Red_Round"] forState:UIControlStateNormal];
        cell.btnLike.selected = YES;
    }
    else
    {
        // None
        [cell.btnLike setImage:[UIImage imageNamed:@"ic_Heart_White_Round"] forState:UIControlStateNormal];
        [cell.btnLike setImage:[UIImage imageNamed:@"ic_Heart_Red_Broken_Round"] forState:UIControlStateSelected];
        cell.btnLike.selected = NO;
    }
    
    __block NSInteger status = [dicData stringValueForJSON:@"liked"].integerValue;
    __block NSInteger likeCount = [dicData stringValueForJSON:@"like_count"].intValue;

    [cell.btnLike touchUpInsideClicked:^{
        
        if(status == 1)
        {
            //Dislike code
            [cell.btnLike setImage:[UIImage imageNamed:@"ic_Heart_Red_Broken_Round"] forState:UIControlStateSelected];
            [cell.btnLike setImage:[UIImage imageNamed:@"ic_Heart_Red_Round"] forState:UIControlStateNormal];
            cell.btnLike.selected = YES;
            
            status = 0;
            
            likeCount = likeCount - 2;
        }
        else if(status == 0)
        {
            //None code
            [cell.btnLike setImage:[UIImage imageNamed:@"ic_Heart_White_Round"] forState:UIControlStateNormal];
            [cell.btnLike setImage:[UIImage imageNamed:@"ic_Heart_Red_Broken_Round"] forState:UIControlStateSelected];
            cell.btnLike.selected = NO;
            
            status = 2;
            
            likeCount = likeCount + 1;
        }
        else
        {
            //like code
            [cell.btnLike setImage:[UIImage imageNamed:@"ic_Heart_Red_Round"] forState:UIControlStateSelected];
            [cell.btnLike setImage:[UIImage imageNamed:@"ic_Heart_Red_Broken_Round"] forState:UIControlStateNormal];
            cell.btnLike.selected = YES;
            status = 1;
            likeCount = likeCount + 1;
        }
        
        cell.lbLikeCount.text = [NSString stringWithFormat:@"%ld", (long)likeCount];
        
        [dicData setObject:cell.lbLikeCount.text forKey:@"like_count"];
        [dicData setObject:[NSString stringWithFormat:@"%ld", (long)status] forKey:@"liked"];
        [arrList replaceObjectAtIndex:indexPath.row withObject:dicData];

        if (likeCommentTask && likeCommentTask.state == NSURLSessionTaskStateRunning)
            [likeCommentTask cancel];

        likeCommentTask = [[APIRequest request] likeCommentWithID:[dicData valueForKey:@"comment_id"] andYuuudID:[self.dictData stringValueForJSON:@"yuuud_id"]  andLikeStatus:status completion:^(id responseObject, NSError *error)
                           {
                               NSLog(@"Finally response got... .. .. .. .");
                               
                               [dicData setObject:cell.lbLikeCount.text forKey:@"like_count"];
                               [dicData setObject:[NSString stringWithFormat:@"%ld", (long)status] forKey:@"liked"];
                               [arrList replaceObjectAtIndex:indexPath.row withObject:dicData];
                           }];
    }];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

#pragma mark - Growing textview delegate methods
#pragma mark -

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    cnTxtCommentHeight.constant = height > 51 ? height : 51;
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
    NSString *finalText = [growingTextView.text stringByReplacingCharactersInRange:range withString:text];
    btnSend.enabled = (finalText.length > 0);
    
    if (!btnSend.enabled)
        cnTxtCommentHeight.constant = 51;
    
    if(finalText.length >= 161)
        return NO;
    
    return true;
}

#pragma mark - ScrollView Method
#pragma mark -

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [txtComment resignFirstResponder];
}

#pragma mark - Click events
#pragma mark -

- (IBAction)btnSendClicked:(UIButton*)sender
{
    [appDelegate hideKeyboard];
   
    if (txtComment.text.length > 0)
    {
        NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
        if ([[txtComment.text stringByTrimmingCharactersInSet:set] length] == 0)
        {
            [[PPAlerts sharedAlerts] showAlertWithType:3 withMessage:@"Please enter any text" withTitle:nil];
            return;
        }
        
        [[APIRequest request] addYuuudCommentWithID:[self.dictData stringValueForJSON:@"yuuud_id"] andComment:txtComment.text completion:^(id responseObject, NSError *error)
         {
             iOffset = 0;
             [arrList removeAllObjects];
             [self getCommentListWithYuuudID:yuuud_id];
             
             txtComment.text = @"";
             btnSend.enabled = NO;
             cnTxtCommentHeight.constant = 51;
             
             iCommentCount++;
             lbCommentCount.text = [appDelegate convertLikeCountInShortForm:@(iCommentCount)];
         }];
    }
}


-(IBAction)btnLikeCLK:(UIButton*)sender
{
    if(likeSt == 1)
    {
        //Dislike code
        [sender setImage:[UIImage imageNamed:@"ic_Like"] forState:UIControlStateSelected];
        [sender setImage:[UIImage imageNamed:@"ic_HeartBroken"] forState:UIControlStateNormal];
        sender.selected = YES;
        
        likeSt = 0;
        
        likeCnt = likeCnt - 2;
    }
    else if(likeSt == 0)
    {
        //None code
        [sender setImage:[UIImage imageNamed:@"ic_Dislike"] forState:UIControlStateSelected];
        [sender setImage:[UIImage imageNamed:@"ic_HeartBroken"] forState:UIControlStateNormal];
        sender.selected = NO;
        
        likeSt = 2;
        
        likeCnt = likeCnt + 1;
    }
    else
    {
        //like code
        [sender setImage:[UIImage imageNamed:@"ic_HeartBroken"] forState:UIControlStateSelected];
        [sender setImage:[UIImage imageNamed:@"ic_Like"] forState:UIControlStateNormal];
        sender.selected = YES;
        
        likeSt = 1;
        
        likeCnt = likeCnt + 1;
    }
    
//    return;
    
    lbLikeCount.text = [NSString stringWithFormat:@"%ld", (long)likeCnt];
    
    if (likeYuuudTask && likeYuuudTask.state == NSURLSessionTaskStateRunning)
        [likeYuuudTask cancel];
    
    likeYuuudTask = [[APIRequest request] likeYuuudWithYuuudID:yuuud_id andLikeStatus:likeSt completion:^(id responseObject, NSError *error)
                     {
                         NSLog(@"Finally response got... .. .. .. .");
                     }];
}

#pragma mark - Helper Method
#pragma mark

- (void)setYuuudDetail
{
    lbYuudName.text = [self.dictData stringValueForJSON:@"yuuud_name"];
    lbUserName.text = [self.dictData stringValueForJSON:@"username"];
    
    if (self.shouldShowColor)
        tblComments.backgroundColor = viewWaveContainer.backgroundColor = [UIColor colorWithHexString:[self.dictData stringValueForJSON:@"color"]];
    else
        tblComments.backgroundColor = viewWaveContainer.backgroundColor = self.clrBackground;
    
    if ([self.dictData objectForKey:@"latitude"] && [self.dictData objectForKey:@"longitude"] && [CUserDefaults objectForKey:CCurrentLatitude] && [CUserDefaults objectForKey:CCurrentLongitude])
    {
        CLLocation *location1 = [[CLLocation alloc] initWithLatitude:[[self.dictData stringValueForJSON:@"latitude"] doubleValue] longitude:[[self.dictData stringValueForJSON:@"longitude"] doubleValue]];
        
        CLLocation *location2 = [[CLLocation alloc] initWithLatitude:[CUserDefaults doubleForKey:CCurrentLatitude] longitude:[CUserDefaults doubleForKey:CCurrentLongitude]];
        
        double distance = [location1 distanceFromLocation:location2];
        
        if(distance > 1000)
            lbLocation.text = [self.dictData stringValueForJSON:@"location_name"];
        else
            lbLocation.text = @"Very close";
    }

    lbLikeCount.text = [appDelegate convertLikeCountInShortForm:[self.dictData numberForJson:@"like_count"]];
    
    iCommentCount = [self.dictData numberForJson:@"comment_count"].integerValue;
    lbCommentCount.text = [appDelegate convertLikeCountInShortForm:@(iCommentCount)];
    
    if (waveForm)
        [waveForm removeFromSuperview];
    
    waveForm = [[MIAudioWaveform alloc] initWithSize:CGSizeMake(viewWave.frame.size.width, viewWave.frame.size.height) andNormalImage:nil andProgressImage:nil Data:self.dictData];
    waveForm.delegate = self;
    [viewWave addSubview:waveForm];
    waveForm.backgroundColor = [UIColor clearColor];
    
    likeSt = [self.dictData numberForJson:@"liked"].integerValue;
    likeCnt = [self.dictData numberForJson:@"like_count"].integerValue;
    
    if(likeSt == 1) // Like
    {
        [btnLike setImage:[UIImage imageNamed:@"ic_Like"] forState:UIControlStateSelected];
        [btnLike setImage:[UIImage imageNamed:@"ic_HeartBroken"] forState:UIControlStateNormal];
        btnLike.selected = YES;
    }
    else if (likeSt == 0) // Dislike
    {
        [btnLike setImage:[UIImage imageNamed:@"ic_HeartBroken"] forState:UIControlStateSelected];
        [btnLike setImage:[UIImage imageNamed:@"ic_Like"] forState:UIControlStateNormal];
        btnLike.selected = YES;
    }
    else // None
    {
        [btnLike setImage:[UIImage imageNamed:@"ic_Dislike"] forState:UIControlStateNormal];
        [btnLike setImage:[UIImage imageNamed:@"ic_HeartBroken"] forState:UIControlStateSelected];
        btnLike.selected = NO;
    }
}

- (NSAttributedString *)setAttributedString:(NSString *)string
{
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:2];
    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, attrString.length)];
    return attrString;
}

- (NSString *)setTimeFormat:(NSString *)sentTime
{
    NSDateFormatter *df=[NSDateFormatter initWithDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDate *date = [df dateFromString:sentTime];
    
    NSCalendarUnit units = NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay |NSCalendarUnitWeekOfYear |NSCalendarUnitMonth | NSCalendarUnitYear;
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:units fromDate:date toDate:[NSDate date] options:0];
    
    if(components.minute < 1)
        return @"Just now";
    else if (components.hour < 1)
        return [NSString stringWithFormat:@"%ld m ago", (long)components.minute];
    else if (components.day < 1)
        return [NSString stringWithFormat:@"%ld h ago", (long)components.hour];
    else if (components.weekOfYear < 1)
        return [NSString stringWithFormat:@"%ld d ago", (long)components.day];
    else if (components.weekOfYear > 1 && components.month < 1)
        return [NSString stringWithFormat:@"%ld w ago", (long)components.weekOfYear];
    else if (components.month > 1 && components.year < 1)
        return [NSString stringWithFormat:@"%ld mon ago", (long)components.month];
    else
        return [NSString stringWithFormat:@"%ld yr ago", (long)components.year];
}

#pragma mark - Function
#pragma mark -

- (void)loadMoreData
{
    if (isApiStarted)
        return;
    
    if (iOffset == 0)
        return;
    
    [self getCommentListWithYuuudID:yuuud_id];
}

- (void)getCommentListWithYuuudID:(NSString *)yuuud_id1
{
    if(loadCommentList && loadCommentList.state == NSURLSessionTaskStateRunning)
        [loadCommentList cancel];
    
    isApiStarted = YES;
    
    loadCommentList = [[APIRequest request] getCommentList:yuuud_id1 andOffset:iOffset andLimit:iLimit completion:^(id responseObject, NSError *error)
                       {
                           [activityInd stopAnimating];
                           
                           if (!error)
                           {
                               isApiStarted = NO;
                               loadCommentList = nil;
                               
                               [arrList addObjectsFromArray:[responseObject objectForKey:CJsonData]];
                               [tblComments reloadData];
                               
                               if([responseObject numberForJson:@"offset"])
                                   iOffset = [responseObject numberForJson:@"offset"].intValue;
                               
                               lbNoComments.hidden = arrList.count > 0;
                               
//                               NSInteger numRows = [self tableView:tblComments numberOfRowsInSection:0];
//                               
//                               CGFloat contentInsetTop = tblComments.bounds.size.height;
//                               
//                               CGFloat height;
//                               
//                               for (NSInteger i = 0; i < numRows-1; i++)
//                               {
//                                   contentInsetTop -= [self tableView:tblComments heightForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
//                                   
//                                   height += [self tableView:tblComments heightForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
//                                   
//                                   if (contentInsetTop <= 0)
//                                   {
//                                       contentInsetTop = 0;
//                                       break;
//                                   }
//                               }
//                               
//                               tblComments.contentInset = UIEdgeInsetsMake(contentInsetTop+height, 0, 0, 0);
                               
                               //[tblComments scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                               
                           }
                       }];
}

- (void)getYuuudDetailWithID:(NSString *)yuuud_id1
{
    [[APIRequest request] getYuuudDetailWithID:yuuud_id1 completion:^(id responseObject, NSError *error)
     {
         self.dictData = [responseObject valueForKey:CJsonData];
         [self setYuuudDetail];
     }];
}

#pragma mark - Audio Waveform Delegate

- (void)DidFinishAudio:(MIAudioWaveform *)waveFormView Finish:(BOOL)isFinish;
{
    NSLog(@"DidFinishAudio========== >>>>>>>>> ");
    btnPlay.selected = NO;
}

- (void)DidAudioBuffering:(AVQueuePlayer *)player Continue:(BOOL)isContinue
{
    if (isContinue)
    {
        NSLog(@"Buffering Continue ==========");
//        ActivityIndicator.hidden = NO;
//        [ActivityIndicator startAnimating];
    }
    else
    {
        NSLog(@"Buffering is end now ==========");
//        ActivityIndicator.hidden = YES;
//        [ActivityIndicator stopAnimating];
    }
}

-(IBAction)btnPlayAudioFileCLK:(UIButton *)sender
{
    [UIView animateWithDuration:.1 animations:^{
        viewWaveContainer.alpha = 0.7;
    } completion:^(BOOL finished) {
        viewWaveContainer.alpha = 1;
    }];

    if (sender.selected)
    {
        [waveForm destroyStreamer];
        sender.selected = NO;
    }
    else
    {
        if ([self.dictData floatForKey:@"yuuud_duration"] < 1)
            return;

        if (waveForm)
            [waveForm destroyStreamer];
        
        waveForm.progressImage = [waveForm recolorizeImage:waveForm.tempImage withColor:waveForm.progressColor];
        [waveForm StartProgressToFilldata:[self.dictData stringValueForJSON:@"yuuud_audio"]];
        sender.selected = YES;
    }
}

@end
