//
//  MSGRLoginViewController.m
//  messengAR
//
//  Created by   on 2/23/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import "MSGRLoginViewController.h"
#import "MSGRMessagesListViewController.h"

@interface MSGRLoginViewController ()

@end

@implementation MSGRLoginViewController

- (IBAction)logIn:(id)sender
{
    NSString *email = [_emailField text];
    NSString *password = [_passwordField text];
    // validate(?)
    // push next view controller:
    MSGRMessagesListViewController *listControl = [[MSGRMessagesListViewController alloc] init];
    [[self navigationController] pushViewController:listControl animated:true];
}

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
    [_emailField addTarget:self action:@selector(resignFirstResponder)forControlEvents:UIControlEventEditingDidEndOnExit];
    [_passwordField addTarget:self action:@selector(resignFirstResponder)forControlEvents:UIControlEventEditingDidEndOnExit];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
