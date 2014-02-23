//
//  MSGRImageViewController.h
//  messengAR
//
//  Created by   on 2/22/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>

@class MSGRMessage;

@interface MSGRImageViewController : UIViewController <UIImagePickerControllerDelegate, UITextFieldDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (nonatomic, assign) bool shouldPresentCamera;
@property (strong, nonatomic) UITextField *activeTextField;
@property (strong, nonatomic) MSGRMessage *message;

@end
