//
//  PopUpViewController.m
//  ChamRDV
//
//  Created by mac-0001 on 6/27/14.
//  Copyright (c) 2014 MIND INVENTORY. All rights reserved.
//

#import "PopUpViewController.h"

#import "Constants.h"

@interface PopUpViewController ()

@end

@implementation PopUpViewController

@synthesize shouldHideOnOutsideClick;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
    
    UIButton *btnOutside = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOutside setFrame:self.view.frame];
    CViewSetOrigin(btnOutside, 0, 0);
    [btnOutside addTarget:self action:@selector(btnCloseClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnOutside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)btnCloseClicked:(id)sender
{
    if (shouldHideOnOutsideClick)
    {
        if (self.closeHandler)
        {
            self.closeHandler(YES);
        }
    }
}

-(void)setCloseEventWithHandler:(void (^)(BOOL animated))closeHandler;
{
    self.closeHandler=closeHandler;
}

@end
