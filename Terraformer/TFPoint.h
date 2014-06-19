//
//  TFPoint.h
//  Terraformer
//
//  Created by Courtf on 5/21/14.
//  Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFGeometry.h"

@interface TFPoint : TFGeometry

@property (copy, nonatomic) NSArray *coordinates;
@property (readonly) double x;
@property (readonly) double y;
@property (readonly) double z;
@property (readonly) double m;
@property (readonly) double latitude;
@property (readonly) double longitude;

+ (instancetype)pointWithX:(double)x y:(double)y;
- (instancetype)initWithX:(double)x y:(double)y;
+ (instancetype)pointWithX:(double)x y:(double)y z:(double)z;
- (instancetype)initWithX:(double)x y:(double)y z:(double)z;
+ (instancetype)pointWithCoordinates:(NSArray *)coordinates;
- (instancetype)initWithCoordinates:(NSArray *)coordinates;
+ (instancetype)pointWithLatitude:(double)lat longitude:(double)lng;
- (instancetype)initWithLatitude:(double)lat longitude:(double)lng;

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (NSUInteger)count;

@end
