//
//  HomeCell.m
//  Yuuud
//
//  Created by mac-00015 on 2/24/17.
//  Copyright © 2017 MindInventory. All rights reserved.
//

#import "HomeCell.h"

@implementation HomeCell
{
//    MIAudioWaveform *waveForm;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    ActivityIndicator.hidden = YES;
    [ActivityIndicator stopAnimating];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)generateWaveform:(NSDictionary *)dicWaveForm runningAudio:(MIAudioWaveform*)runningAudio
{
    if (self.waveForm)
        [self.waveForm removeFromSuperview];
    
    if (runningAudio)
    {
        self.waveForm = runningAudio;
        self.waveForm.frame = CGRectMake(0, 0, self.viewWaveForm.frame.size.width, self.viewWaveForm.frame.size.height) ;
        [self.viewWaveForm addSubview:self.waveForm];
    }
    else
    {
        self.waveForm = [[MIAudioWaveform alloc] initWithSize:CGSizeMake(self.viewWaveForm.frame.size.width, self.viewWaveForm.frame.size.height) andNormalImage:nil andProgressImage:nil Data:dicWaveForm];
        self.waveForm.delegate = self;
        [self.viewWaveForm addSubview:self.waveForm];
    }
    
    [UIView animateWithDuration:.01 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)PlayAudioFile:(NSString *)strUrl
{
    [self.waveForm StartProgressToFilldata:strUrl];
}


@end
