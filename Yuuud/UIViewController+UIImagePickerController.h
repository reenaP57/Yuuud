//
//  UIViewController+UIImagePickerController.h
//  MI API Example
//
//  Created by mac-0001 on 05/11/14.
//  Copyright (c) 2014 MI. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

//#import "SimpleCam.h"

typedef void(^UIImagePickerControllerCompletionBlock)(UIImage *image);
typedef void(^ScanCode)(NSString *resultString);


@interface UIViewController (UIImagePickerController) <UIImagePickerControllerDelegate,UINavigationControllerDelegate>//,SimpleCamDelegate>


//
//@property (nonatomic,strong) SimpleCam *simpleCam;
//-(void)setCustomCamera:(BOOL)camera;


-(void)selectImage:(UIImagePickerControllerCompletionBlock)completion;
-(void)selectImageWithEditing:(UIImagePickerControllerCompletionBlock)completion;
-(void)selectImageWithoutAnimation:(UIImagePickerControllerCompletionBlock)completion;
-(void)selectImageWithEditing:(BOOL)editing animation:(BOOL)animation completion:(UIImagePickerControllerCompletionBlock)completion;
-(void)selectImageFromRect:(CGRect)rect editing:(BOOL)editing animation:(BOOL)animation completion:(UIImagePickerControllerCompletionBlock)completion;


-(void)presentCamera:(UIImagePickerControllerCompletionBlock)completion;
-(void)presentCameraWithEditingImage:(UIImagePickerControllerCompletionBlock)completion;
-(void)presentCameraWithoutAnimation:(UIImagePickerControllerCompletionBlock)completion;
-(void)presentCameraWithEditing:(BOOL)editing animation:(BOOL)animation completion:(UIImagePickerControllerCompletionBlock)completion;
-(void)presentCameraWithEditing:(BOOL)editing animation:(BOOL)animation withPhotoLibrary:(BOOL)photoLibrary completion:(UIImagePickerControllerCompletionBlock)completion;

-(void)presentPhotoLibrary:(UIImagePickerControllerCompletionBlock)completion;
-(void)presentPhotoLibraryWithEditingImage:(UIImagePickerControllerCompletionBlock)completion;
-(void)presentPhotoLibraryWithoutAnimation:(UIImagePickerControllerCompletionBlock)completion;
-(void)presentPhotoLibraryWithEditing:(BOOL)editing animation:(BOOL)animation completion:(UIImagePickerControllerCompletionBlock)completion;


- (void)loadAssetsAtCount:(int)count progress:(void(^)(NSArray *contacts))progress completion:(void(^)(NSArray *contacts))completion;
+(void)latestThumbnail:(void(^)(UIImage *img))completion;




+(void)scanCode:(ScanCode)completion;
+(void)scanCodeOnView:(UIView *)view completion:(ScanCode)completion;
+(void)stopReading;

@end




// To-Do Test Custom Camera with - Landscape Orientation.
// To-Do Add Image Cropping class with custom cropping size, also set round circle for profile image
