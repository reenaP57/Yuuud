//
//  LandingViewController.m
//  Yuuud
//
//  Created by mac-00015 on 2/23/17.
//  Copyright © 2017 MindInventory. All rights reserved.
//

#import "LandingViewController.h"
#import "LocationSelectionViewController.h"

@interface LandingViewController ()

@end

@implementation LandingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prefersStatusBarHidden];
    [self preferredStatusBarStyle];
    [self.navigationController setNavigationBarHidden:YES];
    
//    if (self.isFromEdit)
//    {
//        btnCheckbox.hidden = btnTerms.hidden = imgCheckbox.hidden = vwHorizontalLine.hidden = lbTerms.hidden = YES;
//    }
    
    [txtUserName setPlaceHolderColor:[UIColor whiteColor]];
    
    if(self.isFromEdit)
    {
        txtUserName.text = [CUserDefaults valueForKey:CUserName];
        [btnNext setTitle:@"SAVE" forState:UIControlStateNormal];
    }
    else
        [btnNext setTitle:@"NEXT" forState:UIControlStateNormal];
    
//    btnCheckbox.selected = NO;
    
//    [btnCheckbox touchUpInsideClicked:^{
//    
//        btnCheckbox.selected = !btnCheckbox.selected;
//        
//        if(btnCheckbox.selected)
//        {
//            [imgCheckbox setImage:[UIImage imageNamed:@""]];
//        }
//        else
//        {
//            [imgCheckbox setImage:[UIImage imageNamed:@""]];
//        }
//    
//    }];
    
//    [btnTerms touchUpInsideClicked:^{
//        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://yuuud.se/termsnconditions.html"]])
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://yuuud.se/termsnconditions.html"]];
//    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
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

#pragma mark - Click Events
#pragma mark -

-(IBAction)btnNextClicked:(UIButton*)sender
{
    if (![txtUserName.text isBlankValidationPassed])
    {
        [[PPAlerts sharedAlerts] showAlertWithType:0 withMessage:CMessageUsername withTitle:@""];
        return;
    }
    else
    {
        if(self.isFromEdit)
        {
            [[APIRequest request] editUsername:txtUserName.text completion:^(id responseObject, NSError *error)
            {
                [CUserDefaults setValue:[[responseObject valueForKey:CJsonData] valueForKey:@"username"] forKey:CUserName];
                [CUserDefaults synchronize];
                [[PPAlerts sharedAlerts] showAlertWithType:3 withMessage:[responseObject stringValueForJSON:CJsonMessage]];
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
        else
        {
//            if (!btnCheckbox.selected)
//            {
//                [[PPAlerts sharedAlerts] showAlertWithType:0 withMessage:CMessageAccept withTitle:@""];
//                return;
//            }
            
            [[APIRequest request] signupWithUserName:txtUserName.text completion:^(id responseObject, NSError *error)
             {
                 [CUserDefaults setValue:[[responseObject valueForKey:CJsonData] valueForKey:@"token"] forKey:CToken];
                 [CUserDefaults setValue:[[responseObject valueForKey:CJsonData] valueForKey:@"username"] forKey:CUserName];
                 [CUserDefaults synchronize];
                 
                 LocationSelectionViewController *objLocation = [LocationSelectionViewController initWithXib];
                 [self.navigationController pushViewController:objLocation animated:YES];
             }];
        }
    }
}

#pragma mark - Textfield delegate methods
#pragma mark -

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:txtUserName])
    {
        NSUInteger oldLength = [textField.text length];
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        if (newLength == 16)
        {
            if (newLength > oldLength)
                return NO;
        }
        return YES;
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [txtUserName resignFirstResponder];
    return YES;
}

@end
