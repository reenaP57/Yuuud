//
//  NotificationViewController.m
//  Yuuud
//
//  Created by mac-00015 on 5/25/17.
//  Copyright © 2017 MindInventory. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationCell.h"

@interface NotificationViewController ()
{
    NSURLSessionDataTask *updateNotificationTask;
}
@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Notifications";
    [tblSettings registerNib:[UINib nibWithNibName:@"NotificationCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"NotificationCell"];
    [tblSettings setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tblSettings.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tableview Methods
#pragma mark -

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"NotificationCell";
    
    NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
        cell = [[NotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    
    cell.imgIcon.image = [UIImage imageNamed:@"Ic_Notification"];
    
    switch (indexPath.row)
    {
        case 0:
        {
            cell.lbTitle.text = @"Comments";
            cell.swPush.on = [CUserDefaults boolForKey:CCommentNotification];
        }
            break;
        case 1:
        {
            cell.lbTitle.text = @"Likes";
            cell.swPush.on = [CUserDefaults boolForKey:CLikeNotification];
        }
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.configureSwitchChanged = ^(UISwitch *sw) {
        
        if (updateNotificationTask && updateNotificationTask.state == NSURLSessionTaskStateRunning)
            [updateNotificationTask cancel];
        
        updateNotificationTask = [[APIRequest request] updateNotificationSetting:@(indexPath.row+1) status:[sw isOn]? @1 :@0  completion:^(id responseObject, NSError *error) {
            
        }];
    };
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
   
}

@end
