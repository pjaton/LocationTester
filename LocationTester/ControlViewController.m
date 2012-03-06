//
//  ControlViewController.m
//  LocationTester
//
//  Created by Patrice Jaton on 2/19/12.
//  Copyright (c) 2012 Patrice Jaton. All rights reserved.
//

#import "ControlViewController.h"

@implementation ControlViewController {
    OptionGroup * locationDistanceOptions;
    OptionGroup * locationAccuracyOptions;
    OptionGroup * regionRadiusOptions;
    OptionGroup * regionAccuracyOptions;
}

@synthesize notificationCell = _notificationCell;
@synthesize locationCell = _locationCell;
@synthesize locationOptionsCell = _locationOptionsCell;
@synthesize significantCell = _significantCell;
@synthesize regionCell = _regionCell;
@synthesize regionOptionsCell = _regionOptionsCell;
@synthesize locationTracker = _locationTracker;
@synthesize significantChangeTracker = _significantChangeTracker;
@synthesize regionTracker = _regionTracker;

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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        switch (indexPath.section) {
            case 0:
                // notification
                [self.significantChangeTracker setSendNotification:YES];
                [self.regionTracker setSendNotification:YES];
                break;

            case 1:
                // location monitoring
                [self.locationTracker startMonitoring:locationDistanceOptions.selectedOption accuracy:locationAccuracyOptions.selectedOption];
                break;

            case 2:
                
                // significant change monitoring
                [self.significantChangeTracker startMonitoring];
                break;
                
            case 3:
                // region monitoring
                [self.regionTracker startMonitoring:regionRadiusOptions.selectedOption accuracy:regionAccuracyOptions.selectedOption];
                break;
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        switch (indexPath.section) {
            case 0:
                // notification
                [self.significantChangeTracker setSendNotification:NO];
                [self.regionTracker setSendNotification:NO];
                break;
                
            case 1:
                // location monitoring
                [self.locationTracker stopMonitoring];
                break;
                
            case 2:
                // significant change monitoring
                [self.significantChangeTracker stopMonitoring];
                break;
                
            case 3:
                // region monitoring
                [self.regionTracker stopMonitoring];
                break;
        }
    }
    
}


#pragma mark - Location controls

- (void)locationControls:(BOOL)enabled
{
    if (enabled) {
        [self.locationCell setUserInteractionEnabled:YES];
        [self.locationCell.textLabel setText:@"Monitor (foreground only)"];
    } else {
        [self.locationTracker stopMonitoring];
        [self.locationCell setSelected:NO];
        [self.locationCell setUserInteractionEnabled:NO];
        [self.locationCell.textLabel setText:@"Monitoring disabled"];
    }
}

- (void)applyLocationOptions
{
    [self.locationOptionsCell.textLabel setText:[NSString stringWithFormat:@"Filter %@ (%@)", 
                                        [[locationDistanceOptions selectedOption] label], 
                                        [[locationAccuracyOptions selectedOption] label]]];
    if (self.locationCell.isSelected) {
        [self.locationTracker stopMonitoring];
        [self.locationTracker startMonitoring:locationDistanceOptions.selectedOption 
                                     accuracy:locationAccuracyOptions.selectedOption];
    }
}


#pragma mark - Significant change controls

- (void)significantChangeControls:(BOOL)enabled
{
    if (enabled) {
        [self.significantCell setUserInteractionEnabled:YES];
        [self.significantCell.textLabel setText:@"Monitor"];
    } else {
        [self.significantChangeTracker stopMonitoring];
        [self.significantCell setSelected:NO];
        [self.significantCell setUserInteractionEnabled:NO];
        [self.significantCell.textLabel setText:@"Monitoring disabled"];
    }
}


#pragma mark - Region controls

- (void)regionControls:(BOOL)enabled
{
    if (enabled) {
        [self.regionCell setUserInteractionEnabled:YES];
        [self.regionCell.textLabel setText:@"Monitor "];
    } else {
        [self.regionTracker stopMonitoring];
        [self.regionCell setSelected:NO];
        [self.regionCell setUserInteractionEnabled:NO];
        [self.regionCell.textLabel setText:@"Monitoring disabled"];
    }
}

- (void)applyRegionOptions
{
    [self.regionOptionsCell.textLabel setText:[NSString stringWithFormat:@"Radius of %@ (%@)", 
                                      [[regionRadiusOptions selectedOption] label], 
                                      [[regionAccuracyOptions selectedOption] label]]];
    if (self.regionCell.isSelected) {
        [self.regionTracker stopMonitoring];
        [self.regionTracker startMonitoring:regionRadiusOptions.selectedOption 
                                   accuracy:regionAccuracyOptions.selectedOption];
    }
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
    [self becomeFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}





#pragma mark - Location Tracker delegate

- (void)trackerAuthorizationChanged:(BOOL)authorized;
{
    if (authorized) {
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
