//
//  OptionsViewController.h
//  LocationTester
//
//  Created by Patrice Jaton on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionGroup.h"

@class OptionsViewController;

@protocol OptionsViewControllerDelegate <NSObject>

- (void)updateOption:(OptionsViewController *)controller withChanges:(BOOL)changed;

@end

@interface OptionsViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) IBOutlet UIPickerView *picker;
@property (nonatomic, strong) NSString *control;
@property (nonatomic, strong) OptionGroup *firstOptions;
@property (nonatomic, strong) OptionGroup *secondOptions;

@property (nonatomic, weak) id <OptionsViewControllerDelegate> delegate;

- (IBAction)apply;

@end