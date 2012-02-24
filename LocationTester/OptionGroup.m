//
//  OptionGroup.m
//  LocationTester
//
//  Created by Patrice Jaton on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OptionGroup.h"

@implementation OptionGroup

@synthesize options = _options;
@synthesize selected = _selected;

- (OptionGroup *)initWithOptions:(NSArray *)options andSelected:(NSInteger) index
{
    self = [super init];
    if (self) {
        _options = options;
        _selected = index;
    }
    return self;
}

+ (OptionGroup *)optionGroupWithOption:(NSArray *)options andSelected:(NSInteger) index
{
    return [[OptionGroup alloc] initWithOptions:options andSelected:index];
}

- (Option *) selectedOption
{
    return [self.options objectAtIndex:self.selected];
}

- (NSInteger) size
{
    return [self.options count];
}

@end
