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
#import <CoreMotion/CoreMotion.h>
#import "MSGRMessage.h"
#import "MSGRMessageStore.h"
#import "MSGRUsernameStore.h"
#import "MSGRAddHintController.h"

@interface MSGRImageViewController ()

@end

@implementation MSGRImageViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        _locationManager = [CLLocationManager new];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        _motionManager = [[CMMotionManager alloc] init];
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
            [_locationManager startUpdatingHeading];
            [_motionManager startGyroUpdates];
            [_motionManager startDeviceMotionUpdates];
        }
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        CLLocation *location = [_locationManager location];
        [_locationManager stopUpdatingLocation];
        
        CLHeading *heading = [_locationManager heading];
        CLLocationDirection trueHeading = [heading trueHeading];
        
        CMDeviceMotion *deviceMotion = [_motionManager deviceMotion];
        CMAttitude *attitude = [deviceMotion attitude];
        
        _message = [[MSGRMessage alloc] init];
        [_message setLocation:location];
        [_message setImage:image];
        [_message setYaw:[attitude yaw]];
        [_message setPitch:[attitude pitch]];
        [_message setRoll:[attitude roll]];
        [_message setHeading:trueHeading];
        [_message setSender:[[[MSGRUsernameStore sharedStore] usernames] objectAtIndex:0]];
        
        // TODO: delete this test code
        [[MSGRMessageStore sharedStore] addMessage:_message];
        // end TODO
        
        [[self navigationController] setNavigationBarHidden:false];
        [_imageView setImage:image];
        [self dismissViewControllerAnimated:YES completion:Nil];
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
    CGPoint point;
    point.x = location.x;
    point.y = location.y;
    [_message setPoint:point];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _activeTextField = textField;
    return YES;
}

- (BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}

- (BOOL)resignFirstResponder
{
    [super resignFirstResponder];
    [_activeTextField resignFirstResponder];
    NSLog(@"does this method get called");
    [_message setMessageText:[_activeTextField text]];
    return true;
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (void)send
{
    MSGRAddHintController *hintController = [[MSGRAddHintController alloc] init];
    [hintController setMessage:_message];
    [[self navigationController] pushViewController:hintController animated:true];
}


@end
