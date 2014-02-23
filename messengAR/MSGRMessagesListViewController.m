//
//  MSGRMessagesListViewController.m
//  messengAR
//
//  Created by   on 2/22/14.
//  Copyright (c) 2014 strangerware. All rights reserved.
//

#import "MSGRMessagesListViewController.h"
#import "MSGRImageViewController.h"
#import "MSGRMessageStore.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>
#import "MSGRMessage.h"
#import <AFNetworking/AFNetworking.h>

#define TOLERANCE       0.35
#define PITCH_TOLERANCE 6

@interface MSGRMessagesListViewController ()

@end

@implementation MSGRMessagesListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _locationManager = [CLLocationManager new];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        _motionManager = [[CMMotionManager alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationItem] setTitle:@"Messages"];
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(sendPicture)]];
    [[self navigationItem] setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Log out" style:UIBarButtonItemStyleBordered target:nil action:nil]]; // should work (?) but doesn't :(
    CGRect frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 44, [[UIScreen mainScreen] bounds].size.width, 44);
    _toolbar = [[UIToolbar alloc] initWithFrame:frame];
    [_toolbar sizeToFit];
    [[[self navigationController] view] addSubview:_toolbar];
//    [[self view] addSubview:_toolbar];
    [_toolbar setItems:@[[[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(refresh)]]];
}

- (void)refresh
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://example.com/resources.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *dictionary = responseObject;
        MSGRMessage *message = [[MSGRMessage alloc] init];
        [message setRoll:[[dictionary valueForKey:@"message[roll]"] doubleValue]];
        [message setYaw:[[dictionary valueForKey:@"message[yaw]"] doubleValue]];
        [message setPitch:[[dictionary valueForKey:@"message[pitch]"] doubleValue]];
        [message setHeading:[[dictionary valueForKey:@"message[heading]"] doubleValue]];
        [message setPointX:[[dictionary valueForKey:@"message[pointX]"] doubleValue]];
        [message setPointY:[[dictionary valueForKey:@"message[pointY]"] doubleValue]];
        [message setLocation:[dictionary valueForKey:@"message[location]"]];
        [message setMessageText:[dictionary valueForKey:@"message[messageText]"]];
        [message setHintText:[dictionary valueForKey:@"message[hintText]"]];
        [message setSender:[dictionary valueForKey:@"message[sender]"]];
        [[MSGRMessageStore sharedStore] addMessage:message];
        [[self tableView] reloadData];
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"Error: %@", error);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self tableView] reloadData];
}

- (void)sendPicture
{
    UINavigationController *navControl = [[UINavigationController alloc] init];
    MSGRImageViewController *imageControl = [[MSGRImageViewController alloc] init];
    [navControl setNavigationBarHidden:true];
    [imageControl setShouldPresentCamera:true];
    [navControl setViewControllers:@[imageControl]];
    [self presentViewController:navControl animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[MSGRMessageStore sharedStore] allMessages] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MSGRMessage *message = [[[MSGRMessageStore sharedStore] allMessages] objectAtIndex:[[[MSGRMessageStore sharedStore] allMessages] count] - (1 + [indexPath row])];
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@", [message sender]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [_locationManager startUpdatingLocation];
    [_locationManager startUpdatingHeading];
    [_motionManager startGyroUpdates];
    [_motionManager startDeviceMotionUpdates];
    
    _message = [[[MSGRMessageStore sharedStore] allMessages] objectAtIndex:[indexPath row]];
    _imagePicker = [[UIImagePickerController alloc] init];
    [_imagePicker setDelegate:self];
    [_imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [_imagePicker setMediaTypes:@[(NSString *) kUTTypeImage]];
    [_imagePicker setAllowsEditing:NO];
    // [imagePicker setShowsCameraControls:false];
    // [imagePicker setNavigationBarHidden:true];
    _timer = [NSTimer scheduledTimerWithTimeInterval:.35 target:self selector:@selector(checkAttitude:) userInfo:nil repeats:true];
    [self presentViewController:_imagePicker animated:YES completion:nil];
}

- (void)checkAttitude:(NSTimer *)timer
{
    CLLocation *location = [_locationManager location];
    CLHeading *heading = [_locationManager heading];
    CLLocationDirection trueHeading = [heading trueHeading];
    CMDeviceMotion *deviceMotion = [_motionManager deviceMotion];
    CMAttitude *attitude = [deviceMotion attitude];
    
    NSLog(@"%f \n %f \n %f \n %f \n %f \n %f \n %f \n %f \n %f \n %f \n %f \n %f", location.coordinate.latitude, _message.location.coordinate.latitude,location.coordinate.longitude, _message.location.coordinate.longitude, trueHeading, [_message heading], [attitude yaw], [_message yaw], [attitude pitch], [_message pitch], [attitude roll], [_message roll]);
    
    if (fabs(location.coordinate.latitude - _message.location.coordinate.latitude) < fabs(TOLERANCE * _message.location.coordinate.latitude) && fabs(location.coordinate.longitude - _message.location.coordinate.longitude) < fabs(TOLERANCE * _message.location.coordinate.longitude) && fabs(trueHeading - [_message heading]) < fabs(TOLERANCE * [_message heading] && fabs([attitude pitch] - [_message pitch]) < fabs(PITCH_TOLERANCE * [_message pitch])))
        
        // && fabs([attitude yaw] - [_message yaw]) < fabs(TOLERANCE * [_message yaw]) && fabs([attitude pitch] - [_message pitch]) < fabs(TOLERANCE * [_message pitch]) && fabs([attitude roll] - [_message roll]) < fabs(TOLERANCE * [_message roll])
        
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 300, 300)];
        [label setFont:[UIFont fontWithName:@"Helvetica" size:28.0]];
        [label setText:[_message messageText]];
        [_imagePicker setCameraOverlayView:label];
    }
    else
    {
        [_imagePicker setCameraOverlayView:Nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_timer invalidate];
    _timer = nil;
    [self dismissViewControllerAnimated:true completion:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
