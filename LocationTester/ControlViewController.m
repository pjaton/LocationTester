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
    Option * regionRadius;
    Option * regionAccuracy;

}

@synthesize locationSwitch;
@synthesize locationLabel;
@synthesize regionSwitch;
@synthesize regionLabel;
@synthesize regionOptionsLabel;
@synthesize significantChangeSwitch;
@synthesize significantChangelabel;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    if (locationManager == nil) {
        locationManager = [[CLLocationManager alloc] init];
    }
    locationManager.delegate = self;
    
    if (regionRadius == nil) {
        regionRadius = [Option optionWithLabel:@"25 meters" andValue:25];
    }
    if (regionAccuracy == nil) {
        regionAccuracy = [Option optionWithLabel:@"~10 meters" andValue:kCLLocationAccuracyNearestTenMeters];
    }
    [self refreshRegionOptionsLabel];
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    locationManager = nil;
    regionRadius = nil;
    regionAccuracy = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"RegionOptions"])
	{
		RegionOptionsViewController *regionOptionsViewController = segue.destinationViewController;
		regionOptionsViewController.delegate = self;
        regionOptionsViewController.radius = regionRadius;
        regionOptionsViewController.accuracy = regionAccuracy;
	}
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



#pragma mark - Location controls

- (IBAction)locationSwitched
{
    DNSInfo(@"%d", self.locationSwitch.isOn);
}

- (void)locationControls:(BOOL)enabled
{
    if (enabled) {
        self.locationSwitch.hidden = NO;
        self.locationLabel.text = @"Monitoring";
    } else {
        self.locationSwitch.hidden = YES;
        self.locationLabel.text = @"Monitoring currently disabled";
    }
}


#pragma mark - Significant change controls

- (IBAction)significantChangeSwitched
{
}


- (void)significantChangeControls:(BOOL)enabled
{
    if (enabled) {
        self.significantChangeSwitch.hidden = NO;
        self.significantChangelabel.text = @"Monitoring";
    } else {
        self.significantChangeSwitch.hidden = YES;
        self.significantChangelabel.text = @"Monitoring currently disabled";
    }
}


#pragma mark - Region controls

- (IBAction)regionSwitched
{
}

- (void)regionControls:(BOOL)enabled
{
    if (enabled) {
        self.regionSwitch.hidden = NO;
        self.regionLabel.text = @"Monitoring";
    } else {
        self.regionSwitch.hidden = YES;
        self.regionLabel.text = @"Monitoring currently disabled";
    }
}

- (void)refreshRegionOptionsLabel
{
    self.regionOptionsLabel.text = [NSString stringWithFormat:@"Radius of %@ (%@)", regionRadius.label, regionAccuracy.label];
}



#pragma mark - Location Manager delegate


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    DNSInfo(@"%@", [newLocation description]);
}



- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{

    // the user has explicitly denied authorization for this application, 
    // or location services are disabled in Settings
    if (status == kCLAuthorizationStatusDenied) {
        [self locationControls:NO];
        [self significantChangeControls:NO];
        [self regionControls:NO];

        UIAlertView *debugAlert = [[UIAlertView alloc] initWithTitle:@"This App. Requires the Location Services to Determine Your Location" message:nil delegate:self cancelButtonTitle:@"Settings" otherButtonTitles:@"Cancel", nil];
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
        [self regionControls:[CLLocationManager regionMonitoringAvailable] && [CLLocationManager regionMonitoringEnabled] && (locationManager.maximumRegionMonitoringDistance > 0)];
    }
}



#pragma mark - Alert View delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Settings"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs://"]];
    }
}



#pragma mark - Region Options controller delegate

- (void)cancelRegionOptions:(RegionOptionsViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)defineRegionOptions:(RegionOptionsViewController *)controller radius:(Option *)radius accuracy:(Option *)accuracy
{
    regionRadius = radius;
    regionAccuracy = accuracy;
    [self refreshRegionOptionsLabel];
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
