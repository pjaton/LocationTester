//
//  ControlViewController.h
//  LocationTester
//
//  Created by Patrice Jaton on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "OptionsViewController.h"
#import "LocationTracker.h"
#import "SignificantChangeTracker.h"
#import "RegionTracker.h"

@interface ControlViewController : UITableViewController<TrackerAvailabilityDelegate, OptionsViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UISwitch *locationSwitch;
@property (nonatomic, strong) IBOutlet UILabel  *locationOptionsLabel;
@property (nonatomic, strong) IBOutlet UILabel  *locationLabel;
@property (nonatomic, strong) IBOutlet UISwitch *regionSwitch;
@property (nonatomic, strong) IBOutlet UILabel  *regionLabel;
@property (nonatomic, strong) IBOutlet UILabel  *regionOptionsLabel;
@property (nonatomic, strong) IBOutlet UISwitch *significantChangeSwitch;
@property (nonatomic, strong) IBOutlet UILabel  *significantChangelabel;

@property (nonatomic, strong) LocationTracker *locationTracker;
@property (nonatomic, strong) SignificantChangeTracker *significantChangeTracker;
@property (nonatomic, strong) RegionTracker *regionTracker;

- (IBAction)locationSwitched;
- (IBAction)significantChangeSwitched;
- (IBAction)regionSwitched;

- (void)applyRegionOptions;
- (void)applyLocationOptions;

@end
