//
//  ControlViewController.m
//  LocationTester
//
//  Created by Patrice Jaton on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ControlViewController.h"

@implementation ControlViewController {
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
@synthesize tracker = _tracker;

- (void)setTracker:(LocationTracker *)tracker
{
    _tracker = tracker;
    [_tracker setDelegate:self];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
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
        [ctrl setDelegate:self];
        [ctrl setControl:segue.identifier];
        [ctrl setMessage:@"Define the location filter & accuracy"];
        [ctrl setFirstOptions:locationDistanceOptions];
        [ctrl setSecondOptions:locationAccuracyOptions];
	} else if ([segue.identifier isEqualToString:@"RegionOptions"]) {
        OptionsViewController *ctrl = segue.destinationViewController;
        [ctrl setDelegate:self];
        [ctrl setControl:segue.identifier];
        [ctrl setMessage:@"Define the region radius & accuracy"];
        [ctrl setFirstOptions:regionRadiusOptions];
        [ctrl setSecondOptions:regionAccuracyOptions];
    }
}


#pragma mark - Location controls

- (IBAction)locationSwitched
{
    if (self.locationSwitch.isOn) {
        [self.tracker startMonitoringLocation:locationDistanceOptions.selectedOption.value 
                                     accuracy:locationAccuracyOptions.selectedOption.value];
    } else {
        [self.tracker stopMonitoringLocation];
    }
}

- (void)locationControls:(BOOL)enabled
{
    if (enabled) {
        [self.locationSwitch setHidden:NO];
        [self.locationLabel setText:@"Monitoring"];
    } else {
        [self.locationSwitch setHidden:YES];
        [self.locationLabel setText:@"Monitoring currently disabled"];
    }
}

- (void)applyLocationOptions
{
    [self.locationOptionsLabel setText:[NSString stringWithFormat:@"Filter %@ (%@)", 
                                        [[locationDistanceOptions selectedOption] label], 
                                        [[locationAccuracyOptions selectedOption] label]]];
    if (self.locationSwitch.isOn) {
        [self.tracker stopMonitoringLocation];
        [self.tracker startMonitoringLocation:locationDistanceOptions.selectedOption.value 
                                     accuracy:locationAccuracyOptions.selectedOption.value];
    }
}


#pragma mark - Significant change controls

- (IBAction)significantChangeSwitched
{
}


- (void)significantChangeControls:(BOOL)enabled
{
    if (enabled) {
        [self.significantChangeSwitch setHidden:NO];
        [self.significantChangelabel setText:@"Monitoring"];
    } else {
        [self.significantChangeSwitch setHidden:YES];
        [self.significantChangelabel setText:@"Monitoring currently disabled"];
    }
}


#pragma mark - Region controls

- (IBAction)regionSwitched
{
}

- (void)regionControls:(BOOL)enabled
{
    if (enabled) {
        [self.regionSwitch setHidden:NO];
        [self.regionLabel setText:@"Monitoring"];
    } else {
        [self.regionSwitch setHidden:YES];
        [self.regionLabel setText:@"Monitoring currently disabled"];
    }
}

- (void)applyRegionOptions
{
    [self.regionOptionsLabel setText:[NSString stringWithFormat:@"Radius of %@ (%@)", 
                                      [[regionRadiusOptions selectedOption] label], 
                                      [[regionAccuracyOptions selectedOption] label]]];
}


#pragma mark - Region Options controller delegate

- (void)optionsController:(OptionsViewController *)controller updatedWithChanges:(BOOL)changed
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





#pragma mark - Location Tracker delegate

- (void)locationtracker:(LocationTracker *)tracker authorizationChanged:(BOOL)authorize
{
    if (authorize) {
        [self locationControls:YES];
        [self significantChangeControls:[CLLocationManager significantLocationChangeMonitoringAvailable]];
        [self regionControls:[CLLocationManager regionMonitoringAvailable] && [CLLocationManager regionMonitoringEnabled]];
    } else {
        [self locationControls:NO];
        [self significantChangeControls:NO];
        [self regionControls:NO];
    }
}

@end
