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
    OptionGroup * locationDistanceOptions;
    OptionGroup * locationAccuracyOptions;
    OptionGroup * regionRadiusOptions;
    OptionGroup * regionAccuracyOptions;
}

@synthesize locationSwitch = _locationSwitch;
@synthesize locationOptionsLabel = _locationOptionsLabel;
@synthesize locationLabel = _locationLabel;
@synthesize regionSwitch = _regionSwitch;
@synthesize regionLabel = _regionLabel;
@synthesize regionOptionsLabel = _regionOptionsLabel;
@synthesize significantChangeSwitch = _significantChangeSwitch;
@synthesize significantChangelabel = _significantChangelabel;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    if (locationManager == nil) {
        locationManager = [[CLLocationManager alloc] init];
    }
    locationManager.delegate = self;
    
    if (locationDistanceOptions == nil) {
        locationDistanceOptions = [OptionGroup optionGroupWithOption:
                                   [[NSArray alloc] initWithObjects:
                                    [Option optionWithLabel:@"None" andValue:kCLDistanceFilterNone],
                                    [Option optionWithLabel:@"5 meters" andValue:5],
                                    [Option optionWithLabel:@"10 meters" andValue:10],
                                    [Option optionWithLabel:@"15 meters" andValue:15],
                                    [Option optionWithLabel:@"20 meters" andValue:20],
                                    [Option optionWithLabel:@"25 meters" andValue:25],
                                    [Option optionWithLabel:@"50 meters" andValue:50],
                                    [Option optionWithLabel:@"100 meters" andValue:100],
                                    [Option optionWithLabel:@"250 meters" andValue:250],
                                    [Option optionWithLabel:@"500 meters" andValue:500],
                                    [Option optionWithLabel:@"1km" andValue:1000],
                                    [Option optionWithLabel:@"5km" andValue:5000],
                                    nil] andSelected:1];
    }
    if (locationAccuracyOptions == nil) {
        locationAccuracyOptions = [OptionGroup optionGroupWithOption:
                                   [[NSArray alloc] initWithObjects:
                                    [Option optionWithLabel:@"Navigation" andValue:kCLLocationAccuracyBestForNavigation],
                                    [Option optionWithLabel:@"Best" andValue:kCLLocationAccuracyBest],
                                    [Option optionWithLabel:@"~10 meters" andValue:kCLLocationAccuracyNearestTenMeters],
                                    [Option optionWithLabel:@"~100 meters" andValue:kCLLocationAccuracyHundredMeters],
                                    [Option optionWithLabel:@"~1km" andValue:kCLLocationAccuracyKilometer],
                                    [Option optionWithLabel:@"~3km" andValue:kCLLocationAccuracyThreeKilometers],
                                    nil] andSelected:1];
    }
    if (regionRadiusOptions == nil) {
        regionRadiusOptions = [OptionGroup optionGroupWithOption:
                               [[NSArray alloc] initWithObjects:
                                [Option optionWithLabel:@"10 meters" andValue:10],
                                [Option optionWithLabel:@"15 meters" andValue:15],
                                [Option optionWithLabel:@"20 meters" andValue:20],
                                [Option optionWithLabel:@"25 meters" andValue:25],
                                [Option optionWithLabel:@"50 meters" andValue:50],
                                [Option optionWithLabel:@"100 meters" andValue:100],
                                [Option optionWithLabel:@"250 meters" andValue:250],
                                [Option optionWithLabel:@"500 meters" andValue:500],
                                [Option optionWithLabel:@"1km" andValue:1000],
                                [Option optionWithLabel:@"5km" andValue:5000],
                                nil] andSelected:2];
    }
    if (regionAccuracyOptions == nil) {
        regionAccuracyOptions = [OptionGroup optionGroupWithOption:locationAccuracyOptions.options andSelected:1];
    }
    [self applyRegionOptions];
    [self applyLocationOptions];
    
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    locationManager = nil;
    locationDistanceOptions = nil;
    locationAccuracyOptions = nil;
    regionRadiusOptions = nil;
    regionAccuracyOptions = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"LocationsOptions"]) {
        OptionsViewController *ctrl = segue.destinationViewController;
        ctrl.delegate = self;
        ctrl.control = segue.identifier;
        ctrl.firstOptions = locationDistanceOptions;
        ctrl.secondOptions = locationAccuracyOptions;
	} else if ([segue.identifier isEqualToString:@"RegionOptions"]) {
        OptionsViewController *ctrl = segue.destinationViewController;
        ctrl.delegate = self;
        ctrl.control = segue.identifier;
        ctrl.firstOptions = regionRadiusOptions;
        ctrl.secondOptions = regionAccuracyOptions;
    }
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

- (void)applyLocationOptions
{
    self.locationOptionsLabel.text = [NSString stringWithFormat:@"Filter %@ (%@)", 
                                      [[locationDistanceOptions selectedOption] label], 
                                      [[locationAccuracyOptions selectedOption] label]];
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

- (void)applyRegionOptions
{
    self.regionOptionsLabel.text = [NSString stringWithFormat:@"Radius of %@ (%@)", 
                                    [[regionRadiusOptions selectedOption] label], 
                                    [[regionAccuracyOptions selectedOption] label]];
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

- (void)updateOption:(OptionsViewController *)controller withChanges:(BOOL)changed;
{
    if (changed) {
        if ([controller.control isEqualToString:@"LocationsOptions"]) {
            [self applyLocationOptions];
        } else if ([controller.control isEqualToString:@"RegionOptions"]) {
            [self applyRegionOptions];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
