//
//  MSGRImageViewController.m
//  messengAR
//
//  Created by   on 2/22/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import "MSGRImageViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <ImageIO/CGImageSource.h>
#import <ImageIO/CGImageProperties.h>
#import <CoreLocation/CoreLocation.h>

@interface MSGRImageViewController ()

@end

@implementation MSGRImageViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        _locationManager = [CLLocationManager new];
        [_locationManager setDelegate:self];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [_imageView addGestureRecognizer:singleFingerTap];
    
    // UINavigationBar *bar = [[UINavigationBar alloc] init];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    
    [[self navigationItem] setRightBarButtonItem:right animated:NO];
    [[self navigationItem] setLeftBarButtonItem:left animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_shouldPresentCamera)
    {
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeCamera])
        {
            _shouldPresentCamera = false;
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            [imagePicker setDelegate:self];
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [imagePicker setMediaTypes:@[(NSString *) kUTTypeImage]];
            [imagePicker setAllowsEditing:NO];
            [self presentViewController:imagePicker
                               animated:YES completion:nil];
            [_locationManager startUpdatingLocation];
        }
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        ALAssetsLibrary *lib = [ALAssetsLibrary new];
        void (^libBlock)(NSURL*,NSError*) = ^(NSURL *assetURL, NSError *error) {
            ALAssetsLibrary *al = [ALAssetsLibrary new];
            [al assetForURL:assetURL resultBlock:^(ALAsset *asset)
             {
                 UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
                 CLLocation *location = [asset valueForProperty:ALAssetPropertyLocation];
                 [self dismissViewControllerAnimated:YES completion:nil];
             } failureBlock:nil];
        };
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:info[UIImagePickerControllerMediaMetadata]];
        NSMutableDictionary *gps = [NSMutableDictionary new];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        if (_deviceLocation.coordinate.latitude < 0.0) {
            gps[(__bridge NSString *)kCGImagePropertyGPSLatitude] = [NSNumber numberWithFloat:-_deviceLocation.coordinate.latitude];
            gps[(__bridge NSString *)kCGImagePropertyGPSLatitudeRef] = @"S";
        } else {
            gps[(__bridge NSString *)kCGImagePropertyGPSLatitude] = [NSNumber numberWithFloat:_deviceLocation.coordinate.latitude];
            gps[(__bridge NSString *)kCGImagePropertyGPSLatitudeRef] = @"N";
        }
        if (_deviceLocation.coordinate.longitude < 0.0) {
            gps[(__bridge NSString *)kCGImagePropertyGPSLongitude] = [NSNumber numberWithFloat:-_deviceLocation.coordinate.longitude];
            gps[(__bridge NSString *)kCGImagePropertyGPSLongitudeRef] = @"W";
        } else {
            gps[(__bridge NSString *)kCGImagePropertyGPSLongitude] = [NSNumber numberWithFloat:_deviceLocation.coordinate.longitude];
            gps[(__bridge NSString *)kCGImagePropertyGPSLongitudeRef] = @"E";
        }
        df.dateFormat = @"yyyy:MM:dd";
        gps[(__bridge NSString *)kCGImagePropertyGPSDateStamp] = [df stringFromDate:[NSDate date]];
        df.dateFormat = @"HH:mm:ss";
        gps[(__bridge NSString *)kCGImagePropertyGPSTimeStamp] = [df stringFromDate:[NSDate date]];
        dict[(__bridge NSString *)kCGImagePropertyGPSDictionary] = gps;
        UIImage *img = info[UIImagePickerControllerEditedImage] ? info[UIImagePickerControllerEditedImage] : info[UIImagePickerControllerOriginalImage];
        [lib writeImageToSavedPhotosAlbum:img.CGImage metadata:dict completionBlock:libBlock];
        
        [_locationManager stopUpdatingLocation];
        [[self navigationController] setNavigationBarHidden:false];
        [_imageView setImage:image];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:NO completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    NSLog(@"%f", location.x);
    NSLog(@"%f", location.y);
    _activeTextField = [[UITextField alloc] initWithFrame:CGRectMake(location.x, location.y, 160, 31)];
    [_activeTextField addTarget:self action:@selector(resignFirstResponder)forControlEvents:UIControlEventEditingDidEndOnExit];
    [[self view] addSubview:_activeTextField];
    [_activeTextField becomeFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _activeTextField = textField;
    return YES;
}

- (BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    _activeTextField = nil;
    [textField resignFirstResponder];
    return YES;
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}


@end
