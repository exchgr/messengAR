//
//  MSGRAddHintController.h
//  messengAR
//
//  Created by   on 2/23/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSGRMessage;

@interface MSGRAddHintController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *hintField;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) MSGRMessage *message;

@end
