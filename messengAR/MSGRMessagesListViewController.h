//
//  MSGRMessagesListViewController.h
//  messengAR
//
//  Created by   on 2/22/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>

@class MSGRMessage;

@interface MSGRMessagesListViewController : UITableViewController <UIImagePickerControllerDelegate>

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) MSGRMessage *message;

@end
