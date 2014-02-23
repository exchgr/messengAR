//
//  MSGRLoginViewController.h
//  messengAR
//
//  Created by   on 2/23/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSGRLoginViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)logIn:(id)sender;

@end
