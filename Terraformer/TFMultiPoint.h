//
// Created by Josh Yaganeh on 5/23/14.
// Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFGeometry.h"

@class TFPoint;

@interface TFMultiPoint : TFGeometry

+ (instancetype)multiPointWithPoints:(NSArray *)points;
- (instancetype)initWithPoints:(NSArray *)points;

- (void)addPointWithX:(double)x y:(double)y;
- (void)removePointAtIndex:(NSUInteger)idx;

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;
- (NSUInteger)count;

@end