//
//  ControlViewController.m
//  LocationTester
//
//  Created by Patrice Jaton on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ControlViewController.h"

@implementation ControlViewController {
    CLLocationManager * locationManager;    
}

@synthesize locationLabel, locationSwitch, regionLabel, regionSwitch, significantChangelabel, significantChangeSwitch;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    if (locationManager == nil) {
        locationManager = [[CLLocationManager alloc] init];
    }
    locationManager.delegate = self;
    
    
    if ([CLLocationManager locationServicesEnabled]) {
        
    } else {
        self.locationSwitch.hidden = true;
        self.significantChangeSwitch.hidden = true;
        self.regionSwitch.hidden = true;
        
    }
    
    
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    locationManager = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    DNSInfo(@"view did appear");
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}



#pragma mark - Location

- (IBAction)locationChanged {
    DNSInfo(@"%d", self.locationSwitch.isOn);
}

- (void)locationControls:(BOOL)enabled {
    if (enabled) {
        self.locationSwitch.hidden = NO;
        self.locationLabel.text = @"Monitoring";
    } else {
        self.locationSwitch.hidden = YES;
        self.locationLabel.text = @"Monitoring currently disabled";
    }
}


#pragma mark - Significant change

- (IBAction)significantChangeChanged {
}


- (void)significantChangeControls:(BOOL)enabled {
    if (enabled) {
        self.significantChangeSwitch.hidden = NO;
        self.significantChangelabel.text = @"Monitoring";
    } else {
        self.significantChangeSwitch.hidden = YES;
        self.significantChangelabel.text = @"Monitoring currently disabled";
    }
}


#pragma mark - Significant change

- (IBAction)regionChanged {
}

- (void)regionControls:(BOOL)enabled {
    if (enabled) {
        self.regionSwitch.hidden = NO;
        self.regionLabel.text = @"Monitoring";
    } else {
        self.regionSwitch.hidden = YES;
        self.regionLabel.text = @"Monitoring currently disabled";
    }
}



#pragma mark - Location Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {

    // the user has explicitly denied authorization for this application, 
    // or location services are disabled in Settings
    if (status == kCLAuthorizationStatusDenied) {
        [self locationControls:NO];
        [self significantChangeControls:NO];
        [self regionControls:NO];

        UIAlertView *debugAlert = [[UIAlertView alloc] initWithTitle:@"Services Disabled" message:@"This app. requires the location services to work properly. You can enable them in the system preferences." delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Preferences", nil];
        [debugAlert show];
    }
    
    // this application is not authorized to use location services due
    // to active restrictions on location services, the user cannot change
    // this status, and may not have personally denied authorization
    else if (status == kCLAuthorizationStatusRestricted) {
        [self locationControls:NO];
        [self significantChangeControls:NO];
        [self regionControls:NO];
        
        UIAlertView *debugAlert = [[UIAlertView alloc] initWithTitle:@"Services Restricted" message:@"The location services are currently restricted on this device! Please try again later." delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [debugAlert show];
        
    }
    
    // the user has either not made a choice with regards to this application
    // or (s)he has authorized it to user the location services
    else {
        [self locationControls:YES];
        [self significantChangeControls:[CLLocationManager significantLocationChangeMonitoringAvailable]];
        [self regionControls:[CLLocationManager regionMonitoringAvailable] && [CLLocationManager regionMonitoringEnabled]];
    }
}



#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Preferences"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs://"]];
    }
}



@end
