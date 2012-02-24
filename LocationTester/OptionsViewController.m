//
//  RegionOptionsViewController.m
//  LocationTester
//
//  Created by Patrice Jaton on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OptionsViewController.h"
#import <CoreLocation/CoreLocation.h>

@implementation OptionsViewController

@synthesize picker = _picker;
@synthesize delegate = _delegate;
@synthesize control = _control;
@synthesize firstOptions = _firstOptions;
@synthesize secondOptions = _secondOptions;


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self.picker selectRow:self.firstOptions.selected inComponent:0 animated:NO];
    [self.picker selectRow:self.secondOptions.selected inComponent:1 animated:NO];
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Picker View Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [self.firstOptions size];
    }
    return [self.secondOptions size];
}



#pragma mark - Picker View Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [[self.firstOptions.options objectAtIndex:row] label];
    }
    return [[self.secondOptions.options objectAtIndex:row] label];
}



#pragma mark - Picker View Delegate

- (IBAction)apply 
{
    self.firstOptions.selected = [self.picker selectedRowInComponent:0];
    self.secondOptions.selected = [self.picker selectedRowInComponent:1];
    [self.delegate applyOptions:self];
}

@end
