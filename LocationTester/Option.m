//
//  Option.m
//  LocationTester
//
//  Created by Patrice Jaton on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Option.h"

@implementation Option

@synthesize label = _label;
@synthesize value = _value;

- (Option *)initWithLabel:(NSString *)label andValue:(double)value
{
    self = [super init];
    if (self) {
        _label = label;
        _value = value;
    }
    return self;
}

+ (Option *)optionWithLabel:(NSString *)label andValue:(double)value {
    return [[Option alloc] initWithLabel:label andValue:value];
}


- (BOOL)isEqual:(id)object
{
    if (!object || ![object isKindOfClass:[self class]]) {
        return NO;
    }
        
    return [self isEqualToOption:object];
}

- (BOOL)isEqualToOption:(Option *)option
{
    if (option == self) {
        return YES;
    }
    if (!option) {
        return NO;
    }
    return [self.label isEqualToString:option.label] && (self.value == option.value);
}

- (NSUInteger)hash {
    return [self.label hash];
}

@end
