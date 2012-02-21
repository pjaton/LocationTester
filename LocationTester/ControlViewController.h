//
//  ControlViewController.h
//  LocationTester
//
//  Created by Patrice Jaton on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ControlViewController : UITableViewController<CLLocationManagerDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel  *locationLabel;
@property (nonatomic, weak) IBOutlet UISwitch *locationSwitch;
@property (nonatomic, weak) IBOutlet UILabel  *regionLabel;
@property (nonatomic, weak) IBOutlet UISwitch *regionSwitch;
@property (nonatomic, weak) IBOutlet UILabel  *significantChangelabel;
@property (nonatomic, weak) IBOutlet UISwitch *significantChangeSwitch;

- (IBAction)locationChanged;
- (IBAction)significantChangeChanged;
- (IBAction)regionChanged;

@end
