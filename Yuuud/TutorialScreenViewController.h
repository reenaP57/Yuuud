//
//  ViewController.h
//  VerticalIntroScroll
//
//  Created by mac-0009 on 01/03/17.
//  Copyright © 2017 mac-0009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialScreenViewController : UIViewController <UIGestureRecognizerDelegate>
{
    IBOutlet UIScrollView *scrollViewMain;
    
    IBOutlet UIView *view1;
    IBOutlet UIView *view2;
    IBOutlet UIView *view3;
    IBOutlet UIView *view4;
    IBOutlet UIView *view5;
    IBOutlet UIView *view6;
    
    IBOutlet UIView *viewButton1;
    IBOutlet UIView *viewButton2;
    IBOutlet UIView *viewButton3;
    IBOutlet UIView *viewButton4;
    IBOutlet UIView *viewButton5;
    IBOutlet UIView *viewButton6;
    
    IBOutlet UIImageView *imgView1;
    IBOutlet UIImageView *imgView2;
    IBOutlet UIImageView *imgView3;
    IBOutlet UIImageView *imgView4;
    IBOutlet UIImageView *imgView5;
    IBOutlet UIImageView *imgView6;
    
    IBOutlet UILabel *lblTitle1;
    IBOutlet UILabel *lblTitle2;
    IBOutlet UILabel *lblTitle3;
    IBOutlet UILabel *lblTitle4;
    IBOutlet UILabel *lblTitle5;
    IBOutlet UILabel *lblTitle6;
    
    IBOutlet UIButton *btnNext;
    IBOutlet UIButton *btnSkip;
}

@property (nonatomic, assign) BOOL isFromSettings;

@end

