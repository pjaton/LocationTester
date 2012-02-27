//
//  Option.h
//  LocationTester
//
//  Created by Patrice Jaton on 2/21/12.
//  Copyright (c) 2012 Patrice Jaton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Option : NSObject

+ (Option *)optionWithLabel:(NSString *)label andValue:(double)value;
- (Option *)initWithLabel:(NSString *)label andValue:(double)value;
- (BOOL)isEqualToOption:(Option *)option;

@property (nonatomic, strong, readonly) NSString *label;
@property (readonly) double value;

@end
