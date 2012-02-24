//
//  RegionOptionsViewController.h
//  LocationTester
//
//  Created by Patrice Jaton on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Option.h"

@class RegionOptionsViewController;

@protocol RegionOptionsViewControllerDelegate <NSObject>

- (void)cancelRegionOptions:(RegionOptionsViewController *)controller;
- (void)defineRegionOptions:(RegionOptionsViewController *)controller radius:(Option *)radius accuracy:(Option *)accuracy;

@end

@interface RegionOptionsViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) IBOutlet UIPickerView *picker;
@property (nonatomic, weak) id <RegionOptionsViewControllerDelegate> delegate;
@property (nonatomic, strong) Option *radius;
@property (nonatomic, strong) Option *accuracy;

- (IBAction)applyChanges;
- (IBAction)cancelChanges;

@end
