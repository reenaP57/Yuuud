//
//  UsernameViewController.m
//  Yuuud
//
//  Created by mac-00015 on 2/23/17.
//  Copyright © 2017 MindInventory. All rights reserved.
//

#import "LocationSelectionViewController.h"
#import "AnimateScreenViewController.h"

@interface LocationSelectionViewController ()

@end

@implementation LocationSelectionViewController
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    btnEnable.layer.cornerRadius = CViewHeight(btnEnable)/2;
    btnEnable.layer.masksToBounds = YES;
    [btnEnable setTitleColor:CScreenBackgroundColor forState:UIControlStateNormal];
    btnEnable.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES];
    
    if(appDelegate.configureLocationPermission)
        appDelegate.configureLocationPermission();
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Click Events
#pragma mark -

- (IBAction)btnEnableClicked:(UIButton*)sender
{
    if(appDelegate.configureLocationPermission)
        appDelegate.configureLocationPermission();
    
    if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
        [self showSettingAlert];
    else
        [[PPAlerts sharedAlerts] showAlertWithType:3 withMessage:@"You've aleady enabled location services, Click next to go ahead!"];
}

-(IBAction)btnNextClicked:(UIButton*)sender
{
    if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined)
    {
        if(appDelegate.configureLocationPermission)
            appDelegate.configureLocationPermission();
    }
    else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
        [self showSettingAlert];
    else
    {
        AnimateScreenViewController *objAnimate = [AnimateScreenViewController initWithXib];
        [self.navigationController pushViewController:objAnimate animated:YES];
    }
}

#pragma mark - Functions
#pragma mark -

-(void)showSettingAlert
{
    NSString * errorString = @"It seems your 'locations services' is turned off, Please turn it on from 'Settings > Privacy > Location Services' for this app!";
    
    UIAlertController *objAlert = [UIAlertController alertControllerWithTitle:@"" message:errorString preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* actionOk = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //TODO: Open settings screen from the app
        
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]])
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        
    }];
    
    UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    
    [objAlert addAction:actionOk];
    [objAlert addAction:actionCancel];
    
    [self presentViewController:objAlert animated:YES completion:nil];
}

@end
