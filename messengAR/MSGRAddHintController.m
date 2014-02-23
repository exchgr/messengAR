//
//  MSGRAddHintController.m
//  messengAR
//
//  Created by   on 2/23/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import "MSGRAddHintController.h"
#import "MSGRMessage.h"

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
