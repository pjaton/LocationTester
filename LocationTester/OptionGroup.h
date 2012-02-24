//
//  OptionGroup.h
//  LocationTester
//
//  Created by Patrice Jaton on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Option.h"

@interface OptionGroup : NSObject

+ (OptionGroup *)optionGroupWithOption:(NSArray *)options andSelected:(NSInteger) index;
- (OptionGroup *)initWithOptions:(NSArray *)options andSelected:(NSInteger) index;

@property (nonatomic, strong) NSArray *options;
@property (nonatomic) NSInteger selected;

- (Option *) selectedOption;
- (NSInteger) size;

@end
