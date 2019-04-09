//
//  SettingViewController.m
//  Yuuud
//
//  Created by mac-00015 on 2/23/17.
//  Copyright © 2017 MindInventory. All rights reserved.
//

#import "SettingViewController.h"
#import "LandingViewController.h"
#import "TutorialScreenViewController.h"
#import "NotificationViewController.h"
#import "SettingCell.h"



@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"SETTINGS";
    [tblSetting registerNib:[UINib nibWithNibName:@"SettingCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SettingCell"];
    [tblSetting setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tblSetting.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    vwInApp.layer.cornerRadius = 3;
    vwInApp.layer.borderColor = CRGB(234, 234, 234).CGColor;
    [vwInApp.layer setMasksToBounds:NO];
    vwInApp.layer.shadowOffset = CGSizeMake(0, 2);
    vwInApp.layer.shadowOpacity = 0.1;
    vwInApp.layer.shadowRadius = 1.5;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark - Tableview Delegate Methods
#pragma mark -

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SettingCell";
    
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    
    switch (indexPath.row)
    {
        case 0:
        {
            cell.lbTitle.text = @"Remove Ads";
            cell.imgIcon.image = [UIImage imageNamed:@"ic_Ads"];
        }
            break;
        case 1:
        {
            cell.lbTitle.text = @"Notifications";
            cell.imgIcon.image = [UIImage imageNamed:@"Ic_Notification"];
        }
            break;
        case 2:
        {
            cell.lbTitle.text = @"About Us";
            cell.imgIcon.image = [UIImage imageNamed:@"ic_AboutUs"];
        }
            break;
        case 3:
        {
            cell.lbTitle.text = @"Privacy Policy";
            cell.imgIcon.image = [UIImage imageNamed:@"Ic_Privacy"];
        }
            break;
        case 4:
        {
            cell.lbTitle.text = @"Edit User Name";
            cell.imgIcon.image = [UIImage imageNamed:@"ic_Edit"];
        }
            break;
        case 5:
        {
            cell.lbTitle.text = @"Tutorial";
            cell.imgIcon.image = [UIImage imageNamed:@"ic_Tutorial"];
        }
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        {
            [self purchaseInApp:Product_ID];
        }
            break;
        case 1:
        {
            NotificationViewController *objNoti = [NotificationViewController initWithXib];
            [self.navigationController pushViewController:objNoti animated:YES];
        }
            break;
        case 2:
        {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://yuuud.se/"]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://yuuud.se/"]];
            }
        }
            break;
        case 3:
        {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://yuuud.se/termsnconditions.html"]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://yuuud.se/termsnconditions.html"]];
            }
        }
            break;
        case 4:
        {
            LandingViewController *objLanding = [LandingViewController initWithXib];
            objLanding.isFromEdit = YES;
            [self.navigationController pushViewController:objLanding animated:YES];
        }
            break;
        case 5:
        {
            TutorialScreenViewController *objTutorial = [TutorialScreenViewController initWithXib];
            objTutorial.isFromSettings = YES;
            [self.navigationController pushViewController:objTutorial animated:YES];
        }
            break;
    }
}


#pragma mark - To check if user has purchased in-app
#pragma mark


- (IBAction)btnInAppPurchaseClicked
{
    //Restore in-app purchases
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [self restoreInApp];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    //NSUInteger thisIsTheTotalNumberOfPurchaseToBeRestored = queue.transactions.count;
    
    BOOL isPurahsed = NO;
    
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        NSString *thisIsProductIDThatHasAlreadyBeenPurchased = transaction.payment.productIdentifier;
        
        if([thisIsProductIDThatHasAlreadyBeenPurchased isEqualToString:Product_ID])
        {
            isPurahsed = YES;
        }
    }
    
    if (!isPurahsed)
    {
        UIAlertView *objAlert = [[UIAlertView alloc] initWithTitle:CMessageSorry message:@"There is nothing to restore to your account" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [objAlert show];
    }
    else
    {
//        UIAlertView *objAlert = [[UIAlertView alloc] initWithTitle:@"Huh!" message:@"Seems like you have already paid to remove ads" delegate:nil cancelButtonTitle:@"Awesome" otherButtonTitles:nil, nil];
//        
//        [objAlert show];
    }
}

@end
