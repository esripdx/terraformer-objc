//
// Created by Josh Yaganeh on 5/21/14.
// Copyright (c) 2014 pdx.esri.com. All rights reserved.
//

#import "TFGeometry.h"

@interface TFFeature : TFPrimitive

@property (copy, nonatomic) NSString *identifier;
@property (strong, nonatomic) TFGeometry *geometry;
@property (copy, nonatomic) NSDictionary *properties;

- (instancetype)initWithGeometry:(TFGeometry *)geometry;
- (instancetype)initWithGeometry:(TFGeometry *)geometry properties:(NSDictionary *)properties;
- (instancetype)initWithGeometry:(TFGeometry *)rygeometry properties:(NSDictionary *)properties identifier:(NSString *)identifier;

+ (TFFeature *)featureWithGeometry:(TFGeometry *)geometry;
+ (TFFeature *)featureWithGeometry:(TFGeometry *)geometry properties:(NSDictionary *)properties;
+ (TFFeature *)featureWithGeometry:(TFGeometry *)geometry properties:(NSDictionary *)properties identifier:(NSString *)identifier;

@end