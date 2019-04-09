//
//  SuperViewController.h
//  ChamRDV
//
//  Created by mac-0005 on 12/21/13.
//  Copyright (c) 2013 MIND INVENTORY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SuperNavigationController.h"
#import <CoreData/CoreData.h>

@interface SuperViewController : UIViewController <AVAudioPlayerDelegate>  /// # MI-PickerKeyboard
{
    UITableView *superTable;
    UICollectionView *superCollectionview;
    NSString *fileStorageName;
    
    UILabel *lastUpdateLabel, *updateLabel;
    
    UIImageView *updateImageView, *updateImageViewPng;
    
    UIActivityIndicatorView *spinner;
    
    AVAudioPlayer *audio;
    UIScrollView *scrollNavigationHide;
}

- (void)stopUpdating;
- (void)scrollViewDidScroll:(UIScrollView *)sender;

@end

