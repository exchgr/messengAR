//
//  MSGRAddHintController.m
//  messengAR
//
//  Created by   on 2/23/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import "MSGRAddHintController.h"
#import "MSGRMessage.h"
#import <AFNetworking/AFNetworking.h>

@interface MSGRAddHintController ()

@end

@implementation MSGRAddHintController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_hintField addTarget:self action:@selector(resignFirstResponder)forControlEvents:UIControlEventEditingDidEndOnExit];
    [_usernameField addTarget:self action:@selector(resignFirstResponder)forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (BOOL)resignFirstResponder
{
    [super resignFirstResponder];
    [_hintField resignFirstResponder];
    [_usernameField resignFirstResponder];
    if (![[_usernameField text] isEqualToString:@""])
    {
        [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Deliver" style:UIBarButtonItemStylePlain target:self action:@selector(deliverMessage)]];
    }
    else
    {
        [[self navigationItem] setRightBarButtonItem:nil];
    }
    return true;
}

- (void)viewWillAppear:(BOOL)animated
{
    [_hintField becomeFirstResponder];
}

- (void)deliverMessage
{
    [_message setHintText:[_hintField text]];
    [_message setRecipient:[_usernameField text]];
    
    // send message to server
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"message[yaw]":[NSNumber numberWithDouble:[_message yaw]],
                            @"message[pitch]":[NSNumber numberWithDouble:[_message pitch]],
                            @"message[roll]":[NSNumber numberWithDouble:[_message roll]],
                            @"message[heading]":[NSNumber numberWithDouble:[_message heading]],
                             @"message[pointX]":[NSNumber numberWithDouble:[_message pointX]],
                             @"message[pointY]":[NSNumber numberWithDouble:[_message pointY]],
                             @"message[location]":[_message location],
                             @"message[messageText]":[_message messageText],
                             @"message[hintText]":[_message hintText],
                             @"message[sender]":[_message sender],
                             @"message[recipient]":[_message recipient]};
    
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    
    [manager POST:@"http://mysite.com/myobject" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
                                                                            {
                                                                                NSLog(@"JSON: %@", responseObject);
                                                                            } failure:^(AFHTTPRequestOperation *operation, NSError *error){
                                                                                NSLog(@"Error: %@", error);
                                                                            }];
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
