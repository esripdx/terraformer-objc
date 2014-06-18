//
// Created by Josh Yaganeh on 5/23/14.
// Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFGeometry.h"

@class TFPoint;

@interface TFMultiPoint : TFGeometry

@property (copy, nonatomic) NSArray *points;

+ (instancetype)multiPointWithPoints:(NSArray *)points;
- (instancetype)initWithPoints:(NSArray *)points;

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (NSUInteger)count;

@end