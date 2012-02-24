//
//  RegionOptionsViewController.m
//  LocationTester
//
//  Created by Patrice Jaton on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RegionOptionsViewController.h"
#import <CoreLocation/CoreLocation.h>

@implementation RegionOptionsViewController {
    NSArray *radiuses;
    NSArray *accuracies;
}

@synthesize picker = _picker;
@synthesize delegate = _delegate;
@synthesize radius = _radius;
@synthesize accuracy = _accuracy;


- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
        radiuses = [[NSArray alloc] initWithObjects:
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
                    nil];
        accuracies = [[NSArray alloc] initWithObjects:
                      [Option optionWithLabel:@"Navigation" andValue:kCLLocationAccuracyBestForNavigation],
                      [Option optionWithLabel:@"Best" andValue:kCLLocationAccuracyBest],
                      [Option optionWithLabel:@"~10 meters" andValue:kCLLocationAccuracyNearestTenMeters],
                      [Option optionWithLabel:@"~100 meters" andValue:kCLLocationAccuracyHundredMeters],
                      [Option optionWithLabel:@"~1km" andValue:kCLLocationAccuracyKilometer],
                      [Option optionWithLabel:@"~3km" andValue:kCLLocationAccuracyThreeKilometers],
                      nil];
	}
	return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self.picker selectRow:[radiuses indexOfObject:self.radius] inComponent:0 animated:NO];
    [self.picker selectRow:[accuracies indexOfObject:self.accuracy] inComponent:1 animated:NO];
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    radiuses = nil;
    accuracies = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark - Picker View Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [radiuses count];
    }
    return [accuracies count];
}



#pragma mark - Picker View Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [[radiuses objectAtIndex:row] label];
    }
    return [[accuracies objectAtIndex:row] label];
}



#pragma mark - Picker View Delegate

- (IBAction)applyChanges 
{
    self.radius = [radiuses objectAtIndex: [self.picker selectedRowInComponent:0]];
    self.accuracy = [accuracies objectAtIndex: [self.picker selectedRowInComponent:1]];
    [self.delegate defineRegionOptions:self radius:self.radius accuracy:self.accuracy];
}

- (IBAction)cancelChanges 
{
    [self.delegate cancelRegionOptions:self];
}
@end
