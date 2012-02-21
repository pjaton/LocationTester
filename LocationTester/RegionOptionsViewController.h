//
//  RegionOptionsViewController.h
//  LocationTester
//
//  Created by Patrice Jaton on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegionOptionsViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource> {
    
    IBOutlet UIPickerView *picker;
}

@property (nonatomic, strong) NSArray *distances;
@property (nonatomic, strong) NSArray *precisions;

@end
