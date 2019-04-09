//
//  RecordViewController.h
//  MY_Audio_Demo
//
//  Created by mac-00015 on 2/21/17.
//  Copyright © 2017 mac-00012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCSiriWaveformView.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>


@interface RecordViewController : SuperViewController<AVAudioPlayerDelegate, AVAudioRecorderDelegate, UITextFieldDelegate>
{
    IBOutlet UIButton *btnRecord, *btnHide, *btnSave,*btnLock;
    IBOutlet UILabel *lblRecording,*lblRecordingTime;
    IBOutlet NSLayoutConstraint *cnBtnRecordBottomSpace, *cnBtnRecordX;
    IBOutlet SCSiriWaveformView *waveformView;
    IBOutlet UIImageView *imgLock;
}

@end
