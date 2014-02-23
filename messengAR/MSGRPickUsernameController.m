//
//  MSGRPickUsernameController.m
//  messengAR
//
//  Created by   on 2/23/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import "MSGRPickUsernameController.h"
#import "MSGRUsernameStore.h"

@interface MSGRPickUsernameController ()

@end

@implementation MSGRPickUsernameController

- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationItem] setHidesBackButton:true];
}

- (void)viewDidAppear:(BOOL)animated
{
    [_textField becomeFirstResponder];
    [_textField addTarget:self action:@selector(resignFirstResponder)forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}

- (BOOL)resignFirstResponder
{
    [super resignFirstResponder];
    NSLog(@"text field return method called");
    [_textField resignFirstResponder];
    [[MSGRUsernameStore sharedStore] addUsername:[_textField text]];
    [[self navigationController] popViewControllerAnimated:true];
    return YES;
}


//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    [[MSGRUsernameStore sharedStore] addUsername:[textField text]];
//    [self dismissViewControllerAnimated:YES completion:nil];
//    return true;
//}

@end
