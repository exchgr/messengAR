//
//  MSGRMessage.h
//  messengAR
//
//  Created by   on 2/22/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MSGRMessage : NSObject

@property (nonatomic, assign) double yaw;
@property (nonatomic, assign) double pitch;
@property (nonatomic, assign) double roll;
@property (nonatomic, assign) CLLocationDirection heading;
@property (nonatomic, assign) double pointX;
@property (nonatomic, assign) double pointY;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *messageText;
@property (strong, nonatomic) NSString *hintText;
@property (strong, nonatomic) NSString *sender;
@property (strong, nonatomic) NSString *recipient;

@end
