//
//  TFLineString.h
//  Terraformer
//
//  Created by Jen on 5/21/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFGeometry.h"

@interface TFLineString : TFGeometry

@property (copy, nonatomic) NSArray *points;

+ (instancetype)lineStringWithCoords:(NSArray *)coords;
- (instancetype)initWithCoords:(NSArray *)coords;
+ (instancetype)lineStringWithPoints:(NSArray *)points;
- (instancetype)initWithPoints:(NSArray *)points;

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (NSUInteger)count;

- (BOOL)isLinearRing;
@end
