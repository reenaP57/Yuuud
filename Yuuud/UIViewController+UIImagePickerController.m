//
//  UIViewController+UIImagePickerController.m
//  MI API Example
//
//  Created by mac-0001 on 05/11/14.
//  Copyright (c) 2014 MI. All rights reserved.
//


#import "UIViewController+UIImagePickerController.h"

#import "Master.h"
#import "NSObject+NewProperty.h"




static NSString *const ISEDITING = @"editing";
static NSString *const ISANIMATING = @"animating";
static NSString *const COMPLETIONBLOCK = @"completion";
static NSString *const ISPHOTOLIBRARY = @"photolibrary";


@interface UIViewController ()

+(void)displayCustomAlertWithType:(NSInteger)type;

@end

@interface NSDictionary (AssetExtension)

-(void)originalImage:(void (^)(UIImage *image))completion;

@end

@implementation NSDictionary (AssetExtension)

-(void)originalImage:(void (^)(UIImage *image))completion
{
    if ([self objectForKey:UIImagePickerControllerOriginalImage])
    {
        if (completion)
            completion([self objectForKey:UIImagePickerControllerOriginalImage]);
    }
    else
    {
        NSURL *assetURL = [self objectForKey:UIImagePickerControllerReferenceURL];
        
        
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        {
            ALAssetRepresentation *rep = [myasset defaultRepresentation];
            CGImageRef iref = [rep fullResolutionImage];
            if (iref)
            {
                if (completion)
                    completion([UIImage imageWithCGImage:iref]);
            }
        };
        
        ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
        {
            //            if (completion)
            //                completion(nil);
            
            NSLog(@"ALAsset Error, cant get image - %@",[myerror localizedDescription]);
        };
        
        
        if(assetURL)
        {
            ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
            [assetslibrary assetForURL:assetURL resultBlock:resultblock failureBlock:failureblock];
        }
        //        else
        //        {
        //            if (completion)
        //                completion(nil);
        //        }
    }
}

@end


static AVCaptureSession *captureSession = nil;
static AVCaptureVideoPreviewLayer *videoPreviewLayer = nil;



@implementation UIViewController (UIImagePickerController)

#pragma mark - ActionSheet Methods

//-(void)setCustomCamera:(BOOL)camera{
//    isloadcustomcam = camera;
//}
//
-(void)selectImage:(UIImagePickerControllerCompletionBlock)completion
{
    [self selectImageWithEditing:NO animation:YES completion:completion];
}

-(void)selectImageWithEditing:(UIImagePickerControllerCompletionBlock)completion
{
    [self selectImageWithEditing:YES animation:YES completion:completion];
}

-(void)selectImageWithoutAnimation:(UIImagePickerControllerCompletionBlock)completion
{
    [self selectImageWithEditing:NO animation:NO completion:completion];
}

-(void)selectImageWithEditing:(BOOL)editing animation:(BOOL)animation completion:(UIImagePickerControllerCompletionBlock)completion
{
    [self selectImageFromRect:CGRectMake(0, 0, 0, 0) editing:editing animation:animation completion:completion];
}

-(void)selectImageFromRect:(CGRect)rect editing:(BOOL)editing animation:(BOOL)animation completion:(UIImagePickerControllerCompletionBlock)completion
{
    [self presentActionSheetToChooseImageSourceOptions:rect editing:editing animation:animation completion:completion];
}


-(void)presentActionSheetToChooseImageSourceOptions:(CGRect)rect editing:(BOOL)editing animation:(BOOL)animation completion:(UIImagePickerControllerCompletionBlock)completion
{
    [self setObject:[NSNumber numberWithBool:editing] forKey:ISEDITING];
    [self setObject:[NSNumber numberWithBool:animation] forKey:ISANIMATING];
    [self setObject:completion forKey:COMPLETIONBLOCK];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:MILocalizedString(@"ImagePickerActionSheetCancelButton", @"Cancel") destructiveButtonTitle:nil otherButtonTitles:MILocalizedString(@"ImagePickerActionSheetCameraButton", @"Take New Photo"),MILocalizedString(@"ImagePickerActionSheetPhotoLibraryButton",@"Choose from Existing Photos"),nil];
    [actionSheet showFromRect:rect inView:self.view animated:YES];
    
    
    void(^ClickHandler)(NSInteger buttonIndex);
    
    ClickHandler = ^(NSInteger buttonIndex)
    {
        if (buttonIndex == 0)
        {
            [self presentUIImagePickerController:UIImagePickerControllerSourceTypeCamera editing:[[self objectForKey:ISEDITING] boolValue] animating:[[self objectForKey:ISANIMATING] boolValue] finished:[self objectForKey:COMPLETIONBLOCK]];
        }
        else if (buttonIndex == 1)
        {
            [self presentUIImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary editing:[[self objectForKey:ISEDITING] boolValue] animating:[[self objectForKey:ISANIMATING] boolValue] finished:[self objectForKey:COMPLETIONBLOCK]];
        }
    };
    
    
    if (IS_IPAD)
        [actionSheet setDismissActionHandler:ClickHandler];
    else
        [actionSheet setActionHandler:ClickHandler];
}

#pragma mark - Class Methods



-(void)presentCamera:(UIImagePickerControllerCompletionBlock)completion
{
    [self presentCameraWithEditing:NO animation:YES withPhotoLibrary:NO completion:completion];
}

-(void)presentCameraWithEditingImage:(UIImagePickerControllerCompletionBlock)completion
{
    [self presentCameraWithEditing:YES animation:YES completion:completion];
}

-(void)presentCameraWithoutAnimation:(UIImagePickerControllerCompletionBlock)completion
{
    [self presentCameraWithEditing:NO animation:NO completion:completion];
}

-(void)presentCameraWithEditing:(BOOL)editing animation:(BOOL)animation completion:(UIImagePickerControllerCompletionBlock)completion
{
    [self presentCameraWithEditing:editing animation:animation withPhotoLibrary:NO completion:completion];
}

-(void)presentCameraWithEditing:(BOOL)editing animation:(BOOL)animation withPhotoLibrary:(BOOL)photoLibrary completion:(UIImagePickerControllerCompletionBlock)completion
{
    [self setBoolean:photoLibrary forKey:ISPHOTOLIBRARY];
    
    [self presentUIImagePickerController:UIImagePickerControllerSourceTypeCamera editing:editing animating:animation finished:completion];
}




-(void)presentPhotoLibrary:(UIImagePickerControllerCompletionBlock)completion
{
    [self presentPhotoLibraryWithEditing:NO animation:YES completion:completion];
}

-(void)presentPhotoLibraryWithEditingImage:(UIImagePickerControllerCompletionBlock)completion
{
    [self presentPhotoLibraryWithEditing:YES animation:YES completion:completion];
}

-(void)presentPhotoLibraryWithoutAnimation:(UIImagePickerControllerCompletionBlock)completion
{
    [self presentPhotoLibraryWithEditing:NO animation:NO completion:completion];
}

-(void)presentPhotoLibraryWithEditing:(BOOL)editing animation:(BOOL)animation completion:(UIImagePickerControllerCompletionBlock)completion
{
    [self presentUIImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary editing:editing animating:animation finished:completion];
}

- (void)presentUIImagePickerController:(UIImagePickerControllerSourceType)sourceType editing:(BOOL)editing animating:(BOOL)animating finished:(UIImagePickerControllerCompletionBlock)finished
{
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            
            switch (status)
            {
                case AVAuthorizationStatusAuthorized:
                {
                    dispatch_async(GCDMainThread, ^{
                        [self openUIImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera editing:editing animating:animating finished:finished];
                    });
                };
                    break;
                case AVAuthorizationStatusNotDetermined:
                {
                    // seek access first:
                    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                        if(granted)
                        {
                            dispatch_async(GCDMainThread, ^{
                                [self openUIImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera editing:editing animating:animating finished:finished];
                            });
                        }
                        else
                        {
                            //Open settings url
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Permission denied" message:@"Please enable permisssion from Settings > Privacy > Camera." delegate:nil cancelButtonTitle:@"Settings" otherButtonTitles:@"Cancel", nil];
                            
                            [alert show:^(NSInteger buttonIndex) {
                                
                                if (buttonIndex == 0)
                                {
                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                }
                            }];
                        }
                    }];
                }; break;
                    
                case AVAuthorizationStatusDenied:
                case AVAuthorizationStatusRestricted:
                default:
                {
                    dispatch_async(GCDMainThread, ^{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Permission denied" message:@"Please enable permisssion from Settings > Privacy > Camera." delegate:nil cancelButtonTitle:@"Settings" otherButtonTitles:@"Cancel", nil];
                        
                        [alert show:^(NSInteger buttonIndex) {
                            
                            if (buttonIndex == 0)
                            {
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                            }
                        }];
                    });
                }; break;
            }
        }
        else
            [[PPAlerts sharedAlerts] showAlertWithType:0 withMessage:MILocalizedString(@"ImagePickerControllerCameraSupportError", @"No Camera Available") withTitle:@""];
    }
    else if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary || sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum)
    {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                
                switch (status)
                {
                    case PHAuthorizationStatusAuthorized:
                    {
                        dispatch_async(GCDMainThread, ^{
                            [self openUIImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary editing:editing animating:animating finished:finished];
                        });
                    };
                        break;
                        
                    case PHAuthorizationStatusRestricted:
                    case PHAuthorizationStatusDenied:
                    default:
                    {
                        //Open settings url
                        dispatch_async(GCDMainThread, ^{
                            
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Permission denied" message:@"Please enable permisssion from Settings > Privacy > Photos." delegate:nil cancelButtonTitle:@"Settings" otherButtonTitles:@"Cancel", nil];
                            
                            [alert show:^(NSInteger buttonIndex) {
                                
                                if (buttonIndex == 0)
                                {
                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                }
                            }];
                        });
                    };
                        break;
                }
            }];
        }
        else
            [[PPAlerts sharedAlerts] showAlertWithType:0 withMessage:MILocalizedString(@"ImagePickerControllerPhotoLibrarySupportError", @"Your device dosen't support photo library!") withTitle:@""];
    }
}


#pragma mark - UIImagePickerController

-(UIView *)customOverlayViewForGalleryButton
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(120, CScreenHeight-100, CScreenWidth-120, 100)];
    
    UIButton *btnGallery = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGallery.frame = CGRectMake(view.frame.size.width - 45 - 10, view.frame.size.height-45-10, 45, 45);
    [UIViewController latestThumbnail:^(UIImage *img) {
        [btnGallery setImage:img forState:UIControlStateNormal];
    }];
    [view addSubview:btnGallery];
    
    
    UIButton *btnCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCamera setBackgroundColor:[UIColor clearColor]];
    btnCamera.frame = CGRectMake(0, view.frame.size.height-96-10, 96, 96);
    [view addSubview:btnCamera];
    
    [btnGallery touchUpInsideClicked:^{
        [((UIImagePickerController *)view.viewController) setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    
    [btnCamera touchUpInsideClicked:^{
        [((UIImagePickerController *)view.viewController) setShowsCameraControls:NO];
        [((UIImagePickerController *)view.viewController) takePicture];
    }];
    
    return view;
}


-(void)openUIImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType editing:(BOOL)editing animating:(BOOL)animating finished:(UIImagePickerControllerCompletionBlock)finished
{
    [self setObject:[NSNumber numberWithBool:editing] forKey:ISEDITING];
    [self setObject:[NSNumber numberWithBool:animating] forKey:ISANIMATING];
    [self setObject:finished forKey:COMPLETIONBLOCK];
    
    //    if (isloadcustomcam){
    //        //Default buttons
    //        SimpleCam * simpleCam = [SimpleCam new];
    //        simpleCam.delegate= self;
    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //            [self presentViewController:simpleCam animated:[[self objectForKey:@"animating"] boolValue] completion:^{
    //                [[UIApplication sharedApplication] setStatusBarHidden:YES];
    //            }];
    //        });
    //    }
    //    else
    {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker setSourceType:sourceType];
        picker.delegate = self;
        picker.allowsEditing = [[self objectForKey:ISEDITING] boolValue];
        
        if ([self booleanForKey:ISPHOTOLIBRARY])
            picker.cameraOverlayView = [self customOverlayViewForGalleryButton];
        
        [self presentViewController:picker animated:[[self objectForKey:ISANIMATING] boolValue] completion:nil];
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:[[self objectForKey:ISANIMATING] boolValue] completion:^{
        
        [self setBoolean:NO forKey:ISPHOTOLIBRARY];
        
        UIImage *image;
        
        if ([[self objectForKey:ISEDITING] boolValue])
        {
            image = [info valueForKey:UIImagePickerControllerEditedImage];
        }
        else
        {
            image = [info valueForKey:UIImagePickerControllerOriginalImage];
        }
        
        UIImagePickerControllerCompletionBlock completion = [self objectForKey:COMPLETIONBLOCK];
        
        
        if (!image)
        {
            [info originalImage:^(UIImage *imagel) {
                
                if (completion)
                    completion(imagel);
                
            }];
        }
        else
        {
            if (completion)
                completion(image);
        }
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary && [self booleanForKey:ISPHOTOLIBRARY])
    {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        [self dismissViewControllerAnimated:[[self objectForKey:ISANIMATING] boolValue] completion:^{
            
            [self setBoolean:NO forKey:ISPHOTOLIBRARY];
            
            UIImagePickerControllerCompletionBlock completion = [self objectForKey:COMPLETIONBLOCK];
            
            if (completion)
                completion(nil);
            
        }];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UINavigationBar *bar = navigationController.navigationBar;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [bar setTintColor:[UIColor whiteColor]];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [bar setBackgroundImage:[UIImage imageNamed:@"bg_navbarImage"] forBarMetrics:UIBarMetricsDefault];
    bar.translucent = NO;
}

#pragma mark - Assets Library

- (void)loadAssetsAtCount:(int)count progress:(void(^)(NSArray *contacts))progress completion:(void(^)(NSArray *contacts))completion
{
    NSMutableArray *assets = [[NSMutableArray alloc] init];
    NSMutableArray *assetsProgress;
    
    if (progress)
        assetsProgress = [[NSMutableArray alloc] init];
    
    ALAssetsLibrary *_assetLibrary = [[ALAssetsLibrary alloc] init];
    
    // Run in the background as it takes a while to get all assets from the library
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *assetGroups = [[NSMutableArray alloc] init];
        //        NSMutableArray *assetURLDictionaries = [[NSMutableArray alloc] init];
        
        // Process assets
        void (^assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result != nil) {
                if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                    //                    [assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                    NSURL *url = result.defaultRepresentation.url;
                    [_assetLibrary assetForURL:url
                                   resultBlock:^(ALAsset *asset) {
                                       if (asset) {
                                           @synchronized(assets) {
                                               [assets addObject:@{@"url":asset.defaultRepresentation.url,@"image":[UIImage imageWithCGImage:asset.thumbnail]}];
                                               
                                               if (progress)
                                                   [assetGroups addObject:[assets lastObject]];
                                               
                                               
                                               if (progress && assetsProgress.count%count == 0)
                                               {
                                                   progress(assetsProgress);
                                                   [assetsProgress removeAllObjects];
                                               }
                                           }
                                       }
                                   }
                                  failureBlock:^(NSError *error){
                                      NSLog(@"operation was not successfull!");
                                  }];
                    
                }
            }
        };
        
        // Process groups
        void (^ assetGroupEnumerator) (ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
            if (group != nil) {
                [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:assetEnumerator];
                [assetGroups addObject:group];
            }
            
            if (progress && assetsProgress.count%count == 0)
            {
                progress(assetsProgress);
                [assetsProgress removeAllObjects];
            }
            
            if (completion)
                completion(assets);
        };
        
        // Process!
        [_assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                     usingBlock:assetGroupEnumerator
                                   failureBlock:^(NSError *error) {
                                       NSLog(@"There is an error");
                                   }];
        
    });
    
}

+(void)latestThumbnail:(void(^)(UIImage *img))completion
{
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop)
     {
         NSInteger numberOfAssets = [group numberOfAssets];
         if (numberOfAssets > 0)
         {
             NSInteger lastIndex = numberOfAssets - 1;
             [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:lastIndex] options:0 usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
              {
                  UIImage *thumbnail = [UIImage imageWithCGImage:[result thumbnail]];
                  if (thumbnail && thumbnail.size.width > 0)
                  {
                      *stop = YES;
                      if (completion)
                          completion(thumbnail);
                  }
              }];
         }
         else
             NSLog(@"error: No Photos found.");

     } failureBlock:^(NSError *error) {
         NSLog(@"error: %@", error);
         if (completion)
             completion(nil);
     }];
}


#pragma mark SIMPLE CAM DELEGATE

//- (void) simpleCam:(SimpleCam *)simpleCam didFinishWithImage:(UIImage *)image
//{
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
//
//    // Close simpleCam - use this as opposed to 'dismissViewController' otherwise, the captureSession may not close properly and may result in memory leaks.
//    [simpleCam closeWithCompletion:^{
//        isloadcustomcam = NO;
//        NSLog(@"SimpleCam is done closing ... ");
//
//        UIImagePickerControllerCompletionBlock completion = [self objectForKey:@"completion"];
//
//
//        if (image) {
//            // simple cam finished with image
//            if (completion)
//                completion(image);
//            //_tapLabel.hidden = NO;
//        }
//        else {
//            // simple cam finished w/o image
//            if (completion)
//                completion(nil);
//            //_tapLabel.hidden = NO;
//        }
//
//    }];
//}
//
//- (void) simpleCamDidLoadCameraIntoView:(SimpleCam *)simpleCam
//{
//    NSLog(@"Camera loaded ... ");
//    // if (self.takePhotoImmediately) {
//    // [simpleCam capturePhoto];
//    // }
//}
//
//- (void) simpleCamNotAuthorizedForCameraUse:(SimpleCam *)simpleCam
//{
//    [simpleCam closeWithCompletion:^{
//        NSLog(@"SimpleCam is done closing ... Not Authorized");
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"you are not authorised to access camera" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
//    }];
//}
//


#pragma mark - Scan Code

+(void)scanCode:(ScanCode)completion
{
    UIViewController *controller = [[UIViewController alloc] init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [[UIApplication topMostController] presentViewController:navigationController animated:YES completion:^{
        [self scanCodeOnView:controller.view completion:completion];

        controller.title = MILocalizedString(@"ScanningViewControllerTitle", @"Scanning...");
        controller.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:nil];
        [controller.navigationItem.leftBarButtonItem clicked:^{
            [UIViewController stopReading];
            [navigationController dismissViewControllerAnimated:YES completion:nil];
        }];
    }];
}

+(void)scanCodeOnView:(UIView *)view completion:(ScanCode)completion
{
    NSParameterAssert(completion);
    
    [[UIApplication sharedApplication] setObject:completion forKey:@"scanningBlock"];
    
    NSError *error;
    
    // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
    // as the media type parameter.
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Get an instance of the AVCaptureDeviceInput class using the previous device object.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        // If any error occurs, simply log the description of it and don't continue any more.
        NSLog(@"%@", [error localizedDescription]);
        return;
    }
    
    // Initialize the captureSession object.
    captureSession = [[AVCaptureSession alloc] init];
    // Set the input device on the capture session.
    [captureSession addInput:input];
    
    
    // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [captureSession addOutput:captureMetadataOutput];
    
    // Create a new serial dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:[DelegateObserver sharedInstance] queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeQRCode,AVMetadataObjectTypeAztecCode,nil]];
    
/*
    Add below codes on above array when minimum deplayoment target is ios 8.0
 
    AVF_EXPORT NSString *const AVMetadataObjectTypeInterleaved2of5Code NS_AVAILABLE(NA, 8_0);
    AVF_EXPORT NSString *const AVMetadataObjectTypeITF14Code NS_AVAILABLE(NA, 8_0);
    AVF_EXPORT NSString *const AVMetadataObjectTypeDataMatrixCode NS_AVAILABLE(NA, 8_0);
*/

    
    
    // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
    videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    [videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [videoPreviewLayer setFrame:view.layer.bounds];
    [view.layer addSublayer:videoPreviewLayer];
    
    
    // Start video capture.
    [captureSession startRunning];
}

+(void)stopReading{
    // Stop video capture and make the capture session object nil.
    
    asyncMain(^{
        [captureSession stopRunning];
        captureSession = nil;
        
        // Remove the video preview layer from the viewPreview view's layer.
        [videoPreviewLayer removeFromSuperlayer];
    });
}

@end
