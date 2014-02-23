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
#import "MSGRUsernameStore.h"
#import <CoreLocation/CoreLocation.h>

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
    double latitude = [_message location].coordinate.latitude;
    double longitude = [_message location].coordinate.longitude;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
   // manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *params = @{@"yaw":[NSNumber numberWithDouble:[_message yaw]],
                            @"pitch":[NSNumber numberWithDouble:[_message pitch]],
                            @"roll":[NSNumber numberWithDouble:[_message roll]],
                            @"heading":[NSNumber numberWithDouble:[_message heading]],
                             @"screenX":[NSNumber numberWithDouble:[_message pointX]],
                             @"screenY":[NSNumber numberWithDouble:[_message pointY]],
                             @"longitude":[NSNumber numberWithDouble:longitude],
                             @"latitude":[NSNumber numberWithDouble:latitude],
                             @"content":[_message messageText],
                             @"hint":[_message hintText],
//                             @"message[auth_token]":[[[MSGRUsernameStore sharedStore] usernames] objectAtIndex:0],
                             @"recipient":@"drmmundy@me.com"
                             };
//                             @"message[sender]":[_message sender],
//                             @"message[recipient]":[_message recipient]
                             
    
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    
    NSString *postString = @"http://23.239.12.189:3000/messages.json?auth_token=";
    postString = [postString stringByAppendingString:[[[MSGRUsernameStore sharedStore] usernames] objectAtIndex:0]];
    
    [manager POST:postString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
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
